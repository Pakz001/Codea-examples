-- Test

map = {}
for x=0,10 do
    map[x]={}
    for y=0,10 do
        col = math.random(0,255)
        map[x][y]=color(col,col,col,255)
        
    end
end

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
drawtilemap()
    -- Do your drawing here
    
end

function drawtilemap()
    tw = WIDTH / 10
    th = HEIGHT / 10
    for y=0,10 do
        for x=0,10 do
            fill(map[x][y])
            rect(x*tw,HEIGHT-y*th,tw,th)
        end
    end
end
