
 


-- Pattern Movement

-- enum the instruction
DIR = {
    NORTH = 1,
    EAST = 2,
    SOUTH = 4,
    WEST = 5,
    NORTHEAST = 6, -- not implemented,,
    SOUTHEAST = 7,
    SOUTHWEST = 8,
    NORTHWEST = 9
}

-- the self class
npc = class()
-- init function of the self class
function npc:init(x,y)
    self.active = true
    self.position = vec2(320,200)
    self.width = 32
    self.height = 32
    self.target = vec2(320,200)
    self.speed = 2
    self.path={DIR.EAST,DIR.SOUTH,DIR.WEST,DIR.NORTH}
    self.pos = 1
end
-- create the self
player=npc(320,100)

function npc:update()
    local angle = math.atan2(self.position.y-self.target.y,self.position.x-self.target.x) 
    self.position.x = self.position.x - math.cos(angle)
    self.position.y = self.position.y - math.sin(angle)
    -- if close to target, find next target
    if self.position:dist(self.target)<5 then
        self.pos = self.pos + 1
        if self.pos > #self.path then self.pos = 0 end
        if self.path[self.pos]==DIR.EAST then
            self.target.x = self.target.x + 64
        end
        if self.path[self.pos]==DIR.SOUTH then
            self.target.y = self.target.y + 64
        end
        if self.path[self.pos]==DIR.WEST then
            self.target.x = self.target.x - 64
        end
        if self.path[self.pos]==DIR.NORTH then
            self.target.y = self.target.y - 64
        end
        
    end
end



-- Use this function to perform your initial setup
function setup()
    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)
    
    -- This sets the line thickness
    strokeWidth(5)
    -- move the self
    player:update()
    -- draw the pkayer
    rect(player.position.x,player.position.y,player.width,player.height)
    -- Do your drawing here
    
end
