require "issuefree/timCommon"

local load = false
local clones = {}

local cloningHeroes = {"MonkeyKing", "Shaco", "LeBlanc", "Yorick", "Mordekaiser"}

function checkClones(object)
	-- this one seems weird
	if object.name == "MonkeyKing bot" then
		clone = {object = object,tick = GetClock(),duration = 1500}
		table.insert(clones,clone)
	elseif object.name == "mordekaiser_cotg_ring.troy" then
		clone = {object = object,tick = GetClock(),duration = 30000}
		table.insert(clones,clone)
	else
		for _,hero in ipairs(ENEMIES) do
			if object ~= hero then
				if object.name == "Yorick" and hero.name == "Yorick" then
					clone = {object = object,tick = GetClock(),duration = 10000}
					table.insert(clones,clone)
				end
				if object.name == "Leblanc" and hero.name == "Leblanc" then
					clone = {object = object,tick = GetClock(),duration = 8000}
					table.insert(clones,clone)
				end
				if object.name == "Shaco" and hero.name == "Shaco" then
					clone = {object = object,tick = GetClock(),duration = 18000}
					table.insert(clones,clone)
				end
			end
		end
	end
end

for i=1, objManager:GetMaxHeroes() do
	if ListContains(objManager:GetHero(i).name, cloningHeroes) then 
		load = true
		AddOnCreate(checkClones)
		break
	end
end


if load then
	function Run()
		OnDraw()
	end

	function OnDraw()
		for i, clone in rpairs(clones) do
			TextObject(string.format(math.floor((clone.tick+clone.duration-GetClock())/(10)+0.5)/100).."s",clone.object,0xFF0000FF)
			CustomCircle(100,10,red,clone.object)
			if GetClock() > (clone.tick+clone.duration) then 
				table.remove(clones,i) 
			end
		end
	end

	AddOnTick(Run)

	ModuleConfig.clones = true
end
ModuleConfig:addParam("clones", "Clone Revealer", SCRIPT_PARAM_ONOFF, false)
ModuleConfig:permaShow("clones")

