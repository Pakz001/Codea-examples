-- Angle Collision

-- how to make a player walk 
-- up or down a slope

-- if the player is between the
-- 2 points and if his angle to
-- 1 of the points is the same
-- as the angle between the 2
-- points theb there is a
-- collision

p = vec2(200,480)
p1 = vec2(100,400)
p2 = vec2(300,300)

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


    
    for st=1,50 do
        colangle = math.atan2(p1.y-p2.y,p1.x-p2.x)
        angle = math.atan2(p.y-p2.y,p.x-p2.x)
    if math.floor(math.deg(colangle))~=math.floor(math.deg(angle)) then
        p.y = p.y - 0.5
    else
        p.x = math.random(p1.x+5,p2.x-5)
        p.y = 450
        end
    end
    
    rect(p1.x,p1.y,5,5)
    rect(p2.x,p2.y,5,5)
    line(p1.x,p1.y,p2.x,p2.y)
    
    rect(p.x,p.y,20,20)
    -- Do your drawing here
    
end
