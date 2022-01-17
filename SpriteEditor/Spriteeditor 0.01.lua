-- Sprite Editor

-- reference "shoot em up construction kit - amiga"
-- palette ++

-- Use this function to perform your initial setup
function setup()
    print("Hello World!")
    
    paletteblockwidth = WIDTH*.10
    paletteblockheight = HEIGHT*.10
    mypalette = {}
    iniaap64palette()
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    drawpenbar()
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
end

function drawcolorbar()
    top = HEIGHT
    left = WIDTH*.5
    w = paletteblockwidth
    h = paletteblockheight
    for i=0,63 do
        
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
end
