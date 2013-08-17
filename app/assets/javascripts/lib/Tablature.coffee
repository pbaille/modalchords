class Tablature 

  constructor: (opt) ->

    @mother= $(opt.mother)
    @strings_nb= opt.strings_nb
    @frets_nb= opt.frets_nb
    @start_fret= opt.start_fret
    @tuning= opt.tuning
    @chord= opt.chord
    @pitches= []

    #pitches calc
    @chord.forEach (e,i) =>
      unless e == null then @pitches[i]= @tuning[i]+ e else @pitches[i]= null  
  
    #create wrapper, main div and fret index
    @mother.addClass('tab-wrapper')
    @mother.prepend("<div class=\"tab x-#{@strings_nb} y-#{@frets_nb}\"></div>")
    @mother.find('.tab').append("<div class='fret_index'><b>#{@start_fret}</b></div>")

    #create cases with proper classes
    for num in [0..@strings_nb*(@frets_nb+1)-1]
    	coord=
    	  fret: Math.floor(num/@strings_nb)
    	  string: num%@strings_nb 

    	coord.fret += @start_fret-1 if coord.fret !=0

    	if num < @strings_nb
    	  @mother.find('.tab').append("<div class='case open-string string-#{coord.string} fret-#{coord.fret}'></div>") 
    	else  
    	  @mother.find('.tab').append("<div class='case string-#{coord.string} fret-#{coord.fret}'></div>")

    # cases ($)selector
    @cases= @mother.find(".case")

    # highlight chord notes
    for num,i in @chord
    	unless num == null
    	  @cases.filter(".string-#{i}.fret-#{num}").addClass('on')

      @mother.find('.tab').append("<div class='case num_bubble'><b class='funct'>#{if num != null then num else "X"}</b></div>")

    #play_method
    @mother.find('i.icon-play').bind 'click', () =>
      p= @pitches.filter (value) ->
        return value if value != null
      #arpegio function from listen.js
      arpegio(0,p,60,0.1,2)

    # editable tab
    if opt.editable == true

      #naming form
      @mother.find('#edited_chord_name').hide()
      @mother.find('i.icon-heart-1').bind 'click', () =>
        $('#edited_chord_name').show()

      #save edited chord  
      @mother.find('#edited_chord_name input[type*=submit]').bind 'click', () =>
        n = @mother.find('#edited_chord_name input[type*=text]').val()
        $.get "/save_edited_chord/#{JSON.stringify(@pitches)}/#{JSON.stringify(@chord)}/#{n}", (r) ->
          # closing modal
          $("#lean_overlay").fadeOut(200)
          $("#edit-chord-wrapper").css({ 'display' : 'none' })    

      for c in @cases
        do () =>
          elem= $(c)
          elem.bind 'click', () =>
 
            string= Number(elem.attr('class').split(' ').filter((x)-> x[0]=="s" )[0].match(/\d+/)[0])
            fret= Number(elem.attr('class').split(' ').filter((x)-> x[0]=="f" )[0].match(/\d+/)[0])
  
            @cases.filter(".string-#{string}").not(elem).removeClass('on')
  
            if elem.hasClass('on')
              elem.removeClass('on') 
              @chord[string]= null
            else
              elem.addClass('on')
              @chord[string]= fret
            console.log @chord
  
            @mother.find('.num_bubble').remove()
            for num,i in @chord
              @mother.find('.tab').append("<div class='case num_bubble'><b class='funct'>#{if num != null then num else "X"}</b></div>")

            #pitches update
            @chord.forEach (e,i) =>
              unless e == null then @pitches[i]= @tuning[i]+ e else @pitches[i]= null  

            #play method updated
            @mother.find('i.icon-play').unbind('click')
            @mother.find('i.icon-play').bind 'click', () =>
              p= @pitches.filter (value) ->
                return value != "" && value != null
              #arpegio function from listen.js
              arpegio(0,p,60,0.1,2)

              
