------#################################################################################------  ------###########################      Stylish Taric       ############################------ ------###########################         by Toy           ############################------ ------#################################################################################------

--> Version: 1.0

--> Features:
--> Cast options for Q(With a option to only use betwen auto-attacks to make best use of the passive, must be enabled in the menu if you wanna use this), W, E and R(Also with option to use betwen auto-attacks) in both, autocarry and mixed mode (works separately).
--> Hotkey to turn on/off the use of Radiance (R) in the combo.
--> Option to KS with Radiance, disabled by default.
--> Adjustable range for W and R by a slider, so you can pick how close you have to be from the enemy to use they, also an separated slider only for mixed mode, the drawings apply your choosen range.
--> Drawing options for Q, W, E and R.

if myHero.charName ~= "Taric" then return end
 
local qRange = 750
local wRange = 300
local eRange = 625
local rRange = 200
 
local QAble, WAble, Eable, RAble = false, false, false, false
 
function PluginOnLoad()
        AutoCarry.SkillsCrosshair.range = 625
        Menu()
end

function KS()
	for i, enemy in ipairs(GetEnemyHeroes()) do
	local rDmg = getDmg("R", enemy, myHero)
		if Target and not Target.dead and Target.health < rDmg and GetDistance(Target) < rRange then
			CastSpell(_R)
		end
	end
end
 
function PluginOnTick()
    Checks()
    if Target then
      if Target and (AutoCarry.MainMenu.AutoCarry) then
        Shatter()
        Dazzle()
        Radiance()
      end
      if Target and (AutoCarry.MainMenu.MixedMode) then
        Shatter2()
        Dazzle2()
      end
      if AutoCarry.PluginMenu.KS and RAble then KS()
      end
    end
end
 
function PluginOnDraw()
    if not myHero.dead then
	  if QAble and AutoCarry.PluginMenu.drawQ then
      DrawCircle(myHero.x, myHero.y, myHero.z, qRange, 0x00FF00)
		  end
	  if WAble and AutoCarry.PluginMenu.drawW then
      DrawCircle(myHero.x, myHero.y, myHero.z, AutoCarry.PluginMenu.wRanger, 0x9933FF)
		  end
      if EAble and AutoCarry.PluginMenu.drawE then
      DrawCircle(myHero.x, myHero.y, myHero.z, eRange, 0xFF0000)
		  end
      if RAble and AutoCarry.PluginMenu.drawR then
      DrawCircle(myHero.x, myHero.y, myHero.z, AutoCarry.PluginMenu.rRanger, 0x9933FF)
	    end
   end
end

 function Menu()
  local HKR = string.byte("T")
  AutoCarry.PluginMenu:addParam("sep", "-- Misc Options --", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("KS", "KS - Radiance", SCRIPT_PARAM_ONOFF, false)
  AutoCarry.PluginMenu:addParam("sep1", "-- Autocarry Options --", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("wRanger", "Range - Shatter", SCRIPT_PARAM_SLICE, 300, 125, 300, 0)
  AutoCarry.PluginMenu:addParam("rRanger", "Range - Radiance", SCRIPT_PARAM_SLICE, 200, 125, 300, 0)
  AutoCarry.PluginMenu:addParam("sep2", "[Cast]", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("useW", "Use - Shatter", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("useWre", " [W - After Auto-Attack]", SCRIPT_PARAM_ONOFF, false)
  AutoCarry.PluginMenu:addParam("useE", "Use - Dazzle", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("useR", "Use - Radiance", SCRIPT_PARAM_ONKEYTOGGLE, false, HKR)
  AutoCarry.PluginMenu:addParam("useRre", " [R - After Auto-Attack]", SCRIPT_PARAM_ONOFF, false)
  AutoCarry.PluginMenu:addParam("sep3", "-- Mixed Mode Options --", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("wRanger2", "Range - Shatter", SCRIPT_PARAM_SLICE, 300, 125, 300, 0)
  AutoCarry.PluginMenu:addParam("sep4", "[Cast]", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("useW2", "Use - Shatter", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("useW2re", " [W - After Auto-Attack]", SCRIPT_PARAM_ONOFF, false)
  AutoCarry.PluginMenu:addParam("useE2", "Use - Dazzle", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("sep5", "-- Drawing Options --", SCRIPT_PARAM_INFO, "")
  AutoCarry.PluginMenu:addParam("drawQ", "Draw - Imbue", SCRIPT_PARAM_ONOFF, false)
  AutoCarry.PluginMenu:addParam("drawW", "Draw - Shatter", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("drawE", "Draw - Dazzle", SCRIPT_PARAM_ONOFF, true)
  AutoCarry.PluginMenu:addParam("drawR", "Draw - Radiance", SCRIPT_PARAM_ONOFF, true)
end
 
function Checks()
        QAble = (myHero:CanUseSpell(_Q) == READY)
        WAble = (myHero:CanUseSpell(_W) == READY)
        EAble = (myHero:CanUseSpell(_E) == READY)
        RAble = (myHero:CanUseSpell(_R) == READY)
        Target = AutoCarry.GetAttackTarget()
end
 
function OnAttacked()
        if WAble and (AutoCarry.MainMenu.AutoCarry) and AutoCarry.PluginMenu.useW and AutoCarry.PluginMenu.useWre then CastSpell(_W) end
        if RAble and (AutoCarry.MainMenu.AutoCarry) and AutoCarry.PluginMenu.useR and AutoCarry.PluginMenu.useRre then CastSpell(_W) end
        if WAble and (AutoCarry.MainMenu.MixedMode) and Target and GetDistance(Target) <= AutoCarry.PluginMenu.wRanger and AutoCarry.PluginMenu.useW2 and AutoCarry.PluginMenu.useW2re then CastSpell(_W) end
end

function Shatter()
        if WAble and AutoCarry.PluginMenu.useW and not AutoCarry.PluginMenu.useWre and GetDistance(Target) < AutoCarry.PluginMenu.wRanger then CastSpell(_W) end
end
 
function Dazzle()
        if EAble and AutoCarry.PluginMenu.useE and GetDistance(Target) <= eRange then CastSpell(_E, Target) end
end

function Shatter2()
        if WAble and AutoCarry.PluginMenu.useW2 and not AutoCarry.PluginMenu.useW2re and GetDistance(Target) < AutoCarry.PluginMenu.wRanger2 then CastSpell(_W) end
end
 
function Dazzle2()
        if EAble and AutoCarry.PluginMenu.useE and GetDistance(Target) <= eRange then CastSpell(_E, Target) end
end

function Radiance()
        if RAble and AutoCarry.PluginMenu.useR and not AutoCarry.PluginMenu.useRre and GetDistance(Target) < AutoCarry.PluginMenu.rRanger then CastSpell(_R) end
end