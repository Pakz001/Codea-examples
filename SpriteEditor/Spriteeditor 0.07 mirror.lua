-- Sprite Editor

-- reference "shoot em up construction kit - amiga"
-- palette ++

-- Use this function to perform your initial setup

und = class()
function und:init()
    self.grid = {}
end

function setup()
    print("Hello World!")
  
    previewim = image(0,0)
      
    currentpalette = 1
    
    presstimer = 0
    presstimermax = 30
    edittimer = 0 -- last edited
    hasundone = false
    
    cellshor = 16
    cellsvert = 16 
    
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
    
    undo = {}
    insertundo()
    updatepreview()
    
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)
    
    -- This sets the line thickness
    strokeWidth(5)
    
    -- Do your drawing here
    drawpenbar()
    drawcolorbar()
    drawtoolbar()
    drawgrid()
    drawpreview()
    drawtitle()
    editgrid()
    editpenbar()
    editcolorbar()
    edittoolbar()
    presstimer=presstimer+1
end

function drawtitle()
    w = WIDTH * .15
    h = w/2
    left = WIDTH*.80
    top = HEIGHT*.95-h
    fill(0)
    --rect(left,top,w,h)
    fontSize(40)
    fill(100)
    text("Sprite",left+w/2,top+h*.7)
    text("Editor",left+w/2,top+h*.3)
end

function drawpreview()
    left = WIDTH*.70
    w = WIDTH/100*10
    h = w
    top = HEIGHT*.95-h
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
    if CurrentTouch.state ==  BEGAN  then
        
        
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
    print("inserted undo : "..#undo)
end

function doundo()
    if #undo==1 then return end
    table.remove(undo)
    for x=0,cellshor do
        
        for y=0,cellsvert do
            grid[x][y]=undo[#undo].grid[x][y]
        end
    end
    print("removed undo : "..#undo)
end

function editgrid()
    left=0
    top = HEIGHT-(HEIGHT*.70)
    w = WIDTH*.5
    h = HEIGHT*.65
    cellwidth = w/cellshor
    cellheight = h/cellsvert
    x1 = CurrentTouch.pos.x
    y1 = CurrentTouch.pos.y
    if rectsoverlap(x1,y1,1,1,left,top,w,h)==false then return end
    if CurrentTouch.state==BEGAN or CurrentTouch.state==MOVING then
        for y=0,cellsvert-1 do
            for x=0,cellshor-1 do 
                --drect(left+(x*cellwidth),top+(y*cellheight),cellwidth,cellheight)
                if rectsoverlap(x1,y1,1,1,left+(x*cellwidth),top+(y*cellheight),cellwidth,cellheight)==true then
                    grid[x][y]=currentpalette
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
end

function drawgrid()
    left=0
    top = HEIGHT-(HEIGHT*.70)
    w = WIDTH*.5
    h = HEIGHT*.65
    cellwidth = w/cellshor
    cellheight = h/cellsvert
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

function edittoolbar()
    if CurrentTouch.state~=BEGAN then return end
    top = HEIGHT*.50
    left = WIDTH*.65
    w = WIDTH*.30
    h = HEIGHT*.20
    switch = {0,1,0,1,0,1,0,1,0}--bottom--left--right--top
    cnt = 1
    x3 = CurrentTouch.pos.x
    y3 = CurrentTouch.pos.y
    x1 = left+w/4
    y1 = top+h/1.25-h/2
    for y=-1,1 do
        for x=-1,1 do
            if switch[cnt]==1 then
                x2 = x1 + (x * WIDTH*.040)
                y2 = y1 + (y * HEIGHT*.050)
                if rectsoverlap(x3,y3,1,1,x2,y2,30,30) then -- mirror
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
                if rectsoverlap(x3,y3,1,1,x2+w/2,y2,30,30) then -- slide
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

function gridmirrorright()
    if presstimer<presstimermax then return end
    presstimer = 0
    for y=0,cellsvert do
        for x=0,cellshor do
            temp[x][y] = grid[cellshor-x][y]
        end
    end
    for y=0,cellsvert do
        for x=0,cellshor do
            grid[x][y]=temp[x][y]
        end
    end
    insertundo()
    updatepreview()
end

function gridmirrorleft()
    if presstimer<presstimermax then return end
    presstimer = 0
    for y=0,cellsvert do
        for x=0,cellshor do
            temp[cellshor-x][y] = grid[x][y]
        end
    end
    for y=0,cellsvert do
        for x=0,cellshor do
            grid[x][y]=temp[x][y]
        end
    end
    insertundo()
    updatepreview()
end

function gridmirrorup()
    if presstimer<presstimermax then return end
    presstimer = 0
    for y=0,cellsvert do
        for x=0,cellshor do
            temp[x][y] = grid[x][cellsvert-y]
        end
    end
    for y=0,cellsvert do
        for x=0,cellshor do
            grid[x][y]=temp[x][y]
        end
    end
    insertundo()
    updatepreview()
end

function gridmirrordown()
    if presstimer<presstimermax then return end
    presstimer = 0
    for y=0,cellsvert do
        for x=0,cellshor do
            temp[x][cellsvert-y] = grid[x][y]
        end
    end
    for y=0,cellsvert do
        for x=0,cellshor do
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

function drawtoolbar()
    top = HEIGHT*.50
    left = WIDTH*.65
    w = WIDTH*.30
    h = HEIGHT*.20
    strokeWidth(1)
    stroke(100)
    fill(200)
    --rect(left,top,w,h)
    fontSize(36)
    fill(200,0,0)
    text("mirror",left+w/4,top+h/1.15)
    text("slide",left+w/1.25,top+h/1.15)
    fill(100)
    switch = {0,1,0,1,0,1,0,1,0}--bottom--left--right--top
    cnt = 1
    x1 = left+w/4
    y1 = top+h/1.25-h/2
    for y=-1,1 do
        for x=-1,1 do
            if switch[cnt]==1 then
                x2 = x1 + (x * WIDTH*.040)
                y2 = y1 + (y * HEIGHT*.050)
                rect(x2,y2,30,30)
                rect(x2+w/2,y2,30,30)
            end
            cnt=cnt+1
        end
    end
end

function editcolorbar()
    top = HEIGHT-(HEIGHT*.70)
    left = WIDTH*.5+paletteblockwidth
    w = paletteblockwidth
    h = paletteblockheight
    cnt = 1
    x = left
    y = top
    x1 = CurrentTouch.pos.x
    y1 = CurrentTouch.pos.y
    for i=0,63 do 
        if rectsoverlap(x1,y1,1,1,x,y,w,h) then
            currentpalette = cnt
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
    left = WIDTH*.5+paletteblockwidth
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
    strokeWidth(1)
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
    fontSize(20)
    text("undo",left+w-w/8,top+h/2)
    fill(100)
    rect(left+w-w/8-w/16,top+h/4-h/8,w/8,h/4)
    fill(0)
    text("redo",left+w-w/8,top+h/4)
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
