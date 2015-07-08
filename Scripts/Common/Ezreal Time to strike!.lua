------#################################################################################------  ------########################### Ezreal's Time to strike! ############################------ ------###########################         by Toy           ############################------ ------#################################################################################------

--> Version: 2.1

--> Features:
--> Prodictions in every skill, also taking their hitboxes in consideration.
--> Cast options for Q and W in both, autocarry and mixed mode (Works separately).
--> Auto-aim Trueshot Barrage activated with a separated Hotkey (Default is Spacebar, can be changed on the menu, don't set it to R if you have Smartcast enabled for R) so you can use it when you think it's better, and it will still aim for you, the range to shot it can be set up to 2000 in the Range & Collision Settings menu.
--> KS with Trueshot Barrage, will use Trueshot Barrage if the enemy is killable and is whitin the customizable Skill Crosshair range (can be turned on/off).
--> Draw options for every skill, and also a option to draw the furthest skill avaiable (Except his ultimate).
--> Options to Last Hit with Q in LastHit and LaneClear mode.
--> Options to cancel Blitzcrank Grab.
--> Options to use Muramana.
--> Option for Auto-attack reset with W.
--> If Mystic Shot would interrupt the auto-attack, it waits till the auto-attack goes off before shoting it, therefore won't interrupt auto-attack(Reborn only, Revamped users won't be affected by this, but can still use the plugin normally).
--> Optional use of FastCollision or not in the Range & Collision Settings menu (requires reload, it will display a message telling you if you are using Fast Collision or Normal Collision).
--> Optional customizable skill ranges, set the skills to whatever range you like (default is max range), also you can change the skill cross-hair range (target selector range, if you set it to a value below 1100, Q and W will be limited by this range, recomended is betwen 1100 and 1200), disable the option to reset the ranges to the default, he ranges are configured with a slider.
--> Optional use of VPrediction to predict the skillshoots instead of Prodictions (There's no need to reload too), with a slider to set the hitchance from 0 to 5, and a button to check the informations about hitchance ingame, VPrediction comes enabled by deafault, you can disable it on the Range & Libs menu.

if myHero.charName ~= "Ezreal" then return end

require "Prodiction"
require "VPrediction"
 
local qRange = 1100
local wRange = 1050
local eRange = 475
local rRange = 2000
local xRange = 1100
 
local QColValue = nil
local QAble, WAble, Eable, RAble = false, false, false, false
 
local Prodict = ProdictManager.GetInstance()
local ProdictQ, ProdictQCol, ProdictionQFastCol
local ProdictW
local ProdictR

local grabbed = false
local grab = nil

local ProdictQCol = nil
local ProdictQFastCol = nil

local VP = nil
 
function PluginOnLoad()
        AutoCarry.SkillsCrosshair.range = xRange
        Menu()
        RebornCheck()
        
        ProdictQ = Prodict:AddProdictionObject(_Q, qRange, 2000, 0.251, 80)
        ProdictW = Prodict:AddProdictionObject(_W, wRange, 1600, 0.25, 90)               
        ProdictR = Prodict:AddProdictionObject(_R, rRange, 2000, 1, 150)
        
        VP = VPrediction()
end

function KS()
	for i, enemy in ipairs(GetEnemyHeroes()) do
	local rDmg = getDmg("R", enemy, myHero)
		if Target and not Target.dead and Target.health < rDmg and GetDistance(Target) < rRange then
			ProdictR:GetPredictionCallBack(Target, CastR)
		end
	end
end
 
function PluginOnTick()
    Checks()
    if Target then
      if Target and (AutoCarry.MainMenu.AutoCarry) then
        MysticShot()
        EssenceFlux()
        EssenceFluxReset()
      end
      if Target and (AutoCarry.MainMenu.MixedMode) then
        MysticShot2()
        EssenceFlux2()
      end
      if AutoCarry.PluginMenu.KS and RAble then KS()
      end
    end
    if AutoCarry.PluginMenu.useR then
       TrueShotBarrage()
       AutoCarry.SkillsCrosshair.range = AutoCarry.PluginMenu.ranges.rRanger else AutoCarry.SkillsCrosshair.range = AutoCarry.PluginMenu.ranges.xRanger end
 --
 if not AutoCarry.PluginMenu.ranges.useRanger then
 AutoCarry.PluginMenu.ranges.xRanger = 1100
 AutoCarry.PluginMenu.ranges.qRanger = 1100
 AutoCarry.PluginMenu.ranges.wRanger = 1050
 AutoCarry.PluginMenu.ranges.rRanger = 2000
 end
 --
 if AutoCarry.PluginMenu.ranges.HitChanceInfo then
 PrintChat ("<font color='#FFFFFF'>Hitchance 0: No waypoints found for the target, returning target current position</font>")
 PrintChat ("<font color='#FFFFFF'>Hitchance 1: Low hitchance to hit the target</font>")
 PrintChat ("<font color='#FFFFFF'>Hitchance 2: High hitchance to hit the target</font>")
 PrintChat ("<font color='#FFFFFF'>Hitchance 3: Target too slowed or/and too close(~100% hit chance)</font>")
 PrintChat ("<font color='#FFFFFF'>Hitchance 4: Target inmmobile(~100% hit chace)</font>")
 PrintChat ("<font color='#FFFFFF'>Hitchance 5: Target dashing(~100% hit chance)</font>")
 AutoCarry.PluginMenu.ranges.HitChanceInfo = false
 end
 --
  if AutoCarry.PluginMenu.ToggleMuramana then MuramanaToggle() end
 --
 	if QAble and AutoCarry.PluginMenu.qFarm and AutoCarry.MainMenu.LastHit then
		if Minion and not Minion.type == "obj_Turret" and not Minion.dead and GetDistance(Minion) <= qRange and Minion.health < getDmg("Q", Minion, myHero) then 
			CastSpell(_Q, Minion.x, Minion.z)
		else 
			for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
				if minion and not minion.dead and GetDistance(minion) <= qRange and minion.health < getDmg("Q", minion, myHero) then 
					CastSpell(_Q, minion.x, minion.z)
				end
			end
		end
	end
--
	if AutoCarry.PluginMenu.Cancelblitzgrabs and grab ~= nil and grab:GetDistance(myHero) < 500 then
	  destX = myHero.x * 4 - blitzChamp.x*3
      destZ = myHero.z * 4  - blitzChamp.z*3
	  if math.abs((myHero.x-blitzChamp.x) * (grab.z - blitzChamp.z) - (myHero.z-blitzChamp.z) * (grab.x - blitzChamp.x)) < 39000
	  then CastSpell(_E, destX, destZ) end
	end
--	
	if QAble and AutoCarry.PluginMenu.qClear and AutoCarry.MainMenu.LaneClear then
		if Minion and not Minion.type == "obj_Turret" and not Minion.dead and GetDistance(Minion) <= qRange and Minion.health < getDmg("Q", Minion, myHero) then 
			CastSpell(_Q, Minion.x, Minion.z)
		else 
			for _, minion in pairs(AutoCarry.EnemyMinions().objects) do
				if minion and not minion.dead and GetDistance(minion) <= qRange and minion.health < getDmg("Q", minion, myHero) then 
					CastSpell(_Q, minion.x, minion.z)
				end
			end
		end
	end
end
 
function PluginOnDraw()
    if not myHero.dead then
		  if QAble and AutoCarry.PluginMenu.drawF then
      DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0xFFFFFF)
      else
      if WAble and AutoCarry.PluginMenu.drawF then
      DrawCircle(myHero.x, myHero.y, myHero.z, wRange, 0xFFFFFF)
			else
      end
      end
      if QAble and AutoCarry.PluginMenu.drawQ then
      DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0xFFFFFF)
		  end
		  if WAble and AutoCarry.PluginMenu.drawW then
      DrawCircle(myHero.x, myHero.y, myHero.z, wRange, 0x9933FF)
		  end
      if EAble and AutoCarry.PluginMenu.drawE then
      DrawCircle(myHero.x, myHero.y, myHero.z, eRange, 0xFF0000)
		  end
      if RAble and AutoCarry.PluginMenu.drawR then
      DrawCircle(myHero.x, myHero.y, myHero.z, rRange, 0x9933FF)
	    end
   end
end

 function Menu()
  local HKR = string.byte("T")
  AutoCarry.PluginMenu:addSubMenu("-- [Range & Libs Settings] --", "ranges")
  AutoCarry.PluginMenu.ranges:addParam("useRanger", "Use - Custom Ranges", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu.ranges:addParam("xRanger", "Range - Skill Crosshair", SCRIPT_PARAM_SLICE, 1200, 550, 1500, 0)
  AutoCarry.PluginMenu.ranges:addParam("qRanger", "Range - Mystic Shot", SCRIPT_PARAM_SLICE, 1100, 550, 1100, 0)
  AutoCarry.PluginMenu.ranges:addParam("wRanger", "Range - Essence Flux", SCRIPT_PARAM_SLICE, 1050, 550, 1050, 0)
  AutoCarry.PluginMenu.ranges:addParam("rRanger", "Range - Trueshot Barrage", SCRIPT_PARAM_SLICE, 2000, 550, 2000, 0)
  AutoCarry.PluginMenu.ranges:addParam("UseVP", "Use - VPrediction", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu.ranges:addParam("HitChance", "VP - Hitchance", SCRIPT_PARAM_SLICE, 2, 0, 5, 0)
  AutoCarry.PluginMenu.ranges:addParam("HitChanceInfo", "Info - Hitchance", SCRIPT_PARAM_ONOFF, false)
  AutoCarry.PluginMenu.ranges:addParam("ColSwap", "Use - Fast Collision (Reload)", SCRIPT_PARAM_ONOFF, false)
  AutoCarry.PluginMenu:addParam("sep", "-- Ultimate Options --", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("useR", "Use - Trueshot Barrage", SCRIPT_PARAM_ONKEYDOWN, false, HKR)
  AutoCarry.PluginMenu:addParam("KS", "KS - Trueshot Barrage", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("sep1", "-- Autocarry Options --", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("resetW", "AA Reset - Essence Flux", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("sepC", "[Cast]", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("useQ", "Use - Mystic Shot", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("useW", "Use - Essence Flux", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("sep2", "-- Mixed Mode Options --", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("useQ2", "Use - Mystic Shot", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("useW2", "Use - Essence Flux", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("sep3", "-- Last Hit Options --", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("qFarm", "Farm - Mystic Shot", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("sep4", "-- Lane Clear Options --", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("qClear", "Farm - Mystic Shot", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("sep5", "-- Misc Options --", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("Cancelblitzgrabs", "Avoid - Blitzcrank Grab", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("ToggleMuramana", "Toggle - Muramana", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("sep6", "-- Drawing Options --", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("drawF", "Draw - Furthest Spell Available", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("drawQ", "Draw - Mystic Shot", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("drawW", "Draw - Essence Flux", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("drawE", "Draw - Arcane Shift", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("drawR", "Draw - Trueshot Barrage", SCRIPT_PARAM_ONOFF, true)
end
 
function Checks()
        QAble = (myHero:CanUseSpell(_Q) == READY)
        WAble = (myHero:CanUseSpell(_W) == READY)
        EAble = (myHero:CanUseSpell(_E) == READY)
        RAble = (myHero:CanUseSpell(_R) == READY)
        Target = AutoCarry.GetAttackTarget()
        Minion = AutoCarry.GetMinionTarget()
end
 
function MysticShot()
    if AutoCarry.PluginMenu.ranges.useVP then
      for i, target in pairs(GetEnemyHeroes()) do
      CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.251, 80, qRange, 2000, myHero)
        if IsSACReborn and QAble and AutoCarry.PluginMenu.useQ and not AutoCarry.Orbwalker:IsShooting() and HitChance >= AutoCarry.PluginMenu.ranges.HitChance and GetDistance(CastPosition) < AutoCarry.PluginMenu.ranges.qRanger then CastSpell(_Q, CastPosition.x, CastPosition.z)
        elseif QAble and AutoCarry.PluginMenu.useQ and HitChance >= AutoCarry.PluginMenu.ranges.HitChance and GetDistance(CastPosition) < AutoCarry.PluginMenu.ranges.qRanger then CastSpell(_Q, CastPosition.x, CastPosition.z) end
      end
    else
        if IsSACReborn and QAble and AutoCarry.PluginMenu.useQ and not AutoCarry.Orbwalker:IsShooting() then ProdictQ:GetPredictionCallBack(Target, CastQ)
        elseif QAble and AutoCarry.PluginMenu.useQ then ProdictQ:GetPredictionCallBack(Target, CastQ) end
    end
end    
 
function EssenceFlux()
    if AutoCarry.PluginMenu.ranges.useVP then
      for i, target in pairs(GetEnemyHeroes()) do
      CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.25, 90, wRange, 1600, myHero)
        if WAble and AutoCarry.PluginMenu.useW and not AutoCarry.PluginMenu.resetW and HitChance >= AutoCarry.PluginMenu.ranges.HitChance and GetDistance(CastPosition) < AutoCarry.PluginMenu.ranges.wRanger then CastSpell(_W, CastPosition.x, CastPosition.z) end
      end
    else
        if WAble and AutoCarry.PluginMenu.useW and not AutoCarry.PluginMenu.resetW then ProdictW:GetPredictionCallBack(Target, CastW) end
    end
end  

function EssenceFluxReset()
    if AutoCarry.PluginMenu.ranges.useVP then
      for i, target in pairs(GetEnemyHeroes()) do
      CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.25, 90, wRange, 1600, myHero)
        if IsSACReborn and WAble and AutoCarry.Orbwalker:IsAfterAttack() and AutoCarry.PluginMenu.useW and AutoCarry.PluginMenu.resetW and HitChance >= 2 and GetDistance(CastPosition) < AutoCarry.PluginMenu.ranges.wRanger then CastSpell(_W, CastPosition.x, CastPosition.z) end
      end
    else
        if IsSACReborn and WAble and AutoCarry.Orbwalker:IsAfterAttack() and AutoCarry.PluginMenu.useW and AutoCarry.PluginMenu.resetW then ProdictW:GetPredictionCallBack(Target, CastW) end
    end
end

function OnAttacked()
        if not IsSACReborn and WAble and AutoCarry.MainMenu.AutoCarry and AutoCarry.PluginMenu.useW and AutoCarry.PluginMenu.resetW then ProdictW:GetPredictionCallBack(Target, CastW) end
end

function MysticShot2()
    if AutoCarry.PluginMenu.ranges.useVP then
      for i, target in pairs(GetEnemyHeroes()) do
      CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.251, 80, qRange, 2000, myHero)
        if IsSACReborn and QAble and AutoCarry.PluginMenu.useQ2 and not AutoCarry.Orbwalker:IsShooting() and HitChance >= AutoCarry.PluginMenu.ranges.HitChance and GetDistance(CastPosition) < AutoCarry.PluginMenu.ranges.qRanger then CastSpell(_Q, CastPosition.x, CastPosition.z)
        elseif QAble and AutoCarry.PluginMenu.useQ2 and HitChance >= AutoCarry.PluginMenu.ranges.HitChance and GetDistance(CastPosition) < AutoCarry.PluginMenu.ranges.qRanger then CastSpell(_Q, CastPosition.x, CastPosition.z) end
      end
    else
        if IsSACReborn and QAble and AutoCarry.PluginMenu.useQ2 and not AutoCarry.Orbwalker:IsShooting() then ProdictQ:GetPredictionCallBack(Target, CastQ)
        elseif QAble and AutoCarry.PluginMenu.useQ2 then ProdictQ:GetPredictionCallBack(Target, CastQ) end
    end
end    
 
function EssenceFlux2()
    if AutoCarry.PluginMenu.ranges.useVP then
      for i, target in pairs(GetEnemyHeroes()) do
      CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 0.25, 90, wRange, 1600, myHero)
        if WAble and AutoCarry.PluginMenu.useW2 and not AutoCarry.PluginMenu.resetW and HitChance >= AutoCarry.PluginMenu.ranges.HitChance and GetDistance(CastPosition) < AutoCarry.PluginMenu.ranges.wRanger then CastSpell(_W, CastPosition.x, CastPosition.z) end
      end
    else
        if WAble and AutoCarry.PluginMenu.useW2 and not AutoCarry.PluginMenu.resetW then ProdictW:GetPredictionCallBack(Target, CastW) end
    end
end   

function TrueShotBarrage()
    if AutoCarry.PluginMenu.ranges.useVP then
      for i, target in pairs(GetEnemyHeroes()) do
      CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, 1, 150, rRange, 2000, myHero)
        if Target and RAble and HitChance >= AutoCarry.PluginMenu.ranges.HitChance and GetDistance(CastPosition) < AutoCarry.PluginMenu.ranges.rRanger then CastSpell(_R, CastPosition.x, CastPosition.z) end
      end
    else
        if Target and RAble then ProdictR:GetPredictionCallBack(Target, CastR) end
    end
end
 
local function getHitBoxRadius(target)
        return GetDistance(target, target.minBBox)
end
 
function CastQ(unit, pos, spell)
        if GetDistance(pos) - getHitBoxRadius(unit)/2 < AutoCarry.PluginMenu.ranges.qRanger then
                if AutoCarry.PluginMenu.ranges.ColSwap then
                local willCollide = ProdictQFastCol:GetMinionCollision(pos, myHero)
                if not willCollide then CastSpell(_Q, pos.x, pos.z) end
                else
                local willCollide = ProdictQCol:GetMinionCollision(pos, myHero)
                if not willCollide then CastSpell(_Q, pos.x, pos.z) end
                end
        end
end

function CastW(unit, pos, spell)
        if GetDistance(pos) - getHitBoxRadius(unit)/2 < AutoCarry.PluginMenu.ranges.wRanger then
          CastSpell(_W, pos.x, pos.z)
        end
end

function CastR(unit, pos, spell)
        if GetDistance(pos) - getHitBoxRadius(unit)/2 < AutoCarry.PluginMenu.ranges.rRanger then
          CastSpell(_R, pos.x, pos.z)
        end
end

function OnCreateObj(object)
		if object.name:find("FistGrab") then
			grabbed = true
			grab = object
		end
end

function OnDeleteObj(object)
	  if object.name:find("FistGrab") then
			 grabbed = false
			 grab = nil
  	end
end

function MuramanaToggle()
	if Target and Target.type == myHero.type and GetDistance(Target) <= qRange and not MuramanaIsActive() and (AutoCarry.MainMenu.AutoCarry or AutoCarry.MainMenu.MixedMode) then
		MuramanaOn()
	elseif not Target and MuramanaIsActive() then
		MuramanaOff()
	end
end

function RebornCheck()
	if AutoCarry.Skills then IsSACReborn = true else IsSACReborn = false end
	if AutoCarry.PluginMenu.ranges.ColSwap then
		require "FastCollision"
		ProdictQFastCol = FastCol(ProdictQ)
		PrintChat("<font color='#FFFF33'>>> Ezreal's Time to Strike: Fast Collision Loaded!</font>")
	else
		require "Collision"
		ProdictQCol = Collision(qRange, 2000, 0.251, 80)
		PrintChat("<font color='#FFFF33'>>> Ezreal's Time to Strike: Normal Collision Loaded!</font>") end
end

--UPDATEURL=
--HASH=9DA2F13AF4F0104C1F5D96F4EABAC5B6
