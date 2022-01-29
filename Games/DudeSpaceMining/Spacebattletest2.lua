-- Steering 01

bullet = class()
function bullet:init(x,y,velx,vely)
    self.pos = vec2(x,y)
    self.vel = vec2(velx,vely)
    self.distance = 0
    self.remove = false
end
bullets = {}


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
    for i = 1,20 do
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
    fill(43, 21, 180)
    stroke(42,21,180)
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
        dest.x = math.random(100,WIDTH-100)
        dest.y = math.random(100,HEIGHT-100)
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
    drawbullets()
    updatebullets()
    if math.random()<.01 then
        print(#bullets)
    end
end
function drawplanes()
    fill(195, 18, 24)
    stroke(195,18,24)
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
        
        if math.random()<.1 then
            --a = math.floor(math.deg(math.atan2(pos.y-planes[i].pos.y,pos.y-planes[i].pos.x)))
            --b = math.floor(math.deg(math.atan2(planes[i].vel.y-planes[i].pos.y,planes[i].vel.x-planes[i].pos.x)))
            --a = math.floor(math.deg(math.atan2(planes[i].pos.y-pos.y,planes[i].pos.x-pos.x))/10)
            --b = math.floor(math.deg(math.atan2(planes[i].pos.y-planes[i].vel.y,planes[i].pos.x-planes[i].vel.x))/10)
             --if math.random()<.01 then print(a) end
            
            if linecirclecollide(planes[i].pos.x,planes[i].pos.y,planes[i].pos.x+planes[i].vel.x*460,planes[i].pos.y+planes[i].vel.y*460,pos.x,pos.y,48) then
                vx=planes[i].vel.x
                vy=planes[i].vel.y
                Mag = math.sqrt(vx * vx + vy * vy)
                --//as Piglet noticed in comment, you can use magnitude property
                --To make vector with the same direction but change magnitude, just multiply components by ratio of magnitudes:
            
                vx = vx * 4 / Mag
                vy = vy * 4 / Mag
                vx=vx+(math.random()/2)-.5
                vy=vy+(math.random()/2)-.5
            
                table.insert(bullets,bullet(planes[i].pos.x,planes[i].pos.y,vx,vy))
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
function drawbullets()
    fill(230, 255, 0)
    stroke(230,255,0)
    for i =1,#bullets do
        rect(bullets[i].pos.x-4,bullets[i].pos.y-4,8,8)
    end
end
function updatebullets()
    if math.random()<.01 then
        rem = true
        while rem==true do
            rem=false
            for i = 1,#bullets do
                if bullets[i].remove == true then
                    table.remove(bullets,i)
                    rem=true
                    --i=#bullets
                    break
                end
            end
        end
    end
    for i =1,#bullets do
        bullets[i].distance = bullets[i].distance+1
        if bullets[i].distance > 1000 then
            bullets[i].remove = true
        end
        bullets[i].pos.x = bullets[i].pos.x + bullets[i].vel.x
        bullets[i].pos.y = bullets[i].pos.y + bullets[i].vel.y
    end
end
 
function linecirclecollide(x1,y1, x2,y2,xc,yc,r)
    -- for compatibility I halve
    -- the radius so the default
    -- circle of codea collides.
    r = r / 2
    -- collision code
    xd = 0.0
    yd = 0.0
    t = 0.0
    d = 0.0
    dx = 0.0
    dy = 0.0
    
    dx = x2 - x1
    dy = y2 - y1
    
    t = ((yc - y1) * dy + (xc - x1) * dx) / (dy * dy + dx * dx)
    
    if 0 <= t and t <= 1 then
        xd = x1 + t * dx
        yd = y1 + t * dy
        
        d = math.sqrt((xd - xc) * (xd - xc) + (yd - yc) * (yd - yc))
        return d <= r
    else
        d = math.sqrt((xc - x1) * (xc - x1) + (yc - y1) * (yc - y1));
        if d <= r then
            return true
        else
            d = math.sqrt((xc - x2) * (xc - x2) + (yc - y2) * (yc - y2))
            if d <= r then
                return true
            else
                return false
            end
            
        end
    end
    
end
