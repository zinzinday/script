local version = "1.05"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/gmzopper/BoL/master/JungleBundle.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH


function CustomPrint(msg) PrintChat("<font color=\"#6699ff\"><b>[Jungle Bundle]</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
local ServerData = GetWebResult(UPDATE_HOST, "/gmzopper/BoL/master/version/JungleBundle.version")
if ServerData then
	ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
	if ServerVersion then
		if tonumber(version) < ServerVersion then
			CustomPrint("New version available "..ServerVersion)
			CustomPrint("Updating, please don't press F9")
			DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () _AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
		else
			CustomPrint("You have got the latest version ("..ServerVersion..")")
		end
	end
else
	CustomPrint("Error downloading version info")
end

----------------------
--    Requirements  --
---------------------- 

-- Champion not Suporteed --
local champions = {["Aatrox"] = true, ["Amumu"] = true, ["Chogath"] = true, ["Diana"] = true, ["Elise"] = true, ["Evelynn"] = true, ["FiddleSticks"] = true, 
	["Gragas"] = true, ["Hecarim"] = true, ["Jarvan"] = true, ["Jax"] = true, ["Kayle"] = true, ["Khazix"] = true, ["LeeSin"] = true,
	["MasterYi"] = true, ["Maokai"] = true, ["Nidalee"] = true, ["Nocturne"] = true, ["Nunu"] = true, ["Pantheon"] = true, ["Rammus"] = true, 
	["RekSai"] = true, ["Rengar"] = true, ["Sejuani"] = true, ["Shaco"] = true, ["Shyvana"] = true, ["Sion"] = true, ["Skarner"] = true,
	["Udyr"] = true, ["Vi"] = true, ["Volibear"] = true, ["Warwick"] = true, ["MonkeyKing"] = true, ["XinZhao"] = true, ["Zac"] = true}
if not champions[myHero.charName] then 
	CustomPrint(myHero.charName .. " isn't currently Supported")
	return 
end

if FileExist(LIB_PATH .. "/UPL.lua") then
  require("UPL")
  UPL = UPL()
else 
  CustomPrint("Downloading UPL, please don't press F9")
  DelayAction(function() DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Common/UPL.lua".."?rand="..math.random(1,10000), LIB_PATH.."UPL.lua", function () CustomPrint("Successfully downloaded UPL. Press F9 twice.") end) end, 3) 
  return
end

if FileExist(LIB_PATH .. "/VPrediction.lua") then
	require("VPrediction")
else
	CustomPrint("VPrediction is required, please download it and reload")
	return
end

----------------------
--   Script Status  --
----------------------

assert(load(Base64Decode("G0x1YVIAAQQEBAgAGZMNChoKAAAAAAAAAAAAAQIKAAAABgBAAEFAAAAdQAABBkBAAGUAAAAKQACBBkBAAGVAAAAKQICBHwCAAAQAAAAEBgAAAGNsYXNzAAQNAAAAU2NyaXB0U3RhdHVzAAQHAAAAX19pbml0AAQLAAAAU2VuZFVwZGF0ZQACAAAAAgAAAAgAAAACAAotAAAAhkBAAMaAQAAGwUAABwFBAkFBAQAdgQABRsFAAEcBwQKBgQEAXYEAAYbBQACHAUEDwcEBAJ2BAAHGwUAAxwHBAwECAgDdgQABBsJAAAcCQQRBQgIAHYIAARYBAgLdAAABnYAAAAqAAIAKQACFhgBDAMHAAgCdgAABCoCAhQqAw4aGAEQAx8BCAMfAwwHdAIAAnYAAAAqAgIeMQEQAAYEEAJ1AgAGGwEQA5QAAAJ1AAAEfAIAAFAAAAAQFAAAAaHdpZAAEDQAAAEJhc2U2NEVuY29kZQAECQAAAHRvc3RyaW5nAAQDAAAAb3MABAcAAABnZXRlbnYABBUAAABQUk9DRVNTT1JfSURFTlRJRklFUgAECQAAAFVTRVJOQU1FAAQNAAAAQ09NUFVURVJOQU1FAAQQAAAAUFJPQ0VTU09SX0xFVkVMAAQTAAAAUFJPQ0VTU09SX1JFVklTSU9OAAQEAAAAS2V5AAQHAAAAc29ja2V0AAQIAAAAcmVxdWlyZQAECgAAAGdhbWVTdGF0ZQAABAQAAAB0Y3AABAcAAABhc3NlcnQABAsAAABTZW5kVXBkYXRlAAMAAAAAAADwPwQUAAAAQWRkQnVnc3BsYXRDYWxsYmFjawABAAAACAAAAAgAAAAAAAMFAAAABQAAAAwAQACBQAAAHUCAAR8AgAACAAAABAsAAABTZW5kVXBkYXRlAAMAAAAAAAAAQAAAAAABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAUAAAAIAAAACAAAAAgAAAAIAAAACAAAAAAAAAABAAAABQAAAHNlbGYAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAtAAAAAwAAAAMAAAAEAAAABAAAAAQAAAAEAAAABAAAAAQAAAAEAAAABAAAAAUAAAAFAAAABQAAAAUAAAAFAAAABQAAAAUAAAAFAAAABgAAAAYAAAAGAAAABgAAAAUAAAADAAAAAwAAAAYAAAAGAAAABgAAAAYAAAAGAAAABgAAAAYAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAHAAAABwAAAAcAAAAIAAAACAAAAAgAAAAIAAAAAgAAAAUAAABzZWxmAAAAAAAtAAAAAgAAAGEAAAAAAC0AAAABAAAABQAAAF9FTlYACQAAAA4AAAACAA0XAAAAhwBAAIxAQAEBgQAAQcEAAJ1AAAKHAEAAjABBAQFBAQBHgUEAgcEBAMcBQgABwgEAQAKAAIHCAQDGQkIAx4LCBQHDAgAWAQMCnUCAAYcAQACMAEMBnUAAAR8AgAANAAAABAQAAAB0Y3AABAgAAABjb25uZWN0AAQRAAAAc2NyaXB0c3RhdHVzLm5ldAADAAAAAAAAVEAEBQAAAHNlbmQABAsAAABHRVQgL3N5bmMtAAQEAAAAS2V5AAQCAAAALQAEBQAAAGh3aWQABAcAAABteUhlcm8ABAkAAABjaGFyTmFtZQAEJgAAACBIVFRQLzEuMA0KSG9zdDogc2NyaXB0c3RhdHVzLm5ldA0KDQoABAYAAABjbG9zZQAAAAAAAQAAAAAAEAAAAEBvYmZ1c2NhdGVkLmx1YQAXAAAACgAAAAoAAAAKAAAACgAAAAoAAAALAAAACwAAAAsAAAALAAAADAAAAAwAAAANAAAADQAAAA0AAAAOAAAADgAAAA4AAAAOAAAACwAAAA4AAAAOAAAADgAAAA4AAAACAAAABQAAAHNlbGYAAAAAABcAAAACAAAAYQAAAAAAFwAAAAEAAAAFAAAAX0VOVgABAAAAAQAQAAAAQG9iZnVzY2F0ZWQubHVhAAoAAAABAAAAAQAAAAEAAAACAAAACAAAAAIAAAAJAAAADgAAAAkAAAAOAAAAAAAAAAEAAAAFAAAAX0VOVgA="), nil, "bt", _ENV))() ScriptStatus("REHGIIGMHEE") 

----------------------
--     Variables    --
----------------------

function Variables()
	--    Auto Shield   --
	typeshield = nil
	typeheal = nil

	spellslot = nil
	healslot = nil
	typeult = nil
	ultslot = nil
	wallslot = nil

	range = 0
	healrange = 0
	ultrange = 0
	shealrange = 300
	lisrange = 600
	FotMrange = 700

	sbarrier = nil
	sheal = nil
	sflash = nil
	ssmite = nil
	sdot = nil
	useitems = true
	spelltype = nil
	casttype = nil
	BShield,SShield,Shield,CC = false,false,false,false
	shottype,radius,maxdistance = 0,0,0
	hitchampion = false

	-- Interrupt Spells --
	Interrupt = {
		["Katarina"] = {charName = "Katarina", stop = {["KatarinaR"] = {name = "Death lotus", spellName = "KatarinaR", ult = true }}},
		["Nunu"] = {charName = "Nunu", stop = {["AbsoluteZero"] = {name = "Absolute Zero", spellName = "AbsoluteZero", ult = true }}},
		["Malzahar"] = {charName = "Malzahar", stop = {["AlZaharNetherGrasp"] = {name = "Nether Grasp", spellName = "AlZaharNetherGrasp", ult = true}}},
		["Caitlyn"] = {charName = "Caitlyn", stop = {["CaitlynAceintheHole"] = {name = "Ace in the hole", spellName = "CaitlynAceintheHole", ult = true, projectileName = "caitlyn_ult_mis.troy"}}},
		["FiddleSticks"] = {charName = "FiddleSticks", stop = {["Crowstorm"] = {name = "Crowstorm", spellName = "Crowstorm", ult = true}}},
		["Galio"] = {charName = "Galio", stop = {["GalioIdolOfDurand"] = {name = "Idole of Durand", spellName = "GalioIdolOfDurand", ult = true}}},
		["Janna"] = {charName = "Janna", stop = {["ReapTheWhirlwind"] = {name = "Monsoon", spellName = "ReapTheWhirlwind", ult = true}}},
		["MissFortune"] = {charName = "MissFortune", stop = {["MissFortune"] = {name = "Bullet time", spellName = "MissFortuneBulletTime", ult = true}}},
		["MasterYi"] = {charName = "MasterYi", stop = {["MasterYi"] = {name = "Meditate", spellName = "Meditate", ult = false}}},
		["Pantheon"] = {charName = "Pantheon", stop = {["PantheonRJump"] = {name = "Skyfall", spellName = "PantheonRJump", ult = true}}},
		["Shen"] = {charName = "Shen", stop = {["ShenStandUnited"] = {name = "Stand united", spellName = "ShenStandUnited", ult = true}}},
		["Urgot"] = {charName = "Urgot", stop = {["UrgotSwap2"] = {name = "Position Reverser", spellName = "UrgotSwap2", ult = true}}},
		["Warwick"] = {charName = "Warwick", stop = {["InfiniteDuress"] = {name = "Infinite Duress", spellName = "InfiniteDuress", ult = true}}},
	}
	
	-- General Variables --
	enemyMinions = nil
	jungleMinions = nil
	ts = nil

	-- Champion Variables --
	spells = {}
	buffs = {}
	auto = {}
	lastUsedWall = 0
	endPos, startPos = nil, nil

	-- Champion Specific Variables --
	if myHero.charName == "Aatrox" then
		spells[_Q] = {range = 650 + 100, delay = 0.5, speed = math.huge, width = 285, type = "circular", collision = false}
		spells[_W] = {range = math.ceil(Range(myHero))}
		spells[_E] = {range = 1075, delay = 0.25, speed = 1200, width = 150, type = "linear", collision = false}
		spells[_R] = {range = 0, delay = 0.25, speed = math.huge, width = 550, type = "circular", collision = false}
		
		auto["interrupt"] = {_Q}
	elseif myHero.charName == "Amumu" then
		spells[_Q] = {range = 1100, delay = 0.25, speed = 2000, width = 80, type = "linear", collision = true}
		spells[_W] = {range = 0, delay = 0, speed = math.huge, width = 300, type = "circular", collision = false}
		spells[_E] = {range = 0, delay = 0.25, speed = math.huge, width = 350, type = "circular", collision = false}
		spells[_R] = {range = 0, delay = 0.25, speed = math.huge, width = 550, type = "circular", collision = false}
		
		auto["interrupt"] = {_R}
	elseif myHero.charName == "Chogath" then
		spells[_Q] = {range = 950, delay = 0.5, speed = math.huge, width = 250, type = "circular", collision = false}
		spells[_W] = {range = 650, delay = 0.5, speed = math.huge, width = 345, type = "linear", collision = false}
		spells[_E] = {range = math.ceil(Range(myHero))}
		spells[_R] = {range = math.ceil(Range(myHero))}
		
		auto["interrupt"] = {_Q}
	elseif myHero.charName == "Diana" then
		spells[_Q] = {range = 900, delay = 0.25, speed = 1600, width = 185, type = "circular", collision = false}
		spells[_W] = {range = math.ceil(Range(myHero))}
		spells[_E] = {range = 0, delay = 0.25, speed = math.huge, width = 900, type = "circular", collision = false}
		spells[_R] = {range = 825}
		
		auto["interrupt"] = {_E}
		auto["combo"] = {_Q, _W, _E, _R}
		auto["ks"] = {_Q, _R}
		
		buffs["R"] = 0
	elseif myHero.charName == "Elise" then
		spells[_Q] = {range = 625}
		spells[_W] = {range = 950, delay = 0.125, speed = 1000, width = 100, type = "linear", collision = true}
		spells[_E] = {range = 1100, delay = 0.25, speed = 1600, width = 55, type = "linear", collision = true}
	elseif myHero.charName == "Evelynn" then
		spells[_Q] = {range = 500}
		spells[_W] = {range = math.ceil(Range(myHero))}
		spells[_E] = {range = 225}
		spells[_R] = {range = 650, delay = 0.25, speed = 1250, width = 350, type = "circular", collision = false}
	elseif myHero.charName == "Fiddlesticks" then
		spells[_Q] = {range = 575}
		spells[_W] = {range = 575}
		spells[_E] = {range = 750}
		
		auto["interrupt"] = {_Q, _E}
	elseif myHero.charName == "Gragas" then
		spells[_Q] = {range = 850, delay = 0.25, speed = 1000, width = 250, type = "circular", collision = false}
		spells[_W] = {range = math.ceil(Range(myHero))}
		spells[_E] = {range = 600, delay = 0.25, speed = 2800, width = 50, type = "linear", collision = true}
		spells[_R] = {range = 1150, delay = 0.5, speed = math.huge, width = 350, type = "circular", collision = false}
		
		auto["interrupt"] = {_E, _R}
	elseif myHero.charName == "RekSai" then
		spells[_Q] = {range = 1650, delay = 0.125, speed = 4000, width = 60, type = "linear", collision = true}
		spells[_E] = {range = 750, delay = 0.25, speed = 1600, width = 100, type = "linear", collision = false, ignoreRange = true}
		
		auto["wall"] = true
		auto["afterAttack"] = true
		auto["ks"] = {_Q, _E}
	elseif myHero.charName == "Zac" then
		spells[_Q] = {range = 550, delay = 0.25, speed = math.huge, width = 120, type = "linear", collision = false}
		spells[_W] = {range = 0, delay = 0.25, speed = math.huge, width = 700, type = "circular", collision = false}
		spells[_E] = {range = 1600, delay = 0.125, speed = 1500, width = 300, type = "circular", collision = false}
		spells[_R] = {range = 0, delay = 0.25, speed = math.huge, width = 600, type = "circular", collision = false}
		
		auto["interrupt"] = {_E, _R}
		auto["ks"] = {_Q, _W}
		auto["afterAttack"] = true
		auto["combo"] = {_Q, _W, _E, _R}
		
		buffs["ZacE"] = 0
		buffs["canMove"] = true
		blobs = {}
	end 
	
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerbarrier") then sbarrier = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerbarrier") then sbarrier = SUMMONER_2 end
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerheal") then sheal = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerheal") then sheal = SUMMONER_2 end
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerflash") then sflash = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerflash") then sflash = SUMMONER_2 end
	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then sdot = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then sdot = SUMMONER_2 end
	if myHero:GetSpellData(SUMMONER_1).name:find("summonersmite") then ssmite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonersmite") then ssmite = SUMMONER_2 end
	
	items = {
		['ItemTiamatCleave']          = {true, name = "ItemTiamatCleave", displayName = "Tiamat", range = 400},
		['YoumusBlade']               = {true, name = "YoumusBlade", displayName = "Youmus Blade", range = 400},
		['BilgewaterCutlass']         = {true, name = "BilgewaterCutlass", displayName = "Bilgewater Cutlass", range = 550},
		['ItemSwordOfFeastAndFamine'] = {true, name = "ItemSwordOfFeastAndFamine", displayName = "Blade of the Ruined King", range = 550},
	}
end

function OnLoad()
	Variables()
	Menu()
	LoadSpells()

	enemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_MAXHEALTH_ASC)
	jungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, MINION_SORT_MAXHEALTH_DES)
	VPred = VPrediction()
	
	if auto["afterAttack"] then ZOrbWalker:RegisterAfterAttackCallback(function(unit) AfterAttack(unit) end) end
	
	-- Disable SAC:R movement --
	DisableSAC()
	
	CustomPrint("Ready to use, enjoy.")
end

function DisableSAC()
	if _G.AutoCarry then
		_G.AutoCarry.MyHero:MovementEnabled(false)
		_G.AutoCarry.MyHero:AttacksEnabled(false)
		CustomPrint("SAC:R has been disabled, using ZOrbWalker")
	elseif _G.Reborn_Loaded then
		DelayAction(function() DisableSAC() end, 1)
	end
end

function OnProcessSpell(object,spell)
	if object.isMe then
		if spell.name == "DianaTeleport" then
			buffs["R"] = os.clock() * 1000
		elseif spell.name == "ZacE" then 
			DelayAction(function() buffs["ZacE"] = 0 ZOrbWalker:EnableMove() end, 4)
			ZOrbWalker:DisableMove()
			buffs["canMove"] = false
			buffs["ZacE"] = os.clock()  * 1000 + 125
		end
	end

	-- Auto Shield Process Spell --
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
		
		local lisReady = lisslot ~= nil and myHero:CanUseSpell(lisslot) == READY
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
						if shieldREADY and settings.as["teammateshield"..i] and ((typeshield<=4 and Shield) or (typeshield==5 and BShield) or (typeshield==6 and SShield)) then
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
						
						if healREADY and settings.ah["teammateheal"..i] and Shield then
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
						
						if ultREADY and settings.au["teammateult"..i] and Shield then
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
						
						if wallREADY and settings.aw.wallon and allytarget.isMe and YWall then
							local wallflag, dmgpercent = shieldCheck(object,spell,allytarget,"wall")
							if wallflag then
								CastSpell(wallslot,object.x,object.z)
							end
						end
						
						if sbarrierREADY and settings.asb.barrieron and allytarget.isMe and Shield then
							local barrierflag, dmgpercent = shieldCheck(object,spell,allytarget,"barrier")
							if barrierflag then
								CastSpell(sbarrier)
							end
						end
						
						if shealREADY and settings.ash["teammatesheal"..i] and Shield then
							if GetDistance(allytarget)<=shealrange then
								local shealflag, dmgpercent = shieldCheck(object,spell,allytarget,"sheals")
								if shealflag then
									CastSpell(sheal)
								end
							end
						end
						
						if lisReady and settings.asi["teammateshieldi"..i] and Shield then
							if GetDistance(allytarget)<=lisrange then
								local lisflag, dmgpercent = shieldCheck(object,spell,allytarget,"items")
								if lisflag then
									CastSpell(lisslot)
								end
							end
						end
						
						if FotMREADY and settings.asi["teammateshieldi"..i] and Shield then
							if GetDistance(allytarget)<=FotMrange then
								local FotMflag, dmgpercent = shieldCheck(object,spell,allytarget,"items")
								if FotMflag then
									CastSpell(FotMslot, allytarget)
								end
							end
						end
						
						if seREADY and settings.asi["teammateshieldi"..i] and allytarget.isMe and Shield then
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

	-- Auto Interrupt --
	if auto["interrupt"] ~= nil then
		if not myHero.dead and myHero.team ~= object.team then
			if Interrupt[object.charName] ~= nil then
				if Interrupt[object.charName].stop[spell.name] ~= nil then
					if settings.interrupt[spell.name] then
						if myHero.charName == "Diana" then
							if settings.interrupt[GetSpellData(_E).name] and IsReady(_E) and GetDistance(object) < GetRange(_E) then CastSpell(_E) return end
						elseif myHero.charName == "Zac" then
							if settings.interrupt[GetSpellData(_E).name] and IsReady(_E) and GetDistance(object) < GetRange(_E) then ZacCastE(object) return end
							if settings.interrupt[GetSpellData(_R).name] and IsReady(_R) and GetDistance(object) < GetRange(_R) then CastSpell(_R, object) return end
						end
					end
				end
			end
		end
	end
end

-- Block movement --
function OnSendPacket(p)
	if tostring(p.header) == "38" and buffs["moveBlock"] and settings.key.comboKey then 
		p:Block() 
	end
end

function OnTick()
	enemyMinions:update()
	jungleMinions:update()
	
	KS()
	Combo(GetTarget())
	Automatic()
	if settings.key.clearKey then LaneClear() end
end

function OnDraw()
	Target = GetTarget()		
	if settings.draw.target and ValidTarget(Target) then
		DrawCircle(Target.x, Target.y, Target.z, 150, 0xffffff00)
	end
	
	for slot = _Q, _R  do
		if spells[slot] then
			if myHero.charName == "RekSai" and not GetSpellData(slot).name:lower():find("burrow") then break end
			
			if myHero.charName == "Zac" and slot == _E and IsReady(_E) then
				DrawCircle(myHero.x, myHero.y, myHero.z, 1100 + 100 * GetSpellData(_E).level, 0xFFFF0000)
			else
				if settings.draw[GetSpellData(slot).name] and IsReady(slot) then
					DrawCircle(myHero.x, myHero.y, myHero.z, GetRange(slot), 0xFFFF0000)
				end
			end
			
			if ValidTarget(Target) and settings.draw[GetSpellData(slot).name .. "collision"] and IsReady(slot) then
				local IsCollision = VPred:CheckMinionCollision(Target, Target.pos, spells[slot].delay, spells[slot].width, GetRange(slot), spells[slot].speed, myHero.pos,nil, true)
				DrawLine3D(myHero.x, myHero.y, myHero.z, Target.x, Target.y, Target.z, 5, IsCollision and ARGB(125, 255, 0,0) or ARGB(125, 0, 255,0))
			end
		end
	end
	
	if startPos and endPos and (settings.key.runKey or (settings.key.comboKey and settings.wall.auto)) then
		local drawEndPos = endPos
		if myHero.charName == "RekSai" then
			drawEndPos = startPos + 750 * (Vector(endPos) - Vector(startPos)):normalized()
		elseif myHero.charName == "Zac" then
			local range = GetDistance(startPos, mousePos) > (1100 + 100 * GetSpellData(_E).level) and (1100 + 100 * GetSpellData(_E).level - 300) or GetDistance(startPos, mousePos)
			drawEndPos = startPos + range * (Vector(mousePos) - Vector(startPos)):normalized()
		end
	
		DrawCircle(startPos.x, startPos.y, startPos.z, 100, 0xFFFFFF00)
		DrawCircle(drawEndPos.x, drawEndPos.y, drawEndPos.z, 100, 0xFFFFFF00)
		DrawLine3D(startPos.x, startPos.y, startPos.z, drawEndPos.x, drawEndPos.y, drawEndPos.z, 3, ARGB(125, 255, 255,0))
	end
	
	if myHero.charName == "Zac" and buffs["ZacE"] > 0 then
		local timeDifference = os.clock() * 1000 - buffs["ZacE"] < (0.8 + 0.1 * GetSpellData(_E).level) * 1000 and os.clock() * 1000 - buffs["ZacE"] or (0.8 + 0.1 * GetSpellData(_E).level) * 1000
		DrawCircle(myHero.x, myHero.y, myHero.z, timeDifference  *  (1100 + 100 * GetSpellData(_E).level - 300) / ((0.8 + 0.1 * GetSpellData(_E).level) * 1000) + 300, 0xFFFF0000)
	end
end

function OnWndMsg(msg,key)
	if msg == WM_LBUTTONDOWN then
		local enemy, distance = ClosestEnemy(mousePos) 
		
		if distance < 150 then SelectedTarget = enemy
		else SelectedTarget = nil end
	end
end

----------------------
--     Functions    --
----------------------

function SpellName(slot)
	local spellName = GetSpellData(slot).name
	if myHero.charName == "RekSai" and slot == _Q then spellName = "reksaiqburrowed" end
	if myHero.charName == "RekSai" and slot == _E then spellName = "reksaieburrowed" end
	return spellName
end

function Menu()
	settings = scriptConfig("Jungle Bundle", "Zopper")
	
	-- Spell Settings --
	settings:addSubMenu("[" .. myHero.charName .. "] - Spell Settings", "spell")	
		for slot = _Q, _R  do
			if myHero.charName == "RekSai" and slot == _W then
				settings.spell:addSubMenu("[" .. myHero.charName .. "] - " .. SpellPosition(slot), "RekSaiW")
					settings.spell["RekSaiW"]:addParam("heal", "Use automatically to heal", SCRIPT_PARAM_ONOFF, true)
					settings.spell["RekSaiW"]:addParam("range", "Closest unit range", SCRIPT_PARAM_SLICE, 800, 0, 1500, 0)
			end
		
			if spells[slot] then
				settings.spell:addSubMenu("[" .. myHero.charName .. "] - " .. SpellPosition(slot), SpellName(slot))
				
					settings.spell[SpellName(slot)]:addParam("combo", "Combo", SCRIPT_PARAM_ONOFF, true)
					
					if slot == _R then 
						settings.spell[SpellName(slot)]:addParam("harass", "Harass", SCRIPT_PARAM_ONOFF, false)
					else
						settings.spell[SpellName(slot)]:addParam("harass", "Harass", SCRIPT_PARAM_ONOFF, true)
					end
					
					if spells[slot].range ~= nil and not spells[slot].ignoreRange then
						settings.spell[SpellName(slot)]:addParam("range", "Maximum range", SCRIPT_PARAM_SLICE, LoadRange(slot), 0, LoadRange(slot), 0)
					end
			end
		end
		
	if myHero.charName == "Diana" then
		settings.spell[SpellName(_R)]:addParam("mode", "Combo Mode", SCRIPT_PARAM_LIST, 1, { "R -> Q", "Q -> R"})
	end
		
	settings:addSubMenu("[" .. myHero.charName .. "] - Items", "items")
		for i, item in pairs(items) do
			settings.items:addParam(item.name, "Use " .. item.displayName, SCRIPT_PARAM_ONOFF, true)
		end
		
	if auto["wall"] then
		settings:addSubMenu("[" .. myHero.charName .. "] - Wall Jump", "wall")
			settings.wall:addParam("auto", "Wall jump automatically in Combo", SCRIPT_PARAM_ONOFF, true)
	end
		
	-- KS --
	if auto["ks"] or sdot or ssmite then 
		settings:addSubMenu("[" .. myHero.charName .. "] - KS", "ks")
		
			if myHero.charName == "RekSai" then
				settings.ks:addParam("reksaiqburrowed", "Use Burrowed Q", SCRIPT_PARAM_ONOFF, true)
				settings.ks:addParam("RekSaiE", "Use Unburrowed E", SCRIPT_PARAM_ONOFF, true)
			else
				if auto["ks"] then 
					for i, slot in pairs(auto["ks"]) do
						settings.ks:addParam(SpellName(slot), "Use " .. SpellPosition(slot), SCRIPT_PARAM_ONOFF, true)
					end
				end
			end
			
			if sdot then settings.ks:addParam("dot", "Use Ignite", SCRIPT_PARAM_ONOFF, true) end
			if ssmite then settings.ks:addParam("smite", "Use Smite", SCRIPT_PARAM_ONOFF, true) end
	end
	
	-- Auto Interrupt --
	if auto["interrupt"] ~= nil then 
		settings:addSubMenu("[" .. myHero.charName .. "] - Auto-Interrupt", "interrupt")
			for i, slot in pairs(auto["interrupt"]) do
				settings.interrupt:addParam(SpellName(slot), "Use " .. SpellPosition(slot), SCRIPT_PARAM_ONOFF, true)
			end
			
			settings.interrupt:addParam("info", "-- Auto Interrupt Spells --", SCRIPT_PARAM_INFO, "")
			
			for i, enemy in pairs(GetEnemyHeroes()) do
				if Interrupt[enemy.charName] ~= nil then
					for i, spell in pairs(Interrupt[enemy.charName].stop) do
						settings.interrupt:addParam(spell.spellName, enemy.charName .." - " .. spell.name, SCRIPT_PARAM_ONOFF, true)
					end
				end
			end
	end
	
	settings:addSubMenu("[" .. myHero.charName.. "] - Draw Settings", "draw")
		settings.draw:addParam("target", "Draw Target", SCRIPT_PARAM_ONOFF, true)
		
		for slot = _Q, _R  do
			if spells[slot] then
				if spells[slot].range ~= nil then
					settings.draw:addParam(SpellName(slot), "Draw " .. SpellPosition(slot), SCRIPT_PARAM_ONOFF, true)
				end
				
				if spells[slot].collision ~= nil and spells[slot].type ~= nil and spells[slot].collision == true and spells[slot].type == "linear" then
					settings.draw:addParam(SpellName(slot) .. "collision", "Draw collision for " .. SpellPosition(slot), SCRIPT_PARAM_ONOFF, true)
				end
			end
		end
		
	settings:addSubMenu("[" .. myHero.charName.. "] - Keys", "key")
		settings.key:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		settings.key:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		settings.key:addParam("clearKey", "Lane/Jungle Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
		settings.key:addParam("runKey", "Run Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
			
		settings.key:permaShow("comboKey")
		settings.key:permaShow("harassKey")
		settings.key:permaShow("clearKey")
		settings.key:permaShow("runKey")
	
	-- Auto Shield --
	if typeshield ~= nil then
		settings:addSubMenu("[AS] - Auto Shield", "as")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team then settings.as:addParam("teammateshield"..i, "Shield "..teammate.charName, SCRIPT_PARAM_ONOFF, true) end
		end
		settings.as:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)	
		settings.as:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
		settings.as:addParam("skillshots", "Shield Skillshots", SCRIPT_PARAM_ONOFF, true)
		settings.as:addParam("shieldcc", "Auto Shield Hard CC", SCRIPT_PARAM_ONOFF, true)
		settings.as:addParam("shieldslow", "Auto Shield Slows", SCRIPT_PARAM_ONOFF, true)
	end
	
	-- Auto Heal -- 
	if typeheal ~= nil then
		settings:addSubMenu("[AS] - Auto Heal", "ah")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team then settings.ah:addParam("teammateheal"..i, "Heal "..teammate.charName, SCRIPT_PARAM_ONOFF, true) end
		end
		settings.ah:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)	
		settings.ah:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
		settings.ah:addParam("skillshots", "Heal Skillshots", SCRIPT_PARAM_ONOFF, true)
	end
	
	-- Auto Ult --
	if typeult ~= nil then
		settings:addSubMenu("[AS] - Auto Ultimate", "au")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team then settings.au:addParam("teammateult"..i, "Ult "..teammate.charName, SCRIPT_PARAM_ONOFF, true) end
		end
		settings.au:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)	
		settings.au:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
		settings.au:addParam("skillshots", "Skillshots", SCRIPT_PARAM_ONOFF, true)
	end
	
	-- Auto Wall --
	if wallslot ~= nil then
		settings:addSubMenu("[AS] - Auto Wall", "aw")
		settings.aw:addParam("wallon", "Auto Wall", SCRIPT_PARAM_ONOFF, true)
		settings.aw:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)	
		settings.aw:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 10, 0, 100, 0)
		settings.aw:addParam("skillshots", "Shield Skillshots", SCRIPT_PARAM_ONOFF, true)
		settings.aw:addParam("shieldcc", "Auto Shield Hard CC", SCRIPT_PARAM_ONOFF, true)
		settings.aw:addParam("shieldslow", "Auto Shield Slows", SCRIPT_PARAM_ONOFF, true)
	end
	
	-- Auto Barrier --
	if sbarrier ~= nil then
		settings:addSubMenu("[AS] - Auto Summoner Barrier", "asb")
		settings.asb:addParam("barrieron", "Barrier", SCRIPT_PARAM_ONOFF, true)
		settings.asb:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
		settings.asb:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 95, 0, 100, 0)
		settings.asb:addParam("skillshots", "Shield Skillshots", SCRIPT_PARAM_ONOFF, true)
	end
	
	-- Auto Heal --
	if sheal ~= nil then
		settings:addSubMenu("[AS] - Auto Summoner Heal", "ash")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team then settings.ash:addParam("teammatesheal"..i, "Heal "..teammate.charName, SCRIPT_PARAM_ONOFF, false) end
		end
		settings.ash:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
		settings.ash:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 95, 0, 100, 0)
		settings.ash:addParam("skillshots", "Heal Skillshots", SCRIPT_PARAM_ONOFF, true)
	end

	-- Auto Items --
	if useitems then
		settings:addSubMenu("[AS] - Auto Shield Items", "asi")
		for i=1, heroManager.iCount do
			local teammate = heroManager:GetHero(i)
			if teammate.team == myHero.team then settings.asi:addParam("teammateshieldi"..i, "Shield "..teammate.charName, SCRIPT_PARAM_ONOFF, true) end
		end
		settings.asi:addParam("maxhppercent", "Max percent of hp", SCRIPT_PARAM_SLICE, 100, 0, 100, 0)
		settings.asi:addParam("mindmgpercent", "Min dmg percent", SCRIPT_PARAM_SLICE, 30, 0, 100, 0)
		settings.asi:addParam("skillshots", "Shield Skillshots", SCRIPT_PARAM_ONOFF, true)
	end
	
	SetupOrbwalk()
    UPL:AddToMenu(settings) 
end

function SetupOrbwalk()
	ZOrbWalker()
end

-- Auto Shield Function --
function shieldCheck(object,spell,target,typeused)
	local configused
	
	if typeused == "shields" then configused = settings.as
	elseif typeused == "heals" then configused = settings.ah
	elseif typeused == "ult" then configused = settings.au
	elseif typeused == "wall" then configused = settings.aw
	elseif typeused == "barrier" then configused = settings.asb 
	elseif typeused == "sheals" then configused = settings.ash
	elseif typeused == "items" then configused = settings.asi end
	
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


function LoadSpells()
	for spell = _Q, _R  do
		if spells[spell] and spells[spell].type ~= nil then
			UPL:AddSpell(spell, { speed = spells[spell].speed, delay = spells[spell].delay, range = spells[spell].range, width = spells[spell].width, collision = spells[spell].collision, aoe = spells[spell].aoe, type = spells[spell].type })
		end
	end
end

function ClosestEnemy(pos)
	if pos == nil then return math.huge, nil end
	local closestEnemy, distanceEnemy = nil, math.huge
	
	for i, enemy in pairs(GetEnemyHeroes()) do
		if not enemy.dead then 
			if GetDistance(pos, enemy) < distanceEnemy then
				distanceEnemy = GetDistance(pos, enemy)
				closestEnemy = enemy
			end
		end
	end
	
	return closestEnemy, distanceEnemy
end

-- Get Health between 0-100 --
function GetHealthPercent(unit)
    local obj = unit or myHero
    return (obj.health / obj.maxHealth) * 100
end

-- Get Mana between 0-100 --
function GetManaPercent(unit)
    local obj = unit or myHero
    return (obj.mana / obj.maxMana) * 100
end

-- Get inventory slot --
function CustomGetInventorySlotItem(item, unit)
	for slot = ITEM_1, ITEM_7 do
		if unit:GetSpellData(slot).name:lower() == item:lower() then
			return slot
		end
	end
	
	return nil
end

-- Get the spell with biggest range --
function BiggestRange()
	local range = Range(myHero)
	
	if myHero.charName == "RekSai" then range = 1650 end
	
	if auto["combo"] then
		for i, slot in pairs(auto["combo"]) do
			if IsReady(slot) and range < GetRange(slot) then range = GetRange(slot) end
		end
	end
	
	return range
end

-- Get Target --
function GetTarget()
	local bestEnemy, enemyCoef = nil, math.huge
	for i, enemy in pairs(GetEnemyHeroes()) do
		if not enemy.dead and enemy.visible and GetDistance(enemy) < Range(myHero) and enemyCoef > enemy.health / myHero:CalcDamage(enemy) then
			enemyCoef = enemy.health / myHero:CalcDamage(enemy)
			bestEnemy = enemy
		end
	end

	if SelectedTarget and not SelectedTarget.dead and SelectedTarget.type == myHero.type and SelectedTarget.team ~= myHero.team then
		if GetDistance(SelectedTarget) > BiggestRange() and bestEnemy then
			return bestEnemy
		else
			return SelectedTarget
		end
	end
	
	local bestEnemy, enemyCoef = nil, math.huge
	for i, enemy in pairs(GetEnemyHeroes()) do
		if not enemy.dead and enemy.visible and GetDistance(enemy) < BiggestRange() and enemyCoef > enemy.health / myHero:CalcDamage(enemy) then
			enemyCoef = enemy.health / myHero:CalcDamage(enemy)
			bestEnemy = enemy
		end
	end
	return bestEnemy
end

function SpellPosition(slot)
	if slot == _Q then return "Q"
	elseif slot == _W then return "W"
	elseif slot == _E then return "E"
	elseif slot == _R then return "R"
	end
end

function Range(unit)
	return unit.range + GetDistance(unit, unit.minBBox)
end

function Latency()
	return GetLatency() / 2000
end

----------------------
--  Spell Functions --
----------------------
----------------------
--     General      --
----------------------

function CustomCast(spell, target, from, chance)
	from = from or myHero
	chance = chance or 2
	
	if target == nil or target.dead then return end
	if myHero.dead then return end
	if CanUseSpell(spell) ~= READY then return end
	
	if target.isMe then CastSpell(spell) end
	if spells[spell].type ~= nil and spells[spell].width ~= nil and spells[spell].delay ~= nil and spells[spell].range ~= nil and spells[spell].width ~= nil then
		local CastPosition, HitChance, HeroPosition = UPL:Predict(spell, from, target)
		if HitChance >= chance then
			CastSpell(spell, CastPosition.x, CastPosition.z)
		end
	else
		CastSpell(spell, target)
	end
end

function IsReady(spell)
	if not spell then return false end
	return CanUseSpell(spell) == READY and true or false
end

function UseSpell(slot)
	if myHero.charName == "RekSai" and GetSpellData(slot).name == "reksaieburrowed" and settings.key.harassKey then return false end

	if not IsReady(slot) then return false end
	if not settings.spell[GetSpellData(slot).name] and (settings.key.comboKey  or settings.key.harassKey) then return true end
	if not settings.spell[GetSpellData(slot).name] then return false end
	if settings.spell[GetSpellData(slot).name] and settings.spell[GetSpellData(slot).name].combo == nil and (settings.key.comboKey  or settings.key.harassKey) then return true end
	if settings.key.comboKey and settings.spell[GetSpellData(slot).name].combo then return true end
	if settings.key.harassKey and settings.spell[GetSpellData(slot).name].harass then return true end
	return false
end
 
function LoadRange(slot)
	if spells[slot].range > 0 then return spells[slot].range
	else return math.floor(spells[slot].width / 2) end
end
 
function GetRange(slot)
	if settings.spell[GetSpellData(slot).name] and settings.spell[GetSpellData(slot).name].range then return settings.spell[GetSpellData(slot).name].range end
	if spells[slot].range > 0 then return spells[slot].range
	else return math.floor(spells[slot].width / 2) end
	return 0
end

function HasBuff(unit, buffname)
    for i = 1, unit.buffCount do
        local tBuff = unit:getBuff(i)
        if tBuff.valid and BuffIsValid(tBuff) and tBuff.name == buffname then
            return true
        end
    end
    return false
end

----------------------
--     Spells       --
----------------------

function Combo(unit)
	if not ValidTarget(unit) then return end
	
	if settings.key.comboKey then
		for slot = ITEM_1, ITEM_7 do
			if items[GetSpellData(slot).name] then
				if settings.items[GetSpellData(slot).name] and GetDistance(unit) < items[GetSpellData(slot).name].range then
					CastSpell(slot, unit)
				end
			end
		end
	end
	
	if myHero.charName == "Diana" then
		if UseSpell(_E) and GetDistance(unit) < GetRange(_E) and GetDistance(unit) > Range(myHero) then 
			local Position = VPred:GetPredictedPos(unit, 0.25)
			if GetDistance(Position) < GetRange(_E) then
				CastSpell(_E)
			end
		end
		if UseSpell(_W) and GetDistance(unit) < GetRange(_W) then CastSpell(_W) end
		if UseSpell(_R) and UseSpell(_Q) and GetDistance(unit) < GetRange(_R) and myHero.mana > GetSpellData(_R).mana + GetSpellData(_Q).mana and settings.spell[SpellName(_R)].mode == 1 then
			CustomCast(_Q, unit)
			DelayAction(function(t) CastSpell(_R, unit) end, 0.01, {unit})
		end
		if UseSpell(_Q) and GetDistance(unit) < GetRange(_Q) and settings.spell[SpellName(_R)].mode == 2 then CustomCast(_Q, unit) end
		if UseSpell(_R) and GetDistance(unit) < GetRange(_R) and settings.spell[SpellName(_R)].mode == 2 and HasBuff(unit, "dianamoonlight") and os.clock() * 1000 - buffs["R"] > 2500 then CastSpell(_R, unit) end
		if UseSpell(_Q) and (GetSpellData(_R).level == 0 or GetSpellData(_R).currentCd > GetSpellData(_Q).cd) and GetDistance(unit) < GetRange(_Q) then CustomCast(_Q, unit) end
	elseif myHero.charName == "RekSai" then
		if GetSpellData(_Q).name:find("burrow") then
			if UseSpell(_Q) and GetDistance(unit) < GetRange(_Q) then CustomCast(_Q, unit) end
			if UseSpell(_E) then
				local CastPosition, HitChance, HeroPosition = UPL:Predict(_E, myHero, unit)
				if GetDistance(CastPosition) > 600 and GetDistance(CastPosition) < 900 then CastSpell(_E, CastPosition.x, CastPosition.z) end
			end
		else
			if UseSpell(_E) and GetDistance(unit) < Range(myHero) and (myHero.mana == 100 or getDmg("E", unit, myHero) > unit.health * 0.95) then CastSpell(_E, unit) end
			if UseSpell(_W) and GetDistance(unit) > Range(myHero) then CastSpell(_W) end
		end
	elseif myHero.charName == "Zac" then
		if buffs["canMove"] then
			if UseSpell(_Q) and GetDistance(unit) < GetRange(_Q) then CustomCast(_Q, unit) end
			if UseSpell(_W) and GetDistance(unit) < GetRange(_W) then 
				local Position = VPred:GetPredictedPos(unit, 0.25)
				if GetDistance(Position) < GetRange(_W) then
					CastSpell(_W)
				end
			end
			if UseSpell(_E) and GetDistance(unit) < GetRange(_E) then ZacCastE(unit) end
			if UseSpell(_R) and GetDistance(unit) < GetRange(_R) then CastSpell(_R, unit) end
		else 
			if not IsReady(_E) then
				buffs["canMove"] = true
				ZOrbWalker:EnableMove()
			end
		end
	end
end

function Automatic()
	if auto["wall"] and settings.wall and (settings.key.runKey or (settings.key.comboKey and settings.wall.auto)) and os.clock() * 1000 - lastUsedWall > 200 then
		local p1, p2 = GetRoute()
		lastUsedWall = os.clock() * 1000
		
		if p1 and p2 and GetDistance(p1, p2) > 50 then
			if not startPos then
				startPos, endPos = p1, p2
			elseif GetDistance(p1, startPos) > 50 or GetDistance(p2, endPos) > 50 then
				startPos, endPos = p1, p2
			end
		end
		
		if startPos and endPos then
			if myHero.charName == "RekSai" and GetSpellData(_E).name == "reksaieburrowed" and IsReady(_E) then
				JumpWall(750)
				
				if startPos and endPos and GetDistance(startPos) < 75 then
					CastSpell(_E, endPos.x, endPos.z)
				end
			else
				startPos, endPos = nil, nil
			end
		else
			ZOrbWalker:EnableMove()
		end
		
		if not startPos and settings.key.runKey then
			ZOrbWalker:GoTo(mousePos)
		end
	end

	if myHero.charName == "RekSai" then
		if settings.spell["RekSaiW"].heal and not (settings.key.comboKey or settings.key.harassKey) and GetSpellData(_W).name == "RekSaiW" and myHero.mana > 0 and myHero.health < myHero.maxHealth then
			local closestRange = math.huge
			for i, unit in pairs(enemyMinions.objects) do if GetDistance(unit) < closestRange then closestRange = GetDistance(unit) end end
			for i, unit in pairs(jungleMinions.objects) do if GetDistance(unit) < closestRange then closestRange = GetDistance(unit) end end
			
			if closestRange > settings.spell["RekSaiW"].range then
				CastSpell(_W) 
			end
		end
	end
end

function JumpWall(range)
	if GetDistance(startPos, endPos) < range then
		ZOrbWalker:GoTo(startPos)
		ZOrbWalker:DisableMove()
		DelayAction(function() if not (settings.key.runKey or (settings.key.comboKey and settings.wall.auto) and auto["wall"]) then ZOrbWalker:EnableMove() end end, 0.2)
	else
		startPos, endPos = nil, nil
	end
end

function GetRoute()
	local counter, startP, endP  = 1, nil, nil
		
	while true do
		local point = Vector(myHero) + counter * 20 * (Vector(mousePos) - Vector(myHero)):normalized()
		
		if IsWall(D3DXVECTOR3(point.x, point.y, point.z)) and not startP then
			startP = Vector(myHero) + (counter - 1) * 20 * (Vector(mousePos) - Vector(myHero)):normalized()
		elseif not IsWall(D3DXVECTOR3(point.x, point.y, point.z)) and startP then
			endP = Vector(myHero) + counter * 20 * (Vector(mousePos) - Vector(myHero)):normalized()
			break
		end
		
		if GetDistance(point, mousePos) < 20 then break end
		
		counter = counter + 1
	end
	
	return startP, endP
end

function AfterAttack(unit)
	if myHero.charName == "RekSai" then
		if not GetSpellData(_Q).name:find("burrow") and UseSpell(_Q) and GetDistance(unit) < Range(myHero) then CastSpell(_Q, unit) end
	end
end 

function LaneClear()
	for i, unit in pairs(enemyMinions.objects) do 
		if GetDistance(unit) < 1000 then
			LaneClearSpells(unit, "lane")
			return
		end
	end
	
	for i, unit in pairs(jungleMinions.objects) do 
		LaneClearSpells(unit, "jungle")
	end
end

function LaneClearSpells(unit, mode)
	if myHero.charName == "Diana" then
		if IsReady(_W) and GetDistance(unit) < GetRange(_W) then CastSpell(_W) end
		if IsReady(_R) and IsReady(_Q) and GetDistance(unit) < GetRange(_R) and myHero.mana > GetSpellData(_R).mana + GetSpellData(_Q).mana and mode == "jungle" then
			CastSpell(_Q, unit)
			DelayAction(function(t) CastSpell(_R, t) end, 0.01, {unit})
		end
		if IsReady(_Q) and GetDistance(unit) < GetRange(_Q) then CastSpell(_Q, unit) end
	elseif myHero.charName == "RekSai" then
		if GetSpellData(_Q).name:find("burrow") then
			if GetDistance(unit) < GetRange(_Q) and IsReady(_Q) then CastSpell(_Q, unit.x, unit.z) end
		else
			if GetDistance(unit) < Range(myHero) and IsReady(_E) and (myHero.mana == 100 or getDmg("E", unit, myHero) > unit.health * 0.95) then CastSpell(_E, unit) end
			if GetDistance(unit) < Range(myHero) and IsReady(_Q) then CastSpell(_Q, unit) end
		end
	elseif myHero.charName == "Zac" then
		if buffs["canMove"] then
			if GetDistance(unit) < (1100 + 100 * GetSpellData(_E).level) and IsReady(_E) and mode == "jungle" then ZacCastE(unit) end
			if GetDistance(unit) < GetRange(_Q) and IsReady(_Q) then CastSpell(_Q, unit.x, unit.z) end
			if GetDistance(unit) < GetRange(_W) and IsReady(_W) then CastSpell(_W) end
		else
			if not IsReady(_E) then
				buffs["canMove"] = true
				ZOrbWalker:EnableMove()
			end
		end
	end
end

function KS()
	for i, unit in pairs(GetEnemyHeroes()) do
		if not unit.dead and unit.visible then
			if myHero.charName == "Diana" then
				if settings.ks[GetSpellData(_Q).name] and IsReady(_Q) and GetDistance(unit) < GetRange(_Q) and unit.health < getDmg("Q", unit, myHero) then CustomCast(_Q, unit) end
				if settings.ks[GetSpellData(_R).name] and IsReady(_R) and GetDistance(unit) < GetRange(_R) and unit.health < getDmg("R", unit, myHero) then CastSpell(_R, unit) end
			elseif myHero.charName == "RekSai" then
				if settings.ks.RekSaiE and GetSpellData(_E).name == "RekSaiE" and IsReady(_E) and GetDistance(unit) < Range(myHero) and unit.health < getDmg("E", unit, myHero) then CastSpell(_E, unit) end
				if settings.ks.reksaiqburrowed and GetSpellData(_Q).name == "reksaiqburrowed" and IsReady(_Q) and GetDistance(unit) < GetRange(_Q) and unit.health < getDmg("QM", unit, myHero) then CustomCast(_Q, unit) end
			elseif myHero.charName == "Zac" then
				if buffs["canMove"] then
					if settings.ks[GetSpellData(_Q).name] and IsReady(_Q) and GetDistance(unit) < GetRange(_Q) and unit.health < getDmg("Q", unit, myHero) then CustomCast(_Q, unit) end
					if settings.ks[GetSpellData(_Q).name] and IsReady(_W) and GetDistance(unit) < GetRange(_W) and unit.health < getDmg("W", unit, myHero) then 
						local Position = VPred:GetPredictedPos(unit, 0.25)
						if GetDistance(Position) < GetRange(_W) then
							CastSpell(_W)
						end
					end
				end
			end
			
			if sdot then if settings.ks.dot and GetDistance(unit) < 600  and unit.health < getDmg("IGNITE", unit, myHero) then CastSpell(sdot, unit) end end
			if ssmite then 
				if settings.ks.smite and GetSpellData(ssmite).name:find("duel") and GetDistance(unit) - GetDistance(unit, unit.minBBox) - GetDistance(myHero, myHero.minBBox) < 500 and unit.health < getDmg("SMITESS", unit, myHero) then CastSpell(ssmite, unit) end 
				if settings.ks.smite and GetSpellData(ssmite).name:find("ganker") and GetDistance(unit) - GetDistance(unit, unit.minBBox) - GetDistance(myHero, myHero.minBBox) < 500 and unit.health < getDmg("SMITESB", unit, myHero) then CastSpell(ssmite, unit) end 
			end
		end
	end
end

function ZacCastE(unit)
	if buffs["ZacE"] == 0 and IsReady(_E) then
		if GetDistance(unit) < 1050 + 100 * GetSpellData(_E).level then
			buffs["ZacE"] = os.clock() * 1000 + 125 - ZOrbWalker:Latency()
			buffs["canMove"] = false
			ZOrbWalker:DisableMove()
			
			CastSpell(_E, unit.x, unit.z)
		end
	else
		local Position = VPred:GetPredictedPos(unit, GetDistance(unit) / spells[_E].speed) 
		local nearestUnit = myHero
		
		for i, ally in pairs(GetAllyHeroes()) do
			if not ally.dead and GetDistance(ally, unit) < GetDistance(nearestUnit, unit) then
				nearestUnit = ally
			end
		end
		
		Position = Vector(Position) + 75 * (Vector(unit) - Vector(nearestUnit)):normalized()
		
		local timeDifference = os.clock() * 1000 - buffs["ZacE"] < (0.8 + 0.1 * GetSpellData(_E).level) * 1000 and os.clock() * 1000 - buffs["ZacE"] or (0.8 + 0.1 * GetSpellData(_E).level) * 1000
		local distanceModifier = (1100 + 100 * GetSpellData(_E).level - 300) / ((0.8 + 0.1 * GetSpellData(_E).level) * 1000)

		if GetDistance(unit) < timeDifference * distanceModifier + 300 then
			CastSpell2(_E, D3DXVECTOR3(Position.x, Position.y, Position.z))
			return
		elseif (os.clock() * 1000 - buffs["ZacE"]) > (0.8 + 0.1 * GetSpellData(_E).level) * 1000 then
			CastSpell2(_E, D3DXVECTOR3(Position.x, Position.y, Position.z))
			return
		end
	end
	
	DelayAction(function() ZacCastE(unit) end, 0.1)
end

----------------------
--       Draw       --
----------------------

function DrawCircle(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
		
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 300) 
	end
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(40, Round(180 / math.deg((math.asin((chordlength / (2 * radius)))))))
	quality = 2 * math.pi / quality
	radius = radius * .92
	local points = {}
		
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)	
end

function Round(number)
	if number >= 0 then 
		return math.floor(number+.5) 
	else 
		return math.ceil(number-.5) 
	end
end

----------------------
--    OrbWalker     --
----------------------

class "ZOrbWalker"
function ZOrbWalker:__init()
	_G.ZOWLoaded = true
	
	ZOrbWalker:Menu()
	
	--Callbacks
	ZOrbWalker.AfterAttackCallbacks = {}
	ZOrbWalker.OnAttackCallbacks = {}
	ZOrbWalker.BeforeAttackCallbacks = {}
	
	ZOrbWalker.projectileSpeeds = {["Velkoz"]= 2000,["TeemoMushroom"] = math.huge,["TestCubeRender"] = math.huge ,["Xerath"] = 2000.0000 ,["Kassadin"] = math.huge ,["Rengar"] = math.huge ,["Thresh"] = 1000.0000 ,["Ziggs"] = 1500.0000 ,["ZyraPassive"] = 1500.0000 ,["ZyraThornPlant"] = 1500.0000 ,["KogMaw"] = 1800.0000 ,["HeimerTBlue"] = 1599.3999 ,["EliseSpider"] = 500.0000 ,["Skarner"] = 500.0000 ,["ChaosNexus"] = 500.0000 ,["Katarina"] = 467.0000 ,["Riven"] = 347.79999 ,["SightWard"] = 347.79999 ,["HeimerTYellow"] = 1599.3999 ,["Ashe"] = 2000.0000 ,["VisionWard"] = 2000.0000 ,["TT_NGolem2"] = math.huge ,["ThreshLantern"] = math.huge ,["TT_Spiderboss"] = math.huge ,["OrderNexus"] = math.huge ,["Soraka"] = 1000.0000 ,["Jinx"] = 2750.0000 ,["TestCubeRenderwCollision"] = 2750.0000 ,["Red_Minion_Wizard"] = 650.0000 ,["JarvanIV"] = 20.0000 ,["Blue_Minion_Wizard"] = 650.0000 ,["TT_ChaosTurret2"] = 1200.0000 ,["TT_ChaosTurret3"] = 1200.0000 ,["TT_ChaosTurret1"] = 1200.0000 ,["ChaosTurretGiant"] = 1200.0000 ,["Dragon"] = 1200.0000 ,["LuluSnowman"] = 1200.0000 ,["Worm"] = 1200.0000 ,["ChaosTurretWorm"] = 1200.0000 ,["TT_ChaosInhibitor"] = 1200.0000 ,["ChaosTurretNormal"] = 1200.0000 ,["AncientGolem"] = 500.0000 ,["ZyraGraspingPlant"] = 500.0000 ,["HA_AP_OrderTurret3"] = 1200.0000 ,["HA_AP_OrderTurret2"] = 1200.0000 ,["Tryndamere"] = 347.79999 ,["OrderTurretNormal2"] = 1200.0000 ,["Singed"] = 700.0000 ,["OrderInhibitor"] = 700.0000 ,["Diana"] = 347.79999 ,["HA_FB_HealthRelic"] = 347.79999 ,["TT_OrderInhibitor"] = 347.79999 ,["GreatWraith"] = 750.0000 ,["Yasuo"] = 347.79999 ,["OrderTurretDragon"] = 1200.0000 ,["OrderTurretNormal"] = 1200.0000 ,["LizardElder"] = 500.0000 ,["HA_AP_ChaosTurret"] = 1200.0000 ,["Ahri"] = 1750.0000 ,["Lulu"] = 1450.0000 ,["ChaosInhibitor"] = 1450.0000 ,["HA_AP_ChaosTurret3"] = 1200.0000 ,["HA_AP_ChaosTurret2"] = 1200.0000 ,["ChaosTurretWorm2"] = 1200.0000 ,["TT_OrderTurret1"] = 1200.0000 ,["TT_OrderTurret2"] = 1200.0000 ,["TT_OrderTurret3"] = 1200.0000 ,["LuluFaerie"] = 1200.0000 ,["HA_AP_OrderTurret"] = 1200.0000 ,["OrderTurretAngel"] = 1200.0000 ,["YellowTrinketUpgrade"] = 1200.0000 ,["MasterYi"] = math.huge ,["Lissandra"] = 2000.0000 ,["ARAMOrderTurretNexus"] = 1200.0000 ,["Draven"] = 1700.0000 ,["FiddleSticks"] = 1750.0000 ,["SmallGolem"] = math.huge ,["ARAMOrderTurretFront"] = 1200.0000 ,["ChaosTurretTutorial"] = 1200.0000 ,["NasusUlt"] = 1200.0000 ,["Maokai"] = math.huge ,["Wraith"] = 750.0000 ,["Wolf"] = math.huge ,["Sivir"] = 1750.0000 ,["Corki"] = 2000.0000 ,["Janna"] = 1200.0000 ,["Nasus"] = math.huge ,["Golem"] = math.huge ,["ARAMChaosTurretFront"] = 1200.0000 ,["ARAMOrderTurretInhib"] = 1200.0000 ,["LeeSin"] = math.huge ,["HA_AP_ChaosTurretTutorial"] = 1200.0000 ,["GiantWolf"] = math.huge ,["HA_AP_OrderTurretTutorial"] = 1200.0000 ,["YoungLizard"] = 750.0000 ,["Jax"] = 400.0000 ,["LesserWraith"] = math.huge ,["Blitzcrank"] = math.huge ,["ARAMChaosTurretInhib"] = 1200.0000 ,["Shen"] = 400.0000 ,["Nocturne"] = math.huge ,["Sona"] = 1500.0000 ,["ARAMChaosTurretNexus"] = 1200.0000 ,["YellowTrinket"] = 1200.0000 ,["OrderTurretTutorial"] = 1200.0000 ,["Caitlyn"] = 2500.0000 ,["Trundle"] = 347.79999 ,["Malphite"] = 1000.0000 ,["Mordekaiser"] = math.huge ,["ZyraSeed"] = math.huge ,["Vi"] = 1000.0000 ,["Tutorial_Red_Minion_Wizard"] = 650.0000 ,["Renekton"] = math.huge ,["Anivia"] = 1400.0000 ,["Fizz"] = math.huge ,["Heimerdinger"] = 1500.0000 ,["Evelynn"] = 467.0000 ,["Rumble"] = 347.79999 ,["Leblanc"] = 1700.0000 ,["Darius"] = math.huge ,["OlafAxe"] = math.huge ,["Viktor"] = 2300.0000 ,["XinZhao"] = 20.0000 ,["Orianna"] = 1450.0000 ,["Vladimir"] = 1400.0000 ,["Nidalee"] = 1750.0000 ,["Tutorial_Red_Minion_Basic"] = math.huge ,["ZedShadow"] = 467.0000 ,["Syndra"] = 1800.0000 ,["Zac"] = 1000.0000 ,["Olaf"] = 347.79999 ,["Veigar"] = 1100.0000 ,["Twitch"] = 2500.0000 ,["Alistar"] = math.huge ,["Akali"] = 467.0000 ,["Urgot"] = 1300.0000 ,["Leona"] = 347.79999 ,["Talon"] = math.huge ,["Karma"] = 1500.0000 ,["Jayce"] = 347.79999 ,["Galio"] = 1000.0000 ,["Shaco"] = math.huge ,["Taric"] = math.huge ,["TwistedFate"] = 1500.0000 ,["Varus"] = 2000.0000 ,["Garen"] = 347.79999 ,["Swain"] = 1600.0000 ,["Vayne"] = 2000.0000 ,["Fiora"] = 467.0000 ,["Quinn"] = 2000.0000 ,["Kayle"] = math.huge ,["Blue_Minion_Basic"] = math.huge ,["Brand"] = 2000.0000 ,["Teemo"] = 1300.0000 ,["Amumu"] = 500.0000 ,["Annie"] = 1200.0000 ,["Odin_Blue_Minion_caster"] = 1200.0000 ,["Elise"] = 1600.0000 ,["Nami"] = 1500.0000 ,["Poppy"] = 500.0000 ,["AniviaEgg"] = 500.0000 ,["Tristana"] = 2250.0000 ,["Graves"] = 3000.0000 ,["Morgana"] = 1600.0000 ,["Gragas"] = math.huge ,["MissFortune"] = 2000.0000 ,["Warwick"] = math.huge ,["Cassiopeia"] = 1200.0000 ,["Tutorial_Blue_Minion_Wizard"] = 650.0000 ,["DrMundo"] = math.huge ,["Volibear"] = 467.0000 ,["Irelia"] = 467.0000 ,["Odin_Red_Minion_Caster"] = 650.0000 ,["Lucian"] = 2800.0000 ,["Yorick"] = math.huge ,["RammusPB"] = math.huge ,["Red_Minion_Basic"] = math.huge ,["Udyr"] = 467.0000 ,["MonkeyKing"] = 20.0000 ,["Tutorial_Blue_Minion_Basic"] = math.huge ,["Kennen"] = 1600.0000 ,["Nunu"] = 500.0000 ,["Ryze"] = 2400.0000 ,["Zed"] = 467.0000 ,["Nautilus"] = 1000.0000 ,["Gangplank"] = 1000.0000 ,["Lux"] = 1600.0000 ,["Sejuani"] = 500.0000 ,["Ezreal"] = 2000.0000 ,["OdinNeutralGuardian"] = 1800.0000 ,["Khazix"] = 500.0000 ,["Sion"] = math.huge ,["Aatrox"] = 347.79999 ,["Hecarim"] = 500.0000 ,["Pantheon"] = 20.0000 ,["Shyvana"] = 467.0000 ,["Zyra"] = 1700.0000 ,["Karthus"] = 1200.0000 ,["Rammus"] = math.huge ,["Zilean"] = 1200.0000 ,["Chogath"] = 500.0000 ,["Malzahar"] = 2000.0000 ,["YorickRavenousGhoul"] = 347.79999 ,["YorickSpectralGhoul"] = 347.79999 ,["JinxMine"] = 347.79999 ,["YorickDecayedGhoul"] = 347.79999 ,["XerathArcaneBarrageLauncher"] = 347.79999 ,["Odin_SOG_Order_Crystal"] = 347.79999 ,["TestCube"] = 347.79999 ,["ShyvanaDragon"] = math.huge ,["FizzBait"] = math.huge ,["Blue_Minion_MechMelee"] = math.huge ,["OdinQuestBuff"] = math.huge ,["TT_Buffplat_L"] = math.huge ,["TT_Buffplat_R"] = math.huge ,["KogMawDead"] = math.huge ,["TempMovableChar"] = math.huge ,["Lizard"] = 500.0000 ,["GolemOdin"] = math.huge ,["OdinOpeningBarrier"] = math.huge ,["TT_ChaosTurret4"] = 500.0000 ,["TT_Flytrap_A"] = 500.0000 ,["TT_NWolf"] = math.huge ,["OdinShieldRelic"] = math.huge ,["LuluSquill"] = math.huge ,["redDragon"] = math.huge ,["MonkeyKingClone"] = math.huge ,["Odin_skeleton"] = math.huge ,["OdinChaosTurretShrine"] = 500.0000 ,["Cassiopeia_Death"] = 500.0000 ,["OdinCenterRelic"] = 500.0000 ,["OdinRedSuperminion"] = math.huge ,["JarvanIVWall"] = math.huge ,["ARAMOrderNexus"] = math.huge ,["Red_Minion_MechCannon"] = 1200.0000 ,["OdinBlueSuperminion"] = math.huge ,["SyndraOrbs"] = math.huge ,["LuluKitty"] = math.huge ,["SwainNoBird"] = math.huge ,["LuluLadybug"] = math.huge ,["CaitlynTrap"] = math.huge ,["TT_Shroom_A"] = math.huge ,["ARAMChaosTurretShrine"] = 500.0000 ,["Odin_Windmill_Propellers"] = 500.0000 ,["TT_NWolf2"] = math.huge ,["OdinMinionGraveyardPortal"] = math.huge ,["SwainBeam"] = math.huge ,["Summoner_Rider_Order"] = math.huge ,["TT_Relic"] = math.huge ,["odin_lifts_crystal"] = math.huge ,["OdinOrderTurretShrine"] = 500.0000 ,["SpellBook1"] = 500.0000 ,["Blue_Minion_MechCannon"] = 1200.0000 ,["TT_ChaosInhibitor_D"] = 1200.0000 ,["Odin_SoG_Chaos"] = 1200.0000 ,["TrundleWall"] = 1200.0000 ,["HA_AP_HealthRelic"] = 1200.0000 ,["OrderTurretShrine"] = 500.0000 ,["OriannaBall"] = 500.0000 ,["ChaosTurretShrine"] = 500.0000 ,["LuluCupcake"] = 500.0000 ,["HA_AP_ChaosTurretShrine"] = 500.0000 ,["TT_NWraith2"] = 750.0000 ,["TT_Tree_A"] = 750.0000 ,["SummonerBeacon"] = 750.0000 ,["Odin_Drill"] = 750.0000 ,["TT_NGolem"] = math.huge ,["AramSpeedShrine"] = math.huge ,["OriannaNoBall"] = math.huge ,["Odin_Minecart"] = math.huge ,["Summoner_Rider_Chaos"] = math.huge ,["OdinSpeedShrine"] = math.huge ,["TT_SpeedShrine"] = math.huge ,["odin_lifts_buckets"] = math.huge ,["OdinRockSaw"] = math.huge ,["OdinMinionSpawnPortal"] = math.huge ,["SyndraSphere"] = math.huge ,["Red_Minion_MechMelee"] = math.huge ,["SwainRaven"] = math.huge ,["crystal_platform"] = math.huge ,["MaokaiSproutling"] = math.huge ,["Urf"] = math.huge ,["TestCubeRender10Vision"] = math.huge ,["MalzaharVoidling"] = 500.0000 ,["GhostWard"] = 500.0000 ,["MonkeyKingFlying"] = 500.0000 ,["LuluPig"] = 500.0000 ,["AniviaIceBlock"] = 500.0000 ,["TT_OrderInhibitor_D"] = 500.0000 ,["Odin_SoG_Order"] = 500.0000 ,["RammusDBC"] = 500.0000 ,["FizzShark"] = 500.0000 ,["LuluDragon"] = 500.0000 ,["OdinTestCubeRender"] = 500.0000 ,["TT_Tree1"] = 500.0000 ,["ARAMOrderTurretShrine"] = 500.0000 ,["Odin_Windmill_Gears"] = 500.0000 ,["ARAMChaosNexus"] = 500.0000 ,["TT_NWraith"] = 750.0000 ,["TT_OrderTurret4"] = 500.0000 ,["Odin_SOG_Chaos_Crystal"] = 500.0000 ,["OdinQuestIndicator"] = 500.0000 ,["JarvanIVStandard"] = 500.0000 ,["TT_DummyPusher"] = 500.0000 ,["OdinClaw"] = 500.0000 ,["EliseSpiderling"] = 2000.0000 ,["QuinnValor"] = math.huge ,["UdyrTigerUlt"] = math.huge ,["UdyrTurtleUlt"] = math.huge ,["UdyrUlt"] = math.huge ,["UdyrPhoenixUlt"] = math.huge ,["ShacoBox"] = 1500.0000 ,["HA_AP_Poro"] = 1500.0000 ,["AnnieTibbers"] = math.huge ,["UdyrPhoenix"] = math.huge ,["UdyrTurtle"] = math.huge ,["UdyrTiger"] = math.huge ,["HA_AP_OrderShrineTurret"] = 500.0000 ,["HA_AP_Chains_Long"] = 500.0000 ,["HA_AP_BridgeLaneStatue"] = 500.0000 ,["HA_AP_ChaosTurretRubble"] = 500.0000 ,["HA_AP_PoroSpawner"] = 500.0000 ,["HA_AP_Cutaway"] = 500.0000 ,["HA_AP_Chains"] = 500.0000 ,["ChaosInhibitor_D"] = 500.0000 ,["ZacRebirthBloblet"] = 500.0000 ,["OrderInhibitor_D"] = 500.0000 ,["Nidalee_Spear"] = 500.0000 ,["Nidalee_Cougar"] = 500.0000 ,["TT_Buffplat_Chain"] = 500.0000 ,["WriggleLantern"] = 500.0000 ,["TwistedLizardElder"] = 500.0000 ,["RabidWolf"] = math.huge ,["HeimerTGreen"] = 1599.3999 ,["HeimerTRed"] = 1599.3999 ,["ViktorFF"] = 1599.3999 ,["TwistedGolem"] = math.huge ,["TwistedSmallWolf"] = math.huge ,["TwistedGiantWolf"] = math.huge ,["TwistedTinyWraith"] = 750.0000 ,["TwistedBlueWraith"] = 750.0000 ,["TwistedYoungLizard"] = 750.0000 ,["Red_Minion_Melee"] = math.huge ,["Blue_Minion_Melee"] = math.huge ,["Blue_Minion_Healer"] = 1000.0000 ,["Ghast"] = 750.0000 ,["blueDragon"] = 800.0000 ,["Red_Minion_MechRange"] = 3000, ["SRU_OrderMinionRanged"] = 650, ["SRU_ChaosMinionRanged"] = 650, ["SRU_OrderMinionSiege"] = 1200, ["SRU_ChaosMinionSiege"] = 1200, ["SRUAP_Turret_Chaos1"]  = 1200, ["SRUAP_Turret_Chaos2"]  = 1200, ["SRUAP_Turret_Chaos3"] = 1200, ["SRUAP_Turret_Order1"]  = 1200, ["SRUAP_Turret_Order2"]  = 1200, ["SRUAP_Turret_Order3"] = 1200, ["SRUAP_Turret_Chaos4"] = 1200, ["SRUAP_Turret_Chaos5"] = 500, ["SRUAP_Turret_Order4"] = 1200, ["SRUAP_Turret_Order5"] = 500 }
	
	ZOrbWalker.AttackTable = {}

	ZOrbWalker.NoAttackTable = {
		["Shyvana1"] = "shyvanadoubleattackdragon",
		["Shyvana2"] = "shyvanadoubleattack",
		["Wukong"] = "monkeykingdoubleattack", }

	ZOrbWalker.AttackResetTable = {
		["Blitzcrank"] = _E,
		["Darius"] = _W,
		["Fiora"] = _E,
		["Gankplank"] = _Q,
		["Garen"] = _Q,
		["Jax"] = _W,
		["Jayce"] = _W, -- Get Exact Name
		["Leona"] = _Q,
		["Lucian"] = _E,
		["MasterYi"] = _E,
		["Mordakaiser"] = _Q,
		["Nasus"] = _Q,
		["Nautilus"] = _W,
		["Nidalee"] = _Q, -- Get Exact Name
		["Poppy"] = _Q,
		["RekSai"] = "RekSaiQ", -- Get Exact Name
		["Renekton"] = _W,
		["Rengar"] = _Q,
		["Riven"] = _Q,
		["Sejuani"] = _W, -- Get Exact Name
		["Shyvana"] = _Q,
		["Sivir"] = _W,
		-- Add sona
		["Talon"] = _Q,
		["Teemo"] = _Q,
		["Trundle"] = _Q,
		["Vayne"] = _Q,
		["Vi"] = _E,
		["Volibear"] = _Q,
		["MonkeyKing"] = _Q,
		["XinZhao"] = _Q,
		["Yorick"] = _Q,} 
	
	ZOrbWalker.incomingDamage = {}
	ZOrbWalker.minionHealth = {}
	ZOrbWalker.minionHealthTheoretical = {}
	ZOrbWalker.minionTime = {}
	
	ZOrbWalker.minionInfo = {}
	ZOrbWalker.minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_Basic"] =      { aaDelay = 400, projSpeed = math.huge}
	ZOrbWalker.minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_Caster"] =     { aaDelay = 484, projSpeed = 0.68 }
	ZOrbWalker.minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_Wizard"] =     { aaDelay = 484, projSpeed = 0.68 }
	ZOrbWalker.minionInfo[(myHero.team == 100 and "Blue" or "Red").."_Minion_MechCannon"] = { aaDelay = 365, projSpeed = 1.18 }
	ZOrbWalker.minionInfo.obj_AI_Turret =                                        			  { aaDelay = 150, projSpeed = 1.14 }
	
	ZOrbWalker.allyMinions = minionManager(MINION_ALLY, 2000, myHero, MINION_SORT_HEALTH_ASC)
	ZOrbWalker.enemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
	ZOrbWalker.jungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, MINION_SORT_MAXHEALTH_DEC)
	
	ZOrbWalker.projectileSpeed = ZOrbWalker:GetProjectileSpeed(myHero)
	ZOrbWalker.windUpTime = 0.65
	ZOrbWalker.animationTime = 2
	ZOrbWalker.lastAttack = 0
	
	ZOrbWalker.attacks = true
	ZOrbWalker.move = true
	
	ZOrbWalker.lastCommand = ""

	AddTickCallback(function() ZOrbWalker:OnTick() end)
	AddDrawCallback(function() ZOrbWalker:OnDraw() end)
	AddProcessSpellCallback(function(unit, spell) ZOrbWalker:OnProcessSpell(unit, spell) end)
end

function ZOrbWalker:OnProcessSpell(unit, spell)
	if unit.isMe and ZOrbWalker:IsAttack(spell.name) then
		if not spell.name:lower():find("card") then
			ZOrbWalker.animationTime = spell.animationTime * 1000
			ZOrbWalker.windUpTime = spell.windUpTime * 1000
		end
		
		ZOrbWalker.lastAttack = ZOrbWalker:GetTime() - ZOrbWalker:Latency()
		ZOrbWalker:OnAttack(spell.target)
		DelayAction(function(t) ZOrbWalker:AfterAttack(t) end, (ZOrbWalker.windUpTime - ZOrbWalker:Latency()) / 1000, {spell.target})
	elseif unit.isMe and ZOrbWalker:IsAAReset(spell.name) then
		DelayAction(function(t) ZOrbWalker:ResetAA() end, spell.windUpTime - ZOrbWalker:Latency() / 1000)
	end
	
	if ZOrbWalker:IsAllyMinion(unit) then
		if ValidTarget(spell.target) and ZOrbWalker:IsEnemyMinion(spell.target) then
			for i, attack in ipairs(ZOrbWalker.incomingDamage) do
				if attack.attacker.name == unit.name then
					table.remove(ZOrbWalker.incomingDamage, i)
				end
			end
			
			table.insert(ZOrbWalker.incomingDamage, {hitTime = ZOrbWalker:GetTime() + spell.windUpTime * 1000 + (GetDistance(unit, spell.target) / (ZOrbWalker:GetProjectileSpeed(unit))) * 1000 - ZOrbWalker:Latency(), target = spell.target, attacker = unit, damage = unit:CalcDamage(spell.target), theoretical = false})
			table.insert(ZOrbWalker.incomingDamage, {hitTime = ZOrbWalker:GetTime() + (2 * spell.windUpTime + spell.animationTime) * 1000 + (GetDistance(unit, spell.target) / (ZOrbWalker:GetProjectileSpeed(unit))) * 1000 - ZOrbWalker:Latency(), target = spell.target, attacker = unit, damage = 1.25 * unit:CalcDamage(spell.target), theoretical = true})
			table.insert(ZOrbWalker.incomingDamage, {hitTime = ZOrbWalker:GetTime() + (3 * spell.windUpTime +  2 * spell.animationTime) * 1000 + (GetDistance(unit, spell.target) / (ZOrbWalker:GetProjectileSpeed(unit))) * 1000 - ZOrbWalker:Latency(), target = spell.target, attacker = unit, damage = 1.25 * unit:CalcDamage(spell.target), theoretical = true})
			table.insert(ZOrbWalker.incomingDamage, {hitTime = ZOrbWalker:GetTime() + (4 * spell.windUpTime +  3 * spell.animationTime) * 1000 + (GetDistance(unit, spell.target) / (ZOrbWalker:GetProjectileSpeed(unit))) * 1000 - ZOrbWalker:Latency(), target = spell.target, attacker = unit, damage = 1.25 * unit:CalcDamage(spell.target), theoretical = true})
			table.sort(ZOrbWalker.incomingDamage, function(a,b) return a.hitTime < b.hitTime end)
		end 
    end
end

function ZOrbWalker:IsAllyMinion(minion)
	if minion ~= nil and minion.team == myHero.team
		and (minion.type == "obj_AI_Minion" or minion.type == "obj_AI_Turret")
		and GetDistance(minion) <= 2000 then return true
	else return false end
end

function ZOrbWalker:IsEnemyMinion(minion)
	if minion ~= nil and minion.team ~= myHero.team
		and (minion.type == "obj_AI_Minion" or minion.type == "obj_AI_Turret")
		and GetDistance(minion) <= 2000 then return true
	else return false end
end

function ZOrbWalker:GetProjectileSpeed(unit)
	return ZOrbWalker.projectileSpeeds[unit.charName] and ZOrbWalker.projectileSpeeds[unit.charName] or math.huge
end
function ZOrbWalker:OnTick()
	if ZOrbWalker.menu.key.comboKey or ZOrbWalker.menu.key.mixedKey or ZOrbWalker.menu.key.lastKey or ZOrbWalker.menu.key.clearKey then
		if ZOrbWalker:CanAttack() or ZOrbWalker.menu.move == 2 then
			ZOrbWalker:OrbWalk(ZOrbWalker:GetTarget())
		else
			ZOrbWalker:OrbWalk()
		end
	end
end

function ZOrbWalker:OnDraw()
	if ZOrbWalker.menu.draw.aa then DrawCircle(myHero.x, myHero.y, myHero.z, ZOrbWalker:Range(myHero), 0xFFFF0000) end
	if ZOrbWalker.menu.draw.enemy then
		for i, enemy in pairs(GetEnemyHeroes()) do
			if not enemy.dead and enemy.visible then
				DrawCircle(enemy.x, enemy.y, enemy.z, ZOrbWalker:Range(enemy), ZOrbWalker:InRange(myHero, enemy) and 0xFFFF0000 or 0xFF00FF00)
			end
		end
	end
end

function ZOrbWalker:InTable(table, name)
	for i, unit in ipairs(table) do
		if unit.minion.name == name then return true end
	end
	return faslse
end

function ZOrbWalker:Menu()
	ZOrbWalker.menu = scriptConfig("ZOrbWalker", "ZOrbWalker")
	
	ZOrbWalker.menu:addSubMenu("Mode Settings", "mode")
		ZOrbWalker.menu.mode:addParam("priority", "Priorritize in Mixed Mode", SCRIPT_PARAM_LIST, 1, { "Hitting Minions", "Hitting Enemies"})
		if myHero.range > 300 then ZOrbWalker.menu.mode:addParam("orbwalking",  "Orbwalking mode", SCRIPT_PARAM_LIST, 1, {"To mouse"}) 
		else ZOrbWalker.menu.mode:addParam("orbwalking",  "Orbwalking mode", SCRIPT_PARAM_LIST, 1, { "To mouse"}) end
	
	ZOrbWalker.menu:addSubMenu("Draw", "draw")
		ZOrbWalker.menu.draw:addParam("aa", "My AA range", SCRIPT_PARAM_ONOFF, true)
		ZOrbWalker.menu.draw:addParam("enemy", "Enemy AA range", SCRIPT_PARAM_ONOFF, true)
	
	ZOrbWalker.menu:addSubMenu("Keys", "key")
		ZOrbWalker.menu.key:addParam("comboKey", "Fight Mode Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		ZOrbWalker.menu.key:addParam("mixedKey", "Mixed Mode Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
		ZOrbWalker.menu.key:addParam("lastKey", "Last Hit Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
		ZOrbWalker.menu.key:addParam("clearKey", "Lane/Jungle Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
end

function ZOrbWalker:GetTarget(champion)
	champion = champion or true
	local target = nil
	if not ZOrbWalker:CanAttack() then return nil end
	if not target and ZOrbWalker.menu.key.comboKey or (ZOrbWalker.menu.key.mixedKey and ZOrbWalker.menu.mode.priority == 2) and champion then target = ZOrbWalker:GetEnemy() end
	if not target and ZOrbWalker.menu.key.clearKey then target = ZOrbWalker:GetJungle() end
	if not target and (ZOrbWalker.menu.key.mixedKey or ZOrbWalker.menu.key.lastKey or ZOrbWalker.menu.key.clearKey) then target = ZOrbWalker:GetMinion() end
	if not target and ZOrbWalker.menu.key.mixedKey and ZOrbWalker.menu.mode.priority == 1 and champion then target = ZOrbWalker:GetEnemy() end
	if not target and ZOrbWalker.menu.key.lastKey then target = ZOrbWalker:GetTower() end
	return target
end

function ZOrbWalker:GetJungle()
	ZOrbWalker.jungleMinions:update()
		
	for i, minion in pairs(ZOrbWalker.jungleMinions.objects) do
		if ZOrbWalker:ValidTarget(minion) then
			return minion
		end
	end
end

function ZOrbWalker:AttackLandTime(target)
	if ZOrbWalker.lastAttack + ZOrbWalker.animationTime > ZOrbWalker:GetTime() then return ZOrbWalker.lastAttack + ZOrbWalker.animationTime + ZOrbWalker.windUpTime + (GetDistance(target) / ZOrbWalker.projectileSpeed) * 1000 + ZOrbWalker:Latency()
	else return ZOrbWalker:GetTime() + ZOrbWalker.windUpTime + (GetDistance(target) / ZOrbWalker.projectileSpeed) * 1000 + ZOrbWalker:Latency() end
end

function ZOrbWalker:SecondAttackLandTime(target)
	if ZOrbWalker.lastAttack + ZOrbWalker.animationTime > ZOrbWalker:GetTime() then return ZOrbWalker.lastAttack + 2 * (ZOrbWalker.animationTime + ZOrbWalker.windUpTime) + (GetDistance(target) / ZOrbWalker.projectileSpeed) * 1000 + ZOrbWalker:Latency()
	else return ZOrbWalker:GetTime() +  2 * ZOrbWalker.windUpTime + ZOrbWalker.animationTime + (GetDistance(target) / ZOrbWalker.projectileSpeed) * 1000 + ZOrbWalker:Latency() end
end


function ZOrbWalker:GetTimeOfDeath(minion)
	for i, action in ipairs(ZOrbWalker.timeOfDeath) do
		if action.minion.name == minion.name then
			return action.time
		end
	end
	return 0
end

function ZOrbWalker:GetMinion()	
	for i, attack in ipairs(ZOrbWalker.incomingDamage) do
		if attack.hitTime < ZOrbWalker:GetTime() or attack.attacker.dead then
			table.remove(ZOrbWalker.incomingDamage, i)
		elseif attack.target.name then 
			if not ZOrbWalker.minionHealth[attack.target.name] then ZOrbWalker.minionHealth[attack.target.name] = attack.target.health end
			if not ZOrbWalker.minionHealthTheoretical[attack.target.name] then ZOrbWalker.minionHealthTheoretical[attack.target.name] = attack.target.health end

			if attack.theoretical == false then ZOrbWalker.minionHealth[attack.target.name] = ZOrbWalker.minionHealth[attack.target.name] - attack.damage end
			ZOrbWalker.minionHealthTheoretical[attack.target.name] = ZOrbWalker.minionHealthTheoretical[attack.target.name] - attack.damage
			
			if ZOrbWalker.minionHealthTheoretical[attack.target.name] < 2.5 * myHero:CalcDamage(attack.target) then
				if ZOrbWalker:InTable(ZOrbWalker.minionTime, attack.target.name) then
					for i, unit in ipairs(ZOrbWalker.minionTime) do
						if unit.minion.name == attack.target.name then 
							if unit.timeOfKillTheoretical == math.huge then
								ZOrbWalker.minionTime[i].timeOfKillTheoretical = attack.hitTime
							else
								break
							end
						end
					end
				else
					table.insert(ZOrbWalker.minionTime, {minion = attack.target, timeOfKill = math.huge, timeOfKillTheoretical = attack.hitTime, timeOfDeath = math.huge})
				end
			end
			
			if ZOrbWalker.minionHealth[attack.target.name] < myHero:CalcDamage(attack.target) then
				if ZOrbWalker:InTable(ZOrbWalker.minionTime, attack.target.name) then
					for i, unit in ipairs(ZOrbWalker.minionTime) do
						if unit.minion.name == attack.target.name then 
							if unit.timeOfKill == math.huge then
								ZOrbWalker.minionTime[i].timeOfKill = attack.hitTime
							else
								break
							end
						end
					end
				else
					table.insert(ZOrbWalker.minionTime, {minion = attack.target, timeOfKill = attack.hitTime, timeOfKillTheoretical = math.huge, timeOfDeath = math.huge})
				end
			end
			
			if ZOrbWalker.minionHealth[attack.target.name]  < 0 then
				if ZOrbWalker:InTable(ZOrbWalker.minionTime, attack.target.name) then
					for i, unit in ipairs(ZOrbWalker.minionTime) do
						if unit.minion.name == attack.target.name then 
							if unit.timeOfDeath == math.huge then
								ZOrbWalker.minionTime[i].timeOfDeath = attack.hitTime
							else
								break
							end
						end
					end
				else
					table.insert(ZOrbWalker.minionTime, {minion = attack.target, timeOfKill = math.huge, timeOfKillTheoretical = math.huge, timeOfDeath = attack.hitTime})
				end
			end
		end
	end
	
	ZOrbWalker.minionHealth = {}
	ZOrbWalker.minionHealthTheoretical = {}
	
	for i, data in ipairs(ZOrbWalker.minionTime) do
		if data.minion.dead then
			table.remove(ZOrbWalker.minionTime, i)
		end
	end

	table.sort(ZOrbWalker.minionTime, function(a,b) return a.timeOfKill < b.timeOfKill end)
	for i, action in ipairs(ZOrbWalker.minionTime) do	
		if ZOrbWalker:InRange(action.minion) then
			if action.timeOfKill < math.huge then
				local timeOfKill = action.timeOfKill
				local timeOfDeath = action.timeOfDeath < math.huge and action.timeOfDeath or action.timeOfKill + 200
				local diff = timeOfDeath - timeOfKill
				if ZOrbWalker:AttackLandTime(action.minion) > timeOfKill + diff / 5 then
					return action.minion
				end
			end
		end
	end
	
	if ZOrbWalker.menu.key.clearKey then
		table.sort(ZOrbWalker.minionTime, function(a,b) return a.timeOfKillTheoretical < b.timeOfKillTheoretical end)
		for i, action in ipairs(ZOrbWalker.minionTime) do	
			if ZOrbWalker:InRange(action.minion) then
				if action.timeOfKillTheoretical < math.huge then
					if ZOrbWalker:SecondAttackLandTime(action.minion) < action.timeOfKillTheoretical + 500 then
						return action.minion
					else
						return nil
					end
				end
			end
		end
		
		ZOrbWalker.enemyMinions:update()
		for i, minion in pairs(ZOrbWalker.enemyMinions.objects) do
			if ZOrbWalker:InRange(minion) then
				if ZOrbWalker:InTable(ZOrbWalker.minionTime, minion.name) then return end
				return minion
			end
		end
	end
end

function ZOrbWalker:GetTower()
	for i = 1, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil and object.type == "obj_AI_Turret" then
			if object.team ~= myHero.team and ZOrbWalker:InRange(object) then
				for i, action in ipairs(ZOrbWalker.minionTime) do	
					if ZOrbWalker:InRange(action.minion) then
						if ZOrbWalker:SecondAttackLandTime(action.minion) < action.timeOfKill then
							return nil
						end
					end
				end
			
				return object
			end
		end
	end
end

function ZOrbWalker:GetEnemy()
	return GetTarget()
end

function ZOrbWalker:GetTime()
	return os.clock() * 1000
end

function ZOrbWalker:ResetAA()
	ZOrbWalker.lastAttack = 0
end

function ZOrbWalker:DisableAttacks()
	ZOrbWalker.attacks = false
end

function ZOrbWalker:EnableAttacks()
	ZOrbWalker.attacks = true
end

function ZOrbWalker:DisableMove()
	ZOrbWalker.move = false
end

function ZOrbWalker:EnableMove()
	ZOrbWalker.move = true
end

function ZOrbWalker:Range(unit)
	return unit.range + GetDistance(unit, unit.minBBox)
end

function ZOrbWalker:InRange(target, attacker)
	attacker = attacker or myHero
	return target and GetDistance(target, attacker) <=  ZOrbWalker:Range(attacker) + GetDistance(target, target.minBBox)
end

function ZOrbWalker:Attack(target)
	ZOrbWalker.lastAttack = ZOrbWalker:GetTime() + ZOrbWalker:Latency()
	ZOrbWalker:BeforeAttack(target)
	myHero:Attack(target)
end

function ZOrbWalker:CanAttack()
	return ZOrbWalker.lastAttack + ZOrbWalker.animationTime - ZOrbWalker:Latency() < ZOrbWalker:GetTime()
end

function ZOrbWalker:CanMove()
	return ZOrbWalker.lastAttack + ZOrbWalker.windUpTime  < ZOrbWalker:GetTime() and not _G.evade
end

function ZOrbWalker:ValidTarget(target)
	return ValidTarget(target) and ZOrbWalker:InRange(target)
end

function ZOrbWalker:OrbWalk(target)
	if ZOrbWalker.attacks and ZOrbWalker:CanAttack() and ZOrbWalker:ValidTarget(target) then
		ZOrbWalker:Attack(target)
	elseif ZOrbWalker:CanMove() and ZOrbWalker.move and GetDistance(mousePos, myHero) > 100 then
		if target and ZOrbWalker:ValidTarget(target) then
			myHero:MoveTo(target.x, target.z)
		else
			myHero:MoveTo(mousePos.x, mousePos.z)
		end
	end
end

function ZOrbWalker:GoTo(point)
	if ZOrbWalker:CanMove() then
		myHero:MoveTo(point.x, point.z)
	end
end

function ZOrbWalker:IsAttack(spellName)
	return (spellName:lower():find("attack") or table.contains(ZOrbWalker.AttackTable, spellName:lower())) and not table.contains(ZOrbWalker.NoAttackTable, spellName:lower())
end

function ZOrbWalker:IsAAReset(spellName)
	if spellName == (type(ZOrbWalker.AttackResetTable[myHero.charName]) == 'number' and myHero:GetSpellData(ZOrbWalker.AttackResetTable[myHero.charName]).name or ZOrbWalker.AttackResetTable[myHero.charName]) then return true end
	return false
end

function ZOrbWalker:Latency()
	return GetLatency() / 2
end

-- Callback Functions --
function ZOrbWalker:BeforeAttack(target)
	for i, cb in ipairs(ZOrbWalker.BeforeAttackCallbacks) do
		cb(target)
	end
end

function ZOrbWalker:RegisterBeforeAttackCallback(f)
	table.insert(ZOrbWalker.BeforeAttackCallbacks, f)
end

function ZOrbWalker:OnAttack(target)
	for i, cb in ipairs(ZOrbWalker.OnAttackCallbacks) do
		cb(target)
	end
end

function ZOrbWalker:RegisterOnAttackCallback(f)
	table.insert(ZOrbWalker.OnAttackCallbacks, f)
end

function ZOrbWalker:AfterAttack(target)
	for i, cb in ipairs(ZOrbWalker.AfterAttackCallbacks) do
		cb(target)
	end
end

function ZOrbWalker:RegisterAfterAttackCallback(f)
	table.insert(ZOrbWalker.AfterAttackCallbacks, f)
end

----------------------
--       Draw       --
----------------------

function DrawCircle(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
		
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 300) 
	end
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(40, Round(180 / math.deg((math.asin((chordlength / (2 * radius)))))))
	quality = 2 * math.pi / quality
	radius = radius * .92
	local points = {}
		
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)	
end

function Round(number)
	if number >= 0 then 
		return math.floor(number+.5) 
	else 
		return math.ceil(number-.5) 
	end
end