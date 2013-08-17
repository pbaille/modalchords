(function() {
  var _ref;

  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }

  window.HAML['struct_template'] = function(context) {
    return (function() {
      var $c, $e, $o, k, v, _ref1;
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
      $o.push("<div id='struct_form_wrap'>");
      if (this.name !== "user_current_search") {
        $o.push("  <div id='name-label' style='text-align: left; position: absolute;'>");
        $o.push("    " + $e($c(this.name)));
        $o.push("  </div>");
      }
      _ref1 = this.degree_status_hash;
      for (k in _ref1) {
        v = _ref1[k];
        $o.push("  <div class='wrapper' id='" + k + "'>\n    <div class='main " + (v.split(' ')[1]) + "'>\n      <b unselectable='on'>");
        $o.push("        " + $e($c(v.split(' ')[0])));
        $o.push("      </b>\n    </div>\n    <div class='bub top " + (v.split(' ')[1]) + "'>\n      <b></b>\n    </div>\n    <div class='bub bottom " + (v.split(' ')[1]) + "'>\n      <b></b>\n    </div>\n    <div class='state-selector-wrap'>\n      <div class='enabled little_circle'></div>\n      <div class='little_circle uniq'></div>\n      <div class='little_circle optional'></div>\n      <div class='disabled little_circle'></div>\n    </div>\n  </div>");
      }
      $o.push("  <div class='right' id='struct_form_icon_wrap'>");
      if (this.name === "user_current_search") {
        $o.push("    <i class='icon-refresh' style='font-size: 25px;'></i>");
      } else {
        $o.push("    <i class='icon-rocket' style='font-size: 22px;'></i>");
      }
      if (this.name === "user_current_search") {
        $o.push("    <i class='icon-heart-1' style='font-size: 25px;'></i>");
      } else {
        $o.push("    <i class='icon-cancel-2' style='font-size: 20px;'></i>");
      }
      $o.push("  </div>\n  <div class='left' id='struct_form_icon_wrap'>\n    <i class='icon-tumbler' style='font-size: 25px;'></i>\n    <i class='icon-cog-1' style='font-size: 25px;'></i>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '');
    }).call(context);
  };

}).call(this);
