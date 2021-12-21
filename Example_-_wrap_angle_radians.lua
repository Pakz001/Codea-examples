-- Wrap Angle

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    angle = math.random(-1000,1000)-- get a random radian angle
    v1 = vec2(WIDTH/2,HEIGHT/2)
    v2 = vec2(v1.x+math.cos(angle)*300,v1.y+math.sin(angle)*300)
    -- wrap our angle(radians) value to be within normal region.
    wap = wrapangle(angle)
    -- wrapangle is as simple as :
    -- return math.abs(angle % math.pi)
    v3 = vec2(v1.x+math.cos(wap)*300,v1.y+math.sin(wap)*300)
    print(wap)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness()
    strokeWidth(5)
    line (v1.x,v1.y,v2.x,v2.y)
    line (v1.x,v1.y,v3.x,v3.y)
    -- Do your drawing here
    
end 

-- Wrap angle to be between 0 and 360.
-- maintain its original angle
function wrapangle(angle)

    --return math.abs(angle % 360) 
    return math.abs(angle % math.pi) 

end
