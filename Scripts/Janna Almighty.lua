if myHero.charName ~= "Janna" then return end

require("DivinePred")
require("VPrediction")

local VP, DP

function OnLoad()
	DP = DivinePred()
	VP = VPrediction()
	FeezJanna()
end

class("FeezJanna")

function FeezJanna:__init()
	self.Version = 3.0

	self:LoadMenu()
	self:LoadProperties()
	self:LoadCallbacks()
	self:LoadMovementBlocker()
	self:PrintText("Loaded.")
end

function FeezJanna:PrintText(text)
	PrintChat("<font color='#EDD84C'>Janna</font><font color='#FFFFFF'> Almighty: " .. text .. "</font>")
end

function FeezJanna:LoadMenu()
	self.Config = scriptConfig("Janna Almighty - v"..tostring(version).."", "jannaconfig")

	self.Config:addSubMenu("Combo Settings", "combo")
	self.Config:addSubMenu("Draw Settings", "draw")

	self.Config.draw:addParam("enabledraw", "Draw Circle Ranges", SCRIPT_PARAM_ONOFF, true)
	self.Config.draw:addParam("lagfree", "Lag free", SCRIPT_PARAM_ONOFF, true)
	self.Config.draw:addParam("q", "Draw Q", SCRIPT_PARAM_ONOFF, true)
	self.Config.draw:addParam("w", "Draw W", SCRIPT_PARAM_ONOFF, true)
	self.Config.draw:addParam("e", "Draw E", SCRIPT_PARAM_ONOFF, true)
	self.Config.draw:addParam("target", "Draw Target circle", SCRIPT_PARAM_ONOFF, true)

	self.Config.combo:addParam("comboActive", "Combo", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	self.Config.combo:addParam("movetomouse", "Move to mouse", SCRIPT_PARAM_ONOFF, true)
	self.Config.combo:permaShow("comboActive")

	self.Config:addParam("prediction", "Prediction:", SCRIPT_PARAM_LIST, 2, {"VPrediction", "DivinePred"})
	self.Config:addParam("autoshield", "Auto Shield", SCRIPT_PARAM_ONOFF, true)
	self.Config:addParam("autoq", "Auto Q Ults & Other stuff", SCRIPT_PARAM_ONOFF, true)
end

function FeezJanna:LoadProperties()
	self.Spells =
	{
		[_Q] = {Delay = 1, Width = 200, Range = 1100, Speed = 900, InstaCast = false},
		[_W] = {Range = 600},
		[_E] = {Range = 800},
		[_R] = {Range = 725, Casting = false},
	}

	for spell, tbl in pairs(self.Spells) do
		self.Spells[spell].Ready = function() return (myHero:CanUseSpell(spell) == READY) end
	end

	self.DivineSpells =
	{
		[_Q] = LineSS(self.Spells[_Q].Speed, self.Spells[_Q].Range, self.Spells[_Q].Width, self.Spells[_Q].Delay * 1000, math.huge),
	}
	self.DivineUnits = {}

	for i, enemy in ipairs(GetEnemyHeroes()) do
		self.DivineUnits[enemy.networkID] = {Unit = enemy, DivineUnit = DPTarget(enemy)}
	end

	self.ts = TargetSelector(TARGET_LESS_CAST_PRIORITY,1100,DAMAGE_MAGIC)
	self.ts.name = "Janna"
	self.ts.targetSelected = true
	self.Config.combo:addTS(self.ts)
end

function FeezJanna:LoadCallbacks()
	AddTickCallback(function()                       self:OnTick()                      end)
	AddDrawCallback(function()                       self:OnDraw()                      end)
	AddProcessSpellCallback(function(unit, spell)    self:OnProcessSpell(unit, spell)   end)
	AddApplyBuffCallback(function(src, unit, buff)   self:OnApplyBuff(src, unit, buff)  end)
    AddRemoveBuffCallback(function(unit, buff)       self:OnRemoveBuff(unit, buff)      end)
end

function FeezJana:LoadMovementBlocker()
	AddSendPacketCallback(function(p)
		if p.header == Packet.headers.S_MOVE and self.Spells[_R].Casting and self.Config.combo.comboActive then
			p:Block()
		end
	end)
end

function FeezJanna:OnTick()
	if myHero.dead then return end

	self.ts:update()

	self:Combo()
	self:AutoShield()
end

function FeezJanna:HasOrbwalker()
	return (_G.AutoCarry and _G.AutoCarry.MyHero) or _G.MMA_Loaded
end

function FeezJanna:Combo()
	if not ValidTarget(self.ts.target) or not self.Config.combo.comboActive then return end

	if not self.Spells[_R].Casting then
		if not self:HasOrbwalker() and self.Config.combo.movetomouse then
			myHero:MoveTo(mousePos.x, mousePos.z)
		end

		if self.Spells[_W].Ready() and ValidTarget(self.ts.target, self.Spells[_W].Range) then
			CastSpell(_W, self.ts.target)
		end
		if self.Spells[_Q].Ready() then 
			self:CastQ(self.ts.target)
		end 
	end
end

function FeezJanna:CastQ(unit)
	if not self.ts.target then return end

	local CastPos, HitChance
	if self.Config.prediction == 1 then
		CastPosition, HitChance = VP:GetLineAOECastPosition(unit, self.Spells[_Q].Delay, self.Spells[_Q].Width, self.Spells[_Q].Range, self.Spells[_Q].Speed)
	local Status
		Status, CastPos, HitChance = DP:predict(self.DivineUnits[unit.networkID].DivineUnit, self.DivineSpells[_Q])
		HitChance = HitChance / 25
	end
	if CastPos and HitChance >= self.Config.misc.hitchance then
		CastSpell(_Q, CastPos.x, CastPos.z)
		DelayAction(function() CastSpell(_Q) end, 0)
	end
end


function FeezJanna:AutoShield()
	if self.Config.autoshield and self.Config.combo.comboActive and self.Spells[_E].Ready() and not self.Spells[_R].Casting then
		
		local LowHealthAlly
		for i, ally in ipairs(GetAllyHeroes()) do
			if not LowHealthAlly or (ally.health < LowHealthAlly.health and GetDistance(ally) < Spells[_E].Range) then
				LowHealthAlly = ally
			end
		end

		if LowHealthAlly and LowHealthAlly.health < LowHealthAlly.maxHealth * .16 then
			CastSpell(_E, LowHealthAlly)
		elseif myHero.health < myHero.maxHealth * .05 then
			CastSpell(_E, myHero)
		else
			local ADC = {Unit = nil, Damage = 0}

			for i, ally in ipairs(GetAllyHeroes()) do
				if ally.totalDamage > ADC.Damage and GetDistance(ally) < self.Spells[_E].Range then
					ADC.Unit = ally
					ADC.Damage = ally.totalDamage
				end
			end

			if ADC.Unit then
				CastSpell(_E, ADC.Unit)
			end
		end
	end
end

function FeezJanna:OnProcessSpell(unit, spell)
	if not self.Spells[_Q].Ready() or myHero.dead then return end

	local InterruptSpells = 
	{
		"MissFortuneBulletTime",
		"KatarinaR",
		"AbsoluteZero",
		"AlZaharNetherGrasp",
		"RocketJump",
		"KhazixE",
		"khazixelong",
		"LeonaZenithBlade",
	}
	local ShieldSpells = 
	{
		"infiniteduresschannel",
		"KatarinaR",
		"AlZaharNetherGrasp",
		"LeonaZenithBlade"
	}

	if self.Config.autoq and self.Spells[_Q].Ready() and ValidTarget(unit, self.Spells[_Q].Range) then
		for i, InterruptableSpell in ipairs(InterruptSpells) do
			if spell.name == InterruptableSpell then
				self:CastQ(unit)
				break
			end
		end
	end

	if self.Config.autoshield and self.Spells[_E].Ready() and spell.target and GetDistance(spell.target) < self.Spells[_E].Range and ValidTarget(unit, self.Spells[_E].Range) then
		for i, ShieldSpell in ipairs(ShieldSpells) do
			if spell.name == ShieldSpell then
				CastSpell(_E, spell.target)
				break
			end
		end
	end

	if unit.isMe and spell.name:lower() == "reapthewhirlwind" then
		self.Spells[_R].Casting = true
		DelayAction(function() self.Spells[_R].Casting = false end, 3)
	end
end

function FeezJanna:DrawCircle(unit, range, color)
	DrawCircle2(unit.x, unit.y, unit.z, range, color)
end

function FeezJanna:OnDraw()
	if self.Config.draw.enabledraw then
		if self.Config.draw.q then
			self:DrawCircle(myHero, self.Spells[_Q].Range, ARGB(255,36,0,255))
		end
		if self.Config.draw.w then
			self:DrawCircle(myHero, self.Spells[_W].Range, ARGB(255,36,0,255))
		end
		if self.Config.draw.e then
			self:DrawCircle(myHero, self.Spells[_E].Range, ARGB(255,36,0,255))
		end
		if self.Config.draw.target and self.ts.target ~= nil then
			self:DrawCircle(self.ts.target, 70, ARGB(255, 255, 0, 0))
		end
	end
end

function FeezJanna:OnApplyBuff(src, unit, buff)
	if unit.isMe and buff.name:lower() == "reapthewhirlwind" then
		self.Spells[_R].Casting = true
	end
	if self.Spells[_Q].Ready() and self.Config.autoq then
		if ValidTarget(unit, self.Spells[_Q].Range) and buff.name:lower() == "valkyriesound" then
			self:CastQ(unit)
		end
	end
	if self.Spells[_E].Ready() and self.Config.autoshield then
		if unit.team == myHero.team and buff.name == "leonazenithbladeroot" and GetDistance(unit) < self.Spells[_E].Range then
			CastSpell(_E, unit)
		end
	end
end

function FeezJanna:OnRemoveBuff(unit, buff)
	if unit.isMe and buff.name:lower() == "reapthewhirlwind" then
		self.Spells[_R].Casting = false
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