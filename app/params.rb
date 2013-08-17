#search
set :mode_selector => ModeSelector.new("C Lyd", {"root" => "uniq", "second" => "disabled","fifth" => "disabled","sixt" => "disabled"}),
    :search_results => [],
    :mode_partials => {}

set :chord_filters => {
	    :inversions => false,
        :max_step => 9,
        :bass_max_step => 16,
        :twin_pitches => false,
        :open_strings => nil,
        :b9 => false,
        :interval_range  =>[[1, 52],
                            [2, 51],
                            [3, 48],
                            [4, 46],
                            [5, 46],
                            [6, 46],
                            [7, 34],
                            [8, 43],
                            [9, 40],
                            [10,40],  
                            [11,40]]
                        }

set :filters_array => Proc.new {
  arr=[]
  chord_filters.each do |k,v|
  	if v != nil
  	  if k!= :interval_range
        arr<< ChordFilter.new(k,v) 
      else
        v.each {|args| arr<< ChordFilter.new(k,*args)}
      end
    end    	
  end
  arr 
}

# instrument
set :strings_nb => 6, 
    :cases_nb => 22,
    :tuning => [40,45,50,55,59,64]

# fingerings
set :fb_min_fret => 1, 
    :fb_max_fret => 12, 
    :position_max_width => 5

# tab_display
set :tab_width => 5, 
    :case_width => 20, 
    :case_height => 30

#utils
set :midi_notes => MK::MIDI_NOTES,
    :mother_scales => MK.regular_mothers,
    :known_modes => Mode.all_modes_degrees_names



