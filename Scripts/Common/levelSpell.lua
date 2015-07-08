--[[
	Level Spell library
	Script by SurfaceS
	v0.1a
	
	Usage :
		On your script :
		Load the lib :
		Set the levelSequence :
			autoLevel.levelSequence = {1,nil,0,1,1,4,1,nil,1,nil,4,nil,nil,nil,nil,4,nil,nil}
				The levelSequence is table of 18 fields
				1-4 = spell 1 to 4
				nil = will not auto level on this one
				0 = will use your own function (called autoLevel.onChoiceFunction()) for this one, that return a number between 1-4
			
		Set the function if you use 0, example :
			autoLevel.onChoiceFunction = function()
				if myHero:GetSpellData(SPELL_2).level < myHero:GetSpellData(SPELL_3).level then
					return 2
				else
					return 3
				end
			end
		Call the main function on your tick :
			autoLevel.levelSpell()

]]

-- for those who not use loader.lua
if myHero == nil then myHero = GetMyHero() end

--[[ 		Globals		]]
autoLevel = {}
autoLevel.lastUse = 0
autoLevel.spellsSlots = {SPELL_1, SPELL_2, SPELL_3, SPELL_4}
autoLevel.levelSequence = {}

--[[ 		Code		]]

function autoLevel.realHeroLevel()
	return myHero:GetSpellData(SPELL_1).level + myHero:GetSpellData(SPELL_2).level + myHero:GetSpellData(SPELL_3).level + myHero:GetSpellData(SPELL_4).level
end

function autoLevel.levelSpellTick()
	local realLevel = autoLevel.realHeroLevel()
	if autoLevel.lastUse < GetTickCount() and myHero.level > realLevel and autoLevel.levelSequence[realLevel + 1] ~= nil then
		local spellToLearn = autoLevel.levelSequence[realLevel + 1]
		if spellToLearn == 0 then
			if autoLevel.onChoiceFunction == nil then return nil end
			spellToLearn = autoLevel.onChoiceFunction()
			if spellToLearn == nil or spellToLearn < 1 or spellToLearn > 4 then return nil end
		end
		LevelSpell(autoLevel.spellsSlots[spellToLearn])
		autoLevel.lastUse = GetTickCount() + 1000
	end
end


--UPDATEURL=
--HASH=7190FD0001B3DD2FA560B7A401FE2AC0
