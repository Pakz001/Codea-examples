-- Clip Scissor

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    -- set a area in the center of
    -- the screen that can be drawn
    -- into. outside this area
    -- nothing wil be drawn
    clip(WIDTH/2-50,HEIGHT/2-50,100,100)
    for i=0,1,200 do
        rect(math.random(0,WIDTH),math.random(0,HEIGHT),200,200)
    end
    -- set the clipping/scissor mode
    -- back to default(no clipping)
    clip()
    -- draw some text to the left
    -- top of the screen
    textMode(CORNER)
    text("clip example.",0,HEIGHT-20)
end
