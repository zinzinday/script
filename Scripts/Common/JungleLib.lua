-- Internal constants
local JUNGLE_MOBS = { ["GreatWraith"]  = { useSmite = true, buffMob = false },
                      ["AncientGolem"] = { useSmite = true, buffMob = true },
                      ["GiantWolf"]    = { useSmite = true, buffMob = false },
                      ["Wraith"]       = { useSmite = true, buffMob = false },
                      ["LizardElder"]  = { useSmite = true, buffMob = true },
                      ["Golem"]        = { useSmite = true, buffMob = false },
                      ["Worm"]         = { useSmite = true, buffMob = true },
                      ["Dragon"]       = { useSmite = true, buffMob = false },

                      ["YoungLizard"]  = { useSmite = false, buffMob = false },
                      ["Wolf"]         = { useSmite = false, buffMob = false },
                      ["LesserWraith"] = { useSmite = false, buffMob = false },
                      ["Golem"]        = { useSmite = false, buffMob = false } }

-- Internal globals
local jungleTable = {}


function __OnCreateObj(object)

    if object and object.valid and object.type == "obj_AI_Minion" then
        DelayAction(function(object)
            if object.name and not object.dead then
                if object.team == TEAM_NEUTRAL then
                    table.insert(jungleTable, object)
                end
            end
        end, 0, { object })
    end

end

class 'JungleLib'
--{
    function JungleLib:__init()

        -- Check instance, only allow one instance of JungleLib
        if not _G.JungleLibInstance then
            _G.JungleLibInstance = self
        else
            return _G.JungleLibInstance
        end

        -- Add startsWith method to strings
        rawset(_G.string, "startsWith",
            function(self, piece)
                return string.sub(self, 1, string.len(piece)) == piece
            end
        )

        -- Register callbacks
        AddCreateObjCallback(__OnCreateObj)

        -- Register current mobs
        for i = 1, objManager.maxObjects do
            __OnCreateObj(objManager:getObject(i))
        end

        return self

    end

    function JungleLib:IsValidJungleMob(mob)

        return mob and mob.valid and mob.type == "obj_AI_Minion" and mob.name and mob.team == TEAM_NEUTRAL

    end

    function JungleLib:IsBigMob(mob)

        if self:IsValidJungleMob(mob) then
            local mobName = mob.name

            for name, entry in pairs(JUNGLE_MOBS) do
                if mobName:startsWith(name) then
                    return entry.useSmite ~= nil and entry.useSmite or false
                end
            end
        end

        return false

    end

    function JungleLib:UseSmite(mob)

        return self:IsBigMob(mob)

    end

    function JungleLib:HasBuff(mob)

        if self:IsValidJungleMob(mob) then
            local mobName = mob.name

            for name, entry in pairs(JUNGLE_MOBS) do
                if mobName:startsWith(name) then
                    return entry.buffMob ~= nil and entry.buffMob or false
                end
            end
        end

        return false

    end

    function JungleLib:GetJungleMobs(visible, range)

        local validJungleMobs = {}

        for _, mob in pairs(jungleTable) do
            if mob and mob.valid and not mob.dead and (visible and mob.visible) and (range and GetDistanceSqr(mob) <= range ^ 2) then
                table.insert(validJungleMobs, mob)
            end
        end

        table.sort(validJungleMobs,
            function(a, b)
                if self:IsBigMob(a) and not self:IsBigMob(b) then
                    return true
                elseif self:IsBigMob(b) and not self:IsBigMob(a) then
                    return false
                end
                return a.maxHealth > b.maxHealth
            end
        )

        return validJungleMobs

    end

    function JungleLib:MobCount(visible, range)

        return #self:GetJungleMobs(visible, range)

    end
--}