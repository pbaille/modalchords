var arpegio, plan_note, play_chord, play_note;

play_note = function(channel, pitch, vel, duration) {
  MIDI.noteOn(channel, pitch, vel, 0);
  return MIDI.noteOff(channel, pitch, duration);
};

plan_note = function(channel, pitch, vel, duration, start_time) {
  MIDI.noteOn(channel, pitch, vel, start_time);
  return MIDI.noteOff(channel, pitch, start_time + duration);
};

play_chord = function(channel, pitches, vel, duration) {
  var pitch, _i, _len, _results;
  _results = [];
  for (_i = 0, _len = pitches.length; _i < _len; _i++) {
    pitch = pitches[_i];
    _results.push(play_note(channel, pitch, vel, duration));
  }
  return _results;
};

arpegio = function(channel, pitches, vel, speed, duration) {
  var index, pitch, _i, _len, _results;
  _results = [];
  for (index = _i = 0, _len = pitches.length; _i < _len; index = ++_i) {
    pitch = pitches[index];
    _results.push(plan_note(channel, pitch, vel, duration, speed * index));
  }
  return _results;
};

MIDI.loadPlugin({
  soundfontUrl: "./soundfont/",
  instrument: "acoustic_grand_piano",
  callback: function() {}
});
