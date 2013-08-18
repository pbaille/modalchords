(function() {
  var _ref;

  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }

  window.HAML['tab_template'] = function(context) {
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
      if (this.name !== "untitled") {
        $o.push("<p class='user-chord-name'>");
        $o.push("  " + $e($c(this.name)));
        $o.push("</p>\n<div class='saved_chord_tab' rel='tablature' editable='false' strings_nb='" + ($e($c(this.tab.length))) + "' frets_nb='" + ($e($c(this.tab_width))) + "' start_fret='" + ($e($c(this.tab_index))) + "' chord='" + ($e($c(this.tab.map(function(x) {
          if (x === null) {
            return "null";
          } else {
            return x;
          }
        }).toString()))) + "' tuning='" + ($e($c(this.tuning.toString()))) + "'>\n  <span class='tab-icons'>\n    <i class='icon-play'>  </i>\n    <i class='icon-wrench'></i>\n    <i class='icon-cancel-2'></i>\n  </span>\n</div>");
      } else {
        $o.push("<div class='search_chord_tab' rel='tablature' editable='false' strings_nb='" + ($e($c(this.tab.length))) + "' frets_nb='" + ($e($c(this.tab_width))) + "' start_fret='" + ($e($c(this.tab_index))) + "' chord='" + ($e($c(this.tab.map(function(x) {
          if (x === null) {
            return "null";
          } else {
            return x;
          }
        }).toString()))) + "' tuning='" + ($e($c(this.tuning.toString()))) + "'>\n  <span class='tab-icons'>\n    <i class='icon-play'></i>\n    <i class='icon-heart-1'></i>\n    <i class='icon-wrench'></i>\n  </span>\n</div>");
      }
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '');
    }).call(context);
  };

}).call(this);
