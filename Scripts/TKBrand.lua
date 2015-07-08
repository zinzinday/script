--[[

  _______            _  __    _      ____                      _ 
 |__   __|          | |/ /   | |    |  _ \                    | |
    | | ___  _ __   | ' / ___| | __ | |_) |_ __ __ _ _ __   __| |
    | |/ _ \| '_ \  |  < / _ \ |/ / |  _ <| '__/ _` | '_ \ / _` |
    | | (_) | |_) | | . \  __/   <  | |_) | | | (_| | | | | (_| |
    |_|\___/| .__/  |_|\_\___|_|\_\ |____/|_|  \__,_|_| |_|\__,_|
            | |                                                  
            |_|                                                  

  By Nebelwolfi                             
 
]]--

--[[ Auto updater start ]]--
local version = 0.02
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/nebelwolfi/BoL/master/TKBrand.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."TKBrand.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>[Top Kek Series]: Brand - </b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
  local ServerData = GetWebResult(UPDATE_HOST, "/nebelwolfi/BoL/master/TKBrand.version")
  if ServerData then
    ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
    if ServerVersion then
      if tonumber(version) < ServerVersion then
        AutoupdaterMsg("New version available v"..ServerVersion)
        AutoupdaterMsg("Updating, please don't press F9")
        DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
      else
        AutoupdaterMsg("Loaded the latest version (v"..ServerVersion..")")
      end
    end
  else
    AutoupdaterMsg("Error downloading version info")
  end
end
--[[ Auto updater end ]]--

--[[ Skill list start ]]--
_G.Champs = {
	["Brand"] = {
    [_Q] = { speed = 1600, delay = 0.25, range = 900, width = 50, collision = true, aoe = false, type = "linear"},
    [_W] = { speed = math.huge, delay = 0.625, range = 900, width = 175, collision = false, aoe = true, type = "circular"},
    [_E] = { range = 625, type = "targeted"},
	[_R] = { range = 750, type = "targeted"}
    }
}

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

--[[ Libraries start ]]--
local predToUse = {}
VP = nil
DP = nil
HP = nil
if FileExist(LIB_PATH .. "/VPrediction.lua") then
  require("VPrediction")
  VP = VPrediction()
  table.insert(predToUse, "VPrediction")
end

if VIP_USER and FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then
  require "DivinePred"
  DP = DivinePred() 
  table.insert(predToUse, "DivinePred")
end

if FileExist(LIB_PATH .. "/HPrediction.lua") then
  require("HPrediction")
  HP = HPrediction()
  table.insert(predToUse, "HPrediction")
end

iOrb = nil
if FileExist(LIB_PATH.."iSAC.lua") then
  require "iSAC"
  iOrb = iOrbWalker(myHero.range) 
  iOrb:addAA()
end
--[[ Libraries end ]]--

--[[ Script start ]]--
if not Champs[myHero.charName] then return end -- not supported :(
if VIP_USER then HookPackets() end
local data = Champs[myHero.charName] -- load skills
local QReady, WReady, EReady, RReady = function() return myHero:CanUseSpell(_Q) end, function() return myHero:CanUseSpell(_W) end, function() return myHero:CanUseSpell(_E) end, function() return myHero:CanUseSpell(_R) end
local Target 
local sts
local predictions = {}
local combos = {}

function OnLoad()
  orbDisabled = false
  orbLast = 0
  Config = scriptConfig("Top Kek Brand", "TKBrand")
  
  Config:addSubMenu("Pred/Skill Settings", "misc")
  if VIP_USER then Config.misc:addParam("pc", "Use Packets To Cast Spells", SCRIPT_PARAM_ONOFF, false)
  Config.misc:addParam("qqq", " ", SCRIPT_PARAM_INFO,"") end
  if predToUse == {} then PrintChat("PLEASE DOWNLOAD A PREDICTION!") return end
  Config.misc:addParam("qqq", "RELOAD AFTER CHANGING PREDICTIONS! (2x F9)", SCRIPT_PARAM_INFO,"")
  Config.misc:addParam("pro",  "Type of prediction", SCRIPT_PARAM_LIST, 1, predToUse)

  if ActivePred() == "DivinePred" then Config.misc:addParam("time","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.13, 0, 1, 1) end
  if ActivePred() == "HPrediction" then SetupHPred() end
  
  Config:addSubMenu("Combo Settings", "comboConfig")
  
  local keys = {"Q","W","E"}
  shuffle(keys, #keys, combos)
  keys = {"Q","W","E","R"}
  shuffle(keys, #keys, combos)
  Config.comboConfig:addParam("so",  "Skill Order", SCRIPT_PARAM_LIST, 1, combos)
  Config.comboConfig:addParam("items",  "Use items in combo", SCRIPT_PARAM_ONOFF, true)
  Config.comboConfig:addParam("aa",  "Autoattack in between skills", SCRIPT_PARAM_ONOFF, true)
  Config.comboConfig:addParam("move",  "Move to mouse", SCRIPT_PARAM_ONOFF, true)
  Config.comboConfig:addParam("qqq", "Turn aa and move off with SAC:R!", SCRIPT_PARAM_INFO,"")
			
  Config:addSubMenu("Draw Settings", "Drawing")
	Config.Drawing:addParam("QRange", "Q Range", SCRIPT_PARAM_ONOFF, false)
	Config.Drawing:addParam("WRange", "W Range", SCRIPT_PARAM_ONOFF, false)
	Config.Drawing:addParam("ERange", "E Range", SCRIPT_PARAM_ONOFF, false)
	Config.Drawing:addParam("RRange", "R Range", SCRIPT_PARAM_ONOFF, false)
  
  Config:addParam("combo", "Combo (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  
  Config:permaShow("combo")
  sts = TargetSelector(TARGET_LESS_CAST, 1500, DAMAGE_MAGIC, true)
  Config:addTS(sts)
end

function ActivePred()
    local int = Config.misc.pro
    return tostring(predToUse[int])
end

function SetupHPred()
  MakeHPred("Q", 0) 
  MakeHPred("W", 1) 
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

function shuffle(a, n, whur)
	if n == 0 then
	  local c = ""
	  for i,v in ipairs(a) do
		c = v..c
	  end
	  whur[#whur+1] = c
	else
		for i=1,n do
			a[n], a[i] = a[i], a[n]
			shuffle(a, n-1, whur)
			a[n], a[i] = a[i], a[n]
		end
	end
end

function OnTick()
	Target = GetCustomTarget()
  if not myHero.dead and not recall then 
  	Combo()
  	if (Config.comboConfig.move and Config.combo) and not Config.comboConfig.aa then
  		moveToCursor()
  	end
  end
end   

function Combo()
	if recall or myHero.dead then return end
	local skillOrder = {}
	table.insert(skillOrder, string.sub(combos[Config.comboConfig.so], 1, 1))
	table.insert(skillOrder, string.sub(combos[Config.comboConfig.so], 2, 2))
	table.insert(skillOrder, string.sub(combos[Config.comboConfig.so], 3, 3))
	table.insert(skillOrder, string.sub(combos[Config.comboConfig.so], 4, 4))
	for i=1,4 do
		if orbDisabled or recall or myHero.dead then return end
		if skillOrder[i] == "Q" then
			if (Target ~= nil) and QReady then
				if ValidTarget(Target, data[0].range) and Config.combo then
					if GetDistance(Target, myHero) <= data[0].range then
            			CastQ(Target)
					end
				end
			end
		elseif skillOrder[i] == "W" then
			if (Target ~= nil) and WReady then
				if ValidTarget(Target, data[1].range) and Config.combo then
					if GetDistance(Target, myHero) <= data[1].range then
            			CastW(Target)
					end
				end
			end
		elseif skillOrder[i] == "E" then
			if (Target ~= nil) and EReady then
				if ValidTarget(Target, data[2].range) and Config.combo then
					if GetDistance(Target, myHero) <= data[2].range then
	            		CastE(Target)
					end
				end
			end
		elseif skillOrder[i] == "R" then
			if (Target ~= nil) and RReady then
				if ValidTarget(Target, data[3].range) and Config.combo then
					if GetDistance(Target, myHero) <= data[3].range then
	            	CastR(Target)
					end
				end
			end
		end
		if Config.comboConfig.items and Config.combo then
			UseItems(Target) --wtb logic
		end
		if Target ~=nil and Config.comboConfig.aa and Config.combo then	
			iOrb:Orbwalk(mousePos, Target)
		elseif iOrb:GetStage() == STAGE_NONE and Config.comboConfig.move and Config.combo then
			moveToCursor()
		end
	end
	if Target ~=nil and Config.comboConfig.aa and Config.combo and not recall and not myHero.dead then	
		iOrb:Orbwalk(mousePos, Target)
	elseif iOrb:GetStage() == STAGE_NONE and Config.comboConfig.move and Config.combo then
		moveToCursor()
	end
end

function moveToCursor()
	if GetDistance(mousePos) > 1 and not orbDisabled and not recall and not myHero.dead then
		iOrb:Move(mousePos)
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
end

function CastQ(Target) 
    if ActivePred() == "VPrediction" then 
      local CastPosition, HitChance, Position = VPredict(Target, data[0])
      if HitChance >= 2 then
        CCastSpell(_Q, CastPosition.x, CastPosition.z)
      end
    elseif ActivePred() == "DivinePred" then
      local State, Position, perc = DPredict(Target, data[0])
      if State == SkillShot.STATUS.SUCCESS_HIT then 
        CCastSpell(_Q, Position.x, Position.z)
      end
    elseif ActivePred() == "HPrediction" then
      local Position, HitChance = HPredict(Target, "Q")
      if HitChance >= 2 then 
        CCastSpell(_Q, Position.x, Position.z)
      end
    end
end
function CastW(Target) 
	if ActivePred() == "VPrediction" then
	  local CastPosition, HitChance, Position = VPredict(Target, data[1])
	  if HitChance >= 2 then
	    CCastSpell(_W, CastPosition.x, CastPosition.z)
	  end
	elseif ActivePred() == "DivinePred" then
	  local State, Position, perc = DPredict(Target, data[1])
	  if State == SkillShot.STATUS.SUCCESS_HIT then 
	    CCastSpell(_W, Position.x, Position.z)
	  end
	elseif ActivePred() == "HPrediction" then
	  local Position, HitChance = HPredict(Target, "W")
	  if HitChance >= 2 then 
	    CCastSpell(_W, Position.x, Position.z)
	  end
	end
end
function CastE(Target) 
	CastSpell(_E, Target)
end
function CastR(Target) 
    CastSpell(_R, Target)
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
    sts:update()
    if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
    if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
    return sts.target
end

--[[ Packet Cast Helper ]]--
function CCastSpell(Spell, xPos, zPos)
  if VIP_USER and Config.misc.pc then
    Packet("S_CAST", {spellId = Spell, fromX = xPos, fromY = zPos, toX = xPos, toY = zPos}):send()
  else
    CastSpell(Spell, xPos, zPos)
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