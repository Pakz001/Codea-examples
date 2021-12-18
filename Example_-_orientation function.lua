-- Orientation

-- if you with to program things like homing missiles.
-- the function here can help to let you know which direction to turn.
-- the function returns -1 if a target is to the left of its angle(line)
-- 1 if right.

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

    -- Do your drawing here
    
end



-- This is the orientation function. It returns -1 if the point is left of the inputted line.
-- 0 if on the same and 1 if on the right of the line.
--aa,bb,point
-- ax,ay = line start
-- bx,by = line end
-- cx,cy = point
function orientation(ax,ay,bx,by, cx,cy)
        	if(((bx-ax)*(cy-ay)-(by-ay)*(cx-ax))<0) then return -1 end
        if(((bx-ax)*(cy-ay)-(by-ay)*(cx-ax))>0) then return 1 end
        return 0
end
