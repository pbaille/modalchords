class SelectBox  

  constructor: (opt) ->

  	##### VARS ######

    if opt.mother then @mother= $(opt.mother) else @mother= $(opt)

    @value= "default"

    ##### APPEND CONTENT ########
    @mother.empty() if opt.content

    placeholder = opt.placeholder || "select..."
    @mother.append("<div class='item placeholder'>#{placeholder}</div>")
    if opt.content
      #console.log opt.content
      for k,v of opt.content
        if typeof v == 'string'
          @mother.append("<div class='item'>#{v}</div>")
        else
          new_group= $("<div class='item group'>#{k}</div>")
          for val in v
            new_group.append ("<div class='item sub'>#{val}</div>") 
          @mother.append new_group

    ############################

    open= false
    
    items = @mother.find(".item").not('.sub')
    regular_items = items.not('.placeholder').not('.group')
  
    n_items = items.length
  
    item_height = opt.height || 28
    item_margin = opt.margin || 6
    item_width = opt.width || 160

    closed_height = item_height + 2 * item_margin
    open_height = n_items * item_height + (n_items+1) * item_margin
    current_height= open_height

    open_group= null
  
    theme= ['#423A38', '#47B8C8' , '#E7EEE2' , '#BDB9B1' ,'#D7503E']
    
    # create wrapper
    unless @mother.parent().hasClass("select-box-wrap")
      @mother.wrap("<div class=\"select-box-wrap\" style=\"height: #{closed_height}px; width: #{item_width}px;\" />")

    #dimensioning
    @mother
      .css("height", "#{closed_height}px")
      .css("width", "#{item_width}px")
      .css("display", "inline-block")

    @mother.find(".item")
      .css("height", "#{item_height}px")
      .css("width", "#{item_width - 2 * item_margin}px")
      .css("margin","#{item_margin}px")
      .css("line-height", "#{item_height}px")


    ##### EVENTS #####
      #simple-sb
    @mother.mouseenter ->
      $(this).addClass "hover" 
    @mother.mouseleave ->
      $(this).removeClass "hover"   

    @mother.find(".placeholder").click ->
      if open
        $(this).parent().css('height', "#{closed_height}px")
        open = false
      else	
        $(this).parent().css('height', "#{current_height}px")
        open = true

    @mother.bind "mouseleave", (e) =>
      cb= =>
        unless @mother.hasClass("hover")
          @mother.css('height', "#{closed_height}px")
          open = false  
      setTimeout cb, 1000    
  
    regular_items.add('.sub').mouseenter ->
      $(this).addClass('hov')
  
    regular_items.add('.sub').mouseleave ->
      $(this).removeClass('hov')
  
    regular_items.add('.sub').bind "click", (e) =>
      ct= $(e.currentTarget)
      ct.parent().find('.placeholder').html(ct.text())
      @value = ct.text().trim()
      #poly-depth-sb

    @mother.find('.sub').hide() 

    @mother.find(".group").click ->

      childs = $(this).children('.sub')
      ch_len= childs.length
      #childs to replace inside parent
      rem_ch= $(this).parent().find('.sub').not('.group .sub')

      #if group has childs then it is closed so we open it
      if ch_len != 0
      	#replace open group's child inside it before open another group
      	if rem_ch.length != 0
          rem_height= parseInt(rem_ch.length * (item_height + item_margin))
          current_height -= rem_height
          $(this).parent().css('height', "#{current_height}px")
          rem_ch.hide()
          open_group.append(rem_ch)

        open_group= $(this)
        childs_height= parseInt(ch_len * (item_height + item_margin))
        current_height += childs_height
  
        $(this).after(childs)
        childs.show()
        	
        $(this).parent().css('height', "#{current_height}px")

      #if group has no childs then it is open so we close it   
      else
        open_group= null
        childs= $(this).parent().find('.sub').not('.group .sub')
        ch_len= childs.length
        childs_height= parseInt(ch_len * (item_height + item_margin))
        current_height -= childs_height
        $(this).append(childs)
        childs.hide()
        $(this).parent().css('height', "#{current_height}px")
        $(this).addClass('closed') 
