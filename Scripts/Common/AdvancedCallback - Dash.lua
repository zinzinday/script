AdvancedCallback:register('OnDash')
function OnNewPath(unit, startPos, endPos, isDash, dashSpeed, dashGravity, dashDistance)
if not isDash then return end
	AdvancedCallback:OnDash(unit,{
		startPos = startPos,
		endPos = endPos,
		distance = GetDistance(startPos,endPos),
		speed = dashSpeed,
		duration = (GetDistance(startPos,endPos)/dashSpeed),
		startT = GetGameTimer(),
		endT = GetGameTimer()+(GetDistance(startPos,endPos)/dashSpeed),
	})
end 
