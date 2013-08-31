class ModalChordsApp extends Backbone.View

  className: "modal-chords-app"

  events: 
    "click #load_more": "load_more_results"

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
    @searchResults.fetch({reset: true})

    @modals= new Modals

  render:->
    @$el.html(@template)
    @$el.append(@modals.render().el)
    @$el.prepend(@user_menu.render().el)
    @$el.find('#load_more').hide()
    this

  load_more_results: ->
    @searchResultsView.addNext(20)




class SearchesRouter extends Backbone.Router 

  routes: 
    "user_area": "user_searches"
    "": "main_search"

  user_searches: ->
    $('#user-area').show()
    $('#main-search').hide()
    $('#results').hide()

  main_search: ->
    $('#main-search').show()
    $('#user-area').hide()
    $('#results').show()

  initialize: (user) ->
    @login(user)

  start: () ->
    Backbone.history.start({pushState: true})
  
  login: (user) ->
    @app = new ModalChordsApp user
    $('body .modal-chords-app').remove()
    $('body').prepend @app.render().el
    @navigate('', {trigger: true})


##########################################################################################

window.router= {}

jQuery ($) ->

  window.onbeforeunload = ->
    if router.app.user.get('email').slice(0,5) == "guest"
      return "Are you sure you want to leave?  All your work will be lost, maybe should you signup first..."
    else
      return undefined  

  $.get 'ensure_user', (r) ->
    window.router= new SearchesRouter r
    window.router.start()

  $.get 'destroy_old_guests', (r) ->
    console.log r  


