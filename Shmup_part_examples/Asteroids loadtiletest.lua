-- Tileloadtest

-- here is my current method of loading and processing a sprite atlas.
-- a atlas is afaik a spritesheet that contains tiles for a game level
-- or sprites that are the agents or player in a game.
-- in codea you can copy or load in a asset as a sprite. with some
-- code I extract each frame into a single image. these are then
-- used.
-- I am using pixaki as a sprite editor. i was not sure if it can
-- set the alpha value which make a particula color transparent. I
-- thus used a purple like color(255,0,255) for the transparent
-- color and convert this into a transparent color with code myself.

-- codea uses a inverted coordinate system. i thus created a map on
-- the screen which shows the coordinates on each cell drawn on the screen.
-- i use these(screenshot) to copy the coordinates into my project.

-- press the do button on the top right in codea. select assets
-- and load in the "mytiles 2.png" and "ui space.png" from my github
--(pakz001/codea) and load(copy) these as sprites into codea. select
-- the 640x480 mode (retina) name these as "mytiles" and "uispace"
-- run the program and see.

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    --mytiles = readImage(asset.mytiles)
    mytiles = readImage(asset.uispace)
    im = {}
    coord = {}

    for y=0,480/16 do
        for x=0,640/16 do
            table.insert(im,mytiles:copy(x*16,y*16,16,16))
            table.insert(coord,vec2(x*16,y*16))
        end
    end
    im2 = mytiles:copy(65,161,16,16) 
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(255,255,255)

    -- This sets the line thickness
    strokeWidth(5)
    
    pushMatrix()
    translate(WIDTH/2,HEIGHT/2)
    scale(2,2)
    --sprite(mytiles,0,0)
    popMatrix()
    cnt=1
    for y=0,480/16 do
        for x =0,640/16 do
            pushMatrix()
            translate(60+x*26,HEIGHT-(y*26)-50)
            scale(1.8,1.8)
            tint(255,255,255,180)
            sprite(im[cnt],0,0)
            fontSize(6)
            fill(0)
            text(math.floor(coord[cnt].x),0,0)
            text(math.floor(coord[cnt].y),0,-5)
            
            
            popMatrix()
           
            cnt=cnt+1
        end
    end
    tint(255,255,255,255)
    sprite(im2,200,HEIGHT-10)
    -- Do your drawing here
    
end
