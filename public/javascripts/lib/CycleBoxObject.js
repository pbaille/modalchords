var CycleBox;

CycleBox = (function() {

  function CycleBox(opt) {
    var current_index, i, item, _fn, _i, _len, _ref,
      _this = this;
    if (opt.mother) {
      this.mother = $(opt.mother);
    } else {
      this.mother = $(opt);
    }
    if (opt.values) {
      this.values = opt.values;
    } else {
      this.values = opt.items;
    }
    this.mother.addClass('cycle-box');
    if (opt.items) {
      _ref = opt.items;
      _fn = function() {
        if (opt.colors) {
          return _this.mother.append("<p style=\"background: " + opt.colors[i] + "\">" + item + "</p>");
        } else {
          return _this.mother.append("<p>" + item + "</p>");
        }
      };
      for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
        item = _ref[i];
        _fn();
      }
    }
    this.items = this.mother.find('p');
    if (opt.width) {
      this.mother.css('width', opt.width);
    }
    if (opt.border_color) {
      this.items.css('borderColor', opt.border_color);
    }
    this.items.hide();
    this.current = this.mother.find('.current');
    current_index = 0;
    this.items.each(function(index) {
      if ($(this).hasClass('current')) {
        return current_index = index;
      }
    });
    this.current_index = current_index;
    this.current.show();
    this.mother.click(function() {
      console.log("clic");
      _this.current.hide();
      _this.current.removeClass('current');
      if (_this.current.next('p').length > 0) {
        _this.current = _this.current.next('p');
        _this.current.addClass('current');
        _this.current_index++;
      } else {
        _this.current = _this.items.first();
        _this.current.addClass('current');
        _this.current_index = 0;
      }
      return _this.current.show();
    });
  }

  CycleBox.prototype.get_val = function() {
    if (this.values) {
      return this.values[this.current_index];
    } else {
      return this.get_text();
    }
  };

  CycleBox.prototype.get_text = function() {
    return this.current.text().trim();
  };

  return CycleBox;

})();
