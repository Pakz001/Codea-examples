-- Random Walkers Texture 1

im = image(128,128)


-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    maketexture()
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
    translate(WIDTH/2,HEIGHT/2)
    scale(2,2)
    sprite(im,0,0)
    -- Do your drawing here
    
end

function maketexture()
    setContext(im)
    
    background(0)
    walker = {}
    walkercol = {}
    walkerangle = {}
    for i = 1,1000 do 
        table.insert(walker,vec2(math.random(0-32,128+32),math.random(-32,128+32)))
        table.insert(walkercol,255)
    end
    for j = 1,255 do
        for i = 1,1000 do
            walker[i].x = walker[i].x + math.random(-1,1)
            walker[i].y = walker[i].y + math.random(-1,1)
            walkercol[i] = walkercol[i] - 1
            fill(walkercol[i],walkercol[i],walkercol[i],125)
            rect(walker[i].x,walker[i].y,5,5) 
        end
    end
    for i = 1,1000 do
        walkercol[i] = 255
        walkerangle[i] = 0 --math.random(360)
    end
    for j = 1,255 do
        for i = 1,1000 do
            walker[i].x = walker[i].x + math.cos(math.rad(walkerangle[i])) * 1
            walker[i].y = walker[i].y + math.sin(math.rad(walkerangle[i])) * 1
            if math.random(0,5) == 1 then walkerangle[i] = walkerangle[i] + math.random(-5,5) end
            walkercol[i] = walkercol[i] - 1
            fill(walkercol[i],walkercol[i],walkercol[i],18)
            rect(walker[i].x,walker[i].y,3,3)
        end
    end
    setContext()
end
