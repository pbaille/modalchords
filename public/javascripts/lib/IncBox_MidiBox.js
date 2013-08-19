var IncBox, MidiBox;

IncBox = (function() {

  function IncBox(opt) {
    var arrows, max, min,
      _this = this;
    this.el = $(opt.el);
    if (opt.values) {
      this.values = opt.values.split(" ");
    } else {
      this.values = [];
      min = opt.min || 0;
      max = opt.max || 127;
      while (min <= max) {
        this.values.push(min);
        min++;
      }
    }
    if (opt.index !== void 0) {
      this.index = opt.index;
      this.current = this.values[this.index];
    } else if (opt.current !== void 0) {
      this.current = opt.current;
      this.index = this.values.indexOf(this.current);
    } else {
      this.index = 0;
      this.current = this.values[0];
    }
    this.el.html("<div class='arrow up hidden'></div><div class='arrow down hidden' > </div>");
    this.el.addClass('incBoxWrapper');
    this.el.append("<div class='incBoxDisplay'><b>" + this.current + "</b></div>");
    arrows = this.el.find('.arrow');
    this.el.on("mouseenter mouseleave", function() {
      return arrows.toggleClass('hidden');
    });
    this.el.find('.up').click(function() {
      if (_this.values[_this.index + 1] !== void 0) {
        _this.index++;
      } else {
        _this.index = 0;
      }
      _this.current = _this.values[_this.index];
      return _this.el.find('.incBoxDisplay b').html("" + _this.current);
    });
    this.el.find('.down').click(function() {
      if (_this.values[_this.index - 1] !== void 0) {
        _this.index--;
      } else {
        _this.index = _this.values.length - 1;
      }
      _this.current = _this.values[_this.index];
      return _this.el.find('.incBoxDisplay b').html("" + _this.current);
    });
  }

  IncBox.prototype.get_val = function() {
    return this.current;
  };

  return IncBox;

})();

MidiBox = (function() {

  function MidiBox(opt) {
    this.el = $(opt.el);
    this.pitch = opt.pitch || 60;
    this.el.addClass('midiBoxWrapper');
    this.el.html("<div class='pitch_box'></div><div class='oct_box'></div>");
    this.pitch_box = new IncBox({
      el: this.el.find('.pitch_box'),
      values: "C Db D Eb E F Gb G Ab A Bb B",
      index: this.pitch % 12
    });
    this.oct_box = new IncBox({
      el: this.el.find('.oct_box'),
      min: -5,
      max: 5,
      current: Math.floor(this.pitch / 12) - 5
    });
  }

  MidiBox.prototype.get_val = function() {
    var add, o, p, pitch;
    p = this.pitch_box.get_val();
    o = this.oct_box.get_val();
    add = (o + 5) * 12;
    pitch = this.pitch_box.values.indexOf(p);
    return pitch + add;
  };

  return MidiBox;

})();
