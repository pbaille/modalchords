class SettingsView extends Backbone.View

  className: "search-settings-view"

  initialize: ->
    _.bindAll(this, 'render')

  events: 
    "click .toggle.blue": "toggle_mode_selector"
    "click .toggle.orange": "toggle_struct_selector"
    "click .toggle.grey": "toggle_search_options"
    "click .mode_selector .STelement": "update_mode"
    "click .struct_selector .STelement": "update_struct"
    "mouseleave .search_options": "update_options"

  search_options_template: window.HAML['settings_template']

  render: ->
    @$el.html "
    <div class='toggles_wrap'><div class='toggles'>
    	<div class='toggle blue'></div>
    	<div class='toggle orange'></div>
    	<div class='toggle grey'></div>
    </div></div>
    <div class='mode_selector_wrap'><div class='mode_selector'></div></div>		
    <div class='struct_selector_wrap'><div class='struct_selector'></div></div>		
    <div class='search_options_wrap'><div class='search_options'></div></div>		
    "
    setTimeout @init_elements , 300
    @$el.find('.search_options').html(@search_options_template(@model.toJSON()))
    @init_cycle_boxes()
    @init_inc_boxes()
    this

  init_elements: =>
    @mode_selector= new SelectTable
      el: @$el.find(".mode_selector")
      hash: @model.get('mother_scales')	

    @struct_selector= new SelectTable
      el:  @$el.find(".struct_selector")
      hash: @limited_partials()

  refresh_struct_selector: ->
    @$el.find('.struct_selector').empty()
    @struct_selector= new SelectTable
      el: @$el.find(".struct_selector")
      hash: @limited_partials()  

  init_cycle_boxes: ->
    @tp_box = new CycleBox {mother: @$el.find("#twin-pitches .cycle-box"), values:[null,false,true]} 
    @os_box = new CycleBox {mother: @$el.find("#open-strings .cycle-box"), values:[null,false,true]}
    @iv_box = new CycleBox {mother: @$el.find("#inversions .cycle-box"),   values:[null,false,true]}
    @b9_box = new CycleBox {mother: @$el.find("#b9 .cycle-box"),           values:[null,false,true]}

  init_inc_boxes: ->

    @fb_min_ib= new IncBox
      el: @$el.find('#fb_min')
      current: @model.get('fb_min_fret')
      min: 1
      max: @model.get('cases_nb')

    @fb_max_ib = new IncBox
      el: @$el.find('#fb_max')
      current: @model.get('fb_max_fret')
      min: @model.get('fb_min_fret')
      max: @model.get('cases_nb')

    @position_max_width_ib = new IncBox
      el: @$el.find('#position_max_width')
      current: @model.get('position_max_width')
      min: 3
      max: 6

    @bass_max_step_ib = new IncBox
      el: @$el.find('#bass_max_step')
      current: @model.attributes.chord_filters['bass_max_step']

    @max_step_ib = new IncBox
      el: @$el.find('#max_step')
      current: @model.attributes.chord_filters['max_step']     

  limited_partials: ->
    lim= {}
    _.each @model.get('partials'), (v,k) ->
      lim[k]= v.slice(0,5).map((x)-> x.toString().replace(/,/g," ")) unless k == "6"
    lim
  
  toggle_mode_selector: ->
  	if @$el.find(".mode_selector_wrap").is(':visible')
  	  @$el.find('.blue').removeClass('open')	
  	  @$el.find(".mode_selector_wrap").slideUp()
  	else  
  	  @$el.find('.blue').addClass('open')	
  	  @$el.find(".mode_selector_wrap").detach().insertAfter(@$el.find('.toggles_wrap')).slideDown()

  toggle_struct_selector: ->
  	if @$el.find(".struct_selector_wrap").is(':visible')
  	  @$el.find('.orange').removeClass('open')	
  	  e= @$el.find(".struct_selector_wrap").slideUp()
  	else
  	  @$el.find('.orange').addClass('open')	
  	  @$el.find(".struct_selector_wrap").detach().insertAfter(@$el.find('.toggles_wrap')).slideDown()

  toggle_search_options: ->	 
  	if @$el.find(".search_options_wrap").is(':visible')
  	  @$el.find('.grey').removeClass('open')	
  	  e= @$el.find(".search_options_wrap").slideUp()
  	else
  	  @$el.find('.grey').addClass('open')	
  	  @$el.find(".search_options_wrap").detach().insertAfter(@$el.find('.toggles_wrap')).slideDown() 

  update_mode: ->

    dsh= @model.get('degree_status_hash')
    val= @mode_selector.get_val()
    console.log val
    km= @model.get('known_modes')
    new_mode= km[val]

    for k,v of dsh
      dsh[k]= new_mode[k] + " " + v.split(" ")[1] if new_mode[k]
    
    @model.set
      degree_status_hash: dsh
      mode_name: @model.get('mode_name').split(" ")[0] + " " + val
    
    success_cb= =>
      @refresh_struct_selector()
      @mother.renderStruct()

    @model.save({}, {success: success_cb})    

  update_struct: ->

    console.log "update_struct"
    dsh= @model.get('degree_status_hash')
    degrees_names= Object.keys(dsh) 
    val= @struct_selector.get_val().split(" ")
    h= {}
    for d in val
      h[degrees_names[parseInt(d[1])-1]]= d + " enabled"
    
    for k,v of dsh
      dsh[k]= v.split(" ")[0]+" disabled"
      dsh[k]= h[k] if h[k] 
    dsh["root"]= dsh["root"].split(" ")[0]+" uniq"
    @model.set
      degree_status_hash: dsh
  
    @mother.renderStruct()

    @model.save()

  update_options: (e) ->
    cb = =>
      cf= @model.get('chord_filters')

      cf['bass_max_step']= @bass_max_step_ib.get_val()
      cf['max_step']= @max_step_ib.get_val()
      cf['inversions']= @iv_box.get_val()
      cf['b9']= @b9_box.get_val()
      cf['open_strings']= @os_box.get_val()
      cf['twin_pitches']= @tp_box.get_val()


      @model.set
        chord_filters : cf 
        fb_min_fret: @fb_min_ib.get_val() 
        fb_max_fret: @fb_max_ib.get_val()
        position_max_width: @position_max_width_ib.get_val()

      console.log @model.attributes

    setTimeout cb, 250
