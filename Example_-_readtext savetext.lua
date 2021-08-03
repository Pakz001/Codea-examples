-- Test2

-- Use this function to perform your initial setup
function setup()
    print("Hello")
    mydata = "this is a test."
    saveText(asset.documents.."hello.txt",mydata)
    mydata = readText(asset.documents.hello)
    print(mydata)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end
