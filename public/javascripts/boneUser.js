var MongoUser, UserMenu,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

MongoUser = (function(_super) {

  __extends(MongoUser, _super);

  function MongoUser() {
    return MongoUser.__super__.constructor.apply(this, arguments);
  }

  MongoUser.prototype.idAttribute = '_id';

  MongoUser.prototype.paramRoot = 'mongo_users';

  MongoUser.prototype.urlRoot = "/mongo_users";

  return MongoUser;

})(Backbone.Model);

UserMenu = (function(_super) {

  __extends(UserMenu, _super);

  function UserMenu() {
    return UserMenu.__super__.constructor.apply(this, arguments);
  }

  UserMenu.prototype.events = {
    "click #logout_link": "logout",
    "click #login_link": "login",
    "click #signup_link": "signup",
    "click #user-area-link": "nav_to_user_area"
  };

  UserMenu.prototype.initialize = function() {
    _.bindAll(this, 'render');
    this.model.on('reset', this.render);
    return this.model.on('change', this.render);
  };

  UserMenu.prototype.menu_template = window.HAML['user_menu_template'];

  UserMenu.prototype.render = function() {
    this.$el.html(this.menu_template(this.model.toJSON()));
    this.$el.attr('id', 'user-menu');
    return this;
  };

  UserMenu.prototype.nav_to_user_area = function() {
    return router.navigate('user_area', {
      trigger: true
    });
  };

  UserMenu.prototype.logout = function() {
    return $.get("/mongo_users/logout", function(guest_user) {
      router.login(guest_user);
      return router.navigate('', {
        trigger: true
      });
    });
  };

  UserMenu.prototype.login = function() {
    return router.app.modals.pop_login();
  };

  UserMenu.prototype.signup = function() {
    return router.app.modals.pop_signup();
  };

  return UserMenu;

})(Backbone.View);
