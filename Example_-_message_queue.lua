-- MessageQueues

-- shows how to create a list of
-- messages. you can add new
-- messages. the first added
-- message is shown and removed
-- waiting for the message that
-- wad added after that one.

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    queue = {}
    table.insert(queue,"Welcome to this app")
    table.insert(queue,"this text is queued")
    table.insert(queue,"the last added is last shown.")
    table.insert(queue,"the end")
    cnt = 0
    show ="Welcome"
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    if #queue>0 then
        cnt=cnt+1
        if cnt>200 then
            cnt=0
            table.remove(queue,1)
            if #queue>0 then show = queue[1] end
        end
        
    end
    fill(255)
    text(show,WIDTH/2,HEIGHT/2)
end
