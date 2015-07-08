--[[
    Script: IGER's CloneRevealer v0.2
    Author: PedobearIGER
    Credits: scrampc (for imgame testings and stuff, thanks:) )
    Information: This script will reveal all clones by drawing thick red circles around them. It also draws the duration countdown...
    Supports: Shaco, Wukong, Mordekaiser, LeBlanc, Yorick
]]--

local version = "0.2"
local load = false
local champions = {}
local clone = {}
local clones = {}
local player = GetSelf()

for i=1, objManager:GetMaxHeroes(), 1 do
    local hero = objManager:GetHero(i)
    if hero ~= nil and (hero.name == "MonkeyKing" or hero.name == "Shaco" or hero.name == "LeBlanc" or hero.name == "Yorick" or hero.name == "Mordekaiser") then 
    if hero.name == "LeBlanc" then lbTemp = hero end
    load = true
    table.insert(champions,hero)
    end
end

if load then
    function tick()
        OnCreateObj()
        OnDraw()
    end
    
    function OnDraw()
        if #clones > 0 then
            for i, clone in rpairs(clones) do
                TextObject(string.format(math.floor((clone.tick+clone.duration-GetClock())/(10)+0.5)/100).."s",clone.object,0xFF0000FF)
                CustomCircle(100,10,2,clone.object)
                if GetClock() > (clone.tick+clone.duration) then table.remove(clones,i) end
            end
        end
    end
    
    function OnCreateObj()
        if objManager:GetNewObject(1) then
            for i=1, objManager:GetMaxNewObjects(), 1 do
                local object = objManager:GetNewObject(i)
                if object ~= nil then
                    if object.name == "MonkeyKing bot" then
                        clone = {object = object,tick = GetClock(),duration = 1500}
                        table.insert(clones,clone)
                    elseif object.name == "mordekaiser_cotg_ring.troy" then
                        clone = {object = object,tick = GetClock(),duration = 30000}
                        table.insert(clones,clone)
                    else
                        for i,hero in ipairs(champions) do
                            if object ~= hero then
                                if object.name == "Yorick" and hero.name == "Yorick" then
                                    clone = {object = object,tick = GetClock(),duration = 10000}
                                    table.insert(clones,clone)
                                end
                                if object.name == "Leblanc" and hero.name == "Leblanc" then
                                    clone = {object = object,tick = GetClock(),duration = 8000}
                                    table.insert(clones,clone)
                                end
                                if object.name == "Shaco" and hero.name == "Shaco" then
                                    clone = {object = object,tick = GetClock(),duration = 18000}
                                    table.insert(clones,clone)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    ModuleConfig:addParam("clones", "Clone Revealer", SCRIPT_PARAM_ONOFF, true)
	 ModuleConfig:permaShow("clones")
    
    AddOnTick(tick)
    printtext(" >> IGER's CloneRevealer "..version.." loaded!\n")
    
end
