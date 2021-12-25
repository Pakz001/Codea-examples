-- copy the mytiles png file into the assets. it needs to be at 640x480.

breakcount = 0 -- how many breaks for a block to break
breakx = 0 -- tile position of current block that is being damages.
breaky = 0
breakdelay = 0 
breakdelaymax = 20
breaklastcount = 0


pickup = class()
pickuprotationspeed = 3 -- degrees
function pickup:init(x,y,num)
    self.active = true
    self.x = x
    self.y = y
    self.angle = math.random()
    self.tilenum = num
    self.remove = false
end
pickups = {}

laserbolt = class()
laserboltmaxdistance = 200
laserboltspeed = 5
laserboltsize = 16
function laserbolt:init(x,y,angle)
    self.x = x
    self.y = y
    self.incx = math.cos(angle)*laserboltspeed
    self.incy = math.sin(angle)*laserboltspeed
    self.distancetraveled = 0
end 

laserbolts = {}

-- used to know which pickup tile/sprite to draw. enums
pickupilverore = 1
pickupironore = 2
pickupgoldore = 3
pickupstoneore = 4


itemmininglaser = 0
itemlaserbolt = 1

-- Asteroids Ship
doubletaptime = 0
doubletap = 0
playeritemselected = itemlaserbolt-- blocks weapons tools
playerlaseractive=false
numstars = 100
starsprite = {}
shipmaxspeed = 10.0
shipspeed = 2.0
gamescale = .5
-- for the asteroids
genmapwidth = 512
genmapheight = 512
genmap = {}
tempmap = {}

numtunnels = 50

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
    -- the image file is inside my github shmups folder as mytiles.png. add it
    -- to this project as mytiles. disable retina mode. 320x240
    mytiles = readImage(asset.mytiles)
    myuitiles = readImage(asset.uispace)
    for y=1,mytiles.height,1 do
        for x=1, mytiles.width,1 do
            r,g,b,a = mytiles:get(x,y)
            if r==255 and g==0 and b==255 and a==255 then
                mytiles:set(x,y,0,0,0,0)
            end

        end
    end
    for y=1,myuitiles.height,1 do
        for x=1, myuitiles.width,1 do
            r,g,b,a = myuitiles:get(x,y)
            if r==255 and g==0 and b==255 then
                myuitiles:set(x,y,0,0,0,0)
                
            end
        end
    end
    
    -- set up the uiser interface tiles
    uiblocklefttop = myuitiles:copy(49,417,16,15)
    uiblockleftbottom = myuitiles:copy(49,401,16,15)
    uiblockrighttop = myuitiles:copy(81,417,16,15)
    uiblockrightbottom = myuitiles:copy(81,401,16,15)
    uiblocktopcenter = myuitiles:copy(65,417,16,15)
    uiblockbottomcenter = myuitiles:copy(65,401,16,15)
    -- for the thrust bar
    uithrustleft = myuitiles:copy(49,353,16,15)
    uithrustcenter = myuitiles:copy(65,353,16,15)
    uithrustright = myuitiles:copy(81,353,16,15)
    
    --ship = mytiles:copy(17,128-15,8,8)
    --block1 = mytiles:copy(17,128-7,8,8)
    ship = mytiles:copy(33,256-31,16,16)
    --ship = mytiles:copy(33,1*16,16,16)
    --208,304
    breakmask = mytiles:copy(208,304,16,16)
    block1 = mytiles:copy(63,448,16,16)
    block2 = mytiles:copy(80,272,16,16)
    block3 = mytiles:copy(161,337,16,16)
    block4 = mytiles:copy(161,353,16,16)
    goldoreblock = mytiles:copy(160,272,16,16)
    ironoreblock = mytiles:copy(160,256,16,16)
    silveroreblock = mytiles:copy(160,240,16,16)
    goldoredrop = mytiles:copy(208,272,16,16)
    ironoredrop = mytiles:copy(208,256,16,16)
    silveroredrop = mytiles:copy(208,240,16,16)
    stoneoredrop = mytiles:copy(208,288,16,16)
    laserboltsprite = mytiles:copy(305,465,16,16)
    mininglasericon = mytiles:copy(321,465,16,16)
    buildicon = mytiles:copy(289,465,16,16)
    -- create our asteroid map
    for x=0,genmapwidth do
        genmap[x]={}
        tempmap[x]={}
        for y=0,genmapheight do
            genmap[x][y]=0        
            tempmap[x][y]=0
        end
    end
     
    createasteroid(-30,-30)
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
    stardata = {}
    starscale = {}
    for i = 1,numstars do
        table.insert(stars,vec2(math.random()*WIDTH,math.random()*HEIGHT))
        table.insert(stardata,math.random(1,5))
        a = (math.random()-.5)+.5
        table.insert(starscale,a)
    end
    makestar(1,255,0,0)
    makestar(2,255,255,0)
    makestar(3,255,0,255)
    makestar(4,255,10,100)
    makestar(5,100,10,255)
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
    
    table.insert(pickups,pickup(400,300,pickupgoldore))
    table.insert(pickups,pickup(430,300,pickupsilverore))
    table.insert(pickups,pickup(460,300,pickupironore))
    table.insert(pickups,pickup(490,300,pickupstoneore))
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
    tint(255)
    if playeritemselected == itemmininglaser and playerlaseractive then
        d = vec2(WIDTH/2,HEIGHT/2):dist(vec2(CurrentTouch.x,CurrentTouch.y))
        if d>128 then d = 128 end
        fill(255)
        stroke(255)
        strokeWidth(3)
        line(WIDTH/2,HEIGHT/2,WIDTH/2+math.cos(currentangle)*d,HEIGHT/2+math.sin(currentangle)*d)
        if linetilecollide(WIDTH/2,HEIGHT/2,WIDTH/2+(math.cos(currentangle)*(d)),HEIGHT/2+(math.sin(currentangle)*(d))) then
            
        end
    end
    pushMatrix()
    translate(WIDTH/2,HEIGHT/2)
    scale(gamescale,gamescale)
    rotate(math.deg(currentangle)-90)
    --sprite(im,0,0)
    scale(4,4)
    sprite(ship,0,0)
    popMatrix()
    
    breakdelay = breakdelay + 1
    if breakdelay>40 then breakdelay=0 end
    breaklastcount = breaklastcount + 1
    updatepickups()
    playergetpickups()
    drawpickups()
    updatelaserbolts()
    drawlaserbolts()
    
    
    -- draw buildgrid
    buildgridedit()
    drawbuildgrid()
    updatebuildicon()
    drawbuildicon()
    
    updatespeedcontrols()
    drawspeedcontrols()
    fill(0,0,0)
    stroke(200,250,220)
    --strokeWidth(2)
    --rect(0,HEIGHT-50,WIDTH,50)
    --fill(255,200,200)
    --text(doubletap..","..doubletaptime,400,200) 
    --if laseractive then text("pew",400,220) end
    drawtopui()
    fill(222)
    fontSize(14)
    text("press anywhere on the screen to turn.",WIDTH/1.5,HEIGHT-40)
    text("starposition : "..math.floor(position.x/64)..","..math.floor(position.y/64),WIDTH-150,HEIGHT-40)
    -- collision with tiles
    if recttilecollide(WIDTH/2-((64*gamescale)/2),HEIGHT/2-((64*gamescale)/2),64*gamescale,64*gamescale,0,0) == true then
        --text("collision",WIDTH/2,100)
    end
end



function playergetpickups()
    if pickups == nil then return end
    for i=0,#pickups do      
        if pickups[i] ~= nil then
            d = vec2(WIDTH/2,HEIGHT/2):dist(vec2(pickups[i].x,pickups[i].y))
            if d < 96 then
                
                angle = math.atan2(pickups[i].y-HEIGHT/2,pickups[i].x-WIDTH/2)
                -- move slow then faster each step closer.
                sp = (96-d)/10
                pickups[i].x=pickups[i].x-math.cos(angle)*sp
                pickups[i].y=pickups[i].y-math.sin(angle)*sp
            end
            if d<16 then
                pickups[i].active = false
            end
        end        
    end

end 

function updatepickups()
    --pickuprotationspeed
    if pickups == nil then return end
    for i=0,#pickups do      
        if pickups[i] ~= nil and pickups[i].active==true then
            -- update the laserbolts with the player map position.
            pickups[i].x=pickups[i].x-math.cos(currentangle)*shipspeed 
            pickups[i].y=pickups[i].y-math.sin(currentangle)*shipspeed
            pickups[i].angle = pickups[i].angle + pickuprotationspeed
            pickups[i].angle = pickups[i].angle % 360
        end
        
    end
end
function drawpickups()
    if pickups == nil then return end
    fill(255,255,0)
    stroke(255,255,0)
    strokeWidth(5)
    spriteMode(CENTER)
    for i=0,#pickups do      
        if pickups[i] ~= nil and pickups[i].active==true then
            --rect(laserbolts[i].x,laserbolts[i].y,laserboltsize,laserboltsize)
            pushMatrix()
            translate(pickups[i].x,pickups[i].y)
            scale(1.5,1.5)
            rotate(pickups[i].angle)

            if pickups[i].tilenum == pickupsilverore then
                sprite(silveroredrop,0,0)
            elseif pickups[i].tilenum == pickupgoldore then
                sprite(goldoredrop,0,0)
            elseif pickups[i].tilenum == pickupironore then
                sprite(ironoredrop,0,0)
            elseif pickups[i].tilenum == pickupstoneore then
                sprite(stoneoredrop,0,0)
            end
            
            
            popMatrix()
        end
    end
end

function drawtopui()
    left = 0
    topy = HEIGHT-50
    drawuiblock(left,topy,1)
    drawuiblock(left,0,2)
    for x=left+48,WIDTH,48 do
        drawuiblock(x,topy,3)
        drawuiblock(x,0,4)
    end
    drawuiblock(WIDTH-48,topy,5)
    drawuiblock(WIDTH-48,0,6)
end
function drawuiblock(x,y,block)
    tint(255)
    pushMatrix()
    translate(x,y)
    scale(3,3)
    if block == 1 then
        sprite(uiblocklefttop,8,8)
    end
    if block == 2 then
        sprite(uiblockleftbottom,8,8)
    end
    if block == 3 then       
        sprite(uiblocktopcenter,8,8)
    end
    if block == 4 then       
        sprite(uiblockbottomcenter,8,8)
    end
    if block == 5 then       
        sprite(uiblockrighttop,8,8)
    end
    if block == 6 then       
        sprite(uiblockrightbottom,8,8)
    end
    popMatrix()
end

-- turning towards the last point we pressed on the screen.
function shipcontrols()
    if CurrentTouch.y<150 then return end
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
    
    doubletaptime=doubletaptime+1 
    if doubletaptime>60 then
        doubletap=0
        doubletaptime=0
    end
    
    updatecontrolslaserbolt()
    updatecontrolslaser()
end

function updatecontrolslaserbolt()
    if playeritemselected ~= itemlaserbolt then return end
    if buildgridactive then return end
    
    if CurrentTouch.state == BEGAN then
        if doubletap==0 then
            doubletap=1
            doubletaptime=0
        elseif doubletap==2 and doubletaptime>30 then
            --playerlaseractive=true
            -- fire laserbolt
            if laserbolts==nil then
                laserbolts[0]= laserbolt(WIDTH/2,HEIGHT/2,currentangle)
                --print(math.random())
            else
                chosen=false
                for i=0,#laserbolts do
                    if laserbolts[i]==nil then
                        laserbolts[0]= laserbolt(WIDTH/2,HEIGHT/2,currentangle)
                        chosen=true
                        break
                    end
                end
                if chosen==false then
                    table.insert(laserbolts,laserbolt(WIDTH/2,HEIGHT/2,currentangle))
                end
            end
            doubletap=0
            doubletaptime=0
        end
    end
    
    
    if CurrentTouch.state==ENDED then
        if doubletap==1 and doubletaptime>10 and doubletaptime<60 then doubletap=2 end
        if playerlaseractive then 
            --playerlaseractive=false 
            doubletap=0
        end
    end
end

-- player activate laser if double tap
function updatecontrolslaser()
    if playeritemselected ~= itemmininglaser then return end
    if buildgridactive then return end
    
    if CurrentTouch.state == BEGAN then
        if doubletap==0 then
            doubletap=1
            doubletaptime=0
        elseif doubletap==2 and doubletaptime>30 then
            playerlaseractive=true
        end
    end


    if CurrentTouch.state==ENDED then
        if doubletap==1 and doubletaptime>10 and doubletaptime<60 then doubletap=2 end
        if playerlaseractive then 
            playerlaseractive=false 
            doubletap=0
        end
    end
end


-- keep track how far we have traveled.
function updateposition()
    if recttilecollide(WIDTH/2-((64*gamescale)/2),HEIGHT/2-((64*gamescale)/2),64*gamescale+6,64*gamescale+6,0,0) == true then
        --text("collision",WIDTH/2,100)
        position.x = position.x - math.cos(currentangle) * 2
        position.y = position.y - math.sin(currentangle) * 2
        shipspeed = 0.0
    else
        position.x = position.x + math.cos(currentangle) * shipspeed
        position.y = position.y + math.sin(currentangle) * shipspeed
    end
end

-- if we press on the speed controls the shipspeed gets changed
function updatespeedcontrols()
    --rect(WIDTH/2-WIDTH/8,50,WIDTH/4,50)
    -- quick fix here to not let the speed be adjusted if we are directed into a block.
    x2 = math.cos(currentangle) *2
    y2 = math.sin (currentangle)*2
    if recttilecollide((WIDTH/2-((64*gamescale)/2))+x2,(HEIGHT/2-((64*gamescale)/2))+y2,64*gamescale+6,64*gamescale+6,0,0) == true then return end
    -- change our speed.
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
    --rect(WIDTH/2-WIDTH/8,50,WIDTH/4,50)
    stroke(0)
    fill(155,0,0)
   
    left = WIDTH/2-WIDTH/8-48/2
    right = WIDTH/4
    tint(255)
    pushMatrix()
    translate(left,50)
    scale(3,3)
    sprite(uithrustleft,8,8)
    popMatrix()
    
    for x=left+48,left+right,48 do
        pushMatrix()
        translate(x,50)
        scale(3,3)
        sprite(uithrustcenter,8,8)
        popMatrix()
        
    end
    
    
    
    pushMatrix()
    translate(left+right,50)
    scale(3,3)
    sprite(uithrustright,8,8)
    popMatrix()
    
    
    
    left = WIDTH/2-WIDTH/8
    total = WIDTH/4
    step = total / shipmaxspeed
    pos = step * shipspeed + left
    rect(pos,50,20,50)
    
    fill(255)
    text("Thrust",WIDTH/2,40)
end

function updatelaserbolts()
    if laserbolts == nil then return end
    
    for i=0,#laserbolts do
        if laserbolts[i]~=nil then
            -- update the laserbolts with the player map position.
            laserbolts[i].x=laserbolts[i].x-math.cos(currentangle)*shipspeed
            laserbolts[i].y=laserbolts[i].y-math.sin(currentangle)*shipspeed
            
            laserbolts[i].x=laserbolts[i].x+laserbolts[i].incx
            laserbolts[i].y=laserbolts[i].y+laserbolts[i].incy
        
            laserbolts[i].distancetraveled = laserbolts[i].distancetraveled+ 1
            if laserbolts[i].distancetraveled > laserboltmaxdistance or 
                weapontilecollide(laserbolts[i].x,laserbolts[i].y,laserboltsize,laserboltsize,0,0) then
                laserbolts[i] = nil
            end
        
        end
    end
end

function drawlaserbolts()
    if laserbolts == nil then return end
    fill(255,255,0)
    stroke(255,255,0)
    strokeWidth(5)
    for i=0,#laserbolts do      
        if laserbolts[i] ~= nil then
            --rect(laserbolts[i].x,laserbolts[i].y,laserboltsize,laserboltsize)
            pushMatrix()
            translate(laserbolts[i].x,laserbolts[i].y)
            scale(1,1)
            sprite(laserboltsprite,8,8)
            popMatrix()
        end
    end
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
    tint(255)
    stroke(255)
    for i = 1,numstars do
        --rect(stars[i].x,stars[i].y,4,4)
        pushMatrix()
        translate(stars[i].x,stars[i].y)
        scale(starscale[i],starscale[i])
        sprite(starsprite[stardata[i]],0,0)
        popMatrix()
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
    -- get our offset for smooth scrollingf
    offx = math.floor(tilex*tilewidth-position.x)
    offy = math.floor(tiley*tileheight-position.y)
    -- draw a section of the map on the screen
    for x=0,20,1 do
        for y=0,20,1 do
            if map[x+tilex]==nil==false and map[x+tilex][y+tiley]==nil==false then
                if map[x+tilex][y+tiley]==1 then
                fill(155,155,155)
                stroke(155,155,155)
                else
                    fill(35,10,0)
                    stroke(35,10,0)
                end 
                
                --rect(x*tilewidth+offx,y*tileheight+offy,tilewidth+1,tileheight+1)
                pushMatrix()
                translate(x*tilewidth+offx,y*tileheight+offy)
                --scale(gamescale,gamescale)
                scale(4,4)

                if map[x+tilex][y+tiley]==1 then
                    sprite(block1,8,8)
                elseif map[x+tilex][y+tiley]==2 then
                    sprite(block2,8,8)
                elseif map[x+tilex][y+tiley]==3 then
                    sprite(ironoreblock,8,8)
                elseif map[x+tilex][y+tiley]==4 then
                    sprite(goldoreblock,8,8)
                elseif map[x+tilex][y+tiley]==5 then
                    sprite(silveroreblock,8,8)
                elseif map[x+tilex][y+tiley]==6 then
                    sprite(block3,8,8)
                elseif map[x+tilex][y+tiley]==7 then
                    sprite(block4,8,8)
                end
                -- mining break block effect
                if breaklastcount<60 and breakx == x+tilex and breaky==y+tiley then
                    if math.random()<.2 then
                        sprite(breakmask,7,8)
                    end
                end
                popMatrix()
            end
        end
    end
end

function updatebuildicon()
    if buildgriddelay > 0 then buildgriddelay = buildgriddelay - 1 end
    if buildgriddelay>0 then return end
    left = WIDTH/100*80
    hor = WIDTH/100*5
    -- select build icon
    if rectsoverlap(CurrentTouch.x,CurrentTouch.y,1,1,left,50,hor,50) == true then
        if CurrentTouch.state == BEGAN then
            if buildgridactive == true then buildgridactive=false else buildgridactive=true end
            playeritemselected = -1
            buildgriddelay = 40
         end 
    end 
    if rectsoverlap(CurrentTouch.x,CurrentTouch.y,1,1,left+tilewidth,50,hor,50) == true then
        if CurrentTouch.state == BEGAN then
            buildgridactive=false
            if playeritemselected~=itemlaserbolt then
                playeritemselected = itemlaserbolt
            else
                playeritemselected=-1
            end 
            buildgriddelay = 40
        end
     end
    if rectsoverlap(CurrentTouch.x,CurrentTouch.y,1,1,left+tilewidth*2,50,hor,50) == true then
        if CurrentTouch.state == BEGAN then
            buildgridactive=false
            if playeritemselected~=itemmininglaser then
                playeritemselected = itemmininglaser
            else
                playeritemselected=-1
            end
            buildgriddelay=40
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
    tint(255)
    pushMatrix()
    translate(left,50)
    scale(3,3)
    sprite(buildicon,8,8)
    popMatrix()
    fontSize(50)
    --text("B",left+hor/2,50+25)
    fontSize(20)
    -- bolts and mining laser
    fill(0)
    stroke(255, 0, 66)
    if playeritemselected == itemlaserbolt then stroke(255) end
    rect(left+tilewidth,50,hor,50)
    tint(255)
    pushMatrix()
    translate(left+tilewidth,50)
    scale(3,3)
    sprite(laserboltsprite,8,8)
    popMatrix()
    fill(0)
    stroke(255, 0, 66)
    if playeritemselected==itemmininglaser then stroke(255) end
    rect(left+tilewidth*2,50,hor,50)
    tint(255)
    pushMatrix()
    translate(left+tilewidth*2,50)
    scale(3,3)
    sprite(mininglasericon,8,8)
    popMatrix()
    
end


function makestar(num,r,g,b)
    table.insert(starsprite,image(32,32))
    setContext(starsprite[num])
    r = r + 255*8
    r=r/9
    g=g+255*8
    g=g/9
    b=b+255*8
    b=b/9
    stepr = r/16
    stepg = g/16
    stepb = b/16
    for y=0,16 do
        st=y
        fill(stepr*st,stepg*st,stepb*st)
        stroke(stepr*st,stepg*st,stepb*st)
        strokeWidth(1)
        rect(16,y,2,2)
        rect(16,32-y,2,2)
        rect(y,16,2,2)
        rect(32-y,16,2,2)
    end
    setContext()
end
-- create our asteroid at locx locy
function createasteroid(locx,locy)
    -- create points on the map
    for i=0,numtunnels do
        x1 = math.random(genmapwidth/2-genmapwidth/4,genmapwidth/2+genmapwidth/4)
        y1 = math.random(genmapheight/2-genmapheight/4,genmapheight/2+genmapheight/4)
        genmap[x1][y1] = 1
    end
    -- find a starting point
    startx = nil
    starty = nil
    while startx == nil do
        x1 = math.floor(math.random()*genmapwidth)
        y1 = math.floor(math.random()*genmapheight)
        if genmap[x1][y1]==1 then
            startx = x1
            starty = y1
            tempmap[x1][y1]=1
        end
    end
    -- find closest point within x amount of seeks
    for j = 0,numtunnels do
        x2 = 0
        y2 = 0
        dist = 9999
        for i=0,9000 do
            x1 = math.floor(math.random()*genmapwidth)
            y1 = math.floor(math.random()*genmapheight)
            if genmap[x1][y1]==1 and tempmap[x1][y1]==0 then
                d = vec2(x1,y1):dist(vec2(startx,starty))
                if d<dist then
                    x2 = x1
                    y2 = y1
                    dist = d
                end
            end
        end     
        -- tunnel from start to x2y2
        if x2 == 0 == false then
            zdelay = 5
            z = math.random(2,4)
            genmap[math.floor(startx)][math.floor(starty)]=0
            angle = math.atan2(y2-starty,x2-startx)
            cnt = 0
            while math.floor(startx) == math.floor(x2) == false do
                startx = startx + math.cos(angle) 
                starty = starty + math.sin(angle) 
                -- every couple of dices change our tunneling angle
                if math.random()*20 < 2 then
                    angle = angle + math.random()
                end
                -- every coup,e of dices return our original angle
                if math.random()*20<2 then
                    angle = math.atan2(y2-starty,x2-startx)
                end 
                -- every couple of dices change our tunneling size
                zdelay= zdelay-1
                if math.random(0,10)<4 or zdelay<0 then
                    z = math.random(1,4)
                    zdelay = math.random(0,10)
                end
                -- create our tunnel
                for r=-z,z,.3 do
                    tempmap[math.floor(startx+r)][math.floor(starty+r)]=1
                end
                -- if we get stuck then exit
                cnt=cnt+1 
                if cnt>999 then break end
            end        
        end       
    end
    -- grow edges
    -- pick random spot, if spot is solid or new value, grow to empty neighbours using new value
    for i=0,genmapwidth*genmapheight*4 do
        x1 = math.floor(math.random()*genmapwidth)
        y1 = math.floor(math.random()*genmapheight)
        if tempmap[x1][y1] == 1 or tempmap[x1][y1] == 2 then
            for x2=x1-1,x1+1 do
                for y2=y1-1,y1+1 do
                    if x2<0 or x2>=genmapwidth or y2<0 or y2>=genmapheight then break end
                    if tempmap[x2][y2]==0 then
                        tempmap[x2][y2]=2
                    end
                end
            end
        end
    end
    
    -- for testing purposes add some entrances
    

    for i=0,360,45 do
        x=genmapwidth/2
        y=genmapheight/2
        angle=math.rad(i)
        for j=0,genmapwidth do
            x=x+math.cos(angle)
            y=y+math.sin(angle)
            if math.random()*10<.5 then angle=angle+math.random() end
            -- scan if we are in the clear
            done = true
            for x2=-2,2 do
                for y2=-2,2 do
                    if x2+x >=0 and y2+y>=0 and x2+x<genmapwidth and y2+y<genmapheight then
                        if tempmap[math.floor(x2+x)][math.floor(y2+y)]==2 then 
                            done = false 
                        end
                    end
                end
            end
            --if done==true then j=genmapwidth end
            if done==false then
                for y1=-1,1 do
                    for x1=-1,1 do
                        if x+x1>=0 and y+y1>=0 and x+x1<genmapwidth and y+y1<genmapheight then
                            tempmap[math.floor(x+x1)][math.floor(y+y1)] = 1
                        end
                    end
                end
            end
        end
    end
    
    -- add ore veins and spots
    for i=0,genmapwidth+genmapheight*8 do
        x = math.random(25,genmapwidth-25)
        y= math.random(25,genmapheight-25)
        if tempmap[math.floor(x)][math.floor(y)]==2 then
            tp=math.random(3,5)
            angle = math.random()*7.0
            len = math.random(2,16)
            if math.random()*10<9 then len=1 end
            for j=0,len do
                if math.random()*10<2 then angle=angle+math.random() end
                x = x + math.cos(angle)*math.random(1,2)
                y = y + math.sin(angle)*math.random(1,2)
                if tempmap[math.floor(x)][math.floor(y)]==2 then
                    tempmap[math.floor(x)][math.floor(y)] = tp
                end
            end
            
        end 
    end
    
    -- add block 3
    for i=0,genmapwidth+genmapheight do
        x = math.random(50,genmapwidth-50)
        y= math.random(50,genmapheight-50)
        if tempmap[math.floor(x)][math.floor(y)]==2 then
            tempmap[math.floor(x)][math.floor(y)]=6
        end
    end
    for i=0,genmapwidth+genmapheight*500 do
        x = math.random(50,genmapwidth-50)
        y= math.random(50,genmapheight-50)
        if tempmap[math.floor(x)][math.floor(y)]==6 then
            for y1=y-1,y+1,1 do
                for x1=x-1,x+1,1 do
                    if tempmap[math.floor(x1)][math.floor(y1)]==2 then
                        tempmap[math.floor(x1)][math.floor(y1)]=6
                        
                        
                    end
                end
            end
        end
    end
    -- add block 4
    for i=0,genmapwidth+genmapheight do
        x = math.random(50,genmapwidth-50)
        y= math.random(50,genmapheight-50)
        if tempmap[math.floor(x)][math.floor(y)]==2 then
            tempmap[math.floor(x)][math.floor(y)]=7
        end
    end
    for i=0,genmapwidth+genmapheight*500 do
        x = math.random(50,genmapwidth-50)
        y= math.random(50,genmapheight-50)
        if tempmap[math.floor(x)][math.floor(y)]==7 then
            for y1=y-1,y+1,1 do
                for x1=x-1,x+1,1 do
                    if tempmap[math.floor(x1)][math.floor(y1)]==2 then
                        tempmap[math.floor(x1)][math.floor(y1)]=7
                        
                        
                    end
                end
            end
        end
    end
    
    -- make a 50 by 50 map section at -100 x and -100 y
    for x=0,genmapwidth do
        map[x+locx]={}
        for y=0,genmapheight do
            if tempmap[x][y]==2 then
                map[locx+x][locy+y]=1
            end
            if tempmap[x][y]==1 then
                map[locx+x][locy+y]=2
            end
            if tempmap[x][y]>=3 and tempmap[x][y]<=7 then
                map[locx+x][locy+y]=tempmap[x][y]
            end
        end
    end
    
    
    
end


function weapontilecollide(x,y,w,h,offsetx,offsety)
    tx = math.floor((position.x) / tilewidth)
    ty = math.floor((position.y) / tileheight)
    -- get our offset for smooth scrolling
    ox = math.floor(tx*tilewidth-position.x)
    oy = math.floor(ty*tileheight-position.y)
    cx = math.floor((x)/tilewidth)+tx
    cy = math.floor((y)/tileheight)+ty
    x2 = 0
    y2 = 0
    for y2=cy-1,cy+2,1 do -- if the collision area is large then increase the - and + area to check (+2 etc)
        for x2=cx-1,cx+2,1 do
            if map[x2]~=nil and map[x2][y2]~=nil then
                if map[x2][y2] ~= 2 then
                    
                    x3 = (x2-tx)*tilewidth+ox
                    y3 = (y2-ty)*tileheight+oy
                    
                    if rectsoverlap(x+offsetx,y+offsety,w,h,x3,y3,tilewidth,tileheight) then
                        breaklastcount = 0
                        breakx = x2
                        breaky = y2
                        breakdelay = 0
                        breakcount = breakcount + 1
                        if math.random()*10<2 and breakcount > 5 then 
                            
                            breakcount = 0
                            if map[x2][y2]==1 then
                                tile = pickupstoneore
                            elseif map[x2][y2] == 3 then
                                tile = pickupironore
                            elseif map[x2][y2] == 4 then
                                tile = pickupgoldore
                            elseif map[x2][y2] == 5 then    
                                tile = pickupsilverore
                            elseif map[x2][y2] == 6 then
                                tile = pickupstoneore
                            elseif map[x2][y2] == 7 then
                                tile = pickupstoneore
                            end
                            map[x2][y2]=nil
                            insertpickup(x3+24,y3+32,tile)
                            --table.insert(pickups,pickup(x3+24,y3+32,tile))
                            
                            
                        end
                        return true
                    end
                end
            end
        end
    end
    return false
end

function recttilecollide(x,y,w,h,offsetx,offsety)
    tx = math.floor((position.x) / tilewidth)
    ty = math.floor((position.y) / tileheight)
    -- get our offset for smooth scrolling
    ox = math.floor(tx*tilewidth-position.x)
    oy = math.floor(ty*tileheight-position.y)
    cx = math.floor((x)/tilewidth)+tx
    cy = math.floor((y)/tileheight)+ty
    x2 = 0
    y2 = 0
    for y2=cy-1,cy+2,1 do -- if the collision area is large then increase the - and + area to check (+2 etc)
        for x2=cx-1,cx+2,1 do
            if map[x2]~=nil and map[x2][y2]~=nil then
                if map[x2][y2] ~= 2 then
                    
                    x3 = (x2-tx)*tilewidth+ox
                    y3 = (y2-ty)*tileheight+oy
                    
                    if rectsoverlap(x+offsetx,y+offsety,w,h,x3,y3,tilewidth,tileheight) then
                        return true
                    end
                end
            end
        end
    end
    return false
end

function linetilecollide(x,y,xt,yt)
    tx = math.floor((position.x) / tilewidth)
    ty = math.floor((position.y) / tileheight)
    -- get our offset for smooth scrolling
    ox = math.floor(tx*tilewidth-position.x)
    oy = math.floor(ty*tileheight-position.y)
    
    cx = math.floor((x)/tilewidth)+tx
    cy = math.floor((y)/tileheight)+ty
    x2 = 0
    y2 = 0
    for y2=cy-2,cy+3,1 do -- if the collision area is large then increase the - and + area to check (+2 etc)
        for x2=cx-2,cx+3,1 do
            if map[x2]~=nil and map[x2][y2]~=nil then
                if map[x2][y2] ~= 2 then
                    x3 = (x2-tx)*tilewidth+ox
                    y3 = (y2-ty)*tileheight+oy
                    if get_line_intersect(x,y,xt,yt,x3,y3,x3+tilewidth,y3) or
                    get_line_intersect(x,y,xt,yt,x3,y3+tileheight,x3+tilewidth,y3+tileheight) or
                    get_line_intersect(x,y,xt,yt,x3,y3,x3,y3+tileheight) or
                    get_line_intersect(x,y,xt,yt,x3+tilewidth,y3,x3+tilewidth,y3+tileheight) then
                        -- quick hack to remove tiles with mining laser
                        underground=false
                        for y4=y2-1,y2+1 do
                            for x4=x2-1,x2+1 do
                                if map[x4]~=nil and map[x4][y4]~=nil then
                                    if map[x4][y4]==2 then
                                        underground=true
                                    end
                                end
                            end
                        end
                        
                        if breakx==x2 and breaky==y2 then
                        else
                            breakcount=0
                            breakdelay=0
                        end
                        breaklastcount = 0
                        breakx = x2
                        breaky = y2
                        
                        if breakdelay>20 then breakcount = breakcount + 1 end
                        
                        if underground == false and breakcount>5 then 
                            
                            if map[x2][y2]==1 then
                                tile = pickupstoneore
                            elseif map[x2][y2] == 3 then
                                tile = pickupironore
                            elseif map[x2][y2] == 4 then
                                tile = pickupgoldore
                            elseif map[x2][y2] == 5 then    
                                tile = pickupsilverore
                            elseif map[x2][y2] == 6 then
                                tile = pickupstoneore
                            elseif map[x2][y2] == 7 then
                                tile = pickupstoneore
                            end
                            
                            map[x2][y2]=nil
                            insertpickup(x3+24,y3+32,tile)
                            --table.insert(pickups,pickup(x3+24,y3+32,tile))
                        end
                        if underground==true then map[x2][y2]=2 end
                        
                        return true
                        
                    end
                end
            end
        end
    end
    return false
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

function insertpickup(x,y,num)
    if pickups==nil then 
        table.insert(pickups,pickup(x,y,num))
        return
    end
    for i=0,#pickups do
        if pickups[i]~=nil and pickups[i].active==false then
            table.insert(pickups,pickup(x3+24,y3+32,tile))
            return
        end
    end
    table.insert(pickups,pickup(x3+24,y3+32,tile))
end
