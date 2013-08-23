var SettingsView,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

SettingsView = (function(_super) {

  __extends(SettingsView, _super);

  function SettingsView() {
    this.init_elements = __bind(this.init_elements, this);
    return SettingsView.__super__.constructor.apply(this, arguments);
  }

  SettingsView.prototype.className = "search-settings-view";

  SettingsView.prototype.initialize = function() {
    return _.bindAll(this, 'render');
  };

  SettingsView.prototype.events = {
    "click .toggle.blue": "toggle_mode_selector",
    "click .toggle.orange": "toggle_struct_selector",
    "click .toggle.grey": "toggle_search_options",
    "click .mode_selector .STelement": "update_mode",
    "click .struct_selector .STelement": "update_struct",
    "mouseleave .search_options": "update_options"
  };

  SettingsView.prototype.search_options_template = window.HAML['settings_template'];

  SettingsView.prototype.render = function() {
    this.$el.html("    <div class='toggles_wrap'><div class='toggles'>    	<div class='toggle blue'></div>    	<div class='toggle orange'></div>    	<div class='toggle grey'></div>    </div></div>    <div class='mode_selector_wrap'><div class='mode_selector'></div></div>		    <div class='struct_selector_wrap'><div class='struct_selector'></div></div>		    <div class='search_options_wrap'><div class='search_options'></div></div>		    ");
    setTimeout(this.init_elements, 300);
    this.$el.find('.search_options').html(this.search_options_template(this.model.toJSON()));
    this.init_cycle_boxes();
    this.init_inc_boxes();
    return this;
  };

  SettingsView.prototype.init_elements = function() {
    this.mode_selector = new SelectTable({
      el: this.$el.find(".mode_selector"),
      hash: this.model.get('mother_scales')
    });
    return this.struct_selector = new SelectTable({
      el: this.$el.find(".struct_selector"),
      hash: this.limited_partials()
    });
  };

  SettingsView.prototype.refresh_struct_selector = function() {
    this.$el.find('.struct_selector').empty();
    return this.struct_selector = new SelectTable({
      el: this.$el.find(".struct_selector"),
      hash: this.limited_partials()
    });
  };

  SettingsView.prototype.init_cycle_boxes = function() {
    this.tp_box = new CycleBox({
      mother: this.$el.find("#twin-pitches .cycle-box"),
      values: [null, false, true]
    });
    this.os_box = new CycleBox({
      mother: this.$el.find("#open-strings .cycle-box"),
      values: [null, false, true]
    });
    this.iv_box = new CycleBox({
      mother: this.$el.find("#inversions .cycle-box"),
      values: [null, false, true]
    });
    return this.b9_box = new CycleBox({
      mother: this.$el.find("#b9 .cycle-box"),
      values: [null, false, true]
    });
  };

  SettingsView.prototype.init_inc_boxes = function() {
    this.fb_min_ib = new IncBox({
      el: this.$el.find('#fb_min'),
      current: this.model.get('fb_min_fret'),
      min: 1,
      max: this.model.get('cases_nb')
    });
    this.fb_max_ib = new IncBox({
      el: this.$el.find('#fb_max'),
      current: this.model.get('fb_max_fret'),
      min: this.model.get('fb_min_fret'),
      max: this.model.get('cases_nb')
    });
    this.position_max_width_ib = new IncBox({
      el: this.$el.find('#position_max_width'),
      current: this.model.get('position_max_width'),
      min: 3,
      max: 6
    });
    this.bass_max_step_ib = new IncBox({
      el: this.$el.find('#bass_max_step'),
      current: this.model.attributes.chord_filters['bass_max_step']
    });
    return this.max_step_ib = new IncBox({
      el: this.$el.find('#max_step'),
      current: this.model.attributes.chord_filters['max_step']
    });
  };

  SettingsView.prototype.limited_partials = function() {
    var lim;
    lim = {};
    _.each(this.model.get('partials'), function(v, k) {
      if (k !== "6") {
        return lim[k] = v.slice(0, 5).map(function(x) {
          return x.toString().replace(/,/g, " ");
        });
      }
    });
    return lim;
  };

  SettingsView.prototype.toggle_mode_selector = function() {
    if (this.$el.find(".mode_selector_wrap").is(':visible')) {
      this.$el.find('.blue').removeClass('open');
      return this.$el.find(".mode_selector_wrap").slideUp();
    } else {
      this.$el.find('.blue').addClass('open');
      return this.$el.find(".mode_selector_wrap").detach().insertAfter(this.$el.find('.toggles_wrap')).slideDown();
    }
  };

  SettingsView.prototype.toggle_struct_selector = function() {
    var e;
    if (this.$el.find(".struct_selector_wrap").is(':visible')) {
      this.$el.find('.orange').removeClass('open');
      return e = this.$el.find(".struct_selector_wrap").slideUp();
    } else {
      this.$el.find('.orange').addClass('open');
      return this.$el.find(".struct_selector_wrap").detach().insertAfter(this.$el.find('.toggles_wrap')).slideDown();
    }
  };

  SettingsView.prototype.toggle_search_options = function() {
    var e;
    if (this.$el.find(".search_options_wrap").is(':visible')) {
      this.$el.find('.grey').removeClass('open');
      return e = this.$el.find(".search_options_wrap").slideUp();
    } else {
      this.$el.find('.grey').addClass('open');
      return this.$el.find(".search_options_wrap").detach().insertAfter(this.$el.find('.toggles_wrap')).slideDown();
    }
  };

  SettingsView.prototype.update_mode = function() {
    var dsh, k, km, new_mode, success_cb, v, val,
      _this = this;
    dsh = this.model.get('degree_status_hash');
    val = this.mode_selector.get_val();
    console.log(val);
    km = this.model.get('known_modes');
    new_mode = km[val];
    for (k in dsh) {
      v = dsh[k];
      if (new_mode[k]) {
        dsh[k] = new_mode[k] + " " + v.split(" ")[1];
      }
    }
    this.model.set({
      degree_status_hash: dsh,
      mode_name: this.model.get('mode_name').split(" ")[0] + " " + val
    });
    success_cb = function() {
      _this.refresh_struct_selector();
      return _this.mother.renderStruct();
    };
    return this.model.save({}, {
      success: success_cb
    });
  };

  SettingsView.prototype.update_struct = function() {
    var d, degrees_names, dsh, h, k, v, val, _i, _len;
    console.log("update_struct");
    dsh = this.model.get('degree_status_hash');
    degrees_names = Object.keys(dsh);
    val = this.struct_selector.get_val().split(" ");
    h = {};
    for (_i = 0, _len = val.length; _i < _len; _i++) {
      d = val[_i];
      h[degrees_names[parseInt(d[1]) - 1]] = d + " enabled";
    }
    for (k in dsh) {
      v = dsh[k];
      dsh[k] = v.split(" ")[0] + " disabled";
      if (h[k]) {
        dsh[k] = h[k];
      }
    }
    dsh["root"] = dsh["root"].split(" ")[0] + " uniq";
    this.model.set({
      degree_status_hash: dsh
    });
    this.mother.renderStruct();
    return this.model.save();
  };

  SettingsView.prototype.update_options = function(e) {
    var cb,
      _this = this;
    cb = function() {
      var cf;
      cf = _this.model.get('chord_filters');
      cf['bass_max_step'] = _this.bass_max_step_ib.get_val();
      cf['max_step'] = _this.max_step_ib.get_val();
      cf['inversions'] = _this.iv_box.get_val();
      cf['b9'] = _this.b9_box.get_val();
      cf['open_strings'] = _this.os_box.get_val();
      cf['twin_pitches'] = _this.tp_box.get_val();
      _this.model.set({
        chord_filters: cf,
        fb_min_fret: _this.fb_min_ib.get_val(),
        fb_max_fret: _this.fb_max_ib.get_val(),
        position_max_width: _this.position_max_width_ib.get_val()
      });
      return console.log(_this.model.attributes);
    };
    return setTimeout(cb, 250);
  };

  return SettingsView;

})(Backbone.View);
