-- vector compare

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    -- put true or false inside with this compare between two vectors
    a = vec2(5,5) == vec2(5,5)
    -- the line below does the same thing as above but requires more text
    if vec2(10,10) == vec2(10,10) then b = true end
    -- if the two vectors do not have the same values then c wil contain false.
    c = vec2(10,10) == vec2(10,5)
    -- print out our vectors in the console
    print(a)
    print(b)
    print(c)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end

