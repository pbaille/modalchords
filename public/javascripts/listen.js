
	MIDI.loadPlugin({
		soundfontUrl: "./soundfont/",
		instrument: "acoustic_grand_piano",
		callback: function() {}
	});

	play_note = function(channel,pitch,vel,duration){
		MIDI.noteOn(channel, pitch, vel, 0);
		MIDI.noteOff(channel, pitch, duration);
	}

	plan_note = function(channel,pitch,vel,duration,start_time){
		MIDI.noteOn(channel, pitch, vel, start_time);
		MIDI.noteOff(channel, pitch, start_time+duration);
	}

	play_chord = function(channel,pitches,vel,duration){
		for (index = 0; index < pitches.length; ++index) {
    		play_note(channel,pitches[index],vel,duration);
		}
	}
	arpegio = function(channel,pitches,vel,speed,duration){
		console.log("pitches");

		for (index = 0; index < pitches.length; ++index) {
			console.log(pitches[index]);
    		plan_note(channel,pitches[index],vel,duration,speed*index);
		}
	}
    	
    	
