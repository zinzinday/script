require "Utils"
require "issuefree/timCommon"

local cleanse = {"stun", "banish", 
-- "taunt", 
"fear", "charm",
-- "shackle", 
"binding", "prison", "wither", "ultwrap", "root", "RengarEMax", "VarusRHitFlash"} 

local byAbil = concat({"nethergrasp", "infiniteduress", "skarner_ult_tail_tip", "SwapArrow"}, cleanse)
local byItem  = concat({"mordekaiser_cotg_tar", "Fizz_UltimateMissle_Orbit"}, byAbil)

local exceptions = {"StunReady"}

local cleanseKey

if me.SummonerD == "summonerboost" then
   cleanseKey = "D"
elseif me.SummonerF == "summonerboost" then
   cleanseKey = "F" 
end

local function CheckCC(object, list)
	if ListContains(object.name, list) and
		not ListContains(object.name, exceptions)
	then
		return true
	end
	return false
end

local function cleanseObj(object)
	if not ModuleConfig.cleanse then return end
	if object and GetDistance(object) < 75 then
		if me.name == "Gangplank" and CanUse("W") and
		   CheckCC(object, byAbil) 
		then
			Cast("W", me)
			pp("Removed "..object.name.." with oranges.")
			return
		end
		
		if me.name == "Olaf" and CanUse("R") and
			CheckCC(object, byAbil) and
			not Alone()
      then
			Cast("R", me)
			pp("Removed "..object.name.." with Ragnarok.")
			return
		end
		
		local item = ITEMS["Quicksilver Sash"]
		local slot = GetInventorySlot(item.id)
		if slot and CheckCC(object, byItem) then
			CastSpellTarget(slot, me)
			pp("Removed "..object.name.." with QSS.")
			return
		end

		local item = ITEMS["Mercurial Scimitar"]
		local slot = GetInventorySlot(item.id)
		if slot and CheckCC(object, byItem) then
			CastSpellTarget(slot, me)
			pp("Removed "..object.name.." with MS.")
			return
		end
		
		if cleanseKey and CheckCC(object, cleanse) then
			CastHotkey("SPELL"..cleanseKey..":WEAKALLY SMARTCAST")
			pp("Removed "..object.name.." with Cleanse.")
			return
		end
	end

	local item = ITEMS["Mikael's Crucible"]
	local slot = GetInventorySlot(item.id)
	if slot then
		if CheckCC(object, byItem) then
			if GetDistance(ADC, object) < 75 then
				UseItem("Mikael's Crucible", ADC)
				pp("Mikael's ADC "..ADC.charName.." : "..object.name)
				return
			end
			if GetDistance(APC, object) < 75 then
				UseItem("Mikael's Crucible", APC)
				pp("Mikael's APC "..APC.charName.." : "..object.name)
				return
			end
		end
	end

end

AddOnCreate(cleanseObj)