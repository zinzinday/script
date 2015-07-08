if myHero.charName ~= "Leona" then return end

require 'DivinePred'
require 'VPrediction'
require 'SOW'

local VP, DP

function OnLoad()
	DP = DivinePred()
	VP = VPrediction()
	FeezLeona()
end

class("FeezLeona")

function FeezLeona:__init()
	self.Version = 3.01

	self:LoadMenu()
	self:LoadProperties()
	self:LoadCallbacks()
	self:PrintText("Loaded.")
end

function FeezLeona:PrintText(text)
	PrintChat("<font color='#E38400'>Leona</font><font color='#FFFFFF'> the Annoying <font color='#E38400'>Bitch</font><font color='#FFFFFF'> " .. text .. "</font>")
end

function FeezLeona:LoadMenu()
	self.Config = scriptConfig("Leona (Bitch) - "..tostring(self.Version).."", "leonaconfig") 

	self.Config:addSubMenu("Combo Settings", "combosettings")
		self.Config.combosettings:addParam("comboActive", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		self.Config.combosettings:addParam("useUlt", "Use Ult", SCRIPT_PARAM_ONOFF, true)
		self.Config.combosettings:permaShow("comboActive")

	self.Config:addSubMenu("Auto Ult", "autoult")
		self.Config.autoult:addParam("enabled", "Enable", SCRIPT_PARAM_ONOFF, true)
		self.Config.autoult:addParam("numberofenemies", "least # of enemies to auto ult", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)


	self.Config:addSubMenu("Draw Settings", "drawsettings")
		self.Config.drawsettings:addParam("enabledraw", "Draw Circle Ranges", SCRIPT_PARAM_ONOFF, true)
		self.Config.drawsettings:addParam("w", "Draw W", SCRIPT_PARAM_ONOFF, true)
		self.Config.drawsettings:addParam("e", "Draw E", SCRIPT_PARAM_ONOFF, true)
		self.Config.drawsettings:addParam("r", "Draw R", SCRIPT_PARAM_ONOFF, true)
		self.Config.drawsettings:addParam("tstarget", "Draw Circle around target", SCRIPT_PARAM_ONOFF, true)

	self.Config:addSubMenu("Orbwalker", "orbwalker")

	self.Config:addSubMenu("Miscellaneous", "misc")
		self.Config.misc:addParam("div", "High hitchance = less casting", SCRIPT_PARAM_INFO, "")
		self.Config.misc:addParam("hitchance", "E Hitchance", SCRIPT_PARAM_LIST, 1, { "Low", "Medium", "High"})
		self.Config.misc:addParam("prediction", "Prediction:", SCRIPT_PARAM_LIST, 2, {"VPrediction", "DivinePred"})

end

function FeezLeona:LoadProperties()
	self.Spells =
	{
		[_Q] = {Range = 200},
		[_W] = {Range = 450},
		[_E] = {Range = 875, Speed = 1225, Width = 80, Delay = 0.25, Collision = false},
		[_R] = {Radius = 300, Delay = 0.25, Range = 1200, Speed = 20}
	}

	for spell, tbl in pairs(self.Spells) do
		self.Spells[spell].Ready = function() return (myHero:CanUseSpell(spell) == READY) end
	end

	self.DivineSpells =
	{
		[_E] = LineSS(self.Spells[_E].Speed, self.Spells[_E].Range, self.Spells[_E].Width, self.Spells[_E].Delay * 1000, math.huge),
		[_R] = CircleSS(self.Spells[_R].Speed, self.Spells[_R].Range, self.Spells[_R].Radius, self.Spells[_R].Delay * 1000, math.huge)
	}
	self.DivineUnits = {}

	for i, enemy in ipairs(GetEnemyHeroes()) do
		self.DivineUnits[enemy.networkID] = {Unit = enemy, DivineUnit = DPTarget(enemy)}
	end

	self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY,1200,DAMAGE_MAGIC)
	self.ts.name = "Leona"
	self.ts.targetSelected = true
	self.Config.combosettings:addTS(self.ts)

	self.SOW = SOW(VP)
	self.SOW:LoadToMenu(self.Config.orbwalker)
	self.SOW:EnableAttacks()
end

function FeezLeona:LoadCallbacks()
	AddTickCallback(function()                       self:OnTick()                      end)
	AddDrawCallback(function()                       self:OnDraw()                      end)
	AddProcessSpellCallback(function(unit, spell)    self:OnProcessSpell(unit, spell)   end)
end

function FeezLeona:OnTick()
	if myHero.dead then return end

	if self.Spells[_R].Ready() and self.Spells[_E].Ready() then
		self.ts.range = 1200
	elseif self.Spells[_E].Ready() then
		self.ts.range = 875
	else
		self.ts.range = 300
	end
	self.ts:update()

	if self.ts.target ~= nil then
		self.SOW:ForceTarget(self.ts.target)
	end

	self:Combo()
	self:AutoStun()
end

function FeezLeona:Combo()
	if not ValidTarget(self.ts.target) or not self.Config.combosettings.comboActive then return end

	if not self.ts.target.canMove then
		if self.Spells[_W].Ready() and ValidTarget(self.ts.target, self.Spells[_W].Range) then
			CastSpell(_W)
		end
		if self.Spells[_Q].Ready() and ValidTarget(self.ts.target, self.Spells[_Q].Range) then
			CastSpell(_Q)
		end
	else
		if self.Spells[_Q].Ready() and ValidTarget(self.ts.target, self.Spells[_Q].Range) then
			self:CastQ()
		end
	end

	if self.Spells[_E].Ready() then
		self:CastE()
	end

	if self.Spells[_R].Ready() then
		self:CastR()
	end
end


function FeezLeona:CastE()
	if not ValidTarget(self.ts.target) and not IsFacing(self.ts.target, myHero, 400) then return end

	local CastPos, HitChance
	if self.Config.misc.prediction == 1 then
		CastPos, HitChance = VP:GetLineCastPosition(self.ts.target, self.Spells[_E].Delay, self.Spells[_E].Width, self.Spells[_E].Range, self.Spells[_E].Speed, myHero, self.Spells[_E].Collision)
	else
		local Status
		Status, CastPos, HitChance = DP:predict(self.DivineUnits[self.ts.target.networkID].DivineUnit, self.DivineSpells[_E])
		HitChance = HitChance / 25
	end
	if CastPos and HitChance >= self.Config.misc.hitchance then
		CastSpell(_E, CastPos.x, CastPos.z)
	end
end

function FeezLeona:CastR()
	if not ValidTarget(self.ts.target) or not not self.Config.combosettings.useUlt then return end

	if ValidTarget(self.ts.target, self.Spells[_R].Range) and (VP.TargetsImmobile[self.ts.target.networkID] and VP.TargetsImmobile[self.ts.target.networkID] > os.clock() + .75) then
		CastSpell(_R, self.ts.target.x, self.ts.target.z)
	else
		local CastPos, HitChance
		if self.Config.misc.prediction == 1 then
			CastPos, HitChance = VP:GetCircularAOECastPosition(target, self.Spells[_R].Delay, self.Spells[_R].Radius, self.Spells[_R].Range, self.Spells[_R].Speed)
		else
			CastPos, HitChance = DP:predict(self.DivineUnits[self.ts.target.networkID], self.DivineSpells[_R])
			HitChance = HitChance / 25
		end
		if CastPos and HitChance >= 3 then
			CastSpell(_R, CastPos.x, CastPos.z)
		end
	end
end

function FeezLeona:CastQ()
	if not ValidTarget(self.ts.target) then return end

	if (VP.TargetsImmobile[self.ts.target.networkID] and VP.TargetsImmobile[self.ts.target.networkID] > os.clock() + .25 + self.Config.orbwalker.ExtraWindUpTime) then
		CastSpell(_Q)
	end
end

function FeezLeona:AutoStun()
	if not ValidTarget(self.ts.target) then return end

	if self.Config.autoult.enabled and self.Spells[_R].Ready() and self.Spells[_E].Ready() and not self.Config.combosettings.comboActive then
		CastPos, HitChance, nTargets = VP:GetCircularAOECastPosition(self.ts.target, self.Spells[_R].Delay, self.Spells[_R].Radius, self.Spells[_R].Range, self.Spells[_R].Speed)
		if CastPos and nTargets and (nTargets >= self.Config.autoult.numberofenemies) then
			CastSpell(_R, CastPos.x, CastPos.z)
		end
	end
end

function FeezLeona:OnProcessSpell(unit, spell)
	if not self.Spells[_Q].Ready() or myHero.dead then return end

	if unit and unit.isMe and spell.name:lower():find("attack") then
		CastSpell(_Q)
	end
end

function FeezLeona:DrawCircle(unit, range, color)
	DrawCircle2(unit.x, unit.y, unit.z, range, color)
end

function FeezLeona:OnDraw()
	if self.Config.drawsettings.enabledraw then
		if self.Config.drawsettings.w then
			self:DrawCircle(myHero, 450, ARGB(255,36,0,255))
		end
		if self.Config.drawsettings.e then
			self:DrawCircle(myHero, 875, ARGB(255,36,0,255))
		end
		if self.Config.drawsettings.r then
			self:DrawCircle(myHero, 1200, ARGB(255,36,0,255))
		end
		if self.Config.drawsettings.tstarget and self.ts.target ~= nil then
			self:DrawCircle(self.ts.target, 70, ARGB(255, 255, 0, 0))
		end
	end
end

--http://botoflegends.com/forum/topic/19669-for-devs-isfacing/
function IsFacing(source, target, lineLength)
	if not source.dead and source.visionPos ~= nil and not target.dead and target.visionPos ~= nil then
		local sourceVector = Vector(source.visionPos.x, source.visionPos.z)
		local sourcePos = Vector(source.x, source.z)
		sourceVector = (sourceVector-sourcePos):normalized()
		sourceVector = sourcePos + (sourceVector*(GetDistance(target, source)))
		return GetDistanceSqr(target, {x = sourceVector.x, z = sourceVector.y}) <= (lineLength and lineLength^2 or 90000)
	end
end

function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
	radius = radius or 300
	quality = math.max(8,math.floor(180/math.deg((math.asin((chordlength/(2*radius)))))))
	quality = 2 * math.pi / quality
	radius = radius*.92
	local points = {}
	for theta = 0, 2 * math.pi + quality, quality do
		local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
		points[#points + 1] = D3DXVECTOR2(c.x, c.y)
	end
	DrawLines2(points, width or 1, color or 4294967295)
end

function DrawCircle2(x, y, z, radius, color)
	local vPos1 = Vector(x, y, z)
	local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
	local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
	local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
	if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y })  then
		DrawCircleNextLvl(x, y, z, radius, 1, color, 75)	
	end
end