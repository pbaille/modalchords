class MongoidChord
    include Mongoid::Document

	field :name
  field :root, type: Integer
	field :pitches, type: Array
	field :functs, type: Array
	field :tab, type: Array
	field :display, type: Array
  field :tuning, type: Array
  field :tab_index, type: Integer
  field :tab_width, type: Integer

	has_and_belongs_to_many :mongo_users

  def self.create_form_CMF chordMF, name
    c= MongoidChord.new_from_CMF chordMF, name
    c.save
    c
  end

  def self.new_from_CMF chordMF, name
    MongoidChord.new({
      :name => name,
      :root => chordMF.root,
      :pitches => chordMF.pitches,
      :functs => chordMF.functs,
      :tab => chordMF.tab,
      :display => chordMF.display_format,
      :tab_index => chordMF.tab_index,
      :tab_width => settings.position_max_width,
      :tuning => settings.tuning
    }) 
  end  
    
end	

get "/save_edited_chord/:pitches/:tab/:name" do
  content_type(:json)

  pitches = JSON.parse(params[:pitches])
  tab = JSON.parse(params[:tab])

  chord= ChordMF.new(pitches, :tab => tab)
  m_chord= MongoidChord.create_form_CMF chord, params[:name]

  current_user.mongoid_chords.push m_chord
  m_chord.to_json
end  

get "/update_edited_chord/:_id/:pitches/:tab/:name" do
  content_type(:json)

  pitches = JSON.parse(params[:pitches])
  tab = JSON.parse(params[:tab])
  chord_to_update= current_user.mongoid_chords.where(_id: params[:_id]).first

  chord= ChordMF.new(pitches, :tab => tab)
  m_chord= MongoidChord.new_from_CMF chord, params[:name] 
  
  chord_to_update.update_attributes(
    name: m_chord.name,
    root: m_chord.root,
    pitches: m_chord.pitches, 
    functs: m_chord.functs, 
    tab: m_chord.tab, 
    display: m_chord.display, 
    tab_index: m_chord.tab_index 
  )

  chord_to_update.save()
  chord_to_update.to_json

end 

get "/delete_all_user_chords" do
  current_user.mongoid_chords.each do |c|
    c.destroy
  end 

end  
#################### JSON API ############################

#INDEX
get "/user_chords" do
  content_type(:json)
  ts=current_user.mongoid_chords 
  ts.to_json
end

#GET
get "/user_chords/:_id" do
  content_type(:json)

  t=current_user.mongoid_chords.where(_id: params[:_id]).first
  t=MongoidChord.where(_id: params[:_id]).first() unless t

  t.to_json
end

#UPDATE
put "/user_chords/:_id" do
  content_type(:json)
  request_body = JSON.parse(request.body.read.to_s).reject{|k,v| k == "splat" or k == "captures"}
  
  t=current_user.mongoid_chords.where(_id: params[:_id]).first() 

  t.update_attributes(request_body)

  if t.save
    t.to_json
  else
    halt 500
  end

end 

#NEW 
post "/user_chords" do
  content_type(:json)
  request_body = JSON.parse(request.body.read.to_s)

  t=MongoidChord.new request_body
  if t.save
    current_user.mongoid_chords.push t
    t.to_json
  else
    halt 500
  end  
end  

#DELETE
delete "/user_chords/:_id" do
  content_type(:json)
  t= MongoidChord.where(_id: params[:_id])

  if t.destroy
    {:success => "ok"}.to_json
  else
    halt 500
  end
end


