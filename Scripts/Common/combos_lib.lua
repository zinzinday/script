SPELL_TYPE_SKILLSHOT = 1
SPELL_TYPE_NORMAL = 2
SPELL_TYPE_SELF = 3
SPELL_TYPE_USERFUNC = 4

player = GetMyHero()

Spell = {}


function Spell:new(type,slot)  
    local object = {type=type, slot=slot}
    setmetatable(object, { __index = Spell })  
    return object
end

function Spell:cast(target,prediction)
	if self.type==SPELL_TYPE_USERFUNC then
		return self.slot(target)
	end
	if player:CanUseSpell(self.slot) ~= READY then
		return false
	end
	if self.type==SPELL_TYPE_SKILLSHOT then
		if(prediction) then
			CastSpell(self.slot,prediction.x,prediction.z)	
		else
			return false
		end
	end
	if self.type==SPELL_TYPE_NORMAL then
		rc = CastSpell(self.slot,target)
	end
	if self.type==SPELL_TYPE_SELF then
		CastSpell(self.slot)
	end
	return true
end  

function Spell:to_s()
	return "Spell type:"..self.type .. " slot: "..self.slot
end  

Combo = {}
function Combo:new(combo,range,func)  
    local object = {index = 1, combo=combo, test_func=func, range=range, finished=false}
    setmetatable(object, { __index = Combo })  
    return object
end

function Combo:runNextSpell(target,prediction)
	for k,v in pairs(self.selector.conditional) do
		if v(target) then
			if(k:cast(target,prediction)) then
				return
			end
		end
	end
	s = self.combo[self.index]
	
	if s:cast(target,prediction) then
		self.index = self.index +1
	end
	if self.combo[self.index]==nil then
		self.finished = true
	end
end

function Combo:to_s(  )

	rc = "{"
	for i,v in ipairs(self.combo) do
		if(v.type==SPELL_TYPE_USERFUNC) then
			rc=rc.."U "
		else
			rc=rc..v.slot.." "
		end
	end
	rc = rc.."} "..self.range
	return rc
end



ComboSelector = {}        
function ComboSelector:new()  
    local object = {combos={},conditional={}}
    setmetatable(object, { __index = ComboSelector })  
    return object
end

function ComboSelector:add_combo(combo)
	combo.selector=self
	table.insert(self.combos,combo)
end
function ComboSelector:add_conditional_spell(sp,func)
	self.conditional[sp]=func
end
function ComboSelector:get_combo()
	for i,v in ipairs(self.combos) do
		if(v.test_func(v.combo)) then 
			v.finished=false
			v.index=1
			return v 
		end
	end
	return nil
end

--UPDATEURL=
--HASH=A2858C769A74AA7295EEE8FCF11BABD5
