class "sScriptConfig"

function sScriptConfig:__init(name, theme)
    UpdateWindow()
    self.name   = name
    self.theme  = theme
    self.state  = nil
    self.states = {}
    self.substates = {}
    self.par    = {}
    self.resize = false
    self.move   = false
    self.pos    = {x = 0, z = 50}
    self.touch  = {x = 0, z = 0}
    self.Scale  = {x = 0.65*1920/WINDOW_W, z = 0.65*1080/WINDOW_H}
    self.keyChange = nil
    self.lastMove = 0
    self.LastIncrRequest = 0
    self.slide  = {false, false, false, false}
    self.loaded = false
    AddUnloadCallback(function() self:Unload_Sprites() end)
    AddDrawCallback(function() self:Draw() end)
    AddMsgCallback(function(Msg, Key) self:Msg(Msg, Key) end)
    AddTickCallback(function() self:Tick() end)
    return self
end

local function remove(name)
    if not GetSave("sScriptConfig")[name] then GetSave("sScriptConfig")[name] = {} end
    table.clear(GetSave("sScriptConfig")[name])
end

local function load(name)
    if not GetSave("sScriptConfig")[name] then GetSave("sScriptConfig")[name] = {} end
    return GetSave("sScriptConfig")[name]
end

local function save(name, content)
    if not GetSave("sScriptConfig")[name] then GetSave("sScriptConfig")[name] = {} end
    table.clear(GetSave("sScriptConfig")[name])
    table.merge(GetSave("sScriptConfig")[name], content, true)
end

function sScriptConfig:load()
    local function sensitiveMerge(base, t)
        for i, v in pairs(t) do
            if type(base[i]) == type(v) then
                if type(v) == "table" then sensitiveMerge(base[i], v)
                else base[i] = v
                end
            end
        end
    end
    local config = load(self.name)
    for var, value in pairs(config) do
        for _,par in pairs(self.par) do
            if par.name == value.name and par.state == value.state then
                if value.code == SCRIPT_PARAM_ONKEYDOWN or value.code == SCRIPT_PARAM_ONKEYTOGGLE then par.key = value.key end
                if value.code == SCRIPT_PARAM_ONOFF or value.code == SCRIPT_PARAM_LIST then par.value = value.value end
                if value.code == SCRIPT_PARAM_SLICE then par.slider = value.slider end
            end
        end
    end
end

function sScriptConfig:save()
    local content = {}
    content = {}
    for var, param in pairs(self.par) do
        table.insert(content, param)
    end
    save(self.name, content)
end

function sScriptConfig:addParam(par)
    table.insert(self.par, par)
end

function sScriptConfig:getParam(state, param1, param2)
    for _,par in pairs(self.par) do
        if par.name == param1 and par.state == state then
            if par.code == SCRIPT_PARAM_SLICE and param2 then
                for k=1,#par.slider do
                    if par.text[k] == param2 then
                        return par.slider[k]
                    end
                end
            elseif par.code == SCRIPT_PARAM_ONKEYDOWN then
                return IsKeyDown(par.key)  
            else
                return par.value
            end
        end
    end
end

function sScriptConfig:setParam(state, value, param1, param2)
    for _,par in pairs(self.par) do
        if par.name == param1 and par.state == state then
            if par.code == SCRIPT_PARAM_SLICE and param2 then
                for k=1,#par.slider do
                    if par.text[k] == param2 then
                        par.slider[k] = value
                    end
                end
            elseif par.code == SCRIPT_PARAM_LIST then
                if par.value == #par.list then
                    par.value = 1
                else
                    par.value = value
                end
            else
                par.value = value
            end
        end
    end
end

function sScriptConfig:incParamBy1(state, param1, param2)
    if not self:ValidIncrRequest() then return end
    for _,par in pairs(self.par) do
        if par.name == param1 and par.state == state then
            if par.code == SCRIPT_PARAM_SLICE and param2 then
                for k=1,#par.slider do
                    if par.text[k] == param2 then
                        par.slider[k] = par.slider[k] + 1
                    end
                end
            elseif par.code == SCRIPT_PARAM_LIST then
                if par.value == #par.list then
                    par.value = 1
                else
                    par.value = par.value + 1
                end
            else
                par.value = par.value + 1
            end
        end
    end
end

function sScriptConfig:ValidIncrRequest()
    if GetInGameTimer() - self.LastIncrRequest < 0.5 then
        return false
    else
        self.LastIncrRequest = GetInGameTimer()
        return true
    end
end

function sScriptConfig:addState(state)
    table.insert(self.states, state)
    if self.state == nil then self.state = state end
end

function sScriptConfig:addSubStates(state, sub)
    self.substates[state] = sub
    if self.state == nil or self.state == state then self.state = sub[1] end
end

function sScriptConfig:Unload_Sprites()
    for _,k in pairs(self.Sprites) do
        k:Release()
    end
end

function sScriptConfig:Load_Sprites()
    self.hadToDownload  = false
    self.Sprites        = {}
    self.SpriteTable    = {
        "top",
        "mid",
        "drag",
        "drag_selected",
        "code1",
        "code1_selected",
        "code2",
        "code4",
        "SLIDER_1",
        "SLIDER_2",
        "SLIDER_3",
        "SLIDER_4",
        "code3",
        "code7",
        "state",
        "state_selected", 
        "state_bottom",
        "state_bottom_selected", 
        "bot",
        "Words\\Button\\Change"
    }
    self.dontDownload    = {"chibi\\"..GetUser():lower(),
                            "Scripts\\"..self.name,
                            "Scripts\\"..self.name.." Logo",
                            "Scripts\\"..self.theme.." Logo"}
    self.buttonTable     = { "1","2","3","4","5","6","7","8","9","0","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","Space","Ctrl" }
    self.numTable        = { "1","2","3","4","5","6","7","8","9","0","%" }
    for _, sprite in pairs(self.SpriteTable) do
        location = "sScriptConfig\\"..self.theme.."\\" .. sprite .. ".png"
        if FileExist(SPRITE_PATH .. location) then
            self.Sprites[sprite] = createSprite(location)
        else
            DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Sprites/"..location.."?rand="..math.random(1,10000), SPRITE_PATH..location, function () print("Downloading sprites please wait... "..location) end)
            self.hadToDownload = true
        end
    end
    for _, sprite in pairs(self.dontDownload) do
        location = "sScriptConfig\\"..self.theme.."\\" .. sprite .. ".png"
        if FileExist(SPRITE_PATH .. location) then
            self.Sprites[sprite] = createSprite(location)
        end
    end
    for _, sprite in pairs(self.numTable) do
        location = "sScriptConfig\\"..self.theme.."\\Num\\" .. sprite .. ".png"
        if FileExist(SPRITE_PATH .. location) then
            self.Sprites[sprite] = createSprite(location)
        else
            DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Sprites/"..location.."?rand="..math.random(1,10000), SPRITE_PATH..location, function () print("Downloading sprites please wait... "..location) end)
            self.hadToDownload = true
        end
    end
    for _, sprite in pairs(self.buttonTable) do
        location = "sScriptConfig\\"..self.theme.."\\Words\\Button\\" .. sprite .. ".png"
        if sprite == "Space" then sprite = 32
        elseif sprite == "Alt" then sprite = 18
        elseif sprite == "Ctrl" then sprite = 17
        else sprite = string.byte(sprite) end
        if FileExist(SPRITE_PATH .. location) then
            self.Sprites[sprite] = createSprite(location)
        else
            DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Sprites/"..location.."?rand="..math.random(1,10000), SPRITE_PATH..location, function () print("Downloading sprites please wait... "..location) end)
            self.hadToDownload = true
        end
    end
    for _, sprite in pairs(self.states) do
        if not self.substates[sprite] then
            location = "sScriptConfig\\"..self.theme.."\\Words\\" .. sprite .. ".png"
            if FileExist(SPRITE_PATH .. location) then
                self.Sprites[sprite] = createSprite(location)
            else
                DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Sprites/"..location.."?rand="..math.random(1,10000), SPRITE_PATH..location, function () print("Downloading sprites please wait... "..location) end)
                self.hadToDownload = true
            end
            location = "sScriptConfig\\"..self.theme.."\\Words\\" .. sprite .. "_selected.png"
            if FileExist(SPRITE_PATH .. location) then
                self.Sprites[sprite.."_selected"] = createSprite(location)
            else
                DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Sprites/"..location.."?rand="..math.random(1,10000), SPRITE_PATH..location, function () print("Downloading sprites please wait... "..location) end)
                self.hadToDownload = true
            end
        elseif self.substates[sprite] then
            for v,k in pairs(self.substates[sprite]) do
                location = "sScriptConfig\\"..self.theme.."\\Words\\" .. k .. ".png"
                if FileExist(SPRITE_PATH .. location) then
                    self.Sprites[k] = createSprite(location)
                else
                    DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Sprites/"..location.."?rand="..math.random(1,10000), SPRITE_PATH..location, function () print("Downloading sprites please wait... "..location) end)
                    self.hadToDownload = true
                end
                location = "sScriptConfig\\"..self.theme.."\\Words\\" .. k .. "_selected.png"
                if FileExist(SPRITE_PATH .. location) then
                    self.Sprites[k.."_selected"] = createSprite(location)
                else
                    DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Sprites/"..location.."?rand="..math.random(1,10000), SPRITE_PATH..location, function () print("Downloading sprites please wait... "..location) end)
                    self.hadToDownload = true
                end
            end
        end
    end
    for _, par in pairs(self.par) do
        sprite=par.name
        location = "sScriptConfig\\"..self.theme.."\\Words\\" .. sprite .. ".png"
        if FileExist(SPRITE_PATH .. location) then
            self.Sprites[sprite] = createSprite(location)
        else
            DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Sprites/"..location.."?rand="..math.random(1,10000), SPRITE_PATH..location, function () print("Downloading sprites please wait... "..location) end)
            self.hadToDownload = true
        end
        location = "sScriptConfig\\"..self.theme.."\\Words\\" .. sprite .. "_selected.png"
        if FileExist(SPRITE_PATH .. location) then
            self.Sprites[sprite.."_selected"] = createSprite(location)
        else
            DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Sprites/"..location.."?rand="..math.random(1,10000), SPRITE_PATH..location, function () print("Downloading sprites please wait... "..location) end)
            self.hadToDownload = true
        end
        if par.code == SCRIPT_PARAM_LIST then
            for _,k in pairs(par.list) do
                location = "sScriptConfig\\"..self.theme.."\\Words\\" .. k .. ".png"
                if FileExist(SPRITE_PATH .. location) then
                    self.Sprites[k] = createSprite(location)
                else
                    DownloadFile("https://raw.github.com/nebelwolfi/BoL/master/Sprites/"..location.."?rand="..math.random(1,10000), SPRITE_PATH..location, function () print("Downloading sprites please wait... "..location) end)
                    self.hadToDownload = true
                end
            end
        end
    end
    if not self.hadToDownload then
        while #self.states < 6 do
            self:addState("blank")
        end
        self.offsets = {top = self.Sprites["top"].height, button = self.Sprites["state"].height, bot = self.Sprites["drag"].height*2, width = self.Sprites["top"].width, buttonwidth = self.Sprites["state"].width}
    else
        self:Unload_Sprites()
        DelayAction(function() print("Reloading menu... Please wait!") self.loaded = false end, 5)
    end
end

function sScriptConfig:Draw()
    if (self.keyChange or IsKeyDown(16)) and self.loaded then
        self.Sprites["top"]:SetScale(self.Scale.x,self.Scale.z)
        self.Sprites["top"]:Draw(self.pos.x, self.pos.z+WINDOW_H/4, 255)
        if self.Sprites["Scripts\\"..self.name.." Logo"] then
            self.Sprites["Scripts\\"..self.name.." Logo"]:SetScale(self.Scale.x,self.Scale.z)
            self.Sprites["Scripts\\"..self.name.." Logo"]:Draw(self.pos.x+self.Scale.z*(self.offsets.buttonwidth/2-self.Sprites["Scripts\\"..self.name.." Logo"].width/2), self.pos.z+WINDOW_H/4+self.Scale.z*(self.Sprites["top"].height/2-self.Sprites["Scripts\\"..self.name.." Logo"].height/2), 255)
        elseif self.Sprites["Scripts\\"..self.theme.." Logo"] then
            self.Sprites["Scripts\\"..self.theme.." Logo"]:SetScale(self.Scale.x,self.Scale.z)
            self.Sprites["Scripts\\"..self.theme.." Logo"]:Draw(self.pos.x+self.Scale.z*(self.offsets.buttonwidth/2-self.Sprites["Scripts\\"..self.theme.." Logo"].width/2), self.pos.z+WINDOW_H/4+self.Scale.z*(self.Sprites["top"].height/2-self.Sprites["Scripts\\"..self.theme.." Logo"].height/2), 255)
        end
        self.Sprites["Scripts\\"..self.name]:SetScale(self.Scale.x,self.Scale.z)
        self.Sprites["Scripts\\"..self.name]:Draw(self.pos.x+self.Scale.z*((self.offsets.buttonwidth+self.Sprites["top"].width)/2-self.Sprites["Scripts\\"..self.name].width/2), self.pos.z+WINDOW_H/4+self.Scale.z*(self.Sprites["top"].height/2-self.Sprites["Scripts\\"..self.name].height/2), 255)
        for _,par in pairs(self.states) do
            if not self.substates[par] then
                if self.state ~= par and self.Sprites[par] or self.state == par and self.Sprites[par.."_selected"] then
                    if self.state == par then
                        self.Sprites["state_selected"]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites["state_selected"]:Draw(self.pos.x, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-1)), 255)
                        self.Sprites[par.."_selected"]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites[par.."_selected"]:Draw(self.pos.x+self.Scale.x*20, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-0.5))-self.Scale.z*self.Sprites[par.."_selected"].height/2, 255)
                    else
                        self.Sprites["state"]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites["state"]:Draw(self.pos.x, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-1)), 255)
                        self.Sprites[par]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites[par]:Draw(self.pos.x+self.Scale.x*20, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-0.5)-self.Sprites[par].height/2), 255)
                    end
                else
                    self.Sprites["state"]:SetScale(self.Scale.x,self.Scale.z)
                    self.Sprites["state"]:Draw(self.pos.x, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-1)), 255)
                end
            else
                for v,k in pairs(self.substates[par]) do
                    if self.state ~= k and self.Sprites[k] or self.state == k and self.Sprites[k.."_selected"] then
                        if self.state == k then
                            self.Sprites["state_selected"]:SetScale(self.Scale.x,self.Scale.z)
                            self.Sprites["state_selected"]:Draw(self.pos.x, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-1)+self.offsets.button/2*(v-1)), 255)
                            self.Sprites[k.."_selected"]:SetScale(self.Scale.x*3/4,self.Scale.z*3/4)
                            self.Sprites[k.."_selected"]:Draw(self.pos.x+self.Scale.x*20, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-0.5)-self.offsets.button/2+self.offsets.button/2*(v-1)+self.Sprites[k.."_selected"].height/2-self.Sprites[k].height/4), 255)
                        else
                            self.Sprites["state"]:SetScale(self.Scale.x,self.Scale.z)
                            self.Sprites["state"]:Draw(self.pos.x, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-1)+self.offsets.button/2*(v-1)), 255)
                            self.Sprites[k]:SetScale(self.Scale.x*3/4,self.Scale.z*3/4)
                            self.Sprites[k]:Draw(self.pos.x+self.Scale.x*20, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-0.5)-self.offsets.button/2+self.offsets.button/2*(v-1)+self.Sprites[k].height/2-self.Sprites[k].height/4), 255)
                        end
                    else
                        self.Sprites["state"]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites["state"]:Draw(self.pos.x, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-1)+self.offsets.button/2*(v-1)), 255)
                    end
                end
            end
        end
        self.Sprites["mid"]:SetScale(self.Scale.x,self.Scale.z)
        self.Sprites["mid"]:Draw(self.pos.x+self.Scale.x*self.offsets.buttonwidth, self.pos.z+WINDOW_H/4+self.Scale.z*self.offsets.top, 255)
        if self.Sprites["chibi\\"..GetUser():lower()] then
            self.Sprites["chibi\\"..GetUser():lower()]:SetScale(self.Scale.x*0.75,self.Scale.z*0.75)
            self.Sprites["chibi\\"..GetUser():lower()]:Draw(self.pos.x+self.Scale.x*self.offsets.width-self.Scale.x*(self.Sprites["chibi\\"..GetUser():lower()].width-75), self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*#self.states)-self.Scale.z*(self.Sprites["chibi\\"..GetUser():lower()].height-120), 175)
        end
        local a = 0
        local c = 0
        local y = 0
        for _,par in pairs(self.par) do
            if par.state == self.state and self.Sprites["code"..par.code] and ((par.code == SCRIPT_PARAM_ONKEYDOWN or par.code == SCRIPT_PARAM_ONKEYTOGGLE) and self.Sprites[string.char(par.key)] or (par.code == SCRIPT_PARAM_SLICE and self.Sprites["code"..par.code] or self.Sprites[par.name])) then
                if c == 4 then c = 0 y = y + 1 end
                bxPos = self.pos.x+self.Scale.x*(self.Sprites["code"..par.code].width*(c)+40+c*45+self.offsets.buttonwidth)
                byPos = self.pos.z+WINDOW_H/4+self.Scale.z*((40+self.Sprites["code"..par.code].height)*(y)+20+self.offsets.top)
                if par.code == SCRIPT_PARAM_ONOFF then
                    if par.value then
                        self.Sprites["code"..par.code.."_selected"]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites["code"..par.code.."_selected"]:Draw(bxPos,byPos, 255)
                        self.Sprites[par.name.."_selected"]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites[par.name.."_selected"]:Draw(bxPos+self.Scale.x*(self.Sprites["code"..par.code].width/2-self.Sprites[par.name].width/2),byPos+self.Scale.z*(self.Sprites["code"..par.code].height/2-self.Sprites[par.name].height/2), 255)
                    else
                        self.Sprites["code"..par.code]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites["code"..par.code]:Draw(bxPos,byPos, 255)
                        self.Sprites[par.name]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites[par.name]:Draw(bxPos+self.Scale.x*(self.Sprites["code"..par.code].width/2-self.Sprites[par.name].width/2),byPos+self.Scale.z*(self.Sprites["code"..par.code].height/2-self.Sprites[par.name].height/2), 255)
                    end
                elseif par.code == SCRIPT_PARAM_ONKEYDOWN or par.code == SCRIPT_PARAM_ONKEYTOGGLE then
                    a = a + 1
                    local b = 0
                    local ppos = par.name
                    local kpos = par.key
                    for _,k in pairs(self.par) do
                        if par.state == k.state and (k.code == SCRIPT_PARAM_ONKEYDOWN or k.code == SCRIPT_PARAM_ONKEYTOGGLE) then
                            ppos = k.name 
                            kpos = k.key
                            b = b + 1
                        end
                    end
                    xOffset = b > 1 and self.Scale.x*(0-a*self.Sprites["mid"].width/(2*b)+(b+0.75)*self.Sprites["mid"].width/(4*b)) or 0
                    self.Sprites[par.name]:SetScale(self.Scale.x*0.75,self.Scale.z*0.75)
                    self.Sprites[par.name]:Draw(self.pos.x+xOffset+self.Scale.x*(self.offsets.buttonwidth+self.Sprites["mid"].width/2-self.Sprites[ppos].width/2+15),self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*#self.states)-self.Scale.z*self.Sprites[kpos].height/2, 255)
                    if self.keyChange then 
                        self.Sprites["Words\\Button\\Change"]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites["Words\\Button\\Change"]:Draw(self.pos.x+xOffset+self.Scale.x*(self.offsets.buttonwidth+self.Sprites["mid"].width/2-self.Sprites["Words\\Button\\Change"].width/2-1),self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*#self.states-self.Sprites["Words\\Button\\Change"].height/2-self.Sprites[ppos].height*2-20), 255)      
                    else
                        self.Sprites[par.key]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites[par.key]:Draw(self.pos.x+xOffset+self.Scale.x*(self.offsets.buttonwidth+self.Sprites["mid"].width/2-self.Sprites[kpos].width/2-1),self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*#self.states-self.Sprites[kpos].height/2-self.Sprites[ppos].height*2-20), 255)   
                    end
                elseif par.code == SCRIPT_PARAM_SLICE then --{0,30,100,5}
                    if c > 0 then y = y + 1 c = 0 end
                    if y == 0 then y = 0.2+0.05*#par.slider end
                    self.Sprites[par.name]:SetScale(self.Scale.x*1.25,self.Scale.z*1.25)
                    self.Sprites[par.name]:Draw(self.pos.x+self.Scale.x*(self.offsets.buttonwidth+self.Sprites["mid"].width/2-self.Sprites["code"..par.code].width/2-self.Sprites["code"..par.code].width/2),self.pos.z+WINDOW_H/4+self.Scale.z*(35+self.offsets.top+self.offsets.button*(#self.states-3)*y-10), 255)
                    self.Sprites["code"..par.code]:SetScale(self.Scale.x*1.25,self.Scale.z*1.25)
                    self.Sprites["code"..par.code]:Draw(self.pos.x+self.Scale.x*(self.offsets.buttonwidth+self.Sprites["mid"].width/2-self.Sprites["code"..par.code].width/2-1),self.pos.z+WINDOW_H/4+self.Scale.z*(35+self.offsets.top+self.offsets.button*(#self.states-3)*y), 255) 
                    for k=#par.slider,1,-1 do
                        self.Sprites["SLIDER_"..k]:SetScale(self.Scale.x,self.Scale.z)
                        self.Sprites["SLIDER_"..k]:Draw(self.pos.x+self.Scale.x*((self.Sprites["code"..par.code].width+70)*par.slider[k]/100+k*2+self.offsets.buttonwidth-self.Sprites["SLIDER_"..k].width/2+self.Sprites["mid"].width/2-self.Sprites["code"..par.code].width/2),self.pos.z+WINDOW_H/4+self.Scale.z*(30+self.offsets.top-self.Sprites["SLIDER_"..k].height+self.offsets.button*(#self.states-3)*y), 255)          
                        self.Sprites[par.text[k]]:SetScale(self.Scale.x*0.37,self.Scale.z*0.37)
                        self.Sprites[par.text[k]]:Draw(self.pos.x+self.Scale.x*((self.Sprites["code"..par.code].width+70)*par.slider[k]/100+k*2+self.offsets.buttonwidth-self.Sprites[par.text[k]].width/2*0.37+self.Sprites["mid"].width/2-self.Sprites["code"..par.code].width/2),self.pos.z+WINDOW_H/4+self.Scale.z*(35+self.offsets.top-self.Sprites["SLIDER_"..k].height+self.offsets.button*(#self.states-3)*y), 255)            
                        if self.slide[k] then
                            nxPos = self.pos.x+self.Scale.x*(self.offsets.buttonwidth+self.Sprites["mid"].width/2+self.Sprites["code"..par.code].width/2+self.Sprites["code"..par.code].width/4+15)
                            nzPos = self.pos.z+WINDOW_H/4+self.Scale.z*(35+self.offsets.top+self.offsets.button*(#self.states-3)*y-10)
                            if par.slider[k] > 99 then
                                self.Sprites["1"]:SetScale(self.Scale.x*0.37,self.Scale.z*0.37)
                                self.Sprites["1"]:Draw(nxPos,nzPos, 255)  
                                self.Sprites["0"]:SetScale(self.Scale.x*0.37,self.Scale.z*0.37)
                                self.Sprites["0"]:Draw(nxPos+self.Scale.x*self.Sprites["0"].width/2,nzPos, 255)         
                                self.Sprites["0"]:SetScale(self.Scale.x*0.37,self.Scale.z*0.37)
                                self.Sprites["0"]:Draw(nxPos+self.Scale.x*self.Sprites["0"].width/2+self.Scale.x*self.Sprites["0"].width/2,nzPos, 255)  
                                self.Sprites["%"]:SetScale(self.Scale.x*0.37,self.Scale.z*0.37)
                                self.Sprites["%"]:Draw(nxPos+self.Scale.x*self.Sprites["0"].width/2+self.Scale.x*self.Sprites["0"].width/2+self.Scale.x*self.Sprites["%"].width/4+self.Scale.x*4,nzPos, 255)  
                            elseif par.slider[k] > 9 then
                                self.Sprites[""..math.floor(par.slider[k]/10)]:SetScale(self.Scale.x*0.37,self.Scale.z*0.37)
                                self.Sprites[""..math.floor(par.slider[k]/10)]:Draw(nxPos,nzPos, 255)  
                                self.Sprites[""..math.floor(par.slider[k]-math.floor(par.slider[k]/10)*10)]:SetScale(self.Scale.x*0.37,self.Scale.z*0.37)
                                self.Sprites[""..math.floor(par.slider[k]-math.floor(par.slider[k]/10)*10)]:Draw(nxPos+self.Scale.x*self.Sprites["0"].width/2,nzPos, 255)         
                                self.Sprites["%"]:SetScale(self.Scale.x*0.37,self.Scale.z*0.37)
                                self.Sprites["%"]:Draw(nxPos+self.Scale.x*self.Sprites["0"].width/2+self.Scale.x*self.Sprites["%"].width/4+self.Scale.x*4,nzPos, 255)          
                            else
                                self.Sprites[""..math.floor(par.slider[k])]:SetScale(self.Scale.x*0.37,self.Scale.z*0.37)
                                self.Sprites[""..math.floor(par.slider[k])]:Draw(nxPos+self.Scale.x*self.Sprites["0"].width/2,nzPos, 255)         
                                self.Sprites["%"]:SetScale(self.Scale.x*0.37,self.Scale.z*0.37)
                                self.Sprites["%"]:Draw(nxPos+self.Scale.x*self.Sprites["0"].width/2+self.Scale.x*self.Sprites["%"].width/4+self.Scale.x*4,nzPos, 255)         
                            end
                        end
                    end
                elseif par.code == SCRIPT_PARAM_LIST then
                    if not self.Sprites[par.list[par.value]] then par.value = 1 end
                    if c > 0 then
                        bxPos = self.pos.x+self.Scale.x*(40+self.offsets.buttonwidth)
                        y = y + 1
                        byPos = self.pos.z+WINDOW_H/4+self.Scale.z*((80+45+self.Sprites[par.name].height)*(y+0.5)+self.offsets.top)
                    else
                        byPos = self.pos.z+WINDOW_H/4+self.Scale.z*((80+45+self.Sprites[par.name].height)*(y+0.5)+self.offsets.top)
                    end
                    self.Sprites[par.name]:SetScale(self.Scale.x,self.Scale.z)
                    self.Sprites[par.name]:Draw(bxPos,byPos,255)
                    bxPos = self.pos.x+self.Scale.x*(self.Sprites["mid"].width/2+self.Sprites[par.name].width/2-self.Sprites[par.list[par.value]].width/2+40+self.offsets.buttonwidth)
                    byPos = self.pos.z+WINDOW_H/4+self.Scale.z*((80+45+self.Sprites[par.name].height)*(y+0.5)+self.offsets.top)
                    self.Sprites[par.list[par.value]]:SetScale(self.Scale.x*0.5,self.Scale.z*0.5)
                    self.Sprites[par.list[par.value]]:Draw(bxPos,byPos, 255) 
                elseif par.code == SCRIPT_PARAM_INFO then
                end
                c = c+1
            end
        end
        if self.resize then
            self.Sprites["drag_selected"]:SetScale(self.Scale.x,self.Scale.z) --self.Sprites[par.."_selected"].height
            self.Sprites["drag_selected"]:Draw(self.pos.x+self.Scale.x*self.offsets.width-self.Scale.x*self.offsets.bot/2, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*#self.states)-self.Scale.z*self.offsets.bot/2, 255)
        else
            self.Sprites["drag"]:SetScale(self.Scale.x,self.Scale.z)
            self.Sprites["drag"]:Draw(self.pos.x+self.Scale.x*self.offsets.width-self.Scale.x*self.offsets.bot/2-1, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*#self.states)-self.Scale.z*self.offsets.bot/2-1, 255)
        end
    end
end

function sScriptConfig:Tick()
    if not self.loaded then
        self.loaded = true
        self:load() 
        self:Load_Sprites()
    end
    local cursor = GetCursorPos()
    if self.resize then
        if self.Scale.x > 0.2 and cursor.x+15 < self.pos.x+self.Scale.x*self.offsets.width-self.Scale.x*self.offsets.bot/2 and cursor.y < self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*#self.states+self.offsets.bot)-self.Scale.z*self.offsets.bot/2 then
            self.Scale = {x = self.Scale.x-0.05, z = self.Scale.z-0.05}
        elseif self.Scale.x < 1 and cursor.x-15 > self.pos.x+self.Scale.x*self.offsets.width and cursor.y > self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*#self.states+self.offsets.bot) then
            self.Scale = {x = self.Scale.x+0.05, z = self.Scale.z+0.05}
        end
    end
    if self.move then
        self.pos = {x = cursor.x-self.touch.x, z = cursor.y-self.touch.z}
        self.pos = {x = self.pos.x < 0 and 0 or (self.pos.x+self.Scale.x*self.offsets.width > WINDOW_W and WINDOW_W-self.Scale.x*self.offsets.width or self.pos.x), z = self.pos.z < -WINDOW_H/4 and -WINDOW_H/4 or self.pos.z}
    end
    for _,par in pairs(self.par) do
        if par.state == self.state and par.code == SCRIPT_PARAM_SLICE then
            for k=1,#par.slider do
                if self.slide[k] then
                    local val = self.touch.z+(cursor.x-self.touch.x)/self.Scale.x/self.Sprites["code"..SCRIPT_PARAM_SLICE].width*100--((cursor.x-self.touch.x)*par.slider[k]/100-self.Sprites["SLICE"].width/100)
                    val = val < 0 and 0 or (val > 100 and 100 or val)
                    par.slider[k] = val
                end
            end
        end
    end
end

function sScriptConfig:Msg(Msg, Key)
    if not self.loaded or self.hadToDownload then return end
    local cursor = GetCursorPos()
    if Msg == KEY_DOWN and Key > 16 and self.keyChange then
        for _,par in pairs(self.par) do
            if par.state == self.state and self.keyChange == par and (par.code == SCRIPT_PARAM_ONKEYDOWN or par.code == SCRIPT_PARAM_ONKEYTOGGLE) and self.Sprites[Key] then
                par.key = Key
                self.keyChange = nil
                self:save()
            end
        end
    end
    if Msg == KEY_DOWN and Key > 16 then 
        for _,par in pairs(self.par) do
            if par.code == SCRIPT_PARAM_ONKEYTOGGLE and par.key == Key then
                par.value = not par.value
                if par.value then
                    PrintAlertRed(par.state.." "..par.name.." is now on!")
                else
                    PrintAlertRed(par.state.." "..par.name.." is now off!")
                end
            end
        end
    end
    if Msg == KEY_UP and Key == 16 then
        self:save()
    end
    if Msg == WM_LBUTTONDOWN and (self.keyChange or IsKeyDown(16)) then
        if CursorIsUnder(self.pos.x+self.Scale.x*self.offsets.width-self.Scale.x*self.offsets.bot/2, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*#self.states)-self.Scale.z*self.offsets.bot/2, self.Scale.x*self.offsets.width-self.Scale.x*self.offsets.bot/2, self.Scale.z*self.offsets.bot/2) then
            self.resize = true
        end
        if CursorIsUnder(self.pos.x, self.pos.z+WINDOW_H/4, self.Scale.x*self.offsets.width, self.Scale.z*self.offsets.top) then
            self.touch = {x = cursor.x-self.pos.x, z = cursor.y-self.pos.z}
            self.move = true
        end
        local a = 0
        local c = 0
        local y = 0
        for _,par in pairs(self.par) do
            if par.state == self.state and self.Sprites["code"..par.code] then
                if c == 4 then c = 0 y = y + 1 end
                bxPos = self.pos.x+self.Scale.x*(self.Sprites["code"..par.code].width*(c)+40+c*45+self.offsets.buttonwidth)
                byPos = self.pos.z+WINDOW_H/4+self.Scale.z*(20+(40+self.Sprites["code"..par.code].height)*(y)+self.offsets.top)
                if par.code == SCRIPT_PARAM_ONOFF then
                    if CursorIsUnder(bxPos, byPos, self.Scale.x*self.Sprites["code"..par.code].width, self.Scale.z*self.Sprites["code"..par.code].height) then
                        par.value = not par.value
                        self:save()
                    end
                elseif par.code == SCRIPT_PARAM_ONKEYDOWN or par.code == SCRIPT_PARAM_ONKEYTOGGLE then
                    a = a + 1
                    local b = 0
                    local ppos = par.name
                    local kpos = par.key
                    for _,k in pairs(self.par) do
                        if par.state == k.state and (k.code == SCRIPT_PARAM_ONKEYDOWN or k.code == SCRIPT_PARAM_ONKEYTOGGLE) then
                            ppos = k.name kpos = k.key
                            b = b + 1
                        end
                    end
                    xOffset = b > 1 and self.Scale.x*(0-a*self.Sprites["mid"].width/(2*b)+(b+0.75)*self.Sprites["mid"].width/(4*b)) or 0
                    sprite = par.key > 32 and "Button\\"..string.char(par.key) or "Button\\".."Space"
                    if CursorIsUnder(self.pos.x+xOffset+self.Scale.x*(self.offsets.buttonwidth+self.Sprites["mid"].width/2-self.Sprites[par.key].width/2-1),self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*#self.states-self.Sprites[par.key].height/2-self.Sprites[par.name].height*2-20), self.Scale.x*self.Sprites[par.key].width, self.Scale.z*self.Sprites[par.key].height) then
                        self.keyChange = par
                    end
                elseif par.code == SCRIPT_PARAM_SLICE then
                    if c > 0 then y = y + 1 c = 0 end
                    if y == 0 then y = 0.2+0.05*#par.slider end
                    for k=1,#par.slider do
                        sxPos = self.pos.x+self.Scale.x*((self.Sprites["code"..par.code].width+70)*par.slider[k]/100+k*2+self.offsets.buttonwidth-self.Sprites["SLIDER_"..k].width/2+self.Sprites["mid"].width/2-self.Sprites["code"..par.code].width/2)
                        syPos = self.pos.z+WINDOW_H/4+self.Scale.z*(30+self.offsets.top-self.Sprites["SLIDER_"..k].height+self.offsets.button*(#self.states-3)*y)
                        if CursorIsUnder(sxPos,syPos,self.Sprites["SLIDER_"..k].width,self.Sprites["SLIDER_"..k].height) then
                            self.touch = {x = cursor.x, z = par.slider[k]}
                            self.slide[k] = true
                            break
                        end
                    end
                elseif par.code == SCRIPT_PARAM_LIST then
                    if c > 0 then
                        y = y +1
                    end
                    bxPos = self.pos.x+self.Scale.x*(self.Sprites["mid"].width/2+self.Sprites[par.name].width/2-self.Sprites[par.list[par.value]].width/2+40+self.offsets.buttonwidth)
                    byPos = self.pos.z+WINDOW_H/4+self.Scale.z*((80+45+self.Sprites[par.name].height)*(y+0.5)+self.offsets.top)
                    if CursorIsUnder(bxPos, byPos, self.Scale.x*self.Sprites[par.list[par.value]].width, self.Scale.z*self.Sprites[par.list[par.value]].height) then
                        par.value = par.value + 1
                        if par.value > #par.list then
                            par.value = 1
                        end
                    end
                end
                c = c+1
            end
        end
        for _,k in pairs(self.states) do
            if not self.substates[k] then
                if CursorIsUnder(self.pos.x, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-1)), self.Scale.x*self.offsets.buttonwidth, self.Scale.z*self.offsets.button) then
                    self.state = k
                end
            else
                for v,l in pairs(self.substates[k]) do
                    if CursorIsUnder(self.pos.x, self.pos.z+WINDOW_H/4+self.Scale.z*(self.offsets.top+self.offsets.button*(_-1)+self.offsets.button/2*(v-1)), self.Scale.x*self.offsets.buttonwidth, self.Scale.z*self.offsets.button/2) then
                        self.state = l
                    end
                end
            end
        end
    elseif Msg == WM_LBUTTONUP then
        self.resize = false
        self.move = false
        for _,par in pairs(self.par) do
            if par.state == self.state and par.code == SCRIPT_PARAM_SLICE then
                for k=1,#par.slider do
                    if self.slide[k] then
                        self.slide[k] = false
                    end
                end
            end
        end
    end
end


-- -- Alerter Class
-- written by Weee
-- adjusted so it doesn't create a scriptConfig instance
--[[
    PrintAlert(text, duration, r, g, b, sprite)           - Pushes an alert message (notification) to the middle of the screen. Together with first message it also adds a configuration menu to the scriptConfig.
                text:   Alert text                        - <string>
]]

local __mAlerter, __Alerter_OnTick, __Alerter_OnDraw = nil, nil, nil

function PrintAlertRed(text, duration)
    if not __mAlerter then __mAlerter = __Alerter() end
    return __mAlerter:Push(text, duration, 255, 0, 0)
end

class("__Alerter")
function __Alerter:__init()
    if not __Alerter_OnTick then
        function __Alerter_OnTick() if __mAlerter then __mAlerter:OnTick() end end
        AddTickCallback(__Alerter_OnTick)
    end
    if not __Alerter_OnDraw then
        function __Alerter_OnDraw() if __mAlerter then __mAlerter:OnDraw() end end
        AddDrawCallback(__Alerter_OnDraw)
    end

    self.yO = -WINDOW_H * 0.25
    self.x = WINDOW_W/2
    self.y = WINDOW_H/2 + self.yO
    self._alerts = {}
    self.activeCount = 0
    return self
end

function __Alerter:OnTick()
    self.yO = -WINDOW_H * 0.25
    self.x = WINDOW_W/2
    self.y = WINDOW_H/2 + self.yO
    --if #self._alerts == 0 then self:__finalize() end
end

function __Alerter:OnDraw()
    local gameTime = GetInGameTimer()
    for i, alert in ipairs(self._alerts) do
        self.activeCount = 0
        for j = 1, i do
            local cAlert = self._alerts[j]
            if not cAlert.outro then self.activeCount = self.activeCount + 1 end
        end
        if self.activeCount <= 3 and (not alert.playT or alert.playT + 0.5*2 + alert.duration > gameTime) then
            alert.playT = not alert.playT and self._alerts[i-1] and (self._alerts[i-1].playT + 0.5 >= gameTime and self._alerts[i-1].playT + 0.5 or gameTime) or alert.playT or gameTime
            local intro = alert.playT + 0.5 > gameTime
            alert.outro = alert.playT + 0.5 + alert.duration <= gameTime
            alert.step = alert.outro and math.min(1, (gameTime - alert.playT - 0.5 - alert.duration) / 0.5)
                    or gameTime >= alert.playT and math.min(1, (gameTime - alert.playT) / 0.5)
                    or 0
            local xO = alert.outro and self:Easing(alert.step, 0, 50) or self:Easing(alert.step, -50, 50)
            local alpha = alert.outro and self:Easing(alert.step, 255, -255) or self:Easing(alert.step, 0, 255)
            local yOffsetTar = GetTextArea(alert.text, 20).y * 1.2 * (self.activeCount-1)
            alert.yOffset = intro and alert.step == 0 and yOffsetTar
                    or #self._alerts > 1 and not alert.outro and (alert.yOffset < yOffsetTar and math.min(yOffsetTar, alert.yOffset + 0.5) or alert.yOffset > yOffsetTar and math.max(yOffsetTar, alert.yOffset - 0.5))
                    or alert.yOffset
            local x = self.x + xO
            local y = self.y - alert.yOffset
            -- outline:
            local o = 1--TODO
            if o > 0 then
                for j = -o, o do
                    for k = -o, o do
                        DrawTextA(alert.text, 20, math.floor(x+j), math.floor(y+k), ARGB(alpha, 0, 0, 0), "center", "center")
                    end
                end
            end
            -- sprite:
            if alert.sprite then
                alert.sprite:SetScale(alert.spriteScale, alert.spriteScale)
                alert.sprite:Draw(math.floor(x - GetTextArea(alert.text, 20).x/2 - alert.sprite.width * alert.spriteScale * 1.5), math.floor(y - alert.sprite.width * alert.spriteScale / 2), alpha)
            end
            -- text:
            DrawTextA(alert.text, 20, math.floor(x), math.floor(y), ARGB(alpha, alert.r, alert.g, alert.b), "center", "center")
        elseif alert.playT and alert.playT + 0.5*2 + alert.duration <= gameTime then
            table.remove(self._alerts, i)
        end
    end
end

function __Alerter:Push(text, duration, r, g, b, sprite)
    local alert = {}
    alert.text = text
    alert.sprite = sprite
    alert.spriteScale = sprite and 20 / sprite.height
    alert.duration = duration or 1
    alert.r = r
    alert.g = g
    alert.b = b

    alert.parent = self
    alert.yOffset = 0

    alert.reset = function(duration)
        alert.playT = GetInGameTimer() - 0.5
        alert.duration = duration or 0
        alert.yOffset = GetTextArea(alert.text, 20).y * (self.activeCount-1)
    end

    self._alerts[#self._alerts+1] = alert
    return alert
end

function __Alerter:Easing(step, sPos, tPos)
    step = step - 1
    return tPos * (step ^ 3 + 1) + sPos
end

function __Alerter:__finalize()
    __Alerter_OnTick = nil
    __Alerter_OnDraw = nil
    __mAlerter = nil
end
