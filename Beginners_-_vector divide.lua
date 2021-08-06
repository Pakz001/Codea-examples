-- Vector Divide

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    -- create our vector in variable a
    a = vec2(100,100)
    -- divide the vectors by the value 10
    a = a / 10
    -- print out our new vector values(x,y)
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

