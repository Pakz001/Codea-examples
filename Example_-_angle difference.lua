-- Anglediff

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    -- angle1,angle2,??360
    -- get the shortest difference
    -- or turn in degrees towards
    -- angle2. negative or positive.
    print(anglediff(300,30,360))
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end

-- from pro html 5 games book
function anglediff(angle1,angle2,directions)
    if angle1 >= directions/2 then
        angle1 = angle1 - directions
    end
    if angle2 >= directions/2 then
        angle2 = angle2 - directions
    end
    diff = angle2 - angle1
    if diff<-directions/2 then
        diff = diff + directions
    end
    if diff>directions/2 then
        diff = diff - directions
    end
    return diff
end
