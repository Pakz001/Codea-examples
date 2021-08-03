-- Test2

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    local cnt=0
    for i=0,10 do
        cnt=i
        if i==5 then goto con end
        ::con::
    end
    print(cnt)
     local cnt=0
    for i=0,20 do
        cnt=i
        if i==5 then goto con end
        ::con::
    end
    print(cnt)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end
