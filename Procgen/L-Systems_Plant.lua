-- L Systems - Plant

-- L Systems
str = "F"
-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    for i=1,4 do
        newstr = ""
        for j=1,string.len(str) do
            -- if F then insert new string
            if string.sub(str,j,j) == "F" then
                newstr = newstr .. "FF+[+F-F-F]-[-F+F+F]"
            else
                -- add to string
                newstr = newstr..string.sub(str,j,j)
            end
        end
        -- copy new string into str
        str = newstr
    end
    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)
    
    -- This sets the line thickness
    strokeWidth(1)
    -- set to center of screen
    -- opengl system
    translate(WIDTH/2+WIDTH/8,HEIGHT/3)
    scale(3,2)
    -- move up
    rotate(90)
    makedrawing(str,111)
    -- Do your drawing here
    
end

function makedrawing(str,seed)
    math.randomseed(seed)
    len = 5
    for i = 1,string.len(str) do
        a = string.sub(str,i,i)
        -- draw line and move
        if a == "F" then
            len = math.random(1,7)
            line(0,0,len,0)
            translate(len,0)
        end
        -- not used
        if a == "G" then
            translate(len,0)
        end
        -- rotate left
        if a == "-" then
            rotate(-25)
        end
        -- rotate right
        if a == "+" then
            rotate(25)
        end
        -- store location
        if a == "[" then
            pushMatrix()
        end
        -- restore to previous location
        if a == "]" then
            popMatrix()
        end
    end
    
end
