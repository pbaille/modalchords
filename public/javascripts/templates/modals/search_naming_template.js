(function() {
  var _ref;

  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }

  window.HAML['search_naming_template'] = function(context) {
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
      $o.push("<div class='pop_up' id='search-naming'>\n  <input id='user-fav-name' name='name' size='" + ($e($c(30))) + "' type='text' placeholder='Choose a name'>\n  <input id='submit' value='Save search' type='submit'>\n</div>");
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '');
    }).call(context);
  };

}).call(this);
