-- Random Angle Deg Rad

-- Sometimes you just need to go into a random direction.
-- this for a explosion where parts fly around. maybe
-- for creating a procedural tunnel in a map. Randomness

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    cnt = 0
    randomangledeg = 0
    randomanglerad = 0.0
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here 
    cnt=cnt+1
    if cnt > 30 then
        cnt=0
        -- get a random angle from 0..359
        randomangledeg = math.random(0,359)
        -- turn our random number 0..359 into radians.
        -- or use math.rad(math.random(0,359))
        randomanglerad = math.rad(randomangledeg)
    end
    text("Our random angles :",WIDTH/2,HEIGHT/2+100)
    text(randomangledeg,WIDTH/2,HEIGHT/2)
    text(randomanglerad,WIDTH/2,HEIGHT/2+50)
end
 
