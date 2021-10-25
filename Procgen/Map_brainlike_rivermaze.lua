-- Grow Ai

joint = {}
jointangle = {}
jointlen = {}

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    pos = vec2(WIDTH/2,HEIGHT/2)
    table.insert(joint,pos)
    angle = math.rad(math.random(0,360))
    table.insert(jointangle,angle)
    len = math.random(15,64)
    table.insert(jointlen,len)
    table.insert(joint,vec2(pos.x+math.cos(angle)*len,pos.y+math.sin(angle)*len))
    table.insert(jointangle,0)
    table.insert(jointlen,0)
    for i=0,43100 do
        addrandomjoint()
    end
    --removesomestuff()
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    math.randomseed(100)

    for i = 1,#joint-1 do
        x1 = joint[i].x
        y1 = joint[i].y
        x2 =  x1 + math.cos(jointangle[i])*jointlen[i]
        y2 =  y1 + math.sin(jointangle[i])*jointlen[i]
        --strokeWidth(math.random(5,10))
        --if math.random(0,24)==0 then strokeWidth(10+math.random(0,10)) end
        strokeWidth(5)
        line(x1,y1,x2,y2)
    end
    -- Do your drawing here
    
end

function addrandomjoint()
    pos = joint[math.random(1,#joint)]
    table.insert(joint,pos)
    angle = math.rad(math.random(0,360))
    table.insert(jointangle,angle)
    len = math.random(15,32)
    table.insert(jointlen,len)
    table.insert(joint,vec2(pos.x+math.cos(angle)*len,pos.y+math.sin(angle)*len))
    table.insert(jointangle,0)
    table.insert(jointlen,0)
    cnt=0
    for i=1,#joint do
        if joint[i]:dist(joint[#joint]) < 32 then cnt=cnt+1 end
        if cnt>3 then break end
    end
    if cnt>3 then
        table.remove(joint)
        table.remove(jointangle)
        table.remove(jointlen)
        table.remove(joint)
        table.remove(jointangle)
        table.remove(jointlen)
    end
end


function removesomestuff()
    
    for q = 1,2 do
        x = math.random(0,WIDTH)
        y = math.random(0,HEIGHT)
    
        for i=1,#joint do
            if joint[i]:dist(vec2(x,y))< 50 then
            
                table.remove(joint,i)
                table.remove(jointangle,i)
                table.remove(jointlen,i)

            
            end
        end
    
    end

end
