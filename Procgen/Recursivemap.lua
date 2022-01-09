-- Recursiveprocgen

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    mw = 40
    mh = 40
    tw = WIDTH/mw
    th = HEIGHT/mh
    
    createmap()
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    drawmap()
    if CurrentTouch.state == BEGAN then
        createmap()
    end
end

function createmap()
    map = {}
    for x=0,mw do
        map[x]={}
        for y=0,mh do
            map[x][y]=0
        end
    end
    don = {}
    linemap(math.floor(mw/2),math.floor(mh/2),0,4,mw*112)
    linemap(math.floor(mw/2),math.floor(mh/2),0,-4,mh*112)
    linemap(math.floor(mw/2),math.floor(mh/2),4,0,mw*112)
    linemap(math.floor(mw/2),math.floor(mh/2),-4,0,mh*112)

end

function linemap(x,y,incx,incy,cnt)
    cnt = cnt - 1
    if cnt < 0 then return end
    for i=0,math.abs(incx+incy) do
        if setmap(x,y,1)==false then break end
        if incx>0 then x=x+1 end
        if incy>0 then y=y+1 end   
        if incx<0 then x=x-1 end
        if incy<0 then y=y-1 end
 
    end
    table.insert(don,vec2(x,y))
    incx = 0
    incy = 0
    z = math.random(-4,4)
    if math.random()<.5 then
        incx = z
    else
        incy = z
    end
    if math.random()<.5 then
        n = math.random(1,#don)
        x = don[n].x
        y = don[n].y
    end
    
    linemap(x,y,incx,incy,cnt)
end

function setmap(x,y,val)
    if x<4 or y<4 or x>mw-4 or y>mh-4 then return false end
    
    cnt=0
    for y1=y-1,y+1 do
        for x1=x-1,x+1 do
            if map[x1][y1]==1 then cnt=cnt+1
            end
         end
    end
  
    if cnt>4 then return false end
    map[x][y]=val
    return true
end
function drawmap()
    
    for y = 0,mh,1 do
        for x = 0,mw,1 do
            if map[x][y]==1 then
                fill(255)
                stroke(255)
                rect(x*tw,y*th,tw,th)
            end
        end
    end
end
