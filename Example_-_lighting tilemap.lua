-- Map Torches


-- tilemap with lighting(no multiple torches-untested)
-- basically a 4way dijkstra fill with lower transparancy at every step
-- addtional less transparancy when block 1(solid)
-- ai is a move to target(random destination)

-- Use this function to perform your initial setup
function setup()
    print("Hello World! - restart if weird/stuck")
    mw = 50
    mh = 50
    tw = WIDTH/mw
    th = HEIGHT/mh
    map = {}
    lightmap = {}
    for x=0,mw do
        map[x]={}
        lightmap[x]={}
        for y=0,mh do
            map[x][y]=0
            lightmap[x][y]=0
        end
    end
    for i=1,3 do
        wallrect(math.random(5,30),math.random(5,30),20,3)
    end
    x = math.random(1,mw-1)
    y = math.random(1,mh-1)
    while map[x][y]==1 do
        x = math.random(1,mw-1)
        y = math.random(1,mh-1)
    end
    placetorch(x,y)
    lmpos = vec2(x,y)
    lmdes = vec2(10,10)
    cnt=0
end 

-- This function gets called once every frame
function draw() 
    -- This sets a dark background color 
    background(40, 40, 50)

    -- move the torch around
    cnt=cnt+1
    if cnt>8 then
        cnt=0
        
        oldx = lmpos.x
        oldy = lmpos.y
        if lmpos.x < lmdes.x then lmpos.x=lmpos.x+1 end
        if lmpos.y < lmdes.y then lmpos.y=lmpos.y+1 end
        if lmpos.x > lmdes.x then lmpos.x=lmpos.x-1 end
        if lmpos.y > lmdes.y then lmpos.y=lmpos.y-1 end
        if map[lmpos.x][lmpos.y]==1 then
            lmpos.x = oldx
            lmpos.y = oldy
        end
        if math.random()<.1 then
            lmdes.x = math.random(0,mw)
            lmdes.y = math.random(0,mh)
            while lightmap[lmdes.x][lmdes.y]<20 and lmdes:dist(vec2(oldx,oldy))<5 do
                lmdes.x = math.random(0,mw)
                lmdes.y = math.random(0,mh)
            end
        end
        clearlightmap()
        placetorch(lmpos.x,lmpos.y)
    end
    -- Do your drawing here
    drawmap()
    fill(255,255,0)
    stroke(255)
    rect(lmpos.x*tw,lmpos.y*th,tw,th)
end

function clearlightmap()
    for x=0,mw do
        lightmap[x]={}
        for y=0,mh do
            lightmap[x][y]=0
        end
    end
end

function placetorch(x,y)
    orig = vec2(x,y)
    openlist={}
    table.insert(openlist,vec2(x,y))
    lightmap[x][y]=255
    -- left top right bottom of our position
    switch = {vec2(-1,0),vec2(0,-1),vec2(1,0),vec2(0,1)}
    --switch = {vec2(-1,0),vec2(-1,-1),vec2(0,-1),vec2(1,-1),vec2(1,0),vec2(1,1),vec2(0,1),vec2(-1,1)}
    while #openlist>0 do
        x = openlist[1].x
        y = openlist[1].y
        table.remove(openlist,1)
        if lightmap[x][y]>10 and vec2(x,y):dist(orig)<12 then
            for i = 1,#switch do
                pos = vec2(x+switch[i].x,y+switch[i].y)
                if pos.x>=0 and pos.y>=0 and pos.x<mw and pos.y<mh then
                    if lightmap[pos.x][pos.y]==0 then
                        if map[x][y]==0 then
                            lightmap[pos.x][pos.y]=lightmap[x][y]-10
                        else
                            lightmap[pos.x][pos.y]=lightmap[x][y]-20
                        end
                        if map[pos.x][pos.y]==1 then
                            lightmap[pos.x][pos.y]=lightmap[pos.x][pos.y]/2
                        end
                        if lightmap[pos.x][pos.y]<0 then lightmap[pos.x][pos.y]=0 end
                        if lightmap[pos.x][pos.y]>0 then 
                            table.insert(openlist,vec2(pos.x,pos.y))
                        end
                    end
                 end
            end
        end
    
    end
end

function wallrect(x,y,w,h)
    for y1=y,y+h do
        for x1=x,x+w do
            if x1>=0 and y1>=0 and x1<mw and y1<mh then
                map[x1][y1]=1
            end
        end
    end
end
function drawmap() 
    for y = 0,mh,1 do
        for x = 0,mw,1 do
            if lightmap[x][y]>0 then
            if map[x][y]==0 then
                fill(55,55,55,lightmap[x][y])
                stroke(55,55,55,lightmap[x][y])
                rect(x*tw,y*th,tw,th)
            end
            if map[x][y]==1 then
                fill(255,155,55,lightmap[x][y])
                stroke(255,155,55,lightmap[x][y])
                rect(x*tw,y*th,tw,th)
                end
            end
        end
    end
end
