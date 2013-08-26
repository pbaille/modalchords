var ModalChordsApp, SearchesRouter,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

ModalChordsApp = (function(_super) {

  __extends(ModalChordsApp, _super);

  function ModalChordsApp() {
    return ModalChordsApp.__super__.constructor.apply(this, arguments);
  }

  ModalChordsApp.prototype.className = "modal-chords-app";

  ModalChordsApp.prototype.events = {
    "click #load_more": "load_more_results"
  };

  ModalChordsApp.prototype.template = window.HAML['main_view'];

  ModalChordsApp.prototype.initialize = function(user) {
    this.user = new MongoUser(user);
    this.user_menu = new UserMenu({
      model: this.user
    });
    this.user.fetch({
      reset: true
    });
    this.usc = new UserSearchColl;
    this.uscv = new SearchCollView({
      collection: this.usc
    });
    this.usc.fetch({
      reset: true
    });
    this.userChordLibrary = new ChordLibrary;
    this.userChordLibraryView = new ChordLibraryView({
      collection: this.userChordLibrary
    });
    this.userChordLibrary.fetch({
      reset: true
    });
    this.searchResults = new SearchResults;
    this.searchResultsView = new SearchResultsView({
      collection: this.searchResults
    });
    return this.modals = new Modals;
  };

  ModalChordsApp.prototype.render = function() {
    this.$el.html(this.template);
    this.$el.append(this.modals.render().el);
    this.$el.prepend(this.user_menu.render().el);
    this.$el.find('#load_more').hide();
    return this;
  };

  ModalChordsApp.prototype.load_more_results = function() {
    return this.searchResultsView.addNext(30);
  };

  return ModalChordsApp;

})(Backbone.View);

SearchesRouter = (function(_super) {

  __extends(SearchesRouter, _super);

  function SearchesRouter() {
    return SearchesRouter.__super__.constructor.apply(this, arguments);
  }

  SearchesRouter.prototype.routes = {
    "user_area": "user_searches",
    "": "main_search"
  };

  SearchesRouter.prototype.user_searches = function() {
    $('#user-area').show();
    $('#main-search').hide();
    return $('#results_wrapper').hide();
  };

  SearchesRouter.prototype.main_search = function() {
    $('#main-search').show();
    $('#user-area').hide();
    return $('#results_wrapper').show();
  };

  SearchesRouter.prototype.initialize = function(user) {
    return this.login(user);
  };

  SearchesRouter.prototype.start = function() {
    return Backbone.history.start({
      pushState: true
    });
  };

  SearchesRouter.prototype.login = function(user) {
    this.app = new ModalChordsApp(user);
    $('body .modal-chords-app').remove();
    $('body').prepend(this.app.render().el);
    return this.navigate('', {
      trigger: true
    });
  };

  return SearchesRouter;

})(Backbone.Router);

window.router = {};

jQuery(function($) {
  return $.get('ensure_user', function(r) {
    window.router = new SearchesRouter(r);
    return window.router.start();
  });
});
