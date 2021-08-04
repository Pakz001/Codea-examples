-- Join Variables

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    local var1 = "hello "
    local var2 = "mister."
    local var3 = var1..var2
    print(var3)
    local var4 = 25
    var3 = var3.." ("..var4..")"
    print(var3)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end
