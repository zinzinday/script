if myHero.charName ~= "Katarina" then return end

-- Scriptstatus tracker
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("TGJIJKMMOLI") 
-- Scriptstatus tracker

function OnLoad() 
	ForceTarget = nil lastAttack = 0 previousAttackCooldown = 0 previousWindUp = 0 ultOn = 0 
	targetSelector = TargetSelector(TARGET_LESS_CAST, 700, DAMAGE_MAGICAL, false, true) 
	cfg = scriptConfig("Definitely Katarina", "DKatarina") 
	cfg:addParam("k", "Combo (HOLD)", SCRIPT_PARAM_ONKEYDOWN, false, 32) 
end 

function OnTick() 
	targetSelector:update() 
	target = targetSelector.target 
	if Forcetarget ~= nil and ValidTarget(Forcetarget, 900) then 
		target = Forcetarget 
	end 
		if cfg.k then 
		if GetDistance(mousePos) > myHero.boundingRadius and heroCanMove() and not (target and GetDistance(target) < myHero.range+myHero.boundingRadius+target.boundingRadius-25) then 
			myHero:MoveTo(mousePos.x, mousePos.z) 
		end 
			if timeToShoot() and target then for _,k in pairs({_Q,_E}) do CastSpell(k, target) 
			end 
			if GetDistance(target) < 375 then CastSpell(_W) 
			end
		end 
			if target and GetDistance(target) < 350 then CastSpell(_R) 
				end 
			if target and GetDistance(target) < myHero.range+myHero.boundingRadius+target.boundingRadius+25 and timeToShoot() and not ultOn then 
				myHero:Attack(target) 
			end 
	end 				
end 

function ProcessSpell(unit, spell) 
	if unit and unit.isMe and spell then lastAttack = GetTickCount() - GetLatency()/2 previousWindUp = spell.windUpTime*1000 previousAttackCooldown = spell.animationTime*1000 
		if spell.name:lower():find("katarinar") then 
		ultOn = GetInGameTimer()+2.5 
		end 
	end 
end

function timeToShoot() 
	return (GetTickCount() + GetLatency()/2 > lastAttack + previousAttackCooldown) and (ultOn < GetInGameTimer() or target.dead) 
end 

function heroCanMove() 
	return (GetTickCount() + GetLatency()/2 > lastAttack + previousWindUp + 50) and (ultOn < GetInGameTimer() or target.dead) 
end 

function OnWndMsg(Msg, Key) 
	if Msg == WM_LBUTTONDOWN then 
		local minD = 0 
		local starget = nil 
		for i, enemy in ipairs(GetEnemyHeroes()) do 
			if ValidTarget(enemy) then 
				if GetDistance(enemy, mousePos) <= minD or starget == nil then minD = GetDistance(enemy, mousePos) starget = enemy 
				end 
			end 
		end 
		if starget and minD < 500 then 
			if Forcetarget and starget.charName == Forcetarget.charName then 
				Forcetarget = nil 
			else 
				Forcetarget = starget 
				print("<font color=\"#FF0000\">Definitely Katarina: New target selected: "..starget.charName.."</font>") 
			end 
		end 
	end
end
print("<font color=\"#FF0000\">Definitely Katarina Script Activated.</font>")