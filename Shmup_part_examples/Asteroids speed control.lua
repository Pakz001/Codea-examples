-- Asteroids Ship
numstars = 100
shipmaxspeed = 10.0
shipspeed = 2.0
gamescale = 0.5

-- our star position
position = vec2(0.0,0.0)


-- Use this function to perform your initial setup
function setup()
    -- starry background
    stars = {}
    for i = 1,numstars do
        table.insert(stars,vec2(math.random()*WIDTH,math.random()*HEIGHT))
    end
    -- our ship setup
    angle = 0
    currentangle = 0
    im = image(64,64)
    setContext(im)
    background(0,0,0,0)
    stroke(255,255,255)
    strokeWidth(2)
    for x =0,63 do
        line(64-x,32-x/2,64-x,32+x/2)
    end
    stroke(255,0,0)
    strokeWidth(4)
    line(0,32,64,32)
    setContext()
    print("Hello World!")
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(0,0,0)
    updatestars()
    updateposition()
    drawstars()

    shipcontrols()
        --draw our ship sprite with currentangle
    fill(255)
    pushMatrix()
    translate(WIDTH/2,HEIGHT/2)
    scale(gamescale,gamescale)
    rotate(math.deg(currentangle))
    sprite(im,0,0)
    popMatrix()
    
    updatespeedcontrols()
    drawspeedcontrols()
    fill(255)
    text("press anywhere on the screen to turn.",WIDTH/2,HEIGHT-50)
    text("starposition : "..math.floor(position.x/64)..","..math.floor(position.y/64),WIDTH-150,HEIGHT-50)
end

-- turning towards the last point we pressed on the screen.
function shipcontrols()
    if CurrentTouch.y<100 then return end
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
end


-- keep track how far we have traveled.
function updateposition()
    position.x = position.x + math.cos(currentangle) * shipspeed
    position.y = position.y + math.sin(currentangle) * shipspeed
end

-- if we press on the speed controls the shipspeed gets changed
function updatespeedcontrols()
    --rect(WIDTH/2-WIDTH/8,50,WIDTH/4,50)
    left = WIDTH/2-WIDTH/8
    total = WIDTH/4
    step = total / shipmaxspeed
    if CurrentTouch.x > left and CurrentTouch.y < 90 and CurrentTouch.x < left+total-20 then
        shipspeed = (CurrentTouch.x - left) / step
    end
end

-- our speed controls visuals
function drawspeedcontrols()
    stroke(55)
    fill(155)
    rect(WIDTH/2-WIDTH/8,50,WIDTH/4,50)
    stroke(0)
    fill(155,0,0)
    
    left = WIDTH/2-WIDTH/8
    total = WIDTH/4
    step = total / shipmaxspeed
    pos = step * shipspeed + left
    rect(pos,50,20,50)
    
    fill(255)
    text("Thrust",WIDTH/2,40)
end

function updatestars()
    for i =1,numstars do
        -- move the stars with current ship angle at ship speed
        stars[i].x = stars[i].x - math.cos(currentangle) * shipspeed
        stars[i].y = stars[i].y - math.sin(currentangle) * shipspeed
        -- if the stars get outside then screen then put them on the other side
        if stars[i].x < 0 then stars[i].x = WIDTH end
        if stars[i].x > WIDTH then stars[i].x = 0 end
        if stars[i].y < 0 then stars[i].y = HEIGHT end
        if stars[i].y > HEIGHT then stars[i].y = 0 end          
    end
end
function drawstars()
    stroke(255)
    for i = 1,numstars do
        rect(stars[i].x,stars[i].y,2,2)
    end

end

--This is the orientation function. It returns -1 if the point is left of the inputted line.
    -- 0 if on the same and 1 if on the right of the line.
    -- aa,bb,point
function orientation(ax,ay,bx,by,cx,cy)
        if(((bx-ax)*(cy-ay)-(by-ay)*(cx-ax))<0) then return -1 end
        if(((bx-ax)*(cy-ay)-(by-ay)*(cx-ax))>0) then return 1 end
        return 0
end
