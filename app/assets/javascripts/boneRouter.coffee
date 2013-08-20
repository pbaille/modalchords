class ModalChordsApp extends Backbone.View

  className: "modal-chords-app"

  template: window.HAML['main_view']

  initialize: (user) ->

    @user= new MongoUser user
    @user_menu= new UserMenu {model: @user}
    @user.fetch({reset: true})

    @usc = new UserSearchColl
    @uscv = new SearchCollView {collection: @usc}
    @usc.fetch({reset: true})

    @userChordLibrary= new ChordLibrary
    @userChordLibraryView= new ChordLibraryView {collection: @userChordLibrary}
    @userChordLibrary.fetch({reset: true})

    @searchResults= new SearchResults
    @searchResultsView= new SearchResultsView {collection: @searchResults}

    @modals= new Modals

  render:->
    @$el.html(@template)
    @$el.append(@modals.render().el)
    @$el.prepend(@user_menu.render().el)
    this





class SearchesRouter extends Backbone.Router 

  routes: 
    "user_area": "user_searches"
    "": "main_search"

  user_searches: ->
    $('#user-area').show()
    $('#main-search').hide()
    $('#results_wrapper').hide()

  main_search: ->
    $('#main-search').show()
    $('#user-area').hide()
    $('#results_wrapper').show()

  initialize: (user) ->
    @login(user)

  start: () ->
    Backbone.history.start({pushState: true})
  
  login: (user) ->
    console.log user
    @app = new ModalChordsApp user
    $('body .modal-chords-app').remove()
    $('body').prepend @app.render().el


##########################################################################################

window.router= {}

jQuery ($) ->

  # window.onbeforeunload = ->
  #   if router.app.user.get('email').slice(0,5) == "guest"
  #     return "Are you sure you want to leave?  someCondition does not equal someValue..."
  #   else
  #     return  


  $.get 'ensure_user', (r) ->
    console.log r
    window.router= new SearchesRouter r
    window.router.start()


