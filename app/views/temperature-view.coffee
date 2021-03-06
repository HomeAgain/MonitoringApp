###
    Need documentation, after render function for processing.
    
###

module.exports = class TemperatureView extends Backbone.Marionette.ItemView
    id: 'temperature-view',
    template: 'views/templates/temperature',
    
    initialize: ->
        this.model.on(
            'change',
            () -> 
                if(!@p)
                    @render
                else
                    @p.temperatureEnd = Math.round(@model.get("data")[0].value)
                    @p.loop()
            ,
            @
        )

    events: 
        'click #refresh' : 'refresh'

    refresh : ->

    render : =>
        
        if(!@p)
            super
            canvas = @$el.find(".canvas").get(0)
            @p = new Processing(canvas, @sketchProc);
        @p.width = @$el.width()
       
        if @model.get("data").length > 0
            @p.temperatureEnd= Math.round(@model.get("data")[0].value)
        else
            @p.temperatureEnd= Math.round(0)
        
        
        #p.temperature = @model.get("value")

    sketchProc: (p)->

        
        p.setup= ->
            
            @temperature = 0
            @temperatureEnd = 0
            @width = 176
            
            p.size @width, @width
            # Draw arc
            #  
            @drawArc(@temperature)
            
        p.draw=->

            @width = jQuery("div.col-lg-4").width()
            
            p.size @width, @width
            if (@temperatureEnd != @temperature)
              if( @temperatureEnd > @temperature)
                @temperature += 1
              else if( @temperatureEnd < @temperature)
                @temperature -= 1
            else
                p.noLoop()
              
            @drawArc(@temperature)  
            

        p.drawArc= (temperature)->
            # Set background
            p.background 0, 0

            if (temperature > 26)
              p.color c = p.color 220, 0, 0
            else if (temperature < 18)
              p.color c = p.color 0, 0, 220
            else
              p.color c = p.color 0, 220, 0
            
            p.fill c
            p.noStroke()
            p.arc p.width/2, p.width/2, p.width*12/16, p.width*12/16 , -p.PI/2, (temperature/50)*12/8*p.PI
            
            # Draw center cicle to hide part of the arc
            p.color c = p.color 37, 44, 53
            p.fill c
            p.noStroke()
            p.ellipse p.width/2, p.width/2, p.width*10/16, p.width*10/16
            
            # Write temperature
            p.color c = p.color 255
            p.fill c
         
            p.textSize 40
            p.textAlign p.CENTER, p.CENTER
            p.text @temperature.toString() + "°C", p.width/2, p.width/2

