-- Walltracing

agent = class()
function agent:init(x,y)
    self.time = 0
    self.pos = vec2(math.floor(x),math.floor(y))
    self.direction = 4
end
agents = {}
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

    drawmap()
    for i=1,#agents do
        agents[i].time = agents[i].time+1
        if agents[i].time>5 then
            
            agents[i].time = 0
            x = agents[i].pos.x
            y = agents[i].pos.y
            
            
            if agents[i].direction==4 then           
                if map[x-1][y]==1 then
                    agents[i].pos.x = agents[i].pos.x - 1
                    agents[i].direction = 2
                elseif map[x][y+1]==1 then
                    agents[i].pos.y = agents[i].pos.y + 1
                    agents[i].direction = 4
                elseif map[x+1][y]==1 then
                    agents[i].pos.x = agents[i].pos.x + 1
                    agents[i].direction = 6
                elseif map[x][y-1]==1 then
                    agents[i].pos.y = agents[i].pos.y - 1
                    agents[i].direction = 8
                end
                
                
                elseif agents[i].direction==6 then
                    if map[x][y+1]==1 then
                        agents[i].pos.y = agents[i].pos.y + 1
                        agents[i].direction = 4
                    elseif map[x+1][y]==1 then
                        agents[i].pos.x = agents[i].pos.x + 1
                        agents[i].direction = 6
                    elseif map[x][y-1]==1 then
                        agents[i].pos.y = agents[i].pos.y - 1
                        agents[i].direction = 8
                    elseif map[x-1][y]==1 then
                        agents[i].pos.x = agents[i].pos.x - 1
                        agents[i].direction = 2
                    end
                
                
                
                
                elseif agents[i].direction==8 then
                    if map[x+1][y]==1 then
                        agents[i].pos.x = agents[i].pos.x + 1
                        agents[i].direction = 6
                    elseif map[x][y-1]==1 then
                        agents[i].pos.y = agents[i].pos.y - 1
                        agents[i].direction = 8
                    elseif map[x-1][y]==1 then
                        agents[i].pos.x = agents[i].pos.x - 1
                        agents[i].direction = 2
                    elseif map[x][y+1]==1 then
                        agents[i].pos.y = agents[i].pos.y + 1
                        agents[i].direction = 4
                    end
                
                
                
                
                elseif agents[i].direction==2 then
                    if map[x][y-1]==1 then
                        agents[i].pos.y = agents[i].pos.y - 1
                        agents[i].direction = 8
                    elseif map[x-1][y]==1 then
                        agents[i].pos.x = agents[i].pos.x - 1
                        agents[i].direction = 2
                    elseif map[x][y+1]==1 then
                        agents[i].pos.y = agents[i].pos.y + 1
                        agents[i].direction = 4
                    elseif map[x+1][y]==1 then
                        agents[i].pos.x = agents[i].pos.x + 1
                        agents[i].direction = 6
                    end
                end     
                
             end   
            
            
        
        
        
        
        
             
            fill(255,0,0)
            stroke(255,0,0)
            rect(agents[i].pos.x*tw,agents[i].pos.y*th,tw,th)
        
    end
    
    -- This sets the line thickness
    strokeWidth(5)
    
    -- Do your drawing here
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
    x = mw/2
    y = mh/2
    for i=1,#agents do
        table.remove(agents)
    end
    
    for num=1,90 do
        if math.random()<.1 then
            x = mw/2
            y = mh/2
        end
        d = math.random(2,4)
        dd = 1
        if math.random()<.5 then
            dd=-1
        end
        if math.random()<.5 then
            for i=1,d do
                setmap(x,y,1)
                x=x+dd
                
            end
        else
            for i=1,d do
                setmap(x,y,1)
                 y=y+dd
                
            end
        end
        
    end
    
    for i=1,5 do
        x = math.random(2,mw-1)
        y = math.random(2,mh-1)
        while map[x][y]==0 or map[x][y+1]==1 or map[x][y-1]==1 do
            x = math.random(1,mw-1)
            y = math.random(1,mh-1)
        end
           table.insert(agents,agent(x,y))
    end
end
    
function setmap(x,y,val)
    if x<4 or y<4 or x>mw-4 or y>mh-4 then return end
        
    map[x][y]=val
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
