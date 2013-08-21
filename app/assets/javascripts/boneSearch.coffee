class UserSearch extends Backbone.Model
  idAttribute: '_id'
  paramRoot: 'api/searches'
  urlRoot: "/api/searches"

  state_classes: ["enabled", "uniq", "optional", "disabled"]

  initialize: ->
    @degrees= 
      root: 
        names: ["C","Db","D","Eb","E","F","Gb","G","Ab","A","Bb","B"]
      second  : 
        names: ["m2", "M2", "\#2"]
      third   : 
        names: ["o3", "m3", "M3", "\#3"]
      fourth  : 
        names: ["b4", "P4", "+4"]  
      fifth: 
        names: ["b5", "P5", "+5"]   
      sixt    : 
        names: ["m6", "M6", "\#6"]  
      seventh : 
        names: ["o7", "m7", "M7"]



##########################################################################################################
#################################### VIEW ################################################################

class UserSearchView extends Backbone.View

  className: "search"

  initialize: ->
    _.bindAll(this, 'render')
    @model.bind('refresh', @render)
    #@model.on('refresh_struct', @renderStruct)

  struct_template: window.HAML['struct_template']
  settings_template: window.HAML['settings_template']
  tuning_template: window.HAML['tuning_template']
  #mode_menu_template: window.HAML['mode_menu_template']

  events: 
    #icons
    "click i.icon-cancel-2": "delete_search"
    "click i.icon-rocket": "load_search"
    "click i.icon-cog-1": "toggle_options"
    "click i.icon-tumbler": "toggle_tuning"
      #main
    "click i.icon-heart-1": "save_search"
    "click i.icon-refresh": "search"

    #struct
    "click .main": "cycle_status"
    "click .bub": "alt_degree"
    "mouseenter .wrapper": "show_degree_control"
    "mouseleave .wrapper": "hide_degree_control"
    "click .little_circle": "assign_status"
    "mouseenter #struct-wrap, .wrapper " : "show_mode_menu_toggle"
    "mouseleave #struct-wrap " : "hide_mode_menu_toggle"
    "click i.icon-down-open" : "toggle_mode_menu"

    #options   
    "mouseleave #options-wrapper": "update_options"

    #tuning
    "mouseleave #tuning-wrapper": "update_tuning"
    "click #tuning-wrapper #strings": "nb_strings_update"

    #select_boxes
    "click #struct-selector .item": "update_struct"
    "click #mode-selector .item": "update_mode"
    "click .close_button" : "toggle_mode_menu"

  render: ->

    @$el.html("<div id='tuning-menu'></div><div id='struct-wrap'></div><div id='mode-menu-wrap'></div><div id='options-wrapper'></div>")
    unless @model.get('name') == "user_current_search"
      @$el.prepend("<div class='user-search-name'>#{@model.get('name')}</div>")
    @renderTuning()
    @renderStruct()
    @renderModeMenu()
    @renderOptions()
    @hideControls()
    this

  ### SUB-RENDER #######

  renderStruct: =>
    @$el.find('#struct-wrap').html(@struct_template(@model.toJSON()))
    @hide_stuffs()
    @degrees_init() 
    this

  renderModeMenu: =>
    @$el.find('#mode-menu-wrap').empty().append("<div id='mode-menu'><div class='select-box' id='mode-selector'></div><div class='select-box' id='struct-selector'></div><div class='close_button'><i class='icon-cancel-circled2'/></div></div>")
    setTimeout @init_select_boxes, 30
    this

  renderTuning: =>
    @$el.find('#tuning-menu').html(@tuning_template(@model.toJSON()))
    @init_tuning_boxes()
    this

  renderOptions: =>
    @$el.find('#options-wrapper').html(@settings_template(@model.toJSON()))
    @init_cycle_boxes()
    @init_inc_boxes()
    this
  
  ####

  hideControls: =>  
    @$el.find('#options-wrapper').hide()
    @$el.find('#tuning-menu').hide()
    @$el.find('#mode-menu-wrap').hide()

  delete_search: ->
    @$el.remove()
    @model.destroy()

  update_model: (callback)->
    dsh= {}
    degs= @model.degrees
    stat= @model.state_classes

    get_val= (id) ->
      dsh[id] = degs[id].names[degs[id].current] + " " + stat[degs[id].state]

    get_val d for d of degs

    @model.set("degree_status_hash", dsh) 
    if callback then @model.save({}, {success: callback}) else @model.save()

  save_search: ->
    router.app.modals.pop_search_naming() 

  load_search: ->

    callback= =>  
      coll= router.app.usc
      current_search= coll.filter((s) -> s.attributes.name == "user_current_search")[0]
      search_to_load= $.extend(true, {}, @model.toJSON())
      delete search_to_load._id
      delete search_to_load.name

      after_transfer = =>
        $.get "/load_current_search", (r) ->
          router.navigate('', {trigger: true})
          router.app.searchResults.fetch({reset: true})

      current_search.save(search_to_load, {success: after_transfer})
      current_search.trigger('refresh')

    @update_model(callback)

  search: ->
    #console.log "search"
    callback= () ->
      $.get "/load_current_search", (r) ->
        router.app.searchResults.fetch({reset: true})

    @update_model(callback)
    

  ############# INITS #########################################

  degrees_init: ->
    di= (id) =>
      current_el= @$el.find("#struct_form_wrap ##{id}")
      infos= @model.get('degree_status_hash')[id].split(" ")
      status= infos[1]
      name= infos[0]
  
      @model.degrees[id].state = @model.state_classes.indexOf(status)
      @model.degrees[id].current = @model.degrees[id].names.indexOf(name)
  
      current_el.find(".main b").html(name)  
      current_el.find(".main").removeClass('uniq enabled disabled optional').addClass(status) 
      current_el.find(".bub").removeClass('uniq enabled disabled optional').addClass(status)

    di(i) for i of @model.degrees 

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

  init_tuning_boxes: ->

    @strings_nb_ib = new IncBox
      el: @$el.find('#tuning-wrapper #strings')
      current: @model.get('strings_nb')
      min: 4
      max: 8   

    @tuning_midi_boxes= new Array(8)
    for num,index in ["one", "two", "three", "four", "five", "six", "seven", "eight"]
      @tuning_midi_boxes[index]= new MidiBox
        el: @$el.find("#tuning ##{num}")  
        pitch: @model.attributes.tuning[index]

  init_select_boxes: => 
    @struct_selector = new SelectBox
      mother: @$el.find("#struct-selector")
      placeholder: "Sub-structures"
      content: @model.get('partials')
  
    @mode_selector = new SelectBox
      mother: @$el.find("#mode-selector")
      placeholder: "Select mode"
      content: @model.get('mother_scales')  

  refresh_struct_box: =>
    @struct_selector = new SelectBox
      mother: @$el.find("#struct-selector")
      placeholder: "Sub-structures"
      content: @model.get('partials')     

  #################### UI CONTROLS ###################

  ######### STRUCT ###########

  hide_stuffs: ->
    @$el.find('.bub').hide()
    @$el.find('.state-selector-wrap').hide()
    @$el.find('#struct_form_wrap #mode-menu-toggle').hide()

  cycle_status: (e) ->
    id = $(e.currentTarget).parent().attr("id")
    @model.degrees[id].state= (@model.degrees[id].state+1) % @model.state_classes.length
    k= @model.state_classes[@model.degrees[id].state]
    $(e.currentTarget).removeClass('uniq enabled disabled optional').addClass k
    $(e.currentTarget).parent().find(".bub").removeClass('uniq enabled disabled optional').addClass k 

  show_degree_control: (e) -> 
    $(e.currentTarget).find('.bub').show()
    $(e.currentTarget).find('.state-selector-wrap').show()

  hide_degree_control: (e) -> 
    $(e.currentTarget).find('.bub').hide()
    $(e.currentTarget).find('.state-selector-wrap').hide()  
  
  current_change: (p,mod) ->
    id= p.parent().attr("id")
    deg= @model.degrees[id]
    deg.current= (deg.current+mod+deg.names.length)%deg.names.length
    content= deg.names[deg.current]
    p.parent().find('.main b').html(content)

  alt_degree: (e) ->
    if $(e.currentTarget).hasClass('top')
      @current_change($(e.currentTarget),1)
    else  
      @current_change($(e.currentTarget),-1)
  
  assign_status: (e) ->
    id = $(e.currentTarget).parent().parent().attr("id")
    if $(e.currentTarget).hasClass('enabled')
      @model.degrees[id].state = 0
      k= @model.state_classes[0]
    if $(e.currentTarget).hasClass('uniq')
      @model.degrees[id].state = 1
      k= @model.state_classes[1]
    if $(e.currentTarget).hasClass('optional')
      @model.degrees[id].state = 2
      k= @model.state_classes[2]
    if $(e.currentTarget).hasClass('disabled')
      @model.degrees[id].state = 3
      k= @model.state_classes[3]        
    $(e.currentTarget).parent().parent().find('.main').removeClass('uniq enabled disabled optional').addClass k
    $(e.currentTarget).parent().parent().find(".bub").removeClass('uniq enabled disabled optional').addClass k

  show_mode_menu_toggle: () ->
    if @model.get('name') == "user_current_search"
      @$el.find('#struct_form_wrap #mode-menu-toggle').slideDown() unless @$el.find('#mode-menu-wrap').is(":visible")
  hide_mode_menu_toggle: () ->  
    @$el.find('#struct_form_wrap #mode-menu-toggle').slideUp()

  ############## OPTIONS ###############

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

  toggle_options: (e) ->

    ow= @$el.find('#options-wrapper')
    mm= @$el.find('#mode-menu-wrap')

    if ow.is(":visible")
      ow.slideUp()
      mm.slideUp() unless @model.get('name') == "user_current_search"
    else
      @hide_mode_menu_toggle()
      ow.slideDown()
      mm.slideDown()

  ############ TUNING ##############

  update_tuning: ->
    #cb= =>
    s = @strings_nb_ib.get_val()
    tuning = []
    for e,i in @tuning_midi_boxes
      do (e,i) =>
        tuning.push e.get_val() if i < s

    console.log tuning
    @model.set {tuning: tuning}
    @model.save()

    #setTimeout cb, 50 

  nb_strings_update: ->
    cb= =>
      @model.set {strings_nb: @strings_nb_ib.get_val()}
      @model.save()
      @renderTuning()

    @update_tuning()  
    setTimeout cb, 250

  toggle_tuning: ->
    tm= @$el.find('#tuning-menu')

    if tm.is(":visible")
      tm.slideUp()
    else
      tm.slideDown()

  ########### MODE MENU ############
  toggle_mode_menu: () ->
    @hide_mode_menu_toggle()
    @$el.find('#mode-menu-wrap').slideToggle()

  update_struct: (e) ->

    unless $(e.currentTarget).hasClass("placeholder") or $(e.currentTarget).hasClass("group")

      dsh= @model.get('degree_status_hash')
      degrees_names= Object.keys(dsh) 
      val= @struct_selector.value.split(",")
      h= {}
      for d in val
        h[degrees_names[parseInt(d[1])-1]]= d + " enabled"
      
      for k,v of dsh
        dsh[k]= v.split(" ")[0]+" disabled" 
        dsh[k]= h[k] if h[k] 
  
      @model.set
        degree_status_hash: dsh
  
      @renderStruct()

      @model.save()
        
  update_mode: (e) ->

    unless $(e.currentTarget).hasClass("placeholder") or $(e.currentTarget).hasClass("group")
      dsh= @model.get('degree_status_hash')
      val= @$el.find('#mode-selector .placeholder').text().trim()
      # console.log "val"
      # console.log val
      km= @model.get('known_modes')
      new_mode= km[val]

      for k,v of dsh
        dsh[k]= new_mode[k] + " " + v.split(" ")[1] if new_mode[k]
      
      @model.set
        degree_status_hash: dsh
        mode_name: @model.get('mode_name').split(" ")[0] + " " + val
      
      success_cb= =>
        @refresh_struct_box()
        @renderStruct()

      @model.save({}, {success: success_cb})
             
##############################################################################################################
class UserSearchColl extends Backbone.Collection
  model: UserSearch
  url: "/api/searches"
  


#############################################################################################################
class SearchCollView extends Backbone.View
  collection: UserSearchColl
  initialize: ->
    @collection.on('add', @addOne, this)
    @collection.on('reset', @addAll, this)
  render: ->
    
    @addAll()
  addAll: ->
    @$el.empty()
    $('#user-area').hide()
    @collection.forEach @addOne, this  
  addOne: (item) ->
    itemView = new UserSearchView {model: item}
    if item.get('name') == "user_current_search"
      $('#main-search').html(itemView.render().el)
    else 
      $('#user-searches').append(itemView.render().el)
        
 
      
    
    
     











