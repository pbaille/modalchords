require "sinatra/json"

class Search
  include Mongoid::Document

  field :name 
  field :mode_name
  field :degree_status_hash, type: Hash
  field :tuning,             type: Array
  field :strings_nb,         type: Integer
  field :cases_nb,           type: Integer
  field :fb_min_fret,        type: Integer
  field :fb_max_fret,        type: Integer
  field :position_max_width, type: Integer
  field :chord_filters,      type: Hash
  field :partials,           type: Hash
  field :mother_scales,      type: Hash
  field :known_modes,        type: Hash

  belongs_to :mongo_user

  def self.create_from_current_settings name
    n=self.new_from_current_settings name
    n.save
    n
  end

  def self.new_from_current_settings name

    partials= settings.mode_selector.partials((3..6), false)
    partials.each do |k,v|
      partials[k]=v.map do |x|
        names = x[0].map {|e| settings.mode_selector.abstract.degrees_names[e]}
        [x[0], names]
      end  
    end

    mother_scales_degrees_hash= {}
    settings.mother_scales.each do |k,v|
      mother_scales_degrees_hash[k]= v[:degrees]
    end  

    self.new({
        :name => name,
        :mode_name => settings.mode_selector.name, 
        :degree_status_hash => settings.mode_selector.degree_status_hash,
        :tuning => settings.tuning,
        :strings_nb => settings.strings_nb,
        :cases_nb => settings.cases_nb,
        :fb_min_fret => settings.fb_min_fret,
        :fb_max_fret => settings.fb_max_fret,
        :position_max_width => settings.position_max_width,
        :chord_filters => settings.chord_filters,
        :partials => partials,
        :mother_scales => mother_scales_degrees_hash,
        :known_modes => settings.known_modes
        })
  end

  def partials_calc #WIP
    ms= ModeSelector.new_from_degree_status_hash(self[:degree_status_hash])
    partials= ms.partials((3..6), false)

    partials.each do |k,v|
      partials[k]=v.map do |x|
        x[0].map {|e| ms.abstract.degrees_names[e]}
      end  
    end
    self.update_attributes(partials:  partials)
    self.update_attributes(mode_name: ms.name)
  end 

end

############# CURRENT SEARCH #################

get '/current_search' do
  content_type(:json)
  user= MongoUser.where(_id: session[:user]).first
  if user
    t=user.searches.where(name: "user_current_search").first()
    unless t
      t= Search.create_from_current_settings("user_current_search")
      user.searches.push t
    end
    t.to_json
  else {message: "not logged"}.to_json 
  end
    
end

get '/load_current_search' do

    current_search= current_user.searches.where(name: "user_current_search").first

    settings.mode_selector = ModeSelector.new_from_degree_status_hash(current_search[:degree_status_hash])
    settings.search_results = []
    settings.mode_partials = {}
    settings.chord_filters = current_search[:chord_filters].inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

    settings.strings_nb = current_search[:strings_nb]
    settings.cases_nb = current_search[:cases_nb]
    settings.tuning = current_search[:tuning]

    settings.fb_min_fret = current_search[:fb_min_fret]
    settings.fb_max_fret = current_search[:fb_max_fret]
    settings.position_max_width = current_search[:position_max_width]

    "loaded"
 end

get '/save_search/:name' do
  content_type(:json)
  p params[:name]
  s=Search.create_from_current_settings(params[:name])
  if s
    user= MongoUser.where(_id: session[:user]).first
    user.searches.push s
  end 
  s.to_json
end

################# USER SEARCHES ####################

#INDEX
get "/api/searches" do
  content_type(:json)
  user= MongoUser.where(_id: session[:user]).first
  ts=user.searches 
  ts.to_json
end

#GET
get "/api/searches/:_id" do
  content_type(:json)
  user= MongoUser.where(_id: session[:user]).first

  t=user.searches.where(_id: params[:_id]).first
  t=Search.where(_id: params[:_id]).first() unless t

  t.to_json
end

#UPDATE
put "/api/searches/:_id" do
  content_type(:json)
  request_body = JSON.parse(request.body.read.to_s).reject{|k,v| k == "splat"}
  user= MongoUser.where(_id: session[:user]).first
  t=user.searches.where(_id: params[:_id]).first() 

  t.update_attributes(request_body)
  t.partials_calc()

  if t.save
    t.to_json
  else
    halt 500
  end

end 

#NEW #useless
post "/api/searches" do
  content_type(:json)
  request_body = JSON.parse(request.body.read.to_s)
  user= MongoUser.where(_id: session[:user]).first

  t=Search.new(name: request_body["name"],content: request_body["content"])
  if t.save
    t.to_json
  else
    halt 500
  end  
end  

#DELETE
delete "/api/searches/:_id" do
  content_type(:json)
  t= Search.where(_id: params[:_id])

  if t.destroy
    {:success => "ok"}.to_json
  else
    halt 500
  end
end  
  



