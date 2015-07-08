local version = "1.4"
--[[
██████╗ ███████╗██╗  ██╗███████╗ █████╗ ██╗                         
██╔══██╗██╔════╝██║ ██╔╝██╔════╝██╔══██╗██║                         
██████╔╝█████╗  █████╔╝ ███████╗███████║██║                         
██╔══██╗██╔══╝  ██╔═██╗ ╚════██║██╔══██║██║                         
██║  ██║███████╗██║  ██╗███████║██║  ██║██║                         
╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝                         

████████╗██╗  ██╗███████╗                                           
╚══██╔══╝██║  ██║██╔════╝                                           
   ██║   ███████║█████╗                                             
   ██║   ██╔══██║██╔══╝                                             
   ██║   ██║  ██║███████╗                                           
   ╚═╝   ╚═╝  ╚═╝╚══════╝                                           

██╗   ██╗ ██████╗ ██╗██████╗                                        
██║   ██║██╔═══██╗██║██╔══██╗                                       
██║   ██║██║   ██║██║██║  ██║                                       
╚██╗ ██╔╝██║   ██║██║██║  ██║                                       
 ╚████╔╝ ╚██████╔╝██║██████╔╝                                       
  ╚═══╝   ╚═════╝ ╚═╝╚═════╝                                        
 
██████╗ ██╗   ██╗██████╗ ██████╗  ██████╗ ██╗    ██╗███████╗██████╗ 
██╔══██╗██║   ██║██╔══██╗██╔══██╗██╔═══██╗██║    ██║██╔════╝██╔══██╗
██████╔╝██║   ██║██████╔╝██████╔╝██║   ██║██║ █╗ ██║█████╗  ██████╔╝
██╔══██╗██║   ██║██╔══██╗██╔══██╗██║   ██║██║███╗██║██╔══╝  ██╔══██╗
██████╔╝╚██████╔╝██║  ██║██║  ██║╚██████╔╝╚███╔███╔╝███████╗██║  ██║
╚═════╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚══╝╚══╝ ╚══════╝╚═╝  ╚═╝
]]--

if myHero.charName ~= "RekSai" then return end

local REQUIRED_LIBS = {
	["SxOrbWalk"]   = "https://raw.githubusercontent.com/Superx321/BoL/master/common/SxOrbWalk.lua",
	["VPrediction"] = "https://raw.githubusercontent.com/Ralphlol/BoLGit/master/VPrediction.lua"
}

local DOWNLOADING_LIBS, DOWNLOAD_COUNT = false, 0

function AfterDownload()
	DOWNLOAD_COUNT = DOWNLOAD_COUNT - 1
	if DOWNLOAD_COUNT == 0 then
		DOWNLOADING_LIBS = false
		print("<b><font color=\"#6699FF\">Rek'sai - the Void Burrower:</font></b> <font color=\"#FFFFFF\">Required libraries downloaded successfully, please reload (double F9).</font>")
	end
end

for DOWNLOAD_LIB_NAME, DOWNLOAD_LIB_URL in pairs(REQUIRED_LIBS) do
	if FileExist(LIB_PATH .. DOWNLOAD_LIB_NAME .. ".lua") then
		require(DOWNLOAD_LIB_NAME)
	else
		DOWNLOADING_LIBS = true
		DOWNLOAD_COUNT = DOWNLOAD_COUNT + 1
		DownloadFile(DOWNLOAD_LIB_URL, LIB_PATH .. DOWNLOAD_LIB_NAME..".lua", AfterDownload)
	end
end

if DOWNLOADING_LIBS then return end

local autoupdateenabled = true
local UPDATE_SCRIPT_NAME = "Rek'sai - the Void Burrower"
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/CaosJunior/BOL/master/Rek'Sai%20-%20the%20Void%20Burrower.lua"
local UPDATE_FILE_PATH = SCRIPT_PATH..GetCurrentEnv().FILE_NAME
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

local ServerData
if autoupdateenabled then
	GetAsyncWebResult(UPDATE_HOST, UPDATE_PATH, function(d) ServerData = d end)
	function update()
		if ServerData ~= nil then
			local ServerVersion
			local send, tmp, sstart = nil, string.find(ServerData, "local version = \"")
			if sstart then
				send, tmp = string.find(ServerData, "\"", sstart+1)
			end
			if send then
				ServerVersion = tonumber(string.sub(ServerData, sstart+1, send-1))
			end

			if ServerVersion ~= nil and tonumber(ServerVersion) ~= nil and tonumber(ServerVersion) > tonumber(version) then
				DownloadFile(UPDATE_URL.."?nocache"..myHero.charName..os.clock(), UPDATE_FILE_PATH, function () print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> successfully updated. Reload (double F9) Please. ("..version.." => "..ServerVersion..")</font>") end)     
			elseif ServerVersion then
				print("<font color=\"#FF0000\"><b>"..UPDATE_SCRIPT_NAME..":</b> You have got the latest version: <u><b>"..ServerVersion.."</b></u></font>")
			end		
			ServerData = nil
		end
	end
	AddTickCallback(update)
end

local VP = nil

function OnLoad()
	print("<b><font color=\"#FF6600\">Rek'sai - the Void Burrower:</font></b> <font color=\"#FFFFFF\">Good luck and have fun!</font>")
	Menu()
	VP = VPrediction()
	_G.oldDrawCircle = rawget(_G, 'DrawCircle')
	_G.DrawCircle = DrawCircle2
end

function OnTick()
    TargetSelector:update()
    Target = GetCustomTarget()
    SxOrb:ForceTarget(Target)
	check()
	Scape()
	LagFree()
	MyRange = myHero.range + myHero.boundingRadius
	
	if Menu.combo.combo then
		Combo(Target)
	end
end

function Combo(Target)
	if (Target ~= nil) then
		if not UNDERGROUND and (myHero:CanUseSpell(_W) == READY) and Menu.combo.useW and GetDistance(Target) >= 350 and GetDistance(Target) <= 1625 then
			CastSpell(_W)
		end
		if UNDERGROUND then
			if (myHero:CanUseSpell(_Q) == READY) and Menu.combo.useQbur and GetDistance(Target) <= 1625 then
				for i, target in pairs(GetEnemyHeroes()) do
					local CastPosition,  HitChance,  Position = VP:GetLineCastPosition(target, 0, 45, 1625, 4000, myHero, true)
					if HitChance >= 2 and GetDistance(CastPosition) < 1625 then
						CastSpell(_Q, CastPosition.x, CastPosition.z)
					end
				end
			end
			
			if (myHero:CanUseSpell(_E) == READY) and Menu.combo.useEbur and GetDistance(Target) >= Menu.combo.minErange and GetDistance(Target) <= 750 then
				for i, target in pairs(GetEnemyHeroes()) do
					local CastPosition,  Position = VP:GetLineCastPosition(target, 0, 45, 750, 1600, myHero, true)
					if GetDistance(CastPosition) < 750 then
						CastSpell(_E, CastPosition.x, CastPosition.z)
					end
				end
			end
		
		else
		
			if (myHero:CanUseSpell(_Q) == READY) and Menu.combo.useQ and GetDistance(Target) <= 325 then
				CastSpell(_Q)
			end
			
			if (myHero:CanUseSpell(_E) == READY) and Menu.combo.useE and GetDistance(Target) <= 350 then
				for _, enemy in ipairs(GetEnemyHeroes()) do
					if ValidTarget(enemy) and enemy.visible then
						local eDmg = getDmg("E", enemy, myHero)
							if enemy.health <= eDmg then
								CastSpell(_E, Target)
							end
					end
				end
			end	
		end
	end
end

function Scape()
	if not UNDERGROUND and (myHero:CanUseSpell(_W) == READY) and Menu.scape.scape then
		CastSpell(_W)
	end
	
	if UNDERGROUND then
		if (myHero:CanUseSpell(_E) == READY) and Menu.scape.scape then
			CastSpell(_E, mousePos.x, mousePos.z)
		end
	end
	if Menu.scape.scape then
		myHero:MoveTo(mousePos.x, mousePos.z)
	end
end

function check()
	if myHero:GetSpellData(_Q).name == "reksaiqburrowed" or myHero:GetSpellData(_W).name == "reksaiwburrowed" or myHero:GetSpellData(_E).name == "reksaieburrowed" then
		UNDERGROUND = true
	end
	if myHero:GetSpellData(_Q).name == "RekSaiQ" or myHero:GetSpellData(_W).name == "RekSaiW" or myHero:GetSpellData(_E).name == "reksaie" then
		UNDERGROUND = false
	end
end

function Menu()
	Menu = scriptConfig("Rek'sai - the Void Burrower", "reksai")
	Menu:addSubMenu("Combo Settings", "combo")
		Menu.combo:addParam("combo", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Menu.combo:addParam("useQ", "Use (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:addParam("useW", "Use (W) in Combo", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:addParam("useE", "Use (E) to KS in Combo", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:addParam("useQbur", "Use (Q) while burrowed", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:addParam("useEbur", "Use (E) to gapclose while burrowed", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:addParam("minErange", "Minimum distance to use (E)", SCRIPT_PARAM_SLICE, 660, 360, 750, 0)
	Menu:addSubMenu("Escape Settings", "scape")
		Menu.scape:addParam("scape", "Run, Forrest, run!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
	Menu:addSubMenu("Draw Settings", "draw")
		Menu.draw:addSubMenu("Lag Free Circles: ", "LagFree")
		Menu.draw.LagFree:addParam("LagFree", "Lag Free Circles", SCRIPT_PARAM_ONOFF, true)
		Menu.draw.LagFree:addParam("CL", "Length before Snapping", SCRIPT_PARAM_SLICE, 350, 75, 2000, 0)
		Menu.draw.LagFree:addParam("CLinfo", "Higher length = Lower FPS Drops", SCRIPT_PARAM_INFO, "")
		Menu.draw:addParam("drawAA", "Draw AA range", SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawQbur", "Draw (Q) range while burrowed", SCRIPT_PARAM_ONOFF, true)
		Menu.draw:addParam("drawEbur", "Draw (E) range while burrowed", SCRIPT_PARAM_ONOFF, true)
	Menu:addSubMenu("Orbwalk Settings", "orb")
		SxOrb:LoadToMenu(Menu.orb)
		
	TargetSelector = TargetSelector(TARGET_LESS_CAST, 1625, DAMAGE_PHYSICAL, true)
	TargetSelector.name = "RekSai"
	Menu:addTS(TargetSelector)
end

function LagFree()
	if not Menu.draw.LagFree.LagFree then _G.DrawCircle = _G.oldDrawCircle end
	if Menu.draw.LagFree.LagFree then _G.DrawCircle = DrawCircle2 end
end

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
        DrawCircleNextLvl(x, y, z, radius, 1, color, Menu.draw.LagFree.CL) 
    end
end

function OnDraw()
	if not myHero.dead then
		if Menu.draw.drawQbur and UNDERGROUND and (myHero:CanUseSpell(_Q) == READY) then
			DrawCircle(myHero.x, myHero.y, myHero.z, 1625, ARGB(255,255,0,0))
		end
		if Menu.draw.drawEbur and UNDERGROUND and (myHero:CanUseSpell(_E) == READY) then
			DrawCircle(myHero.x, myHero.y, myHero.z, 750, ARGB(255,255,0,0))
		end
		if Menu.draw.drawAA then
			DrawCircle(myHero.x, myHero.y, myHero.z, MyRange, ARGB(255,255,0,0))
		end
	end
end

function GetCustomTarget()
	TargetSelector:update()        
	if _G.MMA_Target and _G.MMA_Target.type == myHero.type then return _G.MMA_Target end
	if _G.AutoCarry and _G.AutoCarry.Crosshair and _G.AutoCarry.Attack_Crosshair and _G.AutoCarry.Attack_Crosshair.target and _G.AutoCarry.Attack_Crosshair.target.type == myHero.type then return _G.AutoCarry.Attack_Crosshair.target end
	return TargetSelector.target
end