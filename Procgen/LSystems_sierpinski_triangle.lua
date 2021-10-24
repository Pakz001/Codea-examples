-- Lsystems 1
im = 0
lstring = ""

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    lstring = "F"
    b = ""
    for i=0,8 do
        b=""
        for j = 1,string.len(lstring) do
            if string.sub(lstring,j,j) == "F" then
                b=b.."G-F-G"
            elseif string.sub(lstring,j,j) == "G" then 
                b=b.."F+G+F"
            else
                b = b..string.sub(lstring,j,j)
            end
            
        end
        lstring = b
    end
    print(lstring)
    makeimage()
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
    pushMatrix()
    translate(WIDTH/2,HEIGHT/2)
    scale(.18,.18)
    
    sprite(im,0,0)
    popMatrix()

    -- Do your drawing here
    
end

function makeimage()
    im=image(WIDTH*5,HEIGHT*5)
    setContext(im)
    strokeWidth(2)
    fill(255)
    s = vec2(0,0)
    turtle = vec2(WIDTH*2.5,HEIGHT*2.5)
    turtleangle = 0

    for i = 1,string.len(lstring) do      
        a = string.sub(lstring,i,i)
        if a == "F" or a == "G" then 
            s.x = turtle.x
            s.y = turtle.y
            turtle.x = turtle.x + math.cos(turtleangle) * 4
            turtle.y = turtle.y + math.sin(turtleangle) * 4
            line(s.x,s.y,turtle.x,turtle.y)
        end
        if a == "-" then turtleangle = turtleangle - math.rad(60) end
        if a == "+" then turtleangle = turtleangle + math.rad(60) end
       
    end
    
    setContext()
end
