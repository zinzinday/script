--[[
        AutoSmite 4.1
                by eXtragoZ
 
                Features:
                        - Hotkey for switching AutoSmite On/Off (default: N)
                        - Hold-Hotkey for using AutoSmite (default: CTRL)
                        - Range indicator of smite
                        - A bar that indicates at what life can be smited in the hp bar
                        - The damage that smite will do to the monster using smite in the hp bar
                        - Supports Nunu Q and Chogath R
 
Patch 5.6 - Custom edition for SMART
 ^ removed all drawings for better performance/less resource heavy
 ^ removed drawtext for better performance/less resource heavy
 ^ lowered minion health "scan" from 1000000 units to 1400 units (as you dont need possible smite dmg without being near imo).
 ^ fixed smite range (~550)
 ^ fixed circles
 ^ Added Killsteal Function for ChillingSmite - Credit goes to Sida.
]]
 
local range = 550               -- Range of smite (~550)
local turnoff = true
local smiteSlot = nil
local jungleMonsters = {}
 
local smiteDamage, qDamage, mixDamage, rDamage, mixdDamage = 0, 0, 0, 0, 0
local canuseQ,canuseR,canusesmite = false,false,false
local Smiteison = false
local GameMap = 0
 
function OnLoad()
        if myHero:GetSpellData(SUMMONER_1).name:lower():find("smite") then smiteSlot = SUMMONER_1
    elseif myHero:GetSpellData(SUMMONER_2).name:lower():find("smite") then smiteSlot = SUMMONER_2 end
        if myHero.charName == "Nunu" or myHero.charName == "Chogath" or smiteSlot or not turnoff then
                SmiteConfig = scriptConfig("AutoSmite 4.1", "autosmite")
                SmiteConfig:addParam("switcher", "Switcher Hotkey", SCRIPT_PARAM_ONKEYTOGGLE, (smiteSlot ~= nil), 78)
                SmiteConfig:addParam("hold", "Hold Hotkey", SCRIPT_PARAM_ONKEYDOWN, false, 17)
                SmiteConfig:addParam("active", "AutoSmite Active", SCRIPT_PARAM_INFO, false)
                SmiteConfig:addParam("smitenashor", "Always Smite Nashor", SCRIPT_PARAM_ONOFF, true)
                SmiteConfig:addParam("drawrange", "Draw Smite Range", SCRIPT_PARAM_ONOFF, true)
                SmiteConfig:addParam("Killsteal", "Killsteal", SCRIPT_PARAM_ONOFF, true)
                SmiteConfig:addSubMenu("Smite at", "smiteat")
                SmiteConfig.smiteat:addParam("SRUBaron", "Baron", SCRIPT_PARAM_ONOFF, true)
                SmiteConfig.smiteat:addParam("SRUDragon", "Dragon", SCRIPT_PARAM_ONOFF, true)
                SmiteConfig.smiteat:addParam("SRUGromp", "Gromp", SCRIPT_PARAM_ONOFF, false)
                SmiteConfig.smiteat:addParam("SRUBlue", "Blue Sentinel", SCRIPT_PARAM_ONOFF, true)
                SmiteConfig.smiteat:addParam("SRUBlueMini", "Sentry 1", SCRIPT_PARAM_ONOFF, false)
                SmiteConfig.smiteat:addParam("SRUBlueMini2", "Sentry 2", SCRIPT_PARAM_ONOFF, false)
                SmiteConfig.smiteat:addParam("SRUMurkwolf", "Greater Murk Wolf", SCRIPT_PARAM_ONOFF, false)
                SmiteConfig.smiteat:addParam("SRUMurkwolfMini", "Murk Wolf", SCRIPT_PARAM_ONOFF, false)
                SmiteConfig.smiteat:addParam("SRURazorbeak", "Crimson Razorbeak", SCRIPT_PARAM_ONOFF, false)
                SmiteConfig.smiteat:addParam("SRURazorbeakMini", "Razorbeak", SCRIPT_PARAM_ONOFF, false)
                SmiteConfig.smiteat:addParam("SRURed", "Brambleback", SCRIPT_PARAM_ONOFF, true)
                SmiteConfig.smiteat:addParam("SRURedMini", "Cinderling", SCRIPT_PARAM_ONOFF, false)
                SmiteConfig.smiteat:addParam("SRUKrug", "Ancient Krug", SCRIPT_PARAM_ONOFF, false)
                SmiteConfig.smiteat:addParam("SRUKrugMini", "Krug", SCRIPT_PARAM_ONOFF, false)
                SmiteConfig.smiteat:addParam("SruCrab", "Crab", SCRIPT_PARAM_ONOFF, false)
                SmiteConfig.smiteat:addParam("TTSpiderboss", "TT Spiderboss", SCRIPT_PARAM_ONOFF, true)
                SmiteConfig.smiteat:addParam("TTNGolem", "TT Golem", SCRIPT_PARAM_ONOFF, true)
                SmiteConfig.smiteat:addParam("TTNWolf", "TT Wolf", SCRIPT_PARAM_ONOFF, true)
                SmiteConfig.smiteat:addParam("TTNWraith", "TT Wraith", SCRIPT_PARAM_ONOFF, true)
                SmiteConfig:permaShow("active")
                SmiteConfig:permaShow("Killsteal")
                jungleMonsters = minionManager(MINION_JUNGLE, 1400)
                GameMap = GetGame().map.index
                Smiteison = true
                PrintChat(">> SMARTs Smite")
        end
end
 
function OnTick()
        if not Smiteison then return end
        jungleMonsters:update()
        SmiteConfig.active = ((SmiteConfig.hold and not SmiteConfig.switcher) or (not SmiteConfig.hold and SmiteConfig.switcher))
        if not SmiteConfig.active and SmiteConfig.smitenashor then
                if GameMap == 1 and GetDistance({x=4543,y=0,z=10234}) <= 850 then
                        SmiteConfig.active = true
                elseif GameMap == 10 and GetDistance({x=7687,y=0,z=9921}) <= 1000 then
                        SmiteConfig.active = true
                end
        end
        smiteDamage = math.max(20*myHero.level+370,30*myHero.level+330,40*myHero.level+240,50*myHero.level+100)
        qDamage = 250+150*myHero:GetSpellData(_Q).level
        mixDamage = qDamage+smiteDamage
        rDamage = 1000+.7*myHero.ap
        mixdDamage = rDamage+smiteDamage
        canuseQ = (myHero.charName == "Nunu" and myHero:CanUseSpell(_Q) == READY)
        canuseR = (myHero.charName == "Chogath" and myHero:CanUseSpell(_R) == READY)
        if smiteSlot ~= nil then canusesmite = (myHero:CanUseSpell(smiteSlot) == READY) end
 
        if SmiteConfig.Killsteal then --and myHero:GetSpellData(smiteSlot).name == "S5_SummonerSmitePlayerGanker" then
                local smiteChampDmg = 20 + myHero.level * 8
                for _, enemy in pairs(GetEnemyHeroes()) do
                        if enemy.health < smiteChampDmg and GetDistance(enemy)<=range then
                                CastSpell(smiteSlot, enemy)
                        end
                end
        end
 
        if SmiteConfig.active and not myHero.dead and (canusesmite or canuseQ or canuseR) then
                for i,monster in pairs(jungleMonsters.objects) do
                        if monster ~= nil and monster.valid and not monster.dead and monster.visible and monster.x ~= nil and monster.health > 0 and monster.charName ~= "HA_AP_Poro" and monster.charName ~= "TestCubeRender" and monster.charName ~= "TT_Buffplat_R" and monster.charName ~= "TT_Buffplat_L" then
                                if SmiteConfig.smiteat[monster.charName:gsub("_", "")] then
                                        checkMonster(monster)
                                end
                        end
                end    
        end
end
function checkMonster(object)
        local DistanceMonster = GetDistance(object)
        if canusesmite and DistanceMonster <= range and object.health <= smiteDamage then
                CastSpell(smiteSlot, object)
        elseif canuseQ and DistanceMonster <= 125+200 then
                if canusesmite and object.health <= mixDamage then
                        CastSpell(_Q, object)
                elseif object.health <= qDamage then
                        CastSpell(_Q, object)
                end
        elseif canuseR and DistanceMonster <= 150+200 then
                if canusesmite and object.health <= mixdDamage then
                        CastSpell(_R, object)
                elseif object.health <= rDamage then
                        CastSpell(_R, object)
                end
        end
end
function OnDraw()
        if not Smiteison then return end
        if smiteSlot ~= nil and SmiteConfig.active and SmiteConfig.drawrange and not myHero.dead then
                DrawCircle(myHero.x, myHero.y, myHero.z, range, ARGB(252,153,45,61))
        end
end