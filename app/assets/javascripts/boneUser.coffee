class MongoUser extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'mongo_users'
  urlRoot: "/mongo_users"

class UserMenu extends Backbone.View
  events:
  	"click #logout_link": "logout"
  	"click #login_link": "login"
  	"click #signup_link": "signup"
  	"click #user-area-link": "nav_to_user_area"

  initialize: ->
    _.bindAll(this, 'render')
    @model.on('reset', @render)
    @model.on('change', @render)

  menu_template: window.HAML['user_menu_template']	
  
  render: ->
  	@$el.html(@menu_template(@model.toJSON()))
  	@$el.attr('id','user-menu')
  	this

  nav_to_user_area: ->
    router.navigate('user_area', {trigger: true})	

  logout: ->
  	$.get "/mongo_users/logout", (guest_user) ->
  	  router.login guest_user
  	  router.navigate('', {trigger: true})

  login: ->
  	router.app.modals.pop_login()

  signup: ->
  	router.app.modals.pop_signup()
    	





      
