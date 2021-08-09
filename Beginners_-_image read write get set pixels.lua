-- Image Readpixel Writepixel

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    -- create image as im
    -- note that position 0 does not exist in lua. 1,1 and 100,100 are valid pixels.
    im = image(100,100)
    -- get or read pixel at 1,1 into the variables
    r,g,b,a = im:get(0,0)
    -- print them out
    print(r,g,b,a)
    -- set or write a pixel at position 1,1 as color. r,g,b,a is valid also
    im:set(1,1,color(114, 51, 176))
    -- get or read the pixel at position 1,1 again into variables
    r,g,b,a = im:get(1,1)
    -- print out the variables and keep some space between numbers
    print(r," ",g," ",b," ",a)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end
