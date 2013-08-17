(function() {
  var _ref;

  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }

  window.HAML['edit_chord_template'] = function(context) {
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
      $o.push("<input id='chord-name' name='name' size='" + ($e($c(20))) + "' type='text' value='" + ($e($c(this.name))) + "'>\n<div id='edit-chord' rel='tablature' editable='true' strings_nb='" + ($e($c(this.tab.length))) + "' frets_nb='" + ($e($c(this.tab_width))) + "' start_fret='" + ($e($c(this.tab_index))) + "' chord='" + ($e($c(this.tab.map(function(x) {
        if (x === null) {
          return "null";
        } else {
          return x;
        }
      }).toString()))) + "' tuning='" + ($e($c(this.tuning.toString()))) + "'>\n  <span class='tab-icons'>\n    <i class='icon-play'></i>\n  </span>\n</div>\n<input id='submit' type='submit' value='Save'>\n  <!-- #edited_chord_name -->\n  <!--   %input{:type => \"text\", :placeholder => \"untitled\"} -->\n  <!--   %input{:type => \"submit\", :value => \"Save\"}   -->");
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '');
    }).call(context);
  };

}).call(this);
