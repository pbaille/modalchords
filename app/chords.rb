require 'json'

get '/' do 
	haml :modal_chords, :layout => false
end

get '/user_area' do
  redirect "/"
end  

get '/search_results' do
	content_type(:json)
	cs= ChordSearch.new(
		FretboardSlice.new(settings.fb_min_fret,settings.fb_max_fret,settings.tuning),
		settings.mode_selector,
		{:max_width => settings.position_max_width},
		settings.filters_array
		)

	cs.search
	results = cs.chords.map {|x| MongoidChord.new_from_CMF x, "untitled" }

	if results.empty?
	  {}.to_json	
	else	
	  results.to_json
	end

end	
