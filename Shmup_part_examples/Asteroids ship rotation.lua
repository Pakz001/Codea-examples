-- Asteroids Ship
angle = 0
currentangle = 0
im = image(64,64)
setContext(im)
cnt=64
fill(255)
for x =0,64 do
    --line(x,x/2,x,x/2)
    rect(64-x,32-x/2,1,x)
    cnt=cnt-1
end
fill(255,255,0)
rect(0,32,64,1)
setContext()
-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(0,0,0)
    -- this gets our angle from the center to the point touched on screen
    angle = math.atan2(CurrentTouch.y-HEIGHT/2,CurrentTouch.x-WIDTH/2)
    -- if we have a new angle then slowly turn towards new angle
    if math.deg(angle)==math.deg(currentangle)==false then
        if orientation(WIDTH/2,HEIGHT/2,WIDTH/2+math.cos(currentangle)*500,HEIGHT/2+math.sin(currentangle)*500,CurrentTouch.x,CurrentTouch.y)==-1 then
        currentangle=currentangle-0.02
        else
        currentangle=currentangle+0.02
        end 
    end
    --draw our ship sprite with currentangle
    pushMatrix()
    translate(WIDTH/2,HEIGHT/2)
    rotate(math.deg(currentangle))
    sprite(im,0,0)
    popMatrix()
    
    text("press anywhere on the screen to turn.",WIDTH/2,HEIGHT-50)
end


--This is the orientation function. It returns -1 if the point is left of the inputted line.
    -- 0 if on the same and 1 if on the right of the line.
    -- aa,bb,point
function orientation(ax,ay,bx,by,cx,cy)
        if(((bx-ax)*(cy-ay)-(by-ay)*(cx-ax))<0) then return -1 end
        if(((bx-ax)*(cy-ay)-(by-ay)*(cx-ax))>0) then return 1 end
        return 0
end
