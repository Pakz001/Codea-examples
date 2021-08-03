-- Rectsoverlap
rect1 = vec2(0,0)
rect2 = vec2(0,0)
-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    --print(rectsoverlap(0,0,50,50,20,20,50,50))

end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    
    rect1.x = CurrentTouch.pos.x
    rect1.y = CurrentTouch.pos.y

    -- This sets the line thickness
    strokeWidth(5)
    if (rectsoverlap(rect1.x,rect1.y,100,100,rect2.x,rect2.y,100,100)==true) then
        fill(255, 8, 0)
    else
        fill(50,200,100)
    end
    rect(rect1.x,rect1.y,100,100)
    rect(rect2.x,rect2.y,100,100)
    -- Do your drawing here
    
end


function rectsoverlap(x1,  y1,  w1,  h1,  x2,  y2,  w2,  h2) 
    return not ((y1+h1 < y2) or (y1 > y2+h2) or (x1 > x2+w2) or (x1+w1 < x2))
end
