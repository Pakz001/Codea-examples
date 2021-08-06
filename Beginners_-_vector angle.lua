-- Vector Angle

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    -- When you want to shoot a bullet at a npc you want to know how to set up the
    -- bullet. One part is to know the angle between the gun and the npc, this so
    -- the bullet can travel in the right direction.
    
    -- get the angle between two vectors.
    -- note that the upper case B is required!
    a = vec2(100,100):angleBetween(vec2(200,0))
    -- print out the angle in radians and in degrees
    print(a)
    print(math.deg(a))
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end

