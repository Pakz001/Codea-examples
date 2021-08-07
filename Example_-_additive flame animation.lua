-- Blendmode additive flame effect

par = class()
maxpars = 100
pars = {}
function par:init(position,active)
    self.active = active
    self.time = 100
    self.position = position
    self.move = vec2(0,math.random())
    
    self.scale = math.random()
end
function par:update()
    if self.active==false then return end
    self.position = self.position + self.move
    self.time = self.time - 1
    self.scale = self.scale - .02
    if self.time<0 or self.scale < .1 then self.active=false end
end
function par:draw()    
    
       if self.active==false then return end
    local s = 1/100*self.time
    
    pushMatrix()
    translate(self.position.x,self.position.y)
    scale(self.scale,self.scale)
    sprite(im,0,0)
    popMatrix()
end
        
        
        -- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    im = image(64,64)
    setContext(im)
    fill(255, 26, 0)
    ellipse(32,32,32,32)
    
    for i=0,maxpars do
        pars[i] = par(vec2(200,200),false)
        end
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
    
    blendMode(ADDITIVE)
    if math.random()<.5 then
        local con=false
        for i,v in pairs(pars) do
            if v.active==false then
                v.active=true
                v.time = 100
                v.scale = math.random()/2+.5
                v.move = vec2(0,math.random()/2+.5)
                v.position.y=200
                con=true
            end
            if con==true then 
                break
            end
        end
    end
    for i,v in pairs(pars) do
         v:update()
        v:draw()
    end
            
    -- Do your drawing here
    
end
