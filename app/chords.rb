require 'json'

get '/' do 
	haml :modal_chords, :layout => false
end

get '/user_area' do
  redirect "/"
end  

get '/search_results' do
	content_type(:json)

	chord_search()
	results = settings.search_results.map {|x| MongoidChord.new_from_CMF x, "untitled" }

	results.to_json
end

module Sinatra
  module Helpers

  	def chord_search

  	  cs= ChordSearch.new(
	    FretboardSlice.new(settings.fb_min_fret,settings.fb_max_fret,settings.tuning),
	    settings.mode_selector,
	    {:max_width => settings.position_max_width},
	    settings.filters_array
	  )

	  cs.search
	  settings.search_results = cs.chords
  	end	

  end
end 	
