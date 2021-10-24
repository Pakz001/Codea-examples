-- lollypop map

leaf = class()

function leaf:init(x,y,dir)
    self.pos1 = vec2(x,y)
    if dir == -1 then self.pos2 = vec2(x-10,y+10) end
    if dir == 1 then self.pos2 = vec2(x+10,y+10) end
    self.active = true
end

plant = {}

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    table.insert(plant,leaf(620,120,-1))
    for i = 1 , 9501 do
        --pick a random spot and see if we can grow out
        spot = math.random(1,#plant)
        pos = vec2(plant[spot].pos2.x,plant[spot].pos2.y)
        if taken(pos,-1)==false then
            table.insert(plant,leaf(pos.x,pos.y,-1))
        end
        if taken(pos,1)==false then
            table.insert(plant,leaf(pos.x,pos.y,1))
        end
        
    end
end
-- is this new spot taken
function taken(pos,dir)
    if dir == -1 then pos = vec2(pos.x-10,pos.y+10) end
    if dir == 1 then pos = vec2(pos.x+10,pos.y+10) end    
    for i = 1,#plant do
        if plant[i].pos2.x == pos.x and plant[i].pos2.y == pos.y then return true end
        if plant[i].pos1.x == pos.x and plant[i].pos1.y == pos.y then return true end
    end    
    return false
end
-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(3)
    for i = 1,#plant do
        line(plant[i].pos1.x,plant[i].pos1.y,plant[i].pos2.x,plant[i].pos2.y)
    end
    
    -- Do your drawing here
    
end
