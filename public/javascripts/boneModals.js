var Modals,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Modals = (function(_super) {

  __extends(Modals, _super);

  function Modals() {
    return Modals.__super__.constructor.apply(this, arguments);
  }

  Modals.prototype.events = {
    "click #lean_overlay": "hide_all",
    "click #login_link": "pop_login",
    "click #signup_link": "pop_signup",
    "click #login-modal #submit": "login_submit",
    "click #signup-modal #submit": "signup_submit",
    "click #search-naming #submit": "save_search_submit",
    "click #chord-naming #submit": "save_chord_submit",
    "click #edit-chord-wrapper #submit": "save_edited_chord"
  };

  Modals.prototype.initialize = function() {
    _.bindAll(this, 'render');
    return this.render();
  };

  Modals.prototype.login_template = window.HAML['login_template'];

  Modals.prototype.signup_template = window.HAML['signup_template'];

  Modals.prototype.search_naming_template = window.HAML['search_naming_template'];

  Modals.prototype.chord_naming_template = window.HAML['chord_naming_template'];

  Modals.prototype.render = function() {
    this.$el.html("<div id='lean_overlay'></div>");
    this.$el.append(this.login_template);
    this.$el.append(this.signup_template);
    this.$el.append(this.search_naming_template);
    this.$el.append(this.chord_naming_template);
    this.$el.append("<div id='edit-chord-wrapper' class='pop_up'></div>");
    setTimeout(this.hide_all, 30);
    this.$el.attr('id', 'modals');
    return this;
  };

  Modals.prototype.pop_login = function() {
    this.hide_all();
    return $('#login-modal, #lean_overlay').show();
  };

  Modals.prototype.pop_signup = function() {
    this.hide_all();
    return $('#signup-modal, #lean_overlay').show();
  };

  Modals.prototype.pop_search_naming = function() {
    this.hide_all();
    return $('#search-naming, #lean_overlay').show();
  };

  Modals.prototype.pop_chord_naming = function(chord) {
    this.hide_all();
    this.chord_to_save = new UserChord(chord);
    return $('#chord-naming, #lean_overlay').show();
  };

  Modals.prototype.hide_all = function() {
    return $('#login-modal, #signup-modal, #search-naming, #chord-naming, #lean_overlay, #error, #edit-chord-wrapper').hide();
  };

  Modals.prototype.show_error = function() {
    var cb,
      _this = this;
    this.$el.find('#error').show();
    cb = function() {
      return _this.$el.find('#error').hide();
    };
    return setTimeout(cb, 2000);
  };

  Modals.prototype.login_submit = function() {
    var email, pass,
      _this = this;
    email = $('#login-modal input#email').val();
    pass = $('#login-modal input#password').val();
    return $.get("mongo_users/login/" + email + "/" + pass, function(user) {
      if (user) {
        _this.hide_all();
        return router.login(user);
      } else {
        return _this.show_error();
      }
    });
  };

  Modals.prototype.signup_submit = function() {
    var email, pass, pass_conf,
      _this = this;
    email = $('#signup-modal input#email').val();
    pass = $('#signup-modal input#password').val();
    pass_conf = $('#signup-modal input#confirm-password').val();
    return $.get("mongo_users/signup/" + email + "/" + pass + "/" + pass_conf, function(user) {
      if (user) {
        console.log(user);
        _this.hide_all();
        return router.login(user);
      } else {
        return _this.show_error();
      }
    });
  };

  Modals.prototype.save_search_submit = function() {
    var n;
    this.hide_all();
    n = $('#search-naming #user-fav-name').val();
    return $.get("/save_search/" + n, function(ss) {
      return router.app.usc.add(ss);
    });
  };

  Modals.prototype.save_chord_submit = function() {
    this.hide_all();
    this.chord_to_save.set({
      name: $('#chord-naming #user-fav-name').val()
    });
    delete this.chord_to_save.id;
    this.chord_to_save.save();
    router.app.userChordLibrary.add(this.chord_to_save);
    return this.chord_to_save = null;
  };

  Modals.prototype.save_edited_chord = function() {
    var c, id, name, pitches, tab,
      _this = this;
    this.hide_all();
    tab = JSON.stringify(this.current_edited_chord.chord);
    pitches = JSON.stringify(this.current_edited_chord.pitches);
    name = $('input#chord-name').val();
    c = this.current_edited_chord.view.$el.find('.saved_chord_tab');
    if (c.length === 0) {
      return $.get("/save_edited_chord/" + pitches + "/" + tab + "/" + name, function(chord) {
        return router.app.userChordLibrary.add(chord);
      });
    } else {
      id = this.current_edited_chord._id;
      return $.get("/update_edited_chord/" + id + "/" + pitches + "/" + tab + "/" + name, function(chord) {
        return _this.current_edited_chord.view.model.fetch({
          success: _this.current_edited_chord.view.render
        });
      });
    }
  };

  return Modals;

})(Backbone.View);
