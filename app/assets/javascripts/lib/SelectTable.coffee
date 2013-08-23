class SelectTable
  constructor: (opt) ->
    @el = $(opt.el)
    @hash = opt.hash
    @selected = null
    @el.addClass("STwrapper")
    
    
    for k,v of @hash

      @el.append("<div class='STrow'></div>")
      lab = @el.find('.STrow').last()

      lab
        .css('text-align','center')
        .css('display','inline-block')

      lab.append("<div class='STtitle STcase'>#{k}</div>")  
      for e in v
        lab.append("<div class='STelement STcase'>#{e.toString()}</div>")	

    elems= @el.find('.STelement')
    for c in elems
      do () =>
        elem = $(c)
        elem.bind "click", () =>
          elems.removeClass("selected")
          elem.addClass("selected")
          @selected = elem.text().trim()
          console.log @selected	

  get_val: ->
    @selected