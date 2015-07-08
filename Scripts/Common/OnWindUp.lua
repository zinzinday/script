-- DEFINE CUSTOM CALLBACK (OnWindUp.lua in Common Folder)

_ENV = AdvancedCallback:register('OnWindUp')

function OnProcessSpell(unit, spell)
    if string.find(spell.name, "Attack") then
        DelayAction(
            function(unit, attack) AdvancedCallback:OnWindUp(unit, attack) end,
            spell.windUpTime - GetLatency() / 2000,
            {unit, {name = spell.name, target = spell.target}}
        )
    end
end