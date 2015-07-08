if myHero.charName ~= "Karthus" then return end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("XKNLNOKKOQK")

--[[

v. 1.02

Q Farming


v. 1.03

Add ManaManager


v. 1.04

Add KillSteal Mark

E Fix


v. 1.05

Add Harass Key (Not Toggle)

Add Harass E

E Fix

Fix Q Farming ( not perfect )

Fix harass to dead ts.target

Now you not harass when recall


v. 1.06

Delete Q manaManager In Combo


v. 1.10

Add Dpred

Bug Fix


v 1.12

Fix KillMark

Now You can Combo in Dead Passive

Fix Error


v. 1.13

Damage Manager


v. 1.15

Auto downLoad DPred


v 1.16

Fix AutoDownload

Fix KillMark, now you can see stat (Can, Cant, Dead)


v, 1.17

Add OrbWalk Checker


v, 1.18

Farming Fix


v. 1.21

Add Menu Auto E Off


v. 1.24

Fix OrbWalk


v. 1.27

v. 1.28

v. 1.28

Fix E


v. 1.30

Add Line Jungle Clear

Add KillMark location changer

Fix Q, W, E

Optimization


v. 1.31

Add Your Prediction Loader

More Perfectly Q Farming

v. 1.33
Add AA block you can chose only combo mode
Add E exploit
]]

local function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Your Karthus:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end

local version = 1.35
local AUTO_UPDATE = false
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/jineyne/bol/master/Your Karthus.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."Your Karthus.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

if AUTO_UPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/jineyne/bol/master/Your Karthus.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end

local SCRIPT_LIBS = {
	["SourceLib"] = "https://raw.github.com/LegendBot/Scripts/master/Common/SourceLib.lua",
	["VPrediction"] = "https://raw.github.com/LegendBot/Scripts/master/Common/VPrediction.lua",
	["DivinePred"] = "http://divinetek.rocks/divineprediction/DivinePred.lua",
	["HPrediction"]	= "https://raw.githubusercontent.com/BolHTTF/BoL/master/HTTF/Common/HPrediction.lua",
}
function Initiate()
	for LIBRARY, LIBRARY_URL in pairs(SCRIPT_LIBS) do
		if FileExist(LIB_PATH..LIBRARY..".lua") then
			require(LIBRARY)
		else
			DOWNLOADING_LIBS = true
			if LIBRARY == "DivinePred" then
				AutoupdaterMsg("Missing Library! Downloading "..LIBRARY..". If the library doesn't download, please download it manually.")
				DownloadFile("http://divinetek.rocks/divineprediction/DivinePred.lua", LIB_PATH.."DivinePred.lua",function() AutoupdaterMsg("Successfully downloaded "..LIBRARY) end)
				DownloadFile("http://divinetek.rocks/divineprediction/DivinePred.luac", LIB_PATH.."DivinePred.luac",function() AutoupdaterMsg("Successfully downloaded "..LIBRARY) end)
			else
				AutoupdaterMsg("Missing Library! Downloading "..LIBRARY..". If the library doesn't download, please download it manually.")
				DownloadFile(LIBRARY_URL,LIB_PATH..LIBRARY..".lua",function() AutoupdaterMsg("Successfully downloaded "..LIBRARY) end)
			end
		end
	end
	if DOWNLOADING_LIBS then return true end
end
if Initiate() then return end



if VIP_USER then
 	AdvancedCallback:bind('OnApplyBuff', function(source, unit, buff) OnApplyBuff(source, unit, buff) end)
	AdvancedCallback:bind('OnUpdateBuff', function(unit, buff, stack) OnUpdateBuff(unit, buff, stack) end)
	AdvancedCallback:bind('OnRemoveBuff', function(unit, buff) OnRemoveBuff(unit, buff) end)
end

local Qrange = 875
local Wrange = 1000
local Erange = 550

local Qready, Wready, Eready, Rready = nil, nil, nil, nil
local VPLoad, DPLoad, HPLoad = false, false, false
local useingE = false
local EActive = false
local recall = false
local j, CanKillChampion
local status
local dead = false
local player = myHero

local ts
local VP, SxO, dp = nil, nil, nil

local EnemyHeroes = GetEnemyHeroes()

--require "SxOrbWalk"
--require "SourceLib"

local Prediction = {}

class('Predloader')
function Predloader:__init()
end

function Predloader:Msg(msg) print("<font color=\"#6699ff\"><b>Your PredLoader:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end

function Predloader:LoadPred()
	if FileExist(LIB_PATH.."VPrediction.lua") then
		self:Msg("VPrediction Found Now support VPrediction")
		require "VPrediction"
		table.insert(Prediction, "VPrediction")
		VP = VPrediction()
		VPLoad = true
	end
	if FileExist(LIB_PATH.."DivinePred.lua") and FileExist(LIB_PATH.."DivinePred.luac") then
		self:Msg("DivinePred Found Now support DivinePred")
		require "DivinePred"
		table.insert(Prediction, "DivinePred")
		dp = DivinePred()
		DPLoad = true
	end
	if FileExist(LIB_PATH.."HPrediction.lua") then
		self:Msg("HPrediction Found Now support HPrediction")
		require "HPrediction"
		table.insert(Prediction, "HPrediction")
		HPred = HPrediction()
		HPLoad = true
	end
end


local enemyChamps = {}
local enemyChampsCount = 0

function OnOrbLoad()
	if _G.MMA_LOADED then
		AutoupdaterMsg("MMA LOAD")
		MMALoad = true
	elseif _G.AutoCarry then
		if _G.AutoCarry.Helper then
			AutoupdaterMsg("SIDA AUTO CARRY: REBORN LOAD")
			RebornLoad = true
		else
			AutoupdaterMsg("SIDA AUTO CARRY: REVAMPED LOAD")
			RevampedLoaded = true
		end
	elseif _G.Reborn_Loaded then
		SacLoad = true
		DelayAction(OnOrbLoad, 1)
	elseif FileExist(LIB_PATH .. "SxOrbWalk.lua") then
		AutoupdaterMsg("SxOrbWalk Load")
		require 'SxOrbWalk'
		SxO = SxOrbWalk()
		SxOLoad = true
	end
end

function OnLoad()

	PL = Predloader()
	OnOrbLoad()
	PL:LoadPred()
	STS = SimpleTS()


	if HPLoad then
		HPred:AddSpell("Q", 'Karthus', {type = "PromptCircle", range = 875, delay = 0.75, radius = 200})
		HPred:AddSpell("W", 'Karthus', {collisionM = false, collisionH = false, type = "DelayLine", range = 100, delay = 0.25, width = 10})
	end

	
	if GetGame().map.shortName == "twistedTreeline" then
		TwistedTreeline = true
	else
		TwistedTreeline = false
	end
	
	--UpdateWindow() 
	Setting()
	LoadMenu()
	initialize()


	enemyMinions = minionManager(MINION_ENEMY, 975, myHero, MINION_SORT_MAXHEALTH_DEC)
end

function LoadMenu()
	Config = scriptConfig("Your Karthus", "Karthus")
	
		Config:addSubMenu("TargetSelector", "TargetSelector")
			STS:AddToMenu(Config.TargetSelector)
		
		Config:addSubMenu("combo", "combo")
			Config.combo:addParam("activecombo", "combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
			Config.combo:addParam("useq", "use Q", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addParam("usew", "use W", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addParam("UseWinQrange", "Use W in Q range", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addParam("usee", "use E", SCRIPT_PARAM_ONOFF, true)
			Config.combo:addParam("pere", "Until % use W", SCRIPT_PARAM_SLICE, 0, 0, 100, 0)

		Config:addSubMenu("farm", "farm")
			Config.farm:addParam("farm", "farm", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
			Config.farm:addParam("useq", "use Q", SCRIPT_PARAM_ONOFF, true)

		Config:addSubMenu("harass", "harass")
			Config.harass:addParam("harassactive", "harass", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
			Config.harass:addParam("harasstoggle", "harass Toggle", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("G"))
			Config.harass:addParam("useq", "use Q", SCRIPT_PARAM_ONOFF, true)
			Config.harass:addParam("perq", "Until % Q", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			Config.harass:addParam("usee", "use E", SCRIPT_PARAM_ONOFF, true)
			Config.harass:addParam("pere", "Until % E", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
			--Config.harass:addParam("usew", "use W", SCRIPT_PARAM_ONOFF, true)
			--Config.harass:addParam("usee", "use E", SCRIPT_PARAM_ONOFF, true)
		
		Config:addSubMenu("Clear", "Clear")
			Config.Clear:addParam("ClearActice", "Clear Active", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
			Config.Clear:addParam("UseQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
			Config.Clear:addParam("perq", "Until % Q", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

		Config:addSubMenu("Prediction", "pred")
			Config.pred:addParam("choose", "Chooes Type", SCRIPT_PARAM_LIST, 1, Prediction)

		Config:addSubMenu("killsteal", "killsteal")
			Config.killsteal:addParam("killstealmark", "Killsteal Mark", SCRIPT_PARAM_ONOFF, true)
			--Config.killsteal:addParam("killstealq", "Killsteal Q Toggle", SCRIPT_PARAM_ONOFF, true)
			--Config.killsteal:addParam("killstealhitchance", "Killsteal hit chance", SCRIPT_PARAM_LIST, 1, {"1", "2", "3", "4", "5"})

		Config:addSubMenu("Misc", "ads")
			--Config.ads:addParam("adsr", "Use R After You dead", SCRIPT_PARAM_ONOFF, true)
			Config.ads:addParam("CastEeverytime", "Cast E every time", SCRIPT_PARAM_ONOFF, true)
			Config.ads:addParam("autoff", "E Auto Off", SCRIPT_PARAM_ONOFF, true)
			Config.ads:addParam("pa", "Passive Active Auto Attack", SCRIPT_PARAM_ONOFF, true)
			Config.ads:addParam("dm", "Damage Manager", SCRIPT_PARAM_ONOFF, true)
			Config.ads:addParam("BlockAautoattack","Block Auto attack", SCRIPT_PARAM_ONOFF, false)
			Config.ads:addParam("BlockAttackOnCombo", "Block Attack On combo", SCRIPT_PARAM_ONOFF, true)

		Config:addSubMenu("draw", "draw")
			Config.draw:addParam("drawq", "draw Q", SCRIPT_PARAM_ONOFF, true)
			Config.draw:addParam("draww", "draw W", SCRIPT_PARAM_ONOFF, true)
			Config.draw:addParam("drawe", "draw E", SCRIPT_PARAM_ONOFF, true)
			Config.draw:addParam("KillMarkX", "KillMark X ", SCRIPT_PARAM_SLICE, 100, 0, WINDOW_W, 0)
			Config.draw:addParam("KillMarkY", "KillMark Y ", SCRIPT_PARAM_SLICE, 100, 0, WINDOW_H, 0)
		
		if SxOLoad then
			Config:addSubMenu("orbWalk", "orbWalk")
				SxO:LoadToMenu(Config.orbWalk)
		end
end

function Setting()
	if not TwistedTreeline then
		JungleMobNames = {
			["SRU_MurkwolfMini2.1.3"]	= true,
			["SRU_MurkwolfMini2.1.2"]	= true,
			["SRU_MurkwolfMini8.1.3"]	= true,
			["SRU_MurkwolfMini8.1.2"]	= true,
			["SRU_BlueMini1.1.2"]		= true,
			["SRU_BlueMini7.1.2"]		= true,
			["SRU_BlueMini21.1.3"]		= true,
			["SRU_BlueMini27.1.3"]		= true,
			["SRU_RedMini10.1.2"]		= true,
			["SRU_RedMini10.1.3"]		= true,
			["SRU_RedMini4.1.2"]		= true,
			["SRU_RedMini4.1.3"]		= true,
			["SRU_KrugMini11.1.1"]		= true,
			["SRU_KrugMini5.1.1"]		= true,
			["SRU_RazorbeakMini9.1.2"]	= true,
			["SRU_RazorbeakMini9.1.3"]	= true,
			["SRU_RazorbeakMini9.1.4"]	= true,
			["SRU_RazorbeakMini3.1.2"]	= true,
			["SRU_RazorbeakMini3.1.3"]	= true,
			["SRU_RazorbeakMini3.1.4"]	= true
		}

		FocusJungleNames = {
			["SRU_Blue1.1.1"]			= true,
			["SRU_Blue7.1.1"]			= true,
			["SRU_Murkwolf2.1.1"]		= true,
			["SRU_Murkwolf8.1.1"]		= true,
			["SRU_Gromp13.1.1"]			= true,
			["SRU_Gromp14.1.1"]			= true,
			["Sru_Crab16.1.1"]			= true,
			["Sru_Crab15.1.1"]			= true,
			["SRU_Red10.1.1"]			= true,
			["SRU_Red4.1.1"]			= true,
			["SRU_Krug11.1.2"]			= true,
			["SRU_Krug5.1.2"]			= true,
			["SRU_Razorbeak9.1.1"]		= true,
			["SRU_Razorbeak3.1.1"]		= true,
			["SRU_Dragon6.1.1"]			= true,
			["SRU_Baron12.1.1"]			= true
		}
	else
		FocusJungleNames = {
			["TT_NWraith1.1.1"]			= true,
			["TT_NGolem2.1.1"]			= true,
			["TT_NWolf3.1.1"]			= true,
			["TT_NWraith4.1.1"]			= true,
			["TT_NGolem5.1.1"]			= true,
			["TT_NWolf6.1.1"]			= true,
			["TT_Spiderboss8.1.1"]		= true
		}
		JungleMobNames = {
			["TT_NWraith21.1.2"]		= true,
			["TT_NWraith21.1.3"]		= true,
			["TT_NGolem22.1.2"]			= true,
			["TT_NWolf23.1.2"]			= true,
			["TT_NWolf23.1.3"]			= true,
			["TT_NWraith24.1.2"]		= true,
			["TT_NWraith24.1.3"]		= true,
			["TT_NGolem25.1.1"]			= true,
			["TT_NWolf26.1.2"]			= true,
			["TT_NWolf26.1.3"]			= true
		}
	end
	_JungleMobs = minionManager(MINION_JUNGLE, Qrange+100, myHero, MINION_SORT_MAXHEALTH_DEC)
end

function GetHPBarPos(enemy)
	enemy.barData = {PercentageOffset = {x = -0.05, y = 0}}--GetEnemyBarData()
	local barPos = GetUnitHPBarPos(enemy)
	local barPosOffset = GetUnitHPBarOffset(enemy)
	local barOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local barPosPercentageOffset = { x = enemy.barData.PercentageOffset.x, y = enemy.barData.PercentageOffset.y }
	local BarPosOffsetX = 171
	local BarPosOffsetY = 46
	local CorrectionY = 39
	local StartHpPos = 31

	barPos.x = math.floor(barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + StartHpPos)
	barPos.y = math.floor(barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY)

	local StartPos = Vector(barPos.x , barPos.y, 0)
	local EndPos =  Vector(barPos.x + 108 , barPos.y , 0)
	return Vector(StartPos.x, StartPos.y, 0), Vector(EndPos.x, EndPos.y, 0)
end

function initialize()
	for i = 1, heroManager.iCount do
		local hero = heroManager:GetHero(i)
		if hero.team ~= myHero.team then enemyChamps[""..hero.networkID] = DPTarget(hero)
			enemyChampsCount = enemyChampsCount + 1
		end
	end
end

function OnTick()
	if myHero.dead then return end
	if Config.combo.activecombo then OnCombo() end
	if (Config.harass.harasstoggle and recall == false) or (Config.harass.harassactive and recall == false) then OnHarass() end
	OnSpellcheck()
	if Config.farm.farm then Farm() end
	if Config.Clear.ClearActice then Clear() end
	if CountEnemyHeroInRange(Erange) == 0 and EActive == true and Eready and Config.ads.autoff then CastSpell(_E) end
	if Config.combo.activecombo and EActive == true and Eready and Config.ads.CastEeverytime then CastSpell(_E) end
	if dead then PassiveActive() end
	BlockAA()
end

function BlockAA()
	
	if Config.ads.BlockAautoattack then
		if Config.ads.BlockAttackOnCombo then if not Config.combo.activecombo then return end end
		if MMALoad then
		elseif SacLoad then
			_G.AutoCarry.MyHero:AttacksEnabled(true)
		elseif SxOLoad then
			SxO:DisableAttacks()
		end
	else
		if MMALoad then
		elseif SacLoad then
			_G.AutoCarry.MyHero:AttacksEnabled(false)
		elseif SxOLoad then
			SxO:EnableAttacks()
		end
	end

end

function PassiveActive()
	local target = STS:GetTarget(Qrange)
	if target ~= nil and Config.ads.pa then
		CastQ(target)
		CastW(target)
	end
end

function OnCombo()
	local target = STS:GetTarget(Qrange)
	if target ~= nil then
		if Config.combo.useq then CastQ(target) end
		if Config.combo.usew then CastW(target) end
		if Config.combo.usee then CastE() end
	end
end

function OnHarass()
	local target = STS:GetTarget(Qrange)
	if target ~= nil then
		if Config.harass.useq then CastQ(target) end
		if Config.harass.usee then CastE() end
	end
end

function CastQ( target )
	if Qready then
		if Prediction[Config.pred.choose] == "VPrediction" then
			local CastPosition, HitChance, Position = VP:GetCircularAOECastPosition(target, 0.5, 200, 875, 1700, player)
			if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 875 and target.dead == false then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
		elseif Prediction[Config.pred.choose] == "DivinePred" and Config.combo.useq then
			local Target = DPTarget(target)
			local state,hitPos,perc = dp:predict(Target,CircleSS(math.huge,875,200,600,math.huge))
			if state == SkillShot.STATUS.SUCCESS_HIT then
				CastSpell(_Q,hitPos.x,hitPos.z)
			end
		elseif Prediction[Config.pred.choose] == "HPrediction" then
			local Pos, HitChance = HPred:GetPredict("Q", target, myHero)
			if HitChance ~= 0 and Pos ~= nil then
			  CastSpell(_Q, Pos.x, Pos.z)
			end
		end
	end
end

function CastW( target )
	if Wready then
		if Config.combo.UseWinQrange then 
			if GetDistance(target, player) > 875 then
				return
			end
		end
		if Prediction[Config.pred.choose] == "VPrediction" then
			local CastPosition, HitChance, Position = VP:GetCircularCastPosition(target, 0.5, 10, 1000)
			if CastPosition and HitChance >= 1 and GetDistance(CastPosition) < 1000 then
				CastSpell(_W, CastPosition.x, CastPosition.z)
			end
		elseif Prediction[Config.pred.choose] == "DivinePred" then
			local Target = DPTarget(target)
			local state,hitPos,perc = dp:predict(Target,CircleSS(math.huge,1000,10,160,math.huge))
			if state == SkillShot.STATUS.SUCCESS_HIT then
				CastSpell(_W,hitPos.x,hitPos.z)
			end
		elseif Prediction[Config.pred.choose] == "HPrediction" then
			local Pos, HitChance = HPred:GetPredict("W", target, myHero)
			if HitChance ~= 0 and Pos ~= nil then
				CastSpell(_W, Pos.x, Pos.z)
			end
		end
	end
end

function CastE()
	if CountEnemyHeroInRange(Erange) >= 1 and not EActive then
		CastSpell(_E)
	elseif CountEnemyHeroInRange(Erange) == 0 and EActive then
		CastSpell(_E)
	end
end


function OnSpellcheck()
	if myHero:CanUseSpell(_Q) == READY then
		Qready = true
	else
		Qready = false
	end

	if myHero:CanUseSpell(_W) == READY then
		Wready = true
	else
		Wready = false
	end

	if myHero:CanUseSpell(_E) == READY then
		Eready = true
	else
		Eready = false
	end

	if myHero:CanUseSpell(_Q) == READY then
		Rready = true
	else
		Rready = false
	end
end

function OnDraw()
	if Config.draw.drawq then
		DrawCircle(myHero.x, myHero.y, myHero.z, 875, 0xFFFFCC)
	end
	if Config.draw.draww then
		DrawCircle(myHero.x, myHero.y, myHero.z, 1000, 0xFFFF0000)
	end
	if Config.draw.drawe then
		DrawCircle(myHero.x, myHero.y, myHero.z, 475, 0xFFFFFFff)
	end
	if Config.killsteal.killstealmark then
		for j, CanKillChampion in pairs(EnemyHeroes) do
			if stat(CanKillChampion) == "Can" then
				DrawText(CanKillChampion.charName.." can kill with R? | "..stat(CanKillChampion), 18, Config.draw.KillMarkX, Config.draw.KillMarkY+j*20, 0xFFFF0000)
			elseif stat(CanKillChampion) == "dead" or stat(CanKillChampion) == "Can't" then
				DrawText(CanKillChampion.charName.." can kill with R? | "..stat(CanKillChampion), 18, Config.draw.KillMarkX, Config.draw.KillMarkY+j*20, 0xFFFFFF00)
			end
		end
	end
	for i, j in ipairs(GetEnemyHeroes()) do
		if GetDistance(j) < 2000 and not j.dead and Config.ads.dm and ValidTarget(j) then
			local pos = GetHPBarPos(j)
			local dmg, Qdamage = GetSpellDmg(j)
			if dmg == "CanComboKill" then
				DrawText("Can Combo Kill!",18 , pos.x, pos.y-48, 0xffff0000)
			else
				local pos2 = ((j.health - dmg)/j.maxHealth)*100
				DrawLine(pos.x+pos2, pos.y, pos.x+pos2, pos.y-30, 1, 0xffff0000)
				local hit = tostring(math.ceil(j.health/Qdamage))
				DrawText("Q hit : "..hit,18 , pos.x, pos.y-48, 0xffff0000)
			end
		end
	end
end

function GetSpellDmg(enemy)
	local combodmg
	local Qdmg = getDmg("Q", enemy, player)
	local Edmg = getDmg("E", enemy, player)
	local Rdmg = getDmg("R", enemy, player)
	if enemy.health < Qdmg+Edmg+Rdmg then
		combodmg = "CanComboKill"
		return combodmg
	else
		combodmg = Qdmg+Edmg+Rdmg
		return combodmg, Qdmg
	end
end

function stat(unit)
	if getDmg("R", unit, myHero) > unit.health and not unit.dead then
		status = "Can"
	else
		status = "Can't"
	end
	if unit.dead then
		status = "dead"
	end
	return status
end

function Farm()
	enemyMinions:update()
	for i, minion in ipairs(enemyMinions.objects) do
		if GetDistance(minion) <= 875 and myHero:CanUseSpell(_Q) == READY and Config.farm.useq then
			local bestpos, besthit = GetBestCircularFarmPosition(875, 200, enemyMinions.objects)
			if besthit == 1 then
				if getDmg("Q", minion, myHero) > minion.health then
					CastQ(minion)
				end
			elseif besthit > 1 then
				if getDmg("Q", minion, myHero)*0.5 > minion.health then
					CastQ(minion)
				end
			end
		end
	end
end

function Clear()
	_JungleMobs:update()
	for i, minion in pairs(_JungleMobs.objects) do
		if minion ~= nil and not minion.dead and GetDistance(minion) < 975 and Config.Clear.UseQ and player.mana > (player.maxMana*(Config.Clear.perq*0.01)) then
			local bestpos, besthit = GetBestCircularFarmPosition(875, 200, _JungleMobs.objects)
			if bestpos ~= nil then
				CastSpell(_Q, bestpos.x, bestpos.z)
			end
		end
	end
	enemyMinions:update()
	for i, minion in pairs(enemyMinions.objects) do
		if minion ~= nil and not minion.dead and GetDistance(minion) < 975 and Config.Clear.UseQ and player.mana > (player.maxMana*(Config.Clear.perq*0.01)) then
			local bestpos, besthit = GetBestCircularFarmPosition(875, 200, enemyMinions.objects)
			if bestpos ~= nil then
				CastSpell(_Q, bestpos.x, bestpos.z)
			end
		end
	end
end

function GetBestCircularFarmPosition(range, radius, objects)
    local BestPos 
    local BestHit = 0
    for i, object in ipairs(objects) do
        local hit = CountObjectsNearPos(object.pos or object, range, radius, objects)
        if hit > BestHit then
            BestHit = hit
            BestPos = Vector(object)
            if BestHit == #objects then
               break
            end
         end
    end
    return BestPos, BestHit
end

function CountObjectsOnLineSegment(StartPos, EndPos, width, objects)
    local n = 0
    for i, object in ipairs(objects) do
        local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(StartPos, EndPos, object)
        if isOnSegment and GetDistanceSqr(pointSegment, object) < width * width then
            n = n + 1
        end
    end
    return n
end

function CountObjectsNearPos(pos, range, radius, objects)
    local n = 0
    for i, object in ipairs(objects) do
        if GetDistanceSqr(pos, object) <= radius * radius then
            n = n + 1
        end
    end
    return n
end

function OnApplyBuff(source, unit, buff)
	if unit and unit.isMe and buff.name == "KarthusDefile" then
		EActive = true
    end
	if unit and unit.isMe and buff.name == "recall" then
		recall = true
    end
	if unit and unit.isMe and buff.name == "KarthusDeathDefiedBuff" then
		dead = true
	end
end

function OnRemoveBuff(unit, buff)
    if unit and unit.isMe and buff.name == "KarthusDefile" then
        EActive = false
    end
	if unit and unit.isMe and buff.name == "recall" then
		recall = false
    end
	if unit and unit.isMe and buff.name == "KarthusDeathDefiedBuff" then
		dead = false
	end
end

