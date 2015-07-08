toCast = {["Jax"] = _Q, ["LeeSin"] = _W, ["Katarina"] = _E}
if not toCast[myHero.charName] then return end

function OnLoad()
	Config = scriptConfig("WardJump","WardJump")
	Config:addParam("wj", "Wardjump", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("G"))
	Config:addParam("d", "Draw", SCRIPT_PARAM_ONOFF, true)
	Wards = {}
	casted, jumped = false, false
	for i = 1, objManager.maxObjects do
		local object = objManager:GetObject(i)
		if object ~= nil and object.valid and string.find(string.lower(object.name), "ward") then
			table.insert(Wards, object)
		end
	end
end

function OnTick()
	if Config.wj or (casted and not jumped) then
		WardJump()
	end
end

function OnDraw()
	if Config.d then
		local pos = getMousePos()
		DrawCircle3D(pos.x,pos.y,pos.z,150,1,ARGB(255,255,255,255),32)
	end
end

function WardJump()
	if casted and jumped then casted, jumped = false, false
	elseif myHero:CanUseSpell(_W) == READY and myHero.charName == "LeeSin" and myHero:GetSpellData(_W).name == "BlindMonkWOne" then
		local pos = getMousePos()
		if Jump(pos, 150, true) then return end
		slot = GetWardSlot()
		if not slot then return end
		CastSpell(slot, pos.x, pos.z)
	elseif myHero:CanUseSpell(_E) == READY and myHero.charName == "Katarina" then
		local pos = getMousePos()
		if Jump(pos, 150, true) then return end
		slot = GetWardSlot()
		if not slot then return end
		CastSpell(slot, pos.x, pos.z)
	elseif myHero:CanUseSpell(_Q) == READY and myHero.charName == "Jax" then
		local pos = getMousePos()
		if Jump(pos, 150, true) then return end
		slot = GetWardSlot()
		if not slot then return end
		CastSpell(slot, pos.x, pos.z)
	end
end

function Jump(pos, range, useWard)
	for _,ally in pairs(GetAllyHeroes()) do
		if (GetDistance(ally, pos) <= range) then
			CastSpell(toCast[myHero.charName], ally)
			jumped = true
			return true
		end
	end
	for minion,winion in pairs(minionManager(MINION_ALLY, range, pos, MINION_SORT_HEALTH_ASC).objects) do
		if (GetDistance(winion, pos) <= range) then
			CastSpell(toCast[myHero.charName], winion)
			jumped = true
			return true
		end
	end
	table.sort(Wards, function(x,y) return GetDistance(x) < GetDistance(y) end)
	for i, ward in ipairs(Wards) do
		if (GetDistance(ward, pos) <= range) then
			CastSpell(toCast[myHero.charName], ward)
			jumped = true
			return true
		end
	end
end

function OnCreateObj(obj)
	if obj ~= nil and obj.valid then
		if string.find(string.lower(obj.name), "ward") then
			table.insert(Wards, obj)
		end
	end
end

function getMousePos(range)
	local MyPos = Vector(myHero.x, myHero.y, myHero.z)
	local MousePos = Vector(mousePos.x, mousePos.y, mousePos.z)
	return MyPos - (MyPos - MousePos):normalized() * (myHero.charName == "LeeSin" and 600 or 700)
end

function GetWardSlot()
	for slot = ITEM_7, ITEM_1, -1 do
		if myHero:GetSpellData(slot).name and myHero:CanUseSpell(slot) == READY and (string.find(string.lower(myHero:GetSpellData(slot).name), "ward") or string.find(string.lower(myHero:GetSpellData(slot).name), "trinkettotem")) then
			return slot
		end
	end
	return nil
end