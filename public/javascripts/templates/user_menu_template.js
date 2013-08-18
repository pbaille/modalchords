(function() {
  var _ref;

  if ((_ref = window.HAML) == null) {
    window.HAML = {};
  }

  window.HAML['user_menu_template'] = function(context) {
    return (function() {
      var $o;
      $o = [];
      $o.push("<a id='user-area-link'>\n  <i class='icon-user-male'></i>\n</a>");
      if (this.email.slice(0, 5) !== "guest") {
        $o.push("<div id='logout_link'>\n  <i class='icon-logout'></i>\n</div>");
      } else {
        $o.push("<div id='login_link'>\n  <i class='icon-login'></i>\n</div>\n<div id='signup_link'>\n  <i class='icon-feather'></i>\n</div>");
      }
      return $o.join("\n").replace(/\s(\w+)='true'/mg, ' $1').replace(/\s(\w+)='false'/mg, '');
    }).call(context);
  };

}).call(this);
