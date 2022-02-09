-- Push Blocks

-- make a screen filled with grids witg blocks.
-- each grid has a random construction of blocks.
-- no 2x2 block cell combination.
-- this code also shows how to
-- create a multidimensional array
-- from inside a class init.

block = class()
function block:init()
    self.map = block:dim()
end
function block:dim()
    map = {}
    for x=0,mw do
        map[x]={}
        for y=0,mh do
            map[x][y]=0
        end
    end
    return map
end
blocks = {}

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    palette = {}
    for i=1,640 do   table.insert(palette,color(math.random(0,128),math.random(128),math.random(0,128)))
    end
    mw = 6
    mh = 6
    tw = (WIDTH / 10) / mw
    th = (HEIGHT / 10) / mh
    map = {}
    for i=1,10*10+1 do
        for x=0,mw do
            map[x]={}
            for y=0,mh do
                map[x][y]=0
            end
        end
        map[3][3]=1
        addblock(6)
        table.insert(blocks,block())
        for x=0,mw do
            for y=0,mh do
                blocks[#blocks].map[x][y]=map[x][y]
            end
        end
    end
end
function addblock(num)
    if num<=1 then return end
    xit = false
    while xit==false do
        pos = vec2(math.random(0,mw),math.random(0,mh))
        if map[pos.x][pos.y]==1 then
            if math.random()<.5 then
                if math.random()<.5 then
                    mx = -1
                    my = 0
                else
                    mx = 1
                    my = 0
                end
            else
                if math.random()<.5 then
                    mx = 0
                    my = -1
                else
                    mx = 0
                    my = 1
                end
            end
            --xit = true
            x=pos.x+mx
            y=pos.y+my
            if x>=1 and y>=1 and x<mw-1 and y<mh-1 then 
                if map[x][y]==0 then
                    xit=true
                    map[x][y]=1
                    for y1=0,mh-1 do
                        for x1=0,mw-1 do
                            if map[x1][y1]==1 and map[x1+1][y1]==1 and map[x1][y1+1]==1 and map[x1+1][y1+1]==1 then
                                xit = false
                                map[x][y]=0
                                x1 = mw
                                y1 = mh
                            
                            end
                        end
                    end
                 end
            end
        end
    end
    addblock(num-1)
end
-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing h is ere
    num=1
    for y1=0,9 do
        
        for x1=0,9 do
            
            pal = palette[num]
            fill(pal)
            stroke(pal)
            rect(x1*(mw*tw),y1*(mh*th),tw*mw,th*mh)
            for y=0,mh do
                for x=0,mw do
                    if blocks[num].map[x][y]==1 then
 
                        fill(255)
                        stroke(255)
                        rect((x*tw)+(x1*mw)*tw,(y*th)+(y1*mh)*th,tw,th)
                    end
                end
            end
            num=num+1
        end
    end
end
