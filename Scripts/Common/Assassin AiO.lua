--[[

                                  _                  _  ____  
      /\                         (_)           /\   (_)/ __ \ 
     /  \   ___ ___  __ _ ___ ___ _ _ __      /  \   _| |  | |
    / /\ \ / __/ __|/ _` / __/ __| | '_ \    / /\ \ | | |  | |
   / ____ \\__ \__ \ (_| \__ \__ \ | | | |  / ____ \| | |__| |
  /_/    \_\___/___/\__,_|___/___/_|_| |_| /_/    \_\_|\____/ 
 
 
]]--

--[[ Assassin list start ]]--
_G.Champs = {
	["Ahri"] = {
		[_Q] = { speed = 2500, delay = 0.25, range = 900, width = 100, collision = false, aoe = false, type = "linear"},
		[_W] = { range = 800, type = "notarget"},
		[_E] = { speed = 1000, delay = 0.25, range = 1000, width = 60, collision = true, aoe = false, type = "linear"},
		[_R] = { range = 100, type = "notarget"}
    },
	["Akali"] = {
		[_Q] = { range = 600, type = "targeted"},
		[_W] = { speed = math.huge, delay = 0.1, range = 700, width = 400, collision = false, aoe = true, type = "circular"},
		[_E] = { range = 325, type = "notarget"},
		[_R] = { range = 700, type = "targeted"}
    },
  ["Diana"] = {
    [_Q] = { speed = math.huge, delay = 0.25, range = 900, width = 195, collision = false, aoe = true, type = "linear"}, --wat
    [_W] = { range = 450, type = "notarget"},
    [_E] = { speed = math.huge, delay = 0.5, range = 0, width = 450, collision = false, aoe = true, type = "circular"},
    [_R] = { speed = 825, type = "targeted"}
    },
  ["Evelynn"] = {
    [_Q] = { range = 500, type = "notarget"},
    [_W] = { range = 650, type = "notarget"},
    [_E] = { range = 275, type = "targeted"},
    [_R] = { speed = 1300, delay = 0.250, range = 650, width = 500, collision = false, aoe = true, type = "circular"}
    },
	["Fiora"] = {
    [_Q] = { range = 600, type = "targeted"},
    [_W] = { range = 20, type = "notarget"},
    [_E] = { range = 500, type = "notarget"},
    [_R] = { range = 400, type = "targeted"}
    },
	["Fizz"] = {
    [_Q] = { range = 550, type = "targeted"},
    [_W] = { range = 600, type = "notarget"},
    [_E] = { speed = math.huge, delay = 0.302, range = 600, width = 75, collision = false, aoe = true, type = "circular"},
    [_R] = { speed = 1350, delay = 0.250, range = 1275, width = 80, collision = false, aoe = false, type = "linear"}
    },
	["Irelia"] = {
    [_Q] = { range = 650, type = "targeted"},
    [_W] = { range = myHero.range, type = "notarget"},
    [_E] = { range = 325, type = "targeted"},
    [_R] = { speed = 900, delay = 0.250, range = 1000, width = 80, collision = false, aoe = false, type = "linear"}
    },
	["Jax"] = {
		[_Q] = { range = 6700, type = "targeted"},
		[_W] = { range = myHero.range, type = "notarget", aareset = true},
		[_E] = { range = 250, type = "notarget"},
		[_R] = { range = 700, type = "notarget"}
    },
	["Kassadin"] = {
		[_Q] = { range = 650, type = "targeted"},
		[_W] = { range = 250, type = "notarget", aareset = true},
    [_E] = { speed = 2200, delay = 0, range = 650, width = 80, collision = false, aoe = false, type = "cone"},
    [_R] = { speed = math.huge, delay = 0.5, range = 500, width = 150, collision = false, aoe = true, type = "circular"}
    },
	["Katarina"] = {
		[_Q] = { range = 675, type = "targeted"},
		[_W] = { range = 375, type = "notarget"},
		[_E] = { range = 700, type = "targeted"},
		[_R] = { range = 550, type = "notarget"}
    },
	["Khazix"] = {
		[_Q] = { range = 325, type = "targeted"},
    [_W] = { speed = 1700, delay = 0.25, range = 1025, width = 70, collision = true, aoe = false, type = "linear"},
		[_E] = { speed = 400, delay = 0.25, range = 600, width = 325, collision = false, aoe = true, type = "circular"},
		[_R] = { range = 0, type = "dontuse"}
    },
	["Leblanc"] = {
		[_Q] = { range = 700, type = "targeted"},
		[_W] = { speed = 2000, delay = 0.250, range =600, width = 300, collision = false, aoe = false, type = "circular"},
    [_E] = { speed = 1600, delay = 0.250, range = 950, width = 70, collision = true, aoe = false, type = "linear"},
		[_R] = { range = 0, type = "mimikri"}
    },
	["LeeSin"] = {
    [_Q] = { speed = 1500, delay = 0.250, range = 1000, width = 60, collision = true, aoe = false, type = "linear"},
    [_W] = { range = 700, type = "notarget"},
    [_E] = { speed = math.huge, delay = 0.125, range = 0, width = 425, collision = false, aoe = true, type = "circular"},
    [_R] = { range = 375, type = "targeted"}
    },
	["Malzahar"] = {
    [_Q] = { speed = 1170, delay = 0.600, range = 900, width = 50, collision = false, aoe = false, type = "linear"},
    [_W] = { speed = math.huge, delay = 0.125, range = 800, width = 250, collision = false, aoe = true, type = "circular"},
    [_E] = { range = 650, type = "targeted"},
    [_R] = { range = 700, type = "targeted"}
    },
	["MasterYi"] = {
		[_Q] = { range = 600, type = "targeted"},
		[_W] = { range = 0, type = "dontuse"},
		[_E] = { range = 125, type = "notarget"},
		[_R] = { range = 125, type = "notarget"}
    },
	["Nocturne"] = {
    [_Q] = { speed = 1400, delay = 0.250, range = 1125, width = 60, collision = false, aoe = false, type = "linear"},
    [_W] = { range = 20, type = "notarget"},
    [_E] = { range = 425, type = "targeted"},
    [_R] = { range = 3500, type = "targeted"}
    },
	["Pantheon"] = {
    [_Q] = { range = 600, type = "targeted" },
    [_W] = { range = 600, type = "targeted"},
    [_E] = { speed = math.huge, delay = 0.250, range = 400, width = 100, collision = false, aoe = true, type = "cone"},
    [_R] = { speed = 3000, delay = 1, range = 5500, width = 1000, collision = false, aoe = true, type = "circular"}
    },
	["Poppy"] = {
    [_Q] =  { range = 600, type = "targeted"},
    [_W] = { range = 600, type = "targeted"},
    [_E] = { range = 525, type = "targeted"},
    [_R] = { range = 900, type = "targeted"}
    },
	["Rengar"] = {
		[_Q] = { range = 125, type = "notarget", aareset = true},
		[_W] = { speed = math.huge, delay = 0.5, range = 390, width = 55, collision = false, aoe = false, type = "circular"},
    [_E] = { speed = 1500, delay = 0.50, range = 1000, width = 80, collision = false, aoe = false, type = "linear"},
    [_R] = { range = 4000, type = "notarget"}
    },
	["Riven"] = {--blergh
    [_Q] = { speed = math.huge, delay = 0.250, range = 0, width = 225, collision = false, aoe = true, type = "circular"},
    [_W] = { speed = math.huge, delay = 0.250, range = 0, width = 250, collision = false, aoe = true, type = "circular"},
    [_E] = { range = 325, type = "notarget"},
    [_R] = { speed = 2200, delay = 0.5, range = 1100, width = 200, collision = false, aoe = false, type = "cone"}
    },
	["Ryze"] = {
    [_Q] = { speed = 1700, delay = 0.25, range = 900, width = 50, collision = true, aoe = false, type = "linear"},
		[_W] = { range = 600, type = "targeted"},
		[_E] = { range = 600, type = "targeted"},
		[_R] = { range = 125, type = "notarget"}
    },
	["Shaco"] = {
    [_Q] = { range = 400, type = "notarget"},
    [_W] = { range = 425, type = "notarget"},
    [_E] = { range = 625, type = "targeted"},
    [_R] = { range = 500, type = "notarget"}
    },
	["Talon"] = {
    [_Q] = { range = 200, type = "notarget", aareset = true},
    [_W] = { speed = 900, delay = 0.7, range = 600, width = 200, collision = false, aoe = false, type = "cone"},
    [_E] = { range = 700, type = "targeted"},
    [_R] = { range = 650, type = "notarget"}
    },
	["Teemo"] = {--
    [_Q] = { range = myHero.range, type = "targeted"},
    [_W] = { range = 750, type = "notarget"},
    [_E] = { range = myHero.range, type = "dontuse"},
    [_R] = { range = 230, type = "notarget"}
    },
	["Tryndamere"] = {--
    [_Q] = { range = 20, type = "notarget"},
    [_W] = { range = 850, type = "notarget"},
    [_E] = { speed = 700, delay = 0.250, range = 650, width = 160, collision = false, aoe = false, type = "linear"},
    [_R] = { range = 400, type = "dontuse"}
    },
	["XinZhao"] = {--
    [_Q] = { range = 375, type = "notarget"},
    [_W] = { range = 20, type = "notarget"},
    [_E] = { range = 650, type = "targeted"},
    [_R] = { speed = math.huge, delay = 0.25, range = 0, width = 375, collision = false, aoe = true, type = "circular"}
    },
	["Yasuo"] = {
    [_Q] = { speed = math.huge, delay = 0.250, range = 475, width = 40, collision = false, aoe = false, type = "linear"},
    [_W] = { range = 600, type = "targeted"},
    [_E] = { range = 20, type = "notarget"},
    [_R] = { range = 500, type = "notarget"}
    },
	["Zed"] = {
    [_Q] = { speed = 1700, delay = 0.25, range = 900, width = 48, collision = false, aoe = false, type = "linear"},
    [_W] = { speed = 1600, delay = 0.5, range = 550, width = 40, collision = false, aoe = false, type = "dontuse"}, --aim yourself.. wut?
    [_E] = { speed = math.huge, delay = 0, range = 0, width = 300, collision = false, aoe = true, type = "circular"},
    [_R] = { range = 850, type = "targeted"}
    }
}

local CastableItems = {
Tiamat      = { Range = 400, Slot = function() return GetInventorySlotItem(3077) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3077) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3077)) == READY) end, Damage = function(target) return getDmg("TIAMAT", Target, myHero) end},
Hydra       = { Range = 400, Slot = function() return GetInventorySlotItem(3074) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3074) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3074)) == READY) end, Damage = function(target) return getDmg("HYDRA", Target, myHero) end},
Bork        = { Range = 450, Slot = function() return GetInventorySlotItem(3153) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3153) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3153)) == READY) end, Damage = function(target) return getDmg("RUINEDKING", Target, myHero) end},
Bwc         = { Range = 400, Slot = function() return GetInventorySlotItem(3144) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3144) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3144)) == READY) end, Damage = function(target) return getDmg("BWC", Target, myHero) end},
Hextech     = { Range = 400, Slot = function() return GetInventorySlotItem(3146) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3146) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3146)) == READY) end, Damage = function(target) return getDmg("HXG", Target, myHero) end},
Blackfire   = { Range = 750, Slot = function() return GetInventorySlotItem(3188) end,  reqTarget = true, IsReady = function() return (GetInventorySlotItem(3188) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3188)) == READY) end, Damage = function(target) return getDmg("BLACKFIRE", Target, myHero) end},
Youmuu      = { Range = 350, Slot = function() return GetInventorySlotItem(3142) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3142) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3142)) == READY) end, Damage = function(target) return 0 end},
Randuin     = { Range = 500, Slot = function() return GetInventorySlotItem(3143) end,  reqTarget = false, IsReady = function() return (GetInventorySlotItem(3143) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3143)) == READY) end, Damage = function(target) return 0 end},
TwinShadows = { Range = 1000, Slot = function() return GetInventorySlotItem(3023) end, reqTarget = false, IsReady = function() return (GetInventorySlotItem(3023) ~= nil and myHero:CanUseSpell(GetInventorySlotItem(3023)) == READY) end, Damage = function(target) return 0 end},
}

--[[ Auto updater start ]]--
local version = 0.44
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/nebelwolfi/BoL/master/Assassin AiO.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."Assassin AiO.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>[Assassin AiO]:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
  local ServerData = GetWebResult(UPDATE_HOST, "/nebelwolfi/BoL/master/Assassin AiO.version")
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

--[[ Libraries start ]]--
if not Champs[myHero.charName] then champions = nil CastableItems = nil collectgarbage() return end -- not supported :(
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
	AutoupdaterMsg("Please download a Prediction") 
	return 
end

iOrb = nil
if FileExist(LIB_PATH.."iSAC.lua") then
  require "iSAC"
  iOrb = iOrbWalker(myHero.range) 
  iOrb:addAA()
end

if iOrb == nil then 
	AutoupdaterMsg("Please download iSAC") 
	return 
end
--[[ Libraries end ]]--

--[[ Script start ]]--
if VIP_USER then HookPackets() end
local data = Champs[myHero.charName] -- load skills
local QReady, WReady, EReady, RReady = function() return myHero:CanUseSpell(_Q) end, function() return myHero:CanUseSpell(_W) end, function() return myHero:CanUseSpell(_E) end, function() return myHero:CanUseSpell(_R) end
local Target 
local sts
local predictions = {}
local combos = {}
local harr = {"Q", "W", "E"}
local orbDisabled
local orbLast
local enemyCount = 0
local enemyTable = {}
local lastUsedSpell = nil

function OnLoad()
  orbDisabled = false
  orbLast = 0
  Config = scriptConfig("Assassin AiO", "Assassin AiO")
  
  Config:addSubMenu("Pred/Skill Settings", "misc")
  Config.misc:addParam("pc", "Use Packets To Cast Spells", SCRIPT_PARAM_ONOFF, false)
  Config.misc:addParam("qqq", " ", SCRIPT_PARAM_INFO,"")
  if predToUse == {} then PrintChat("PLEASE DOWNLOAD A PREDICTION!") return end
  Config.misc:addParam("qqq", " ", SCRIPT_PARAM_INFO,"")
  Config.misc:addParam("qqq", "RELOAD AFTER CHANGING PREDICTIONS! (2x F9)", SCRIPT_PARAM_INFO,"")
  Config.misc:addParam("pro",  "Type of prediction", SCRIPT_PARAM_LIST, 1, predToUse)
  if ActivePred() == "VPrediction" or ActivePred() == "HPrediction" then 
	 Config.misc:addParam("hitchance", "Accuracy (Default: 2)", SCRIPT_PARAM_SLICE, 2, 0, 3, 1)
  elseif ActivePred() == "DivinePred" then
	 Config.misc:addParam("hitchance", "Accuracy (Default: 1.2)", SCRIPT_PARAM_SLICE, 1.2, 0, 1.5, 1)
   if Config.misc.hitchance > 1.5 then Config.misc.hitchance = 1.2 end
	 Config.misc:addParam("time","DPred Extra Time", SCRIPT_PARAM_SLICE, 0.13, 0, 1, 1)
  end

  if ActivePred() == "HPrediction" then SetupHPred() end
  
  Config:addSubMenu("Combo Settings", "comboConfig")
  
  local keys = {"Q","W","E"}
  shuffle(keys, #keys, combos)
  keys = {"Q","W","E","R"}
  shuffle(keys, #keys, combos)
  Config.comboConfig:addSubMenu("Combo Key Settings", "cConfig")
  Config.comboConfig.cConfig:addParam("so",  "Skill Order Key 1", SCRIPT_PARAM_LIST, 1, combos)
  Config.comboConfig.cConfig:addParam("st",  "Skill Order Key 2", SCRIPT_PARAM_LIST, 1, combos)
  Config.comboConfig.cConfig:addParam("sz",  "Skill Order Key 3", SCRIPT_PARAM_LIST, 1, combos)
  Config.comboConfig:addParam("aa",  "Autoattack in between skills", SCRIPT_PARAM_ONOFF, true)
  Config.comboConfig:addParam("move",  "Move to mouse", SCRIPT_PARAM_ONOFF, true)
  Config.comboConfig:addParam("items",  "Use items in combo", SCRIPT_PARAM_ONOFF, true)
  
  Config:addSubMenu("Harrass Settings", "harrConfig")
  keys = {"Q","W"}
  shuffle(keys, #keys, harr)
  keys = {"Q","E"}
  shuffle(keys, #keys, harr)
  keys = {"W","E"}
  shuffle(keys, #keys, harr)
  keys = {"Q","W","E"}
  shuffle(keys, #keys, harr)
  Config.harrConfig:addParam("so",  "Skill Order", SCRIPT_PARAM_LIST, 1, harr)
  Config.harrConfig:addParam("aa",  "Autoattack in between skills", SCRIPT_PARAM_ONOFF, true)
  Config.harrConfig:addParam("move",  "Move to mouse", SCRIPT_PARAM_ONOFF, true)
  
	Config:addSubMenu("Killsteal Settings", "KS")
	Config.KS:addParam("enableKS", "Enable Killsteal", SCRIPT_PARAM_ONOFF, true)
	Config.KS:addParam("killstealQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
	Config.KS:addParam("killstealW", "Use W", SCRIPT_PARAM_ONOFF, true)
	Config.KS:addParam("killstealE", "Use E", SCRIPT_PARAM_ONOFF, true)
	Config.KS:addParam("killstealR", "Use R", SCRIPT_PARAM_ONOFF, true)
	--Config.KS:addParam("killstealI", "Use Ignite", SCRIPT_PARAM_ONOFF, true)
			
    Config:addSubMenu("Draw Settings", "Drawing")
	Config.Drawing:addParam("QRange", "Q Range", SCRIPT_PARAM_ONOFF, false)
	Config.Drawing:addParam("WRange", "W Range", SCRIPT_PARAM_ONOFF, false)
	Config.Drawing:addParam("ERange", "E Range", SCRIPT_PARAM_ONOFF, false)
	Config.Drawing:addParam("RRange", "R Range", SCRIPT_PARAM_ONOFF, false)
	Config.Drawing:addParam("DmgCalcs", "Killable Text", SCRIPT_PARAM_ONOFF, true)
  
  Config:addParam("comboo", "Combokey1 (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  Config:addParam("combot", "Combokey2 (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("I"))
  Config:addParam("comboz", "Combokey3 (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("O"))
  Config:addParam("har", "Harrass (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
  Config:addParam("harr", "Harrass (TOGGLE)", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("T"))
  
  Config:permaShow("comboo")
  Config:permaShow("combot")
  Config:permaShow("comboz")
  Config:permaShow("har")
  Config:permaShow("harr")
  sts = TargetSelector(TARGET_LESS_CAST, 1500, DAMAGE_MAGIC, true)
  Config:addTS(sts)
  
    for i = 1, heroManager.iCount do
        local champ = heroManager:GetHero(i)
        if champ.team ~= player.team then
            enemyCount = enemyCount + 1
            enemyTable[enemyCount] = { player = champ, name = champ.charName, damageQ = 0, damageE = 0, damageR = 0, indicatorText = "", damageGettingText = "", ready = true}
        end
    end
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
	if orbDisabled then
		if (os.clock() - orbLast) > 2.5 then
			orbDisabled = false
			orbLast  = 0
		end
	else
	  if not myHero.dead and not recall then 
		Combo()
		Harrass()
		EveAntiSlow()
		if Config.KS.enableKS then
			killsteal()
		end
		if ((Config.comboConfig.move and Config.combo) or ((Config.har or Config.harr) and Config.harrConfig.move)) and not Config.comboConfig.aa then
			moveToCursor()
		end
	  end
	end
	DmgCalculations()
end   

function killsteal()
	for i=1, heroManager.iCount do
		local enemy = heroManager:GetHero(i)
		local qDmg = ((getDmg("Q", enemy, myHero)) or 0)	
		local wDmg = ((getDmg("W", enemy, myHero)) or 0)	
		local eDmg = ((getDmg("E", enemy, myHero)) or 0)	
		local rDmg = ((getDmg("R", enemy, myHero)) or 0)
		--local iDmg = 50 + (20 * myHero.level)
		if ValidTarget(enemy) and enemy ~= nil and Config.KS.enableKS and not enemy.dead and enemy.visible then
			if enemy.health < qDmg and Config.KS.killstealQ and ValidTarget(enemy, data[0].range) then
				CastSpell(_Q, enemy)
			elseif enemy.health < wDmg and Config.KS.killstealW and ValidTarget(enemy, data[1].range) then
				CastSpell(_W, enemy)
			elseif enemy.health < eDmg and Config.KS.killstealE and ValidTarget(enemy, data[2].range) then
				CastSpell(_E, enemy)
			elseif enemy.health < rDmg and Config.KS.killstealR and ValidTarget(enemy, data[3].range) then
				CastSpell(_R, enemy)
			--elseif enemy.health < iDmg and Config.KS.killstealI and ValidTarget(enemy, 600) and IReady then
			--	CastSpell(SSpells:GetSlot("summonerdot"), enemy)
			end
		end
	end
end

function Harrass()
	if orbDisabled or Config.combo then return end
	local skillOrder = {}
	table.insert(skillOrder, string.sub(harr[Config.harrConfig.so], 1, 1))
	table.insert(skillOrder, string.sub(harr[Config.harrConfig.so], 2, 2))
	table.insert(skillOrder, string.sub(harr[Config.harrConfig.so], 3, 3))
	--PrintChat("Executing combo: "..skillOrder[1]..skillOrder[2]..skillOrder[3]..skillOrder[4]) --combos[Config.comboConfig.so]
	for i=1,3 do
		if orbDisabled or recall or myHero.dead then return end
		if skillOrder[i] == "Q" then
			if (Target ~= nil) and QReady then
				if ValidTarget(Target, data[0].range) and (Config.harr or Config.har) then
					if GetDistance(Target, myHero) <= data[0].range then
            CastQ(Target)
						lastUsedSpell = _Q
					end
				end
			end
		elseif skillOrder[i] == "W" then
			if (Target ~= nil) and WReady then
				if ValidTarget(Target, data[1].range) and (Config.harr or Config.har) then
					if GetDistance(Target, myHero) <= data[1].range then
            CastW(Target)
						lastUsedSpell = _W
					end
				end
			end
		elseif skillOrder[i] == "E" then
			if (Target ~= nil) and EReady then
				if ValidTarget(Target, data[2].range) and (Config.harr or Config.har) then
					if GetDistance(Target, myHero) <= data[2].range then
            CastE(Target)
						lastUsedSpell = _E
					end
				end
			end
		end
		if Target ~=nil and Config.harrConfig.aa and (Config.harr or Config.har) and not orbDisabled then	
			iOrb:Orbwalk(mousePos, Target)
		elseif iOrb:GetStage() == STAGE_NONE and Config.harrConfig.move and (Config.harr or Config.har) then
			moveToCursor()
		end
	end
  if Target ~=nil and Config.harrConfig.aa and (Config.harr or Config.har) and not orbDisabled then 
    iOrb:Orbwalk(mousePos, Target)
  elseif iOrb:GetStage() == STAGE_NONE and Config.harrConfig.move and (Config.harr or Config.har) then
    moveToCursor()
  end
end

function Combo()
	if orbDisabled or recall or myHero.dead then return end
	local skillOrder = {}
  local comboOn = false
  if Config.comboo then
  comboOn = true
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.so], 1, 1))
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.so], 2, 2))
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.so], 3, 3))
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.so], 4, 4))
  elseif Config.combot then
  comboOn = true
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.st], 1, 1))
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.st], 2, 2))
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.st], 3, 3))
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.st], 4, 4))
  elseif Config.comboz then
  comboOn = true
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.sz], 1, 1))
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.sz], 2, 2))
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.sz], 3, 3))
  table.insert(skillOrder, string.sub(combos[Config.comboConfig.cConfig.sz], 4, 4))
  end
	--PrintChat("Executing combo: "..skillOrder[1]..skillOrder[2]..skillOrder[3]..skillOrder[4]) --combos[Config.comboConfig.so]
	for i=1,4 do
		if orbDisabled or recall or myHero.dead then return end
		if skillOrder[i] == "Q" then
			if (Target ~= nil) and QReady then
				if ValidTarget(Target, data[0].range) and comboOn then
					if GetDistance(Target, myHero) <= data[0].range then
            Castspell(Target, _Q)
						lastUsedSpell = _Q
					end
				end
			end
		elseif skillOrder[i] == "W" then
			if (Target ~= nil) and WReady then
				if ValidTarget(Target, data[1].range) and comboOn then
					if GetDistance(Target, myHero) <= data[1].range then
            Castspell(Target, _W)
						lastUsedSpell = _W
					end
				end
			end
		elseif skillOrder[i] == "E" then
			if (Target ~= nil) and EReady then
				if ValidTarget(Target, data[2].range) and comboOn then
					if GetDistance(Target, myHero) <= data[2].range then
            Castspell(Target, _E)
						lastUsedSpell = _E
					end
				end
			end
		elseif skillOrder[i] == "R" then
			if (Target ~= nil) and RReady then
				if myHero.charName:lower() == "leblanc" then
					if lastUsedSpell == _Q then
						data[3] = data[0]
					elseif lastUsedSpell == _W then
						data[3] = data[1]
					elseif lastUsedSpell == _E then
						data[3] = data[2]
					end
          if ActivePred() == "HPrediction" then SetupHPred() end -- kanker
				end
				if ValidTarget(Target, data[3].range) and comboOn then
					if GetDistance(Target, myHero) <= data[3].range then
            Castspell(Target, _R)
            lastUsedSpell = _R
					end
				end
			end
		end
		if Config.comboConfig.items and comboOn then
			UseItems(Target) --wtb logic
		end
		if Target ~=nil and Config.comboConfig.aa and comboOn and not orbDisabled then	
			iOrb:Orbwalk(mousePos, Target)
		elseif iOrb:GetStage() == STAGE_NONE and Config.comboConfig.move and Config.combo then
			moveToCursor()
		end
	end
	if Target ~=nil and Config.comboConfig.aa and comboOn and not orbDisabled and not recall and not myHero.dead then	
		iOrb:Orbwalk(mousePos, Target)
	elseif iOrb:GetStage() == STAGE_NONE and Config.comboConfig.move and comboOn then
		moveToCursor()
	end
end

function Castspell(Target, spell) 
  if data[spell].aareset then
    CastSpell(spell, myHero:Attack(Target))
  elseif data[spell].type == "notarget" then 
    CastSpell(spell)
  elseif data[spell].type == "targeted" then 
    CastSpell(spell, Target)
  elseif data[spell].type == "dontuse" then 
    return
  else
    local CastPosition, HitChance, Position = Predict(Target, spell)
    if HitChance >= Config.misc.hitchance then
      CCastSpell(spell, CastPosition.x, CastPosition.z)
    end
  end
end

function moveToCursor()
	if GetDistance(mousePos) > 1 and not orbDisabled and not recall and not myHero.dead then
		iOrb:Move(mousePos)
	end
end

function OnProcessSpell(object, spell)
	if object == myHero then
		iOrb:OnProcessSpell(object, spell)
		if spell.name:lower():find("katarinar") and Config.combo then
			orbDisabled = true
			orbLast = os.clock()
		end
	end
end

speed = myHero.ms
old_speed = myHero.ms
function EveAntiSlow()
	if myHero.charName == "Evelynn" then
		speed = myHero.ms
		if speed < old_speed and (100-(speed*100/old_speed)) > 15 then
				CastSpell(_W)
		end
		old_speed = speed
	end
end

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

local colorRangeReady        = ARGB(255, 200, 0,   200)
local colorRangeComboReady   = ARGB(255, 255, 128, 0)
local colorRangeNotReady     = ARGB(255, 50,  50,  50)
local colorIndicatorReady    = ARGB(255, 0,   255, 0)
local colorIndicatorNotReady = ARGB(255, 255, 220, 0)
local colorInfo              = ARGB(255, 255, 50,  0)
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

local str = { [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R" }
function Predict(Target, spell)
    if ActivePred() == "VPrediction" then
        return VPredict(Target, spell)
    elseif ActivePred() == "Prodiction" then
        return nil
    elseif ActivePred() == "DivinePred" then
        local State, Position, perc = DPredict(Target, spell)
        return Position, perc*3/100, Position
    elseif ActivePred() == "HPrediction" then
        return HPredict(Target, str[spell])
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