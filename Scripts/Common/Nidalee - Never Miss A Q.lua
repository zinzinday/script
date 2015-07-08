if myHero.charName ~= "Nidalee" then return end
require "Collision"
require "2Dgeometry"


------------- TRAP PLACEMENT Configuration ------------------
 
local highEnabled         = true -- Enable High Priority trapes
local medEnabled          = true -- Enable Medium Priority trapes
local lowEnabled          = true -- Enable Low Priority trapes
local blueEnabled         = true -- Enable Blue Team trapes (in and around blue jungle)
local purpEnabled         = true -- Enable Purple Team trapes (in and around purple jungle)
 
local autotrapHigh  = true -- Auto-trap high priority locations
 
--[[local NidaleeConfig.showLocationsInRange = 1200 -- When you press W, locations in this range will be shown
local NidaleeConfig.showClose = true -- Show trap locations that are close to you
local NidaleeConfig.showCloseRange = 800]]

--NidaleeConfig.drawtrapSpots = false
 --------------------------------------------
 
 --------------TRAP PLACEMENT Locations------
 red, yellow, green, blue, purple = 0x990000, 0x993300, 0x00FF00, 0x000099, 0x660066

trapSpots = {
        -- High priority for both sides
        HighPriority =  {
                                                Locations = {
                                                                                { x = 3316.20,  y = -74.06, z = 9334.85},
                                                                                { x = 4288.76,  y = -71.71, z = 9902.76},
                                                                                { x = 3981.86,  y = 39.54,      z = 11603.55},
                                                                                { x = 6435.51,  y = 47.51,      z = 9076.02},
                                                                                { x = 9577.91,  y = 45.97,      z = 6634.53},
                                                                                { x = 7635.25,  y = 45.09,      z = 5126.81},
                                                                                { x = 10731.51, y = -30.77, z = 5287.01},
                                                                                { x = 9662.24,  y = -70.79, z = 4536.15},
                                                                                { x = 10080.45, y = 44.48,      z = 2829.56}  
                                                                        },
                                                Colour = red,
                                                Enabled = highEnabled,
                                                Auto = autotrapHigh
                                        },
-- Medium priority for both sides
        MediumPriority ={
                                                Locations = {
                                                                                { x = 3283.18,  y = -69.64, z = 10975.15},
                                                                                { x = 2595.85,  y = -74.00, z = 11044.66},
                                                                                { x = 2524.10,  y = 23.36,      z = 11912.28},
                                                                                { x = 4347.64,  y = 43.34,      z = 7796.28},
                                                                                { x = 6093.20,  y = -67.90, z = 8067.45},
                                                                                { x = 7960.99,  y = -73.41, z = 6233.09},
                                                                                { x = 10652.57, y = -58.96, z = 3507.64},
                                                                                { x = 11460.14, y = -63.94, z = 3544.83},
                                                                                { x = 11401.81, y = -11.72, z = 2626.61}  
                                                                        },
                                                Colour = yellow,
                                                Enabled = medEnabled,
                                                Auto = false
                                        },
-- Low priority/situational for both sides
        LowPriority =   {
                                                Locations = {
                                                                                { x = 1346.10,  y = 26.56,      z = 11064.81},
                                                                                { x = 705.87,   y = 26.93,      z = 11359.88},
                                                                                { x = 762.80,   y = 26.15,      z = 12210.61},
                                                                                { x = 1355.53,  y = 24.13,      z = 12936.99},
                                                                                { x = 1926.92,  y = 25.14,      z = 11567.44},
                                                                                { x = 1752.22,  y = 24.02,      z = 13176.95},
                                                                                { x = 2512.96,  y = 21.74,      z = 13524.44},
                                                                                { x = 3577.42,  y = 25.27,      z = 12429.88},
                                                                                { x = 5246.01,  y = 30.91,      z = 12508.33},
                                                                                { x = 5549.60,  y = 42.94,      z = 10917.27},
                                                                                { x = 6552.56,  y = 47.09,      z = 9688.99},
                                                                                { x = 5806.41,  y = 46.01,      z = 9918.99},
                                                                                { x = 7112.27,  y = 46.86,      z = 8443.55},
                                                                                { x = 4896.10,  y = -72.08, z = 8964.81},
                                                                                { x = 3096.10,  y = 45.41,      z = 8164.81},
                                                                                { x = 2390.53,  y = 46.57,      z = 5232.34},
                                                                                { x = 4358.81,  y = 45.83,      z = 5834.64},
                                                                                { x = 5746.10,  y = 42.52,      z = 4864.81},
                                                                                { x = 6307.66,  y = 46.07,      z = 7165.92},
                                                                                { x = 5443.82,  y = 45.64,      z = 7110.85},
                                                                                { x = 5153.75,  y = 45.41,      z = 3358.76},
                                                                                { x = 6876.07,  y = 46.44,      z = 5897.48},
                                                                                { x = 6881.30,  y = 46.08,      z = 6555.85},
                                                                                { x = 8555.10,  y = 46.36,      z = 7267.04},
                                                                                { x = 7946.10,  y = 44.19,      z = 7214.81},
                                                                                { x = 9088.99,  y = -73.12, z = 5441.11},
                                                                                { x = 7687.96,  y = 46.12,      z = 5203.08},
                                                                                { x = 8559.97,  y = 47.97,      z = 3477.87},
                                                                                { x = 8841.04,  y = 52.28,      z = 1944.09},
                                                                                { x = 10582.93, y = 43.25,      z = 1707.35},
                                                                                { x = 11046.10, y = 43.26,      z = 964.81},
                                                                                { x = 11682.20, y = 43.40,      z = 1061.03},
                                                                                { x = 12420.51, y = 46.87,      z = 1532.34},
                                                                                { x = 12819.32, y = 45.74,      z = 1931.32},
                                                                                { x = 13275.52, y = 45.38,      z = 2873.69},
                                                                                { x = 11978.71, y = 45.49,      z = 2914.69},
                                                                                { x = 13379.36, y = 45.37,      z = 3499.62},
                                                                                { x = 12818.08, y = 45.38,      z = 3625.44},
                                                                                { x = 10985.17, y = 45.69,      z = 6305.81},
                                                                                { x = 11580.80, y = 41.26,      z = 9214.09},
                                                                                { x = 9574.88,  y = 44.40,      z = 8679.65},
                                                                                { x = 8359.96,  y = 44.37,      z = 9595.58},
                                                                                { x = 8927.12,  y = 48.17,      z = 11175.70}  
                                                                        },
                                                Colour = green,
                                                Enabled = lowEnabled,
                                                Auto = false
                                        },
-- blue team areas
        BlueOnly = {
                                                Locations = {
																				{ x = 3529.24, y = 54.65, z = 7700.50},  -- Blue Camp
                                                                                { x = 6397.00, y = 51.67, z = 5065.00},  -- Wraith Camp
                                                                                { x = 3388.47, y = 55.61, z = 6168.49},  -- Wolf Camp
                                                                                { x = 7586.97, y = 57.00, z = 3828.58},  -- Red Camp
                                                                                { x = 7445.00, y = 55.60, z = 3365.00},  -- Red Camp(Bush, E little minion closest to bush)
                                                                                { x = 8055.41, y = 54.28, z = 2671.30},  -- Golem Camp
                                                                                { x = 2112.87, y = 43.81, z = 7047.48},
                                                                                { x = 2646.25, y = 45.84, z = 7545.78},
                                                                                { x = 1926.95, y = 44.83, z = 9515.71},
                                                                                { x = 4239.97, y = 44.40, z = 7132.02},
                                                                                { x = 6149.34, y = 42.51, z = 4481.88},
                                                                                { x = 6630.28, y = 46.56, z = 2836.88},
                                                                                { x = 7687.62, y = 45.54, z = 3210.98},
                                                                                { x = 7050.22, y = 46.46, z = 2351.33} 
                                                                        },
                                                Colour = blue,
                                                Enabled = blueEnabled,
                                                Auto = false
                                },
-- purple team areas
        PurpleOnly =    {
                                        Locations = {
																		{ x = 10520.72, y = 54.87, z = 6927.20}, -- Blue Camp
                                                                        { x = 7645.00, y = 55.20, z = 9413.00 }, -- Wraith Camp
                                                                        { x = 10580.53, y = 65.54, z = 7958.30}, -- Wolf Camp
                                                                        { x = 6431.00, y = 54.63, z = 10535.00}, -- Red Camp
                                                                        { x = 6597.55, y = 54.63, z = 11117.78}, -- Red Camp(Bush, E little minion closest to bush)
                                                                        { x = 6143.00, y = 39.55, z = 11777.00},  -- Golem Camp
                                                                        { x = 7466.52, y = 41.54, z = 11720.22},
                                                                        { x = 6945.85, y = 43.53, z = 11901.30},
                                                                        { x = 6636.28, y = 45.03, z = 11079.65},
                                                                        { x = 7878.53, y = 43.83, z = 10042.65},
                                                                        { x = 9701.57, y = 45.72, z = 7298.22},
                                                                        { x = 11358.86, y = 45.71, z = 6872.10},
                                                                        { x = 11946.10, y = 45.80, z = 7414.81},
                                                                        { x = 12169.52, y = 44.03, z = 4858.85}  
                                                                },
                                        Colour = purple,
                                        Enabled = purpEnabled,
                                        Auto = false
                                }
}

 --------------------------------------------
 

 
 --------------------------------------------

--Q VIP Prediction
local QRange = 1500
local QSpeed = 1300
local QDelay = 0.100
local QWidth = 60
local travelDuration = 0

--Q normal prediction
local qrange = 1500
local delay = 100
local speed = 1300
local QWidth = 60
local travelDuration = 0
local predic = nil

function OnLoad()
		enemyMinions = minionManager(MINION_ENEMY, 1550, player)
        qp = TargetPredictionVIP(QRange, QSpeed, QDelay, Qwidth)
        wp = TargetPredictionVIP(900, math.huge, 0.400, 80)
        col = Collision(QRange, QSpeed, QDelay, QWidth)
        NidaleeConfig = scriptConfig("The Bestial Huntress", "Nidalee")
        NidaleeConfig:addParam("AutoQ", "Spear Harras", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("T"))
        NidaleeConfig:addParam("Combo", "Space To Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
        NidaleeConfig:addParam("Heal", "Auto Heal", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("J"))
        NidaleeConfig:addParam("SelfHeal", "Self Heal", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("K"))
        NidaleeConfig:addParam("FHeal", "Force Heal", SCRIPT_PARAM_ONKEYTOGGLE, false, string.byte("L"))
		
		NidaleeConfig:addParam("ManaCheck", "Min Mana", SCRIPT_PARAM_SLICE, 0.3, 0, 1, 2)
		NidaleeConfig:addParam("WPos", "Lock on Traps", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("W"))
		NidaleeConfig:addParam("DrawCircle", "DrawCircles", SCRIPT_PARAM_ONOFF, true)
		NidaleeConfig:addParam("showLocationsInRange", "showLocationsInRange", SCRIPT_PARAM_SLICE, 800, 300, 1500, 1)
		NidaleeConfig:addParam("showClose", "showClose", SCRIPT_PARAM_ONOFF, true)
		NidaleeConfig:addParam("drawtrapSpots", "drawtrapSpots", SCRIPT_PARAM_ONOFF, true)
		NidaleeConfig:addParam("showCloseRange", "showCloseRange", SCRIPT_PARAM_SLICE, 800, 200, 1500, 1)
		NidaleeConfig:addParam("QHitChance", "Q Hit Chance", SCRIPT_PARAM_SLICE, 0.7, 0.1, 1, 2)
		
		NidaleeConfig:addParam("Debugging", "Debugging", SCRIPT_PARAM_ONOFF, false)
		
        NidaleeConfig:permaShow("AutoQ")
        NidaleeConfig:permaShow("Combo")
        NidaleeConfig:permaShow("FHeal")
        NidaleeConfig:permaShow("Heal")
				NidaleeConfig:permaShow("WPos")
 
        ts = TargetSelector(TARGET_NEAR_MOUSE, 2000, DAMAGE_MAGICAL, false)
        ts.name = "Nidalee"
        NidaleeConfig:addTS(ts)
        PrintChat("<font color='#CCCCCC'> >> Nidalee - by Pain loaded! <<</font>")
end


function OnTick()
wTraps()
for i, group in pairs(trapSpots) do
	for x, trapspot in pairs(group.Locations) do
		if trapSpot and group.Enabled and group.Auto and GetDistance(trapSpot) <= 300 and not trapExists(trapSpot) then
			CastSpell(_W, trapSpot.x, trapSpot.z)
		end
	end
end
        Checks()
				if ts.target ~= nil then
				--[[if not VIP_USER then

                travelDuration = (delay + GetDistance(myHero, ts.target)/speed)
                ts:SetPrediction(travelDuration)
                predic = ts.nextPosition
			end]]
        end

				
		if NidaleeConfig.ManaCheck > (myHero.mana / myHero.maxMana) then
        if NidaleeConfig.SelfHeal and HUMAN == true then SelfHeal() end
        if NidaleeConfig.Heal and HUMAN == true then Heal() end
        if NidaleeConfig.FHeal and NidaleeConfig.Heal and COUGAR == true then FHeal() end
		end
        if ts.target then
                spear = qp:GetPrediction(ts.target)
                trap = wp:GetPrediction(ts.target)
                if NidaleeConfig.Combo and HUMAN == true then HCombo() end
                if NidaleeConfig.Combo and COUGAR == true then CCombo() end
                if NidaleeConfig.AutoQ and HUMAN == true then Spear() end
        end
end

function HCombo()
  if HUMAN == true then
		--[[if not VIP_USER then
			if menu.UseQ and ts.target ~= nil then
				if predic ~= nil and GetDistance(predic) < qrange and not minionCollision(predic, QWidth, qrange) then
					CastSpell(_Q, predic.x, predic.z)
				end
			end
		end]]

	if VIP_USER then
		if spear ~= nil and GetDistance(spear) < QRange and not minionCollision(spear, QWidth, QRange) and qp:GetHitChance(ts.target) > NidaleeConfig.QHitChance then
            CastSpell(_Q, spear.x, spear.z)
        end
	end
    if trap then
        CastSpell(_W, trap.x, trap.z)
    end
	if  myHero:CanUseSpell(_Q) ~= READY then
		CastSpell(_R)
	end
end
end
function CCombo()
    if COUGAR == true then
        myHero:Attack(ts.target)
        CastSpell(_W)
        if GetDistance(ts.target) < 280 then CastSpell(_E) end
        if ts.target.health < (ts.target.maxHealth*0.50) then CastSpell(_Q) end
        end
end
 
function SelfHeal()
    if HUMAN == true then
        if myHero.health < (myHero.maxHealth*0.50) and myHero:CanUseSpell(_E) == READY then
            CastSpell(_E, myHero)
        end
    end
end
 
function Heal()
        if HUMAN == true then
                for i=1, heroManager.iCount do
                        local allytarget = heroManager:GetHero(i)
                        if allytarget.team == myHero.team and not allytarget.dead and GetDistance(allytarget) <= 600 and allytarget.health < (allytarget.maxHealth*0.70) and myHero:CanUseSpell(_E) == READY then
                                CastSpell(_E, allytarget)
                        end
                end
        end
end
 
function FHeal()
    if COUGAR == true then
        CastSpell(_R)
    end
end
 
function Spear()
    if HUMAN == true then
		if VIP_USER then
            if spear and not col:GetMinionCollision(ts.target) and qp:GetHitChance(ts.target) > NidaleeConfig.QHitChance then
                CastSpell(_Q, spear.x, spear.z)
			end
		end
	end
--[[	if not VIP_USER then
	if menu.UseQ and ts.target ~= nil then
    if predic ~= nil and GetDistance(predic) < qrange and not minionCollision(predic, QWidth, qrange) then
      CastSpell(_Q, predic.x, predic.z)
		end
  end
	end]]
end

function wTraps()

	if NidaleeConfig.WPos then
		if HUMAN == true then
			if player:CanUseSpell(_W) == READY then
				NidaleeConfig.drawtrapSpots = true
			end
			for i,group in pairs(trapSpots) do
				for x, trapSpot in pairs(group.Locations) do
					if group.Enabled then
						if trapSpot ~= nil and mousePos ~= nil and GetDistance(trapSpot, mousePos) <= 300 then
							CastSpell(_W, trapSpot.x, trapSpot.z)
						end
					end
				end 
			end
			
			else
			NidaleeConfig.drawtrapSpots = false
		end
	end
end

function Checks()
    ts:update()
	enemyMinions:update()
    if myHero:GetSpellData(_Q).name == "JavelinToss" or myHero:GetSpellData(_W).name == "Bushwhack" or myHero:GetSpellData(_E).name == "PrimalSurge" then
        HUMAN = true
		COUGAR = false
    end
	if myHero:GetSpellData(_Q).name == "Takedown" or myHero:GetSpellData(_W).name == "Pounce" or myHero:GetSpellData(_E).name == "Swipe" then
        COUGAR = true
		HUMAN = false
    end
end

function minionCollision(predic, width, range)
	for _, minionObjectE in pairs(enemyMinions.objects) do
        if predic ~= nil and player:GetDistance(minionObjectE) < range then
            ex = player.x
            ez = player.z
            tx = predic.x
            tz = predic.z
            dx = ex - tx
            dz = ez - tz
            if dx ~= 0 then
                m = dz/dx
                c = ez - m*ex
            end
            mx = minionObjectE.x
            mz = minionObjectE.z
            distance = (math.abs(mz - m*mx - c))/(math.sqrt(m*m+1))
            if distance < width and math.sqrt((tx - ex)*(tx - ex) + (tz - ez)*(tz - ez)) > math.sqrt((tx - mx)*(tx - mx) + (tz - mz)*(tz - mz)) then
                return true
            end
        end
    end
    return false
end

function trapExists(trapSpot)
        for i=1, objManager.maxObjects do
        local obj = objManager:getObject(i)
                if obj.name:find("Nidalee_trap_team_id_green.troy") and obj ~= nil then
                        if GetDistance(obj) <= 300 then
                                return true
                        end
                end
        end    
        return false
end

function drawCircles(x,y,z,colour)
if NidaleeConfig.DrawCircles then
        DrawCircle(x, y, z, 28, colour)
        DrawCircle(x, y, z, 29, colour)
        DrawCircle(x, y, z, 30, colour)
        DrawCircle(x, y, z, 31, colour)
        DrawCircle(x, y, z, 32, colour)
        DrawCircle(x, y, z, 250, colour)
        if colour == red or colour == blue
                or colour == purple or colour == yellow then
                DrawCircle(x, y, z, 251, colour)
                DrawCircle(x, y, z, 252, colour)
                DrawCircle(x, y, z, 253, colour)
                DrawCircle(x, y, z, 254, colour)
        end
end
end
function OnDraw()
if HUMAN == true then
if NidaleeConfig.DrawCircles then
DrawCircle(myHero.x, myHero.y, myHero.z, 890, 0x7F006E)
DrawCircle(myHero.x, myHero.y, myHero.z, qrange, 0xc2743c)
                if ts.target ~= nil then
                        DrawText("Targetting: " .. ts.target.charName, 15, 100, 100, 0xFFFF0000)
                        DrawCircle(ts.target.x, ts.target.y, ts.target.z, 100, 0x00FF00)
                end
end
        for i,group in pairs(trapSpots) do
                if group.Enabled == true then
                        if NidaleeConfig.drawtrapSpots then
                                for x, trapSpot in pairs(group.Locations) do
                                        if GetDistance(trapSpot) < NidaleeConfig.showLocationsInRange then
                                                if GetDistance(trapSpot, mousePos) <= 300 then
                                                        trapColour = 0xFFFFFF
                                                else
                                                        trapColour = group.Colour
                                                end
                                                drawCircles(trapSpot.x, trapSpot.y, trapSpot.z,trapColour)
                                        end
                                end
                        elseif NidaleeConfig.showClose then
                                for x, trapSpot in pairs(group.Locations) do
                                        if GetDistance(trapSpot) <= NidaleeConfig.showCloseRange then
                                                if GetDistance(trapSpot, mousePos) <= 300 then
                                                        trapColour = 0xFFFFFF
                                                else
                                                        trapColour = group.Colour
                                                end
                                                drawCircles(trapSpot.x, trapSpot.y, trapSpot.z,trapColour)
                                        end
                                end
                        end
                end
        end    
end
end
function OnProcessSpell(unit, spell)
if NidaleeConfig.Debugging then
	--[[DEBUGGING]]--
if unit.isMe and spell.name == myHero:GetSpellData(_Q).name then
    print("<font color='#21007F'>Cast Spell Q</font>")
		local LastCast = Q
end
if unit.isMe and spell.name == myHero:GetSpellData(_W).name then
    print("<font color='#57007F'>Cast Spell W</font>")
		local LastCast = W
end
if unit.isMe and spell.name == myHero:GetSpellData(_E).name then
    print("<font color='#7F006E'>Cast Spell E</font>")
		local LastCast = E
end
if unit.isMe and spell.name == myHero:GetSpellData(_R).name then
    print("<font color='#7F006E'>Cast Spell R</font>")
		local LastCast = R
end
	--[[END OF DEBUGGING]]--
end
end
