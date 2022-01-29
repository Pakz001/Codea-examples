-- Steering 01
plane = class()

function plane:init(x,y)
    self.pos = vec2(x,y)
    self.dest = vec2()
    self.vel = vec2()
    self.countdown = 0
end

planes = {}
-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    for i = 1,10 do
        table.insert(planes,plane(math.random(0,WIDTH),math.random(0,HEIGHT)))
    end
    dest = vec2(WIDTH/2,HEIGHT/4)
    pos = vec2(WIDTH,0)
    vel=vec2(-1,0)

end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    fill(255,255,0)
    rect(pos.x-10,pos.y-10,20,20)
    fill(255, 0, 2)
    rect(dest.x-10,dest.y-10,20,20)
    
    des = vec2(dest.x-pos.x,dest.y -pos.y)

    dis = pos:dist(dest)
    dis = math.sqrt((pos.y-dest.y)*(pos.y-dest.y)+(pos.x-dest.x)*(pos.x-dest.x))
    if dis > 300 then
        des.x = des.x /dis*3
        des.y = des.y /dis*3
    else
        des.x = des.x / dis
        des.y = des.y / dis
    end
    if dis<40 then
        dest.x = math.random(0,WIDTH)
        dest.y = math.random(0,HEIGHT)
    end
    --des.x = des.x/dis
    --des.y = des.y/dis
    steer = vec2(des.x-vel.x,des.y-vel.y)
    vel.x=vel.x+(steer.x*0.007)
    vel.y=vel.y+(steer.y*0.007)
    pos.x=pos.x +vel.x
    pos.y=pos.y +vel.y
    
    line(pos.x,pos.y,pos.x+vel.x*dis,pos.y+vel.y*dis)
    
    updateplanes()
    drawplanes()
end
function drawplanes()
    for i = 1,#planes do
        rect(planes[i].pos.x-8,planes[i].pos.y-8,16,16)
        line(planes[i].pos.x,planes[i].pos.y,planes[i].pos.x+planes[i].
        vel.x*32,planes[i].pos.y+planes[i].vel.y*32)
    end
end
function updateplanes()
    for i = 1,#planes do
        if planes[i].countdown>0 then planes[i].countdown=planes[i].countdown-1 end
        
        if planes[i].countdown==0 then
            -- update target
            planes[i].dest.x = pos.x
            planes[i].dest.y = pos.y
            --
            for j =1,#planes do
                if j ~= i then
                    d = planes[j].pos:dist(planes[i].pos)
                    if d<96 then
                        planes[i].dest.x = planes[i].dest.x + math.random(-264,264)
                        planes[i].dest.y = planes[i].dest.y + math.random(-264,264)
                        planes[i].countdown = 200
                    end
                end
            end
        end
        
        --
        des = vec2(planes[i].dest.x-planes[i].pos.x,planes[i].dest.y -planes[i].pos.y)
        dis = planes[i].pos:dist(pos)
        
        if dis > 300 then
            des.x = des.x /dis*3
            des.y = des.y /dis*3
        else
            des.x = des.x / dis
            des.y = des.y / dis
        end
        if planes[i].countdown==0 and dis<40 then -- if close by
            des = vec2((planes[i].dest.x+math.random(-500,500))-planes[i].pos.x,(planes[i].dest.y+math.random(-500,500)) -planes[i].pos.y)
            planes[i].countdown = 200
            des.x = des.x /dis*3
            des.y = des.y /dis*3
            --dest.x = math.random(0,WIDTH)
            --dest.y = math.random(0,HEIGHT)
        end
        steer = vec2(des.x-planes[i].vel.x,des.y-planes[i].vel.y)
        planes[i].vel.x=planes[i].vel.x+(steer.x*0.007)
        planes[i].vel.y=planes[i].vel.y+(steer.y*0.007)
        planes[i].pos.x=planes[i].pos.x +planes[i].vel.x
        planes[i].pos.y=planes[i].pos.y +planes[i].vel.y
        
    end
end

 
