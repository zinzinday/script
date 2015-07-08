local activeBuffs = { }

AdvancedCallback:register("OnGainBuff", "OnUpdateBuff", "OnLoseBuff")

function OnRecvPacket(p)
  if p.header == 0xB7 then -- AddBuff
    local unit = objManager:GetObjectByNetworkId(p:DecodeF())
    local slot = p:Decode1() + 1
    local buffType = p:Decode1()
    local unk = p:Decode1() -- unk
    local stack = p:Decode1()
    local duration = p:DecodeF()
    local hash = p:Decode4()
    local source = objManager:GetObjectByNetworkId(p:DecodeF())

    if type(activeBuffs[unit.networkID]) ~= "table" then
      activeBuffs[unit.networkID] = {  }
    end

    DelayAction(
      function()
        activeBuffs[unit.networkID][slot] = {
          slot = slot,
          type = buffType,
          stack = stack,
          visible = unk,
          hash = hash,
          duration = duration,
          source = source,
          startT = GetInGameTimer(),
          endT = GetInGameTimer() + duration
        }

  			local buff = unit:getBuff(slot)
  			activeBuffs[unit.networkID][slot].name = buff and buff.name or ""

        AdvancedCallback:OnGainBuff(unit, activeBuffs[unit.networkID][slot])
      end
    )
  elseif p.header == 0x011C then -- EditBuff
    local unit = objManager:GetObjectByNetworkId(p:DecodeF())
    local stack = p:Decode1()
    local unk = p:Decode4()
    local slot = p:Decode1() + 1
    local source = objManager:GetObjectByNetworkId(p:DecodeF())
    local duration = p:DecodeF()

    if type(activeBuffs[unit.networkID]) == "table" and activeBuffs[unit.networkID][slot] then
      activeBuffs[unit.networkID][slot].stack = stack
      activeBuffs[unit.networkID][slot].duration = duration
      activeBuffs[unit.networkID][slot].endT = GetInGameTimer() + duration

      AdvancedCallback:OnUpdateBuff(unit, activeBuffs[unit.networkID][slot])
    end
  elseif p.header == 0x7B then -- RemoveBuff
    local unit = objManager:GetObjectByNetworkId(p:DecodeF())
    local slot = p:Decode1() + 1

    if type(activeBuffs[unit.networkID]) == "table" and activeBuffs[unit.networkID][slot] then
      AdvancedCallback:OnLoseBuff(unit, activeBuffs[unit.networkID][slot])

      activeBuffs[unit.networkID][slot] = nil
    end
  end
end
