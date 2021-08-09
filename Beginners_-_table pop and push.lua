-- Table Pop And Push

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    -- create a table
    a = {}
    -- create 10 elements in a
    -- insert without a position acts as a push. adding the new element at the bottom.
    for i=1,10 do
        table.insert(a,i)
    end
    -- remove last element from table a
    -- remove without a index acts as a pop. removing the bittom element.
    table.remove(a)
    -- print out all elements in table a
    for i,v in pairs(a) do
        print(v)
    end
    
    -- removing or adding a element from say in the middle of a table index cause lua to shift the list. this costs cpu time and could slow down the game or program a lot.
    -- removing and inserting at the last position had no performance cost caused by shifting the list. this is where pop and push is known for
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end
