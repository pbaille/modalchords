class UserChord extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'user_chords'
  urlRoot: "/user_chords"

class UserChordView extends Backbone.View 

  className: "chord-view"

  initialize: ->
    _.bindAll(this, 'render')

  events: 
    "click i.icon-wrench": "pop_edit_chord"
    "click i.icon-cancel-2": "delete_chord"
    "click i.icon-heart-1": "save_chord"


  template: window.HAML['tab_template']
  edit_chord_template: window.HAML['edit_chord_template']

  render: ->
  	@$el.html(@template(@model.toJSON()))
  	@init_tab()
  	this

  init_tab: ->
  	@tab_div= @$el.find('div[rel*=tablature]')
  	@tab= new Tablature
      editable: if @tab_div.attr('editable') == "true" then true else false
      mother: @tab_div
      strings_nb: Number @tab_div.attr('strings_nb')
      frets_nb: Number @tab_div.attr('frets_nb')
      start_fret: Number @tab_div.attr('start_fret')
      chord: @tab_div.attr('chord').split(',').map((x) -> if isNaN(Number(x)) then null else Number(x))
      tuning: @tab_div.attr('tuning').split(',').map((x) -> if isNaN(Number(x)) then null else Number(x))


  pop_edit_chord: ->
  	$('#lean_overlay').show()
  	$('#edit-chord-wrapper').html(@edit_chord_template(@model.toJSON())).show()
  	setTimeout @init_edit_chord, 30

  save_chord: ->
  	router.app.modals.pop_chord_naming(@model.toJSON())

  delete_chord: ->
    @$el.remove()
    @model.destroy()

  init_edit_chord: =>
  	elem = $('#edit-chord-wrapper #edit-chord')
  	router.app.modals.current_edited_chord = new Tablature
      editable: true
      mother: elem
      strings_nb: Number elem.attr('strings_nb')
      frets_nb: Number elem.attr('frets_nb')
      start_fret: Number elem.attr('start_fret')
      chord: elem.attr('chord').split(',').map((x) -> if isNaN(Number(x)) then null else Number(x))
      tuning: elem.attr('tuning').split(',').map((x) -> if isNaN(Number(x)) then null else Number(x)) 

    router.app.modals.current_edited_chord._id= @model.attributes._id
    router.app.modals.current_edited_chord.view= this 
  
#### COLL
  
class ChordLibrary extends Backbone.Collection  	
  
  model: UserChord
  url: "/user_chords"

class ChordLibraryView extends Backbone.View
  collection: ChordLibrary
  initialize: ->
    @collection.on('add', @addOne, this)
    @collection.on('reset', @addAll, this)
  render: ->
    @addAll()
  addAll: ->
    @$el.empty()
    @collection.forEach @addOne, this  
  addOne: (item) ->
  	itemView = new UserChordView {model: item}
  	$('#user-chords').append(itemView.render().el)

########### SEARCH RESULTS #################################
class SearchResults extends Backbone.Collection  	
  
  model: UserChord
  url: "/search_results"

class SearchResultsView extends Backbone.View 

  collection: SearchResults

  initialize: ->
    @collection.on('reset', @render, this)

  render: ->
    $('#results_wrapper').empty()
    @index = 0
    if @collection.length == 0
      $('#results_wrapper').html "
        <p class='empty_search_message'>
          Sorry no matches, please check your settings
        </p>"
    else    
      @addNext(30)

  addNext: (n)->
    @collection.slice(@index, @index+n).forEach @addOne, this  
    @index+=n 
    if @index >= @collection.length then $('#load_more').hide() else $('#load_more').show()

  addOne: (item) ->
    itemView = new UserChordView {model: item}
    $('#results_wrapper').append(itemView.render().el)


