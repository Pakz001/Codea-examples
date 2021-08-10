-- Vector Angle

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    -- When you want to shoot a bullet at a npc you want to know how to set up the
    -- bullet. One part is to know the angle between the gun and the npc, this so
    -- the bullet can travel in the right direction.
    
    -- get the angle between two vectors.
    -- note that the upper case B is required!
    
    -- another inportant note is
    -- that it takes the first angle
    -- from position 0,0
    -- you would need to set up the
    -- vectors like you would
    -- set up atan2
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
