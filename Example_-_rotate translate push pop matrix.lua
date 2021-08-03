
-- Test
angle=0
-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    angle=angle+1
    if angle>359 then
    angle=0
    end
    
    pushMatrix()
    translate(200,HEIGHT-100)
    rotate(angle)
    rectMode(CENTER)
    rect(0,0,100,100)
    popMatrix()
end
