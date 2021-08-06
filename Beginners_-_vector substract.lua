-- Vector Substract

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    -- create our vector
    a = vec2(10,5)
    -- substract the vector(its 2 values) from the values inside our vector a
    a = a - vec2(10,5)
    -- print out the vector values into the console.
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

