class 'Plugin'
if myHero.charName ~= "Jayce" then return end

require "Collision"
require "Prodiction"

local Skills, Keys, Items, Data, Jungle, Helper, MyHero, Minions, Crosshair, Orbwalker = AutoCarry.Helper:GetClasses()

local QAble, WAble, EAble, RAble = false, false, false, false

local QRange, QMaxRange, QSpeed, QDelay, QWidth, Qtime = 1600, 1500, 200, 90, 0

local WBuff, Passive, CannonQ, cancelMovt = false, false, false, false

local JayceType = 1

local GateRange = 0

local Prodict = ProdictManager.GetInstance()

local enemyTable = GetEnemyHeroes()

function Plugin:__init()

	Crosshair:SetSkillCrosshairRange(QRange)
	Skills:DisableAll()
	PrintChat("Loaded AutoCarry: Jayce")
	AdvancedCallback:bind('OnGainBuff', function(unit, buff) self:OnGainBuff(unit, buff) end)
	AdvancedCallback:bind('OnLoseBuff', function(unit, buff) self:OnLoseBuff(unit, buff) end)
	if TargetHaveBuff("jaycestancehammer") then JayceType = 1 else JayceType = 2 end
	ProQ = Prodict:AddProdictionObject(_Q, QRange, QSpeed*1000, QDelay/1000, QWidth) 
	QSkill = AutoCarry.Skills:NewSkill(false, _Q, QRange, "Q skill", AutoCarry.SPELL_LINEAR_COL, 0, false, false, QSpeed*1000, QDelay/1000, QWidth, true)
end

function Plugin:OnTick()
	Target = AutoCarry.GetAttackTarget()
	CheckSkill()
	GateRange = Menu.GateD
	if Target then
		if Keys.AutoCarry then
		  Combo(Target)
		end
		if Menu.Poke then
		  Poke(Target)
		end
	end
	if Menu.FreeEQ then
		FreeEQ()
	end
	if Menu.KillSteal then
		KillSteal()
	end
	if CannonQ and os.clock() > Qtime + 0.5 then
    cancelMovt = false
    CannonQ = false
  end  
end
-- By jbman
function Plugin:OnProcessSpell(unit, spell)
	if unit == player and spell.name == "jayceshockblast" then 
		if JayceType == 2 and EAble and Menu.FreeEQ or Keys.AutoCarry or Menu.Poke or Menu.KillSteal then
			CastSpell(_E,player.x+GateRange*(spell.endPos.x-player.x)/math.abs(spell.endPos.x-player.x),player.z+GateRange*(spell.endPos.z-player.z)/math.abs(spell.endPos.z-player.z))
		end
	end
	if unit.isMe and spell and (spell.name:find("jayceaccelerationgate") ~= nil) then
		cancelMovt = false
	end
	if unit.isMe and spell and (spell.name:find("jayceshockblast") ~= nil) then
    CannonQ = true
    Qtime = os.clock()
    if JayceType == 2 and EAble and Menu.FreeEQ or Keys.AutoCarry then
      cancelMovt = true
    end
  end
end

function Plugin:OnSendPacket(packet)  
  if packet.header == 0x71 then
    packet.pos = 5    
    if cancelMovt == true then
      packet:Block()
      packet:Block()
      packet:Block()
    end
  end
end

function Plugin:OnGainBuff(unit, buff)
	if unit.isMe then
		if buff.name == "jaycehypercharge" then 
			WBuff = true
		end
		if buff.name == "jaycepassiverangedattack" or buff.name == "jaycepassivemeleeattack" then 
			Passive = true
		end
		if(buff.name == "jaycestancehammer") then 
			JayceType = 1 
			
		elseif(buff.name == "jaycestancegun") then
			JayceType = 2 
		end	
		
	end
end 
function Plugin:OnLoseBuff(unit, buff)
	if unit.isMe then
		if buff.name == "jaycehypercharge" then 
			WBuff = false
		end
		if buff.name == "jaycepassiverangedattack" or buff.name == "jaycepassivemeleeattack" then 
			Passive = false
		end
	end
end 
function CheckSkill()
	QAble = (myHero:CanUseSpell(_Q) == READY)
	WAble = (myHero:CanUseSpell(_W) == READY)
	EAble = (myHero:CanUseSpell(_E) == READY)
	RAble = (myHero:CanUseSpell(_R) == READY)
end

function CheckMana()
	if QAble and EAble then 
		qMana = GetSpellData(_Q).mana
		eMana = GetSpellData(_E).mana
		if (qMana + eMana) > myHero.mana then
			return false
		else
			return true
		end
	end
end

function KillSteal()
	for _, enemy in pairs(enemyTable) do
		if enemy ~= nil and ValidTarget(enemy) then 
			local Etr = GetDistance(enemy) - getHitBoxRadius(enemy)/2
			if JayceType == 1 then
				if Etr < 600 then
					if getDmg("Q", enemy, myHero) > enemy.health and QAble then 
						CastSpell(_Q, enemy)
					end
					if getDmg("E", enemy, myHero) > enemy.health and Etr <= 240 and EAble then 
						CastSpell(_E, enemy)
					end
					if getDmg("Q", enemy, myHero) + getDmg("E", enemy, myHero) > enemy.health and QAble and EAble then
						CastSpell(_Q, enemy)
						CastSpell(_E, enemy)
					end
				end
			elseif JayceType == 2 then
				if Etr < QRange then
					if getDmg("Q", enemy, myHero) > enemy.health and QAble and Etr < 1000 then
						ProQ:GetPredictionCallBack(Target, CastQ)
					end
				end
			end
		end
	end	
end

function FreeEQ()
	if JayceType == 1 and RAble then
		CastSpell(_R) 
	elseif JayceType == 2 and CheckMana() then
		CastSpell(_Q, mousePos.x, mousePos.z)
	end
end

function Poke(Target)
	if isValidTarget(Target) then
		local Etr = GetDistance(Target) - getHitBoxRadius(Target)/2
		if JayceType == 1  then
			if Etr < 600 then
				if CheckMana() then CastSpell(_Q, Target) end
				if EAble then CastSpell(_E, Target) end
			end
			if Etr > 600 and RAble and not Passive then CastSpell(_R) end
		elseif JayceType == 2 then
			if Etr < QRange then 
				if CheckMana() then ProQ:GetPredictionCallBack(Target, CastQ) end
				if WAble and Etr <= 600 then CastSpell(_W) end
				if RAble and not EAble and not Passive and Etr <= 600 then
					if QAble and Etr <= 1050 then ProQ:GetPredictionCallBack(Target, CastQ) end
					CastSpell(_R)
				end
			end
		end
	end
end

function Combo(Target)
	if isValidTarget(Target) then
		local Etr = GetDistance(Target) - getHitBoxRadius(Target)/2
		if JayceType == 1 then
			if Etr > 240 and Etr < 600 then
				if QAble then CastSpell(_Q, Target) end
				if RAble and EAble and not QAble and not Passive and not WBuff and Etr <= 240 then CastSpell(_E, Target) end
			elseif Etr < 240 then
				if CheckMana() then CastSpell(_E, Target) end
				if QAble then CastSpell(_Q, Target) end
			end
			if WAble and Etr <= 285 then CastSpell(_W) end
			if RAble and not Passive and Etr > MyHero.TrueRange then CastSpell(_R) end
		elseif JayceType == 2 then
			if Etr < QRange then 
				if CheckMana() then ProQ:GetPredictionCallBack(Target, CastQ) end
				if WAble and Etr <= 600 then CastSpell(_W) end
				if RAble and not EAble and not Passive and Etr <= 600 then
					if QAble then ProQ:GetPredictionCallBack(Target, CastQ) end
					CastSpell(_R)
				end
			end
		end
	end
end

function CastQ(unit, pos, spell)
	if isValidTarget(unit) then
		if not QSkill:GetCollision(unit) then
			CastSpell(_Q, pos.x, pos.z)
		end
	end
end

function isValidTarget(e)
  if e and e.valid and e.team ~= myHero.team and not e.dead and e.bTargetable then
    return true
  end
   return false
end

Menu = AutoCarry.Plugins:RegisterPlugin(Plugin(), "Jayce")
Menu:addParam("FreeEQ","Free EQ at MousePos", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("A")) 
Menu:addParam("Poke","Poke enemy", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
Menu:addParam("KillSteal","Kill Steal", SCRIPT_PARAM_ONOFF, true)
Menu:addParam("GateD", "Gate distance",SCRIPT_PARAM_SLICE, 100, 1, 500, 2)