
play_note = (channel,pitch,vel,duration) ->
	MIDI.noteOn channel, pitch, vel, 0
	MIDI.noteOff channel, pitch, duration

plan_note = (channel,pitch,vel,duration,start_time) ->
  MIDI.noteOn channel, pitch, vel, start_time
  MIDI.noteOff channel, pitch, start_time+duration

play_chord = (channel,pitches,vel,duration) ->
  for pitch in pitches
  	play_note channel,pitch,vel,duration
	

arpegio = (channel,pitches,vel,speed,duration) ->
  for pitch,index in pitches
  	plan_note channel,pitch,vel,duration,speed*index

MIDI.loadPlugin
  soundfontUrl: "./soundfont/"
  instrument: "acoustic_grand_piano"
  callback: () ->
	# console.log "MIDI loaded !! "