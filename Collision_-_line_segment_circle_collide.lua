-- Line Seg Circle

v1 = vec2(100,300)
v2 = vec2(300,400)
c = vec2(0,0)
r = 90

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    c.x = CurrentTouch.x
    c.y = CurrentTouch.y
    
    -- This sets the line thickness
    strokeWidth(5)
    line(v1.x,v1.y,v2.x,v2.y)
    ellipse(c.x,c.y,r,r)
    -- Do your drawing here
    if linecirclecollide(v1.x,v1.y,v2.x,v2.y,c.x,c.y,r) then
        text("collision",WIDTH/2,HEIGHT-70)
    end
    
    
end

--//'
--//' Line(segment) to Circle Collision//
--//'
function linecirclecollide(x1,y1, x2,y2,xc,yc,r)
    -- for compatibility I halve
    -- the radius so the default
    -- circle of codea collides.
    r = r / 2
    -- collision code
    xd = 0.0
    yd = 0.0
    t = 0.0
    d = 0.0
    dx = 0.0
    dy = 0.0
    
    dx = x2 - x1
    dy = y2 - y1
    
    t = ((yc - y1) * dy + (xc - x1) * dx) / (dy * dy + dx * dx)
    
    if 0 <= t and t <= 1 then
        xd = x1 + t * dx
        yd = y1 + t * dy
        
        d = math.sqrt((xd - xc) * (xd - xc) + (yd - yc) * (yd - yc))
        return d <= r
    else
        d = math.sqrt((xc - x1) * (xc - x1) + (yc - y1) * (yc - y1));
        if d <= r then
            return true
        else
            d = math.sqrt((xc - x2) * (xc - x2) + (yc - y2) * (yc - y2))
            if d <= r then
                return true
            else
                return false
            end
            
        end
    end
    
end
