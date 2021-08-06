-- Shmup Tut 01
bulletradius = 8
bulletcountdown = 80
bullet = class()
mybullets = {}

function bullet:init(position,angle,speed)
    self.active = true
    -- position is vec2
    self.position=position
    -- 
    self.move = vec2(math.cos(angle)*speed
    ,math.sin(angle)*speed)
    -- local variables are faster than global variables,
    self.radius = bulletradius
    self.countdown = bulletcountdown
end
function bullet:update()
    if self.active == false then  return end
    self.position = self.position + self.move
    self.countdown = self.countdown - 1
    if self.countdown < 0 then self.active=false end
    
end
function bullet:draw()
    if self.active == false then return end
    ellipse(self.position.x,self.position.y,self.radius,self.radius)
end
-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    for i=1,50 do
    mybullets[i] = bullet(vec2(320,200),math.rad(math.random(0,360)),2)
     end
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
    for i,v in pairs(mybullets) do 
        v:update()
        v:draw()
    end
    
    
end
