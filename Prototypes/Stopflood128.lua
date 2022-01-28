-- Water 02

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    cellshor = 128
    cellsvert = 128
    cellw = WIDTH/cellshor
    cellh = HEIGHT/cellsvert
    grid = {}
    
    for x=0,cellshor do
        grid[x]={}
        for y=0,cellsvert do
            grid[x][y]=0
        end
    end
    --grid[25][49]=100
    for i=1,math.random(1,6) do
        makegrid(math.random(5,cellshor-20),math.random(5,cellsvert-20),10,20)
    end
    particle = {}
    pi = vec2(100,300)

    time=30
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(55, 39, 28)

    -- This sets the line thickness
    strokeWidth(5)
    if time<58 then 
    time=time+0.04
    else
        particle = {}
        for x=0,cellshor do
            grid[x]={}
            for y=0,cellsvert do
                grid[x][y]=0
            end
        end
        for i=1,math.random(3,6) do
        makegrid(math.random(5,cellshor-20),math.random(5,cellsvert-20),10,20)
        end
        q = false

        while q==false do
            a = math.random(3,cellshor-3)
            b = math.random(3,cellsvert-3)
            if grid[a][b]==0 then q=true end
        end
        pi.x = a*cellw
        pi.y = b*cellh
        time = 0
    end
    if math.random()<.1 then
        if time<40 then
            table.insert(particle,vec2(pi.x+math.random(-32,32),pi.y+math.random(-32,32)))
        end
        for i=0,time,.1 do
            a=math.floor(math.random(0,cellshor))
            b =math.floor(math.random(0,cellsvert))
            if grid[a][b]>0 and grid[a][b]<40 then
                table.insert(particle,vec2(a*cellw,b *cellh))
            end
      end      
     end
         -- Do your drawing here
    
    
    drawcells()
    --drawparticles()
    updateparticles()
    for i=1,15 do
        removethick()
    end
    optifine()
end
    
function optifine()
    c = {}
    for i=1,#particle do
        a = math.floor(particle[i].x/cellw)
        b = math.floor(particle[i].y/cellh)
        --if math.random()<.01 then print(grid[a][b]) end
        if grid[a][b]<450 then
            table.insert(c,particle[i])
        end
    end
    particle = {}
    for i=1,#c do
        table.insert(particle,c[i])
    end
end
function removethick()
    i = math.random(#particle)
    check = {}
    for j = 1,#particle do
        if i ~= j then
            d = particle[i]:dist(particle[j])
            if d<40 then
                table.insert(check,j)
            end
        end
            
    end
    if #check>3 then
        table.remove(particle,math.random(#check))
    end
    
end  
function updateparticles()
    for i =1,#particle do
        for j = 1,#particle do
            if i ~= j then
                
                a = math.atan2(particle[i].y-particle[j].y,particle[i].x-particle[j].x)
                d=particle[i]:dist(particle[j])
                if d<80 then
                    new = vec2()
                    new.x=particle[i].x+(math.cos(a)*2)
                    new.y=particle[i].y+(math.sin(a)*2)
                    --new.y=new.y -.01
                    if mapcollide(math.floor(new.x/cellw),math.floor(new.y/cellh))==false   then
                        particle[i].x = new.x
                        particle[i].y = new.y
                        mapset(math.floor(new.x/cellw),math.floor(new.y/cellh))
                    end
                end
            end 
        end
    end
end

function drawparticles()
    fill(15, 76, 205,50)
    strokeWidth(0)
    for i = 1,#particle do
        rect(particle[i].x,particle[i].y,32,32)
    end
end
function makegrid(x,y,w,h)
    for y1=y,y+h do
        for x1=x,x+w do
            grid[x1][y1]=-1
            if x1>x+w/2 then grid[x1][y1]=-2 end
        end
    end
end
function mapset(x,y)
    for y1=y-math.random(0,2),y+math.random(0,2) do
        for x1=x-math.random(0,2),x+math.random(0,2) do
            if x1>=0 and x1<cellshor and y1>=0 and y1<cellsvert then
                if grid[x1][y1]>=0 then grid[x1][y1]=grid[x1][y1]+1 end
            end 
        end
    end

end
function mapcollide(x,y)
    for y1=y-1,y+1 do
        for x1=x-1,x+1 do
            if x1>=0 and x1<cellshor and y1>=0 and y1<cellsvert then
                if grid[x1][y1]<0 then return true end
            end 
        end
    end
    if y<1 then return true end
    if x<1 then return true end
    if x>cellshor-1 then return true end
    if y>cellsvert-1 then return true end
    return false
end
function drawcells()
    
    strokeWidth(0)
    for y = 0,cellsvert do
        for x = 0,cellshor do
            if grid[x][y]>0 then
                z = grid[x][y]
                if z>100 then z=100 end
                if z<20 and math.random()<.5 then
                    z=math.random(-40,math.floor(z))
                end
                fill(108-z, 176-z, 215-z)
                rect(x*cellw,(y*cellh),cellw+2,cellh+2)
            end
            if grid[x][y]==-1 then
                fill(66, 58, 30)
                rect(x*cellw,(y*cellh),cellw+2,cellh)
            end
            if grid[x][y]==-2 then
                fill(157, 117, 26)
                rect(x*cellw,(y*cellh),cellw+2,cellh)
            end
        end
    end
end
