--[[PippyAshe
by
DaPipex]]

local version = "1.11"

local DaPipexAsheUpdate = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/DaPipex/BoL_Scripts/master/PippyAshe.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

--[[
                                                                        
,------. ,--.                            ,---.         ,--.             
|  .--. '`--' ,---.  ,---.,--. ,--.     /  O  \  ,---. |  ,---.  ,---.  
|  '--' |,--.| .-. || .-. |\  '  /     |  .-.  |(  .-' |  .-.  || .-. : 
|  | --' |  || '-' '| '-' ' \   '      |  | |  |.-'  `)|  | |  |\   --. 
`--'     `--'|  |-' |  |-'.-'  /       `--' `--'`----' `--' `--' `----' 
             `--'   `--'  `---'                                         
]]--

if myHero.charName ~= "Ashe" then return end

function printScript(message)
	PrintChat("<font color='#08B4D7'><b>Pippy Ashe:</b></font> <font color='#FFFFFF'>"..message.."</font>")
end

if DaPipexAsheUpdate then
	local ServerData = GetWebResult(UPDATE_HOST, "/DaPipex/BoL_Scripts/master/PippyAshe.version")
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				printScript("New version available: "..ServerVersion)
				printScript("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () printScript("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				printScript("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		printScript("Error downloading version info")
	end
end

local lib_Required = {

	["VPrediction"]	= "https://raw.github.com/Ralphlol/BoLGit/master/VPrediction.lua",
	["Sourcelib"] = "https://raw.github.com/TheRealSource/public/master/common/SourceLib.lua"

}

local lib_Required_Sx = {
	["SxOrbWalk"]	= "https://raw.github.com/Superx321/BoL/master/common/SxOrbWalk.lua"
}

local lib_downloadNeeded, lib_downloadCount = false, 0

function AfterDownload()
	lib_downloadCount = lib_downloadCount - 1
	if lib_downloadCount == 0 then
		lib_downloadNeeded = false
		printScript("Required libraries downloaded successfully, please reload (double F9)")
	end
end

for lib_downloadName, lib_downloadUrl in pairs(lib_Required) do
	local lib_fileName = LIB_PATH .. lib_downloadName .. ".lua"

	if FileExist(lib_fileName) then
		require(lib_downloadName)
	else
		lib_downloadNeeded = true
		lib_downloadCount = lib_downloadCount and lib_downloadCount + 1 or 1
		printScript("Downloading: "..lib_downloadName)
		DownloadFile(lib_downloadUrl, lib_fileName, function() AfterDownload() end)
	end
end

if lib_downloadNeeded then return end


function CheckSAC()
	if (_G.AutoCarry ~= nil) or (_G.Reborn_Loaded ~= nil) then
		return true
	else
		return false
	end
end


function OnLoad()

	loadDone = false

	AsheVars()
	ItemVars()
	AsheMenu()
	DelayAction(LoadSxLib, 6)
	--printScript("Script Loaded! Version: "..version)
end

function LoadSxLib()
	if not CheckSAC() then
		if FileExist(LIB_PATH.."SxOrbWalk.lua") then
			require "SxOrbWalk"
			AshyMenu:addSubMenu("Orbwalking", "orbw")
			SxOrb:LoadToMenu(AshyMenu.orbw)
		else
			local DownloadLoc = lib_Required_Sx["SxOrbWalk"]
			DownloadFile(DownloadLoc, LIB_PATH.."SxOrbWalk.lua", function() printScript("Downloaded: SxOrbWalk. Please Reload (Double F9)") end)
		end
	else
		AshyMenu:addParam("info4", "Orbwalking", SCRIPT_PARAM_INFO, "SAC:R")
		_G.AutoCarry.Skills:DisableAll()
	end
end

function AsheVars()

	Spell = {

		AA = {Range = 600},
		I  = {Ready = false, Slot = nil},
		Q  = {Enabled = false, Ready = false},
		W  = {Range = 1200, Speed = 902, Delay = .25, Width = 45, Ready = false},
		E  = {Range = 0},
		R  = {Range = math.huge, Speed = 1600, Delay = .25, Width = 130, Ready = false}

	}

	AbilitySequence = {2, 1, 3, 2, 2, 4, 2, 1, 2, 1, 4, 1, 1, 3, 3, 4, 3, 3}

	MyTrueRange = (Spell.AA.Range + GetDistance(myHero.minBBox))

	VP = VPrediction()
	STSa = SimpleTS(STS_PRIORITY_LESS_CAST_PHYSICAL)
	ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, Spell.W.Range, DAMAGE_PHYSICAL)
	ts.name = "Allclass"
	tsUlti = TargetSelector(TARGET_CLOSEST, 1000, DAMAGE_MAGIC)
	tsUlti.name = "Ultimate"

	InterruptGame = {}
	InterruptComplete = {
		{ nombre = "Caitlyn"     , hechizo = "CaitlynAceintheHole"},
		{ nombre = "FiddleSticks", hechizo = "Crowstorm"},
		{ nombre = "FiddleSticks", hechizo = "DrainChannel"},
		{ nombre = "Galio"       , hechizo = "GalioIdolOfDurand"},
		{ nombre = "Karthus"     , hechizo = "FallenOne"},
		{ nombre = "Katarina"    , hechizo = "KatarinaR"},
		{ nombre = "Lucian"      , hechizo = "LucianR"},
		{ nombre = "Malzahar"    , hechizo = "AlZaharNetherGrasp"},
		{ nombre = "MissFortune" , hechizo = "MissFortuneBulletTime"},
		{ nombre = "Nunu"        , hechizo = "AbsoluteZero"},
		{ nombre = "Shen"        , hechizo = "ShenStandUnited"},
		{ nombre = "Urgot"       , hechizo = "UrgotSwap2"},
		{ nombre = "Varus"       , hechizo = "VarusQ"},
		{ nombre = "Velkoz"      , hechizo = "VelkozR"},
		{ nombre = "Warwick"     , hechizo = "InfiniteDuress"}
	}

	for i, enemigo in pairs(GetEnemyHeroes()) do
		for j, campeon in pairs(InterruptComplete) do
			if enemigo.charName == campeon.nombre then
				table.insert(InterruptGame, campeon)
			end
		end
	end

	if myHero:GetSpellData(SUMMONER_1).name:find("summonerdot") then
		Spell.I.Slot = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("summonerdot") then
		Spell.I.Slot = SUMMONER_2
	end

end

function ItemVars()

	Item = {

		BOTRK = {Slot = nil, Ready = nil},
		BC    = {Slot = nil, Ready = nil},
		YMG   = {Slot = nil, Ready = nil}

	}

end

function AsheMenu()

	AshyMenu = scriptConfig("Pippy Ashe", "PippyAshe")

	AshyMenu:addSubMenu("Combo Settings", "combo")
	AshyMenu.combo:addParam("useQ", "Use Q against champions", SCRIPT_PARAM_ONOFF, true)
	--AshyMenu.combo:addParam("useQrange", "Q Range", SCRIPT_PARAM_SLICE, MyTrueRange, 1, MyTrueRange, 0)
	AshyMenu.combo:addParam("useW", "Use W", SCRIPT_PARAM_ONOFF, true)
	--AshyMenu.combo:addParam("useW", "Use W...", SCRIPT_PARAM_LIST, 2, { "Never", "Single Target", "AOE" })
	--AshyMenu.combo:addParam("useWminAOE", "W AOE min enemies", SCRIPT_PARAM_SLICE, 2, 2, 5, 0)
	AshyMenu.combo:addParam("useR", "Use R", SCRIPT_PARAM_ONOFF, false)

	AshyMenu:addSubMenu("Harass Settings", "harass")
	--AshyMenu.harass:addParam("useQ", "Use Q when enemy in range", SCRIPT_PARAM_ONOFF, false)
	--AshyMenu.harass:addParam("useQrange", "Q Range", SCRIPT_PARAM_SLICE, MyTrueRange, 1, MyTrueRange, 0)
	AshyMenu.harass:addParam("useW", "Use W (Single Target)", SCRIPT_PARAM_ONOFF, true)

	AshyMenu:addSubMenu("Hitchance Settings", "hc")
	AshyMenu.hc:addParam("wCombo", "W - Combo", SCRIPT_PARAM_LIST, 1, { "Low", "High" })
	AshyMenu.hc:addParam("wHarass", "W - Harass", SCRIPT_PARAM_LIST, 1, { "Low", "High" })
	AshyMenu.hc:addParam("rCombo", "R - Combo", SCRIPT_PARAM_LIST, 2, { "Low", "High" })
	AshyMenu.hc:addParam("rHelper", "R - Helper", SCRIPT_PARAM_LIST, 2, { "Low", "High" })

	AshyMenu:addSubMenu("Interrupter Settings", "interrupt")
	AshyMenu.interrupt:addParam("interruptRange", "Interrupt Range", SCRIPT_PARAM_SLICE, 1000, 1, 1500, 0)
	if #InterruptGame > 0 then
		AshyMenu.interrupt:addParam("info8", "", SCRIPT_PARAM_INFO, "")
		for i, v in pairs(InterruptGame) do
			AshyMenu.interrupt:addParam(v.hechizo, v.nombre.."-"..v.hechizo, SCRIPT_PARAM_ONOFF, true)
		end
	else
		AshyMenu.interrupt:addParam("info1", "No supported spells found", SCRIPT_PARAM_INFO, "")
	end

	AshyMenu:addSubMenu("Ult Helper", "ulti")
	AshyMenu.ulti:addParam("fireKey", "Fire ult Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
	AshyMenu.ulti:addParam("info7", "Range to check:", SCRIPT_PARAM_INFO, "1500")
	--AshyMenu.ulti:addParam("fireMode", "Fire Mode", SCRIPT_PARAM_LIST, 1, { "Closest Enemy", "Ult Target Selector" })
	AshyMenu.ulti:addTS(tsUlti)

	AshyMenu:addSubMenu("Killsteal Settings", "ks")
	AshyMenu.ks:addParam("ksIgnite", "KS with Ignite", SCRIPT_PARAM_ONOFF, true)
	AshyMenu.ks:addParam("ksW", "KS with W", SCRIPT_PARAM_ONOFF, true)
	AshyMenu.ks:addParam("ksR", "KS with R", SCRIPT_PARAM_ONOFF, true)
	AshyMenu.ks:addParam("ksRrange", "KS with R range", SCRIPT_PARAM_SLICE, 650, 1, 1500, 0)

	AshyMenu:addSubMenu("Items Settings", "item")
	AshyMenu.item:addParam("useBOTRK", "Use Ruined King", SCRIPT_PARAM_ONOFF, true)
	AshyMenu.item:addParam("useBC", "Use Bilgewater Cutlass", SCRIPT_PARAM_ONOFF, true)
	AshyMenu.item:addParam("useYMG", "Use Youmouu's Ghostblade", SCRIPT_PARAM_ONOFF, true)

	AshyMenu:addSubMenu("Drawing Settings", "draw")
	AshyMenu.draw:addParam("lfc", "Use Lag Free Circles", SCRIPT_PARAM_ONOFF, true)
	AshyMenu.draw:addParam("lfcQuality", "LFC Quality", SCRIPT_PARAM_SLICE, 300, 75, 550, 0)
	--AshyMenu.draw:addParam("qRange", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
	--AshyMenu.draw:addParam("qColor", "Color:", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	AshyMenu.draw:addParam("wRange", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
	AshyMenu.draw:addParam("wColor", "Color:", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	AshyMenu.draw:addParam("eRangeMM", "Draw E Range (Minimap)", SCRIPT_PARAM_ONOFF, true)
	AshyMenu.draw:addParam("eColor", "Color:", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	AshyMenu.draw:addParam("rKsRange", "Draw R KS Range", SCRIPT_PARAM_ONOFF, false)
	AshyMenu.draw:addParam("rColor", "Color:", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})
	AshyMenu.draw:addParam("rInterruptRange", "Draw R Interrupt Range", SCRIPT_PARAM_ONOFF, false)
	AshyMenu.draw:addParam("rInterColor", "Color:", SCRIPT_PARAM_COLOR, {255, 255, 255, 255})

	AshyMenu:addSubMenu("Target Selection Settings", "ts")
	AshyMenu.ts:addTS(ts)
	AshyMenu.ts:addParam("info5", "-------------------", SCRIPT_PARAM_INFO, "")
	AshyMenu.ts:addParam("chooseTS", "Choose TS", SCRIPT_PARAM_LIST, 1, { "Allclass TS", "SimpleTS" })
	AshyMenu.ts:addParam("info6", "-------------------", SCRIPT_PARAM_INFO, "")
	STSa:AddToMenu(AshyMenu.ts)

	AshyMenu:addSubMenu("Auto Level Settings", "als")
	AshyMenu.als:addParam("option1", "Auto Level: R-W-Q-E", SCRIPT_PARAM_ONOFF, false)

	AshyMenu:addParam("comboKey", "Combo Key (SPACE)", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	AshyMenu:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))

	AshyMenu:addParam("info2", "Version:", SCRIPT_PARAM_INFO, version)
	AshyMenu:addParam("info3", "Author:", SCRIPT_PARAM_INFO, "DaPipex")

	loadDone = true

end

function OnTick()

	if loadDone then

		Checks()
		Killsteal()

		if AshyMenu.comboKey then
			Combo()
			UseItems()
		end

		if AshyMenu.harassKey then
			Harass()
		end

		if AshyMenu.ulti.fireKey then
			UltHelper()
		end

		if AshyMenu.als.option1 then
			AutoLevelSpells()
		end
	end
end

function Checks()

	Spell.Q.Ready = (myHero:CanUseSpell(_Q) == READY)
	Spell.W.Ready = (myHero:CanUseSpell(_W) == READY)
	Spell.R.Ready = (myHero:CanUseSpell(_R) == READY)
	Spell.I.Ready = (Spell.I.Slot ~= nil) and (myHero:CanUseSpell(Spell.I.Slot) == READY)

	Item.BOTRK.Slot = GetInventorySlotItem(3153)
	Item.BC.Slot = GetInventorySlotItem(3144)
	Item.YMG.Slot = GetInventorySlotItem(3142)

	Item.BOTRK.Ready = (Item.BOTRK.Slot ~= nil) and (myHero:CanUseSpell(Item.BOTRK.Slot) == READY)
	Item.BC.Ready = (Item.BC.Slot ~= nil) and (myHero:CanUseSpell(Item.BC.Slot) == READY)
	Item.YMG.Ready = (Item.YMG.Slot ~= nil) and (myHero:CanUseSpell(Item.YMG.Slot) == READY)

	Target = CustomTarget()

	TargetUlti = tsUlti.target

	ts:update()
	tsUlti:update()

	Spell.E.Range = 2500 + (myHero:GetSpellData(_E).level - 1) * 750

end

function AutoLevelSpells()

	local qLevel = myHero:GetSpellData(_Q).level
	local wLevel = myHero:GetSpellData(_W).level
	local eLevel = myHero:GetSpellData(_E).level
	local rLevel = myHero:GetSpellData(_R).level

	if qLevel + wLevel + eLevel + rLevel < myHero.level then
		local spellSlot = { SPELL_1, SPELL_2, SPELL_3, SPELL_4 }
		local level = { 0, 0, 0, 0 }
		for i = 1, player.level, 1 do
			level[AbilitySequence[i]] = level[AbilitySequence[i]] + 1
		end
		for i, v in ipairs({ qLevel, wLevel, eLevel, rLevel }) do
			if v < level[i] then LevelSpell(spellSlot[i]) end
		end
	end
end



function Combo()

	if Target ~= nil then

		if Spell.W.Ready then
			if AshyMenu.combo.useW then
				local CastPosition, HitChance, Position = VP:GetLineCastPosition(Target, Spell.W.Delay, Spell.W.Width, Spell.W.Range, Spell.W.Speed, myHero, true)
				if HitChance >= AshyMenu.hc.wCombo then
					CastSpell(_W, CastPosition.x, CastPosition.z)
				end
			end
		end

		if Spell.R.Ready then
			if AshyMenu.combo.useR then
				local CastPosition, HitChance, Position = VP:GetLineCastPosition(Target, Spell.R.Delay, Spell.R.Width, 1000, Spell.R.Speed, myHero, false)
				if HitChance >= AshyMenu.hc.rCombo then
					CastSpell(_R, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
end

function Harass()

	if Target ~= nil then

		if Spell.W.Ready then
			if AshyMenu.harass.useW then
				local CastPosition, HitChance, Position = VP:GetLineCastPosition(Target, Spell.W.Delay, Spell.W.Width, Spell.W.Range, Spell.W.Speed, myHero, true)
				if HitChance >= AshyMenu.hc.wHarass then
					CastSpell(_W, CastPosition.x, CastPosition.z)
				end
			end
		end
	end
end

function UltHelper()

	if Spell.R.Ready then
		if TargetUlti ~= nil then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(TargetUlti, Spell.R.Delay, Spell.R.Width, 1000, Spell.R.Speed, myHero, false)
			if HitChance >= AshyMenu.hc.rHelper then
				CastSpell(_R, CastPosition.x, CastPosition.z)
			end
		end
	end
end

function UseItems()

	if Target ~= nil then

		if AshyMenu.item.useBOTRK and (GetDistance(Target) < 450) then
			if Item.BOTRK.Ready then
				CastSpell(Item.BOTRK.Slot, Target)
			end
		end

		if AshyMenu.item.useBC and (GetDistance(Target) < 450) then
			if Item.BC.Ready then
				CastSpell(Item.BC.Slot, Target)
			end
		end

		if AshyMenu.item.useYMG and (GetDistance(Target) < (MyTrueRange - 100)) then
			if Item.YMG.Ready then
				CastSpell(Item.YMG.Slot)
			end
		end
	end
end

function Killsteal()

	local enemies = GetEnemyHeroes()
	for i, enemy in pairs(enemies) do

		if AshyMenu.ks.ksIgnite and Spell.I.Ready then
			if (GetDistance(enemy) < 600) and ValidTarget(enemy) then
				if getDmg("IGNITE", enemy, myHero) > enemy.health then
					CastSpell(Spell.I.Slot, enemy)
				end
			end
		end

		if AshyMenu.ks.ksW and Spell.W.Ready then
			if (GetDistance(enemy) < Spell.W.Range) and ValidTarget(enemy) then
				if getDmg("W", enemy, myHero) > enemy.health then
					local CastPosition, HitChance, Position = VP:GetLineCastPosition(enemy, Spell.W.Delay, Spell.W.Width, Spell.W.Range, Spell.W.Speed, myHero, true)
					if HitChance >= 1 then
						CastSpell(_W, CastPosition.x, CastPosition.z)
					end
				end
			end
		end

		if AshyMenu.ks.ksR and Spell.R.Ready then
			if (GetDistance(enemy) < AshyMenu.ks.ksRrange) and ValidTarget(enemy) then
				if getDmg("R", enemy, myHero) > enemy.health then
					local CastPosition, HitChance, Position = VP:GetLineCastPosition(enemy, Spell.R.Delay, Spell.R.Width, AshyMenu.ks.ksRrange, Spell.R.Speed, myHero, false)
					if HitChance >= 2 then
						CastSpell(_R, CastPosition.x, CastPosition.z)
					end
				end
			end
		end
	end
end

function OnDraw()

	if loadDone and not myHero.dead then

		if AshyMenu.draw.lfc then
			--if AshyMenu.draw.qRange then
			--	DrawCircle2(myHero.x, myHero.y, myHero.z, AshyMenu.combo.useQrange, TARGB(AshyMenu.draw.qColor))
			--end

			if AshyMenu.draw.wRange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, Spell.W.Range, TARGB(AshyMenu.draw.wColor))
			end

			if AshyMenu.draw.eRangeMM then
				DrawCircleMinimap(myHero.x, myHero.y, myHero.z, Spell.E.Range, 1, TARGB(AshyMenu.draw.eColor), 300)
			end

			if AshyMenu.draw.rKsRange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, AshyMenu.ks.ksRrange, TARGB(AshyMenu.draw.rColor))
			end

			if AshyMenu.draw.rInterruptRange then
				DrawCircle2(myHero.x, myHero.y, myHero.z, AshyMenu.interrupt.interruptRange, TARGB(AshyMenu.draw.rInterColor))
			end
		else
			--if AshyMenu.draw.qRange then
			--	DrawCircle(myHero.x, myHero.y, myHero.z, AshyMenu.combo.useQrange, TARGB(AshyMenu.draw.qColor))
			--end

			if AshyMenu.draw.wRange then
				DrawCircle(myHero.x, myHero.y, myHero.z, Spell.W.Range, TARGB(AshyMenu.draw.wColor))
			end

			if AshyMenu.draw.eRangeMM then
				DrawCircleMinimap(myHero.x, myHero.y, myHero.z, Spell.E.Range, 1, TARGB(AshyMenu.draw.eColor), 300)
			end

			if AshyMenu.draw.rKsRange then
				DrawCircle(myHero.x, myHero.y, myHero.z, AshyMenu.ks.ksRrange, TARGB(AshyMenu.draw.rColor))
			end

			if AshyMenu.draw.rInterruptRange then
				DrawCircle(myHero.x, myHero.y, myHero.z, AshyMenu.interrupt.interruptRange, TARGB(AshyMenu.draw.rInterColor))
			end
		end
	end
end

-- Lag free circles (by barasia, vadash and viseversa)
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
		DrawCircleNextLvl(x, y, z, radius, 1, color, AshyMenu.draw.lfcQuality) 
	end
end

function TARGB(colorTable)
	return ARGB(colorTable[1], colorTable[2], colorTable[3], colorTable[4])
end

function CustomTarget()

	if AshyMenu.ts.chooseTS == 1 then
		return ts.target
	elseif AshyMenu.ts.chooseTS == 2 then
		return STSa:GetTarget(Spell.W.Range)
	end
end

function OnProcessSpell(unit, spell)

	if unit.isMe and spell.name:lower():find("attack") then
		Spell.Q.Enabled = false
		if spell.target.type == myHero.type then
			if AshyMenu.combo.useQ then
				CastSpell(_Q)
			end
		end
	elseif unit.isMe and spell.name == "frostarrow" then
		Spell.Q.Enabled = true
		if spell.target.type ~= myHero.type then
			if AshyMenu.combo.useQ then
				CastSpell(_Q)
			end
		end
	end

	if #InterruptGame > 0 and Spell.R.Ready then
		for i, v in pairs(InterruptGame) do
			if (spell.name == v.hechizo) and (unit.team ~= myHero.team) and AshyMenu.interrupt[v.hechizo] then
				if GetDistance(unit) < AshyMenu.interrupt.interruptRange then
					CastSpell(_R, unit.x, unit.z)
				end
			end
		end
	end
end
