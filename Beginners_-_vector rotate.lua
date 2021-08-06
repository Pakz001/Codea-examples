-- Vector Rotate

-- create our vector as position
-- the higher the values the larger the circle it makes on the canvas(in this example)
position = vec2(120,20)


-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    

    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
    -- rotate our vector values by 5 degrees
    position = position:rotate(math.rad(5))
    -- draw our position in the center of the screen.
    rect(position.x+WIDTH/2,position.y+HEIGHT/2,20,20)
    
    -- Do your drawing here
    
end
