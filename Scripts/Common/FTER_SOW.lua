--[[
Change-log
	0.1
		0.11 Option to Prioritize Enemy than Minion added
		0.12 AA fire time limit slice value width increased(If u feel it cancels AA so hard,increase the value)
]]


local version = "0.13"
local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/fter44/ilikeman/master/common/FTER_SOW.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."FTER_SOW.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>FTER_SOW:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, "/fter44/ilikeman/master/VersionFiles/FTER_SOW.version".."?rand="..math.random(1,10000))
	if ServerData then
		ServerVersion = type(tonumber(ServerData)) == "number" and tonumber(ServerData) or nil
		if ServerVersion then
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New version available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info")
	end
end


class "FTER_SOW"
function FTER_SOW:__init(VP)
	_G.FTER_SOWLoaded = true

	self.ProjectileSpeed = myHero.range > 300 and VP:GetProjectileSpeed(myHero) or math.huge
	self.BaseWindupTime = 3
	self.BaseAnimationTime = 0.65
	self.DataUpdated = false

	self.VP = VP
	
	--Callbacks
	self.AfterAttackCallbacks = {}
	self.OnAttackCallbacks = {}
	self.BeforeAttackCallbacks = {}

	self.AttackTable =
		{
			["Ashes Q"] = "frostarrow",
		}

	self.NoAttackTable =
		{
			["Shyvana1"] = "shyvanadoubleattackdragon",
			["Shyvana2"] = "ShyvanaDoubleAttack",
			["Wukong"] = "MonkeyKingDoubleAttack",
		}

	self.AttackResetTable = 
		{
			["vayne"] = _Q,
			["darius"] = _W,
			["fiora"] = _E,
			["gangplank"] = _Q,
			["jax"] = _W,
			["leona"] = _Q,
			["mordekaiser"] = _Q,
			["nasus"] = _Q,
			["nautilus"] = _W,
			["nidalee"] = _Q,
			["poppy"] = _Q,
			["renekton"] = _W,
			["rengar"] = _Q,
			["shyvana"] = _Q,
			["sivir"] = _W,
			["talon"] = _Q,
			["trundle"] = _Q,
			["vi"] = _E,
			["volibear"] = _Q,
			["xinzhao"] = _Q,
			["monkeyking"] = _Q,
			["yorick"] = _Q,
			["cassiopeia"] = _E,
			["garen"] = _Q,
			["khazix"] = _Q,
			["kassadin"] = _W,
			--["riven"] = _Q,
		}

	self.LastAttack = 0
	--MINION_SORT_HEALTH_ASC = function(a, b) return a.health < b.health end
	--MINION_SORT_PIRCE_HEALTH_ASC = function(a, b) return a.health < b.health end --Cannon< Magic < Basic
	local function MINION_SORT_PIRCE_HEALTH_ASC(a,b)
		if a.name==b.name then		
			return a.health < b.health
		else
			--[[
			local PRICE={
				["Red_Minion_MechCannon"]=0,
				["Red_Minion_Wizard"]=1,
				["Red_Minion_Basic"]=2,
				["Blue_Minion_MechCannon"]=0,
				["Blue_Minion_Wizard"]=1,
				["Blue_Minion_WIZARD_Basic"]=2,
			}			
			return PRICE[a.charName]<PRICE[b.charName]
			]]
			return a.maxHealth > b.maxHealth --SUPER > CANNON > MAGIC > MELEE
		end
	end
	local function JUNGLE_SORT_AD_ASC(a,b)
		return a.totalDamage > b.totalDamage
	end
	self.EnemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_PIRCE_HEALTH_ASC)
	self.JungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, JUNGLE_SORT_AD_ASC)
	self.OtherMinions = minionManager(MINION_OTHER, 2000, myHero, MINION_SORT_HEALTH_ASC)
	
	GetSave("FTER_SOW").FarmDelay = GetSave("FTER_SOW").FarmDelay and GetSave("FTER_SOW").FarmDelay or 0
	GetSave("FTER_SOW").ExtraWindUpTime = GetSave("FTER_SOW").ExtraWindUpTime and GetSave("FTER_SOW").ExtraWindUpTime or 50
	GetSave("FTER_SOW").Mode3 = GetSave("FTER_SOW").Mode3 and GetSave("FTER_SOW").Mode3 or string.byte("X")
	GetSave("FTER_SOW").Mode2 = GetSave("FTER_SOW").Mode2 and GetSave("FTER_SOW").Mode2 or string.byte("V")
	GetSave("FTER_SOW").Mode1 = GetSave("FTER_SOW").Mode1 and GetSave("FTER_SOW").Mode1 or string.byte("C")
	GetSave("FTER_SOW").Mode0 = GetSave("FTER_SOW").Mode0 and GetSave("FTER_SOW").Mode0 or 32

	self.Attacks = true
	self.Move = true
	self.mode = -1
	self.checkcancel = 0
		
	AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)
	
	
	
	--[[
	fter44
		States
			0 	-- All(attack,move) Ready
			1 	-- Attack Tried,before OnProcessSpell called
			2 	-- Called on OnProcessSpell and Attack Animation On-Going
			3(0)-- Attack Finished and go back to state 0
		satete = (staet+1)%3 0 1 2
	]]--
	self.state=0	
	self.Attack_Completed=true
	self.AA_OnProcessSpell_Limit=math.huge
	AddRecvPacketCallback(function(packet) self:OnRecvPacket(packet) end)
	--_SwingTimer(self)
	--AddSendPacketCallback(function(packet) self:OnSendPacket(packet) end)
	--AddAnimationCallback(function(Unit, Animation) self:OnAnimation(Unit, Animation) end)
end

function FTER_SOW:OnAnimation(unit, animation)
	local dontlist={
		["Run"]=true,
		["Idle"]=true,
		["Idle1"]=true,
		["Idle2"]=true,
		["Idle3"]=true,
		["Spell1"]=true,
		["Spell1"]=true,
		["Spell2"]=true,
		["Spell3"]=true,
	}
	if not self:CanMove() and unit.isMe and (dontlist[animation]) then
		self:resetAA()
		self.state=0
	end
end

function FTER_SOW:LoadToMenu(m, STS)
	if not m then
		self.Menu = scriptConfig("Simple OrbWalker", "FTER_SOW")
	else
		self.Menu = m
	end

	if STS then
		self.STS = STS
		self.STS.VP = self.VP
	end
	
	self.Menu:addParam("Enabled", "Enabled", SCRIPT_PARAM_ONOFF, true)
	self.Menu:addParam("FarmDelay", "Farm Delay", SCRIPT_PARAM_SLICE, 0, 0, 150)
	self.Menu:addParam("ExtraWindUpTime", "Extra WindUp Time", SCRIPT_PARAM_SLICE, 50,  0, 300)
	
	self.Menu.FarmDelay = GetSave("FTER_SOW").FarmDelay
	self.Menu.ExtraWindUpTime = GetSave("FTER_SOW").ExtraWindUpTime

	self.Menu:addParam("Attack",  "Attack", SCRIPT_PARAM_LIST, 2, { "Only Farming", "Farming + Carry mode"})
	self.Menu:addParam("Mode",  "Orbwalking mode", SCRIPT_PARAM_LIST, 1, { "To mouse", "To target"})

	
	self.Menu:addParam("CPriority", "Prioritize harass enemy ", SCRIPT_PARAM_ONOFF, true )--fter44
	self.Menu:addParam("ALimit", "AA Fire Time Limit", SCRIPT_PARAM_SLICE, self:Latency(),  0.01, 0.5,2)--fter44
	
	self.Menu:addParam("Hotkeys", "", SCRIPT_PARAM_INFO, "")

	self.Menu:addParam("Mode3", "Last hit!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
	self.Mode3ParamID = #self.Menu._param
	self.Menu:addParam("Mode1", "Mixed Mode!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
	self.Mode1ParamID = #self.Menu._param
	self.Menu:addParam("Mode2", "Laneclear!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
	self.Mode2ParamID = #self.Menu._param
	self.Menu:addParam("Mode0", "Carry me!", SCRIPT_PARAM_ONKEYDOWN, false, 32)
	self.Mode0ParamID = #self.Menu._param

	
	
	
	self.Menu._param[self.Mode3ParamID].key = GetSave("FTER_SOW").Mode3
	self.Menu._param[self.Mode2ParamID].key = GetSave("FTER_SOW").Mode2
	self.Menu._param[self.Mode1ParamID].key = GetSave("FTER_SOW").Mode1
	self.Menu._param[self.Mode0ParamID].key = GetSave("FTER_SOW").Mode0
	
	--[[fter44
		Draw Ranges
		Debug Info
	]]
	--Drawings
	self.Menu:addSubMenu("Draw", "Draw")
		self.Menu.Draw:addParam("MyRange","Draw My Range", SCRIPT_PARAM_ONOFF, true)		
        self.Menu.Draw:addParam("MyWidth", "My Range Width", SCRIPT_PARAM_SLICE, 2, 1, 5)
		self.Menu.Draw:addParam("EnemyRange","Draw Enemy Range", SCRIPT_PARAM_ONOFF, true)			
        self.Menu.Draw:addParam("EnemyWidth", "Enemy Range Width", SCRIPT_PARAM_SLICE, 2, 1, 5)
	--Debug
	self.Menu:addParam("Debug", "Debug", SCRIPT_PARAM_ONOFF, false)
	
	
	
	AddTickCallback(function() self:OnTick() end)
	AddTickCallback(function() self:CheckConfig() end)
	AddDrawCallback(function() self:OnDraw() end)
end
function FTER_SOW:OnDraw()
	if self.Menu.Draw.MyRange then	
		DrawCircle3D(myHero.x, myHero.y, myHero.z, self:MyRange(), self.Menu.Draw.MyWidth, ARGB(255, 0, 255, 0))--GREEN
	end
	if self.Menu.Draw.EnemyRange then
		for _,c in pairs(GetEnemyHeroes()) do
			if not c.dead and c.visible then
				local p = WorldToScreen(D3DXVECTOR3(c.x, c.y, c.z))
				if OnScreen(p.x, p.y) then
					DrawCircle3D(c.x, c.y, c.z, c.range+self.VP:GetHitBox(c), self.Menu.Draw.EnemyWidth, ARGB(255, 255, 0, 0))--RED
				end
			end
		end
	end
end


function FTER_SOW:DrawAARange(width, color)--fter44
	local p = WorldToScreen(D3DXVECTOR3(myHero.x, myHero.y, myHero.z))
	if OnScreen(p.x, p.y) then
		DrawCircle3D(myHero.x, myHero.y, myHero.z, self:MyRange(), width or 1, color or ARGB(255, 255, 0, 0))
	end
end
function FTER_SOW:DrawEnemyAARange(enemy,width, color)--fter44
	--use self.VP:GetHitBox(myHero)
	DrawCircle3D(enemy.x, enemy.y, enemy.z, enemy.range+self.VP:GetHitBox(enemy), width or 1, color or ARGB(255, 255, 0, 0))
end

function FTER_SOW:CheckConfig()
	GetSave("FTER_SOW").FarmDelay = self.Menu.FarmDelay
	GetSave("FTER_SOW").ExtraWindUpTime = self.Menu.ExtraWindUpTime

	GetSave("FTER_SOW").Mode3 = self.Menu._param[self.Mode3ParamID].key
	GetSave("FTER_SOW").Mode2 = self.Menu._param[self.Mode2ParamID].key
	GetSave("FTER_SOW").Mode1 = self.Menu._param[self.Mode1ParamID].key
	GetSave("FTER_SOW").Mode0 = self.Menu._param[self.Mode0ParamID].key
end

function FTER_SOW:DisableAttacks()
	self.Attacks = false
end

function FTER_SOW:EnableAttacks()
	self.Attacks = true
end

function FTER_SOW:ForceTarget(target)
	self.forcetarget = target
end

function FTER_SOW:GetTime()
	return os.clock()
end

function FTER_SOW:MyRange(target)
	local myRange = myHero.range + self.VP:GetHitBox(myHero)
	if target then --and ValidTarget(target) then -- fter44 only pass Valid Target
		myRange = myRange + self.VP:GetHitBox(target)
	end
	return myRange - 20
end

function FTER_SOW:InRange(target)
	local MyRange = self:MyRange(target)
	if target and GetDistanceSqr(target.visionPos, myHero.visionPos) <= MyRange * MyRange then
		return true
	end
end
function FTER_SOW:ForceOrbWalkTo(pos)
	self.forceorbwalkpos=pos
end

function FTER_SOW:OrbWalk(target, point)
	point = point or self.forceorbwalkpos
	if self.Attacks and self:CanAttack() and self:ValidTarget(target) and not self:BeforeAttack(target) then
		self:Attack(target)
	elseif self:CanMove() and self.Move then
		if not point then
			local OBTarget = GetTarget() or target
			if self.Menu.Mode == 1 or not OBTarget then
				--local Mv = Vector(myHero) + 400 * (Vector(mousePos) - Vector(myHero)):normalized()
				--self:MoveTo(Mv.x, Mv.z)
				self:MoveTo(mousePos.x, mousePos.z)
			--elseif GetDistanceSqr(OBTarget) > 50*50 then
			elseif GetDistanceSqr(OBTarget) > 100*100 + math.pow(self.VP:GetHitBox(OBTarget), 2) then
				local point = self.VP:GetPredictedPos(OBTarget, 0, 2*myHero.ms, myHero, false)
				if GetDistanceSqr(point) < 100*100 + math.pow(self.VP:GetHitBox(OBTarget), 2) then
					point = Vector(Vector(myHero) - point):normalized() * 50
				end
				self:MoveTo(point.x, point.z)
			end
		else
			self:MoveTo(point.x, point.z)
		end
	end
end

function FTER_SOW:ValidTarget(target)
	if target and target.type and (target.type == "obj_BarracksDampener" or target.type == "obj_HQ")  then --fter44--WHY??
		local CollisionRange={["obj_BarracksDampener"]=205, ["obj_HQ"]=300}
		local myRange = myHero.range + self.VP:GetHitBox(myHero) + CollisionRange[target.type]
		
		return ValidTarget(target) and GetDistanceSqr(target, myHero.visionPos) <= myRange * myRange
	end
	return ValidTarget(target) and self:InRange(target)
end

function FTER_SOW:WindUpTime(exact)
	return (1 / (myHero.attackSpeed * self.BaseWindupTime)) + (exact and 0 or GetSave("FTER_SOW").ExtraWindUpTime / 1000)
end

function FTER_SOW:AnimationTime()
	return (1 / (myHero.attackSpeed * self.BaseAnimationTime))
end

function FTER_SOW:Latency()
	return GetLatency() / 2000
end

function FTER_SOW:CanAttack()
	if self.LastAttack <= self:GetTime() then
		if (self:GetTime() + self:Latency()  > self.LastAttack + self:AnimationTime()) then
			return true
		end
	end
		
	local percentage = (os.clock() -  self.LastAttack) / (self:GetNextAttackTime() - self.LastAttack)
--	if self.Menu.Debug then self:Print( math.floor(percentage*100).."%".." LastAttack:"..self.LastAttack.." ") end
	return false
end
function FTER_SOW:GetNextAttackTime()
	return self.LastAttack + self:AnimationTime()
end

function FTER_SOW:BeforeAttack(target)
	local result = false
	for i, cb in ipairs(self.BeforeAttackCallbacks) do
		local ri = cb(target, self.mode)
		if ri then
			result = true
		end
	end
	return result
end

function FTER_SOW:RegisterBeforeAttackCallback(f)
	table.insert(self.BeforeAttackCallbacks, f)
end

function FTER_SOW:OnAttack(target)
	for i, cb in ipairs(self.OnAttackCallbacks) do
		cb(target, self.mode)
	end
end

function FTER_SOW:RegisterOnAttackCallback(f)
	table.insert(self.OnAttackCallbacks, f)
end

function FTER_SOW:AfterAttack(target)
	for i, cb in ipairs(self.AfterAttackCallbacks) do
		cb(target, self.mode)
	end
end

function FTER_SOW:RegisterAfterAttackCallback(f)
	table.insert(self.AfterAttackCallbacks, f)
end

function FTER_SOW:MoveTo(x, y)
	myHero:MoveTo(x, y)
end

function FTER_SOW:IsAttack(SpellName)
	return (SpellName:lower():find("attack") or table.contains(self.AttackTable, SpellName:lower())) and not table.contains(self.NoAttackTable, SpellName:lower())
end

function FTER_SOW:IsAAReset(SpellName)
	local SpellID
	if SpellName:lower() == myHero:GetSpellData(_Q).name:lower() then
		SpellID = _Q
	elseif SpellName:lower() == myHero:GetSpellData(_W).name:lower() then
		SpellID = _W
	elseif SpellName:lower() == myHero:GetSpellData(_E).name:lower() then
		SpellID = _E
	elseif SpellName:lower() == myHero:GetSpellData(_R).name:lower() then
		SpellID = _R
	end

	if SpellID then
		return self.AttackResetTable[myHero.charName:lower()]==SpellID
	end
end


if myHero.charName==Thresh then
	function FTER_SOW:CanMove()
		if self.LastAttack <= self:GetTime() then
			return (self.Attack_Completed) and not _G.evade
		end
	end
else
	function FTER_SOW:CanMove()
		if self.LastAttack <= self:GetTime() then
			return (self.Attack_Completed or (self:GetTime() + self:Latency() > self.LastAttack + self:WindUpTime()) ) and not _G.evade
		end
	end
end

local physicals={}
for x=0,0xFF do 
  if table.contains({3,4,6,7},x%8) and table.contains({0,1,6,7},(x%(8*8)-(x%8))/8) then
      physicals[x]=true
  end
end

function FTER_SOW:OnSendPacket(p)
	if p.header==Packet.headers.S_MOVE then
		packet=Packet(p)
		if packet:get('type') == 3 or packet:get('type') == 7 then
		
		end
	elseif p.header==Packet.headers.S_CAST then
	
	end
end

function FTER_SOW:OnRecvPacket(p)--fter44
	if p.header==51 then --Attacks
		p.pos = 1
		local networkID = p:DecodeF()
		if networkID==myHero.networkID then
			p.pos = 9
			local attack_type = p:Decode1()			
			if attack_type == 0x11 then				
				--if true or self.Attack_Completed==false or self:GetTime() < self.checkcancel then
					self.LastAttackCancelled=true
					self.last_AA_target=nil
					self.Attack_Completed=true					
					self:resetAA()										
					self.state=0
					if self.Menu.Debug then self:Print("AA canceled"..":"..os.clock()) end
				--end	
			--elseif attack_type == 0x03 then --type:3 aa target change?
				--self.last_AA_target=nil
				--print("51 "..Packet(p):getRawHexString())
				--self:Print("attack_type : "..attack_type..":"..os.clock())
			--else --type 0 : Mundo Q casted Riven Q casted
				--print(attack_type.." "..Packet(p):getRawHexString())
				--self.last_AA_target=nil
				--self.Attack_Completed=true
				--self:Print("attack_type : "..attack_type..":"..os.clock())
				--self.LastAttackCancelled=true
				--self.Attack_Completed=true					
				--self:resetAA()					
			end	
		end
	--elseif p.header==23 then --Attack start		--ALSO Spell started
	--	if containsFloat(p,player.networkID) then
	--		self:Print("Attack started : "..p.header..":"..os.clock())
	--		self.Attack_Completed=false
	--		print("AA started")
	--	end
	else
		self:Process_Attack_Completed(p)
	end
end
function FTER_SOW:AADamageSpawned(p)
	if p.header==100 then--DAMAGE INDICATOR --134 MELEE --ALSO AFTER CASTED PARITLCE 
		p.pos=1 	local attacked=p:DecodeF()
					local Dtype = p:Decode1()    --Dtype(hex)  24:true damage 03,04,0C:physical 14:magical
		p.pos=10 	local attacker=p:DecodeF()
		
		if self.Attack_Completed==false and self.last_AA_target and attacker==myHero.networkID and attacked==self.last_AA_target.networkID and physicals[Dtype] then
			self.Attack_Completed=true
			self:AfterAttack(self.last_AA_target) 		
			self.state=0			
			if self.Menu.Debug then self:Print("AA DAMAGE SPAWNED : :"..os.clock()) end
		end
	end
end
function FTER_SOW:ParticleCreated(p)
	if p.header==109 then --RANGE PARTICLE CREATED --or MUNDO Q PARTICLE CREATED
		p.pos=1	local generator=p:DecodeF()
		if generator==myHero.networkID then
			if self.Attack_Completed==false and self.last_AA_target then
				self.Attack_Completed=true
				self:AfterAttack(self.last_AA_target)
				self.last_AA_target=nil
				self.state=0
				if self.Menu.Debug then self:Print("Particle Created : "..os.clock()) end--Particle Created
			end
		end
	end
end
local MELEE={aatrox,kayle,rengar}
local RANGE={}
local HYBRID={nidalee,elise,jayce}
local THRESH={velkoz,thresh}
if table.contains(HYBRID,myHero.charName:lower()) then
	function FTER_SOW:Process_Attack_Completed(p)
		if myHero.range>400 then		
			self:ParticleCreated(p)
		else
			self:AADamageSpawned(p)
		end
	end	
elseif table.contains(THRESH,myHero.charName:lower()) then
	function FTER_SOW:Process_Attack_Completed(p)
		self:AADamageSpawned(p)
	end
elseif table.contains(MELEE,myHero.charName:lower()) or myHero.range<425   then --MELEE	
	function FTER_SOW:Process_Attack_Completed(p)
		self:AADamageSpawned(p)
	end
elseif table.contains(RANGE,myHero.charName:lower()) or myHero.range>=425 then
	function FTER_SOW:Process_Attack_Completed(p)
		self:ParticleCreated(p)
	end

end
function FTER_SOW:OnProcessSpell(unit, spell)
	if unit.isMe and self:IsAttack(spell.name) then
		if self.debugdps then
			DPS = DPS and DPS or 0
			print("DPS: "..(1000/(self:GetTime()- DPS)).." "..(1000/(self:AnimationTime())))
			DPS = self:GetTime()
		end
		if not self.DataUpdated and not spell.name:lower():find("card") then
			self.BaseAnimationTime = 1 / (spell.animationTime * myHero.attackSpeed)
			self.BaseWindupTime = 1 / (spell.windUpTime * myHero.attackSpeed)
			if self.debug then
				print("<font color=\"#FF0000\">Basic Attacks data updated: </font>")
				print("<font color=\"#FF0000\">BaseWindupTime: "..self.BaseWindupTime.."</font>")
				print("<font color=\"#FF0000\">BaseAnimationTime: "..self.BaseAnimationTime.."</font>")
				print("<font color=\"#FF0000\">ProjectileSpeed: "..self.ProjectileSpeed.."</font>")
			end
			self.DataUpdated = true
		end
		self.LastAttack = self:GetTime() - self:Latency()
		self.checking = true
		self.LastAttackCancelled = false
		self:OnAttack(spell.target)
		
		
		--fter44
		--self.checkcancel = self:WindUpTime() - self:Latency()
		self.Attack_Completed=false
		self.last_AA_target=spell.target
		if self.Menu.Debug then self:Print("OnProcessSpell ATTACK DETECTED name : "..spell.name) end
		if self.Menu.Debug then self:Print("FROM TRY TO OnProcessSpell:.."..string.format("%.3f",os.clock()-(self.AA_OnProcessSpell_Limit-self.Menu.ALimit))) end
		--print("FROM TRY TO OnProcessSpell:.."..string.format("%.3f",os.clock()-(self.AA_OnProcessSpell_Limit-self.Menu.ALimit)))
		self.AA_OnProcessSpell_Fired=true		
		self.state=2
		
		--DelayAction(function(t)   --fter44
		--	if not self.LastAttackCancelled then 
		--		self:AfterAttack(t) 
		--	end 
		--end, self:WindUpTime() - self:Latency(), {spell.target})

	elseif unit.isMe and self:IsAAReset(spell.name) then
		if self.Menu.Debug then self:Print(spell.name.." Detected") end
		DelayAction(function() self:resetAA() end, 0.1)
	end
end

function FTER_SOW:resetAA()
	self.LastAttack = 0
	self.last_AA_target=nil
	self.Attack_Completed = true
	self.AA_OnProcessSpell_Fired=true
	if self.Menu.Debug then self:Print("resetAA() called") end
end
--TODO: Change this.
function FTER_SOW:BonusDamage(minion)
	local AD = myHero:CalcDamage(minion, myHero.totalDamage)
	local BONUS = 0
	if myHero.charName == 'Vayne' then
		if myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == SUPRESSED then
			BONUS = BONUS + myHero:CalcDamage(minion, ((0.05 * myHero:GetSpellData(_Q).level) + 0.25 ) * myHero.totalDamage)
		end
		if not VayneCBAdded then
			VayneCBAdded = true
			function VayneParticle(obj)
				if GetDistance(obj) < 1000 and obj.name:lower():find("vayne_w_ring2.troy") then
					VayneWParticle = obj
				end
			end
			AddCreateObjCallback(VayneParticle)
		end
		if VayneWParticle and VayneWParticle.valid and GetDistance(VayneWParticle, minion) < 10 then
			BONUS = BONUS + 10 + 10 * myHero:GetSpellData(_W).level + (0.03 + (0.01 * myHero:GetSpellData(_W).level)) * minion.maxHealth
		end
	elseif myHero.charName == 'Teemo' and myHero:GetSpellData(_E).level > 0 then
		BONUS = BONUS + myHero:CalcMagicDamage(minion, (myHero:GetSpellData(_E).level * 10) + (myHero.ap * 0.3) )
	elseif myHero.charName == 'Corki' then
		BONUS = BONUS + myHero.totalDamage/10
	elseif myHero.charName == 'MissFortune' and myHero:GetSpellData(_W).level > 0 then
		BONUS = BONUS + myHero:CalcMagicDamage(minion, (4 + 2 * myHero:GetSpellData(_W).level) + (myHero.ap/20))
	elseif myHero.charName == 'Varus' and myHero:GetSpellData(_W).level > 0 then
		BONUS = BONUS + (6 + (myHero:GetSpellData(_W).level * 4) + (myHero.ap * 0.25))
	elseif myHero.charName == 'Caitlyn' then
			if not CallbackCaitlynAdded then
				function CaitlynParticle(obj)
					if GetDistance(obj) < 100 and obj.name:lower():find("caitlyn_headshot_rdy") then
							HeadShotParticle = obj
					end
				end
				AddCreateObjCallback(CaitlynParticle)
				CallbackCaitlynAdded = true
			end
			if HeadShotParticle and HeadShotParticle.valid then
				BONUS = BONUS + AD * 1.5
			end
	elseif myHero.charName == 'Orianna' then
		BONUS = BONUS + myHero:CalcMagicDamage(minion, 10 + 8 * ((myHero.level - 1) % 3))
	elseif myHero.charName == 'TwistedFate' then
			if not TFCallbackAdded then
				function TFParticle(obj)
					if GetDistance(obj) < 100 and obj.name:lower():find("cardmaster_stackready.troy") then
						TFEParticle = obj
					elseif GetDistance(obj) < 100 and obj.name:lower():find("card_blue.troy") then
						TFWParticle = obj
					end
				end
				AddCreateObjCallback(TFParticle)
				TFCallbackAdded = true
			end
			if TFEParticle and TFEParticle.valid then
				BONUS = BONUS + myHero:CalcMagicDamage(minion, myHero:GetSpellData(_E).level * 15 + 40 + 0.5 * myHero.ap)  
			end
			if TFWParticle and TFWParticle.valid then
				BONUS = BONUS + math.max(myHero:CalcMagicDamage(minion, myHero:GetSpellData(_W).level * 20 + 20 + 0.5 * myHero.ap) - 40, 0) 
			end
	elseif myHero.charName == 'Draven' then
			if not CallbackDravenAdded then
				function DravenParticle(obj)
					if GetDistance(obj) < 100 and obj.name:lower():find("draven_q_buf") then
							DravenParticleo = obj
					end
				end
				AddCreateObjCallback(DravenParticle)
				CallbackDravenAdded = true
			end
			if DravenParticleo and DravenParticleo.valid then
				BONUS = BONUS + AD * (0.3 + (0.10 * myHero:GetSpellData(_Q).level))
			end
	elseif myHero.charName == 'Nasus' and VIP_USER then
		if myHero:GetSpellData(_Q).level > 0 and myHero:CanUseSpell(_Q) == SUPRESSED then
			local Qdamage = {30, 50, 70, 90, 110}
			NasusQStacks = NasusQStacks or 0
			BONUS = BONUS + myHero:CalcDamage(minion, 10 + 20 * (myHero:GetSpellData(_Q).level) + NasusQStacks)
			if not RecvPacketNasusAdded then
				function NasusOnRecvPacket(p)
					if p.header == 0xFE and p.size == 0xC then
						p.pos = 1
						pNetworkID = p:DecodeF()
						unk01 = p:Decode2()
				 		unk02 = p:Decode1()
						stack = p:Decode4()
						if pNetworkID == myHero.networkID then
							NasusQStacks = stack
						end
					end
				end
				RecvPacketNasusAdded = true
				AddRecvPacketCallback(NasusOnRecvPacket)
			end
		end
	elseif myHero.charName == "Ziggs" then
		if not CallbackZiggsAdded then
			function ZiggsParticle(obj)
				if GetDistance(obj) < 100 and obj.name:lower():find("ziggspassive") then
						ZiggsParticleObj = obj
				end
			end
			AddCreateObjCallback(ZiggsParticle)
			CallbackZiggsAdded = true
		end
		if ZiggsParticleObj and ZiggsParticleObj.valid then
			local base = {20, 24, 28, 32, 36, 40, 48, 56, 64, 72, 80, 88, 100, 112, 124, 136, 148, 160}
			BONUS = BONUS + myHero:CalcMagicDamage(minion, base[myHero.level] + (0.25 + 0.05 * (myHero.level % 7)) * myHero.ap)  
		end
	end

	return BONUS
end

function FTER_SOW:KillableMinion()
	local result
	for i, minion in ipairs(self.EnemyMinions.objects) do
		local time = self:WindUpTime(true) + GetDistance(minion.visionPos, myHero.visionPos) / self.ProjectileSpeed - 0.07
		local PredictedHealth = self.VP:GetPredictedHealth(minion, time, GetSave("FTER_SOW").FarmDelay / 1000)
		if self:ValidTarget(minion) and PredictedHealth < self.VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + self:BonusDamage(minion) and PredictedHealth > -40 then
			result = minion
			break
		end
	end
	return result
end

function FTER_SOW:ShouldWait()
	for i, minion in ipairs(self.EnemyMinions.objects) do
		local time = self:AnimationTime() + GetDistance(minion.visionPos, myHero.visionPos) / self.ProjectileSpeed - 0.07
		if self:ValidTarget(minion) and self.VP:GetPredictedHealth2(minion, time * 2) < (self.VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + self:BonusDamage(minion)) then
			return true
		end
	end
end

function FTER_SOW:ValidStuff()
	local result = self:GetTarget()

	if result then 
		return result
	end

	for i, minion in ipairs(self.EnemyMinions.objects) do
		local time = self:AnimationTime() + GetDistance(minion.visionPos, myHero.visionPos) / self.ProjectileSpeed - 0.07
		local pdamage2 = minion.health - self.VP:GetPredictedHealth(minion, time, GetSave("FTER_SOW").FarmDelay / 1000)
		local pdamage = self.VP:GetPredictedHealth2(minion, time * 2)
		if self:ValidTarget(minion) and ((pdamage) > 2*self.VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + self:BonusDamage(minion) or pdamage2 == 0) then
			return minion
		end
	end

	for i, minion in ipairs(self.JungleMinions.objects) do
		if self:ValidTarget(minion) then
			return minion
		end
	end

	for i, minion in ipairs(self.OtherMinions.objects) do
		if self:ValidTarget(minion) then
			return minion
		end
	end
end

function FTER_SOW:GetTarget(OnlyChampions)
	local result
	local healthRatio

	if self:ValidTarget(self.forcetarget) then
		return self.forcetarget
	elseif self.forcetarget ~= nil then
		return nil
	end

	if (not self.STS or not OnlyChampions) and self:ValidTarget(GetTarget()) and (GetTarget().type == myHero.type or (not OnlyChampions)) then
		return GetTarget()
	end

	if self.STS then
		local oldhitboxmode = self.STS.hitboxmode
		self.STS.hitboxmode = true

		result = self.STS:GetTarget(myHero.range)

		self.STS.hitboxmode = oldhitboxmode
		return result
	end

	for i, champion in ipairs(GetEnemyHeroes()) do
		local hr = champion.health / myHero:CalcDamage(champion, 200)
		if self:ValidTarget(champion) and ((healthRatio == nil) or hr < healthRatio) then
			result = champion
			healthRatio = hr
		end
	end

	return result
end

function FTER_SOW:Farm(mode, point)
	if mode == 1 then --Mix
		local target
		self.EnemyMinions:update()
		if self.Menu.CPriority then
			target = self:GetTarget() or self:KillableMinion()
		else
			target = self:KillableMinion() or self:GetTarget()
		end
		self:OrbWalk(target, point)
		self.mode = 1
	elseif mode == 2 then --LaneClear
		self.EnemyMinions:update()
		self.OtherMinions:update()
		self.JungleMinions:update()

		local target = self:KillableMinion()
		if target then
			self:OrbWalk(target, point)
		elseif not self:ShouldWait() then

			if self:ValidTarget(self.lasttarget) then
				target = self.lasttarget
			else
				target = self:ValidStuff()
			end
			self.lasttarget = target
			
			self:OrbWalk(target, point)
		else
			self:OrbWalk(nil, point)
		end
		self.mode = 2
	elseif mode == 3 then	--lasthit
		self.EnemyMinions:update()
		local target = self:KillableMinion()
		self:OrbWalk(target, point)
		self.mode = 3
	end
end


function FTER_SOW:Attack(target)
	self.LastAttack = self:GetTime() + self:Latency()
	self.Attack_Completed=false--fter44
	self.AA_OnProcessSpell_Fired = false
	self.AA_OnProcessSpell_Limit = os.clock()+ self.Menu.ALimit
	self.state=1
	if self.Menu.Debug then self:Print("AA START TO"..target.name) end--fter44
	myHero:Attack(target)
end


function FTER_SOW:OnTick()
	if not self.Menu.Enabled then return end
	
	if self.AA_OnProcessSpell_Fired==false and os.clock() > self.AA_OnProcessSpell_Limit then --fter44
		self:resetAA()
		self.state=0
		if self.Menu.Debug then self:Print("OnProcessSpell not fired :( during Time Limit "..os.clock()-self.AA_OnProcessSpell_Limit.." overed") end
	end
	
	if self.Menu.Mode0 then
		local target = self:GetTarget(true)
		if self.Menu.Attack == 2 then
			self:OrbWalk(target)
		else
			self:OrbWalk()
		end
		self.mode = 0
	elseif self.Menu.Mode1 then
		self:Farm(1)
	elseif self.Menu.Mode2 then
		self:Farm(2)
	elseif self.Menu.Mode3 then
		self:Farm(3)
	else
		self.mode = -1
	end
end
function FTER_SOW:Print(str) --fter44
	if GetUser()=="fter44" then
		local time=string.format(" %.2f",os.clock())
		print("<font color=\"#6699ff\"><b>FTER_SOW:</b></font> <font color=\"#FFFFFF\">"..str..time..".</font>")
		lib.print("FTER_SOW:"..str.."-"..time)
	end
end
function FTER_SOW:GetState()--fter44
	return self.state
end
