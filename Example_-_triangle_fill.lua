-- Triangle fill

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
    
    x1 = math.random(100,WIDTH-100)
    y1 = math.random(100,HEIGHT-100)
    x2 = math.random(100,WIDTH-100)
    y2 = math.random(100,HEIGHT-100)
    x3 = math.random(100,WIDTH-100)
    y3 = math.random(100,HEIGHT-100)
      triangle(x1,y1,x2,y2,x3,y3)
    -- Do your drawing here
    
end

-- stackexchange triangle fill
function triangle(ax,ay,bx,by,cx,cy)

    
    -- sort vertices by y
    if (ay > by) then
        t = ay
        ay=by
        by=t
        
        t=ax
        ax=bx
        bx=t

    end
    if (ay > cy) then
        t=ay
        ay=cy
        cy=t

        t = ax
        ax = cx
        cx = t

    end
    if (by > cy) then
        t=by
        by=cy
        cy=t

        t=bx
        bx = cx
        cx = t

    end
    
    -- define more algorithm variables
    dx1 = (cx-ax)/(cy-ay)
    dx2 = (bx-ax)/(by-ay)
    dx3 = (cx-bx)/(cy-by)
    x1 = ax
    x2 = ax
    
    -- loop through coordinates
    for y = ay,by do
    
        line(x1,y,x2,y)
        x1 = x1 +dx1
        x2 = x2 +dx2
    end
    x2=bx
    -- loop through coordinates
    for y = by,cy do
    
        line(x1,y,x2,y)
        x1 = x1 + dx1
        x2 = x2 + dx3
    end
end
