-- Tilemap Collision

mapwidth = 10
mapheight = 10
tilewidth = math.floor(WIDTH/mapwidth)
tileheight = math.floor(HEIGHT/mapheight)


map = {}
for x=0,mapwidth do
    map[x]={}
    for y=0,mapheight do
        map[x][y]=1      
    end
end

-- cut out the corners
for x=0,3 do
    for y=0,3 do
        map[x][y]=0
        map[10-x][y]=0
        map[x][10-y]=0
        map[10-x][10-y]=0
    end
end
-- erase the borders
for x=0,10 do
    for y=0,10 do
        if x<1 or y<2 or x>8 or y>8 then
            map[x][y]=0
        end
    end
end
-- erase the center
map[5][5]=0


-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    drawtilemap()
    fill(255)
    text("touch the screen to check collision",200,HEIGHT-50)
    -- our collision check
    rect(CurrentTouch.x,CurrentTouch.y,50,50)
    if recttilecollide(CurrentTouch.x,CurrentTouch.y,50,50,0,0)==true then
        text("collision",400,HEIGHT-50)
    end

    -- Do your drawing here
    
end

function drawtilemap()
    tw = WIDTH / 10
    th = HEIGHT / 10
    for y=0,10 do
        for x=0,10 do
            if map[x][y]==1 then
                fill(69, 51, 213)
                rect(x*tw,HEIGHT-y*th,tw,th)
            end
        end
    end
end

--Unit collide with solid blocks true/false
-- what it does is takes the rectangular area and checks if this collides
-- with any of a section of rectangular blocks of the map. this section
-- is from around our collision check area
function recttilecollide(x,y,w,h,offsetx,offsety)
    cx = math.floor((x+offsetx)/tilewidth)
    cy = math.floor((y+offsety)/tileheight)
    x2 = 0
    y2 = 0
    for y2=cy-1,cy+2,1 do -- if the collision area is large then increase the - and + area to check (+2 etc)
        for x2=cx-1,cx+2,1 do
            if x2>=0 and x2<mapwidth and y2>=0 and y2<mapheight then
                if map[x2][y2] == 1 then
                    x3 = (x2)*tilewidth
                    y3 = (y2)*tileheight
                    if rectsoverlap(x+offsetx,y+offsety,w,h,x3,y3,tilewidth,tileheight) then
                        return true
                    end
                end
            end
        end
     end
    return false
end

function rectsoverlap(x1,  y1,  w1,  h1,  x2,  y2,  w2,  h2) 
    return not ((y1+h1 < y2) or (y1 > y2+h2) or (x1 > x2+w2) or (x1+w1 < x2))
end
