--[[
	Library: inventory v0.1
	Author: SurfaceS
	
	required libs : 		-
	exposed variables : 	inventory, player
	
	UPDATES :
	v0.1				initial release
	v0.2				BoL Studio Version
]]

if player == nil then player = GetMyHero() end

inventory = {
	itemSlot = {ITEM_1,ITEM_2,ITEM_3,ITEM_4,ITEM_5,ITEM_6}
}
function inventory.slotItem( itemID )
    for i=1,6,1 do
        if player:getInventorySlot(inventory.itemSlot[i]) == itemID then return inventory.itemSlot[i] end
    end
	return nil
end
function inventory.haveItem( itemID )
    local slot = inventory.slotItem( itemID ) 
	return (slot ~= nil)
end
function inventory.slotIsEmpty( slot )
    return (player:getInventorySlot(slot) == 0)
end
function inventory.itemIsCastable( itemID )
	local slot = inventory.slotItem( itemID )
	if slot == nil then return false end
	return (player:CanUseSpell(slot) == READY)
end
-- inventory.castItem(itemID) -> Cast item
-- inventory.castItem(itemID, var1) -> Cast item on hero = var1
-- inventory.castItem(itemID, var1, var2) -> Cast item on posX = var1, pasZ = var2
function inventory.castItem( itemID, var1, var2 )
	local slot = inventory.slotItem( itemID )
	if slot == nil then return false end
	if (player:CanUseSpell(slot) == READY) then
		if (var2 ~= nil) then CastSpell(slot, var1, var2)
		elseif (var1 ~= nil) then CastSpell(slot, var1)
		else CastSpell(slot)
		end
		return true
	end
	return false
end

--UPDATEURL=
--HASH=503D589B4A2101D3CDF84F46FA3A1AA9
