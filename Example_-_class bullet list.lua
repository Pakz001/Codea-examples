-- Bullet List

bullet = class()

function bullet:init(x,y)
    self.x = x
    self.y = y
    self.incx = math.random()*2-1
    self.incy = math.random()*2-1
end

bullets = {}

    


-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    for i=0,10 do
        bullets[i] = bullet(320,200)
    end
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
    for i=0,#bullets do
        bullets[i].x=bullets[i].x+bullets[i].incx
        bullets[i].y=bullets[i].y+bullets[i].incy
        
        if bullets[i].x < 0 then bullets[i].x =  WIDTH/2 end
        if bullets[i].x > WIDTH then bullets[i].y = WIDTH/2 end
        if bullets[i].y < 0 then bullets[i].y = HEIGHT/2 end
        if bullets[i].y > HEIGHT then bullets[i].x = HEIGHT/2 end
        
                rect(bullets[i].x,bullets[i].y,32,32)
    end
    -- Do your drawing here
    
end
