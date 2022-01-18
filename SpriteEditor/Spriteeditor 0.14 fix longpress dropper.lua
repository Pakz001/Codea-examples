-- Sprite Editor

-- reference "shoot em up construction kit - amiga"
-- palette ++

-- Use this function to perform your initial setup

und = class()
function und:init()
    self.grid = {}
    self.blocknum = nil
end

function setup()
    print("Hello World!")
  
    blocknum = 1
    destination = 1
    destinationmax = 0
    blocknummax = 0
    
    MODEPEN = 1
    MODEFLOOD = 2
    
    editmode = MODEPEN
    
    longpresspalette = 1
    longpressx = 0
    longpressy = 0
    longpresstime = 0
    
    previewim = image(0,0)
      
    currentpalette = 16
    
    presstimer = 0
    presstimermax = 30
    edittimer = 0 -- last edited
    hasundone = false
    
    cellshor = 16
    cellsvert = 16
    a=320/cellshor
    b=240/cellsvert
    destinationmax = math.floor(a*b)
    blocknummax = math.floor(a*b)
    
    paletteblockwidth = WIDTH*.030
    paletteblockheight = HEIGHT*.040
    mypalette = {}
    iniaap64palette()
    
    grid = {}
    temp = {}
    for x=0,cellshor do
        grid[x]={}
        temp[x]={}
        for y=0,cellsvert do
            grid[x][y]=1
            temp[x][y]=1
        end
    end
    
    --savedimage = image(320,240)
    --saveImage(asset.documents.."savedimage.png",savedimage)
    savedimage = readImage(asset.documents.savedimage)
    if savedimage==nil then
        savedimage = image(320,240)
        saveImage(asset.documents.."savedimage.png",savedimage)
        print("created new save..")
    else
        getgridfromimage(1,1,cellshor,cellsvert)
        print("reading image")
    end
    
    undo = {}
    insertundo()
    updatepreview()
    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(0)
    
    -- This sets the line thickness
    strokeWidth(5)
    
    -- Do your drawing here
    drawpenbar()
    drawcolorbar()
    drawtoolbar()
    drawgrid()
    drawpreview()
    drawtitle()
    drawstorage()
    editstorage()
    editgrid()
    editpenbar()
    editcolorbar()
    edittoolbar()
    presstimer=presstimer+1
    --sprite(savedimage,WIDTH/2,HEIGHT/2)

    
end

function editstorage()
    if presstimer<presstimermax then return end

    --if CurrentTouch.state~=BEGAN then return end
    --presstimer=0
    top = 0
    h = HEIGHT/100*30  
    w1 = WIDTH/100*75
    w=WIDTH-w1
    left = w1
    x1 = CurrentTouch.pos.x
    y1 = CurrentTouch.pos.y
    if rectsoverlap(x1,y1,1,1,left,top,w,h)==false then return end
    if CurrentTouch.state==BEGAN then
        --destination buttons
        if rectsoverlap(x1,y1,1,1,left+w/10,top+h/1.9,w/10,h/6) then -- +
            if destination<destinationmax then 
                destination = destination + 1
                presstimer=0
            end
        end
        if rectsoverlap(x1,y1,1,1,left+w-w/10-w/10,top+h/1.9,w/10,h/6) then -- -
            if destination>1 then
                destination = destination - 1
                presstimer=0
            end
        end
        --block number buttons
        if rectsoverlap(x1,y1,1,1,left+w/10,top+h/7,w/10,h/6) then -- +
            if blocknum<blocknummax then 
                blocknum = blocknum + 1
                presstimer=0
                getgrid()
                insertundo()
                updatepreview()
            end
        end
        if rectsoverlap(x1,y1,1,1,left+w-w/10-w/10,top+h/7,w/10,h/6) then -- -)
            if blocknum>1 then
                blocknum = blocknum - 1
                presstimer=0
                getgrid()
                insertundo()
                updatepreview()
            end
        end
        
    end
end
function drawstorage()
    strokeWidth(3)
    stroke(100)
    fill(0)

    top = 0
    h = HEIGHT/100*30
    
    w1 = WIDTH/100*75
    w=WIDTH-w1
    left = w1
    --if math.random()<.01 then print(w) end
    fontsz = 30/300*w
    fontSize(fontsz)
    rect(left,top,w,h)
    fill(200,0,0)
    text("destination",left+w/2,top+h/1.2)
    stroke(100)
    fill(0)
    rect(left+w/10,top+h/1.9,w-w/5,h/6)
    fill(100)
    rect(left+w/10,top+h/1.9,w/10,h/6)-- +
    rect(left+w-w/10-w/10,top+h/1.9,w/10,h/6)-- -)
    fill(0)
    text("+",left+w/10+w/10/2,top+h/1.9+h/6/2)
    text("-",left+w-w/10-w/10+w/10/2,top+h/1.9+h/6/2)
    fill(255,0,0)
    text(destination,left+w/2,top+h/1.9+h/6/2)-- destination txt
    --
    fill(200,0,0)
    text("block no.",left+w/2,top+h/2.5)
    stroke(100)
    fill(0)
    rect(left+w/10,top+h/7,w-w/5,h/6)
    fill(100)
    rect(left+w/10,top+h/7,w/10,h/6)-- +
    rect(left+w-w/10-w/10,top+h/7,w/10,h/6)-- -)
    fill(0)
    text("+",left+w/10+w/10/2,top+h/7+h/6/2)
    text("-",left+w-w/10-w/10+w/10/2,top+h/7+h/6/2)
    fill(255,0,0)
    text(blocknum,left+w/2,top+h/7+h/6/2)
end

function getgrid()
    cnt=1
    for y=1,240,cellsvert do
        for x=1,320,cellshor do
            if cnt==blocknum then
                getgridfromimage(x,y,cellshor,cellsvert)
                do return end
            end
            cnt=cnt+1
        end
    end
end

function setgrid()
    cnt=1
    for y=1,240,cellsvert do
        for x=1,320,cellshor do
            if cnt==blocknum then
                setgridtoimage(x,y,cellshor,cellsvert)
                do return end
            end
            cnt=cnt+1
        end
    end
end

function setgridtoimage(x,y,w,h)
    x2 = 0
    y2 = 0
    for y1=y,y+h do
        for x1=x,x+w do
            savedimage:set(x1,y1,mypalette[grid[x2][y2]])
            --r,g,b = savedimage:get(x1,y1)
            --for i=1,#mypalette do
                --if r == mypalette[i].r and g == mypalette[i].g and b == mypalette[i].b then
                --    grid[x2][y2]=i
                --end
            --end
            x2=x2+1
        end
        x2=0
        y2=y2+1
    end
end

function getgridfromimage(x,y,w,h)
    x2 = 0
    y2 = 0
    for y1=y,y+h do
        for x1=x,x+w do
            grid[x2][y2]=1
            r,g,b = savedimage:get(x1,y1)
            --print(r..math.random())
            for i=1,#mypalette do
                if r == mypalette[i].r and g == mypalette[i].g and b == mypalette[i].b then
                    grid[x2][y2]=i
                    --print(math.random())
                end
            end
            x2=x2+1
        end
        x2=0
        y2=y2+1
    end
end

function drawtitle()
    w = WIDTH * .15
    h = w/2
    left = WIDTH*.80
    top = HEIGHT*.95-h
    fill(0)
    --rect(left,top,w,h)
    --if math.random()<.01 then print(w) end --180
    fontsz = 40/180*w
    fontSize(fontsz)
    fill(100)
    text("Sprite",left+w/2,top+h*.7)
    text("Editor",left+w/2,top+h*.3)
end

function drawpreview()
    --left = WIDTH*.70
    --left = WIDTH*.53+paletteblockwidth*6--from colorbar
    left = WIDTH*.80-WIDTH*.10
    w = WIDTH/100*10
    h = w
    top = HEIGHT*.95-h
    --top = HEIGHT-(HEIGHT*.70)+(cellsvert*cellheight)-cellheight*4
    strokeWidth(1)
    stroke(100)
    fill(0)
    rect(left,top,w,h)
    sprite(previewim,left+w/2,top+h/2)
end

function updatepreview()
    w = WIDTH/100*10
    h = w
    stp = math.ceil(w/cellshor)
    previewim = image(w,h)
    setContext(previewim)
    strokeWidth(0)
    for x=0,cellshor do
        for y=0,cellsvert do
            fill(mypalette[grid[x][y]])
            stroke(mypalette[grid[x][y]])
            rect(x*stp,y*stp,stp+2,stp+2)
        end
    end
    setContext()
    --setgridtoimage(1,1,cellshor,cellsvert)
    setgrid()
    saveImage(asset.documents.."savedimage.png",savedimage)
    
end

-- has the undo redo and pen buttons
function editpenbar()
    if presstimer < presstimermax then return end
    strokeWidth(1)
    stroke(100)
    fill(0)
    left = 0
    top = 0
    h = HEIGHT/100*25
    w = WIDTH/100*75
    x1 = CurrentTouch.pos.x
    y1 = CurrentTouch.pos.y
    --rect(left,top,w,h)
    
    if CurrentTouch.state == BEGAN  then
        
        --print(math.random())
        if rectsoverlap(x1,y1,1,1,left+w-w/8-w/16,top+h/2-h/8,w/8,h/4) then
            if #undo>0 then
                --grid = undo[#undo]
                --table.remove(undo)
                doundo()
                
                --print(math.random())
                presstimer = 0
            end
        end
        
        --text("undo",left+w-w/8,top+h/2)
        
        if rectsoverlap(x1,y1,1,1,left+w-w/8-w/16,top+h/4-h/8,w/8,h/4) then
            --redo()
            presstimer=0
        end
        
        --text("redo",left+w-w/8,top+h/4)
        
        if rectsoverlap(x1,y1,1,1,left+w-w/4-w/15,top+h/2-h/8,w/8,h/4) then
            if editmode == MODEPEN then editmode=MODEFLOOD else editmode=MODEPEN end
            presstimer = 0
            
        end
    end
end

function insertundo()
    table.insert(undo,und())
    for x=0,cellshor do
        undo[#undo].grid[x]={}
        for y=0,cellsvert do
            undo[#undo].grid[x][y]=grid[x][y]
        end
    end
    undo[#undo].blocknum = blocknum
    print("inserted undo : "..#undo)
end

function doundo()
    if #undo==1 then return end
    --if undo[#undo].blocknum~=blocknum then return end
    --if undo[#undo-1].blocknum~=blocknum then return end
    table.remove(undo)
    if undo[#undo].blocknum ~= blocknum then
        blocknum = undo[#undo].blocknum
        updatepreview()
        print ("switched view after undo..")
    end
    for x=0,cellshor do
        
        for y=0,cellsvert do
            grid[x][y]=undo[#undo].grid[x][y]
        end
    end
    print("removed undo : "..#undo)
end

function drawgrid()
    top = HEIGHT-(HEIGHT*.70)
    w = WIDTH*.5
    h = HEIGHT*.65
    cellwidth = w/cellshor
    cellheight = h/cellsvert
    left=cellwidth
    strokeWidth(1)
    stroke(255)
    fill(100)
    rect(left,top,w,h)
    fill(0)
    stroke(100)
    for y=0,cellsvert-1 do       
        for x=0,cellshor-1 do
            fill(mypalette[grid[x][y]])
            rect(left+(x*cellwidth),top+(y*cellheight),cellwidth,cellheight)
        end
    end
end

function editgrid()

    top = HEIGHT-(HEIGHT*.70)
    w = WIDTH*.5
    h = HEIGHT*.65
    cellwidth = w/cellshor
    cellheight = h/cellsvert
    left=cellwidth
    x1 = CurrentTouch.pos.x
    y1 = CurrentTouch.pos.y
    if rectsoverlap(x1,y1,1,1,left,top,w,h)==false then return end
    if CurrentTouch.state==BEGAN or CurrentTouch.state==MOVING then
        for y=0,cellsvert do
            for x=0,cellshor do 
                --drect(left+(x*cellwidth),top+(y*cellheight),cellwidth,cellheight)
                
                if rectsoverlap(x1,y1,1,1,left+(x*cellwidth),top+(y*cellheight),cellwidth,cellheight)==true then
                    if editmode == MODEPEN and grid[x][y]~= currentpalette then 
                        longpresspalette = grid[x][y]
                        longpressx = x
                        longpressy = y
                        longpresstime=0
                        grid[x][y]=currentpalette
                        --print(x)
                    end
                    if editmode == MODEFLOOD then
                        floodgrid(x,y,currentpalette)
                    end
                    edittimer=0
                    hasundone=false
                end
            end
        end
    end
    edittimer=edittimer+1
    if CurrentTouch.state == ENDED and hasundone==false and edittimer>20   then
        insertundo()
        updatepreview()
        hasundone = true
    end
    
    -- longpress color dropper
    if CurrentTouch.state == BEGAN and currentpalette~=longpresspalette then
        longpresstime=longpresstime+1
        if longpresstime>60 then
            --print(math.random())
            currentpalette = longpresspalette
            longpresstime=0
            grid[longpressx][longpressy]=longpresspalette
        end
    end
end

function floodgrid(x,y,pal)
    col = grid[x][y]
    if col == pal then return end
    openlist = {}
    table.insert(openlist,vec2(x,y))
    switchx = {-1,0,1,0}
    switchy = {0,-1,0,1}
    while #openlist>0 do
        x1 = openlist[#openlist].x
        y1 = openlist[#openlist].y
        table.remove(openlist)
        for i = 1,#switchx do
            x2 = x1 + switchx[i]
            y2 = y1 + switchy[i]
            if x2>=0 and y2>=0 and x2<cellshor and y2<cellsvert then
                if grid[x2][y2]==col then
                    table.insert(openlist,vec2(x2,y2))
                    grid[x2][y2]=pal
                end
            end
        end
    end
end






function gridmirrorright()
    if presstimer<presstimermax then return end
    presstimer = 0
    for y=1,cellsvert do
        for x=1,cellshor do
            temp[x][y] = grid[cellshor-x][y]
        end
    end
    for y=1,cellsvert do
        for x=1,cellshor do
            grid[x][y]=temp[x][y]
        end
    end
    insertundo()
    updatepreview()
end

function gridmirrorleft()
    if presstimer<presstimermax then return end
    presstimer = 0
    for y=1,cellsvert do
        for x=1,cellshor do
            temp[cellshor-x][y] = grid[x][y]
        end
    end
    for y=1,cellsvert do
        for x=1,cellshor do
            grid[x][y]=temp[x][y]
        end
    end
    insertundo()
    updatepreview()
end

function gridmirrorup()
    if presstimer<presstimermax then return end
    presstimer = 0
    for y=1,cellsvert do
        for x=1,cellshor do
            temp[x][y] = grid[x][cellsvert-y]
        end
    end
    for y=1,cellsvert do
        for x=1,cellshor do
            grid[x][y]=temp[x][y]
        end
    end
    insertundo()
    updatepreview()
end

function gridmirrordown()
    if presstimer<presstimermax then return end
    presstimer = 0
    for y=1,cellsvert do
        for x=1,cellshor do
            temp[x][cellsvert-y] = grid[x][y]
        end
    end
    for y=1,cellsvert do
        for x=1,cellshor do
            grid[x][y]=temp[x][y]
        end
    end
    insertundo()
    updatepreview()
end

function gridslideright()
    if presstimer<presstimermax then return end
    presstimer = 0
    a = {}
    for y=0,cellsvert do
        table.insert(a,grid[cellshor-1][y])
    end
    for y=0,cellsvert-1,1 do
        for x=cellshor-1,1,-1 do
            grid[x][y]=grid[x-1][y]
        end
    end
    for y=0,cellsvert do
        grid[0][y]=a[y+1]
    end
    insertundo()
    updatepreview()
end

function gridslideleft()
    if presstimer<presstimermax then return end
    presstimer = 0
    a = {}
    for y=0,cellsvert do
        table.insert(a,grid[0][y])
    end
    for y=0,cellsvert-1,1 do
        for x=0,cellshor-2 do
            grid[x][y]=grid[x+1][y]
        end
    end
    for y=0,cellsvert do
        grid[cellshor-1][y]=a[y+1]
    end
    insertundo()
    updatepreview()
end

function gridslidedown()
    if presstimer<presstimermax then return end
    presstimer = 0
    a = {}
    for x=0,cellshor do
        table.insert(a,grid[x][0])
    end
    for y=0,cellsvert-2,1 do
        for x=0,cellshor do
            grid[x][y]=grid[x][y+1]
        end
    end
    for x=0,cellshor do
        grid[x][cellsvert-1]=a[x+1]
    end
    insertundo()
    updatepreview()
end

function gridslideup()
    if presstimer<presstimermax then return end
    presstimer = 0
    a = {}
    for x=0,cellshor do
        table.insert(a,grid[x][cellsvert-1])
    end
    for y=cellsvert-1,1,-1 do
        for x=0,cellshor do
            grid[x][y]=grid[x][y-1]
        end
    end
    for x=0,cellshor do
        grid[x][0]=a[x+1]
    end
    insertundo()
    updatepreview()
end

function edittoolbar()
    if CurrentTouch.state~=BEGAN then return end

    top = HEIGHT*.50
    --left = WIDTH*.70
    left = WIDTH*.53+paletteblockwidth*5--from colorbar
    --w = WIDTH*.30
    w = WIDTH-left
    h = HEIGHT*.20
    buttonsh = (30/400)*w
    buttonsv = (30/170)*h
    switch = {0,1,0,1,0,1,0,1,0}--bottom--left--right--top
    cnt = 1
    x3 = CurrentTouch.pos.x
    y3 = CurrentTouch.pos.y
    x1 = left+w/6
    y1 = top+h/1.25-h/2
    for y=-1,1 do
        for x=-1,1 do
            if switch[cnt]==1 then
                x2 = x1 + (x * WIDTH*.030)
                y2 = y1 + (y * HEIGHT*.040)
                if rectsoverlap(x3,y3,1,1,x2,y2,buttonsh,buttonsv) then -- mirror
                    if cnt==2 then -- bottom
                        gridmirrordown()
                    end
                    if cnt==8 then -- up
                        gridmirrorup()
                    end
                    if cnt==4 then -- left
                        gridmirrorleft()
                    end
                    if cnt==6 then -- right
                        gridmirrorright()
                    end
                end
                if rectsoverlap(x3,y3,1,1,x2+w/2,y2,buttonsh,buttonsv) then -- slide
                    if cnt==2 then -- bottom
                        gridslidedown()
                    end
                    if cnt==8 then -- up
                        gridslideup()
                    end
                    if cnt==4 then -- left
                        gridslideleft()
                    end
                    if cnt==6 then -- right
                        gridslideright()
                    end
                end
            end
            cnt=cnt+1
        end
    end
end

function drawtoolbar()
    top = HEIGHT*.50
    --left = WIDTH*.70
    left = WIDTH*.53+paletteblockwidth*5--from colorbar
    --w = WIDTH*.30
    w = WIDTH-left
    h = HEIGHT*.20
    strokeWidth(3)
    stroke(100)
    fill(0)
    rect(left,top,w,h)
    --if math.random()<.01 then print(h) end
    fontsz = (36/400)*w
    buttonsh = (30/400)*w
    buttonsv = (30/170)*h
    fontSize(fontsz)
    fill(200,0,0)
    text("mirror",left+w/4,top+h/1.15)
    text("slide",left+w/1.25,top+h/1.15)
    fill(100)
    switch = {0,1,0,1,0,1,0,1,0}--bottom--left--right--top
    cnt = 1
    x1 = left+w/6
    y1 = top+h/1.25-h/2
    for y=-1,1 do
        for x=-1,1 do
            if switch[cnt]==1 then
                x2 = x1 + (x * WIDTH*.030)
                y2 = y1 + (y * HEIGHT*.040)
                rect(x2,y2,buttonsh,buttonsv)
                rect(x2+w/2,y2,buttonsh,buttonsv)
            end
            cnt=cnt+1
        end
    end
end

function editcolorbar()
    top = HEIGHT-(HEIGHT*.70)
    left = WIDTH*.53+paletteblockwidth
    w = paletteblockwidth
    h = paletteblockheight
    cnt = 1
    x = left
    y = top
    x1 = CurrentTouch.pos.x
    y1 = CurrentTouch.pos.y
    if rectsoverlap(x1,y1,1,1,x,y,w+(w*3),h+(h*15))==false then return end
    for i=0,63 do 
        if rectsoverlap(x1,y1,1,1,x,y,w,h) then
            currentpalette = cnt
            --print("pakette changed")
        end
        y=y+h
        if cnt%16 == 0 then
            y=top
            x=x+w
        end
        cnt=cnt+1
    end
end

function drawcolorbar()
    top = HEIGHT-(HEIGHT*.70)
    left = WIDTH*.53+paletteblockwidth
    w = paletteblockwidth
    h = paletteblockheight
    strokeWidth(1)
    stroke(100)
    cnt = 1
    x = left
    y = top
    for i=0,63 do 
        if cnt==currentpalette then
            stroke(255)
            strokeWidth(3)
        else
            stroke(100)
            strokeWidth(1)
        end
        fill(mypalette[cnt])
        rect(x,y,w,h)
        y=y+h
        if cnt%16 == 0 then
            y=top
            x=x+w
        end
        cnt=cnt+1
    end
    
end  
function drawpenbar()
    strokeWidth(3)
    stroke(100)
    fill(0)
    left = 0
    top = 0
    h = HEIGHT/100*25
    w = WIDTH/100*75
    rect(left,top,w,h)
    fill(100)
    rect(left+w-w/8-w/16,top+h/2-h/8,w/8,h/4)
    fill(0)
    --if math.random()<.01 then print(w) end
    fontsz = 20/900*w
    fontSize(fontsz)
    text("undo",left+w-w/8,top+h/2)
    fill(100)
    rect(left+w-w/8-w/16,top+h/4-h/8,w/8,h/4)
    fill(60)
    text("redo",left+w-w/8,top+h/4)
    
    
    str = ""
    if editmode==MODEFLOOD then
        str = "flood"
    end
    if editmode ==MODEPEN then
        str = "pen"
    end
    fill(140)
    text(str,left+w-w/2,top+h/1.2)
    fill(mypalette[currentpalette])
    strokeWidth(3)
    stroke(100)
    rect(left+w-w/2+w/30,top+h/2,w/16,h/2)
    if str=="flood" then str="pen" else str="flood" end
    fill(100)
    rect(left+w-w/4-w/15,top+h/2-h/8+3,w/8,h/4)
    fill(0)
    text(str,left+w-w/4,top+h/2)
end

function rectsoverlap(x1,  y1,  w1,  h1,  x2,  y2,  w2,  h2) 
    return not ((y1+h1 < y2) or (y1 > y2+h2) or (x1 > x2+w2) or (x1+w1 < x2))
end

function iniaap64palette()
    mypalette = {}
    table.insert(mypalette,color(6,6,8))
    table.insert(mypalette,color(20,16,19))
    table.insert(mypalette,color(59,23,37))
    table.insert(mypalette,color(115,23,45))
    table.insert(mypalette,color(180,32,42))
    table.insert(mypalette,color(223,62,35))
    table.insert(mypalette,color(250,106,10))
    table.insert(mypalette,color(249,163,27))
    table.insert(mypalette,color(255,213,65))
    table.insert(mypalette,color(255,252,64))
    table.insert(mypalette,color(214,242,100))
    table.insert(mypalette,color(156,219,67))--12
    table.insert(mypalette,color(89,193,53))
    table.insert(mypalette,color(20,160,46))
    table.insert(mypalette,color(26,122,62))
    table.insert(mypalette,color(36,82,59))
    table.insert(mypalette,color(18,32,32))
    table.insert(mypalette,color(20,52,100))
    table.insert(mypalette,color(40,92,196))
    table.insert(mypalette,color(36,159,222))
    table.insert(mypalette,color(32,214,199))
    table.insert(mypalette,color(166,252,219))
    table.insert(mypalette,color(255,255,255))
    table.insert(mypalette,color(254,243,192))--24
    table.insert(mypalette,color(250,214,184))
    table.insert(mypalette,color(245,160,151))
    table.insert(mypalette,color(232,106,115))
    table.insert(mypalette,color(188,74,155))
    table.insert(mypalette,color(121,58,128))
    table.insert(mypalette,color(64,51,83))
    table.insert(mypalette,color(36,34,52))
    table.insert(mypalette,color(34,28,26)) --32
    table.insert(mypalette,color(50,43,40))
    table.insert(mypalette,color(113,65,59))
    table.insert(mypalette,color(187,117,71))
    table.insert(mypalette,color(219,164,99))
    table.insert(mypalette,color(244,210,156))
    table.insert(mypalette,color(218,224,234))
    table.insert(mypalette,color(179,185,209))
    table.insert(mypalette,color(139,147,175))
    table.insert(mypalette,color(109,117,141))
    table.insert(mypalette,color(74,84,98))
    table.insert(mypalette,color(51,57,65))
    table.insert(mypalette,color(66,36,51))
    table.insert(mypalette,color(91,49,56))
    table.insert(mypalette,color(142,82,82))
    table.insert(mypalette,color(186,117,106))
    table.insert(mypalette,color(233,181,163)) --48
    table.insert(mypalette,color(227,230,255))
    table.insert(mypalette,color(185,191,251))
    table.insert(mypalette,color(132,155,228))
    table.insert(mypalette,color(88,141,190))
    table.insert(mypalette,color(71,125,133))
    table.insert(mypalette,color(35,103,78))
    table.insert(mypalette,color(50,132,100))
    table.insert(mypalette,color(93,175,141)) 
    table.insert(mypalette,color(146,220,186))
    table.insert(mypalette,color(205,247,226))
    table.insert(mypalette,color(228,210,170))
    table.insert(mypalette,color(199,176,139))
    table.insert(mypalette,color(160,134,98))
    table.insert(mypalette,color(121,103,85))
    table.insert(mypalette,color(90,78,68))
    table.insert(mypalette,color(66,57,52)) --64
    paletteblockwidth = ((WIDTH*.65)-(WIDTH*.5)) / 5
    
    paletteblockheight = (HEIGHT*.65)/(#mypalette/4)
end
