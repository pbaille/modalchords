(function() {
  var _ref;

  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }

  window.HAML['tuning_template'] = function(context) {
    return (function() {
      var $o, e, i, _fn, _i, _len, _ref1,
        _this = this;
      $o = [];
      $o.push("<div id='tuning-wrapper'>\n  <div id='strings'></div>\n  <div id='tuning'>");
      _ref1 = ["one", "two", "three", "four", "five", "six", "seven", "eight"];
      _fn = function(e, i) {
        $o.push("    <div class='" + (['tuning-midi-box', "" + (!(i < _this.strings_nb) ? 'hidden' : void 0)].sort().join(' ').trim()) + "' id='" + e + "'></div>");
        return '';
      };
      for (i = _i = 0, _len = _ref1.length; _i < _len; i = ++_i) {
        e = _ref1[i];
        _fn(e, i);
      }
      $o.push("  </div>\n</div>");
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '');
    }).call(context);
  };

}).call(this);
