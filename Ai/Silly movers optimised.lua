
 -- Botcoordination


-- added a grif collision system
-- for better performance.
-- gauntlet gdc talk


maxbots = 25
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
        map[x][y]=1
    end
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
    self.whisker = {}
    self.stuckcnt = 0
    self.prvpos = vec2(0,0)
end
function bot:draw()
    rect(self.position.x,self.position.y,botwidth,botheight)
end
function bot:update()
    -- move bots away from other bots
    --do goto sk end
    if math.floor(self.prvpos.x) == math.floor(self.position.x)
    and math.floor(self.prvpos.y) == math.floor(self.position.y) then
        self.stuckcnt = self.stuckcnt + 1
        
    end
    self.prvpos.x=math.floor(self.position.x)
    self.prvpos.y=math.floor(self.position.y)
    
    if self.stuckcnt>100 then
        self.stuckcnt=0
        a = math.rad(math.random(0,360))
        self.position.x=self.position.x+math.cos(a)*10
        self.position.y=self.position.y+math.sin(a)*10
    end
    ::sk::
    --do goto sk end
    sx = math.floor(self.position.x/cellwidth)
    sy = math.floor(self.position.y/cellheight)
    for ax=sx-1,sx+1 do
        for ay=sy-1,sy+1 do
            if ax>0 and ay >0 and ax<20 and ay<20 then
                for i=1,#mapcol[ax][ay] do
                    
                    if i~=self.id then
                        
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

    
    a = math.atan2(self.position.y-self.target.y,self.position.x-self.target.x)     
    
    
    
    self.position.x = self.position.x - math.cos(            a)
    self.position.y = self.position.y - math.sin(            a )
    
    
    for y=-16,16,5 do
        for x=-16,20,5 do
            tx = (self.position.x+x)/cellwidth
            ty = (self.position.y+y)/cellheight
        tx = math.floor(tx)
            ty = math.floor(ty)
            
            if tx>0 and ty>0 and tx<20 and ty<20 and map[tx][ty]==1 then
                a = math.atan2(ty*cellheight-self.position.y,tx*cellwidth-self.position.x)
            self.position.x = self.position.x - math.cos(a)
            self.position.y = self.position.y - math.sin(a)
            end
        end
    end
    
    if self.position:dist(self.target)<32 then
        if self.target.y == HEIGHT-59 then
            self.target.y=59
            self.target.x =math.random(64,WIDTH-64)
        else
            self.target.y = HEIGHT-59
            self.target.x = math.random(64,WIDTH-64)
        end
    end
    
end
function bot:findpath()
    
end


-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    for i=1,maxbots do
        bots[i]=bot(i,i*botwidth+50,100)
        bots[i].target = vec2(WIDTH/2,HEIGHT-59)
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
    
    
    
    drawmap()
    for i=1,#bots do
        for z=1,2 do
        bots[i]:update()
        end
        bots[i]:draw()
            
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
