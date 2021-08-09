-- Table In Table
a = {}
a.banana = {}

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    -- we insert 5 values into a.banana
    for i=1,5 do
        table.insert(a.banana,i)
    end
    -- we turn index 2 to nik
    a.banana[2]=nil
    -- printed out you can see that the for loop skips index 2. But it does not get removed. removing it would cause a cpu costly shift.
    for k,v in pairs(a.banana) do
        print(k,v)
    end
    -- adding a new value to the table adds it to the end of the table.
    table.insert(a.banana,100)
    for k,v in pairs(a.banana) do
        print(k,v)
    end
    -- for a bullet or particle system you might want to add a active boolean to the table entry. when adding a new particle then loop the list and add it to the first active==false entry.
    -- in the bubbles example that comes with codea each new bubble is inserted in a new spot growing the table. the bubbles that run out of life get set to nil and stay in the table. this would cause the table to grow infinitly.
    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end
