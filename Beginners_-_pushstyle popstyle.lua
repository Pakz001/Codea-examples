
-- Pushstyle Popstyle

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)
    
    
    -- draw a rectangle
    rect(WIDTH/2,HEIGHT/2,WIDTH/4,HEIGHT/4)
    
    -- store our previous styles for drawing
    pushStyle()
    fill(159, 33, 26)-- drawing object color
    stroke(207, 174, 14)-- drawing object outline color
    strokeWidth(10)-- lines around object size
    -- draw a rectangle
    rect(WIDTH/2,HEIGHT/2+HEIGHT/4,WIDTH/4,HEIGHT/4)
    
    -- restore drawing styles that were stored
    popStyle()
    
    -- draw a rectangle
    rect(WIDTH/4,HEIGHT/2,WIDTH/4,HEIGHT/4)
    -- Do your drawing here
    
end
