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
		[_R] = { range = 350, type = "notarget"}
    },
	["Khazix"] = {
		[_Q] = { range = 325, type = "targeted"},
    [_W] = { speed = 1700, delay = 0.25, range = 1025, width = 70, collision = true, aoe = false, type = "linear"},
		[_E] = { speed = 400, delay = 0.25, range = 600, width = 325, collision = false, aoe = true, type = "circular"},
		[_R] = { range = 0, type = "dontuse"}
    },
	["Leblanc"] = {
		[_Q] = { range = 700, type = "targeted"},
		[_W] = { speed = 1300, delay = 0.250, range = 600, width = 300, collision = false, aoe = false, type = "circular"},
    [_E] = { speed = 1300, delay = 0.250, range = 950, width = 55, collision = true, aoe = false, type = "linear"},
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

--[[ Auto updater start ]]--
local version = 0.55
local AUTO_UPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/nebelwolfi/BoL/master/AssassinAiO.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH.."AssassinAiO.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH
local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>[Assassin AiO]:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTO_UPDATE then
  local ServerData = GetWebResult(UPDATE_HOST, "/nebelwolfi/BoL/master/AssassinAiO.version")
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

--Scriptstatus Tracker
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("PCFEDDEKCKH") 
--Scriptstatus Tracker

UPL = nil
if FileExist(LIB_PATH .. "/UPL.lua") then
  require("UPL")
  UPL = UPL()
else 
  AutoupdaterMsg("Please download the UPLib.") 
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
if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then Ignite = SUMMONER_1 elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then Ignite = SUMMONER_2 end
local QReady, WReady, EReady, RReady, IReady = function() return myHero:CanUseSpell(_Q) end, function() return myHero:CanUseSpell(_W) end, function() return myHero:CanUseSpell(_E) end, function() return myHero:CanUseSpell(_R) end, function() if Ignite ~= nil then return myHero:CanUseSpell(Ignite) end end
local Target 
local sts
local combos = {}
local harr = {"Q", "W", "E"}
local orbDisabled
local orbLast
local enemyCount = 0
local enemyTable = {}
local lastUsedSpell = nil
local ForceTarget = nil

function OnLoad()
  orbDisabled = false
  orbLast = 0
  Config = scriptConfig("Assassin AiO", "Assassin AiO")
  
  Config:addSubMenu("Pred/Skill Settings", "misc")
  if VIP_USER then Config.misc:addParam("pc", "Use Packets To Cast Spells", SCRIPT_PARAM_ONOFF, false)
  Config.misc:addParam("qqq", " ", SCRIPT_PARAM_INFO,"") end
	Config.misc:addParam("hitchance", "Accuracy (Default: 2)", SCRIPT_PARAM_SLICE, 2, 0, 3, 1)
  UPL:AddToMenu(Config.misc)
  
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
  if Ignite ~= nil then Config.KS:addParam("killstealI", "Use Ignite", SCRIPT_PARAM_ONOFF, true) end
			
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
      if champ.team ~= myHero.team then
          enemyCount = enemyCount + 1
          enemyTable[enemyCount] = { player = champ, name = champ.charName, damageQ = 0, damageE = 0, damageR = 0, indicatorText = "", damageGettingText = "", ready = true}
      end
  end
  for i=0,3 do
    if data[i].type ~= nil and (data[i].type == "linear" or data[i].type == "circular" or data[i].type == "cone") then
      UPL:AddSpell(i, data[i])
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
  if Forcetarget ~= nil and ValidTarget(Forcetarget, 1500) then
    Target = Forcetarget  
  end
	if orbDisabled then
		if (os.clock() - orbLast) > 2.5 then
			orbDisabled = false
			orbLast  = 0
		end
	else
	  if not myHero.dead and not orbDisabled then 
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
		local iDmg = 50 + (20 * myHero.level)
		if ValidTarget(enemy) and enemy ~= nil and Config.KS.enableKS and not enemy.dead and enemy.visible then
			if enemy.health < qDmg and Config.KS.killstealQ and ValidTarget(enemy, data[0].range) then
				Castspell(Target, _Q)
			elseif enemy.health < wDmg and Config.KS.killstealW and ValidTarget(enemy, data[1].range) then
				Castspell(Target, _W)
			elseif enemy.health < eDmg and Config.KS.killstealE and ValidTarget(enemy, data[2].range) then
				Castspell(Target, _E)
			elseif enemy.health < rDmg and Config.KS.killstealR and ValidTarget(enemy, data[3].range) then
				Castspell(Target, _R)
			elseif enemy.health < iDmg and Config.KS.killstealI and ValidTarget(enemy, 600) and IReady() then
				CastSpell(Ignite, enemy)
			end
		end
	end
end

function Harrass()
	if orbDisabled or Config.combo then return end
  harrEnabled = false
  if Config.harr or Config.har then harrEnabled = true end
	local skillOrder = {}
	table.insert(skillOrder, string.sub(harr[Config.harrConfig.so], 1, 1))
	table.insert(skillOrder, string.sub(harr[Config.harrConfig.so], 2, 2))
	table.insert(skillOrder, string.sub(harr[Config.harrConfig.so], 3, 3))
	--PrintChat("Executing combo: "..skillOrder[1]..skillOrder[2]..skillOrder[3]..skillOrder[4]) --combos[Config.comboConfig.so]
	for i=1,3 do
		if orbDisabled or myHero.dead then return end
		if skillOrder[i] == "Q" then
			if (Target ~= nil) and QReady() then
				if ValidTarget(Target, data[0].range) and harrEnabled then
					if GetDistance(Target, myHero) <= data[0].range then
            Castspell(Target, _Q)
						lastUsedSpell = _Q
					end
				end
			end
		elseif skillOrder[i] == "W" then
			if (Target ~= nil) and WReady() then
				if ValidTarget(Target, data[1].range) and harrEnabled then
					if GetDistance(Target, myHero) <= data[1].range then
            Castspell(Target, _W)
						lastUsedSpell = _W
					end
				end
			end
		elseif skillOrder[i] == "E" then
			if (Target ~= nil) and EReady() then
				if ValidTarget(Target, data[2].range) and harrEnabled then
					if GetDistance(Target, myHero) <= data[2].range then
            Castspell(Target, _E)
						lastUsedSpell = _E
					end
				end
			end
		end
		if Target ~=nil and Config.harrConfig.aa and harrEnabled and not orbDisabled then	
			iOrb:Orbwalk(mousePos, Target)
		elseif iOrb:GetStage() == STAGE_NONE and Config.harrConfig.move and harrEnabled then
			moveToCursor()
		end
	end
  if Target ~=nil and Config.harrConfig.aa and harrEnabled and not orbDisabled then 
    iOrb:Orbwalk(mousePos, Target)
  elseif iOrb:GetStage() == STAGE_NONE and Config.harrConfig.move and (Config.harr or Config.har) then
    moveToCursor()
  end
end

function Combo()
	if orbDisabled or myHero.dead then return end
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
		if orbDisabled or myHero.dead then return end
		if skillOrder[i] == "Q" then
			if (Target ~= nil) and QReady() then
				if ValidTarget(Target, data[0].range) and comboOn then
					if GetDistance(Target, myHero) <= data[0].range then
            Castspell(Target, _Q)
						lastUsedSpell = _Q
					end
				end
			end
		elseif skillOrder[i] == "W" then
			if (Target ~= nil) and WReady() then
				if ValidTarget(Target, data[1].range) and comboOn then
					if GetDistance(Target, myHero) <= data[1].range then
            Castspell(Target, _W)
						lastUsedSpell = _W
					end
				end
			end
		elseif skillOrder[i] == "E" then
			if (Target ~= nil) and EReady() then
				if ValidTarget(Target, data[2].range) and comboOn then
					if GetDistance(Target, myHero) <= data[2].range then
            Castspell(Target, _E)
						lastUsedSpell = _E
					end
				end
			end
		elseif skillOrder[i] == "R" then
			if (Target ~= nil) and RReady() then
				if myHero.charName:lower() == "leblanc" then
					if lastUsedSpell == _Q then
						data[3] = data[0]
					elseif lastUsedSpell == _W then
						data[3] = data[1]
					elseif lastUsedSpell == _E then
						data[3] = data[2]
					end
          UPL:AddSpell(3, data[3])
				end
				if ValidTarget(Target, data[3].range) and comboOn then
					if GetDistance(Target, myHero) <= data[3].range then
            Castspell(Target, _R)
            lastUsedSpell = _R
					end
				end
			end
		end
		if Target ~=nil and Config.comboConfig.aa and comboOn and not orbDisabled then	
			iOrb:Orbwalk(mousePos, Target)
		elseif iOrb:GetStage() == STAGE_NONE and Config.comboConfig.move and Config.combo then
			moveToCursor()
		end
	end
	if Target ~=nil and Config.comboConfig.aa and comboOn and not orbDisabled and not myHero.dead then	
		iOrb:Orbwalk(mousePos, Target)
	elseif iOrb:GetStage() == STAGE_NONE and Config.comboConfig.move and comboOn then
		moveToCursor()
	end
end

function Castspell(Target, spell) 
  if data[spell].aareset and Target ~= nil then
    CastSpell(spell, myHero:Attack(Target))
  elseif data[spell].type == "notarget" then 
    CastSpell(spell)
  elseif data[spell].type == "targeted" then 
    CastSpell(spell, Target)
  elseif data[spell].type == "dontuse" then 
    return
  elseif Target ~= nil then
    local CastPosition, HitChance, Position = UPL:Predict(spell, myHero, Target)
    if HitChance >= Config.misc.hitchance then
      CCastSpell(spell, CastPosition.x, CastPosition.z)
    end
  end
end

function moveToCursor()
	if GetDistance(mousePos) > 1 and not orbDisabled and not myHero.dead then
		iOrb:Move(mousePos)
	end
end

function OnProcessSpell(object, spell)
	if object == myHero then
		iOrb:OnProcessSpell(object, spell)
		if spell.name:lower():find("katarinar") then
			orbDisabled = true
			orbLast = os.clock()
		end
	end
end

function OnCastSpell(spell,startPos,endPos,targetUnit)
  if spell == _R then
      orbDisabled = true
      orbLast = os.clock()
  end
end

function OnWndMsg(Msg, Key)
  if Msg == WM_LBUTTONDOWN then
    local minD = 0
    local starget = nil
    for i, enemy in ipairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) then
        if GetDistance(enemy, mousePos) <= minD or starget == nil then
          minD = GetDistance(enemy, mousePos)
          starget = enemy
        end
      end
    end
    
    if starget and minD < 500 then
      if Forcetarget and starget.charName == Forcetarget.charName then
        Forcetarget = nil
      else
        Forcetarget = starget
        print("<font color=\"#FF0000\">Assassin AiO: New target selected: "..starget.charName.."</font>")
      end
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
            local damageI  = Ignite and (50+20*myHero.level) or 0
            enemyTable[i].damageQ = damageQ
            enemyTable[i].damageW = damageW
            enemyTable[i].damageE = damageE
            enemyTable[i].damageR = damageR
            if enemy.health < damageQ then
                enemyTable[i].indicatorText = "Q Kill"
                enemyTable[i].ready = QReady()
            elseif enemy.health < damageW then
                enemyTable[i].indicatorText = "W Kill"
                enemyTable[i].ready = WReady()
            elseif enemy.health < damageE then
                enemyTable[i].indicatorText = "E Kill"
                enemyTable[i].ready = EReady()
            elseif enemy.health < damageR then
                enemyTable[i].indicatorText = "R Kill"
                enemyTable[i].ready = RReady()
            elseif enemy.health < damageQ + damageW then
                enemyTable[i].indicatorText = "Q + W Kill"
                enemyTable[i].ready = QReady() and WReady()
            elseif enemy.health < damageE + damageQ then
                enemyTable[i].indicatorText = "Q + E Kill"
                enemyTable[i].ready = EReady() and QReady()
            elseif enemy.health < damageW + damageE then
                enemyTable[i].indicatorText = "W + E Kill"
                enemyTable[i].ready = WReady() and EReady()
            elseif enemy.health < damageR + damageQ then
                enemyTable[i].indicatorText = "Q + R Kill"
                enemyTable[i].ready = RReady() and QReady()
            elseif enemy.health < damageR + damageE then
                enemyTable[i].indicatorText = "E + R Kill"
                enemyTable[i].ready = RReady() and EReady()
            elseif enemy.health < damageR + damageW then
                enemyTable[i].indicatorText = "W + R Kill"
                enemyTable[i].ready = RReady() and WReady()
            elseif enemy.health < damageQ + damageW + damageE then
                enemyTable[i].indicatorText = "Q + W + E Kill"
                enemyTable[i].ready = QReady() and WReady() and EReady()
            elseif enemy.health < damageQ + damageW + damageR then
                enemyTable[i].indicatorText = "Q + W + R Kill"
                enemyTable[i].ready = QReady() and WReady() and EReady()
            elseif enemy.health < damageQ + damageE + damageR then
                enemyTable[i].indicatorText = "Q + E + R Kill"
                enemyTable[i].ready = QReady() and EReady() and EReady()
            elseif enemy.health < damageR + damageW + damageE then
                enemyTable[i].indicatorText = "W + E + R Kill"
                enemyTable[i].ready = RReady() and WReady() and EReady()
            elseif enemy.health < damageQ + damageW + damageE + damageR + damageAA + damageI then
                enemyTable[i].indicatorText = "All-In Kill"
                enemyTable[i].ready = QReady() and WReady() and EReady() and RReady()
            else
                local damageTotal = damageQ + damageW + damageE + damageR
                local healthLeft = math.round(enemy.health - damageTotal)
                local percentLeft = math.round(healthLeft / enemy.maxHealth * 100)
                enemyTable[i].indicatorText = percentLeft .. "% Harass"
                enemyTable[i].ready = QReady() or WReady() or EReady() or RReady()
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
  if Forcetarget ~= nil then
    DrawCircle(Forcetarget.x, Forcetarget.y, Forcetarget.z, Forcetarget.boundingRadius, ARGB(255, 0, 255, 0))
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