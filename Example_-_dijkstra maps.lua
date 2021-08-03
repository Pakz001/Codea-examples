    -- 
map ={}
for x=0,10 do
    map[x]={}
    for y=0,10 do
        map[x][y]=0
    end
end
openlist = {}

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    flood()
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)
    drawmap()
    -- Do your drawing here
    
end
function drawmap()
    for y=0,10 do
        for x=0,10 do
            text(map[x][y],WIDTH-x*30,y*30)
        end
    end
end
function flood()
    dx = {0,1,0,-1}
    dy = {-1,0,1,0}
    local pos = vec2(5,5)
    table.insert(openlist,pos)
    while #openlist>0 do
        pos = openlist[1]
        table.remove(openlist,1)
        for i=1,4 do
            local nx = pos.x+dx[i]
            local ny = pos.y+dy[i]
            if nx>-1 and nx<10 and ny>-1 and ny<10 then
            if map[pos.x+dx[i]][pos.y+dy[i]] == 0 then
                table.insert(openlist,vec2(nx,ny))
                map[nx][ny]=map[pos.x][pos.y]+1
            end
            end
        end
    end
    
end
