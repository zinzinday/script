if myHero.charName ~= "Ryze" then return end
if _G.UPLloaded then
	SP = UPL.SP
else
	require("SPrediction") 
	SP = SPrediction() 	
end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("VILKKOPQMLM") 

function OnLoad() 
	passiveTracker = 0 
	ForceTarget = nil 
	targetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, 900, DAMAGE_MAGICAL, false, true)
	Config = scriptConfig("Smashing Ryze", "SRyze") 
	Config:addParam("m", "Move to mouse", SCRIPT_PARAM_ONOFF, true)
	Config:addParam("k", "Combo (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, 32) 
	Config:addTS(targetSelector) 
end 

function OnTick() 
	targetSelector:update() 
	target = targetSelector.target 
	if Forcetarget ~= nil and ValidTarget(Forcetarget, 900) then 
		target = Forcetarget 
	end 
	if Config.k then 
		if GetDistance(mousePos) > myHero.boundingRadius and Config.m then 
			myHero:MoveTo(mousePos.x, mousePos.z) 
		end 
		if target and GetDistance(target) < 900 then 
			local x1, x2, x3 = SP:Predict(_Q, myHero, target) 
			if x2 and x2 >= 1 then CastSpell(_Q, x1.x, x1.z) end 
			local ready = 0 
			for _,k in pairs({_Q,_W,_E,_R}) do 
				if myHero:CanUseSpell(k) == READY then 
					ready = ready + 1 
				end  
			end 
			if passiveTracker >= 5 then 
				if myHero:GetSpellData(_W).currentCd > 0 and myHero:GetSpellData(_E).currentCd > 0 and myHero:GetSpellData(_R).currentCd > 0 then
					SP.SpellData[myHero.charName][_Q].collision = false
				elseif myHero:GetSpellData(_Q).currentCd > 0 and myHero:GetSpellData(_W).currentCd > 0 and myHero:GetSpellData(_R).currentCd > 0 then 
					CastSpell(_E, target) 
				elseif myHero:GetSpellData(_Q).currentCd > 0 and myHero:GetSpellData(_R).currentCd > 0 then
					CastSpell(_W, target) 
				elseif myHero:GetSpellData(_Q).currentCd > 0 then
					CastSpell(_R, target) 
				end 
			else 
				SP.SpellData[myHero.charName][_Q].collision = true
				CastSpell(_W, target) 
				CastSpell(_E, target) 
			end 
			if passiveTracker >= (6-ready) then 
				if passiveTracker >= 5 then
					if myHero:GetSpellData(_Q).currentCd > 0 and myHero:GetSpellData(_W).currentCd > 0 and myHero:GetSpellData(_E).currentCd > 0 then 
						CastSpell(_R)
					end
				else
					CastSpell(_R) 
				end
			end 
		end 
	end 
end 

function OnWndMsg(Msg, Key) if Msg == WM_LBUTTONDOWN then local minD = 0 local starget = nil for i, enemy in ipairs(GetEnemyHeroes()) do if ValidTarget(enemy) then if GetDistance(enemy, mousePos) <= minD or starget == nil then minD = GetDistance(enemy, mousePos) starget = enemy end end end if starget and minD < 500 then if Forcetarget and starget.charName == Forcetarget.charName then Forcetarget = nil else Forcetarget = starget print("<font color=\"#FF0000\">Smashing Ryze: New target selected: "..starget.charName.."</font>") end end end end 

function OnApplyBuff(unit, buff) 
	if unit == nil or buff == nil then return end 
	if buff.name == "ryzepassivestack" then passiveTracker = 1 end 
	if buff.name == "ryzepassivecharged" then passiveTracker = 5 end 
end 

function OnUpdateBuff(unit, buff, stacks) 
	if unit == nil or buff == nil then return end 
	if buff.name == "ryzepassivestack" then passiveTracker = stacks end 
	if buff.name == "ryzepassivecharged" then passiveTracker = 5 end 
end 

function OnRemoveBuff(unit, buff) 
	if unit == nil or buff == nil then return end 
	if buff.name == "ryzepassivestack" then passiveTracker = 0 end 
	if buff.name == "ryzepassivecharged" then passiveTracker = 0 end 
end
print("<font color=\"#FF0000\">Smashing Ryze Script Activated.</font>")