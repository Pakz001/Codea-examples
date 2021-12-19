-- Infinite Scroller

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    position = vec2(0,0)
    map = {}
    countdown=0
end

-- This function gets called once every frame
function draw() 
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
    countdown = countdown - 1
    if countdown<0 then
        createrandommapsection(math.floor(position.x / 64)+20,0,math.random(2,6),math.random(2,8))
        createrandommapsection(math.floor(position.x / 64)+20,0,25,1)
        countdown = math.random(10,120)
    end
    
    
    drawmap()
    -- increase our position
    position.x=position.x+4
    text(position.x,WIDTH/2,HEIGHT-50)
    
end

function drawmap()
    -- get our tile position
    -- 64s are the tile width and height
    tilex = math.floor(position.x / 64)
    tiley = math.floor(position.y / 64)
    -- get our offset for smooth scrolling
    offx = math.floor(tilex*64-position.x)
    offy = math.floor(tiley*64-position.y)
    -- draw a section of the map on the screen
    for x=0,20,1 do
        for y=0,20,1 do
            if map[x+tilex]==nil==false and map[x+tilex][y+tiley]==nil==false then
                fill(255)
                stroke(255)
                rect(x*64+offx,y*64+offy,64,64)
            end
        end
    end
end
-- create a random set of blocks on the map table
function createrandommapsection(x,y,w,h)
    -- make a 50 by 50 map section at -100 x and -100 y
    for x1=x,x+w do
        if map[x1]==nil then map[x1]={} end
        for y1=y,y+h do
            map[x1][y1]=2
            
        end
    end
end
