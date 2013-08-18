class Modals extends Backbone.View
  
  events: 
  	"click #lean_overlay": "hide_all"
  	"click #login_link": "pop_login"
  	"click #signup_link": "pop_signup"

  	"click #login-modal #submit": "login_submit"
  	"click #signup-modal #submit": "signup_submit"
  	"click #search-naming #submit": "save_search_submit"
  	"click #chord-naming #submit": "save_chord_submit"
  	"click #edit-chord-wrapper #submit": "save_edited_chord"



  initialize: ->
    _.bindAll(this, 'render')
    @render()

  login_template: window.HAML['login_template']
  signup_template: window.HAML['signup_template']
  search_naming_template: window.HAML['search_naming_template']
  chord_naming_template: window.HAML['chord_naming_template']

  render: ->
  	@$el.html("<div id='lean_overlay'></div>")
  	@$el.append(@login_template)
  	@$el.append(@signup_template)
  	@$el.append(@search_naming_template)
  	@$el.append(@chord_naming_template)
  	@$el.append("<div id='edit-chord-wrapper' class='pop_up'></div>")
  	setTimeout @hide_all, 30
  	@$el.attr('id', 'modals')
  	this

  pop_login: ->
  	@hide_all()
  	$('#login-modal, #lean_overlay').show()

  pop_signup: ->
  	@hide_all()
  	$('#signup-modal, #lean_overlay').show()

  pop_search_naming: ->
    @hide_all()
    $('#search-naming, #lean_overlay').show()

  pop_chord_naming: (chord) ->
  	@hide_all()
  	@chord_to_save = new UserChord chord
  	$('#chord-naming, #lean_overlay').show()  

  hide_all: ->
  	$('#login-modal, #signup-modal, #search-naming, #chord-naming, #lean_overlay, #error, #edit-chord-wrapper').hide()

  show_error: ->
  	@$el.find('#error').show()
  	cb= =>
  	  @$el.find('#error').hide()
  	setTimeout cb, 2000  


  login_submit: ->
  	email= $('#login-modal input#email').val()
  	pass= $('#login-modal input#password').val()
  	$.get "mongo_users/login/#{email}/#{pass}", (user) =>
  	  if user
  	  	@hide_all()
  	  	router.login(user)
  	  else 
  	    @show_error()
  	 
  signup_submit: ->	
  	email= $('#signup-modal input#email').val()
  	pass= $('#signup-modal input#password').val()
  	pass_conf= $('#signup-modal input#confirm-password').val()
  	$.get "mongo_users/signup/#{email}/#{pass}/#{pass_conf}", (user) =>
  	  if user
        console.log user
        @hide_all()
        router.login(user)
  	  else 
  	    @show_error()

  	
  save_search_submit: ->
  	console.log "search sub"
  	@hide_all()
  	n = $('#search-naming #user-fav-name').val()
  	$.get "/save_search/#{n}", (ss) ->
  	  router.app.usc.add ss 

  save_chord_submit: ->
  	@hide_all()
  	@chord_to_save.set
  	  name: $('#chord-naming #user-fav-name').val() 
  	delete @chord_to_save.id
  	@chord_to_save.save()

  	router.app.userChordLibrary.add @chord_to_save
  	@chord_to_save = null

  save_edited_chord: ->
  	@hide_all()
  	tab = JSON.stringify(@current_edited_chord.chord)
  	pitches = JSON.stringify(@current_edited_chord.pitches)
  	name = $('input#chord-name').val()

  	# to see if it is from search result or saved chords :( ugly...
  	c = @current_edited_chord.view.$el.find('.saved_chord_tab')
  	if c.length == 0
  	  $.get "/save_edited_chord/#{pitches}/#{tab}/#{name}", (chord) ->
  	    router.app.userChordLibrary.add chord
  	else
  	  id= @current_edited_chord._id
  	  $.get "/update_edited_chord/#{id}/#{pitches}/#{tab}/#{name}", (chord) =>
  	    @current_edited_chord.view.model.fetch
  	      success: @current_edited_chord.view.render