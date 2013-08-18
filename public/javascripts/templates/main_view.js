(function() {
  var _ref;

  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }

  window.HAML['main_view'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<div id='main-search'></div>\n<div id='results_wrapper'></div>\n<div id='user-area'>\n  <div id='user-searches'>\n    <p class='categorie'>User searches</p>\n  </div>\n  <div id='user-chords'>\n    <p class='categorie'>User chords</p>\n  </div>\n</div>");
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '');
    }).call(context);
  };

}).call(this);
