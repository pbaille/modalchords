class IncBox

  constructor: (opt) ->

    @el = $(opt.el)

    if opt.values
      @values= opt.values.split(" ")
    else
      @values = []
      min= opt.min || 0
      max= opt.max || 127
      while min <= max
        @values.push min
        min++	  	

    if opt.index != undefined
      @index= opt.index
      @current= @values[@index]
    else if opt.current != undefined
      @current= opt.current
      @index = @values.indexOf(@current)
    else
      @index = 0
      @current = @values[0]  

    @el.html("<div class='arrow up hidden'></div><div class='arrow down hidden' > </div>")
    @el.addClass('incBoxWrapper')
    @el.append("<div class='incBoxDisplay'><b>#{@current}</b></div>")

    arrows= @el.find('.arrow')
    
    @el.on "mouseenter mouseleave",() =>
    	arrows.toggleClass('hidden')

    @el.find('.up').click () =>
      if @values[@index+1] != undefined then @index++ else @index = 0
      @current = @values[@index]
      @el.find('.incBoxDisplay b').html("#{@current}")

    @el.find('.down').click () =>
      if @values[@index-1] != undefined then @index-- else @index = @values.length - 1
      @current = @values[@index]
      @el.find('.incBoxDisplay b').html("#{@current}") 

  get_val: ->
    @current 

class MidiBox

  constructor: (opt) ->
    @el = $(opt.el)
    @pitch = opt.pitch || 60

    @el.addClass('midiBoxWrapper')
    @el.html("<div class='pitch_box'></div><div class='oct_box'></div>")	  
    @pitch_box = new IncBox
      el: @el.find('.pitch_box')
      values: "C Db D Eb E F Gb G Ab A Bb B"
      index: @pitch % 12
    @oct_box = new IncBox
      el: @el.find('.oct_box')
      min: -5
      max: 5
      current: Math.floor(@pitch / 12) - 5

  get_val: ->
    p = @pitch_box.get_val()
    o = @oct_box.get_val()
    add = (o+5)*12
    pitch = @pitch_box.values.indexOf p
    pitch + add