--[[
	Animations Lib OLD !!
	v0.3c
	Modified by SurfaceS
    Originaly written by Weee for FPB
    Thanks 2 h0nda for help and lots of advices!

    v0.1:   This is really raw and dirty version of anim.lib but still it does everything I wanted for Breaking Bad Ward Scanner.
             - Animations FADING and PULSE
    v0.2:   Now this does everything I want for autoSmiteee xD
             - New animation FADINGVELOCITY. See example in autoSmiteee v1.0
             - Support for multiple animations per one DrawingSet. See example in autoSmiteee v1.0
    v0.2b:  Hotfix.
    v0.3:   isMultiply added + size support + font align support + few other changes.
	v0.3b:  Modified for BOL
	v0.3c:	Put back the Sprites
	
    Example of usage:
    
    Init:
    de = DrawingEngine()
    ds = DrawingSets()

    Adding drawingSets:
    ds:Add("playerMark",DrawingCircle(100,player),DrawingCircle(150,player))
    ds:Add("text1",DrawingText("TESTTEXTTESTTEXT",14,110,60,0,0,1,1),DrawingText("TESTTEXTTESTTEXT",14,100,40,0,1,0,1))

    Starting animations:
    ds:Get("playerMark"):RunAnimation(PULSE,RADIUS,1,0.5,1,1)
    ds:Get("text1"):RunAnimation(FADING,OPACITY,1,0,1,1) -- arguments: animation(PULSE,FADING,etc), value to change(OPACITY,RADIUS,RED,GREEN,BLUE, etc), from(0 to 1), to(0 to 1), speed (0.1 to ...), is repeatable (1,0)

    Stopping animations:
    ds:Get("playerMark"):StopAnimations()
    ds:Get("text1"):StopAnimations()

    Computing and drawing:
    de:ComputeAnimations(ds)    -- put this in timerCallback function
    de:Draw(ds)                 -- put this in drawCallback function
]]

FADING = "Fading"
PULSE = "Pulse"
FADINGVELOCITY = "FadingVelocity"

RED = "R"
GREEN = "G"
BLUE = "B"
OPACITY = "A"
SIZE = "size"
POSITIONX = {"position","x"}
POSITIONY = {"position","y"}
POSITIONZ = {"position","z"}
TEXT = "text"
RADIUS = "radius"

-- ===========================
-- Return the ARGB hex value from R,G,B,A.
-- added for BOL
-- ===========================
function getHexFromARGB(argb)
	if argb.A > 1 then argb.A = 1 elseif argb.A < 0 then argb.A = 0 end
	if argb.R > 1 then argb.R = 1 elseif argb.R < 0 then argb.R = 0 end
	if argb.G > 1 then argb.G = 1 elseif argb.G < 0 then argb.G = 0 end
	if argb.B > 1 then argb.B = 1 elseif argb.B < 0 then argb.B = 0 end
	-- NO BLUE UNTIL FIXED
	argb.B = 0
	return (math.floor(argb.B*255)+(math.floor(argb.G*255)*16^2)+(math.floor(argb.R*255)*16^4)+(math.floor(argb.A*255)*16^6))
end

-- ===========================
-- Copy the array portion of the table.
-- ===========================
function CopyArray(t)
    local ret = {}
    for i,v in pairs(t) do
        ret[i] = v
    end
    return ret
end

-- ======================================
-- Drawings:
-- ======================================

-- dc = DrawingCircle(radius,{x,y,z})
-- dc2 = DrawingCircle(radius,player)
function DrawingCircle(radius,position,R,G,B,A)
    local dc = {}
    dc.radius, dc.orig_radius = radius, radius
    dc.position, dc.orig_position = position, CopyArray(position)
	--add the color for BOL
	if R ~= nil and G ~= nil and B ~= nil and A ~= nil then
		dt.R = R
		dt.G = G
		dt.B = B
		dt.A = A
	else
		dt.R = 1
		dt.G = 1
		dt.B = 1
		dt.A = 1
	end
    return dc
end

-- dt = DrawingText("text",size,x,y,R,G,B,A)
function DrawingText(text,size,x,y,R,G,B,A,align)
    local dt = {}
    dt.text, dt.orig_text = text, text
    dt.size, dt.orig_size = size, size
    dt.position, dt.orig_position = {x=x,y=y}, {x=x,y=y}
    dt.R, dt.orig_R = R, R
    dt.G, dt.orig_G = G, G
    dt.B, dt.orig_B = B, B
    dt.A, dt.orig_A = A, A
    dt.align, dt.orig_align = align or FONT_LEFT, align or FONT_LEFT
    return dt
end

-- dsol = DrawingSpriteOverlay("path_from_srites_folder",x,y,alpha)    - alpha is optional
function DrawingSpriteOverlay(path,x,y,alpha)
    local dsol = {}
	dsol.sprite = createSprite(path)
    dsol.path, dsol.orig_path = path, path
    dsol.position, dsol.orig_position = {x=x,y=y}, {x=x,y=y}
    dsol.alpha, dsol_orig_alpha = alpha or 1, alpha or 1
    return dsol
end


-- ======================================
-- Animations:
-- ======================================

Fading = {
    New = function(self, from, to, speed, repeatable, isMultiply)
        local fading = {}
        fading.from = from
        fading.to = to
        fading.speed = speed
        fading.fadingRepeatable = repeatable or 1
        fading.isMultiply = isMultiply or false
        fading.phase = from
        setmetatable(fading, {__index = self})
        return fading
    end,
    
    ComputeStuff = function(self)
            if self.from > self.to then
                if self.isMultiply then
                    self.phase = self.phase - self.speed*0.001
                else
                    self.phase = self.phase - self.speed
                end
                if self.phase <= self.to then
                    if self.fadingRepeatable == 1 then self.phase = self.from else self.phase = nil end
                    return
                end
            else
                if self.isMultiply then
                    self.phase = self.phase + self.speed*0.001
                else
                    self.phase = self.phase + self.speed
                end
                if self.phase >= self.to then
                    if self.fadingRepeatable == 1 then self.phase = self.from else self.phase = nil end
                    return
                end
            end
    end,
}
setmetatable(Fading, {__call = Fading.New })

Pulse = {
    New = function(self, from, to, speed, repeatable, isMultiply)
        local pulse = Fading(from,to,speed,0,isMultiply)
        pulse.pulseRepeatable = repeatable or 1
        setmetatable(pulse, {__index = self})
        return pulse
    end,
    
    ComputeStuff = function(self)
            Fading.ComputeStuff(self)
            if self.phase == nil then
                if self.pulseRepeatable <= 0 then self.pulseRepeatable = self.pulseRepeatable - 1 end
                if self.pulseRepeatable == -2 then
                    return
                else
                    self.phase = self.to
                    self.from,self.to = self.to,self.from
                    --Fading.ComputeStuff(self)
                end
            end
    end,
}
setmetatable(Pulse, {__call = Pulse.New })

FadingVelocity = {
    New = function(self, from, to, speed, repeatable, velocity, isMultiply)
        fadingVelocity = Fading(from,to,speed,repeatable,isMultiply)
        fadingVelocity.velocity = velocity
        fadingVelocity.orig_speed = speed
        fadingVelocity.repeatable = repeatable
        setmetatable(fadingVelocity, {__index = self})
        return fadingVelocity
    end,

    ComputeStuff = function(self)
        self.speed = self.speed * self.velocity
        Fading.ComputeStuff(self)
        if self.repeatable == 1 and self.phase == self.from then
            self.speed = self.orig_speed
        end
    end,
}
setmetatable(FadingVelocity, {__call = FadingVelocity.New })

-- ======================================
-- Engine:
-- ======================================

DrawingSets = {
    -- ds = DrawingSets()
    New = function(self)
        local ds = {}
        setmetatable(ds, {__index = self})
        return ds
    end,

    -- add only one type of drawings per key!
    -- Correct usage:
    -- ds:Add("circles",dc,dc2,dc3,...)  [circles] contains only DrawingCircle
    -- ds:Add("texts",dt,dt2,dt3,...)  [texts] contains only DrawingText
    -- Wrong usage:
    -- ds:Add("dafuq",dc,dc2,dt3,dt4,...)  [dafuq] contains DrawingCircles + DrawingTexts. Script will draw [dafuq], but animations will be fuq'd up.
    Add = function(self, drawingID, drawingObject, ...)
        if self[drawingID] == nil then self[drawingID] = {drawingID = drawingID, animation = nil, objects = {}} end
        table.insert(self[drawingID].objects, drawingObject)
        if #arg < 1 then return end
        for i,v in ipairs(arg) do
            table.insert(self[drawingID].objects, v)
        end
    end,
    
    Remove = function(self, drawingID)
        if self.sprite ~= nil then
			self.sprite.Release()
		end
		self[drawingID] = nil
    end,

    Get = function(self, drawingID)
        local get = {}
        get = self[drawingID]
        setmetatable(get, {__index = self})
        return get
    end,

    RunAnimation = function(self, animationName, animationType, changingValue, ...)
        if self.animation and self.animation[animationName] then self:StopAnimation(animationName) end
        if self.animation == nil then self.animation = {} end
        self.animation[animationName] = _G[animationType](...)
        self.animation[animationName].animationName = animationName
        self.animation[animationName].animationType = animationType
        self.animation[animationName].changingValue = changingValue
    end,
    
    StopAnimation = function(self, animationName)
        self.animation[animationName] = nil
    end,

    StopAnimations = function(self)
        self.animation = nil
        for i,obj in pairs(self.objects) do
            if obj.radius then
                obj.radius = obj.orig_radius
                obj.position.x = obj.orig_position.x
                obj.position.y = obj.orig_position.y
                obj.position.z = obj.orig_position.z
            else
                obj.text = obj.orig_text
                obj.size = obj.orig_size
                obj.position.x = obj.orig_position.x
                obj.position.y = obj.orig_position.y
                obj.R = obj.orig_R
                obj.G = obj.orig_G
                obj.B = obj.orig_B
                obj.A = obj.orig_A
                obj.align = obj.orig_align
            end
        end
    end,
}
setmetatable(DrawingSets, {__call = DrawingSets.New })

DrawingEngine = {
    -- de = DrawingEngine()
    New = function(self)
        local de = {}
        setmetatable(de, {__index = self})
        return de
    end,

    ComputeAnimations = function(self, DrawingSets)
        for k,drawingSet in pairs(DrawingSets) do
            if drawingSet.animation then
                for l,anim in pairs(drawingSet.animation) do
                    local changingValue = anim.changingValue
                    anim:ComputeStuff()
                    if anim.phase then
                        for i,obj in pairs(drawingSet.objects) do
                            if type(changingValue) == "table" then
                                if anim.isMultiply then
                                    obj[changingValue[1]][changingValue[2]] = obj["orig_"..changingValue[1]][changingValue[2]] * anim.phase
                                else
                                    obj[changingValue[1]][changingValue[2]] = anim.phase
                                end
                            else
                                if anim.isMultiply then
                                    obj[changingValue] = obj["orig_"..changingValue] * anim.phase
                                else
                                    obj[changingValue] = anim.phase
                                end
                            end
                        end
                    else
                        drawingSet:StopAnimation(anim.animationName)
                    end
                end
            end
        end
    end,

    -- de:Draw(DrawingSets)
    Draw = function(self, DrawingSets)
        for k,drawingSet in pairs(DrawingSets) do
            for i,obj in pairs(drawingSet.objects) do
                if obj.radius ~= nil then
                    if obj.position.x ~= nil then
                        --old : DrawCircle(obj.radius,obj.position.x,obj.position.y,obj.position.z)
						--add color
						DrawCircle(obj.position.x,obj.position.y,obj.position.z,obj.radius,getHexFromARGB(obj))
                    end
                    --print("Set: "..drawingSet.drawingID.." | DrawCircle | Radius: "..obj.radius.." | X: "..obj.position.x.." | Y: "..obj.position.y.." | Z: "..obj.position.z)

				elseif obj.sprite ~= nil then
                    if obj.position.x ~= nil then
                        obj.sprite:Draw(obj.position.x, obj.position.y, obj.alpha * 255)
						--sprite:DrawOverlay(obj.path,obj.position.x,obj.position.y,obj.scale)
                    end
                else
					--DrawText(obj.text,obj.size,obj.position.x,obj.position.y,obj.R,obj.G,obj.B,obj.A,obj.align)
					-- CHANGED FOR BOL
					-- DrawText(text,size,x,y,ARGB) --Draw Text over Screen
					DrawText(obj.text,obj.size,obj.position.x,obj.position.y,getHexFromARGB(obj))
                    --print("Set: "..drawingSet.drawingID.." | DrawText | Text: "..obj.text.." | X: "..obj.position.x.." | Y: "..obj.position.y.." | R: "..obj.R.." G: "..obj.G.." B: "..obj.B.." A: "..obj.A)
                end
            end
        end
    end,
}
setmetatable(DrawingEngine, {__call = DrawingEngine.New })

--UPDATEURL=
--HASH=9FDFE55022F6B6267BFA7924BDE009CB
