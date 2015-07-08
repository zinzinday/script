--[[
    MiniMap Marks Lib
    v1.0
    Written by Weee
	Port by Kilua
]]
LoadScript = false

xAdd, yAdd = 0, -5
initMarksState = 0
premapx, premapy = 0, 0
minimapOffsets = {}

-- ===========================================
-- Return true if file exists and is readable.
-- ===========================================
function fileExists(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

function altDoFile(name)
    dofile(debug.getinfo(1).source:sub(debug.getinfo(1).source:find(".*\\")):sub(2)..name)
end

-- ===========================================
-- Init-function. Needs to be runned once in the script.
-- ===========================================
function initMarks()
    if LoadScript == true then --ici
        initMarksState = 4
        return 4
    end
    if fileExists(CONFIG_PATH) then
        dofile(CONFIG_PATH)
        premapx = ( minimapOffsets[3] - minimapOffsets[1] ) / 14545
        premapz = ( minimapOffsets[4] - minimapOffsets[2] ) / 14604
        initMarksState = 1
    else
        PrintChat(" >> MiniMap Marks Lib: Config not found. Starting wizard to make a new one:")
			
			altDoFile("minimap_marks_wizard.lua")  --ici
			LoadScript = true
            initMarksState = 2
        else
            PrintChat(" >> MiniMap Marks Lib: [ERROR] Wizard not found. You have to download it and put to libs folder!")
            initMarksState = 3
        end
    end
    return initMarksState
end

function convertToMinimap(ingameX,ingameZ)
    if initMarksState == 1 then return minimapOffsets[1] + premapx * ingameX + xAdd, minimapOffsets[4] - premapx * ingameZ + yAdd else return -100, -100 end
end

--UPDATEURL=
--HASH=4D8134D8155F63AA9A086AA4F1D743FC
