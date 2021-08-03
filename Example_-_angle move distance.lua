-- Test

angle = 0
botx = 500
boty = 300
targetx = 200
targety = 200

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

    -- Do your drawing here
    angle = math.atan2(boty-targety,botx-targetx)
    botx = botx - math.cos(angle)
    boty = boty - math.sin(angle)
    v1 = vec2(targetx,targety)
    v2 = vec2(botx,boty)
    if(v1:dist(v2)<10) then
        targetx = math.random(100,WIDTH-100)
        targety = math.random(100,HEIGHT-100)
    end
    rect(botx,boty,20,20)
    rect(targetx,targety,50,50)
end

