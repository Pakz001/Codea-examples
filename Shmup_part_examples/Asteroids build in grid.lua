-- Asteroids Ship
numstars = 100
shipmaxspeed = 10.0
shipspeed = 2.0
gamescale = 0.5

-- our star position
position = vec2(0.0,0.0)

map = {}

actionmap = {}
actionmapmax = 512
tilewidth = 64
tileheight = 64

-- build grid
buildgridselected = vec2(-1,-1)

-- Use this function to perform your initial setup
function setup()
    -- set up build grid
    buildblock = {}
    table.insert(buildblock,image(64,64))
    setContext(buildblock[1])
    background(0,0,0,100)
    fill(255,255,255,50)
    stroke(255)
    strokeWidth(3)
    rect(0,0,tilewidth,tileheight)
    setContext()
    -- set up the action map
    
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
    drawmap()
    shipcontrols()
        --draw our ship sprite with currentangle
    fill(255)
    pushMatrix()
    translate(WIDTH/2,HEIGHT/2)
    scale(gamescale,gamescale)
    rotate(math.deg(currentangle))
    sprite(im,0,0)
    popMatrix()
    
    -- draw buildgrid
    buildgridedit()
    drawbuildgrid()
    
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
        if shipspeed<.1 then shipspeed=0.0 end
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

function buildgridedit()
    if CurrentTouch.state == BEGAN == false then return end
        
    center = vec2((WIDTH/2)+14,(HEIGHT/2)-2)
    tilex  = math.floor(position.x/ tilewidth)
    tiley = math.floor(position.y / tileheight)
    offx = math.floor(tilex*tilewidth-position.x)
    offy = math.floor(tiley*tileheight-position.y)
    for y=-2,2 do
        for x = -2,2 do
            x1 = math.floor((10+x)*tilewidth)
            y1 = math.floor((7+y)*tileheight)
            if rectsoverlap(CurrentTouch.x,CurrentTouch.y,1,1,x1+offx+(tilewidth/2),y1+offy+(tileheight/2),tilewidth,tileheight) then
                buildgridselected.x = x
                buildgridselected.y = y
           
                tilex = math.floor(position.x / tilewidth) + x
                tiley = math.floor(position.y / tileheight) + y
                tilex = tilex + 10
                tiley = tiley + 7
                if map[tilex]==nil then
                    map[tilex]={}
                end
                map[tilex][tiley]=1
                
            end
            --sprite(buildblock[1],x1,y1)
        end
    end
end


-- Asteroids Ship
numstars = 100
shipmaxspeed = 10.0
shipspeed = 2.0
gamescale = 0.5

-- our star position
position = vec2(0.0,0.0)

map = {}

actionmap = {}
actionmapmax = 512
tilewidth = 64
tileheight = 64

-- build grid
buildgridselected = vec2(-1,-1)
buildgridactive = false -- this activates the grid around the ship for building on the tilemap
buildgriddelay = 0

-- Use this function to perform your initial setup 
function setup()
    -- set up build grid
    buildblock = {}
    table.insert(buildblock,image(64,64))
    setContext(buildblock[1])
    background(0,0,0,100)
    fill(255,255,255,50)
    stroke(255)
    strokeWidth(3)
    rect(0,0,tilewidth,tileheight)
    setContext()
    -- set up the action map
    
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
    drawmap()
    shipcontrols()
        --draw our ship sprite with currentangle
    fill(255)
    pushMatrix()
    translate(WIDTH/2,HEIGHT/2)
    scale(gamescale,gamescale)
    rotate(math.deg(currentangle))
    sprite(im,0,0)
    popMatrix()
    
    -- draw buildgrid
    buildgridedit()
    drawbuildgrid()
    updatebuildicon()
    drawbuildicon()
    
    updatespeedcontrols()
    drawspeedcontrols()
    fill(255)
    text("press anywhere on the screen to turn.",WIDTH/2,HEIGHT-50)
    text("starposition : "..math.floor(position.x/64)..","..math.floor(position.y/64),WIDTH-150,HEIGHT-50)
    if buildgridactive == true then
        text("124",100,100)
    end
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
        if shipspeed<.1 then shipspeed=0.0 end
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

function buildgridedit()
    if buildgridactive==false then return end
    if CurrentTouch.state == BEGAN == false then return end
        
    center = vec2((WIDTH/2)+14,(HEIGHT/2)-2)
    tilex  = math.floor(position.x/ tilewidth)
    tiley = math.floor(position.y / tileheight)
    offx = math.floor(tilex*tilewidth-position.x)
    offy = math.floor(tiley*tileheight-position.y)
    for y=-2,2 do
        for x = -2,2 do
            x1 = math.floor((10+x)*tilewidth)
            y1 = math.floor((7+y)*tileheight)
            if rectsoverlap(CurrentTouch.x,CurrentTouch.y,1,1,x1+offx+(tilewidth/2),y1+offy+(tileheight/2),tilewidth,tileheight) then
                buildgridselected.x = x
                buildgridselected.y = y
           
                tilex = math.floor(position.x / tilewidth) + x
                tiley = math.floor(position.y / tileheight) + y
                tilex = tilex + 10
                tiley = tiley + 7
                if map[tilex]==nil then
                    map[tilex]={}
                end
                map[tilex][tiley]=1
                
            end
            --sprite(buildblock[1],x1,y1)
        end
    end
end


function drawbuildgrid()
    if buildgridactive==false then return end
    left = position.x
    tilex  = math.floor(position.x/ tilewidth)
    tiley = math.floor(position.y / tileheight)
    offx = math.floor(tilex*tilewidth-position.x)
    offy = math.floor(tiley*tileheight-position.y)
    center = vec2((WIDTH/2)+32,(HEIGHT/2)+32)
    for y=-2,2 do 
        for x = -2,2 do
            x1 = math.floor((10+x)*tilewidth)
            y1 = math.floor((7+y)*tileheight)
            if buildgridselected.x == x and buildgridselected.y == y then
                tint(255,255,255)
            else
                tint(55)
            end
            
            sprite(buildblock[1],(x1)+offx+(tilewidth/2),(y1)+offy+(tileheight/2))
        end
    end
end


function rectsoverlap(x1,  y1,  w1,  h1,  x2,  y2,  w2,  h2) 
    return not ((y1+h1 < y2) or (y1 > y2+h2) or (x1 > x2+w2) or (x1+w1 < x2))
end

function drawmap()
    -- get our tile position
    -- 64s are the tile width and height
    tilex = math.floor(position.x / tilewidth)
    tiley = math.floor(position.y / tileheight)
    -- get our offset for smooth scrolling
    offx = math.floor(tilex*tilewidth-position.x)
    offy = math.floor(tiley*tileheight-position.y)
    -- draw a section of the map on the screen
    for x=0,20,1 do
        for y=0,20,1 do
            if map[x+tilex]==nil==false and map[x+tilex][y+tiley]==nil==false then
                fill(255)
                stroke(255)
                rect(x*tilewidth+offx,y*tileheight+offy,tilewidth,tileheight)
            end
        end
    end
end

function updatebuildicon()
    if buildgriddelay > 0 then buildgriddelay = buildgriddelay - 1 end
    if buildgriddelay>0 then return end
    left = WIDTH/100*80
    hor = WIDTH/100*5
    if rectsoverlap(CurrentTouch.x,CurrentTouch.y,1,1,left,50,hor,50) == true then
        if CurrentTouch.state == BEGAN then
            if buildgridactive == true then buildgridactive=false else buildgridactive=true end
            buildgriddelay = 100
         end 
    end 
end

function drawbuildicon()
    if buildgridactive then
        fill(255)
        stroke(255,0,0)
    else
        fill(0)
        stroke(255, 0, 66)
    end 
    
    left = WIDTH/100*80
    hor = WIDTH/100*5
    rect(left,50,hor,50)
    if buildgridactive then
        fill(0)
    else
        fill(255)
    end
    
    fontSize(50)
    text("B",left+hor/2,50+25)
    fontSize(20)
end
