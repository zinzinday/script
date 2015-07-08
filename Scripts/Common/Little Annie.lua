--[[
 _     _ _   _   _         ___              _      
| |   (_) | | | | |       / _ \            (_)     
| |    _| |_| |_| | ___  / /_\ \_ __  _ __  _  ___ 
| |   | | __| __| |/ _ \ |  _  | '_ \| '_ \| |/ _ \
| |___| | |_| |_| |  __/ | | | | | | | | | | |  __/
\_____/_|\__|\__|_|\___| \_| |_/_| |_|_| |_|_|\___|
                                                  
Changelog:
	v0.003:
		-Fix bug with auto cast ignite
	v0.002:
		-Fix auto passive stacking that break recall.
		-Change Auto tibber from "follow target" to "Attack target".
	v0.001: Initial release
--]]

local annie_autoupdate = true
local silentUpdate = false

local version = 0.003

local scriptName = "LittleAnnie"

myHero = GetMyHero()

if myHero.charName ~= 'Annie' then return end

--{ Sourcelib check
local sourceLibFound = true
    require "SourceLib"
else
    sourceLibFound = false
end

if not sourceLibFound then print("Can't find sourcelib") return end
--}

--{ Auto update
if annie_autoupdate then
	SourceUpdater(scriptName, version, "raw.github.com", "/LazerBoL/BoL/master/" .. scriptName .. ".lua", SCRIPT_PATH .. GetCurrentEnv().FILE_NAME, "/LazerBoL/BoL/master/version/" .. scriptName .. ".version"):SetSilent(silentUpdate):CheckUpdate()
end
--}

--{ Lib downloader
 local libDownloader = Require(scriptName)
        libDownloader:Add("VPrediction", "https://raw.github.com/Hellsing/BoL/master/common/VPrediction.lua")
        libDownloader:Add("SOW",         "https://raw.github.com/Hellsing/BoL/master/common/SOW.lua")
        libDownloader:Check()

 if libDownloader.downloadNeeded then return end
--}

function AnnieData()
	SpellData = {
		Q = {range = 625    ,width = -1            , delay = 0.25    ,speed = 1400},
		W = {range = 625    ,width = 50*math.pi/180, delay = 0.25    ,speed = math.huge},
		E = {range = -1     ,width = -1            , delay = 0.5     ,speed = -1}, 
		R = {range = 600    ,width = 250         , delay = 0.25    ,speed = math.huge} 
	}
	MainCombo = {ItemManager:GetItem("DFG"):GetId(), _Q, _W, _R, _IGNITE,_AA}
	buffCount = 0
	haveStun = false
	objR = nil
	
	maxQRWE = {1,2,1,3,1,4,1,2,1,2,4,2,2,3,3,4,3,3}
	maxWRQE = {2,1,3,2,2,4,2,1,2,1,4,1,1,3,3,4,3,3}
	
	Recalling = false
	
	TWinduptime = 0
	TAnimationTime = 0
	TLastAttack = 0
end

function OnLoad()
	--{ Variables
	AnnieData()
	VP = VPrediction()
	OW = SOW(VP)
	STS = SimpleTS()
	DM = DrawManager()
	DLib = DamageLib()
	--}
	
	--{ Spell data
	Q = Spell(_Q, SpellData.Q.range)
	W = Spell(_W, SpellData.W.range)
	E = Spell(_E, SpellData.E.range)
	R = Spell(_R, SpellData.R.range)
	
	W:SetSkillshot(VP, SKILLSHOT_CONE  , SpellData.W.width, SpellData.W.delay, SpellData.W.speed, false)
	R:SetSkillshot(VP, SKILLSHOT_CIRCULAR, SpellData.R.width, SpellData.R.delay, SpellData.R.speed, false)
	
	W:SetAOE(true)
	R:SetAOE(true)
	
	DLib:RegisterDamageSource(_Q, _MAGIC, 45, 35, _MAGIC, _AP, 0.8, function() return (player:CanUseSpell(_Q) == READY) end)
	DLib:RegisterDamageSource(_W, _MAGIC, 25, 45, _MAGIC, _AP, 0.85, function() return (player:CanUseSpell(_W) == READY) end)
	DLib:RegisterDamageSource(_R, _MAGIC, 85, 125, _MAGIC, _AP, 1.0, function() return (player:CanUseSpell(_R) == READY and objR == nil) end)
	--}
	
	--{ Menu
	Menu = scriptConfig("Little Annie","LittleAnnie")
	
	--Author
	Menu:addSubMenu("[ Annie : Script Information ]","Script")
		Menu.Script:addParam("Author","Author: Lazer",SCRIPT_PARAM_INFO,"")
		Menu.Script:addParam("Credits","Credits: Pain,ViceVersa,shagratt, turtlebot,",SCRIPT_PARAM_INFO,"")
		Menu.Script:addParam("Credits1","honda7,Bilbao,Hellsing,Vadash,barasia283",SCRIPT_PARAM_INFO,"")
		Menu.Script:addParam("Version","Version: " .. version,SCRIPT_PARAM_INFO,"")
	--General
	Menu:addSubMenu("[ Annie : General ]","General")
		Menu.General:addParam("Combo","Combo",SCRIPT_PARAM_ONKEYDOWN,false,32)
		Menu.General:addParam("Harass","Harass",SCRIPT_PARAM_ONKEYDOWN,false,string.byte("C"))
		Menu.General:addParam("Farm","Farm/Jungle press",SCRIPT_PARAM_ONKEYDOWN,false,string.byte("V"))
		Menu.General:addParam("Farm2","Farm/Jungle toggle",SCRIPT_PARAM_ONKEYTOGGLE,false,string.byte("Z"))
	
	--Target Selector
	Menu:addSubMenu("[ Annie : Target Selector ]","TS")
		Menu.TS:addParam("TS","Target Selector",SCRIPT_PARAM_LIST,2,{"AllClass","STS","SAC: Reborn","MMA","Selector"})
		ts = TargetSelector(TARGET_LESS_CAST,625,DAMAGE_MAGIC,false)
		ts.name = "AllClass TS"
		Menu.TS:addTS(ts)
		
	--Orbwalking
	Menu:addSubMenu("[ Annie : Orbwalking ]","Orbwalking")
		OW:LoadToMenu(Menu.Orbwalking)
	
	--Combo
	Menu:addSubMenu("[ Annie : Combo ]","Combo")
		Menu.Combo:addParam("Q","Use Q in combo",SCRIPT_PARAM_ONOFF,true)
		Menu.Combo:addParam("W","Use W in combo",SCRIPT_PARAM_ONOFF,true)
		Menu.Combo:addParam("E","Use E in combo",SCRIPT_PARAM_ONOFF,true)
		Menu.Combo:addParam("R","Use R in combo",SCRIPT_PARAM_ONOFF,true)
		Menu.Combo:addParam("I","Use item in combo",SCRIPT_PARAM_ONOFF,true)
		Menu.Combo:addParam("Flash","Use flash if can kill target",SCRIPT_PARAM_ONOFF,false)
		
	--Harass
	Menu:addSubMenu("[ Annie : Harass ]","Harass")
		Menu.Harass:addParam("Q","Use Q in combo",SCRIPT_PARAM_ONOFF,true)
		Menu.Harass:addParam("W","Use W in combo",SCRIPT_PARAM_ONOFF,true)
		
	--Jungle/Farm Settings
	Menu:addSubMenu("[ Annie : Farm/Jungle Settings ]","Farm")
		Menu.Farm:addParam("LQ","Use Q to 'Farm'",SCRIPT_PARAM_ONOFF,true)
		Menu.Farm:addParam("LW","Use W to 'Farm'",SCRIPT_PARAM_ONOFF,false)
		Menu.Farm:addParam("JQ","Use Q to 'Jungle'",SCRIPT_PARAM_ONOFF,true)
		Menu.Farm:addParam("JW","Use W to 'Jungle'",SCRIPT_PARAM_ONOFF,true)
		Menu.Farm:addParam("Stop","Don't Farm when ",SCRIPT_PARAM_LIST,3,{"None","enemy are near","have stun","both"})
		Menu.Farm:addParam("Mana","Don't farm if mana < %",SCRIPT_PARAM_SLICE,20,0,100)
		
	--Interrupt Settings
	Menu:addSubMenu("[ Annie : Auto interrupt settings ]","Interrupt")
	Interrupter(Menu.Interrupt, OnTargetInterruptable)
	
	--Automation Settings
	Menu:addSubMenu("[ Annie : Automation Settings ]","Auto")
		Menu.Auto:addParam("W","Auto W if can stun",SCRIPT_PARAM_LIST,3,{"No",">0 targets",">1 targets",">2 targets",">3 targets",">4 targets"})
		Menu.Auto:addParam("R","Auto R if can stun",SCRIPT_PARAM_LIST,3,{"No",">0 targets",">1 targets",">2 targets",">3 targets",">4 targets"})
		Menu.Auto:addParam("Tibbers","Auto command Tibbers to",SCRIPT_PARAM_LIST,2,{"No","Attack target","Follow Annie"})
		Menu.Auto:addParam("E","Auto shield",SCRIPT_PARAM_ONOFF,true)
		Menu.Auto:addParam("Passive","Stacking passive when in fountain",SCRIPT_PARAM_ONOFF,true)
	
	--Extra Settings
	Menu:addSubMenu("[ Annie: Extra Settings ]","Extra")
	if VIP_USER then
		Menu.Extra:addParam("Packet","Use Packet cast",SCRIPT_PARAM_ONOFF,true)
	end
	Menu.Extra:addParam("AutoLevel","Auto level sequence",SCRIPT_PARAM_LIST,1,{"None","QRWE","WRQE"})
	
	--Draw Settings
	Menu:addSubMenu("[ Annie : Draw ]","Draw")
		DM:CreateCircle(myHero, SpellData.Q.range, 1, {255, 170, 0, 255}):AddToMenu(Menu.Draw, "Combo Range", true, true, true)
		DM:CreateCircle(myHero, SpellData.R.range + 400, 1, {255, 255, 0, 255}):AddToMenu(Menu.Draw, "Flash-Ult Range", true, true, true)
		
		-- Predicted damage tick on health bar
		DLib:AddToMenu(Menu.Draw, MainCombo)

	-- Minion & Jungle Mob
	EnemyMinion = minionManager(MINION_ENEMY,625,myHero,MINION_SORT_HEALTH_ASC)
	JungMinion = minionManager(MINION_JUNGLE,625,myHero,MINION_SORT_MAXHEALTH_DEC)
	
	--}
	
	TickLimiter(OnTick5, 5)
	TickLimiter(OnTick15, 15)
	
	--{ Perma show
	Menu.Script:permaShow("Author")
	Menu.General:permaShow("Combo")
	Menu.General:permaShow("Harass")
	Menu.General:permaShow("Farm")
	Menu.General:permaShow("Farm2")
	Menu.Auto:permaShow("R")
	Menu.Auto:permaShow("Tibbers")
	--}
	
	--{ All loaded
	print("<font color='#AA00FF'>Little </font><font color='#FF00FF'>Annie</font><font color='#E25822'> v" .. version .."</font>")
	--}
end

--{ Target Selector
function GrabTarget()
	if  _G.Selector_Enabled and Menu.TS.TS == 5 then
		return Selector.GetTarget(SelectorMenu.Get().mode, nil, {distance = MaxRange()})
	elseif _G.MMA_Loaded and Menu.TS.TS == 4 then
		return _G.MMA_ConsideredTarget(MaxRange())		
	elseif _G.AutoCarry and Menu.TS.TS == 3 then
		return _G.AutoCarry.Crosshair:GetTarget()
	elseif Menu.TS.TS == 2 then
		return STS:GetTarget(MaxRange())
	else
		ts.range = MaxRange()
		ts:update()
		return ts.target
	end
end

function GrabTargetInRange(rangeT)
	if  _G.Selector_Enabled and Menu.TS.TS == 5 then
		return Selector.GetTarget(SelectorMenu.Get().mode, nil, {distance = rangeT})
	elseif _G.MMA_Loaded and Menu.TS.TS == 4 then
		return _G.MMA_ConsideredTarget(rangeT)		
	elseif _G.AutoCarry and Menu.TS.TS == 3 then
		return _G.AutoCarry.Crosshair:GetTarget()
	elseif Menu.TS.TS == 2 then
		return STS:GetTarget(rangeT)
	else
		ts.range = rangeT
		ts:update()
		return ts.target
	end
end

function MaxRange()
	if Menu.Combo.Flash and myHero:CanUseSpell(_FLASH) == READY then
		return SpellData.R.range + 400
	elseif R:IsReady() then
		return SpellData.Q.range
	elseif W:IsReady() then
		return SpellData.W.range
	elseif Q:IsReady() then
		return SpellData.R.range
	else
		return myHero.range + 50
	end
end
--}

--{Interrupt
function OnTargetInterruptable(unit,spell)
	if E:IsReady() and not haveStun then
		E:Cast()
	end
	if haveStun and ValidTarget(unit) then
        if R:IsReady() and objR == nil then
			R:Cast(unit)
		end
		if W:IsReady() then
			W:Cast(unit)
		end
		if Q:IsReady() then
			Q:Cast(unit)
		end
    end
end
--}

--{ Combo
function ComboManaUsage(combo)
	local totalMana = 0
	for i,spell in ipairs(combo) do
		if myHero:CanUseSpell(spell) == READY then
			totalMana = totalMana + myHero:GetSpellData(spell).mana
		end
	end
	return totalMana
end

function Combo(UseQ,UseW,UseE,UseR,target)
	if DLib:IsKillable(target, {_Q}) and UseQ and Q:IsReady() then
		Q:Cast(target)
	elseif DLib:IsKillable(target, {_W}) and UseW and W:IsReady() then
		W:Cast(target)
	elseif DLib:IsKillable(target, {_R}) and UseR and R:IsReady() and objR == nil then
		R:Cast(target)
	else
		if UseE and not haveStun then E:Cast() end
		if R:IsReady() and haveStun and UseR and objR == nil then
			R:Cast(target)
		else
			if UseW then W:Cast(target) end
			if UseQ then Q:Cast(target) end
		end
	end
end

--}

--{ Enemy in range of myHero
function CountEnemyInRange(target,range)
	local count = 0
	for i = 1, heroManager.iCount do
		local hero = heroManager:GetHero(i)
		if hero.team ~= myHero.team and hero.visible and not hero.dead and GetDistanceSqr(target,hero) <= range*range then
			count = count + 1
		end
	end
	return count
end
--}

--{ Spell cast
function SpellCast(spellSlot,castPosition)
	if VIP_USER and Menu.Extra.Packet then
		Packet("S_CAST", {spellId = spellSlot, targetNetworkId = castPosition.networkID}):send()
	else
		CastSpell(spellSlot,castPosition)
	end
end
--}

function OnTick()
	local TARGET = GrabTarget()
	if ValidTarget(TARGET) then
		--{ Combo
		if Menu.General.Combo then	
			OW:DisableAttacks()
			if DLib:IsKillable(TARGET, MainCombo) and ComboManaUsage(MainCombo) then
				ItemManager:CastOffensiveItems(TARGET)	
				if Menu.Combo.Flash then
					local position = VP:GetPredictedPos(TARGET,SpellData.R.delay)
					local realPos = Vector(myHero.visionPos) + 400 * (Vector(position) - Vector(myHero.visionPos)):normalized()
					if not IsWall(D3DXVECTOR3(realPos.x, realPos.y, realPos.z))
						and GetDistanceSqr(myHero,position) > SpellData.R.range * SpellData.R.range
						and GetDistanceSqr(myHero,position) <= (SpellData.R.range + 400) * (SpellData.R.range + 400)  then
						CastSpell(_FLASH,realPos.x,realPos.z)
					end
			end	
				if _IGNITE then
					CastSpell(_IGNITE, TARGET)
				end
			end
			Combo(Menu.Combo.Q,Menu.Combo.W,Menu.Combo.E,Menu.Combo.R,TARGET)
			if not (Q:IsReady() or W:IsReady() or (R:IsReady() and objR == nil)) then
				OW:EnableAttacks()
			end
		end
		--}
		
		--{ Harass
		if Menu.General.Harass then
			if Menu.Harass.Q and Q:IsReady() then
				Q:Cast(TARGET)
			end
			if Menu.Harass.W and W:IsReady() then
				W:Cast(TARGET)
			end
		end
		--}
	end
	--{ Farm/Jungle
	if Menu.General.Farm or Menu.General.Farm2 then
		if Menu.General.Combo or Menu.General.Harass then return end
		--Lane
		EnemyMinion:update()
		if myHero.mana/myHero.maxMana * 100 > Menu.Farm.Mana and ValidTarget(EnemyMinion.objects[1],SpellData.Q.range) then
			if Menu.Farm.Stop == 2 then
				if CountEnemyInRange(myHero,800) > 0 then return end
			elseif Menu.Farm.Stop == 3 then
				if haveStun then return end		
			elseif Menu.Farm.Stop == 4 then
				if CountEnemyInRange(myHero,800) > 0 or haveStun then return end
			end
			if Menu.Farm.LQ and Q:IsReady() then 
				local delay = SpellData.Q.delay + GetDistance(EnemyMinion.objects[1].visionPos, myHero.visionPos) / SpellData.Q.speed - 0.07
				local predictedHealth = VP:GetPredictedHealth(EnemyMinion.objects[1], delay)
				if predictedHealth <= DLib:CalcSpellDamage(EnemyMinion.objects[1],_Q) and predictedHealth > 0 then
					Q:Cast(EnemyMinion.objects[1])
				end
			end
			if Menu.Farm.LW and W:IsReady() then 
				if DLib:IsKillable(EnemyMinion.objects[1], {_W}) then 
					W:Cast(EnemyMinion.objects[1])
				end
			end
		end
	end
	if Menu.General.Farm then
		--Jungle
		JungMinion:update()
		if ValidTarget(JungMinion.objects[1],SpellData.Q.range) then
			if Menu.Farm.JQ and Q:IsReady() then
				for i, minion in ipairs(JungMinion.objects) do
					if minion.health <= DLib:CalcSpellDamage(minion,_Q)  then
						Q:Cast(minion)
						break
					end
				end
				if Q:IsReady() then
					Q:Cast(JungMinion.objects[1])
				end
			end
			if Menu.Farm.JW and W:IsReady() then
				W:Cast(JungMinion.objects[1])
			end
		end
			
		if OW:CanAttack() and OW:InRange(JungMinion.objects[1])  then
			myHero:Attack(JungMinion.objects[1])
		end		
	end
	--}
end

function OnTick5()
	
	--{ Packet cast
	if VIP_USER then
		Q.packetCast = Menu.Extra.Packet
		W.packetCast = Menu.Extra.Packet
		E.packetCast = Menu.Extra.Packet
		R.packetCast = Menu.Extra.Packet
	end
	--}
	TibberTarget = GrabTargetInRange(1500)

	--{ Automation
		--{ Tibber follow
		if objR ~= nil then
			if Menu.Auto.Tibbers == 2 then
				if ValidTarget(TibberTarget) then
					if os.clock() + GetLatency()/2000 > TLastAttack + TAnimationTime+0.05 then
						CastSpell(_R,TibberTarget.x,TibberTarget.z)
					end
				end
			elseif Menu.Auto.Tibbers == 3 then
				R:Cast()
			end
		end
		--}
		
		--{ Passive Stack
		if Menu.Auto.Passive  and not haveStun then
			if InFountain() then
				if E:IsReady() then E:Cast() end
				if W:IsReady() then W:Cast(myHero.x,myHero.z)end
			elseif myHero.mana == myHero.maxMana and not Recalling then
				if E:IsReady() then E:Cast() end
			end
		end
		--}
		
		-- Auto level
		if Menu.Extra.AutoLevel == 2 then
			autoLevelSetSequence(maxQRWE)
		elseif Menu.Extra.AutoLevel == 3 then
			autoLevelSetSequence(maxWRQE)
		end
	--}
end

function OnTick15()
	local TARGET = GrabTarget()
	--{ Automation
		--{ Auto R
		if Menu.Auto.R > 1 and R:IsReady() and objR == nil and TARGET and W:IsInRange(TARGET) and haveStun then
			local minTargetsAoe = Menu.Auto.R - 1
			R:SetAOE(true, SpellData.R.width, minTargetsAoe)
			R:Cast(TARGET)
			R:SetAOE(true)
		end
		--}
		
		--{ Auto W
		if Menu.Auto.W > 1 and W:IsReady() and TARGET and R:IsInRange(TARGET) and haveStun then
			local minTargetsAoe = Menu.Auto.W - 1
			W:SetAOE(true, SpellData.W.width, minTargetsAoe)
			W:Cast(TARGET)
			W:SetAOE(true)
		end
		--}
	--}
end

function OnCreateObj(obj)
	if obj.name:find("StunReady") then
		haveStun = true
		buffCount = 3
	end
	if obj.name:lower():find("annietibbers") and obj.name:lower():find("body") then
		objR = obj
	end
	if obj.name:find("TeleportHome") then
		Recalling = true
	end
end

function OnDeleteObj(obj)
	if obj.name:find("StunReady") then
		haveStun = false
		buffCount = 0
	end
	if obj.name:lower():find("annietibbers") and obj.name:lower():find("body") then
		objR = nil
	end
	if obj.name:find("TeleportHome") or (Recalling == nil and obj.name == Recalling.name) then
		Recalling = false
	end
end

function OnProcessSpell(unit,spell)
	if unit.isMe and (spell.name:lower():find("disintegrate") or
					  spell.name:lower():find("incinerate") or
					  spell.name:lower():find("moltenshield") or
					  spell.name:lower():find("infernalguardian") )then
		DelayAction(
		function()
			buffCount = buffCount + 1
			if buffCount > 4 then buffCount = 4 end
		end,spell.windUpTime + GetLatency() / 2000)
	end
	
	if Menu.Auto.E and unit.team ~= myHero.team and (unit.type =="obj_AI_Hero" or unit.type == "obj_AI_Turret")
		and spell.target == myHero and spell.name:lower():find("attack") then
		if E:IsReady() then
			E:Cast()
		end
	end
	
	if unit.charName == "AnnieTibbers" and spell.name:lower():find("attack") then
		TWinduptime = spell.windUpTime
		TAnimationTime = spell.animationTime
		TLastAttack = os.clock() - GetLatency()/2000
	end
end


--UPDATEURL=
--HASH=D9BF96409144FC5442E66BEA478D3EC4
