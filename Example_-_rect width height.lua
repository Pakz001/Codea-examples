
-- Test

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    
    -- WIDTH and HEIGHT are the size of the canvas, they are built in variables.
    
    -- draw a transparent rectangle with thick outer lines in the center of the screen
    strokeWidth(10)
    stroke(255,255,255,125)
    fill(0,0,0,125)-- r,g,b,alpha(0..255non transparent)
    rectMode(CENTER)
    rect(WIDTH/2,HEIGHT/2,100,100)
    -- draw a transparent rectangle with thick outer lines in the bottom left of the canvas
    rectMode(CORNER)
    rect(0,0,WIDTH/2,HEIGHT/2)
    
    -- draw a black non transparent rectangle top right in the screen.
    strokeWidth(0)
    stroke(0)
    rectMode(CORNER)
    rect(WIDTH-200,HEIGHT-200,200,200)
end

