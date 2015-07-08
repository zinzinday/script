--[[
 
Output library by Kevinkev
-small'N'simple
]]--
--path ~= nil --until set by makeFile
function output(message,path) --
        local file = io.open(tostring(path), "a")
        if file then
                file:write(tostring(message .. "\n"))
                file:close()
        end
end
 
function makeFile(path) --Put in onLoad() to make a new file every time you press f9 twice
        local file = io.open(tostring(path), "w")
        if file then
                file:write(tostring(""))
                file:close()
        end
end


--UPDATEURL=
--HASH=C982039402636BC3FD453F586922D939
