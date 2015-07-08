--[[
	Auto Shield 1.10
		by eXtragoZ
		
	Features:
		- Supports:
			- Shields: Lulu, Janna, Karma, LeeSin, Orianna, Lux, Thresh, JarvanIV, Nautilus, Rumble, Sion, Shen, Skarner, Urgot, Diana, Riven, Morgana, Sivir and Nocturne
			- Items: Locket of the Iron Solari, Seraph's Embrace, Face of the Mountain
			- Summoner Spells: Heal, Barrier
			- Heals: Alistar E, Kayle W, Nami W, Nidalee E, Sona W, Soraka W, Taric Q ,Gangplank W
			- Ultimates: Zilean R, Tryndamere R, Kayle R, Shen R, Lulu R, Soraka R
			- Yasuo and Braum Wall
		- If the skill has immediate damage, the script does not reached to activate the shield/heal/invulnerability
		- In the case that the enemy ability hits multiple allies the script looks for the highest percentage of damage unless it is a skillshot that only hits the first target in that case looks for the closest one from the enemy
		- Press shift to configure	
]]

local version = "1.07"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/gmzopper/BoL/master/AutoShield.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function _AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>AutoShield:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/gmzopper/BoL/master/version/AutoShield.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				_AutoupdaterMsg("New version available "..ServerVersion)
				_AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () _AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				_AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		_AutoupdaterMsg("Error downloading version info")
	end
end

--Script Status Updates
assert(load(Base64Decode("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"), nil, "bt", _ENV))() ScriptStatus("SFIHGLJLJFG") 

local typeshield
local spellslot
local typeheal
local healslot
local typeult
local ultslot
local wallslot
local range = 0
local healrange = 0
local ultrange = 0
local shealrange = 300
local lisrange = 600
local FotMrange = 700

if myHero.charName == "Lulu" then
	typeshield = 1
	spellslot = _E
	range = 650
	typeult = 1
	ultslot = _R
	ultrange = 900
elseif myHero.charName == "Janna" then
	typeshield = 1
	spellslot = _E
	range = 800
elseif myHero.charName == "Karma" then
	typeshield = 1
	spellslot = _E
	range = 800
elseif myHero.charName == "LeeSin" then
	typeshield = 1
	spellslot = _W
	range = 700
elseif myHero.charName == "Orianna" then
	typeshield = 1
	spellslot = _E
	range = 1120 -- 1095
elseif myHero.charName == "Lux" then
	typeshield = 2
	spellslot = _W
	range = 1075
elseif myHero.charName == "Thresh" then
	typeshield = 2
	spellslot = _W
	range = 950 + 300
elseif myHero.charName == "JarvanIV" then
	typeshield = 3
	spellslot = _W
elseif myHero.charName == "Nautilus" then
	typeshield = 3
	spellslot = _W
elseif myHero.charName == "Rumble" then
	typeshield = 3
	spellslot = _W
elseif myHero.charName == "Sion" then
	typeshield = 3
	spellslot = _W
elseif myHero.charName == "Shen" then
	typeshield = 3
	spellslot = _W
	typeult = 3
	ultslot = _R
	ultrange = 25000
elseif myHero.charName == "Skarner" then
	typeshield = 3
	spellslot = _W
elseif myHero.charName == "Urgot" then
	typeshield = 3
	spellslot = _W
elseif myHero.charName == "Diana" then
	typeshield = 3
	spellslot = _W
elseif myHero.charName == "Riven" then
	typeshield = 4
	spellslot = _E
elseif myHero.charName == "Morgana" then
	typeshield = 5
	spellslot = _E
	range = 750
elseif myHero.charName == "Sivir" then
	typeshield = 6
	spellslot = _E
elseif myHero.charName == "Nocturne" then
	typeshield = 6
	spellslot = _W
elseif myHero.charName == "Alistar" then
	typeheal = 2
	healslot = _E
	healrange = 575
elseif myHero.charName == "Kayle" then
	typeheal = 1
	healslot = _W
	healrange = 900
	typeult = 1
	ultslot = _R
	ultrange = 900
elseif myHero.charName == "Nami" then
	typeheal = 1
	healslot = _W
	healrange = 725
elseif myHero.charName == "Nidalee" then
	typeheal = 1
	healslot = _E
	healrange = 600
elseif myHero.charName == "Sona" then
	typeheal = 2
	healslot = _W
	healrange = 1000
elseif myHero.charName == "Soraka" then
	typeheal = 1
	healslot = _W
	healrange = 750
	typeult = 2
	ultslot = _R
	ultrange = 25000
elseif myHero.charName == "Taric" then
	typeheal = 1
	healslot = _Q
	healrange = 750
elseif myHero.charName == "Gangplank" then
	typeheal = 3
	healslot = _W
elseif myHero.charName == "Zilean" then
	typeult = 1
	ultslot = _R
	ultrange = 900
elseif myHero.charName == "Tryndamere" then
	typeult = 4
	ultslot = _R
elseif myHero.charName == "Yasuo" then
	wallslot = _W
elseif myHero.charName == "Braum" then
	wallslot = _E
end

local sbarrier = nil
local sheal = nil
local useitems = true
local spelltype = nil
local casttype = nil
local BShield,SShield,Shield,CC = false,false,false,false
local shottype,radius,maxdistance = 0,0,0
local hitchampion = false
--[[		Code		]]

function CustomGetInventorySlotItem(item, unit)
	for slot = ITEM_1, ITEM_7 do
		if unit:GetSpellData(slot).name:lower() == item:lower() then
			return slot
		end
	end
	
	return nil
end

function CustomGetInventoryHaveItem(item, unit)
	for slot = ITEM_1, ITEM_7 do
		if unit:GetSpellData(slot).name:lower() == item:lower() then
			return true
		end
	end
	
	return false
end

function OnLoad()
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerbarrier") then sbarrier = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerbarrier") then sbarrier = SUMMONER_2 end
	
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerheal") then sheal = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerheal") then sheal = SUMMONER_2 end
	
	if typeshield ~= nil then
		ASConfig = scriptConfig("(AS) Auto Shield", "AutoShield")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team then ASConfig:addParam("teammateshield"..i, "Shield "..teammate.charName, SCRIPT_PARAM_ONOFF, true) end
		end
		ASConfig:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)	
		ASConfig:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
		ASConfig:addParam("mindmg", "Min dmg approx", SCRIPT_PARAM_INFO, 0)
		ASConfig:addParam("skillshots", "Shield Skillshots", SCRIPT_PARAM_ONOFF, true)
		ASConfig:addParam("shieldcc", "Auto Shield Hard CC", SCRIPT_PARAM_ONOFF, true)
		ASConfig:addParam("shieldslow", "Auto Shield Slows", SCRIPT_PARAM_ONOFF, true)
		ASConfig:addParam("drawcircles", "Draw Range", SCRIPT_PARAM_ONOFF, true)
		ASConfig:permaShow("mindmg")
	end
	
	if typeheal ~= nil then
		AHConfig = scriptConfig("(AS) Auto Heal", "AutoHeal")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team then AHConfig:addParam("teammateheal"..i, "Heal "..teammate.charName, SCRIPT_PARAM_ONOFF, true) end
		end
		AHConfig:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)	
		AHConfig:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
		AHConfig:addParam("mindmg", "Min dmg approx", SCRIPT_PARAM_INFO, 0)
		AHConfig:addParam("skillshots", "Heal Skillshots", SCRIPT_PARAM_ONOFF, true)
		AHConfig:addParam("drawcircles", "Draw Range", SCRIPT_PARAM_ONOFF, true)
		AHConfig:permaShow("mindmg")
	end
	
	if typeult ~= nil then
		AUConfig = scriptConfig("(AS) Auto Ultimate", "AutoUlt")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team then AUConfig:addParam("teammateult"..i, "Ult "..teammate.charName, SCRIPT_PARAM_ONOFF, true) end
		end
		AUConfig:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)	
		AUConfig:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
		AUConfig:addParam("mindmg", "Min dmg approx", SCRIPT_PARAM_INFO, 0)
		AUConfig:addParam("skillshots", "Skillshots", SCRIPT_PARAM_ONOFF, true)
		AUConfig:addParam("drawcircles", "Draw Range", SCRIPT_PARAM_ONOFF, true)
		AUConfig:permaShow("mindmg")
	end
	
	if wallslot ~= nil then
		WConfig = scriptConfig("(AS) Auto Wall", "AutoWall")
		WConfig:addParam("wallon", "Auto Wall", SCRIPT_PARAM_ONOFF, true)
		WConfig:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)	
		WConfig:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
		WConfig:addParam("mindmg", "Min dmg approx", SCRIPT_PARAM_INFO, 0)
		WConfig:addParam("skillshots", "Shield Skillshots", SCRIPT_PARAM_ONOFF, true)
		WConfig:addParam("shieldcc", "Auto Shield Hard CC", SCRIPT_PARAM_ONOFF, true)
		WConfig:addParam("shieldslow", "Auto Shield Slows", SCRIPT_PARAM_ONOFF, true)
		WConfig:permaShow("mindmg")
	end
	
	if sbarrier ~= nil then
		ASBConfig = scriptConfig("(AS) Auto Summoner Barrier", "AutoSummonerBarrier")
		ASBConfig:addParam("barrieron", "Barrier", SCRIPT_PARAM_ONOFF, true)
		ASBConfig:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
		ASBConfig:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 95, 0, 100, 0)
		ASBConfig:addParam("mindmg", "Min dmg approx", SCRIPT_PARAM_INFO, 0)
		ASBConfig:addParam("skillshots", "Shield Skillshots", SCRIPT_PARAM_ONOFF, true)
	end
	
	if sheal ~= nil then
		ASHConfig = scriptConfig("(AS) Auto Summoner Heal", "AutoSummonerHeal")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team then ASHConfig:addParam("teammatesheal"..i, "Heal "..teammate.charName, SCRIPT_PARAM_ONOFF, false) end
		end
		ASHConfig:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
		ASHConfig:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 95, 0, 100, 0)
		ASHConfig:addParam("mindmg", "Min dmg approx", SCRIPT_PARAM_INFO, 0)
		ASHConfig:addParam("skillshots", "Heal Skillshots", SCRIPT_PARAM_ONOFF, true)
	end

	if useitems then
		ASIConfig = scriptConfig("(AS) Auto Shield Items", "AutoShieldItems")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team then ASIConfig:addParam("teammateshieldi"..i, "Shield "..teammate.charName, SCRIPT_PARAM_ONOFF, true) end
		end
		ASIConfig:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
		ASIConfig:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		ASIConfig:addParam("mindmg", "Min dmg approx", SCRIPT_PARAM_INFO, 0)
		ASIConfig:addParam("skillshots", "Shield Skillshots", SCRIPT_PARAM_ONOFF, true)
	end
end

function OnProcessSpell(object,spell)
	if object.team ~= myHero.team and not myHero.dead and object.name ~= nil and not (object.name:find("Minion_") or object.name:find("Odin")) then
		local leesinW = myHero.charName ~= "LeeSin" or myHero:GetSpellData(_W).name == "BlindMonkWOne"
		local nidaleeE = myHero.charName ~= "Nidalee" or myHero:GetSpellData(_E).name == "PrimalSurge"
		
		local shieldREADY = typeshield ~= nil and myHero:CanUseSpell(spellslot) == READY and leesinW
		local healREADY = typeheal ~= nil and myHero:CanUseSpell(healslot) == READY and nidaleeE
		local ultREADY = typeult ~= nil and myHero:CanUseSpell(ultslot) == READY
		local wallREADY = wallslot ~= nil and myHero:CanUseSpell(wallslot) == READY
		local sbarrierREADY = sbarrier ~= nil and myHero:CanUseSpell(sbarrier) == READY
		local shealREADY = sheal ~= nil and myHero:CanUseSpell(sheal) == READY
		
		local lisslot = CustomGetInventorySlotItem("IronStylus", myHero)
		local seslot = CustomGetInventorySlotItem("ItemSeraphsEmbrace", myHero)
		local FotMslot = CustomGetInventorySlotItem("HealthBomb", myHero)
		
		local lisREADY = lisslot ~= nil and myHero:CanUseSpell(lisslot) == READY
		local seREADY = seslot ~= nil and myHero:CanUseSpell(seslot) == READY
		local FotMREADY = FotMslot ~= nil and myHero:CanUseSpell(FotMslot) == READY
		
		local HitFirst = false
		local shieldtarget,SLastDistance,SLastDmgPercent = nil,nil,nil
		local healtarget,HLastDistance,HLastDmgPercent = nil,nil,nil
		local ulttarget,ULastDistance,ULastDmgPercent = nil,nil,nil
		
		YWall,BShield,SShield,Shield,CC = false,false,false,false,false
		shottype,radius,maxdistance = 0,0,0
		
		if object.type == "AIHeroClient" then
			spelltype, casttype = getSpellType(object, spell.name)
			
			if casttype == 4 or casttype == 5 or casttype == 6 then return end
			
			if spelltype == "BAttack" or spelltype == "CAttack" then
				Shield = true
				YWall = true
			elseif spell.name:find("SummonerDot") then
				Shield = true
			elseif spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" or spelltype == "P" or spelltype == "QM" or spelltype == "WM" or spelltype == "EM" then
				if skillShield[object.charName] == nil then return end
				HitFirst = skillShield[object.charName][spelltype]["HitFirst"]
				YWall = skillShield[object.charName][spelltype]["YWall"]
				BShield = skillShield[object.charName][spelltype]["BShield"]
				SShield = skillShield[object.charName][spelltype]["SShield"]
				Shield = skillShield[object.charName][spelltype]["Shield"]
				CC = skillShield[object.charName][spelltype]["CC"]
				shottype = skillData[object.charName][spelltype]["type"]
				radius = skillData[object.charName][spelltype]["radius"]
				maxdistance = skillData[object.charName][spelltype]["maxdistance"]
			end
		else
			Shield = true
		end
		
		for i=1, heroManager.iCount do
			local allytarget = heroManager:GetHero(i)
			if allytarget.team == myHero.team and not allytarget.dead and allytarget.health > 0 then
				hitchampion = false
				
				local allyHitBox = allytarget.boundingRadius
				if shottype == 0 then hitchampion = spell.target and spell.target.networkID == allytarget.networkID
				elseif shottype == 1 then hitchampion = checkhitlinepass(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 2 then hitchampion = checkhitlinepoint(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 3 then hitchampion = checkhitaoe(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 4 then hitchampion = checkhitcone(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 5 then hitchampion = checkhitwall(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 6 then hitchampion = checkhitlinepass(object, spell.endPos, radius, maxdistance, allytarget, allyHitBox) or checkhitlinepass(object, Vector(object)*2-spell.endPos, radius, maxdistance, allytarget, allyHitBox)
				elseif shottype == 7 then hitchampion = checkhitcone(spell.endPos, object, radius, maxdistance, allytarget, allyHitBox)
				end
				
				if hitchampion then
					if (allytarget.isMe and (_G.Evadeee_Enabled and _G.Evadeee_Loaded and _G.Evadeee_impossibleToEvade) or not _G.Evadeee_Enabled) or not allytarget.isMe then
						if shieldREADY and ASConfig["teammateshield"..i] and ((typeshield<=4 and Shield) or (typeshield==5 and BShield) or (typeshield==6 and SShield)) then
							if (((typeshield==1 or typeshield==2 or typeshield==5) and GetDistance(allytarget)<=range) or allytarget.isMe) then
								local shieldflag, dmgpercent = shieldCheck(object,spell,allytarget,"shields")
								if shieldflag then
									if HitFirst and (SLastDistance == nil or GetDistance(allytarget,object) <= SLastDistance) then
										shieldtarget,SLastDistance = allytarget,GetDistance(allytarget,object)
									elseif not HitFirst and (SLastDmgPercent == nil or dmgpercent >= SLastDmgPercent) then
										shieldtarget,SLastDmgPercent = allytarget,dmgpercent
									end
								end
							end
						end
						
						if healREADY and AHConfig["teammateheal"..i] and Shield then
							if ((typeheal==1 or typeheal==2) and GetDistance(allytarget)<=healrange) or allytarget.isMe then
								local healflag, dmgpercent = shieldCheck(object,spell,allytarget,"heals")
								if healflag then
									if HitFirst and (HLastDistance == nil or GetDistance(allytarget,object) <= HLastDistance) then
										healtarget,HLastDistance = allytarget,GetDistance(allytarget,object)
									elseif not HitFirst and (HLastDmgPercent == nil or dmgpercent >= HLastDmgPercent) then
										healtarget,HLastDmgPercent = allytarget,dmgpercent
									end
								end		
							end
						end
						
						if ultREADY and AUConfig["teammateult"..i] and Shield then
							if typeult==2 or (typeult==1 and GetDistance(allytarget)<=ultrange) or (typeult==4 and allytarget.isMe) or (typeult==3 and not allytarget.isMe) then
								local ultflag, dmgpercent = shieldCheck(object,spell,allytarget,"ult")
								if ultflag then
									if HitFirst and (ULastDistance == nil or GetDistance(allytarget,object) <= ULastDistance) then
										ulttarget,ULastDistance = allytarget,GetDistance(allytarget,object)
									elseif not HitFirst and (ULastDmgPercent == nil or dmgpercent >= ULastDmgPercent) then
										ulttarget,ULastDmgPercent = allytarget,dmgpercent
									end
								end
							end
						end
						
						if wallREADY and WConfig.wallon and allytarget.isMe and YWall then
							local wallflag, dmgpercent = shieldCheck(object,spell,allytarget,"wall")
							if wallflag then
								CastSpell(wallslot,spell.startPos.x,spell.startPos.z)
							end
						end
						
						if sbarrierREADY and ASBConfig.barrieron and allytarget.isMe and Shield then
							local barrierflag, dmgpercent = shieldCheck(object,spell,allytarget,"barrier")
							if barrierflag then
								CastSpell(sbarrier)
							end
						end
						
						if shealREADY and ASHConfig["teammatesheal"..i] and Shield then
							if GetDistance(allytarget)<=shealrange then
								local shealflag, dmgpercent = shieldCheck(object,spell,allytarget,"sheals")
								if shealflag then
									CastSpell(sheal)
								end
							end
						end
						
						if lisREADY and ASIConfig["teammateshieldi"..i] and Shield then
							if GetDistance(allytarget)<=lisrange then
								local lisflag, dmgpercent = shieldCheck(object,spell,allytarget,"items")
								if lisflag then
									CastSpell(lisslot)
								end
							end
						end
						
						if FotMREADY and ASIConfig["teammateshieldi"..i] and Shield then
							if GetDistance(allytarget)<=FotMrange then
								local FotMflag, dmgpercent = shieldCheck(object,spell,allytarget,"items")
								if FotMflag then
									CastSpell(FotMslot, allytarget)
								end
							end
						end
						
						if seREADY and ASIConfig["teammateshieldi"..i] and allytarget.isMe and Shield then
							local seflag, dmgpercent = shieldCheck(object,spell,allytarget,"items")
							if seflag then
								CastSpell(seslot)
							end
						end
					end
				end
			end
		end
		
		if shieldtarget ~= nil then
			if typeshield==1 or typeshield==5 then CastSpell(spellslot,shieldtarget)
			elseif typeshield==2 or typeshield==4 then CastSpell(spellslot,shieldtarget.x,shieldtarget.z)
			elseif typeshield==3 or typeshield==6 then CastSpell(spellslot) end
		end
		
		if healtarget ~= nil then
			if typeheal==1 then CastSpell(healslot,healtarget)
			elseif typeheal==2 or typeheal==3 then CastSpell(healslot) end
		end
		
		if ulttarget ~= nil then
			if typeult==1 or typeult==3 then CastSpell(ultslot,ulttarget)
			elseif typeult==2 or typeult==4 then CastSpell(ultslot) end		
		end
	end	
end

function shieldCheck(object,spell,target,typeused)
	local configused
	
	if typeused == "shields" then configused = ASConfig
	elseif typeused == "heals" then configused = AHConfig
	elseif typeused == "ult" then configused = AUConfig
	elseif typeused == "wall" then configused = WConfig
	elseif typeused == "barrier" then configused = ASBConfig 
	elseif typeused == "sheals" then configused = ASHConfig
	elseif typeused == "items" then configused = ASIConfig end
	
	local shieldflag = false
	if (not configused.skillshots and shottype ~= 0) then return false, 0 end
	local adamage = object:CalcDamage(target,object.totalDamage)
	local InfinityEdge,onhitdmg,onhittdmg,onhitspelldmg,onhitspelltdmg,muramanadmg,skilldamage,skillTypeDmg = 0,0,0,0,0,0,0,0

	if object.type ~= "AIHeroClient" then
		if spell.name:find("BasicAttack") then skilldamage = adamage
		elseif spell.name:find("CritAttack") then skilldamage = adamage*2 end
	else
		if GetInventoryHaveItem(3091,object) then onhitdmg = onhitdmg+getDmg("WITSEND",target,object) end
		if GetInventoryHaveItem(3057,object) then onhitdmg = onhitdmg+getDmg("SHEEN",target,object) end
		if GetInventoryHaveItem(3078,object) then onhitdmg = onhitdmg+getDmg("TRINITY",target,object) end
		if GetInventoryHaveItem(3100,object) then onhitdmg = onhitdmg+getDmg("LICHBANE",target,object) end
		if GetInventoryHaveItem(3025,object) then onhitdmg = onhitdmg+getDmg("ICEBORN",target,object) end
		if GetInventoryHaveItem(3087,object) then onhitdmg = onhitdmg+getDmg("STATIKK",target,object) end
		if GetInventoryHaveItem(3153,object) then onhitdmg = onhitdmg+getDmg("RUINEDKING",target,object) end
		if GetInventoryHaveItem(3042,object) then muramanadmg = getDmg("MURAMANA",target,object) end
		if GetInventoryHaveItem(3184,object) then onhittdmg = onhittdmg + 80 end
		
		if spelltype == "BAttack" then
			skilldamage = (adamage+onhitdmg+muramanadmg)*1.07+onhittdmg
		elseif spelltype == "CAttack" then
			if GetInventoryHaveItem(3031,object) then InfinityEdge = .5 end
			skilldamage = (adamage*(2.1+InfinityEdge)+onhitdmg+muramanadmg)*1.07+onhittdmg --fix Lethality
		elseif spelltype == "Q" or spelltype == "W" or spelltype == "E" or spelltype == "R" or spelltype == "P" or spelltype == "QM" or spelltype == "WM" or spelltype == "EM" then
			if GetInventoryHaveItem(3151,object) then onhitspelldmg = getDmg("LIANDRYS",target,object) end
			muramanadmg = skillShield[object.charName][spelltype]["Muramana"] and muramanadmg or 0
			
			if spelltype == "Q" or spelltype == "QM" then
				level = object:GetSpellData(_Q).level
			elseif spelltype == "W" or spelltype == "WM" then
				level = object:GetSpellData(_W).level
			elseif spelltype == "E" or spelltype == "EM" then
				level = object:GetSpellData(_E).level
			elseif spelltype == "R" then
				level = object:GetSpellData(_R).level
			else
				level = 1
			end
				
			
			
			if casttype == 1 or casttype == 2 or casttype == 3 then
				skilldamage, skillTypeDmg = getDmg(spelltype,target,object, casttype, level)
			end
						
			if skillTypeDmg == 2 then
				skilldamage = (skilldamage+adamage+onhitspelldmg+onhitdmg+muramanadmg)*1.07+onhittdmg+onhitspelltdmg
			else
				if skilldamage > 0 then skilldamage = (skilldamage+onhitspelldmg+muramanadmg)*1.07+onhitspelltdmg end
			end
			
		elseif spell.name:lower():find("summonerdot") then
			skilldamage = getDmg("IGNITE",target,object)
		end
	end
	
	local dmgpercent = skilldamage*100/target.health
	local dmgneeded = dmgpercent >= configused.mindmgpercent
	local hpneeded = configused.maxhppercent >= (target.health-skilldamage)*100/target.maxHealth
	
	if dmgneeded and hpneeded then
		shieldflag = true
	elseif (typeused == "shields" or typeused == "wall") and ((CC == 2 and configused.shieldcc) or (CC == 1 and configused.shieldslow)) then
		shieldflag = true
	end
	
	return shieldflag, dmgpercent
end

function OnDraw()
	if typeshield ~= nil and ASConfig then
		if ASConfig.drawcircles and not myHero.dead and (typeshield == 1 or typeshield == 2 or typeshield == 5) then
			DrawCircle(myHero.x, myHero.y, myHero.z, range, 0x19A712)
		end
		ASConfig.mindmg = math.floor(myHero.health*ASConfig.mindmgpercent/100)
	end
	
	if typeheal ~= nil and AHConfig then
		if AHConfig.drawcircles and not myHero.dead and (typeheal == 1 or typeheal == 2) then
			DrawCircle(myHero.x, myHero.y, myHero.z, healrange, 0x19A712)
		end
		AHConfig.mindmg = math.floor(myHero.health*AHConfig.mindmgpercent/100)
	end
	
	if typeult ~= nil and AUConfig then
		if AUConfig.drawcircles and not myHero.dead and typeult == 1 then
			DrawCircle(myHero.x, myHero.y, myHero.z, ultrange, 0x19A712)
		end
		AUConfig.mindmg = math.floor(myHero.health*AUConfig.mindmgpercent/100)
	end
	
	if wallslot ~= nil and WConfig then WConfig.mindmg = math.floor(myHero.health*WConfig.mindmgpercent/100) end
	if sbarrier ~= nil and ASBConfig then ASBConfig.mindmg = math.floor(myHero.health*ASBConfig.mindmgpercent/100) end
	if sheal ~= nil and ASHConfig then ASHConfig.mindmg = math.floor(myHero.health*ASHConfig.mindmgpercent/100) end
	if useitems and ASIConfig then ASIConfig.mindmg = math.floor(myHero.health*ASIConfig.mindmgpercent/100) end
end