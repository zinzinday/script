--[[

  _______            _  __    _      _____                 _     _      
 |__   __|          | |/ /   | |    |  __ \               | |   | |     
    | | ___  _ __   | ' / ___| | __ | |__) |   _ _ __ ___ | |__ | | ___ 
    | |/ _ \| '_ \  |  < / _ \ |/ / |  _  / | | | '_ ` _ \| '_ \| |/ _ \
    | | (_) | |_) | | . \  __/   <  | | \ \ |_| | | | | | | |_) | |  __/
    |_|\___/| .__/  |_|\_\___|_|\_\ |_|  \_\__,_|_| |_| |_|_.__/|_|\___|
            | |                                                         
            |_|                                                         

		By Nebelwolfi

]]--

--[[ Auto updater start ]]--
local version = 0.05
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/nebelwolfi/BoL/master/TKRumble.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."TKRumble.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
local function TopKekMsg(msg) print("<font color=\"#6699ff\"><b>[Top Kek Series]: Rumble - </b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
  local ServerData = GetWebResult(UPDATE_HOST, "/nebelwolfi/BoL/master/TKRumble.version")
  if ServerData then
    ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
    if ServerVersion then
      if tonumber(version) < ServerVersion then
        TopKekMsg("New version available v"..ServerVersion)
        TopKekMsg("Updating, please don't press F9")
        DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () TopKekMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
      else
        TopKekMsg("Loaded the latest version (v"..ServerVersion..")")
      end
    end
  else
    TopKekMsg("Error downloading version info")
  end
end
--[[ Auto updater end ]]--

--[[ Libraries start ]]--
local predToUse = {}
VP = nil
DP = nil
HP = nil
if FileExist(LIB_PATH .. "VPrediction.lua") then
  require("VPrediction")
  VP = VPrediction()
  table.insert(predToUse, "VPrediction")
end

if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then
  require "DivinePred"
  DP = DivinePred() 
  table.insert(predToUse, "DivinePred")
end

if FileExist(LIB_PATH .. "HPrediction.lua") then
  require("HPrediction")
  HP = HPrediction()
  table.insert(predToUse, "HPrediction")
end

if predToUse == {} then 
	TopKekMsg("Please download a Prediction.") 
	return 
end

if FileExist(LIB_PATH .. "SourceLib.lua") then
  require("SourceLib")
else
  TopKekMsg("Please download SourceLib.")
  return
end
--[[ Libraries end ]]--

--[[ Castable itemlist start ]]--
local CastableItems = {
	Bork        = { Range = 450, Slot = function() return GetInventorySlotItem(3153) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3153) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY) end, Damage = function(target) return getDmg("RUINEDKING", Target, myHero) end},
	Bwc         = { Range = 400, Slot = function() return GetInventorySlotItem(3144) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3144) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY) end, Damage = function(target) return getDmg("BWC", Target, myHero) end},
	Hextech     = { Range = 400, Slot = function() return GetInventorySlotItem(3146) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3146) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3146)) == READY) end, Damage = function(target) return getDmg("HXG", Target, myHero) end},
	Blackfire   = { Range = 750, Slot = function() return GetInventorySlotItem(3188) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3188) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3188)) == READY) end, Damage = function(target) return getDmg("BLACKFIRE", Target, myHero) end},
	Youmuu      = { Range = 350, Slot = function() return GetInventorySlotItem(3142) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3142) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY) end, Damage = function(target) return 0 end},
	Randuin     = { Range = 500, Slot = function() return GetInventorySlotItem(3143) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3143) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3143)) == READY) end, Damage = function(target) return 0 end},
	TwinShadows = { Range = 1000, Slot = function() return GetInventorySlotItem(3023) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3023) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3023)) == READY) end, Damage = function(target) return 0 end},
}
--[[ Castable itemlist end ]]--

--[[ Script start ]]--
if myHero.charName ~= "Rumble" then return end -- not supported :(
if VIP_USER then HookPackets() end
local QReady, WReady, EReady, RReady = function() return myHero:CanUseSpell(_Q) end, function() return myHero:CanUseSpell(_W) end, function() return myHero:CanUseSpell(_E) end, function() return myHero:CanUseSpell(_R) end
local RebornLoaded, RevampedLoaded, MMALoaded, SxOrbLoaded, SOWLoaded = false, false, false, false, false
local Target 
local sts
local predictions = {}
local enemyTable = {}
local enemyCount = 0
local data = {
[_Q] = { speed = 5000, delay = 0.250, range = 600, width = 500, collision = false, aoe = false, type = "cone"},
[_E] = { speed = 1200, delay = 0.250, range = 850, width = 90, collision = true, aoe = false, type = "linear"},
[_R] = { speed = 1200, delay = 0.250, range = 1700, width = 90, collision = false, aoe = false, type = "linear"}
}

function OnLoad()
  Config = scriptConfig("Top Kek Rumble", "TKRumble")
  
  Config:addSubMenu("Pred/Skill Settings", "misc")
  if VIP_USER then Config.misc:addParam("pc", "Use Packets To Cast Spells", SCRIPT_PARAM_ONOFF, false)
  Config.misc:addParam("qqq", " ", SCRIPT_PARAM_INFO,"") end
  Config.misc:addParam("qqq", "RELOAD AFTER CHANGING PREDICTIONS! (2x F9)", SCRIPT_PARAM_INFO,"")
  Config.misc:addParam("pro",  "Type of prediction", SCRIPT_PARAM_LIST, 1, predToUse)

  if ActivePred() == "DivinePred" then Config.misc:addParam("time","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.03, 0, 0.3, 2) end
  if ActivePred() == "HPrediction" then SetupHPred() end
  
  Config:addSubMenu("Misc settings", "casual")
  Config.casual:addSubMenu("Zhonya's settings", "zhg")
  Config.casual.zhg:addParam("enabled", "Use Auto Zhonya's", SCRIPT_PARAM_ONOFF, true)
  Config.casual.zhg:addParam("zhonyapls", "Min. % health for Zhonya's", SCRIPT_PARAM_SLICE, 15, 1, 50, 0)
  Config.casual:addParam("leW", "Use W to kee passive 50+", SCRIPT_PARAM_ONOFF, true)

  Config:addSubMenu("Combo Settings", "comboConfig")
  Config.comboConfig:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
  Config.comboConfig:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
  if VIP_USER then Config.comboConfig:addParam("R", "Use R", SCRIPT_PARAM_ONOFF, false) end
  Config.comboConfig:addParam("items", "Use Items", SCRIPT_PARAM_ONOFF, true)

  if VIP_USER then 
  	Config:addSubMenu("Ult Settings", "rConfig")
  	Config.rConfig:addParam("r", "Auto-R", SCRIPT_PARAM_ONOFF, true)
  	Config.rConfig:addParam("toomanyenemies", "Min. enemies for auto-r", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
    Config.misc:addParam("SPACE", " ", SCRIPT_PARAM_INFO,"")
  	Config.rConfig:addParam("omgisteamfight", "Auto-R in teamfights", SCRIPT_PARAM_ONOFF, true)
  	Config.rConfig:addParam("teamfightallies", "Min. allies in teamfight", SCRIPT_PARAM_SLICE, 2, 1, 5, 0)
  	Config.rConfig:addParam("teamfightenemies", "Min. enemies in teamfight", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
  end

  Config:addSubMenu("Harrass Settings", "harrConfig")
  Config.harrConfig:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
  Config.harrConfig:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
  
  Config:addSubMenu("Farm Settings", "farmConfig")
  Config.farmConfig:addParam("Q", "Use Q", SCRIPT_PARAM_ONOFF, true)
  Config.farmConfig:addParam("E", "Use E", SCRIPT_PARAM_ONOFF, true)
			
  Config:addSubMenu("Draw Settings", "Drawing")
  Config.Drawing:addParam("QRange", "Q Range", SCRIPT_PARAM_ONOFF, true)
  Config.Drawing:addParam("ERange", "E Range", SCRIPT_PARAM_ONOFF, true)
  Config.Drawing:addParam("RRange", "R Range", SCRIPT_PARAM_ONOFF, false)
  Config.Drawing:addParam("dmgCalc", "Damage", SCRIPT_PARAM_ONOFF, true)
  
  Config:addSubMenu("Key Settings", "kConfig")
  Config.kConfig:addParam("combo", "SBTW (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  Config.kConfig:addParam("harr", "Harrass (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
  Config.kConfig:addParam("har", "Harrass (Toggle)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("G"))
  Config.kConfig:addParam("lc", "Last Hit (Hold)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
  if VIP_USER then Config.kConfig:addParam("r", "Aim R", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T")) end
  Config:addParam("ragequit",  "Ragequit", SCRIPT_PARAM_ONOFF, false) 
  
  Config:addSubMenu("Orbwalk Settings", "oConfig")
  SetupOrbwalk()

  Config.kConfig:permaShow("combo")
  Config.kConfig:permaShow("harr")
  Config.kConfig:permaShow("har")
  Config.kConfig:permaShow("lc")
  sts = SimpleTS(STS_PRIORITY_LESS_CAST_MAGIC)
  Config:addSubMenu("Target Selector", "sts")
  sts:AddToMenu(Config.sts)

    for i = 1, heroManager.iCount do
        local champ = heroManager:GetHero(i)
        if champ.team ~= player.team then
            enemyCount = enemyCount + 1
            enemyTable[enemyCount] = { player = champ, name = champ.charName, damageQ = 0, damageE = 0, damageR = 0, indicatorText = "", damageGettingText = "", ready = true}
        end
    end
end

function SetupOrbwalk()
  if _G.AutoCarry then
    if _G.Reborn_Initialised then
      RebornLoaded = true
      TopKekMsg("Found SAC: Reborn.")
      Config.oConfig:addParam("Info", "SAC: Reborn detected!", SCRIPT_PARAM_INFO, "")
    else
      RevampedLoaded = true
      TopKekMsg("Found SAC: Revamped.")
      Config.oConfig:addParam("Info", "SAC: Revamped detected!", SCRIPT_PARAM_INFO, "")
    end
  elseif _G.Reborn_Loaded then
    DelayAction(function() SetupOrbwalk() end, 1)
  elseif _G.MMA_Loaded then
    MMALoaded = true
    TopKekMsg("Found MMA.")
      Config.oConfig:addParam("Info", "MMA detected!", SCRIPT_PARAM_INFO, "")
  elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
    require 'SxOrbWalk'
    SxOrb = SxOrbWalk()
    SxOrb:LoadToMenu(Config.oConfig)
    SxOrbLoaded = true
    TopKekMsg("Found SxOrb.")
  elseif FileExist(LIB_PATH .. "SOW.lua") then
    require 'SOW'
    require 'VPrediction'
    SOWVP = SOW(VP)
    Config.oConfig:addParam("Info", "SOW settings", SCRIPT_PARAM_INFO, "")
     Config.oConfig:addParam("Blank", "", SCRIPT_PARAM_INFO, "")
    SOWVP:LoadToMenu(Config.oConfig)
    SOWLoaded = true
    TopKekMsg("Found SOW.")
  else
    TopKekMsg("No valid Orbwalker found. :/")
  end
end

function OnTick()
  	local target
  	target = GetCustomTarget()
    
    zhg()
    
    if Config.ragequit then Target=myHero.isWindingUp end --trololo ty Hirschmilch

    if Config.casual.leW and WReady and not recall then 
    	if myHero.mana < 40 then
    		CastSpell(_W)
    	end
    end

    if (Config.kConfig.harr or Config.kConfig.har) and ValidTarget(target, data[2].range) then
      if Config.harrConfig.Q then
    	local spell = ActivePred()=="HPrediction" and "Q" or 0
      local CastPosition, HitChance, Position = Predict(target, spell)
    	if HitChance >= 2 then
    		CCastSpell(_Q, CastPosition.x, CastPosition.z)
    	end
      end
      if Config.harrConfig.E then
    	local spell = ActivePred()=="HPrediction" and "E" or 2
       	local CastPosition, HitChance, Position = Predict(target, spell)
    	if HitChance >= 2 then
    		CCastSpell(_E, CastPosition.x, CastPosition.z)
    	end
      end
    end

    if Config.kConfig.lc then
		FarmQ()
		FarmE()
    end

    if Config.kConfig.combo and ValidTarget(target, 1500) then
      if Config.comboConfig.Q then
    	local spell = ActivePred()=="HPrediction" and "Q" or 0
    	local CastPosition, HitChance, Position = Predict(target, spell)
    	if HitChance >= 2 then
    		CCastSpell(_Q, CastPosition.x, CastPosition.z)
    	end
      end
      if Config.comboConfig.W and WReady then
		CastSpell(_W)
      end
      if Config.comboConfig.E then
    	local spell = ActivePred()=="HPrediction" and "E" or 2
    	local CastPosition, HitChance, Position = Predict(target, spell)
    	if HitChance >= 2 then
    		CCastSpell(_E, CastPosition.x, CastPosition.z)
    	end
      end
      if VIP_USER and Config.comboConfig.R then
    	local spell = ActivePred()=="HPrediction" and "R" or 3
    	local CastPosition, HitChance, Position = Predict(target, spell)
    	if HitChance >= 2 then
    		CastR(CastPosition, target)
    	end
      end
      if Config.comboConfig.items then
      	UseItems(target)
      end
    end
    
    DoSomeUltLogic()

    if VIP_USER and Config.kConfig.r then
    	local spell = ActivePred()=="HPrediction" and "R" or 3
    	local CastPosition, HitChance, Position = Predict(target, spell)
    	if HitChance >= 2 then
    		CastR(CastPosition, target)
    	end
    end
end

function DoSomeUltLogic()
  	if Config.rConfig.r then
  		local enemies = EnemiesAround(Target, 250)
  		if enemies >= Config.rConfig.toomanyenemies then
	    	local spell = ActivePred()=="HPrediction" and "R" or 3
	    	local CastPosition, HitChance, Position = Predict(target, spell)
	    	if HitChance >= 2 then
	    		CastR(CastPosition, target)
	    	end
  		end
  	end
  	if Config.rConfig.omgisteamfight then
  		local enemies = EnemiesAround(Target, 250)
  		local allies = EnemiesAround(myHero, 500)
  		if enemies >= Config.rConfig.teamfightenemies and allies >= Config.rConfig.teamfightallies then
	    	local spell = ActivePred()=="HPrediction" and "R" or 3
	    	local CastPosition, HitChance, Position = Predict(target, spell)
	    	if HitChance >= 2 then
	    		CastR(CastPosition, target)
	    	end
	    end
  	end
end

function EnemiesAround(Unit, range)
  local c=0
  for i=1,heroManager.iCount do hero = heroManager:GetHero(i) if hero.team ~= myHero.team and hero.x and hero.y and hero.z and GetDistance(hero, Unit) < range then c=c+1 end end return c
end

function AlliesAround(Unit, range)
  local c=0
  for i=1,heroManager.iCount do hero = heroManager:GetHero(i) if hero.team == myHero.team and hero.x and hero.y and hero.z and GetDistance(hero, Unit) < range then c=c+1 end end return c
end

function FarmQ()
	if Config.farmConfig.FarmQ and QReady then
		for index, minion in pairs(minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC).objects) do
			local mhp = minion.health
			local qDmg = getDmg("Q", minion, GetMyHero())
			if qDmg >= mhp then
            	CCastSpell(_Q, minion.x, minion.z)
			end
		end
    end
end

function FarmE()
	if Config.farmConfig.FarmE and EReady then
		for index, minion in pairs(minionManager(MINION_ENEMY, 850, player, MINION_SORT_HEALTH_ASC).objects) do
			local mhp = minion.health
			local eDmg = getDmg("E", minion, GetMyHero())
	    	local spell = ActivePred()=="HPrediction" and "E" or 2
	    	local CastPosition, HitChance, Position = Predict(minion, spell)
			if eDmg >= mhp and HitChance > 1.5 then
    			CCastSpell(_E, CastPosition.x, CastPosition.z)
			end
		end
    end
end

--[[ Packet Cast Helper ]]--
function CCastSpell(Spell, xPos, zPos)
  if VIP_USER and Config.misc.pc then
    Packet("S_CAST", {spellId = Spell, fromX = xPos, fromY = zPos, toX = xPos, toY = zPos}):send()
  else
    CastSpell(Spell, xPos, zPos)
  end
end
function CastR(Target, target)
	Pos = Target + (Vector(target) - Target):normalized()*(GetDistance(Target)) --myHero+(Vector(Target)-myHero):normalized()*GetDistance(Target)
	Packet("S_CAST", {spellId = _R, fromX = Pos.x, fromY = Pos.z, toX = Target.x, toY = Target.z}):send()
end

function ActivePred()
    local int = Config.misc.pro
    return tostring(predToUse[int])
end

function SetupHPred()
  MakeHPred("Q", 0) 
  MakeHPred("E", 2) 
  MakeHPred("R", 3) 
end

function MakeHPred(hspell, i)
 if data[i].type == "linear" or data[i].type == "cone" or data[i].type == "circular" then 
    if data[i].type == "linear" then
        if data[i].speed ~= math.huge then 
            HP:AddSpell(hspell, myHero.charName, {type = "DelayLine", range = data[i].range, speed = data[i].speed, width = 2*data[i].width, delay = data[i].delay, collisionM = data[i].collision, collisionH = data[i].collision})
        else
            HP:AddSpell(hspell, myHero.charName, {type = "PromptLine", range = data[i].range, width = 2*data[i].width, delay = data[i].delay, collisionM = data[i].collision, collisionH = data[i].collision})
        end
    elseif data[i].type == "circular" then
        if data[i].speed ~= math.huge then 
            HP:AddSpell(hspell, myHero.charName, {type = "DelayCircle", range = data[i].range, speed = data[i].speed, width = data[i].width, delay = data[i].delay, collisionM = data[i].collision, collisionH = data[i].collision})
        else
            HP:AddSpell(hspell, myHero.charName, {type = "PromptCircle", range = data[i].range, width = data[i].width, delay = data[i].delay, collisionM = data[i].collision, collisionH = data[i].collision})
        end
    else --Cone!
        HP:AddSpell(hspell, myHero.charName, {type = "DelayLine", range = data[i].range, speed = data[i].speed, width = data[i].width, delay = data[i].delay, collisionM = data[i].collision, collisionH = data[i].collision})
    end
 end
end

function Predict(Target, spell)
    if ActivePred() == "VPrediction" then
        return VPredict(Target, data[spell])
    elseif ActivePred() == "Prodiction" then
        return nil
    elseif ActivePred() == "DivinePred" then
        local State, Position, perc = DPredict(Target, data[spell])
        return Position, perc*3/100, Position
    elseif ActivePred() == "HPrediction" then
    	local Position, HitChance = HPredict(Target, spell)
        return Position, HitChance, Position
    end
end

function HPredict(Target, spell)
	return HP:GetPredict(spell, Target, myHero) 
end

function DPredict(Target, spell)
  local unit = DPTarget(Target)
  local col = spell.collision and 0 or math.huge
  local Spell = nil
  if spell.type == "linear" then
	 Spell = LineSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
  elseif spell.type == "circular" then
	 Spell = CircleSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
  elseif spell.type == "cone" then
	 Spell = ConeSS(spell.speed, spell.range, spell.width, spell.delay * 1000, col)
  end
  return DP:predict(unit, Spell)
end

function VPredict(Target, spell)
  if spell.type == "linear" then
  	if spell.aoe then
  		return VP:GetLineAOECastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero)
  	else
  		return VP:GetLineCastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
  	end
  elseif spell.type == "circular" then
  	if spell.aoe then
  		return VP:GetCircularAOECastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero)
  	else
  		return VP:GetCircularCastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
  	end
  elseif spell.type == "cone" then
  	if spell.aoe then
  		return VP:GetConeAOECastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero)
  	else
  		return VP:GetLineCastPosition(Target, spell.delay, spell.width, spell.range, spell.speed, myHero, spell.collision)
  	end
  end
end

function GetCustomTarget()
    if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
    return sts:GetTarget(data[3].range)
end

function zhg()
  if Config.casual.zhg.enabled then
    if GetInventoryHaveItem(3157) and GetInventoryItemIsCastable(3157) then
      if myHero.health <=  myHero.maxHealth * (Config.casual.zhg.zhonyapls / 100) then
        CastItem(3157)
      end 
    end 
  end 
end

-- Credits: Da Vinci
function UseItems(unit)
    if unit ~= nil then
        for _, item in pairs(CastableItems) do
            if item.IsReady() and GetDistance(myHero, unit) < item.Range then
                if item.reqTarget then
                    CastSpell(item.Slot(), unit)
                else
                    CastSpell(item.Slot())
                end
            end
        end
    end
end

function OnDraw()
	if Config.Drawing.QRange then
		DrawCircle(myHero.x, myHero.y, myHero.z, data[0].range, 0x111111)
	end
	if Config.Drawing.WRange then
		DrawCircle(myHero.x, myHero.y, myHero.z, data[1].range, 0x111111)
	end
	if Config.Drawing.ERange then
		DrawCircle(myHero.x, myHero.y, myHero.z, data[2].range, 0x111111)
	end
	if Config.Drawing.RRange then
		DrawCircle(myHero.x, myHero.y, myHero.z, data[3].range, 0x111111)
	end
	if Config.Drawing.DmgCalcs then
        for i = 1, enemyCount do
            local enemy = enemyTable[i].player
            if ValidTarget(enemy) then
                local barPos = WorldToScreen(D3DXVECTOR3(enemy.x, enemy.y, enemy.z))
                local posX = barPos.x - 35
                local posY = barPos.y - 50
                -- Doing damage
                DrawText(enemyTable[i].indicatorText, 15, posX, posY, (enemyTable[i].ready and colorIndicatorReady or colorIndicatorNotReady))
               
                -- Taking damage
                DrawText(enemyTable[i].damageGettingText, 15, posX, posY + 15, ARGB(255, 255, 0, 0))
            end
        end
    end      
end

local colorRangeReady        = ARGB(255, 200, 0,   200)
local colorRangeComboReady   = ARGB(255, 255, 128, 0)
local colorRangeNotReady     = ARGB(255, 50,  50,  50)
local colorIndicatorReady    = ARGB(255, 0,   255, 0)
local colorIndicatorNotReady = ARGB(255, 255, 220, 0)
local colorInfo              = ARGB(255, 255, 50,  0)
local KillText = {}
local KillTextColor = ARGB(255, 216, 247, 8)
local KillTextList = {"Harass Him", "Combo Kill"}
function DmgCalculations()
    if not Config.Drawing.DmgCalcs then return end
    for i = 1, enemyCount do
        local enemy = enemyTable[i].player
          if ValidTarget(enemy) and enemy.visible then
            local damageAA = getDmg("AD", enemy, player)
            local damageQ  = getDmg("Q", enemy, player)
            local damageW  = getDmg("W", enemy, player)
            local damageE  = getDmg("E", enemy, player)
            local damageR  = getDmg("R", enemy, player)
            enemyTable[i].damageQ = damageQ
            enemyTable[i].damageW = damageW
            enemyTable[i].damageE = damageE
            enemyTable[i].damageR = damageR
            if enemy.health < damageR then
                enemyTable[i].indicatorText = "R Kill"
                enemyTable[i].ready = RReady
            elseif enemy.health < damageQ then
                enemyTable[i].indicatorText = "Q Kill"
                enemyTable[i].ready = QReady
            elseif enemy.health < damageE then
                enemyTable[i].indicatorText = "E Kill"
                enemyTable[i].ready = EReady
            elseif enemy.health < damageW then
                enemyTable[i].indicatorText = "W Kill"
                enemyTable[i].ready = WReady
            elseif enemy.health < damageE + damageQ then
                enemyTable[i].indicatorText = "Q + E Kill"
                enemyTable[i].ready = EReady and QReady
            elseif enemy.health < damageQ + damageW then
                enemyTable[i].indicatorText = "Q + W Kill"
                enemyTable[i].ready = QReady and WReady
            elseif enemy.health < damageW + damageE then
                enemyTable[i].indicatorText = "W + E Kill"
                enemyTable[i].ready = WReady and EReady
            elseif enemy.health < damageR + damageQ then
                enemyTable[i].indicatorText = "R + Q Kill"
                enemyTable[i].ready = RReady and QReady
            elseif enemy.health < damageR + damageE then
                enemyTable[i].indicatorText = "R + E Kill"
                enemyTable[i].ready = RReady and EReady
            elseif enemy.health < damageR + damageW then
                enemyTable[i].indicatorText = "R + W Kill"
                enemyTable[i].ready = RReady and WReady
            elseif enemy.health < damageQ + damageW + damageE then
                enemyTable[i].indicatorText = "Q + W + E Kill"
                enemyTable[i].ready = QReady and WReady and EReady
            elseif enemy.health < damageQ + damageE + damageR then
                enemyTable[i].indicatorText = "Q + E + R Kill"
                enemyTable[i].ready = QReady and EReady and EReady
            elseif enemy.health < damageQ + damageW + damageR then
                enemyTable[i].indicatorText = "Q + W + R Kill"
                enemyTable[i].ready = QReady and WReady and EReady
            elseif enemy.health < damageR + damageW + damageE then
                enemyTable[i].indicatorText = "W + E + R Kill"
                enemyTable[i].ready = RReady and WReady and EReady
            elseif enemy.health < damageQ + damageW + damageE + damageR then
                enemyTable[i].indicatorText = "All-In Kill"
                enemyTable[i].ready = QReady and WReady and EReady and RReady
            else
                local damageTotal = damageQ + damageW + damageE + damageR
                local healthLeft = math.round(enemy.health - damageTotal)
                local percentLeft = math.round(healthLeft / enemy.maxHealth * 100)
                enemyTable[i].indicatorText = percentLeft .. "% Harass"
                enemyTable[i].ready = QReady or EReady or RReady
            end
            local enemyDamageAA = getDmg("AD", player, enemy)
            local enemyNeededAA = math.ceil(player.health / enemyDamageAA)            
            enemyTable[i].damageGettingText = enemy.charName .. " kills me with " .. enemyNeededAA .. " hits"
        end
    end
end