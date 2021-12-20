-- Asteroids Ship
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
    for y=1,mytiles.height,1 do
        for x=1, mytiles.width,1 do
            r,g,b,a = mytiles:get(x,y)
            if r==255 and g==0 and b==255 and a==255 then
                mytiles:set(x,y,0,0,0,0)
            end
        end
    end
    
    --ship = mytiles:copy(17,128-15,8,8)
    --block1 = mytiles:copy(17,128-7,8,8)
    ship = mytiles:copy(33,256-31,16,16)
    --ship = mytiles:copy(33,1*16,16,16)
    block1 = mytiles:copy(63,448,16,16)
    block2 = mytiles:copy(80,272,16,16)
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
    pushMatrix()
    translate(WIDTH/2,HEIGHT/2)
    scale(gamescale,gamescale)
    rotate(math.deg(currentangle)-90)
    --sprite(im,0,0)
    scale(4,4)
    sprite(ship,0,0)
    popMatrix()
    
    
    
    
    -- draw buildgrid
    buildgridedit()
    drawbuildgrid()
    updatebuildicon()
    drawbuildicon()
    
    updatespeedcontrols()
    drawspeedcontrols()
    fill(255,0,0)
    text("press anywhere on the screen to turn.",WIDTH/2,HEIGHT-50)
    text("starposition : "..math.floor(position.x/64)..","..math.floor(position.y/64),WIDTH-150,HEIGHT-50)
    -- collision with tiles
    if recttilecollide(WIDTH/2-((64*gamescale)/2),HEIGHT/2-((64*gamescale)/2),64*gamescale,64*gamescale,0,0) == true then
        --text("collision",WIDTH/2,100)
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
                
                rect(x*tilewidth+offx,y*tileheight+offy,tilewidth+1,tileheight+1)
                pushMatrix()
                translate(x*tilewidth+offx,y*tileheight+offy)
                --scale(gamescale,gamescale)
                scale(4,4)
                if map[x+tilex][y+tiley]==1 then
                    sprite(block1,8,8)
                else
                    sprite(block2,8,8)
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
            if map[x2]~=nil and map[x2][y2]~=nil and map[x2][y2] == 1 then
                
                x3 = (x2-tx)*tilewidth+ox
                y3 = (y2-ty)*tileheight+oy
            
                if rectsoverlap(x+offsetx,y+offsety,w,h,x3,y3,tilewidth,tileheight) then
                    return true
                end
            end
        end
    end
    return false
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
        end
    end
    
    
    
end
