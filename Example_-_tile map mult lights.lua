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
    lightmapbase = {}-- contains all stationary lights
    for x=0,mw do
        map[x]={}
        lightmapbase[x]={}
        lightmap[x]={}
        for y=0,mh do
            map[x][y]=0
            lightmapbase[x][y]=0
            lightmap[x][y]=0
        end
    end
    for i=1,3 do
        wallrect(math.random(5,30),math.random(5,30),20,3)
    end
    
    
    for i =0,3 do
        x = math.random(1,mw-1)
        y = math.random(1,mh-1)
        while map[x][y]==1 or (map[x][y+1]==0 and map[x][y-1]==0) do
            x = math.random(1,mw-1)
            y = math.random(1,mh-1)
        end
        clearlightmap()
        placetorch(x,y)
        mixlightmaptobase()
    end
    mixlightmaps()
    
    x = math.random(1,mw-1)
    y = math.random(1,mh-1)
    while map[x][y]==1 do
        x = math.random(1,mw-1)
        y = math.random(1,mh-1)
    end

    lmpos = vec2(x,y)
    lmdes = vec2(10,10)
    cnt=0
end 

-- This function gets called once every frame
function draw() 
    -- This sets a dark background color 
    background(0,0,0)
    
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
        mixlightmaps()
    end
    -- Do your drawing here
    drawmap()
    fill(255,255,0)
    stroke(255)
    rect(lmpos.x*tw,lmpos.y*th,tw,th)
end
-- add current lightmap to lightmap base. count up light particles.
function mixlightmaptobase()
    for y=0,mh do
        for x=0,mw do
            if lightmapbase[x][y]~=0 and lightmap[x][y]~=0 then
                lightmapbase[x][y]=(lightmapbase[x][y]+lightmap[x][y])
                if lightmap[x][y]>255 then lightmapbase[x][y]=255 end
            end
            if lightmapbase[x][y]==0 and lightmap[x][y]~=0 then
                lightmapbase[x][y]=lightmap[x][y]
            end
            --if lightmapbase[x][y]~=0 and lightmap[x][y]==0 then
                
            --end
        end
    end
end
-- create our main lightmap for drawing the map
-- adding the stationary lights(base) with current lightmap.
-- add up all light particles.
function mixlightmaps()
    for y=0,mh do
        for x=0,mw do
            if lightmapbase[x][y]~=0 and lightmap[x][y]~=0 then
                lightmap[x][y]=(lightmapbase[x][y]+lightmap[x][y])
                if lightmap[x][y]>255 then lightmap[x][y]=255 end
            end
            if lightmap[x][y]==0 and lightmapbase[x][y]~=0 then
                lightmap[x][y]=lightmapbase[x][y]
            end
            --lightmap[x][y]=lightmap[x][y]/2+lightmapbase[x][y]/2
        end
    end
end

function clearlightmapbase()
    for x=0,mw do
        lightmapbase[x]={}
        for y=0,mh do
            lightmapbase[x][y]=0
        end
    end       
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
    --switch = {vec2(-1,0),vec2(0,-1),vec2(1,0),vec2(0,1)}
    switch = {vec2(-1,0),vec2(-1,-1),vec2(0,-1),vec2(1,-1),vec2(1,0),vec2(1,1),vec2(0,1),vec2(-1,1)}
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
                            lightmap[pos.x][pos.y]=(lightmap[x][y]/100)*80
                        else
                            lightmap[pos.x][pos.y]=(lightmap[x][y]/100)*30
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
    blendlight(orig.x,orig.y)
end
function blendlight2(x,y)
    for x1 = x-10,x+10 do
    for y1 = y-10,y+10 do
        if x1>=0 and y1>=0 and x1<mw and y1<mh then
            z=0
            d=0
            for y2=y1-1,y1+1 do
                for x2=x1-1,x1+1 do
                    if x2>=0 and y2>=0 and x2<mw and y2<mh then
                        z=z+lightmap[x2][y2]
                        d=d+1
                        
                    end
                end
            end
            lightmap[x1][y1]=z/d      
        end
        end
        end
end
-- this is a flickering style of lighting
function blendlight(x,y)
    for i = 1,(6*6)*100 do
        x1 = x+math.random(-6,6)
        y1 = y+math.random(-6,6)
        if x1>=0 and y1>=0 and x1<mw and y1<mh then
            z=0
            d=0
            for y2=y1-1,y1+1 do
                for x2=x1-1,x1+1 do
                    if x2>=0 and y2>=0 and x2<mw and y2<mh then
                        z=z+lightmap[x2][y2]
                        d=d+1
                    
                    end
                end
            end
            lightmap[x1][y1]=z/d      
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
                fill(40,40,0,lightmap[x][y])
                stroke(40,40,0,lightmap[x][y])
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
