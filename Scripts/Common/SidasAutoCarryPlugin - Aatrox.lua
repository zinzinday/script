--[[
 
        Auto Carry Plugin - Aatrox Edition
		Author: Berb
		Version: 1.0
		Copyright 2015

		Features:
			Combo
			KS
			Harass
			W logic

		History:
			Version: 1.0
				-First release
--]]

if myHero.charName ~= "Aatrox" then return end

--[[ Libraries start ]]--
if not _G.UPLloaded then
  if FileExist(LIB_PATH .. "/UPL.lua") then
    require("UPL")
    _G.UPL = UPL()
  else 
    print("Downloading UPL, please don't press F9")
    DelayAction(function() DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Common/UPL.lua".."?rand="..math.random(1,10000), LIB_PATH.."UPL.lua", function () TopKekMsg("Successfully downloaded UPL. Press F9 twice.") end) end, 3)
    return
  end
end
--[[ Libraries end ]]--

local Target

-- Prediction

local QReady, WReady, EReady, RReady, FlashReady = false, false, false, false, false
local ignite, igniteReady = nil, nil

function PluginOnLoad() 

	print("Loaded Aatrox by Berb!")
	
	-- Params
	AutoCarry.PluginMenu:addParam("aCombo", "Use Combo With SAC:R", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("autoW", "Auto W (Under 50% HP = Off)", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("aKS", "Killsteal", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("aHarass", "Harass (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	AutoCarry.PluginMenu:addParam("drawings", "Skill Draws", SCRIPT_PARAM_ONOFF, false)
	
	-- Prediction
	UPL:AddSpell(_Q, {speed = 450, delay = 0.25, range = 650, width = 150, collision = false, aoe = true, type = "circular"})
	UPL:AddSpell(_E, {speed = 1200, delay = 0.25, range = 1000, width = 150, collision = false, aoe = false, type = "linear"})
end 

-- On Button or 'tick'
function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()
	
	SmartW()
	SpellCheck()

	if AutoCarry.PluginMenu.aKS then
		killSteal()
	end
	
	if AutoCarry.PluginMenu.aCombo and AutoCarry.MainMenu.AutoCarry then
		Combo()
	end
	
	if AutoCarry.PluginMenu.aHarass and AutoCarry.MainMenu.MixedMode then
		Harass()
	end
end

-- Drawings
function PluginOnDraw()
	if not myHero.dead and AutoCarry.PluginMenu.drawings then
		DrawCircle(myHero.x, myHero.y, myHero.z, 650, 0x00FF00)
		DrawCircle(myHero.x, myHero.y, myHero.z, 1000, 0x00FF00)
	end
end

-- Custom Functions
function Combo()
	if ValidTarget(Target) then
		CastR()
		if ValidTarget(Target, 650) and QReady then
			CastQ(Target)
		end
		if ValidTarget(Target, 1000) and EReady then
			CastE(Target)
		end
	end
end

function Harass()
	if ValidTarget(Target) then
		if ValidTarget(Target, 1000) and EReady then
			CastE(Target)
		end
	end
end

function killSteal()
	if ValidTarget(Target) then
        for _, enemy in pairs(AutoCarry.EnemyTable) do
			if ValidTarget(enemy) and GetDistance(enemy) < 650 and enemy.health < (getDmg("Q", enemy, myHero)) then
				local CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, Target)
				CastSpell(_Q, CastPosition.x, CastPosition.z)
			end
			if ValidTarget(enemy) and GetDistance(enemy) < 1000 and enemy.health < (getDmg("E", enemy, myHero)) then
				local CastPosition, HitChance, HeroPosition = UPL:Predict(_E, myHero, Target)
				CastSpell(_E, CastPosition.x, CastPosition.z)
			end			
        end
	end
end

-- Cast Logic
function CastQ(Targ)
	if Target == nil then return end
	local CastPosition, HitChance, HeroPosition = UPL:Predict(_Q, myHero, Target)
    if HitChance >= 1 then
      CastSpell(_Q, CastPosition.x, CastPosition.z)
    end
end

function CastW()
	if WReady then
		SmartW()
	end
end

function CastE(Targ)
	if Target == nil then return end
	local CastPosition, HitChance, HeroPosition = UPL:Predict(_E, myHero, Target)
    if HitChance >= 0.5 then
      CastSpell(_E, CastPosition.x, CastPosition.z)
    end
end

function CastR()
	if RReady then
		CastSpell(_R)
	end
end

-- SpellCheck CD
function SpellCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerFlash") then
		FlashSlot = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerFlash") then
		FlashSlot = SUMMONER_2
	end

	QReady = (myHero:CanUseSpell(_Q) == READY)
	WReady = (myHero:CanUseSpell(_W) == READY)
	EReady = (myHero:CanUseSpell(_E) == READY)
	RReady = (myHero:CanUseSpell(_R) == READY)
	
	-- Summoners
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then
		ignite = SUMMONER_2
	end
	igniteReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)	
	
	FlashReady = (FlashSlot ~= nil and myHero:CanUseSpell(FlashSlot) == READY)
end

-- Aatrox Skills - Taken from Fukda

function SmartW()
    if AutoCarry.PluginMenu.autoW then
        if myHero.health < (myHero.maxHealth * 0.50) then
            if isWOn() then
               CastSpell(_W)
            end
        end
        if myHero.health > (myHero.maxHealth * 0.50) then
            if not isWOn() then
               CastSpell(_W)     
            end	  
        end
	end
end

function isWOn()
  if myHero:GetSpellData(_W).name == "aatroxw2" then
    return true
  else
    return false
  end
end