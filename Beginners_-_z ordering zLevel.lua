-- Zlevel Z Ordering

-- with games you might want to have sprites behind or in front of each other. think of when the player walks behind a tree or in front of a tree. the zLevel command can take care of which sprite gets drawn at which z level.

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
    
    -- draw the next thing in front
    zLevel(1)
    fill(233, 209, 80)
    rect(100,HEIGHT/2,200,200)
    -- draw the next thing behind
    zLevel(-1)
    fill(237, 19, 6)
    rect(100,HEIGHT/2-50,100,100)
    
    
    
end
