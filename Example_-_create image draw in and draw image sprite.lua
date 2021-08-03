-- create a image

im = image(100,100)

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
    -- This sets a dark background color 
    background(40, 40, 50)
    -- draw 50 times
    for i = 0,50 do
        -- sprite is used to draw a image
        sprite(im,math.random(0,WIDTH),math.random(0,HEIGHT))
    end
