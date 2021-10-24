-- L Systems Nature of code
q = 120
time = 0
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
    time=time+1
    if time>10 then
        time=0
        q = math.random(0,99999)
    end
    math.randomseed(q)
    translate(WIDTH/2,200)
    branch(60)
    -- Do your drawing here
    
end

function branch(len)
    theta = math.random(0,30);
    strokeWidth(len/10)
    line(0, 0, 0, len);
    translate(0, len);
    
    --Each branch’s length shrinks by two-thirds.
    len = len * 0.75;
    
    if len > 2 then
        pushMatrix();
        rotate(theta);
        --Subsequent calls to branch() include the length argument.
        branch(len);
        popMatrix();
        
        pushMatrix();
        rotate(-theta);
        branch(len);
        popMatrix();
    end
end
