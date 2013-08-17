(function() {
  var _ref;

  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }

  window.HAML['tuning_template'] = function(context) {
    return (function() {
      var $c, $e, $o, e, i, _fn, _i, _len, _ref1,
        _this = this;
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
      $o.push("<div id='tuning-wrapper'>\n  <div id='instument_settings_wrap'>\n    <input class='hidden' id='str' type='number' value='" + this.strings_nb + "' name='strings_nb'>\n    <div id='strings-wrap'>\n      <rz-inc_box id='strings' min='" + ($e($c(4))) + "' max='" + ($e($c(8))) + "' current='" + ($e($c(this.strings_nb))) + "' color='#47B8C8'></rz-inc_box>\n    </div>\n    <div id='tuning'>");
      _ref1 = ["one", "two", "three", "four", "five", "six", "seven", "eight"];
      _fn = function(e, i) {
        $o.push("      <rz-midi_box class='" + (!(i < _this.strings_nb) ? 'hidden' : void 0) + "' id='" + e + "' value='" + (_this.tuning[i] !== void 0 ? _this.tuning[i] : 0) + "'></rz-midi_box>");
        return '';
      };
      for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
        e = _ref1[i];
        _fn(e, i);
      }
      $o.push("    </div>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '');
    }).call(context);
  };

}).call(this);
