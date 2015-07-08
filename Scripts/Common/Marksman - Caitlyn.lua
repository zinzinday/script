if myHero.charName ~= 'Caitlyn' then return end

assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("OBEDAAGHEEJ") 

--Changelog 1.0 Release
--Changelog 1.1 Added Auto E Gapclosers
--              Cleaned code  
--Changelog 1.2 added w ON ESCAPE vs gapclosers               
--              added e to mouse 
--Changelog 1.3 Draws HP Bar Q+E+R  
--              Added fast eq with logic in misc
--Changelog 1.4 Added logic for Q in farm
--Changelog 1.5 Fixed Target lock with SxOrb
--Changelog 1.6 Added HPred and 
--Changelog 1.7 now released open source
  

require "SxOrbWalk"
require "VPrediction"
require "HPrediction"


local Q = {range = 1250, delay = 0.65, speed = 2225, width = 80,IsReady = function() return myHero:CanUseSpell(_Q) == READY end}
local W = {range = 800, delay = 0.25, speed = 1200, width = 67,IsReady = function() return myHero:CanUseSpell(_W) == READY end}
local E = {range = 950, delay = 0.25, speed = 1800, width = 100,IsReady = function() return myHero:CanUseSpell(_E) == READY end}
local R = {range = math.huge,IsReady = function() return myHero:CanUseSpell(_R) == READY end}
local ignite = nil
local iDmg = 0
local informationTable = {}
local spellExpired = true
local HPred = HPrediction()
local ts
local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 2000, DAMAGE_PHYSICAL, true)
local myTarget = nil
local Killable = false


local immuneEffects = {
	{'zhonyas_ring_activate.troy', 2.5},
	{'Aatrox_Passive_Death_Activate.troy', 3},
	{'LifeAura.troy', 4},
	{'nickoftime_tar.troy', 7},
	{'eyeforaneye_self.troy', 2},
	{'UndyingRage_buf.troy', 5},
	{'EggTimer.troy', 6},
}
local ToInterrupt = {}
local InterruptList = {
    { charName = "Caitlyn", spellName = "CaitlynAceintheHole"},
    { charName = "FiddleSticks", spellName = "Crowstorm"},
    { charName = "FiddleSticks", spellName = "DrainChannel"},
    { charName = "Galio", spellName = "GalioIdolOfDurand"},
    { charName = "Karthus", spellName = "FallenOne"},
    { charName = "Katarina", spellName = "KatarinaR"},
    { charName = "Lucian", spellName = "LucianR"},
    { charName = "Malzahar", spellName = "AlZaharNetherGrasp"},
    { charName = "MissFortune", spellName = "MissFortuneBulletTime"},
    { charName = "Nunu", spellName = "AbsoluteZero"},                            
    { charName = "Pantheon", spellName = "Pantheon_GrandSkyfall_Jump"},
    { charName = "Shen", spellName = "ShenStandUnited"},
    { charName = "Urgot", spellName = "UrgotSwap2"},
    { charName = "Varus", spellName = "VarusQ"},
	{ charName = "Warwick", spellName = "InfiniteDuress"},
	{ charName = "Velkoz", spellName = "VelkozR"}
}



TextList = {"Poke", " Killable Ult!"}
KillText = {}
colorText = ARGB(255,255,204,0)


function GetCustomTarget()
	ts:update()
	if _G.AutoCarry and ValidTarget(_G.AutoCarry.Crosshair:GetTarget()) then return _G.AutoCarry.Crosshair:GetTarget() end
	if not _G.Reborn_Loaded then return ts.target end
	return ts.target
end

function OnLoad()
	PrintChat("<font color=\"#00FF00\">Caitlyn by Fukdapolice.</font>")
	
	HPred:AddSpell("Q", 'Caitlyn', {collisionM = false, collisionH = false, delay = 0.65, range = 1250, speed = 2225, type = "DelayLine", width = 40, IsVeryLowAccuracy = true})
	
	immuneTable = {}
	checkDistance = 3000 * 3000
	IgniteCheck()
	FLoadLib()
	VP = VPrediction(true)   
    _G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
	if myHero:GetSpellData(_R).level == 3 then R.Range = R.Ranget[3] end
	Minions = minionManager(MINION_ENEMY, Q.range, myHero, MINION_SORT_MAXHEALTH_ASC)
	JungleMinions = minionManager(MINION_JUNGLE, Q.range, myHero, MINION_SORT_MAXHEALTH_DEC)
end

function OnTick()
	target = GetCustomTarget()
	Checks()
	
	
	ClearImmuneTable()   
end

function OnDraw()
	if HazMenu.Draw.drawq then
		DrawCircle(myHero.x,myHero.y,myHero.z,1250,0xFFFF0000)
	end 			
	if HazMenu.Draw.draww then
		DrawCircle(myHero.x,myHero.y,myHero.z,800,0xFFFF0000)
	end
	if HazMenu.Draw.drawe then
		DrawCircle(myHero.x,myHero.y,myHero.z,950,0xFFFF0000)
	end
	
	if  HazMenu.Draw.drawHP then
			for i, enemy in ipairs(GetEnemyHeroes()) do
       			if ValidTarget(enemy) then
			       DrawIndicator(enemy)
			    end
	        end
	end		
	
	if HazMenu.Misc.killtext then
		for i = 1, heroManager.iCount do
			local target = heroManager:GetHero(i)
			if ValidTarget(target) and target ~= nil then
				local barPos = WorldToScreen(D3DXVECTOR3(target.x, target.y, target.z))
				local PosX = barPos.x - 35
				local PosY = barPos.y - 10
				
				DrawText(TextList[KillText[i]], 16, PosX, PosY, colorText)
			end
		end
	end
    for networkID, time in pairs(immuneTable) do
		local unit = objManager:GetObjectByNetworkId(networkID)
		if unit and unit.valid and not unit.dead and GetDistanceSqr(myHero, unit) <= checkDistance then
			DrawText3D(tostring(math.round(time - os.clock())), unit.x, unit.y, unit.z, 70, RGB(255, 255, 255), true)
		end
	end
end


function Checks()
	IREADY = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	QREADY = (myHero:CanUseSpell(_Q) == READY)
	WREADY = (myHero:CanUseSpell(_W) == READY)
	EREADY = (myHero:CanUseSpell(_E) == READY)
	RREADY = (myHero:CanUseSpell(_R) == READY)
	calcDmg()
	LFCfunc()
	SpellExpired()
	
	if ValidTarget(target) then
		if HazMenu.Misc.KS then KS(target) end
		if HazMenu.Misc.Ignite then AutoIgnite(target) end
	    if HazMenu.Combo.comboR then KS(target) end
	   
	end
		
	
	if HazMenu.combokey then
		Combo()
    end
	
   if HazMenu.harasskey and myHero.mana / myHero.maxMana > HazMenu.Harass.Mana /100 then
		Poke()
   end
   if HazMenu.farmkey and myHero.mana / myHero.maxMana > HazMenu.Farm.Mana /100 then
		Farm()
   end
    if HazMenu.moveto and HazMenu.Misc.Emouse then 
	   moveto(mousePos.x,mousePos.z)
	end   
    if HazMenu.fastqe and HazMenu.Misc.QEorEQ then
	 fastqe()
	 elseif HazMenu.fastqe and not HazMenu.Misc.QEorEQ then
	    fasteq()
    end
	
end

function IgniteCheck()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
		ignite = SUMMONER_2
	end
end

function FLoadLib()
	FMenu()
end

function FMenu()
	HazMenu = scriptConfig("Caitlyn", "Caitlyn")
		HazMenu:addParam("combokey", "Combo key(Space)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		HazMenu:addParam("harasskey", "Harass key(C)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		HazMenu:addParam("farmkey", "Farm key(V)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	    HazMenu:addParam("moveto", "E to Mouse(Z)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("Z"))
	    HazMenu:addParam("fastqe", "Fast Q E anim.canc.(X)", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	
	HazMenu:addTS(ts)
		
	HazMenu:addSubMenu("Combo", "Combo")
		HazMenu.Combo:addParam("comboQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		HazMenu.Combo:addParam("comboW", "Use W", SCRIPT_PARAM_ONOFF, true)
		HazMenu.Combo:addParam("comboE", "Use E", SCRIPT_PARAM_ONOFF, true)
		HazMenu.Combo:addParam("comboR", "Use R", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("R"))
        
		
	HazMenu:addSubMenu("Harass", "Harass")
		HazMenu.Harass:addParam("harassQ", "Use Q", SCRIPT_PARAM_ONOFF, true)		
		HazMenu.Harass:addParam("harassE", "Use E", SCRIPT_PARAM_ONOFF, true)
	    HazMenu.Harass:addParam("Mana", "Mana Manager %", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
	
    HazMenu:addSubMenu("Farm", "Farm")
	    HazMenu.Farm:addParam("farmQ", "Use Q", SCRIPT_PARAM_ONOFF, true)
		HazMenu.Farm:addParam("farmE", "Use E", SCRIPT_PARAM_ONOFF, true)
	    HazMenu.Farm:addParam("Mana", "Mana Manager %", SCRIPT_PARAM_SLICE, 50, 1, 100, 0)
	
	HazMenu:addSubMenu("Misc", "Misc")
		HazMenu.Misc:addParam("KS", "KillSteal with Q", SCRIPT_PARAM_ONOFF, true)
		HazMenu.Misc:addParam("Ignite", "Use Auto Ignite", SCRIPT_PARAM_ONOFF, true)
	    HazMenu.Misc:addParam("killtext", "Draw if Killable with combo", SCRIPT_PARAM_ONOFF, true)
		HazMenu.Misc:addParam("Emouse", "E to Mouse", SCRIPT_PARAM_ONOFF, false)
		HazMenu.Misc:addParam("QEorEQ", "ON QE / Off EQ", SCRIPT_PARAM_ONOFF, true)
		HazMenu.Misc:addParam("Pred", "Use HPred", SCRIPT_PARAM_ONOFF, true)
		
	HazMenu:addSubMenu("Draw","Draw")
	  HazMenu.Draw:addParam("drawq", "Draw Q", SCRIPT_PARAM_ONOFF, true)
	  HazMenu.Draw:addParam("draww", "Draw W", SCRIPT_PARAM_ONOFF, true)
	  HazMenu.Draw:addParam("drawe", "Draw E", SCRIPT_PARAM_ONOFF, true)
	  HazMenu.Draw:addParam("drawHP", "Draw Dmg on HPBar", SCRIPT_PARAM_ONOFF, true)
	  
	  
	HazMenu:addParam("AGP", "Auto E gapclosers", SCRIPT_PARAM_ONOFF, true)
	HazMenu:addParam("useW", "Auto W gapclosers", SCRIPT_PARAM_ONOFF, true)
	HazMenu:addParam("Interrupt", "interrupt with W", SCRIPT_PARAM_ONOFF, true)
	
	
	HazMenu:addSubMenu("LagFreeCircles", "LFC")
	  HazMenu.LFC:addParam("LagFree", "Activate Lag Free Circles", SCRIPT_PARAM_ONOFF, false)
	  HazMenu.LFC:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 350, 75, 2000, 0)
	  HazMenu.LFC:addParam("CLinfo", "Higher length = Lower FPS Drops", SCRIPT_PARAM_INFO, "")
	
	for i = 1, heroManager.iCount, 1 do
		local enemy = heroManager:getHero(i)
		if enemy.team ~= myHero.team then
			for _, champ in pairs(InterruptList) do
				if enemy.charName == champ.charName then
					table.insert(ToInterrupt, champ.spellName)
				end
			end
		end
	end
	
	if _G.Reborn_Loaded then
	DelayAction(function()
		PrintChat("<font color = \"#FFFFFF\">[Caitlyn] </font><font color = \"#FF0000\">SAC Status:</font> <font color = \"#FFFFFF\">Successfully integrated.</font> </font>")
		HazMenu:addParam("SACON","[Caitlyn] SAC:R support is active.", 5, "")
		isSAC = true
	end, 10)
	elseif not _G.Reborn_Loaded then
		PrintChat("<font color = \"#FFFFFF\">[Caitlyn] </font><font color = \"#FF0000\">Orbwalker not found:</font> <font color = \"#FFFFFF\">SxOrbWalk integrated.</font> </font>")
		HazMenu:addSubMenu("Orbwalker", "SxOrb")
		SxOrb:LoadToMenu(HazMenu.SxOrb)
		isSX = true
	end
	HazMenu:permaShow("combokey")
	HazMenu:permaShow("harasskey")
	HazMenu:permaShow("farmkey")
end



function KS(enemy)  
	if Q.IsReady() and getDmg("Q", enemy, myHero) > enemy.health then
		if GetDistance(enemy) <= Q.range and HazMenu.Misc.KS then 
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, Q.delay, Q.width, Q.range, Q.speed, myHero, false)
			if HitChance >= 2 and GetDistance(CastPosition) <= Q.range and GetDistance(CastPosition) >= 700 and Q.IsReady() then
				CastSpell(_Q, CastPosition.x, CastPosition.z)
		    end
		end
	end
    if R.IsReady() and getDmg("R", enemy, myHero) > enemy.health then
	    if GetDistance(enemy) <= R.range and GetDistance(enemy) > 900 and HazMenu.Combo.comboR then
		  CastSpell(_R, enemy)
		end
	end	
end

function AutoIgnite(enemy)
  	iDmg = ((IREADY and getDmg("IGNITE", enemy, myHero)) or 0) 
	if enemy.health <= iDmg and GetDistance(enemy) <= 600 and ignite ~= nil
		then
			if IREADY then CastSpell(ignite, enemy) end
	end
end


--Big TNX to Manciuzz for this part


function OnProcessSpell(unit, spell)
	if HazMenu.Interrupt and W.IsReady() and #ToInterrupt > 0 then
		for _, ability in pairs(ToInterrupt) do
			if spell.name == ability and unit.team ~= myHero.team then
				if GetDistance(unit) <= 800 then CastSpell(_W, unit.x, unit.z) end
			end
		end
	end
	if HazMenu.AGP and E.IsReady() then
	        local jarvanAddition = unit.charName == "JarvanIV" and unit:CanUseSpell(_Q) ~= READY and _R or _Q
			local isAGapcloserUnit = {
				['Aatrox']      = {true, spell = _Q,                  range = 1000,  projSpeed = 1200, },
				['Akali']       = {true, spell = _R,                  range = 800,   projSpeed = 2200, }, 
				['Alistar']     = {true, spell = _W,                  range = 650,   projSpeed = 2000, }, 
				['Diana']       = {true, spell = _R,                  range = 825,   projSpeed = 2000, }, 
				['Gragas']      = {true, spell = _E,                  range = 600,   projSpeed = 2000, },
				['Hecarim']     = {true, spell = _R,                  range = 1000,  projSpeed = 1200, },
				['Irelia']      = {true, spell = _Q,                  range = 650,   projSpeed = 2200, }, 
				['JarvanIV']    = {true, spell = jarvanAddition,      range = 770,   projSpeed = 2000, }, 
				['Jax']         = {true, spell = _Q,                  range = 700,   projSpeed = 2000, }, 
				['Jayce']       = {true, spell = 'JayceToTheSkies',   range = 600,   projSpeed = 2000, }, 
				['Khazix']      = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
				['Leblanc']     = {true, spell = _W,                  range = 600,   projSpeed = 2000, },
				['LeeSin']      = {true, spell = 'blindmonkqtwo',     range = 1300,  projSpeed = 1800, },
				['Leona']       = {true, spell = _E,                  range = 900,   projSpeed = 2000, },
				['Malphite']    = {true, spell = _R,                  range = 1000,  projSpeed = 1500 + unit.ms},
				['Maokai']      = {true, spell = _Q,                  range = 600,   projSpeed = 1200, }, 
				['MonkeyKing']  = {true, spell = _E,                  range = 650,   projSpeed = 2200, }, 
				['Pantheon']    = {true, spell = _W,                  range = 600,   projSpeed = 2000, }, 
				['Poppy']       = {true, spell = _E,                  range = 525,   projSpeed = 2000, }, 
				['Renekton']    = {true, spell = _E,                  range = 450,   projSpeed = 2000, },
				['Sejuani']     = {true, spell = _Q,                  range = 650,   projSpeed = 2000, },
				['Shen']        = {true, spell = _E,                  range = 575,   projSpeed = 2000, },
				['Tristana']    = {true, spell = _W,                  range = 900,   projSpeed = 2000, },
				['Tryndamere']  = {true, spell = 'Slash',             range = 650,   projSpeed = 1450, },
				['XinZhao']     = {true, spell = _E,                  range = 650,   projSpeed = 2000, }, 
			}
			if unit.type == myHero.type and unit.team ~= myHero.team and isAGapcloserUnit[unit.charName] and GetDistance(unit) < 2000 and spell ~= nil then
				if spell.name == (type(isAGapcloserUnit[unit.charName].spell) == 'number' and unit:GetSpellData(isAGapcloserUnit[unit.charName].spell).name or isAGapcloserUnit[unit.charName].spell) then
					if spell.target ~= nil and spell.target.isMe or isAGapcloserUnit[unit.charName].spell == 'blindmonkqtwo' then
						if E.IsReady() then
							E.target = unit
							CastSpell(_E, unit.x, unit.z)
						end
					else
						spellExpired = false
						informationTable = {
							spellSource = unit,
							spellCastedTick = GetTickCount(),
							spellStartPos = Point(spell.startPos.x, spell.startPos.z),
							spellEndPos = Point(spell.endPos.x, spell.endPos.z),
							spellRange = isAGapcloserUnit[unit.charName].range,
							spellSpeed = isAGapcloserUnit[unit.charName].projSpeed
						}
					end
				end
			end
		
    end
end			



function SpellExpired()
    if ValidTarget(target) then
	if HazMenu.AGP and not spellExpired and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange / informationTable.spellSpeed) * 1000 then
		local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
		local spellStartPosition = informationTable.spellStartPos + spellDirection
		local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
		local heroPosition = Point(myHero.x, myHero.z)
		local lineSegment = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
	
			local lineSegment = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
			

			if lineSegment:distance(heroPosition) <= 300 and E.IsReady() then
				
				CastSpell(_E, target.x, target.z)
			end

		else
			spellExpired = true
			informationTable = {}
		end
        if W.IsReady() and HazMenu.useW then  
            if HazMenu.AGP and not spellExpired and (GetTickCount() - informationTable.spellCastedTick) <= (informationTable.spellRange / informationTable.spellSpeed) * 1000 then
		local spellDirection     = (informationTable.spellEndPos - informationTable.spellStartPos):normalized()
		local spellStartPosition = informationTable.spellStartPos + spellDirection
		local spellEndPosition   = informationTable.spellStartPos + spellDirection * informationTable.spellRange
		local heroPosition = Point(myHero.x, myHero.z)
		local lineSegment = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
	
			local lineSegment = LineSegment(Point(spellStartPosition.x, spellStartPosition.y), Point(spellEndPosition.x, spellEndPosition.y))
			

			if lineSegment:distance(heroPosition) <= 400 then
				   CastSpell(_W,myHero.x,myHero.z)
            end
			

		else
			spellExpired = true
			informationTable = {}
		end
               
               
        end
    end
end

function fasteq()
    	if ValidTarget(target) and not HazMenu.Misc.QEorEQ then 
		
		if E.IsReady() and HazMenu.fastqe and Q.IsReady() then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, E.delay, E.width, E.range, E.speed, myHero, false)
			if HitChance >= 2 and GetDistance(CastPosition) <= W.range and E.IsReady() then
				--if HazMenu.Misc.Pak and VIP_USER then
				   
					--else
				    CastSpell(_E, CastPosition.x, CastPosition.z)
				--end
			end
		end
	    if Q.IsReady() and HazMenu.fastqe then
		    local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, Q.delay, Q.width, Q.range, Q.speed, myHero, false)
			if HitChance >= 2 and GetDistance(CastPosition) <= Q.range and Q.IsReady() then
				 --if HazMenu.Misc.Pak and VIP_USER then
				     
					--else
				    CastSpell(_Q, CastPosition.x, CastPosition.z)
				--end
			end
		end
	end
end


function fastqe()
    	if ValidTarget(target) and HazMenu.Misc.QEorEQ then 
		if Q.IsReady() and HazMenu.fastqe and E.IsReady() then
		    local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, Q.delay, Q.width, Q.range, Q.speed, myHero, false)
			if HitChance >= 2 and GetDistance(CastPosition) <= 950 and Q.IsReady() then
				 --if HazMenu.Misc.Pak and VIP_USER then
				     
					--else
				    CastSpell(_Q, CastPosition.x, CastPosition.z)
				--end
			end
		end
		if E.IsReady() and HazMenu.fastqe then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, E.delay, E.width, E.range, E.speed, myHero, false)
			if HitChance >= 2 and GetDistance(CastPosition) <= E.range and E.IsReady() then
				--if HazMenu.Misc.Pak and VIP_USER then
				    
					--else
				    CastSpell(_E, CastPosition.x, CastPosition.z)
				--end
			end
		end
	    
	end
end

function Combo()
	if ValidTarget(target) then
        	if W.IsReady() and HazMenu.Combo.comboW and HazMenu.useW then			 
			local AOECastPosition, MainTargetHitChance, nTargets = VP:GetCircularAOECastPosition(target, W.delay, W.width, W.range, W.speed, myHero, false)
			if MainTargetHitChance >= 3 and GetDistance(AOECastPosition) <= W.range and W.IsReady() then
				CastSpell(_W, AOECastPosition.x, AOECastPosition.z)
			end
			
		end		
        if E.IsReady() and HazMenu.Combo.comboE then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, E.delay, E.width, E.range, E.speed, myHero, true)
			if HitChance >= 2 and GetDistance(CastPosition) <= E.range and E.IsReady() then
				--if HazMenu.Misc.Pak and VIP_USER then
				    
					--else
				    CastSpell(_E, CastPosition.x, CastPosition.z)
				--end	
			end
		end
	    
        if Q.IsReady() and HazMenu.Combo.comboQ then
		    if HazMenu.Misc.Pred and GetDistance(myHero, target) > 60 then					  
					    HPredQ()
	    elseif not HazMenu.Misc.Pred then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, Q.delay, Q.width, Q.range, Q.speed, myHero, false)
			if HitChance >= 2 and GetDistance(CastPosition) <= Q.range and GetDistance(CastPosition) >= 660 and Q.IsReady() then
				 --if HazMenu.Misc.Pak and VIP_USER then
				     
					--else
				     CastSpell(_Q, CastPosition.x, CastPosition.z)
				--end	 
			end
			end
		end				
	end
end


                    


function Poke()
	if ValidTarget(target) then 
		if Q.IsReady() and HazMenu.Harass.harassQ then
		    if HazMenu.Misc.Pred and GetDistance(myHero, target) > 640 then					  
					    HPredQ()
	    elseif not HazMenu.Misc.Pred then
		    local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, Q.delay, Q.width, Q.range, Q.speed, myHero, false)
			if HitChance >= 2 and GetDistance(CastPosition) <= Q.range and GetDistance(CastPosition) >= 640 and Q.IsReady() then
				 --if HazMenu.Misc.Pak and VIP_USER then
				     --packetCast(_Q, CastPosition.x, CastPosition.z)
					--else
				    CastSpell(_Q, CastPosition.x, CastPosition.z)
				--end
		    end
		end
		end
		if E.IsReady() and HazMenu.Harass.harassE then
			local CastPosition, HitChance, CastPos = VP:GetLineCastPosition(target, E.delay, E.width, E.range, E.speed, myHero, true)
			if HitChance >= 2 and GetDistance(CastPosition) <= E.range and E.IsReady() then
				--if HazMenu.Misc.Pak and VIP_USER then
				    --packetCast(_E, CastPosition.x, CastPosition.z)
					--else
				    CastSpell(_E, CastPosition.x, CastPosition.z)
				--end
			end
		end
	end
end

function Farm()
	Minions:update()
	
	for i, Minion in pairs(Minions.objects) do
		if Q.IsReady() and HazMenu.Farm.farmQ and #Minions.objects > 2 then
		   if myHero.mana / myHero.maxMana > HazMenu.Farm.Mana /100 then
		   if ValidTarget(Minion) and GetDistance(myHero, Minion) > 400 then
		   local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(Minion, Q.delay, Q.width, 750, Q.speed, myHero)
			if nTargets >= 1 and Q.IsReady() then
			 CastSpell(_Q, AOECastPosition.x, AOECastPosition.z)
			 end
   		end
		end
	 end
	 end
    JungleMinions:update()
	for i, Minion in pairs(JungleMinions.objects) do
	    if  Q.IsReady() and HazMenu.Farm.farmQ then
			CastSpell(_Q, Minion.x, Minion.z)
   		end
	    if  E.IsReady() and HazMenu.Farm.farmE then
			CastSpell(_E, Minion.x, Minion.z)
   		end
    end
end

function moveto()
    if E.IsReady() and HazMenu.moveto and HazMenu.Misc.Emouse then 
	  MPos = Vector(mousePos.x, mousePos.y, mousePos.z)
        HeroPos = Vector(myHero.x, myHero.y, myHero.z)
        DashPos = HeroPos + ( HeroPos - MPos )*(500/GetDistance(mousePos))
        myHero:MoveTo(mousePos.x, mousePos.z)
        CastSpell(_E,DashPos.x, DashPos.z)
        myHero:MoveTo(mousePos.x, mousePos.z)
    end
end


       



function HPredQ(unit)
    local unit = target
	local QPos, QHitChance = HPred:GetPredict("Q", unit, myHero)
	if QHitChance >= 1 then
		CastSpell(_Q, QPos.x, QPos.z)
	end
    
end


function calcDmg()
	for i=1, heroManager.iCount do
		local Target = heroManager:GetHero(i)
		if ValidTarget(Target) and Target ~= nil then
			qDmg = ((QREADY and getDmg("Q", Target, myHero)) or 0)
			wDmg = ((WREADY and getDmg("W", Target, myHero)) or 0)
			eDmg = ((EREADY and getDmg("E", Target, myHero)) or 0)
			rDmg = ((RREADY and getDmg("R", Target, myHero)) or 0)
			allDmg = (rDmg)
			
			if Target.health > allDmg then
				KillText[i] = 1
			elseif Target.health <= allDmg then
				KillText[i] = 2
			end
		end
	end	
end

function LFCfunc()
	if not HazMenu.LFC.LagFree then _G.DrawCircle = _G.oldDrawCircle end
    if HazMenu.LFC.LagFree then _G.DrawCircle = DrawCircle2 end
end

-- Barasia, vadash, viseversa

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function round(num) 
	if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, HazMenu.LFC.CL) 
	end
end

function OnCreateObj(object)
	if object and object.valid then
		for _, effect in pairs(immuneEffects) do
			if effect[1] == object.name then
				local nearestHero = nil
				for i = 1, heroManager.iCount do
					local hero = heroManager:GetHero(i)
					if nearestHero and nearestHero.valid and hero and hero.valid then
						if GetDistanceSqr(hero, object) < GetDistanceSqr(nearestHero, object) then
							nearestHero = hero
						end
					else
						nearestHero = hero
					end
				end
				immuneTable[nearestHero.networkID] = os.clock() + effect[2]
			end
		end
	end
end



function ClearImmuneTable()
	for networkID, time in pairs(immuneTable) do
		if os.clock() > time then
			immuneTable[networkID] = nil
		end
	end
end



for i, enemy in ipairs(GetEnemyHeroes()) do
    enemy.barData = {PercentageOffset = {x = 0, y = 0} }
end

function GetEnemyHPBarPos(enemy)

    if not enemy.barData then
        return
    end

    local barPos = GetUnitHPBarPos(enemy)
    local barPosOffset = GetUnitHPBarOffset(enemy)
    local barOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)
    local barPosPercentageOffset = Point(enemy.barData.PercentageOffset.x, enemy.barData.PercentageOffset.y)

    local BarPosOffsetX = 169
    local BarPosOffsetY = 47
    local CorrectionX = 16
    local CorrectionY = 4

    barPos.x = barPos.x + (barPosOffset.x - 0.5 + barPosPercentageOffset.x) * BarPosOffsetX + CorrectionX
    barPos.y = barPos.y + (barPosOffset.y - 0.5 + barPosPercentageOffset.y) * BarPosOffsetY + CorrectionY 

    local StartPos = Point(barPos.x, barPos.y)
    local EndPos = Point(barPos.x + 103, barPos.y)

    return Point(StartPos.x, StartPos.y), Point(EndPos.x, EndPos.y)

end


function DrawIndicator(enemy)
	local Qdmg, Wdmg, Edmg, AAdmg = getDmg("Q", enemy, myHero), getDmg("W", enemy, myHero), getDmg("E", enemy, myHero), getDmg("AD", enemy, myHero)
	
	Qdmg = ((Q.IsReady and Qdmg) or 0)
	Edmg = ((E.IsReady and Edmg) or 0)
	Rdmg = ((R.IsReady and Rdmg) or 0)
	AAdmg = ((Aadmg) or 0)

    local damage = Qdmg + Edmg + Rdmg

    local SPos, EPos = GetEnemyHPBarPos(enemy)

    if not SPos then return end

    local barwidth = EPos.x - SPos.x
    local Position = SPos.x + math.max(0, (enemy.health - damage) / enemy.maxHealth) * barwidth

	DrawText("|", 16, math.floor(Position), math.floor(SPos.y + 8), ARGB(255,0,255,0))
    DrawText("HP: "..math.floor(enemy.health - damage), 12, math.floor(SPos.x + 25), math.floor(SPos.y - 15), (enemy.health - damage) > 0 and ARGB(255, 0, 255, 0) or  ARGB(255, 255, 0, 0))
end