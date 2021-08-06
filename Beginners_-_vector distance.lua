-- Vector Distance

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    -- distance is good way to find collision between circles. collisions!
    
    -- get the distance from 2 vectors inside a
    a = vec2(0,0):dist(vec2(100,100))
    -- print the vector values in the console
    print (a)    
    b = vec2(0,0)
    c = vec2(100,100)
    -- get distance squared(slower?) into a
    a = b:distSqr(c)
    print(a)
    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)
    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end
