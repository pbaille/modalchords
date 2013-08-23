var SelectTable;

SelectTable = (function() {

  function SelectTable(opt) {
    var c, e, elems, k, lab, v, _fn, _i, _j, _len, _len1, _ref,
      _this = this;
    this.el = $(opt.el);
    this.hash = opt.hash;
    this.selected = null;
    this.el.addClass("STwrapper");
    _ref = this.hash;
    for (k in _ref) {
      v = _ref[k];
      this.el.append("<div class='STrow'></div>");
      lab = this.el.find('.STrow').last();
      lab.css('text-align', 'center').css('display', 'inline-block');
      lab.append("<div class='STtitle STcase'>" + k + "</div>");
      for (_i = 0, _len = v.length; _i < _len; _i++) {
        e = v[_i];
        lab.append("<div class='STelement STcase'>" + (e.toString()) + "</div>");
      }
    }
    elems = this.el.find('.STelement');
    _fn = function() {
      var elem;
      elem = $(c);
      return elem.bind("click", function() {
        elems.removeClass("selected");
        elem.addClass("selected");
        _this.selected = elem.text().trim();
        return console.log(_this.selected);
      });
    };
    for (_j = 0, _len1 = elems.length; _j < _len1; _j++) {
      c = elems[_j];
      _fn();
    }
  }

  SelectTable.prototype.get_val = function() {
    return this.selected;
  };

  return SelectTable;

})();
