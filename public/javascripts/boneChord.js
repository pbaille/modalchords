var ChordLibrary, ChordLibraryView, SearchResults, SearchResultsView, UserChord, UserChordView,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

UserChord = (function(_super) {

  __extends(UserChord, _super);

  function UserChord() {
    return UserChord.__super__.constructor.apply(this, arguments);
  }

  UserChord.prototype.idAttribute = '_id';

  UserChord.prototype.paramRoot = 'user_chords';

  UserChord.prototype.urlRoot = "/user_chords";

  return UserChord;

})(Backbone.Model);

UserChordView = (function(_super) {

  __extends(UserChordView, _super);

  function UserChordView() {
    this.init_edit_chord = __bind(this.init_edit_chord, this);
    return UserChordView.__super__.constructor.apply(this, arguments);
  }

  UserChordView.prototype.className = "chord-view";

  UserChordView.prototype.initialize = function() {
    return _.bindAll(this, 'render');
  };

  UserChordView.prototype.events = {
    "click i.icon-wrench": "pop_edit_chord",
    "click i.icon-cancel-2": "delete_chord",
    "click i.icon-heart-1": "save_chord"
  };

  UserChordView.prototype.template = window.HAML['tab_template'];

  UserChordView.prototype.edit_chord_template = window.HAML['edit_chord_template'];

  UserChordView.prototype.render = function() {
    this.$el.html(this.template(this.model.toJSON()));
    this.init_tab();
    return this;
  };

  UserChordView.prototype.init_tab = function() {
    this.tab_div = this.$el.find('div[rel*=tablature]');
    return this.tab = new Tablature({
      editable: this.tab_div.attr('editable') === "true" ? true : false,
      mother: this.tab_div,
      strings_nb: Number(this.tab_div.attr('strings_nb')),
      frets_nb: Number(this.tab_div.attr('frets_nb')),
      start_fret: Number(this.tab_div.attr('start_fret')),
      chord: this.tab_div.attr('chord').split(',').map(function(x) {
        if (isNaN(Number(x))) {
          return null;
        } else {
          return Number(x);
        }
      }),
      tuning: this.tab_div.attr('tuning').split(',').map(function(x) {
        if (isNaN(Number(x))) {
          return null;
        } else {
          return Number(x);
        }
      })
    });
  };

  UserChordView.prototype.pop_edit_chord = function() {
    $('#lean_overlay').show();
    $('#edit-chord-wrapper').html(this.edit_chord_template(this.model.toJSON())).show();
    return setTimeout(this.init_edit_chord, 30);
  };

  UserChordView.prototype.save_chord = function() {
    return router.app.modals.pop_chord_naming(this.model.toJSON());
  };

  UserChordView.prototype.delete_chord = function() {
    this.$el.remove();
    return this.model.destroy();
  };

  UserChordView.prototype.init_edit_chord = function() {
    var elem;
    elem = $('#edit-chord-wrapper #edit-chord');
    router.app.modals.current_edited_chord = new Tablature({
      editable: true,
      mother: elem,
      strings_nb: Number(elem.attr('strings_nb')),
      frets_nb: Number(elem.attr('frets_nb')),
      start_fret: Number(elem.attr('start_fret')),
      chord: elem.attr('chord').split(',').map(function(x) {
        if (isNaN(Number(x))) {
          return null;
        } else {
          return Number(x);
        }
      }),
      tuning: elem.attr('tuning').split(',').map(function(x) {
        if (isNaN(Number(x))) {
          return null;
        } else {
          return Number(x);
        }
      })
    });
    router.app.modals.current_edited_chord._id = this.model.attributes._id;
    return router.app.modals.current_edited_chord.view = this;
  };

  return UserChordView;

})(Backbone.View);

ChordLibrary = (function(_super) {

  __extends(ChordLibrary, _super);

  function ChordLibrary() {
    return ChordLibrary.__super__.constructor.apply(this, arguments);
  }

  ChordLibrary.prototype.model = UserChord;

  ChordLibrary.prototype.url = "/user_chords";

  return ChordLibrary;

})(Backbone.Collection);

ChordLibraryView = (function(_super) {

  __extends(ChordLibraryView, _super);

  function ChordLibraryView() {
    return ChordLibraryView.__super__.constructor.apply(this, arguments);
  }

  ChordLibraryView.prototype.collection = ChordLibrary;

  ChordLibraryView.prototype.initialize = function() {
    this.collection.on('add', this.addOne, this);
    return this.collection.on('reset', this.addAll, this);
  };

  ChordLibraryView.prototype.render = function() {
    return this.addAll();
  };

  ChordLibraryView.prototype.addAll = function() {
    this.$el.empty();
    return this.collection.forEach(this.addOne, this);
  };

  ChordLibraryView.prototype.addOne = function(item) {
    var itemView;
    itemView = new UserChordView({
      model: item
    });
    return $('#user-chords').append(itemView.render().el);
  };

  return ChordLibraryView;

})(Backbone.View);

SearchResults = (function(_super) {

  __extends(SearchResults, _super);

  function SearchResults() {
    return SearchResults.__super__.constructor.apply(this, arguments);
  }

  SearchResults.prototype.model = UserChord;

  SearchResults.prototype.url = "/search_results";

  return SearchResults;

})(Backbone.Collection);

SearchResultsView = (function(_super) {

  __extends(SearchResultsView, _super);

  function SearchResultsView() {
    return SearchResultsView.__super__.constructor.apply(this, arguments);
  }

  SearchResultsView.prototype.collection = SearchResults;

  SearchResultsView.prototype.initialize = function() {
    return this.collection.on('reset', this.render, this);
  };

  SearchResultsView.prototype.render = function() {
    $('#results_wrapper').empty();
    this.index = 0;
    if (this.collection.length === 0) {
      return $('#results_wrapper').html("        <p class='empty_search_message'>          Sorry no matches, please check your settings        </p>");
    } else {
      return this.addNext(30);
    }
  };

  SearchResultsView.prototype.addNext = function(n) {
    this.collection.slice(this.index, this.index + n).forEach(this.addOne, this);
    this.index += n;
    if (this.index >= this.collection.length) {
      return $('#load_more').hide();
    } else {
      return $('#load_more').show();
    }
  };

  SearchResultsView.prototype.addOne = function(item) {
    var itemView;
    itemView = new UserChordView({
      model: item
    });
    return $('#results_wrapper').append(itemView.render().el);
  };

  return SearchResultsView;

})(Backbone.View);
