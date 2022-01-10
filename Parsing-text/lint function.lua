-- Lint


-- lint is a function to check if
-- the opening braces and closing
-- braces in a string match. sorta
-- like being a part of a compiler. 


-- Use this function to perform your initial setup
function setup()
    -- add {[( or ]}) and see what
    -- happens.
    if lint("((()))")==true then
        print("success")
    end
end

-- This function gets called once every frame
function draw()
    -- This sets a dark background color 
    background(40, 40, 50)

    -- This sets the line thickness
    strokeWidth(5)

    -- Do your drawing here
    
end

function lint(input)
    tab = {}
    for i=1,#input do
        a = string.sub(input,i,i)
        if isopeningbrace(a) then
            table.insert(tab,a)
        elseif isclosingbrace(a) then
            
            b=table.remove(tab)
            
            if b==nil then
                print ("does not have opening brace")
                return false
            end
            if isnotamatch(b,a)==true then
                print( "mismatch!")
                return false
            end
        end
    end
    if #tab>0 then
        print "no closing brace"
        return false
    end
    return true
end
function isnotamatch(check1,check2)
    if check1 == "(" and check2 ~= ")" then return true end
    if check1 == "[" and check2 ~= "]" then return true end
    if check1 == "{" and check2 ~= "}" then return true end
    return false
end
function isclosingbrace(input)
    if input == ")" then return true end
    if input == "]" then return true end
    if input == "}" then return true end
    return false
end
function isopeningbrace(input)
    if input == "(" then return true end
    if input == "[" then return true end
    if input == "{" then return true end
    return false
end
