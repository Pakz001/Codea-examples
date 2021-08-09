-- Image Copy

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    -- create a global image
    im = image(100,100)
    -- set to draw into image
    setContext(im)
    -- fill and stroke color
    fill(145)
    stroke(236, 197, 6)
    -- draw a rectangle bottom left in image
    rect(1,1,10,10)
    -- create a local image and copy left bottom from image im
    local ti = im:copy(1,1,10,10)
    -- the origin of a sprite(image) is bottom left.
    spriteMode(CORNER)
    -- draw our local image into our global image
    for y=0,100,10 do
        for x=0,100,10 do
            sprite(ti,x,y) 
        end
    end
    -- restore context so we draw to the main canvas
    setContext()
    -- restore spritemode to draw as center as origin
    spriteMode(CENTER)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
    -- draw our global image im to the center of the screen scaled
    pushMatrix()
    translate(WIDTH/2,HEIGHT/2)
    scale(2.5,2.5)
    sprite(im,0,0)
    popMatrix()
    
end
