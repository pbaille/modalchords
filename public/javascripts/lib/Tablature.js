var Tablature;

Tablature = (function() {

  function Tablature(opt) {
    var c, coord, i, num, _fn, _i, _j, _k, _len, _len1, _ref, _ref1, _ref2,
      _this = this;
    this.mother = $(opt.mother);
    this.strings_nb = opt.strings_nb;
    this.frets_nb = opt.frets_nb;
    this.start_fret = opt.start_fret;
    this.tuning = opt.tuning;
    this.chord = opt.chord;
    this.pitches = [];
    this.chord.forEach(function(e, i) {
      if (e !== null) {
        return _this.pitches[i] = _this.tuning[i] + e;
      } else {
        return _this.pitches[i] = null;
      }
    });
    this.mother.addClass('tab-wrapper');
    this.mother.prepend("<div class=\"tab x-" + this.strings_nb + " y-" + this.frets_nb + "\"></div>");
    this.mother.find('.tab').append("<div class='fret_index'><b>" + this.start_fret + "</b></div>");
    for (num = _i = 0, _ref = this.strings_nb * (this.frets_nb + 1) - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; num = 0 <= _ref ? ++_i : --_i) {
      coord = {
        fret: Math.floor(num / this.strings_nb),
        string: num % this.strings_nb
      };
      if (coord.fret !== 0) {
        coord.fret += this.start_fret - 1;
      }
      if (num < this.strings_nb) {
        this.mother.find('.tab').append("<div class='case open-string string-" + coord.string + " fret-" + coord.fret + "'></div>");
      } else {
        this.mother.find('.tab').append("<div class='case string-" + coord.string + " fret-" + coord.fret + "'></div>");
      }
    }
    this.cases = this.mother.find(".case");
    _ref1 = this.chord;
    for (i = _j = 0, _len = _ref1.length; _j < _len; i = ++_j) {
      num = _ref1[i];
      if (num !== null) {
        this.cases.filter(".string-" + i + ".fret-" + num).addClass('on');
      }
      this.mother.find('.tab').append("<div class='case num_bubble'><b class='funct'>" + (num !== null ? num : "X") + "</b></div>");
    }
    this.mother.find('i.icon-play').bind('click', function() {
      var p;
      p = _this.pitches.filter(function(value) {
        if (value !== null) {
          return value;
        }
      });
      return arpegio(0, p, 60, 0.1, 2);
    });
    if (opt.editable === true) {
      this.mother.find('#edited_chord_name').hide();
      this.mother.find('i.icon-heart-1').bind('click', function() {
        return $('#edited_chord_name').show();
      });
      this.mother.find('#edited_chord_name input[type*=submit]').bind('click', function() {
        var n;
        n = _this.mother.find('#edited_chord_name input[type*=text]').val();
        return $.get("/save_edited_chord/" + (JSON.stringify(_this.pitches)) + "/" + (JSON.stringify(_this.chord)) + "/" + n, function(r) {
          $("#lean_overlay").fadeOut(200);
          return $("#edit-chord-wrapper").css({
            'display': 'none'
          });
        });
      });
      _ref2 = this.cases;
      _fn = function() {
        var elem;
        elem = $(c);
        return elem.bind('click', function() {
          var fret, string, _l, _len2, _ref3;
          string = Number(elem.attr('class').split(' ').filter(function(x) {
            return x[0] === "s";
          })[0].match(/\d+/)[0]);
          fret = Number(elem.attr('class').split(' ').filter(function(x) {
            return x[0] === "f";
          })[0].match(/\d+/)[0]);
          _this.cases.filter(".string-" + string).not(elem).removeClass('on');
          if (elem.hasClass('on')) {
            elem.removeClass('on');
            _this.chord[string] = null;
          } else {
            elem.addClass('on');
            _this.chord[string] = fret;
          }
          console.log(_this.chord);
          _this.mother.find('.num_bubble').remove();
          _ref3 = _this.chord;
          for (i = _l = 0, _len2 = _ref3.length; _l < _len2; i = ++_l) {
            num = _ref3[i];
            _this.mother.find('.tab').append("<div class='case num_bubble'><b class='funct'>" + (num !== null ? num : "X") + "</b></div>");
          }
          _this.chord.forEach(function(e, i) {
            if (e !== null) {
              return _this.pitches[i] = _this.tuning[i] + e;
            } else {
              return _this.pitches[i] = null;
            }
          });
          _this.mother.find('i.icon-play').unbind('click');
          return _this.mother.find('i.icon-play').bind('click', function() {
            var p;
            p = _this.pitches.filter(function(value) {
              return value !== "" && value !== null;
            });
            return arpegio(0, p, 60, 0.1, 2);
          });
        });
      };
      for (_k = 0, _len1 = _ref2.length; _k < _len1; _k++) {
        c = _ref2[_k];
        _fn();
      }
    }
  }

  return Tablature;

})();
