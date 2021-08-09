-- Table Insert Table

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    -- create a global table
    a = {}
    -- create a local table with various variables
    local b = {active = false, position = vec2(WIDTH/2,HEIGHT/2), move = vec2((math.random()-1)*2,(math.random()-1)*2)}
    -- insert the local table(b) into the global table(a)
    table.insert(a,b)
    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
    
    -- update a[1]
    a[1].position = a[1].position + a[1].move
    -- draw a[1]
    rect(a[1].position.x,a[1].position.y,50,50)
    
    
end
