--[[  comboLib.lua v1.3

         by llama

]]
do
    -- require"spellDmg"
    local itemArray = {
        { name = "DFG", id = 3128 },
        { name = "HXG", id = 3146 },
        { name = "BWC", id = 3144 },
        { name = "RUINEDKING", id = 3153 },
        { name = "TIAMAT", id = 3077 },
        { name = "HYDRA", id = 3074 },
    }

    comboLib = {}
    local addItemFlag = false
    local BRKSlot, DFGSlot, HXGSlot, BWCSlot, TMTSlot, RAHSlot, RNDSlot, YGBSlot
    local DFGREADY, HXGREADY, BWCREADY, BRKREADY, TMTREADY, RAHREADY, RNDREADY, YGBREADY, IREADY
    local usableArray = {}
    local player = myHero
    local comboArray = {}
    local comboStorage = {}
    local skillCountArray = {}
    local skillCount
    local igniteName = "SummonerDot"

    local function checkItems(object)
        local ItemSlot = { ITEM_1, ITEM_2, ITEM_3, ITEM_4, ITEM_5, ITEM_6, }

        for i = 1, #comboArray, 1 do
            for j = 1, #itemArray, 1 do
                if comboArray[i].name == itemArray[j].name then

                    comboArray[i].isItem = true
                    comboArray[i].slot = nil

                    for k = 1, #ItemSlot, 1 do
                        if player:getInventorySlot(ItemSlot[k]) == itemArray[j].id then
                            comboArray[i].slot = ItemSlot[k]
                            comboArray[i].skill = ItemSlot[k]
                        end
                    end
                end
            end
        end
    end

    local function checkMana()

        for i = 1, #usableArray, 1 do
            usableArray[i].mana = player:GetSpellData(usableArray[i].skill).mana
        end
    end

    local function checkCombo(object)

        for i = 1, #comboArray, 1 do
            if comboArray[i].isItem == true then
                if comboArray[i].slot == nil then
                    comboArray[i].offCooldown = false
                else
                    comboArray[i].offCooldown = player:CanUseSpell(comboArray[i].slot) == READY
                end
            else
                comboArray[i].offCooldown = (player:CanUseSpell(comboArray[i].skill) == READY)
            end

            if comboArray[i].offCooldown then
                comboArray[i].customTest = (comboArray[i].customFunction and comboArray[i].customFunction() == comboArray[i].customResult) or comboArray[i].customFunction == nil
                comboArray[i].isInRange = (player:GetDistance(object) <= comboArray[i].range)
                comboArray[i].dmg = math.floor(getDmg(comboArray[i].name, object, player))
            end
        end
    end

    local function makeUsableCombo()
        local j = 1
        for i = 1, #comboArray, 1 do
            if comboArray[i].offCooldown == true and comboArray[i].isInRange == true and comboArray[i].customTest == true and comboArray[i].dmg > 0 then
                usableArray[j] = comboArray[i]
                j = j + 1
            end
        end
    end

    local function hasDFG(combo)
        local test = false
        local dfgNumber
        for i = 1, #combo, 1 do
            if combo[i].name == "DFG" then
                test = true
                dfgNumber = i
            else
                test = test or false
            end
        end
        return test, dfgNumber
    end

    local function killableTotal(combo, health)
        local tempDmg, tempMana = 0, 0
        local length = #combo
        local usableMana = math.floor(player.mana)
        local dfgFlag, dfgNumber = hasDFG(combo)

        if dfgFlag == true and dfgNumber then
            for i = 1, length, 1 do
                if combo[i].name ~= "DFG" then
                    tempDmg = tempDmg + combo[i].dmg * 1.2
                else
                    tempDmg = tempDmg + combo[i].dmg
                end
                tempMana = tempMana + combo[i].mana
            end
        else
            for i = 1, length, 1 do
                tempDmg = tempDmg + combo[i].dmg
                tempMana = tempMana + combo[i].mana
            end
        end
        return tempDmg > health and tempMana < usableMana
    end



    local function findCombo(health)
        --local totalDmg = 0
        --local totalMana = 0
        local bestCombo = {}
        local usableMana = math.floor(player.mana)
        local length = #usableArray
        --local dfgFlag, dfgNumber = hasDFG(usableArray)

        if killableTotal(usableArray, health) == false then
            return nil
        else
            if length >= 1 then
                for i = 1, length, 1 do
                    if usableArray[i].dmg > health then
                        if usableArray[i].mana < usableMana then
                            bestCombo[1] = usableArray[i]
                            return bestCombo
                        end
                    end
                end
            end
            if length >= 2 then
                for i = 1, length, 1 do
                    for j = 1, length, 1 do
                        if i ~= j then
                            bestCombo[1] = usableArray[i]
                            bestCombo[2] = usableArray[j]
                            if killableTotal(bestCombo, health) then
                                return bestCombo
                            end
                        end
                    end
                end
            end
            if length >= 3 then
                for i = 1, length, 1 do
                    for j = 1, length, 1 do
                        for k = 1, length, 1 do
                            if i ~= j and j ~= k and i ~= k then
                                -- if usableArray[i].dmg + usableArray[j].dmg + usableArray[k].dmg > health then
                                --if usableArray[i].mana + usableArray[j].mana + usableArray[k].mana < usableMana then
                                bestCombo[1] = usableArray[i]
                                bestCombo[2] = usableArray[j]
                                bestCombo[3] = usableArray[k]
                                if killableTotal(bestCombo, health) then
                                    return bestCombo
                                end
                                -- end
                                -- end
                            end
                        end
                    end
                end
            end
            if length >= 4 then
                for i = 1, length, 1 do
                    for j = 1, length, 1 do
                        for k = 1, length, 1 do
                            for l = 1, length, 1 do
                                if i ~= j and i ~= k and i ~= l and j ~= k and j ~= l and k ~= l then
                                    -- if usableArray[i].dmg + usableArray[j].dmg + usableArray[k].dmg + usableArray[l].dmg > health then
                                    --  if usableArray[i].mana + usableArray[j].mana + usableArray[k].mana + usableArray[l].mana < usableMana then
                                    bestCombo[1] = usableArray[i]
                                    bestCombo[2] = usableArray[j]
                                    bestCombo[3] = usableArray[k]
                                    bestCombo[4] = usableArray[l]
                                    if killableTotal(bestCombo, health) then
                                        return bestCombo
                                    end
                                    --end
                                    --end
                                end
                            end
                        end
                    end
                end
            end
            if length >= 5 then
                for i = 1, length, 1 do
                    for j = 1, length, 1 do
                        for k = 1, length, 1 do
                            for l = 1, length, 1 do
                                for m = 1, length, 1 do
                                    if i ~= j and i ~= k and i ~= l and i ~= m and j ~= k and j ~= l and j ~= m and k ~= l and k ~= m and l ~= m then
                                        --if usableArray[i].dmg + usableArray[j].dmg + usableArray[k].dmg + usableArray[l].dmg + usableArray[m].dmg > health then
                                        -- if usableArray[i].mana + usableArray[j].mana + usableArray[k].mana + usableArray[l].mana + usableArray[m].mana < usableMana then
                                        bestCombo[1] = usableArray[i]
                                        bestCombo[2] = usableArray[j]
                                        bestCombo[3] = usableArray[k]
                                        bestCombo[4] = usableArray[l]
                                        bestCombo[5] = usableArray[m]
                                        if killableTotal(bestCombo, health) then
                                            return bestCombo
                                        end
                                        -- end
                                        -- end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if length >= 6 then
                for i = 1, length, 1 do
                    for j = 1, length, 1 do
                        for k = 1, length, 1 do
                            for l = 1, length, 1 do
                                for m = 1, length, 1 do
                                    for n = 1, length, 1 do
                                        if i ~= j and i ~= k and i ~= l and i ~= m and i ~= n and j ~= k and j ~= l and j ~= m and j ~= n and k ~= l and k ~= m and k ~= n and l ~= m and l ~= n and m ~= n then
                                            -- if usableArray[i].dmg + usableArray[j].dmg + usableArray[k].dmg + usableArray[l].dmg + usableArray[m].dmg + usableArray[n].dmg > health then
                                            --  if usableArray[i].mana + usableArray[j].mana + usableArray[k].mana + usableArray[l].mana + usableArray[m].mana + usableArray[n].mana < usableMana then
                                            bestCombo[1] = usableArray[i]
                                            bestCombo[2] = usableArray[j]
                                            bestCombo[3] = usableArray[k]
                                            bestCombo[4] = usableArray[l]
                                            bestCombo[5] = usableArray[m]
                                            bestCombo[6] = usableArray[n]
                                            if killableTotal(bestCombo, health) then
                                                return bestCombo
                                            end
                                            -- end
                                            -- end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if length >= 7 then
                for i = 1, length, 1 do
                    for j = 1, length, 1 do
                        for k = 1, length, 1 do
                            for l = 1, length, 1 do
                                for m = 1, length, 1 do
                                    for n = 1, length, 1 do
                                        for o = 1, length, 1 do
                                            if i ~= j and i ~= k and i ~= l and i ~= m and i ~= n and i ~= o and j ~= k and j ~= l and j ~= m and j ~= n and j ~= o and k ~= l and k ~= m and k ~= n and k ~= o and l ~= m and l ~= n and l ~= o and m ~= n and m ~= o and n ~= o then
                                                -- if usableArray[i].dmg + usableArray[j].dmg + usableArray[k].dmg + usableArray[l].dmg + usableArray[m].dmg + usableArray[n].dmg + usableArray[o].dmg > health then
                                                --    if usableArray[i].mana + usableArray[j].mana + usableArray[k].mana + usableArray[l].mana + usableArray[m].mana + usableArray[n].mana + usableArray[o].mana < usableMana then
                                                bestCombo[1] = usableArray[i]
                                                bestCombo[2] = usableArray[j]
                                                bestCombo[3] = usableArray[k]
                                                bestCombo[4] = usableArray[l]
                                                bestCombo[5] = usableArray[m]
                                                bestCombo[6] = usableArray[n]
                                                bestCombo[7] = usableArray[o]
                                                if killableTotal(bestCombo, health) then
                                                    return bestCombo
                                                end
                                                -- end
                                                -- end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if length >= 8 then
                for i = 1, length, 1 do
                    for j = 1, length, 1 do
                        for k = 1, length, 1 do
                            for l = 1, length, 1 do
                                for m = 1, length, 1 do
                                    for n = 1, length, 1 do
                                        for o = 1, length, 1 do
                                            for p = 1, length, 1 do
                                                if i ~= j and i ~= k and i ~= l and i ~= m and i ~= n and i ~= o and i ~= p and j ~= k and j ~= l and j ~= m and j ~= n and j ~= o and j ~= p and k ~= l and k ~= m and k ~= n and k ~= o and k ~= p and l ~= m and l ~= n and l ~= o and l ~= p and m ~= n and m ~= o and m ~= p and n ~= o and n ~= p and o ~= p then
                                                    --if usableArray[i].dmg + usableArray[j].dmg + usableArray[k].dmg + usableArray[l].dmg + usableArray[m].dmg + usableArray[n].dmg + usableArray[o].dmg + usableArray[p].dmg > health then
                                                    --   if usableArray[i].mana + usableArray[j].mana + usableArray[k].mana + usableArray[l].mana + usableArray[m].mana + usableArray[n].mana + usableArray[o].mana + usableArray[p].mana < usableMana then
                                                    bestCombo[1] = usableArray[i]
                                                    bestCombo[2] = usableArray[j]
                                                    bestCombo[3] = usableArray[k]
                                                    bestCombo[4] = usableArray[l]
                                                    bestCombo[5] = usableArray[m]
                                                    bestCombo[6] = usableArray[n]
                                                    bestCombo[7] = usableArray[o]
                                                    bestCombo[8] = usableArray[p]
                                                    if killableTotal(bestCombo, health) then
                                                        return bestCombo
                                                    end
                                                    -- end
                                                    -- end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if length >= 9 then
                for i = 1, length, 1 do
                    for j = 1, length, 1 do
                        for k = 1, length, 1 do
                            for l = 1, length, 1 do
                                for m = 1, length, 1 do
                                    for n = 1, length, 1 do
                                        for o = 1, length, 1 do
                                            for p = 1, length, 1 do
                                                for q = 1, length, 1 do
                                                    if i ~= j and i ~= k and i ~= l and i ~= m and i ~= n and i ~= o and i ~= p and i ~= q and j ~= k and j ~= l and j ~= m and j ~= n and j ~= o and j ~= p and j ~= q and k ~= l and k ~= m and k ~= n and k ~= o and k ~= p and k ~= q and l ~= m and l ~= n and l ~= o and l ~= p and l ~= q and m ~= n and m ~= o and m ~= p and m ~= q and n ~= o and n ~= p and n ~= q and o ~= p and o ~= q and p ~= q then
                                                        -- if usableArray[i].dmg + usableArray[j].dmg + usableArray[k].dmg + usableArray[l].dmg + usableArray[m].dmg + usableArray[n].dmg + usableArray[o].dmg + usableArray[p].dmg + usableArray[q].dmg > health then
                                                        -- if usableArray[i].mana + usableArray[j].mana + usableArray[k].mana + usableArray[l].mana + usableArray[m].mana + usableArray[n].mana + usableArray[o].mana + usableArray[p].mana + usableArray[q].mana < usableMana then
                                                        bestCombo[1] = usableArray[i]
                                                        bestCombo[2] = usableArray[j]
                                                        bestCombo[3] = usableArray[k]
                                                        bestCombo[4] = usableArray[l]
                                                        bestCombo[5] = usableArray[m]
                                                        bestCombo[6] = usableArray[n]
                                                        bestCombo[7] = usableArray[o]
                                                        bestCombo[8] = usableArray[p]
                                                        bestCombo[9] = usableArray[q]
                                                        if killableTotal(bestCombo, health) then
                                                            return bestCombo
                                                        end
                                                        -- end
                                                        -- end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if length >= 10 then
                for i = 1, length, 1 do
                    for j = 1, length, 1 do
                        for k = 1, length, 1 do
                            for l = 1, length, 1 do
                                for m = 1, length, 1 do
                                    for n = 1, length, 1 do
                                        for o = 1, length, 1 do
                                            for p = 1, length, 1 do
                                                for q = 1, length, 1 do
                                                    for r = 1, length, 1 do
                                                        if i ~= j and i ~= k and i ~= l and i ~= m and i ~= n and i ~= o and i ~= p and i ~= q and i ~= r and j ~= k and j ~= l and j ~= m and j ~= n and j ~= o and j ~= p and j ~= q and j ~= r and k ~= l and k ~= m and k ~= n and k ~= o and k ~= p and k ~= q and k ~= r and l ~= m and l ~= n and l ~= o and l ~= p and l ~= q and l ~= r and m ~= n and m ~= o and m ~= p and m ~= q and m ~= r and n ~= o and n ~= p and n ~= q and n ~= r and o ~= p and o ~= q and o ~= r and p ~= q and p ~= r and q ~= r then
                                                            -- if usableArray[i].dmg + usableArray[j].dmg + usableArray[k].dmg + usableArray[l].dmg + usableArray[m].dmg + usableArray[n].dmg + usableArray[o].dmg + usableArray[p].dmg + usableArray[q].dmg + usableArray[r].dmg > health then
                                                            --  if usableArray[i].mana + usableArray[j].mana + usableArray[k].mana + usableArray[l].mana + usableArray[m].mana + usableArray[n].mana + usableArray[o].mana + usableArray[p].mana + usableArray[q].mana + usableArray[r].mana < usableMana then
                                                            bestCombo[1] = usableArray[i]
                                                            bestCombo[2] = usableArray[j]
                                                            bestCombo[3] = usableArray[k]
                                                            bestCombo[4] = usableArray[l]
                                                            bestCombo[5] = usableArray[m]
                                                            bestCombo[6] = usableArray[n]
                                                            bestCombo[7] = usableArray[o]
                                                            bestCombo[8] = usableArray[p]
                                                            bestCombo[9] = usableArray[q]
                                                            bestCombo[10] = usableArray[r]
                                                            if killableTotal(bestCombo, health) then
                                                                return bestCombo
                                                            end
                                                            -- end
                                                            -- end
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local function checkDFG(combo)
        local tempcombo = {}
        local dfgNum
        local dfgFound = false
        for i = 1, #combo, 1 do
            if combo[i].name == "DFG" then
                tempcombo[1] = combo[i]
                dfgFound = true
                dfgNum = i
            end
        end

        if dfgFound then
            for i = 2, #combo, 1 do
                if i <= dfgNum then
                    tempcombo[i] = combo[i - 1]
                else
                    tempcombo[i] = combo[i]
                end
            end
            return tempcombo
        else
            return combo
        end
    end

    function comboLib:newSkill(skillName, skillRange, comboNum, myFunction, myResult)
        local combo = {}
        skillName = string.upper(skillName)

        comboNum = comboNum or 1

        if comboStorage[comboNum] == nil then
            comboStorage[comboNum] = { comboArray = {} }
        end

        if skillCountArray[comboNum] == nil then
            skillCountArray[comboNum] = 1
        end

        skillCount = skillCountArray[comboNum]
        skillCountArray[comboNum] = skillCountArray[comboNum] + 1

        if skillName ~= "IGNITE" or (skillName == "IGNITE" and (player:GetSpellData(SUMMONER_1).name == igniteName or player:GetSpellData(SUMMONER_2).name == igniteName)) then
            comboStorage[comboNum].comboArray[skillCount] = { name = skillName, range = skillRange, customFunction = myFunction, customResult = myResult, customTest = false, isInRange = true, offCooldown = false, isItem = false, slot = nil, skill = nil, mana = 0 }
        end
        if skillName == "Q" or skillName == "QM" then
            comboStorage[comboNum].comboArray[skillCount].skill = _Q
        elseif skillName == "W" or skillName == "W" then
            comboStorage[comboNum].comboArray[skillCount].skill = _W
        elseif skillName == "E" or skillName == "EM" then
            comboStorage[comboNum].comboArray[skillCount].skill = _E
        elseif skillName == "R" then
            comboStorage[comboNum].comboArray[skillCount].skill = _R
        elseif skillName == "IGNITE" then
            if player:GetSpellData(SUMMONER_1).name == igniteName then
                comboStorage[comboNum].comboArray[skillCount].skill = SUMMONER_1
            elseif player:GetSpellData(SUMMONER_2).name == igniteName then
                comboStorage[comboNum].comboArray[skillCount].skill = SUMMONER_2
            end
        end
    end

    function comboLib:findBestCombo(target, comboNum)
        local bestCombo = {}
        if comboNum == nil then
            comboNum = 1
        end

        comboArray = comboStorage[comboNum].comboArray
        if target and #comboArray > 0 then

            checkItems() --checks array for items

            checkCombo(target) --checks array for cooldowns, ranges, damage, and conditionals.

            usableArray = {} --resets array of usable skills/items

            makeUsableCombo() --makes the array depending on cooldown and range
            if #usableArray > 0 then --usable array must have at least 1 skill/item

                checkMana() --collects skill mana costs in the usable array.

                bestCombo = findCombo(math.floor(target.health)) --find the best combo to kill.

                if bestCombo and #bestCombo > 0 then
                    bestCombo = checkDFG(bestCombo) --find DFG, put it at the top of list.
                end
            end
        end
        return bestCombo
    end
end