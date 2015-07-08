class 'GUI' -- {
    function GUI:__init() end

    function GUI:DrawText(text, size, x, y, color, outline, outlineColor, align)
        text = text or 'SAMPLE TEXT'
        size = size or 24
        x = x or WINDOW_W / 2
        y = y or WINDOW_H / 2
        color = color or 4278255360
        outline = outline or 1
        outlineColor = outlineColor or 4278190080
        align = align or 'C'

        local textArea = GetTextArea(text, size)
        x = x - (align == 'C' and textArea.x / 2 or (align == 'R' and textArea.x or 0))
        y = y - textArea.y / 2

        if outline >= 1 then
            _G.DrawText(text, size, x + outline, y, outlineColor)
            _G.DrawText(text, size, x - outline, y, outlineColor)
            _G.DrawText(text, size, x, y - outline, outlineColor)
            _G.DrawText(text, size, x, y + outline, outlineColor)
        end

        _G.DrawText(text, size, x , y, color)
    end

    function GUI:GetSprites(spriteFolder)
        if not self.loadedSprites then
            self.loadedSprites = {}

            AddUnloadCallback(function()
                for folderName, sprites in pairs(self.loadedSprites) do
                    for spriteName, sprite in pairs(sprites) do
                        sprite:Release()
                    end
                end
            end)
        end

        if not self.loadedSprites[spriteFolder] then
            local path = (SPRITE_PATH .. spriteFolder):gsub([[/]], [[\]])

            self.loadedSprites[spriteFolder] = {}

            if RunCmdCommand('dir /b /a:-d-s "' .. path .. '"') == 0 then
                for k, file in pairs(PopenHidden('dir /b /a:-d-s "' .. path .. '"'):trim():split("\n")) do
                    self.loadedSprites[spriteFolder][file:trim():gsub('%.[^%.]+$', '')] = GetSprite(spriteFolder .. '\\' .. file:trim())
                end
            end
        end

        return self.loadedSprites[spriteFolder]
    end
--}

_G.GUI = GUI()