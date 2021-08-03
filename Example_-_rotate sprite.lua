


-- create a image

im = image(100,100)
angle = 0
-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    -- 
    setContext(im) -- draw into image(im)
    fill(255)-- white color non transparent
    rect(0,0,100,10) -- draw a line
    rect(0,90,100,10)
    
    setContext()-- restore context
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background
    background(40, 40, 40)
    
    angle=angle+1
    if angle>359 then 
        angle=0
    end
    pushMatrix()
    translate(160,300)
    rotate(angle)
        sprite(im,0,0)
    popMatrix()
end
