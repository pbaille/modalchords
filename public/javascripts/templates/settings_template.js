(function() {
  var _ref;

  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }

  window.HAML['settings_template'] = function(context) {
    return (function() {
      var $c, $e, $o;
      $e = function(text, escape) {
        return ("" + text).replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/'/g, '&#39;').replace(/"/g, '&quot;');
      };
      $c = function(text) {
        switch (text) {
          case null:
          case void 0:
            return '';
          case true:
          case false:
            return '' + text;
          default:
            return text;
        }
      };
      $o = [];
      $o.push("<div class='opt-item' id='search-range'>\n  <span class='label'>\n    search-range\n  </span>\n  <div class='control'>\n    <rz-inc_box id='fb_min' min='" + ($e($c(0))) + "' max='" + ($e($c(this.cases_nb))) + "' current='" + ($e($c(this.fb_min_fret))) + "'></rz-inc_box>\n    <span>...</span>\n    <rz-inc_box id='fb_max' min='" + ($e($c(1))) + "' max='" + ($e($c(this.cases_nb))) + "' current='" + ($e($c(this.fb_max_fret))) + "'></rz-inc_box>\n  </div>\n</div>\n<div class='opt-item' id='fingering-max-gap'>\n  <span class='label'>\n    fingering-max-gap\n  </span>\n  <div class='control'>\n    <rz-inc_box id='position_max_width' min='" + ($e($c(3))) + "' max='" + ($e($c(6))) + "' current='" + ($e($c(this.position_max_width))) + "'></rz-inc_box>\n  </div>\n</div>\n<div class='opt-item' id='inversions'>\n  <span class='label'>\n    inversions\n  </span>\n  <div class='cycle-box'>\n    <p class='" + (['one', "" + (this.chord_filters['inversions'] === null ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      Yes\n    </p>\n    <p class='" + (['two', "" + (this.chord_filters['inversions'] === false ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      No\n    </p>\n    <p class='" + (['three', "" + (this.chord_filters['inversions'] === true ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      Only\n    </p>\n  </div>\n</div>\n<div class='opt-item' id='b9'>\n  <span class='label'>\n    minor 9th\n  </span>\n  <div class='cycle-box'>\n    <p class='" + (['one', "" + (this.chord_filters['b9'] === null ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      Yes\n    </p>\n    <p class='" + (['two', "" + (this.chord_filters['b9'] === false ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      No\n    </p>\n    <p class='" + (['three', "" + (this.chord_filters['b9'] === true ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      Only\n    </p>\n  </div>\n</div>\n<div class='opt-item' id='bass-max-distance'>\n  <span class='label'>\n    bass-max-distance\n  </span>\n  <div class='control'>\n    <rz-inc_box id='bass_max_step' min='" + ($e($c(1))) + "' max='" + ($e($c(99))) + "' current='" + ($e($c(this.chord_filters['bass_max_step']))) + "'></rz-inc_box>\n  </div>\n</div>\n<div class='opt-item' id='max-step'>\n  <span class='label'>\n    max-step\n  </span>\n  <div class='control'>\n    <rz-inc_box id='max_step' min='" + ($e($c(1))) + "' max='" + ($e($c(99))) + "' current='" + ($e($c(this.chord_filters['max_step']))) + "'></rz-inc_box>\n  </div>\n</div>\n<div class='opt-item' id='open-strings'>\n  <span class='label'>\n    open-strings\n  </span>\n  <div class='cycle-box'>\n    <p class='" + (['one', "" + (this.chord_filters['open_strings'] === null ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      Yes\n    </p>\n    <p class='" + (['two', "" + (this.chord_filters['open_strings'] === false ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      No\n    </p>\n    <p class='" + (['three', "" + (this.chord_filters['open_strings'] === true ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      Only\n    </p>\n  </div>\n</div>\n<div class='opt-item' id='twin-pitches'>\n  <span class='label'>\n    twin-pitches\n  </span>\n  <div class='cycle-box'>\n    <p class='" + (['one', "" + (this.chord_filters['twin_pitches'] === null ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      Yes\n    </p>\n    <p class='" + (['two', "" + (this.chord_filters['twin_pitches'] === false ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      No\n    </p>\n    <p class='" + (['three', "" + (this.chord_filters['twin_pitches'] === true ? 'current' : void 0)].sort().join(' ').trim()) + "'>\n      Only\n    </p>\n  </div>\n</div>\n<div id='intervals-ranges'></div>");
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '');
    }).call(context);
  };

}).call(this);
