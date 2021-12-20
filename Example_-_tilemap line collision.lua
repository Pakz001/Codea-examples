-- Tilemap line Collision

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
    v1 = vec2(0,0)
    v2 = vec2(0,0)
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)
    
    drawtilemap()
    fill(255)
    text("touch the screen to check collision",200,HEIGHT-50)
    -- our collision check
    v1.x = CurrentTouch.x
    v1.y = CurrentTouch.y
    v2.x = v1.x+100
    v2.y = v1.y+100
    fill(255)
    stroke(255)
    strokeWidth(5)
    line(v1.x,v1.y,v2.x,v2.y)
    strokeWidth(1)
    if linetilecollide(v1.x,v1.y,v2.x,v2.y) then
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
function linetilecollide(x,y,xt,yt)
    cx = math.floor((x)/tilewidth)
    cy = math.floor((y)/tileheight)
    x2 = 0
    y2 = 0
    for y2=cy-1,cy+2,1 do -- if the collision area is large then increase the - and + area to check (+2 etc)
        for x2=cx-1,cx+2,1 do
            if x2>=0 and x2<mapwidth and y2>=0 and y2<mapheight then
                if map[x2][y2] == 1 then
                    x3 = (x2)*tilewidth
                    y3 = (y2)*tileheight
                    if get_line_intersect(x,y,xt,yt,x3,y3,x3+tilewidth,y3) or
                        get_line_intersect(x,y,xt,yt,x3,y3+tileheight,x3+tilewidth,y3+tileheight) or
                    get_line_intersect(x,y,xt,yt,x3,y3,x3,y3+tileheight) or
                    get_line_intersect(x,y,xt,yt,x3+tilewidth,y3,x3+tilewidth,y3+tileheight) then
                
                       return true
                    end
                end
            end
        end
    end
    return false
end



-- This function was originally by andre la moth.
function get_line_intersect(p0_x, p0_y, p1_x, p1_y, p2_x ,p2_y, p3_x, p3_y)
    s1_x = 0
    s1_y = 0
    s2_x = 0
    s2_y = 0
    
    s1_x = p1_x - p0_x   
    s1_y = p1_y - p0_y
    s2_x = p3_x - p2_x
    s2_y = p3_y - p2_y
    
    s = 0
    t = 0
    
    s = (-s1_y * (p0_x - p2_x) + s1_x * (p0_y - p2_y)) / (-s2_x * s1_y + s1_x * s2_y);
    t = ( s2_x * (p0_y - p2_y) - s2_y * (p0_x - p2_x)) / (-s2_x * s1_y + s1_x * s2_y);
    
    if s >= 0 and s <= 1 and t >= 0 and t <= 1 then return true end
    
    return false --No collision    
end
