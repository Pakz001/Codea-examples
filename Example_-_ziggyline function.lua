-- Ziggy Lines

-- a line function that draws a
-- sketchy or peaky or wavy like
-- line from a to b.

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    bg = image(WIDTH,HEIGHT)
    setContext(bg)
    background(0)
    x=0
    y=0
    lastx=0
    lasty=0
    while x<WIDTH+169 do
        ziggyline(lastx,lasty,x,y)
        lastx=x
        lasty=y
        x=x+math.random(32,64)
        y=math.random(0,math.floor(HEIGHT/4))
    end
    ziggyline(50,180,WIDTH-50,180)
    ziggyline(50,HEIGHT-50,WIDTH-50,HEIGHT-50)
    ziggyline(50,180,50,HEIGHT-50)
    ziggyline(WIDTH-50,180,WIDTH-50,HEIGHT-50)
    setContext()
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    translate(WIDTH/2,HEIGHT/2)
    sprite(bg,0,0)
end

function ziggyline(x1,y1,x2,y2)
    
    fill(255)
    stroke(255)
    strokeWidth(1)
    --line(100,100,200,200)
    a = math.atan2(y2-y1,x2-x1)
    d = vec2(x1,y1):dist(vec2(x2,y2))
    sd = d
    z=0
    start = 0
    sw=1
    while d>1 do
        start=start+1
        lastx=x1
        lasty=y1
    d = vec2(x1,y1):dist(vec2(x2,y2))
        z=z-1
        if z<0 then
            a = math.atan2(y2-y1,x2-x1)
        end
        if d>5 and start>5 and math.random()<.5 then
            z = 5
            oa = a
            q = math.random(0,360)/100
            if sw==1 then q=-q end
            a = math.atan2(y2-y1,x2-x1)+q
            if sw==1 then sw=0 else sw=1 end
            a=(oa+a)/2
        end
        x1=x1+math.cos(a)
        y1=y1+math.sin(a)
        line(x1,y1,lastx,lasty)
    end
end
