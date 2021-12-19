-- Hill Algorithm -- golden mountains

mapwidth = 800
mapheight = 600
tilewidth = WIDTH/mapwidth
tileheight = HEIGHT/mapheight

-- Use this function to perform your initial setup
function setup()
    --print(math.pi*2)
    
    map = {}
    for x=0,mapwidth do
        map[x]={}
        for y=0,mapheight do
            map[x][y]=0
            
        end
    end
    
    -- first we create some random spots and lines that we want to
    -- pile sand on.
    
    -- first some dots and smears
    for i=0,(mapwidth+mapheight) do
        x = math.random(0,mapwidth)
        y = math.random(0,mapheight)
        map[x][y] = 1
        if math.random()*10<3 then
            len = math.random(1,math.floor(mapwidth/10))
            for x1=x-len,x+len do
                for y1=y-len,y+len do
                    if x1<=mapwidth and y1<=mapheight and x1>=0 and y1>=0 then
                        map[x1][y1] = map[x1][y1] + 1
                    end
                end
            end
        end
    end
    -- here some lines(ridges)
    for i=0,(mapwidth+mapheight)/6 do
        angle=math.random(0.0,7.0)
        x=math.random(-mapwidth/2,mapwidth*1.5)
        y=math.random(-mapheight/2,mapheight*1.5)
        -- how long do we draw these lines(ridges)
        len = math.random(mapwidth+mapheight,(mapwidth+mapheight)*3)
        for j=0,len do
            x=x+math.cos(angle)*1
            y=y+math.sin(angle)*1
            if math.random()*10<3 then
                angle=angle+math.random()/4
            end
            if math.random()*10<3 then
                angle=math.random(0.0,7.0)
            end
            for y1=y-1,y+1 do
                for x1=x-1,x+1 do
                    if x1>=0 and y1>=0 and x1<mapwidth and y1<mapheight then
                        map[math.floor(x1)][math.floor(y1)]=map[math.floor(x1)][math.floor(y1)]+math.random(2,4)
                    end
                end
            end
        end
    end
    -- here we start shoveling sand ontop and abit besides of the sand below us.
    for i=0,(mapwidth+mapheight)*100 do
        x = math.random(1,mapwidth-1)
        y = math.random(1,mapheight-1)
        if map[x][y]>0 then
            for x1=x-1,x+1 do
                for y1=y-1,y+1 do
                    map[x1][y1] = map[x1][y1] + 1
                end
            end
        end
    end
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    for y=0,mapheight do
        for x=0,mapwidth do
            num = map[x][y]
            fill(num*4,num*2,num)
            stroke(num*4,num*2,num)
            rect(x*tilewidth,y*tileheight,tilewidth+2,tileheight+2)
        end
    end
    
end
