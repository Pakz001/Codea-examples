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

-- the player class
npc = class()
-- init function of the player class
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
-- create the player
player=npc(100,100)





-- Use this function to perform your initial setup
function setup()
    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
    -- move the player
    local angle = math.atan2(player.position.y-player.target.y,player.position.x-player.target.x)
    player.position.x = player.position.x - math.cos(angle)
    player.position.y = player.position.y - math.sin(angle)
    -- if close to target, find next target
    if player.position:dist(player.target)<5 then
    player.pos = player.pos + 1
    if player.pos > #player.path then player.pos = 0 end
        if player.path[player.pos]==DIR.EAST then
            player.target.x = player.target.x + 64
        end
        if player.path[player.pos]==DIR.SOUTH then
            player.target.y = player.target.y + 64
        end
        if player.path[player.pos]==DIR.WEST then
            player.target.x = player.target.x - 64
        end
        if player.path[player.pos]==DIR.NORTH then
             player.target.y = player.target.y - 64
        end
        
    end
    -- draw the pkayer
    rect(player.position.x,player.position.y,player.width,player.height)
    -- Do your drawing here
    
end

