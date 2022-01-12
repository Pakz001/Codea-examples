-- Berzerk Map Generator



--I found the description on twitter 
--by the user @pugfuglygames

--You have a empty map with columns spread
-- into a grid pattern. Each column then
-- extend into 1 of four directions. This
-- then should create the map.
        
--There can be areas created that are
-- blocked. A flood fill check or manual
-- seed selection can sort this.

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    mw = 10*5
    mh = 10*5
    tw = WIDTH/mw
    th = HEIGHT/mh
    map = {}
    for x=0,mw do
        map[x]={}
        for y=0,mh do
            map[x][y]=0
        end
    end
    -- the distance between the columns is 5(grid)
    for y=0,mh,5 do
        for x=0,mw,5 do
            -- at each collumn set a line in any
            -- of four directions. length of 0..3          
            a = math.random()
            b = math.random()
            map[x][y]=1
            x1=0
            y1=0
            for i =0,3 do
                
                if a<.5 then
                    if b<.5 then x1=x1+1 else x1=x1-1 end
                else
                    if b<.5 then y1=y1+1 else y1=y1-1 end
                end
                if x+x1>=0 and x+x1<mw and y+y1>=0 and y+y1<mh then
                    map[x+x1][y+y1]=1
                end
            end
        end
    end
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    drawmap()
end

function drawmap() 
    for y = 0,mh,1 do
        for x = 0,mw,1 do
                if map[x][y]==0 then
                    fill(40,40,0)
                    stroke(40,40,0)
                    rect(x*tw,y*th,tw,th)
                end
                if map[x][y]==1 then
                    fill(255,155,55)
                    stroke(255,155,55)
                    rect(x*tw,y*th,tw,th)
                end
        end
    end
end
