var SelectBox;

SelectBox = (function() {

  function SelectBox(opt) {
    var closed_height, current_height, item_height, item_margin, item_width, items, k, n_items, new_group, open, open_group, open_height, placeholder, regular_items, theme, v, val, _i, _len, _ref,
      _this = this;
    if (opt.mother) {
      this.mother = $(opt.mother);
    } else {
      this.mother = $(opt);
    }
    this.value = "default";
    if (opt.content) {
      this.mother.empty();
    }
    placeholder = opt.placeholder || "select...";
    this.mother.append("<div class='item placeholder'>" + placeholder + "</div>");
    if (opt.content) {
      _ref = opt.content;
      for (k in _ref) {
        v = _ref[k];
        if (typeof v === 'string') {
          this.mother.append("<div class='item'>" + v + "</div>");
        } else {
          new_group = $("<div class='item group'>" + k + "</div>");
          for (_i = 0, _len = v.length; _i < _len; _i++) {
            val = v[_i];
            new_group.append("<div class='item sub'>" + val + "</div>");
          }
          this.mother.append(new_group);
        }
      }
    }
    open = false;
    items = this.mother.find(".item").not('.sub');
    regular_items = items.not('.placeholder').not('.group');
    n_items = items.length;
    item_height = opt.height || 28;
    item_margin = opt.margin || 6;
    item_width = opt.width || 160;
    closed_height = item_height + 2 * item_margin;
    open_height = n_items * item_height + (n_items + 1) * item_margin;
    current_height = open_height;
    open_group = null;
    theme = ['#423A38', '#47B8C8', '#E7EEE2', '#BDB9B1', '#D7503E'];
    if (!this.mother.parent().hasClass("select-box-wrap")) {
      this.mother.wrap("<div class=\"select-box-wrap\" style=\"height: " + closed_height + "px; width: " + item_width + "px;\" />");
    }
    this.mother.css("height", "" + closed_height + "px").css("width", "" + item_width + "px").css("display", "inline-block");
    this.mother.find(".item").css("height", "" + item_height + "px").css("width", "" + (item_width - 2 * item_margin) + "px").css("margin", "" + item_margin + "px").css("line-height", "" + item_height + "px");
    this.mother.find(".placeholder").click(function() {
      if (open) {
        $(this).parent().css('height', "" + closed_height + "px");
        return open = false;
      } else {
        $(this).parent().css('height', "" + current_height + "px");
        return open = true;
      }
    });
    this.mother.bind("mouseleave", function(e) {
      var cb;
      cb = function() {
        if (!_this.mother.is(":hover")) {
          _this.mother.css('height', "" + closed_height + "px");
          return open = false;
        }
      };
      return setTimeout(cb, 1000);
    });
    regular_items.add('.sub').mouseenter(function() {
      return $(this).addClass('hov');
    });
    regular_items.add('.sub').mouseleave(function() {
      return $(this).removeClass('hov');
    });
    regular_items.add('.sub').bind("click", function(e) {
      var ct;
      ct = $(e.currentTarget);
      console.log(e.currentTarget);
      ct.parent().find('.placeholder').html(ct.text());
      _this.value = ct.text().trim();
      return console.log("clic: val: " + _this.value);
    });
    this.mother.find('.sub').hide();
    this.mother.find(".group").click(function() {
      var ch_len, childs, childs_height, rem_ch, rem_height;
      childs = $(this).children('.sub');
      ch_len = childs.length;
      rem_ch = $(this).parent().find('.sub').not('.group .sub');
      if (ch_len !== 0) {
        if (rem_ch.length !== 0) {
          rem_height = parseInt(rem_ch.length * (item_height + item_margin));
          current_height -= rem_height;
          $(this).parent().css('height', "" + current_height + "px");
          rem_ch.hide();
          open_group.append(rem_ch);
        }
        open_group = $(this);
        childs_height = parseInt(ch_len * (item_height + item_margin));
        current_height += childs_height;
        $(this).after(childs);
        childs.show();
        return $(this).parent().css('height', "" + current_height + "px");
      } else {
        open_group = null;
        childs = $(this).parent().find('.sub').not('.group .sub');
        ch_len = childs.length;
        childs_height = parseInt(ch_len * (item_height + item_margin));
        current_height -= childs_height;
        $(this).append(childs);
        childs.hide();
        $(this).parent().css('height', "" + current_height + "px");
        return $(this).addClass('closed');
      }
    });
  }

  return SelectBox;

})();
