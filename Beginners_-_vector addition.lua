-- Vector Addition

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    -- add vectors up
    -- for things like updating sprite position(bullets..)
    a = vec2(0,0)
    a = a+vec2(10,-10)
    -- print shows the new vector values inside the console
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

