-- Wrapvalue

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    -- wrap value a based on b.
    -- my use would be for keeping
    -- a angle inside 0..360 or
    -- 0..pi*2
    print(wrapvalue(361,360))
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
function wrapvalue(a,b)
    if a<0 then
        a=a+b
    end
    if a>=b then
        a=a-b
    end
    return a
end
