-- Line Segment Collision

-- line segment collision checks if a part(segment) of a line
-- is touching another line segment. a line normally is
-- unlimited in length. A segment like here is from point a to b.
-- this function here can be used to check if 2 lines collide
-- or to be used as a building block to check collision
-- between more complex objects like triangles or squares or
-- polygons. do this by checking if any line of a object made
-- of lines is colliding. (collision shapes/masks)

v1 = vec2(100,150)
v2 = vec2(300,500)
v3 = vec2(0,0)
v4 = vec2(0,0)

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
    line(v1.x,v1.y,v2.x,v2.y)
    -- Do your drawing here
    v3.x = CurrentTouch.x
    v3.y = CurrentTouch.y
    v4.x = v3.x - 100
    v4.y = v3.y + 100
    line(v3.x,v3.y,v4.x,v4.y)
    
    if get_line_intersect(v1.x,v1.y,v2.x,v2.y,v3.x,v3.y,v4.x,v4.y) then
        text("collision",WIDTH/2,HEIGHT-70)
    end
    
    text("touch move line on the screen",WIDTH/2,HEIGHT - 50)
end

-- This function was originally by andre la moth.
function get_line_intersect(p0_x, p0_y, p1_x, p1_y, p2_x ,p2_y, p3_x, p3_y)
    s1_x = 0
    s1_y = 0
    s2_x = 0
    s2_y = 0
    
    s1_x = p1_x - p0_x   
    s1_y = p1_y - p0_y
    s2_x = p3_x - p2_x
    s2_y = p3_y - p2_y
    
    s = 0
    t = 0
    
    s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
    t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);
    
    if s >= 0 and s <= 1 and t >= 0 and t <= 1 then return true end
    
    return false --No collision    
end

