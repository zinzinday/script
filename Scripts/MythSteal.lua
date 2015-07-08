version = 0.02
local autoupdate = true
local UPDATE_NAME = "MythSteal"
local UPDATE_FILE_PATH = SCRIPT_PATH..UPDATE_NAME..".lua"
local UPDATE_URL = "http://raw.github.com/iMythik/BoL/master/MythSteal.lua"

function printChat(msg) print("<font color='#009DFF'>[MythSteal]</font><font color='#FFFFFF'> "..msg.."</font>") end

function update()
    local netdata = GetWebResult("raw.github.com", "/iMythik/BoL/master/MythSteal.lua")
    if netdata then
        local netver = string.match(netdata, "local version = \"%d+.%d+\"")
        netver = string.match(netver and netver or "", "%d+.%d+")
        if netver then
            netver = tonumber(netver)
            if tonumber(version) < netver then
                printChat("New version found, updating... don't press F9.")
                DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () printChat("Updated script ["..version.." to "..netver.."], press F9 twice to reload the script.") end)    
            else
                printChat("is running latest version!")
            end
        end
    end
end

local ss = {
    ["Aatrox"] = {"Q","E"},
    ["Ahri"] = {"Q","E"},
    ["Amumu"] = {"Q"},
    ["Anivia"] = {"Q","R"},
    ["Annie"] = {"W","R"},
    ["Ashe"] = {"W","R"},
    ["Blitzcrank"] = {"Q"},
    ["Brand"] = {"Q","W"},
    ["Braum"] = {"Q","R"},    
    ["Caitlyn"] = {"Q","E"},
    ["Cassiopeia"] = {"Q","W","R"},
    ["Chogath"] = {"Q","W"},
    ["Corki"] = {"Q","R"},
    ["Darius"] = {"E"},
    ["Diana"] = {"Q"},
    ["DrMundo"] = {"Q"},
    ["Draven"] = {"E","R"},
    ["Elise"] = {"E"},
    ["Ezreal"] = {"Q","W","R"},
    ["Fizz"] = {"R"},
    ["Galio"] = {"Q","E"},
    ["Gragas"] = {"Q","E","R"},
    ["Graves"] = {"Q","W","R"},
    ["Heimerdinger"] = {"W","E"},
    ["Irelia"] = {"R"},
    ["JarvanIV"] = {"Q","E"},
    ["Jinx"] = {"W","E","R"},
    ["Jayce"] = {"Q"},
    ["Kalista"] = {"Q"},
    ["Karma"] = {"Q"},
    ["Karthus"] = {"Q"},
    ["Kennen"] = {"Q"},
    ["Khazix"] = {"W",},
    ["KogMaw"] = {"Q","E","R"},
    ["Leblanc"] = {"E",},
    ["LeeSin"] = {"Q",},
    ["Leona"] = {"E","R"},
    ["Lissandra"] = {"Q"},
    ["Lucian"] = {"W"},
    ["Lulu"] = {"Q"},
    ["Lux"] = {"Q","E","R"},
    ["Malphite"] = {"R",},
    ["Malzahar"] = {"Q","W"},
    ["Mordekaiser"] = {"E"},
    ["Morgana"] = {"Q"},
    ["Nami"] = {"Q"},
    ["Nautilus"] = {"Q"},
    ["Nidalee"] = {"Q"},
    ["Nocturne"] = {"Q"},
    ["Olaf"] = {"Q"},
    ["Quinn"] = {"Q"},
    ["Rengar"] = {"E"},
    ["Riven"] = {"R"},
    ["Rumble"] = {"E"},
    ["Ryze"] = {"Q"},
    ["Sejuani"] = {"R"},
    ["Shyvana"] = {"E"},
    ["Sivir"] = {"Q"},
    ["Skarner"] = {"E"},
    ["Sona"] = {"R"},
    ["Swain"] = {"W"},
    ["Syndra"] = {"Q","E"},
    ["Thresh"] = {"Q"},
    ["Twitch"] = {"W"},
    ["TwistedFate"] = {"Q"},
    ["Urgot"] = {"Q","E"},
    ["Varus"] = {"Q","E","R"},
    ["Veigar"] = {"Q","W"},    
    ["Vi"] = {"Q"},    
    ["Viktor"] = {"W","E","R"},    
    ["Velkoz"] = {"Q","W","E","R"},        
    ["Xerath"] = {"Q","W","E","R"},    
    ["Yasuo"] = {"Q"},    
    ["Zac"] = {"Q"},    
    ["Zed"] = {"Q"},
    ["Ziggs"] = {"Q","W","E","R"},
    ["Zilean"] = {"Q"},
    ["Zyra"] = { "Q","E","R"}
}

local spells = {}
spells.q = {ready = false}
spells.w = {ready = false}
spells.e = {ready = false}
spells.r = {ready = false}

function readyCheck()
    spells.q.ready, spells.w.ready, spells.e.ready, spells.r.ready = (myHero:CanUseSpell(_Q) == READY), (myHero:CanUseSpell(_W) == READY), (myHero:CanUseSpell(_E) == READY), (myHero:CanUseSpell(_R) == READY)
end

function OnLoad()
    printChat("Dragon stealer loaded!")
    menu()
end

function OnTick()
    readyCheck()

    for i=1, objManager.maxObjects, 1 do
        local object = objManager:getObject(i)
        if object ~= nil and object.name == "SRU_Dragon6.1.1" and object.visible and object.valid and not object.dead and GetDistance(object, myHero) < 950 then
            drag = object
        end
    end


    if drag ~= nil and drag.visible and drag.valid and GetDistance(drag, myHero) < 950 and not drag.dead then
        for k, v in pairs(ss[myHero.charName]) do

            if not settings.v then return end 

            if v == "Q" then spell = _Q 
                elseif v == "W" then spell = _W 
                elseif v == "E" then spell = _E
                elseif v == "R" then spell = _R
            end

            if not settings.Q and v == "Q" then return end
            if not settings.W and v == "W" then return end
            if not settings.E and v == "E" then return end
            if not settings.R and v == "R" then return end

            if getDmg(v, drag, myHero) > drag.health then
                CastSpell(spell, drag.x, drag.z)
            end
        end
    end
end

function menu()
    settings = scriptConfig("MythSteal", "mythik")

    for k, v in pairs(ss[myHero.charName]) do
        settings:addParam(v, "Use "..v.." to steal dragon", SCRIPT_PARAM_ONOFF, true)
    end

    settings:addParam("ver", "Version", SCRIPT_PARAM_LIST, 1, {tostring(version)})
end