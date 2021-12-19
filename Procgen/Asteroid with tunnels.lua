-- Procgen Asteroid Tunnels

mapwidth = 512
mapheight = 512
tilewidth = WIDTH / mapwidth
tileheight = HEIGHT / mapheight
map = {}
tempmap = {}

numtunnels = 50

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    -- create our asteroid map
    for x=0,mapwidth do
        map[x]={}
        tempmap[x]={}
        for y=0,mapheight do
            map[x][y]=0        
            tempmap[x][y]=0
        end
    end
    
    createasteroid()
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    drawmap()
end

function drawmap()
    stroke(255)
    fill(255)
    for y=0,mapheight do
        for x=0,mapwidth do
            if tempmap[x][y]==2 then
                x1 = x*tilewidth
                y1 = y*tileheight
                rect(x1,y1,tilewidth+1,tileheight+1)
            end
        end
    end
end

function createasteroid()
    -- create points on the map
    for i=0,numtunnels do
        x1 = math.random(mapwidth/2-mapwidth/4,mapwidth/2+mapwidth/4)
        y1 = math.random(mapheight/2-mapheight/4,mapheight/2+mapheight/4)
        map[x1][y1] = 1
    end
    -- find a starting point
    startx = nil
    starty = nil
    while startx == nil do
        x1 = math.floor(math.random()*mapwidth)
        y1 = math.floor(math.random()*mapheight)
        if map[x1][y1]==1 then
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
            x1 = math.floor(math.random()*mapwidth)
            y1 = math.floor(math.random()*mapheight)
            if map[x1][y1]==1 and tempmap[x1][y1]==0 then
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
            map[math.floor(startx)][math.floor(starty)]=0
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
    for i=0,mapwidth*mapheight*4 do
        x1 = math.floor(math.random()*mapwidth)
        y1 = math.floor(math.random()*mapheight)
        if tempmap[x1][y1] == 1 or tempmap[x1][y1] == 2 then
            for x2=x1-1,x1+1 do
                for y2=y1-1,y1+1 do
                    if x2<0 or x2>=mapwidth or y2<0 or y2>=mapheight then break end
                    if tempmap[x2][y2]==0 then
                        tempmap[x2][y2]=2
                    end
                end
            end
        end
    end
end
