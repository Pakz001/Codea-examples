-- Procgen Asteroid Tunnels

pha = class()
function pha:init(x,y)
    self.pos = vec2(x,y)
    self.map = {}
    self.dest = vec2(x+2,y)
    self.vel = vec2(1,0)
end
phas = {}

genmapwidth = 200
genmapheight = 200
tilewidth = WIDTH / genmapwidth
tileheight = HEIGHT / genmapheight
genmap = {}
tempmap = {}
pathmap = {}

numtunnels = (genmapwidth+genmapheight)/15

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    -- create our asteroid map
    for x=0,genmapwidth do
        genmap[x]={}
        tempmap[x]={}
        pathmap[x]={}
        for y=0,genmapheight do
            genmap[x][y]=0        
            tempmap[x][y]=0
            pathmap[x][y]=0
        end
    end
    
    createasteroid()
    makepathmap()
    for i=1,32 do
        pos = phafindstartpos()
        table.insert(phas,pha(pos.x,pos.y))
    end
    makephasmaps()
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(0)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    drawmap()
    --drawpathmap()
    cnt=cnt+1
    if cnt==1 then
        updatephas()
        cnt=0
    end
    drawphas()
    --text(phas[1].pos.x..""..phas[1].vel.x,WIDTH/2,50)
end

function updatephas()
    for i=1,#phas do
        if i==1 then
            --print(phas[i].pos.x..","..phas[i].pos.y)
        end
        --if phas[i].pos.x > phas[i].dest.x then phas[i].pos.x=phas[i].pos.x-.1 end
        --if phas[i].pos.x < phas[i].dest.x then phas[i].pos.x=phas[i].pos.x+.1 end
        --if phas[i].pos.y > phas[i].dest.y then phas[i].pos.y=phas[i].pos.y-.1 end
        --if phas[i].pos.y < phas[i].dest.y then phas[i].pos.y=phas[i].pos.y+.1 end
   
        a = math.atan2(phas[i].pos.y-phas[i].dest.y,phas[i].pos.x-phas[i].dest.x)
        phas[i].pos.x=phas[i].pos.x-(math.cos(a)/10)
        phas[i].pos.y=phas[i].pos.y-(math.sin(a)/10)
        if i==1 then
            --print(phas[i].pos:dist(phas[i].dest))
        end
        if phas[i].pos:dist(phas[i].dest) <=.1 then
            phas[i].pos.x=phas[i].dest.x
            phas[i].pos.y=phas[i].dest.y
            x = math.floor(phas[i].pos.x)
            y = math.floor(phas[i].pos.y)
            phas[i].map[x][y]=phas[i].map[x][y]+math.random(1,3)
            val = phas[i].map[x][y]
            --addphasweight(i,x,y)
            -- find nearby lower point
            --val = getphasweight(i,x,y)
            spots = {}
            an = {}
            for aa=0,360 do  
                table.insert(an,false)
            end
        --for md=1,3,.1 do
            for a =1,360,1 do

                d=0

                d=0
                ex=false
                x1 = x
                y1 = y
                while ex==false do
                    x1 = x1 +( math.cos(math.rad(a)))
                    y1 = y1 + (math.sin(math.rad(a)))
                    d=d+1
                    if x1>=0 and y1>=0 and x1<genmapwidth and y1<genmapheight then
                        if tempmap[math.floor(x1)][math.floor(y1)]~=1 then
                            ex=true
                            an[a]=true
                            --if math.random()<.1 then print("edge") end
                        end
                        --b = getphasweight(i,math.floor(x1),math.floor(y1))
                        b=phas[i].map[math.floor(x1)][math.floor(y1)]
                        --pathmap[math.floor(x1)][math.floor(y1)]=-1
                        --if an[a]==false then q = 1 else q = 0 end
                        --if b>-1 then print(b..","..val..","..q) end
                        if an[a]==false and b~=-1 and b<val then
                            an[a]=true
                            --removephas(i,math.floor(x1),math.floor(y1))
                            --pathmap[math.floor(x1)][math.floor(y1)] = -1
                            table.insert(spots,vec2(math.floor(x1),math.floor(y1)))
                            --if math.random()<5 then print("new spot") end
                            --phas[i].pos.x = math.floor(x1)
                            --phas[i].pos.y = math.floor(y1)
                            ex=true
                            --a=360
                            --md=20
                        end
                    else
                        ex=true
                        an[a]=true
                    end    
                    if d>16 then
                        ex=true
                    end
                    --if #spots>1400 then
                    --    if math.random()<.01 then print("max spots.") end
                    --    md=20
                    --    ex=true
                    --end
                end
            end   
        --end
        -- pick spot with lowest value
            --if math.random()<.01 and #spots==0 then print("no spots") end
            --if #spots==0 then print("no spots to select") end
            --print(math.random())
            lowest=val
            nx=0
            ny=0
            for j=1,#spots do
                --b=getphasweight(i,spots[j].x,spots[j].y)
                b=phas[i].map[spots[j].x][spots[j].y]
                if b<lowest then
                    lowest = b
                    phas[i].dest.x = spots[j].x
                    phas[i].dest.y = spots[j].y
                
                end
            end
        end
        
    end
    
end



function makephasmaps()
    for i=1,#phas do
        for x=0,genmapwidth do

            phas[i].map[x]={}
            for y=0,genmapheight do
                if pathmap[x][y]~=1 then
                    phas[i].map[x][y]=-1
                else
                    phas[i].map[x][y]=math.random(1,16)
                end    
            end
        end
    end
end
    
function drawphas()
    fill(255)
    stroke(255, 8, 0)
    for i=1,#phas do
        rect(phas[i].pos.x*tilewidth,phas[i].pos.y*tileheight,tilewidth,tileheight)
    end
end

function makepathmap()
    for y = 1,genmapheight-1 do
        for x = 1,genmapwidth-1 do
            soko=false
            cnt=0
            cnt2=0
            for zy=-1,1 do
                for zx=-1,1 do
                    if tempmap[x+zx][y+zy]==1 then
                        cnt=cnt+1
                    end
                    if pathmap[x+zx][y+zy]==1 then
                        cnt2=cnt2+1
                    end
                end
            end
            
            
            if cnt>8 and cnt2<2 then
                --pathmap[x][y]=1
                --
                lowest = 100
                whackbonk=false
                for i = 1,360,math.floor(360/16) do
                    len = 0
                    x1 = x
                    y1 = y
                    x2 = x
                    y2 = y
                    xit = false
                    while xit==false do
                        len=len+1
                        x1=x1+math.cos(math.rad(i))
                        y1=y1+math.sin(math.rad(i))
                        x2=x2+math.cos(math.rad(i+180))
                        y2=y2+math.sin(math.rad(i+180))
                        if len>10 then xit=true end


                        if x1<0 or y1<0 or x1>=genmapwidth or y1>=genmapheight or x2<0 or y2<0 or x2>=genmapwidth or y2>=genmapheight then
                            xit=true
                        else
                            if tempmap[math.floor(x1)][math.floor(y1)]>1 then
                                xit=true
                            end
                            if tempmap[math.floor(x2)][math.floor(y2)]>1 then
                                xit=true
                            end
                            if tempmap[math.floor(x1)][math.floor(y1)]>1 and tempmap[math.floor(x2)][math.floor(y2)]>1 then 
                                xit=true 
                                i=460
                                lowest = len
                                whackbonk=true
                            end
                        end
                    end
                end
                if whackbonk==true  then
                    pathmap[x][y]=1
                end
            end
        end
    end
end
function drawpathmap()
    for y=0,genmapheight do
        for x=0,genmapwidth do
            if pathmap[x][y]==1 then
                stroke(215, 187, 12)
                fill(255, 242, 0)
                x1 = x*tilewidth
                y1 = y*tileheight
                rect(x1,y1,tilewidth+1,tileheight+1)
            end

        end
    end
    
end
function drawmap()

    stroke(255)
    fill(255)
    for y=0,genmapheight do
        for x=0,genmapwidth do
            if tempmap[x][y]==2 then
                stroke(60, 42, 29)
                fill(100, 59, 32)
                x1 = x*tilewidth
                y1 = y*tileheight
                rect(x1,y1,tilewidth+1,tileheight+1)
            end
            if tempmap[x][y]==1 then
                stroke(28, 23, 19)
                fill(28, 22, 19)
                x1 = x*tilewidth
                y1 = y*tileheight
                rect(x1,y1,tilewidth+1,tileheight+1)
            end
            if tempmap[x][y]==3 then -- gold
                stroke(155, 68, 26)
                fill(185, 121, 24)
                x1 = x*tilewidth
                y1 = y*tileheight
                rect(x1,y1,tilewidth+1,tileheight+1)
            end
            if tempmap[x][y]==4 then -- iron
                stroke(174)
                fill(185)
                x1 = x*tilewidth
                y1 = y*tileheight
                rect(x1,y1,tilewidth+1,tileheight+1)
            end
            if tempmap[x][y]==5 then -- silver
                stroke(255)
                fill(255)
                x1 = x*tilewidth
                y1 = y*tileheight
                rect(x1,y1,tilewidth+1,tileheight+1)
            end
            if tempmap[x][y]==6 then -- b lock 3
                stroke(135, 49, 29)
                fill(90, 32, 32)
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
                    z = math.random(2,4)
                    zdelay = math.random(0,10)
                end
                -- create our tunnel
                for r=-z,z,.3 do
                    if startx+r>0 and startx+r<genmapwidth and starty+r>0 and starty+r<genmapheight then
                        tempmap[math.floor(startx+r)][math.floor(starty+r)]=1
                    end
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
    
    -- exits
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
                    if x2+x>=0 and y2+y>=0 and x2+x<genmapwidth and y2+y<genmapheight then
                        if tempmap[math.floor(x2+x)][math.floor(y2+y)]==2 then 
                            done = false 
                        end
                    end
                end
            end
            
            --if done==true then j=genmapwidth end
            if done==false then
            for y1=-2,1 do
                for x1=-2,1 do
                    if x+x1>=0 and y+y1>=0 and x+x1<genmapwidth and y+y1<genmapheight then
                        tempmap[math.floor(x+x1)][math.floor(y+y1)] = 1
                    end
                end
            end
            end
        end
    end
    
    
    
    -- add ore veins and spots
    for i=0,genmapwidth+genmapheight*6 do
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
        x = math.random(10,genmapwidth-10)
        y= math.random(10,genmapheight-10)
        if tempmap[math.floor(x)][math.floor(y)]==2 then
            tempmap[math.floor(x)][math.floor(y)]=6
        end
    end
    for i=0,(genmapwidth+genmapheight*5) do
        x = math.random(10,genmapwidth-10)
        y= math.random(10,genmapheight-10)
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
        
end

function phafindstartpos()
    done=false
    repeat
        x = math.random(10,genmapwidth-10)
        y = math.random(10,genmapheight-10)
        if pathmap[x][y]>0 then
            return vec2(x,y)
        end
    until done
end
