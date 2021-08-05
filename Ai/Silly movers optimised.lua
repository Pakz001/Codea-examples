

-- Botcoordination


-- added a grif collision system
-- for better performance.
-- gauntlet gdc talk


maxbots = 32
botwidth = 16
botheight = 16
cellwidth = WIDTH/20
cellheight = HEIGHT/20






mapcol = {}
collist = {}

-- contains the obstacles
map = {}
-- used for pathfinding
mappath = {} 
-- set up the maps
for x = 0, 20 do
    map[x]={}
    mappath[x]={}
    mapcol[x]={}
    for y = 0, 20 do
        mappath[x][y]=0
        map[x][y]=0
        mapcol[x][y]=collist
    end
end
for x=3,17,3 do
    for y=8,20-8 do
        map[y][x]=1
    end
end
for y=8,20-8 do
    map[3][y]=1
    map[20-3][y]=1
end

-- set up the bots
bots = {}
bot = class()
function bot:init(num,x,y)
    self.id = num
    -- path contains cell location
    self.path = {} -- path of vec2
    self.position = vec2(x,y)
    self.target = vec2(0,0)
    self.pos = 1 -- position in path
    self.speed = 0.5
    --self.whisker = {}
    self.stuckcnt = 0
    self.prvpos = vec2(0,0)
    self.temptarget = vec2(-1,-1)
    self.state=0
    self.lc=vec2()
    self.rc=vec2()
    self.bc=vec2()
    self.uc=vec2()
    
end
function bot:draw()
    rect(self.position.x,self.position.y,botwidth,botheight)
end
function bot:update()
    -- move bots away from other bots
    
    
  slide=false
    
    if self.prvpos.x==math.floor(self.position.x/10) and self.prvpos.y==math.floor(self.position.y/10)then
        self.stuckcnt=self.stuckcnt+1
    else
        self.stuckcnt = 0
    end
    self.prvpos.x = math.floor(self.position.x/10)
    self.prvpos.y = math.floor(self.position.y/10)
    if self.stuckcnt> 160 then
        self.state=1
        self.temptarget = self.lc
    end
    --do goto sk     if slide==false then
    if self.state==0 then
    for y=-26,26,5 do
        for x=-26,30,5 do
            tx = (self.position.x+x)/cellwidth
            ty = (self.position.y+y)/cellheight
            tx = math.floor(tx)
            ty = math.floor(ty)
            
            if tx>0 and ty>0 and tx<20 and ty<20 and map[tx][ty]==1 then
                local w = 0
                local h = 0
                local l = tx
                local r = tx
                local u = ty
                local d = ty
                
                    while r<20 and map[r][ty]==1 do
                        r=r+1
                    end
                    r=r-tx
                    while l > 0 and map[l][ty]==1 do
                        l=l-1
                    end
                    l=l-tx
                    while u < 20 and map[tx][u]==1 do
                        u=u+1
                    end
                    u=u-ty
                    while d > 0 and map[tx][d]==1 do
                        d=d-1
                    end
                    d=d-ty
                    self.lc = vec2((tx+l)*cellwidth,ty*cellheight)
                    self.rc = vec2((tx+r)*cellwidth,ty*cellheight)
                    self.uc = vec2(tx*cellwidth,(ty+u)*cellheight)
                    self.bc = vec2(tx*cellwidth,(ty+d)*cellheight)
                end      
                    
            end
        end
    end
    
    
    
    ::sk::
    --do goto sk end
    sx = math.floor(self.position.x/cellwidth)
    sy = math.floor(self.position.y/cellheight)
    for ax=sx-1,sx+1 do
        for ay=sy-1,sy+1 do
            if ax>0 and ay >0 and ax<20 and ay<20 then
                for i=1,#mapcol[ax][ay] do
                    
                    if mapcol[ax][ay][i]~=self.id then
                        
                        if bots[mapcol[ax][ay][i]].position:dist(self.position)<20 then
                            
                            
                            a = math.atan2(bots[mapcol[ax][ay][i]].position.y-self.position.y,bots[mapcol[ax][ay][i]].position.x-self.position.x) 
                            
                            self.position.x = self.position.x -math.cos(a)
                            
                            self.position.y=self.position.y - math.sin(a)
                            
                            
                        end
                        
                        
                    end
                    
                    
                end
            end
        end
    end
    
    
    --::sk::
    
    if self.state==0 then
    a = math.atan2(self.position.y-self.target.y,self.position.x-self.target.x)     
    
    
    
    self.position.x = self.position.x - math.cos(            a)
    self.position.y = self.position.y - math.sin(            a )
    end
    if self.state==1 then
        a = math.atan2(self.position.y-self.temptarget.y,self.position.x-self.temptarget.x)     
        
        
        
        self.position.x = self.position.x - math.cos(            a)
        self.position.y = self.position.y - math.sin(            a )
    end
    
    
    if slide==false then
    for y=-16,16,5 do
        for x=-16,20,5 do
            tx = (self.position.x+x)/cellwidth
            ty = (self.position.y+y)/cellheight
            tx = math.floor(tx)
            ty = math.floor(ty)
            
            if slide==false and tx>0 and ty>0 and tx<20 and ty<20 and map[tx][ty]==1 then
                a = math.atan2(ty*cellheight-self.position.y,tx*cellwidth-self.position.x)
                self.position.x = self.position.x - math.cos(a)
                self.position.y = self.position.y - math.sin(a)
            end
        end
    end
    end
    
    if self.state == 0 and self.position:dist(self.target)<12 then
        if self.target.y == HEIGHT-20 then
            self.target.y=30
            self.target.x =math.random(64,WIDTH-64)
        else
            self.target.y = HEIGHT-20
            self.target.x = math.random(64,WIDTH-64)
        end
    end
    if self.state == 1 and self.position:dist(self.temptarget)<10 then
        self.state=0
    end
    
end



-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    for i=1,maxbots do
        bots[i]=bot(i,i*botwidth+50,50)
        bots[i].target = vec2(math.random(30,WIDTH-30),HEIGHT-59)
    end
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)
    
    -- This sets the line thickness
    strokeWidth(5)
    
    for x=0,20 do
        for y=0,20 do
            --if #mapcol[x][y]>50 then
            --print(#mapcol[x][y])
            --end
            for i=1,#mapcol[x][y] do
                
                table.remove(mapcol[x][y])
            end   
        end
    end
    for i=1,#bots do
        local x1 = math.floor(bots[i].position.x/cellwidth)
        local y1 =      
        
        math.floor(bots[i].position.y/cellheight)
        
        if x1>0 and y1 > 0 and x1 < 20 and y1 < 20 then
            table.insert(mapcol[x1][y1],i)
        end
        
    end
    
        fill(224, 131, 57)
        text(bots[1].stuckcnt,100,100)
    
    
    drawmap()
    for i=1,#bots do
        for z=1,2 do
            bots[i]:update()
        end
        bots[i]:draw()
        --fill(227, 197, 55)
       -- rect(bots[i].temptarget.x,bots[i].temptarget.y,20,20)
        --rect(bots[i].lc.x,bots[i].lc.y,20,20)
       -- rect(bots[i].rc.x,bots[i].rc.y,20,20)
        --rect(bots[i].uc.x,bots[i].uc.y,20,20)
       -- rect(bots[i].bc.x,bots[i].bc.y,20,20)
    end
    -- Do your drawing here
    
end

function drawmap()
    for y=0,#map do
        for x=0,#map do
            if map[x][y]==1 then
                
                fill(73)         rect(x*cellwidth,y*cellheight,cellwidth,cellheight)
            end
        end
    end
end
