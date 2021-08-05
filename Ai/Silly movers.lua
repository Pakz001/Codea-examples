 -- Botcoordination

botwidth = 16
botheight = 16
cellwidth = WIDTH/20
cellheight = HEIGHT/20

-- contains the obstacles
map = {}
-- used for pathfinding
mappath = {}
-- set up the maps
for x = 0, 20 do
    map[x]={}
    mappath[x]={}
    for y = 0, 20 do
        mappath[x][y]=0
        map[x][y]=0
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
function bot:init(x,y)
    -- path contains cell location
    self.path = {} -- path of vec2
    self.position = vec2(x,y)
    self.target = vec2(0,0)
    self.pos = 1 -- position in path
    self.speed = 0.5
    self.whisker = {}
end
function bot:draw()
    rect(self.position.x,self.position.y,botwidth,botheight)
end
function bot:update()
    -- move bots away from other bots
    
    for i,v in ipairs(bots) do
        if v~=self then
            if v.position:dist(self.position)<32 then
                a = math.atan2(v.position.y-self.position.y,v.position.x-self.position.x)
                
                
        
                
              v.position.x = v.position.x + math.cos(            a)
             v.position.y = v.position.y + math.sin(            a )
       
    
                
            end
        end
    end
    
    
    a = math.atan2(self.position.y-self.target.y,self.position.x-self.target.x)     
    
    
    
 self.position.x = self.position.x - math.cos(            a)
    self.position.y = self.position.y - math.sin(            a )
    
    
    for y=-16,16,5 do
        for x=-16,16,5 do
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
        else
            self.target.y = HEIGHT-59
        end
    end
    
end
function bot:findpath()
    
end


-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    for i=1,5 do
        bots[i]=bot(i*botwidth+50,100)
        bots[i].target = vec2(WIDTH/2,HEIGHT-59)
    end
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
    drawmap()
    for i=1,#bots do
        bots[i]:update()
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
