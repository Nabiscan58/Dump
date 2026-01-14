Modules.UI.cooldown = false
Modules.UI.font = {}
Modules.UI.AnimatedFrames = {}
Modules.UI.Alpha = {}
Modules.UI.pages = {
    ["tablet"] = {
        label = "tablet",
        active = false,
        lockControls = true,
        showCursor = true,
        drawFunction = function()
            TABLET.UI.MAIN.Draw()
        end,
    },
}

Modules.UI.lockedControls = {
    { 24, 30, 31, 32, 33, 34, 35, 69, 70, 92, 114, 121, 140, 141, 142, 257, 263, 264, 331, 1, 2, 4, 5, 17, 16, 15, 14 }
}

function Modules.UI.IsAnySubMenuActive()
    for k, v in pairs(Modules.UI.pages) do
        if v.active then
            return true
        end
    end
    return false
end

function LoadLogin()
    Modules.UI.SetPageActive("tablet")
end

function CloseLogin()
    Modules.UI.SetPageInactive("tablet")
end

function LoadMonopoleAlert()
    Modules.UI.SetPageActive("monopole_alert")
end

function CloseMonopoleAlert()
    Modules.UI.SetPageInactive("monopole_alert")
end

function Modules.UI.SetPageActive(page)
    Modules.UI.pages[page].active = true
end

function Modules.UI.IsActive(page)
    return Modules.UI.pages[page].active
end

function Modules.UI.SetPageInactive(page)
    if Modules.UI.pages[page] then
        Modules.UI.pages[page].active = false
    end
end

function Modules.UI.SetFullscreenLoaderActive(status)
    if status then
        SendNUIMessage({
            type = 'toggleLoaderOn',
        })
    else
        SendNUIMessage({
            type = 'toggleLoaderOff',
        })
    end
end

function Modules.UI.ForceStopIntro()
    SendNUIMessage({
        type = 'stopIntro',
    })
end

Citizen.CreateThread(function()
    local isPlayingAnim = false

    local function playTabletAnimation()
        local playerPed = PlayerPedId()
        ExecuteCommand("e tablet")
        isPlayingAnim = true
    end

    local function stopTabletAnimation()
        local playerPed = PlayerPedId()
        ExecuteCommand("e stop")
        isPlayingAnim = false
    end

    while true do
        local pNear = false
        local lockControls = false
        local showCursor = false

        for k, v in pairs(Modules.UI.pages) do
            if v.active then
                pNear = true
                if v.showCursor then
                    showCursor = true
                end
                if v.lockControls then
                    lockControls = true
                end
                v.drawFunction()
            end
        end

        if pNear and not isPlayingAnim then
            playTabletAnimation()
        elseif not pNear and isPlayingAnim then
            stopTabletAnimation()
        end

        if showCursor and pNear then
            ShowCursorThisFrame()
        end

        if lockControls and pNear then
            for k, v in pairs(Modules.UI.lockedControls[1]) do
                if v ~= nil then
                    DisableControlAction(0, v, true)
                end
            end
        end

        if pNear then
            Wait(0)
        else
            Wait(500)
        end
    end
end)

function Modules.UI.RealWait(ms, cb)
    local timer = GetGameTimer() + ms
    while GetGameTimer() < timer do
        if cb ~= nil then
            cb(function(stop)
                if stop then
                    timer = 0
                    return
                end
            end)
        end
        Wait(0)
    end
end

function Modules.UI.LoadStreamDict(dict)
    while not HasStreamedTextureDictLoaded(dict) do
        RequestStreamedTextureDict(dict, 1)
        Wait(0)
    end
    Modules.UI.RealWait(100)
end

function Modules.UI.LoadFont(font)
    RegisterFontFile(font[1])              -- the name of your .gfx, without .gfx
    local fontId = RegisterFontId(font[2]) -- the name from the .xml

    Modules.UI.font[font[2]] = fontId
    Citizen.Wait(100)
end

local cachedResult = nil
function Modules.UI.GetTopLeftMinimap()
    if cachedResult == nil then
        SetScriptGfxAlign(string.byte('L'), string.byte('B'))
        local minimapTopX, minimapTopY = GetScriptGfxPosition(-0.0045, 0.002 + (-0.188888))
        ResetScriptGfxAlign()
        local w, h = GetActiveScreenResolution()
        cachedResult = { w * minimapTopX, h * minimapTopY }
        return { w * minimapTopX, h * minimapTopY }
    else
        return cachedResult
    end
end

-- DrawRectangle(vector2(self.baseX, self.baseY - 0.005), vector2(self.baseWidth, self.baseHeight - 0.025), {self.baseRgb[1], self.baseRgb[2], self.baseRgb[3], 255})
function Modules.UI.DrawRectangle(position, size, color, action, hoverColor, actions, hoverAction, sound, devmod)
    if devmod ~= nil and devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
        position = vector2(x, y)
    end

    local pos = (position + size / 2.0)
    DrawRect(pos[1], pos[2], size[1], size[2], color[1], color[2], color[3], color[4])

    if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
            { x = position.x, y = position.y }, size[1], size[2]) then
        -- SetMouseCursorSprite(4)
        if hoverColor[4] ~= 0 then -- Avoid drawing anything if alpha == 0, performaaaaance
            DrawRect(pos[1], pos[2], size[1] + 0.003, size[2] + 0.003, hoverColor[1], hoverColor[2], hoverColor[3],
                hoverColor[4])
        end
        if action ~= nil and action ~= false then
            if Modules.UI.HandleControl() then
                if sound == nil then
                    --PlayCustomSound("ui_click.ogg", 0.02)
                else
                    --PlayCustomSound(sound, 0.02)
                end
                actions()
            end

            if hoverAction ~= nil then
                hoverAction()
            end
            return true
        else
            return false
        end
    end
end

function Modules.UI.GetControl()
    local x, y = 0, 0
    local resX, resY = GetActiveScreenResolution()
    if GetPauseMenuState() ~= 0 then
        EnableAllControlActions(0)
        x, y =  GetNuiCursorPosition()
        x = x/resX
        y = y/resY
    else
        x = GetControlNormal(0, 239)
        y = GetControlNormal(0, 240)
    end
    return vector2(x, y)
end

function Modules.UI.DrawSlider(screenX, screenY, width, height, backgroundColor, progressColor, value, max, settings, cb)
    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)


        screenX = x
        screenY = y


        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if value > max then
        value = max
    end

    if settings.direction == nil then
        settings.direction = 1
    end

    local valueUpdated = false
    local newValue = value

    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    DrawRect(pos[1], pos[2], width, height, backgroundColor[1], backgroundColor[2], backgroundColor[3],
        backgroundColor[4])

    local progressWidth = (value / max) * width
    local progressHeight = height

    if settings.direction == 1 then     -- left-to-right
        pos = (vector2(screenX, screenY) + vector2(progressWidth, height) / 2.0)
    elseif settings.direction == 2 then -- right-to-left
        pos = pos + vector2(width / 2.0, 0.0) - vector2(progressWidth / 2.0, 0.0)
    elseif settings.direction == 3 then -- bottom-to-top
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos + vector2(0.0, height / 2.0) - vector2(0.0, progressHeight / 2.0)
    elseif settings.direction == 4 then -- top-to-bottom
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos - vector2(0.0, height / 2.0) + vector2(0.0, progressHeight / 2.0)
    end

    DrawRect(pos[1], pos[2], progressWidth, progressHeight, progressColor[1], progressColor[2], progressColor[3],
        progressColor[4])
    if settings.noHover == false then
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
                { x = screenX, y = screenY }, width, height) then
            -- SetMouseCursorSprite(4)
            if IsDisabledControlPressed(0, 24) then
                local mouse = GetControlNormal(0, 239)
                local size = ((mouse - screenX) * max) / width
                newValue = size

                valueUpdated = true
            end
        end
    end

    cb(valueUpdated, newValue)
end

function Modules.UI.DrawCrossBar(screenX, screenY, width, height, backgroundColor, progressColor, max, seeNumber,
                                 actualPage, settings, cb)
    local value = 1
    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)


        screenX = x
        screenY = y


        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end
    if max < seeNumber then
        actualPage = 0
    end
    max = max / seeNumber
    if value > max then
        value = max
    end

    if settings.direction == nil then
        settings.direction = 1
    end

    local valueUpdated = false
    local newValue = value

    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    DrawRect(pos[1], pos[2], width, height, backgroundColor[1], backgroundColor[2], backgroundColor[3],
        backgroundColor[4])

    local progressWidth = (value / max) * width
    local progressHeight = height
    local crossPos
    if settings.direction == 1 then -- left-to-right
        pos = (vector2(screenX, screenY) + vector2(progressWidth, height) / 2.0)
        local longueur = screenX + ((actualPage / max) * width)

        crossPos = (vector2(longueur, screenY) + vector2(progressWidth, height) / 2.0)
    elseif settings.direction == 2 then -- right-to-left ---pas fonctionnel total
        ---minimum = 1
        pos = pos + vector2(width / 2.0, 0.0) - vector2(progressWidth / 2.0, 0.0)
        local longueur = screenX + (((actualPage - 0.5) / max) * (width))
        crossPos = vector2(longueur, pos[2]) - vector2(((actualPage / max) * (width)), 0.0)
    elseif settings.direction == 3 then -- bottom-to-top
        progressWidth = width
        progressHeight = (value / max) * height
        local longueur = screenY + (((actualPage * 2.0) / max) * (height / 2.0))
        crossPos = vector2(pos[1], longueur) + vector2(0.0, progressHeight / 2.0)
        pos = pos + vector2(0.0, height / 2.0) - vector2(0.0, progressHeight / 2.0)
    elseif settings.direction == 4 then -- top-to-bottom
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos - vector2(0.0, height / 2.0) + vector2(0.0, progressHeight / 2.0)
    end


    if settings.noHover == false then
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
                { x = screenX, y = screenY }, width, height) then
            -- SetMouseCursorSprite(5)
            if IsDisabledControlPressed(0, 24) then
                local mouse = GetControlNormal(0, 239)
                local size = ((mouse - screenX) * max) / width
                local longueur = screenY + (((actualPage * 2.0) / max) * (height / 2.0))
                newValue = size
                valueUpdated = true
            end
        end
    end
    DrawRect(crossPos[1], crossPos[2], progressWidth, progressHeight, progressColor[1], progressColor[2],
        progressColor[3],
        progressColor[4])

    cb(valueUpdated, newValue)
end

function Modules.UI.DrawProgressBar(screenX, screenY, width, height, backgroundColor, progressColor, value, max, settings
    , cb)
    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)


        screenX = x
        screenY = y


        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if value > max then
        value = max
    end

    if settings.direction == nil then
        settings.direction = 1
    end

    local valueUpdated = false
    local newValue = value

    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    DrawRect(pos[1], pos[2], width + 0.005, height + 00.005, backgroundColor[1], backgroundColor[2], backgroundColor[3],
        backgroundColor[4])

    local progressWidth = (value / max) * width
    local progressHeight = height

    if settings.direction == 1 then     -- left-to-right
        pos = (vector2(screenX, screenY) + vector2(progressWidth, height) / 2.0)
    elseif settings.direction == 2 then -- right-to-left
        pos = pos + vector2(width / 2.0, 0.0) - vector2(progressWidth / 2.0, 0.0)
    elseif settings.direction == 3 then -- bottom-to-top
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos + vector2(0.0, height / 2.0) - vector2(0.0, progressHeight / 2.0)
    elseif settings.direction == 4 then -- top-to-bottom
        progressWidth = width
        progressHeight = (value / max) * width
        pos = pos - vector2(0.0, height / 2.0) + vector2(0.0, progressHeight / 2.0)
    end

    DrawRect(pos[1], pos[2], progressWidth, progressHeight, progressColor[1], progressColor[2], progressColor[3],
        progressColor[4])

    if settings.noHover == false then
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
                { x = screenX, y = screenY }, width, height) then
            -- SetMouseCursorSprite(4)
            if IsControlPressed(0, 24) then
                local mouse = GetControlNormal(0, 239)
                local size = ((mouse - screenX) * max) / width
                newValue = size

                valueUpdated = true
            end
        end
    end

    cb(valueUpdated, newValue)
end

function Modules.UI.DrawSprite(textureDict, textureName, screenX, screenY, width, height, heading, red, green, blue,
                               alpha, actions, hover)
    local pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)

    -- if Modules.Sheets.IsSpriteAnimated(textureDict, textureName) then
    --     textureName = textureName .. Modules.Sheets.GetActualFrame(textureDict, textureName)
    -- end

    if hover == nil then
        DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
    else
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
                { x = screenX, y = screenY }, width, height) then
            DrawSprite(hover[1], hover[2], pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        else
            DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        end
    end

    if actions ~= nil then
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
                { x = screenX, y = screenY }, width, height) then
            -- SetMouseCursorSprite(4)

            if Modules.UI.HandleControl() then
                --PlayCustomSound("ui_click.ogg", 0.02)
                actions()
            end

            return true
        else
            return false
        end
    end
end

Modules.UI.HoveredCache = {}

function Modules.UI.CheckIfAlreadyHovered(textureDict, textureName, screenX, screenY)
    local uniqueID = textureDict .. textureName .. screenX .. screenY
    if Modules.UI.HoveredCache[uniqueID] == nil then
        Modules.UI.HoveredCache[uniqueID] = false
        return false, uniqueID
    else
        return Modules.UI.HoveredCache[uniqueID], uniqueID
    end
end

function Modules.UI.SetHoveredStatus(uniqueID, status)
    if Modules.UI.HoveredCache[uniqueID] ~= nil then
        Modules.UI.HoveredCache[uniqueID] = status
    end
end

function Modules.UI.DrawSpriteNew(textureDict, textureName, screenX, screenY, width, height, heading, red, green, blue, alpha, settings, cb)
    local onSelected = false
    local onHovered = false

    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)

        screenX = x
        screenY = y
        
        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    local pos
    if settings.centerDraw ~= nil and settings.centerDraw == true then
        pos = vector2(screenX, screenY)
    else
        pos = (vector2(screenX, screenY) + vector2(width, height) / 2.0)
    end

    -- if Modules.Sheets.IsSpriteAnimated(textureDict, textureName) then
    --     textureName = textureName .. Modules.Sheets.GetActualFrame(textureDict, textureName)
    -- end

    if settings.Draw3d ~= nil then
        SetDrawOrigin(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z, 0)
        pos = (vector2(0.0, 0.0) + vector2(width, height) / 2.0)
    end

    if settings.NoHover ~= nil and settings.NoHover == true then
        DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
    else
        if settings.Draw3d ~= nil then
            _, screenX, screenY = GetScreenCoordFromWorldCoord(settings.Draw3d.pos.x, settings.Draw3d.pos.y, settings.Draw3d.pos.z)
        end
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) }, { x = screenX, y = screenY }, width, height) then
            onHovered = true
            local aleadyHovered, spriteUniqueId = Modules.UI.CheckIfAlreadyHovered(textureDict, textureName, screenX,
                screenY)
            if not aleadyHovered then
                Modules.UI.SetHoveredStatus(spriteUniqueId, true)
                -- Modules.Sound.PlaySound(math.random(1, 99999), "FrontEnd/Navigate_one", false, 0.4)
            end
            if settings.CustomHoverTexture ~= nil and settings.CustomHoverTexture ~= false then
                if settings.CustomHoverTexture[3] ~= nil and settings.CustomHoverTexture[4] ~= nil then
                    local x, y = Modules.UI.ConvertToPixel(settings.CustomHoverTexture[3], settings.CustomHoverTexture[4])
                    width = x
                    height = y
                end

                if settings.CustomHoverTexture[5] ~= nil and settings.CustomHoverTexture[6] ~= nil then
                    pos = (vector2(settings.CustomHoverTexture[5], settings.CustomHoverTexture[6]) + vector2(width, height) / 2.0)
                end
                if settings.CustomHoverTexture[7] ~= nil then
                    red = settings.CustomHoverTexture[7][1]
                    blue = settings.CustomHoverTexture[7][3]
                    green = settings.CustomHoverTexture[7][2]
                    alpha = settings.CustomHoverTexture[7][4]
                end

                DrawSprite(settings.CustomHoverTexture[1], settings.CustomHoverTexture[2], pos[1], pos[2], width, height, heading, red, green, blue, alpha)
            else
                DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
            end
        else
            onHovered = false
            local aleadyHovered, spriteUniqueId = Modules.UI.CheckIfAlreadyHovered(textureDict, textureName, screenX,
                screenY)
            if aleadyHovered then
                Modules.UI.SetHoveredStatus(spriteUniqueId, false)
            end
            DrawSprite(textureDict, textureName, pos[1], pos[2], width, height, heading, red, green, blue, alpha)
        end
    end

    if settings.NoSelect == nil or settings.NoSelect == false and not settings.devmod == true then
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) }, { x = screenX, y = screenY }, width, height) then
            -- SetMouseCursorSprite(3)
            onHovered = true

            if (IsControlJustReleased(0, 24) or IsDisabledControlJustReleased(0, 24)) or (IsControlJustReleased(0, 176) or IsDisabledControlJustReleased(0, 176)) then
            -- if Modules.UI.HandleControl() then
                -- PlayCustomSound("FrontEnd/Navigate_Apply_01_Wave 0 0 0", 0.02)
                -- Modules.Sound.PlaySound(math.random(1, 99999), "FrontEnd/Navigate_one", false, 0.02)
                onSelected = true
            end
        end
    end

    if settings.Draw3d ~= nil then
        ClearDrawOrigin()
    end

    cb(onSelected, onHovered, pos)
end

function Modules.UI.FadeOutSprite(dict, sprite, screenX, screenY, width, height, heading, red, green, blue, alpha, time,
                                  remove)
    Citizen.CreateThread(function()
        local originalAlpha = alpha
        for i = 0, originalAlpha do
            alpha = alpha - remove
            DrawSprite(dict, sprite, screenX, screenY, width, height, heading, red, green, blue, alpha)

            if alpha <= 0 then
                break
            end
            Wait(time)
        end
    end)
end

function Modules.UI.FadeInSprite(dict, sprite, screenX, screenY, width, height, heading, red, green, blue, alpha, time,
                                 add)
    Citizen.CreateThread(function()
        local originalAlpha = alpha
        for i = 0, originalAlpha do
            alpha = alpha + add
            DrawSprite(dict, sprite, screenX, screenY, width, height, heading, red, green, blue, alpha)

            if alpha <= originalAlpha then
                break
            end
            Wait(time)
        end
    end)
end

-- Position = mouse pos
function Modules.UI.isMouseOnButton(position, buttonPos, Width, Heigh)
    return position.x >= buttonPos.x and position.y >= buttonPos.y and position.x < buttonPos.x + Width and
        position.y < buttonPos.y + Heigh
end

function Modules.UI.HandleCooldown()
    if not Modules.UI.cooldown then
        Modules.UI.cooldown = true
        Citizen.CreateThread(function()
            Wait(150)
            Modules.UI.cooldown = false
        end)
    end
end

local clickControl = { 24, 176 }
function Modules.UI.HandleControl()
    for k, v in pairs(clickControl) do
        if not Modules.UI.cooldown then
            if IsControlJustReleased(0, v) or IsDisabledControlJustReleased(0, v) then
                Modules.UI.HandleCooldown()
                return true
            end
        end
    end
    return false
end

function Modules.UI.DrawTexts(x, y, text, center, scale, rgb, font, rightJustify, devmod, width, height, cb)
    local onSelected = false
    local onHovered = false
    if devmod then
        local x2 = GetControlNormal(0, 239)
        local y2 = GetControlNormal(0, 240)

        x = x2
        y = y2

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if rightJustify ~= 0 and rightJustify ~= false then
        SetTextJustification(2)
        SetTextWrap(0.0, x)
    end

    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("STRING")
    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
    if width ~= nil and height ~= nil then
        if center then
            x = x - 0.03
            y = y - 0.04
        end
        if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) },
                { x = x, y = y }, width, height) then
            -- SetMouseCursorSprite(4)
            onHovered = true
            if Modules.UI.HandleControl() then
                --PlayCustomSound("FrontEnd/Navigate_Apply_01_Wave 0 0 0", 0.02)
                -- Modules.Sound.PlaySound(math.random(1, 99999), "FrontEnd/Navigate_one", false, 0.02)
                onSelected = true
            end
        end
    end
    if cb ~= nil then
        cb(onSelected, onHovered)
    end
end

function Modules.UI.DrawTextsNoLimit(x, y, text, center, scale, rgb, font, rightJustify, devmod)
    AddTextEntry("text", text)
    if devmod then
        local x2 = GetControlNormal(0, 239)
        local y2 = GetControlNormal(0, 240)

        x = x2
        y = y2
    end

    if rightJustify ~= 0 and rightJustify ~= false then
        SetTextJustification(2)
        SetTextWrap(0.0, x)
    end

    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("text")
    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

function Modules.UI.Draw3DText(x, y, z, textInput, fontId, scaleX, scaleY, color)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
    local scale = (1 / dist) * 20
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    SetTextScale(scaleX * scale, scaleY * scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(color[1], color[2], color[3], color[4]) -- You can change the text color here
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

-- pos.xyz
-- textureDict
-- textureName
-- x
-- y
-- width
-- height
-- heading
-- r
-- g
-- b
-- a
function Modules.UI.DrawSprite3d(data, dontDrawHowOfScreen)
    if dontDrawHowOfScreen == nil then
        dontDrawHowOfScreen = false
    end

    local draw = false
    if dontDrawHowOfScreen == false then
        draw = true
    else
        local get, x, y = GetScreenCoordFromWorldCoord(data.pos.x, data.pos.y, data.pos.z)
        if not get or x < 0.0 or x > 1.0 or y < 0.0 or y > 1.0 then
            draw = false
        else
            draw = true
        end
    end

    if draw then
        local dist = #(GetGameplayCamCoords().xy - data.pos.xy)
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = ((1 / dist) * 2) * fov
        SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
        DrawSprite(
            data.textureDict,
            data.textureName,
            (data.x or 0) * scale,
            (data.y or 0) * scale,
            data.width * scale,
            data.height * scale,
            data.heading or 0,
            data.r or 255,
            data.g or 255,
            data.b or 255,
            data.a or 255
        )
        ClearDrawOrigin()
    end
    return draw
end

function Modules.UI.DrawSprite3dNoDownSize(data, dontDrawHowOfScreen)
    if dontDrawHowOfScreen == nil then
        dontDrawHowOfScreen = false
    end

    local draw = false
    if dontDrawHowOfScreen == false then
        draw = true
    else
        local get, x, y = GetScreenCoordFromWorldCoord(data.pos.x, data.pos.y, data.pos.z)
        if not get or x < 0.0 or x > 1.0 or y < 0.0 or y > 1.0 then
            draw = false
        else
            draw = true
        end
    end

    if draw then
        local scale = 1
        SetDrawOrigin(data.pos.x, data.pos.y, data.pos.z, 0)
        DrawSprite(
            data.textureDict,
            data.textureName,
            data.x or (0 * scale),
            data.y or (0 * scale),
            data.width * scale,
            data.height * scale,
            data.heading or 0,
            data.r or 255,
            data.g or 255,
            data.b or 255,
            data.a or 255
        )
        ClearDrawOrigin()
    end
    return draw
end

-- function Modules.UI.ConvertToPixel(x, y)
--     return (x * 1920), (y * 1080)
-- end

function Modules.UI.ConvertToPixel(x, y)
    return (x / 1920), (y / 1080)
end

function Modules.UI.Convert2kTo1080(x, y)
    return ((x * 1920) / 2560), ((y * 1080) / 1440)
end

function Modules.UI.Convert2kToPixel(x, y)
    local w, h = Modules.UI.Convert2kTo1080(x, y)
    return (w / 1920), (h / 1080)
end

function Modules.UI.Convert4kTo1080(x, y)
    return ((x * 1920) / 3840), ((y * 1080) / 2160)
end

function Modules.UI.Convert4kToPixel(x, y)
    local w, h = Modules.UI.Convert4kTo1080(x, y)
    return (w / 1920), (h / 1080)
end

function Modules.UI.ConvertToRes(x, y)
    return (x * 1920), (y * 1080)
end

function Modules.UI.MeasureStringWidth(str, font, scale)
    local len
    local function Execute(str, font, scale)
        BeginTextCommandGetWidth("CELL_EMAIL_BCON")
        AddTextComponentSubstringPlayerName(str)
        SetTextFont(font or 0)
        SetTextScale(1.0, scale or 0)
        len, _ = Modules.UI.ConvertToPixel(EndTextCommandGetWidth(true) * 1920, 0)
    end

    SafeExecuteFunction(Execute, str, font, scale)

    return len
end

function Modules.UI.Subtitle(text, time)
    AddTextEntry('module:notif', text)
    BeginTextCommandPrint('module:notif')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(time and math.ceil(time) or 0, true)
end

Modules.posX = 0.1328125
Modules.posY = 0.7740740776062
Modules.posX2 = 0.1328125
Modules.posY2 = 0.7740740776062
local width, height = Modules.UI.ConvertToPixel(150, 150)
local tw, th = Modules.UI.ConvertToRes(width, height)
local CircleX = (0.17254584624767 * 1920) + 0.17254584624767 / tw
local CircleY = (0.84311106872559 * 1080) + 0.84311106872559 / th
local CircleX2 = (0.17254584624767 * 1920) + 0.17254584624767 / tw
local CircleY2 = (0.84311106872559 * 1080) + 0.84311106872559 / th
-- 0.16614584624767, 0.83611106872559
local save = false
-- 0.16666667163372, 0.83518517017365

function Modules.UI.DrawGridHorizontal(screenX, screenY, settings, cb)
    local onSelected = false
    local onPositionChange = false
    local X = screenX
    local Y = screenY

    local gridX = (Modules.posX * 1920) + Modules.posX2 / tw
    local gridY = (Modules.posY * 1080) + Modules.posY2 / th


    ---DevMode
    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)

        Modules.posX2 = x
        Modules.posY2 = y

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if settings.grid == nil then
        settings.grid = 'default'
    end
    if settings.grid == "default" then
        Modules.UI.DrawSpriteNew("pause_menu_pages_char_mom_dad", "nose_grid", Modules.posX2, Modules.posY2, width, height, 0, 255, 255,
            255,
            255, {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)

            end)
    elseif settings.grid == "horizontal" then
        Modules.UI.DrawSpriteNew("barber", "horizontal_grid", Modules.posX2, Modules.posY2, width, height, 0, 255, 255,
            255,
            255, {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)

            end)
    end

    local w, h = Modules.UI.ConvertToPixel(20, 20)

    if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) }, { x = gridX / 1920, y =
            gridY / 1080 }, width, height) then
        if IsDisabledControlPressed(0, 24) or IsControlPressed(0, 24) then
            onPositionChange = true
            if settings.grid ~= "horizontal" then
                CircleX2 = (GetControlNormal(0, 239) * 1920) + Modules.posX2 / tw
                CircleY2 = (GetControlNormal(0, 240) * 1080) + Modules.posY2 / th
                X = ((CircleX2 / 1920) / width) - (Modules.posX2 / width)
                Y = ((CircleY2 / 1080) / height) - (Modules.posY2 / height)
            else
                CircleX2 = (GetControlNormal(0, 239) * 1920) + Modules.posX2 / tw
                -- CircleY = (GetControlNormal(0, 240) * 1080) + posY / th
                X = ((CircleX2 / 1920) / width) - (Modules.posX2 / width)
                -- Y = ((CircleY / 1080) / height) - (posY / height)
            end
        end
        -- Modules.Sound.PlaySound(math.random(1, 99999), "FrontEnd/Navigate_one", false, 0.4)
    else
        onPositionChange = false
    end

    Modules.UI.DrawSpriteNew("mpinventory", "in_world_circle", CircleX2 / 1920 - w / 2, CircleY2 / 1080 - h / 2, w, h, 0,
    255, 255, 255, 255, {
        NoHover = true,
        CustomHoverTexture = false,
        NoSelect = true,
        devmod = false
    }, function(onSelected, onHovered)
        if onSelected then
        end
    end)


    --Text
    if settings.grid ~= "horizontal" then
        Modules.UI.DrawTexts(0.17135417461395, 0.74814814329147, settings.text.up, true, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], true, false)
        Modules.UI.DrawTexts(0.17187501490116, 0.92407405376434, settings.text.down, true, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], true, false)
        Modules.UI.DrawTexts(0.21822917461395, 0.83333331346512, settings.text.out, false, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], false, false)
        Modules.UI.DrawTexts(0.1234375089407, 0.83333331346512, settings.text.ins, false, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], true, false)
    else
        Modules.UI.DrawTexts(0.21822917461395, 0.83333331346512, settings.text.out, false, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], false, false)
        Modules.UI.DrawTexts(0.1234375089407, 0.83333331346512, settings.text.ins, false, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], true, false)
    end


    cb(onPositionChange, math.round(X, 2), math.round(Y, 2))
end
function Modules.UI.DrawGrid(screenX, screenY, settings, cb)
    local onSelected = false
    local onPositionChange = false
    local X = screenX
    local Y = screenY

    local gridX = (Modules.posX * 1920) + Modules.posX / tw
    local gridY = (Modules.posY * 1080) + Modules.posY / th

    ---DevMode
    if settings.devmod ~= nil and settings.devmod == true then
        local x = GetControlNormal(0, 239)
        local y = GetControlNormal(0, 240)

        Modules.posX = x
        Modules.posY = y

        if IsControlJustReleased(0, 38) then
            TriggerEvent("addToCopy", x .. ", " .. y)
        end
    end

    if settings.grid == nil then
        settings.grid = 'default'
    end
    if settings.grid == "default" then
        Modules.UI.DrawSpriteNew("pause_menu_pages_char_mom_dad", "nose_grid", Modules.posX, Modules.posY, width, height, 0, 255, 255,
            255,
            255, {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)

            end)
    elseif settings.grid == "horizontal" then
        Modules.UI.DrawSpriteNew("barber", "horizontal_grid", Modules.posX, Modules.posY, width, height, 0, 255, 255,
            255,
            255, {
                NoHover = false,
                CustomHoverTexture = false,
                NoSelect = false,
                devmod = false
            }, function(onSelected, onHovered)

            end)
    end

    local w, h = Modules.UI.ConvertToPixel(20, 20)

    if Modules.UI.isMouseOnButton({ x = GetControlNormal(0, 239), y = GetControlNormal(0, 240) }, { x = gridX / 1920, y =
            gridY / 1080 }, width, height) then
        if IsDisabledControlPressed(0, 24) or IsControlPressed(0, 24) then
            onPositionChange = true
            if settings.grid ~= "horizontal" then
                CircleX = (GetControlNormal(0, 239) * 1920) + Modules.posX / tw
                CircleY = (GetControlNormal(0, 240) * 1080) + Modules.posY / th
                X = ((CircleX / 1920) / width) - (Modules.posX / width)
                Y = ((CircleY / 1080) / height) - (Modules.posY / height)
            else
                CircleX = (GetControlNormal(0, 239) * 1920) + Modules.posX / tw
                -- CircleY = (GetControlNormal(0, 240) * 1080) + posY / th
                X = ((CircleX / 1920) / width) - (Modules.posX / width)
                -- Y = ((CircleY / 1080) / height) - (posY / height)
            end
        end
        -- Modules.Sound.PlaySound(math.random(1, 99999), "FrontEnd/Navigate_one", false, 0.4)
    else
        onPositionChange = false
    end

    Modules.UI.DrawSpriteNew("mpinventory", "in_world_circle", CircleX / 1920 - w / 2, CircleY / 1080 - h / 2, w, h, 0,
        255, 255, 255, 255, {
            NoHover = true,
            CustomHoverTexture = false,
            NoSelect = true,
            devmod = false
        }, function(onSelected, onHovered)
            if onSelected then
            end
        end)


    --Text
    if settings.grid ~= "horizontal" then
        Modules.UI.DrawTexts(0.17135417461395, 0.74814814329147, settings.text.up, true, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], true, false)
        Modules.UI.DrawTexts(0.17187501490116, 0.92407405376434, settings.text.down, true, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], true, false)
        Modules.UI.DrawTexts(0.21822917461395, 0.83333331346512, settings.text.out, false, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], false, false)
        Modules.UI.DrawTexts(0.1234375089407, 0.83333331346512, settings.text.ins, false, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], true, false)
    else
        Modules.UI.DrawTexts(0.21822917461395, 0.83333331346512, settings.text.out, false, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], false, false)
        Modules.UI.DrawTexts(0.1234375089407, 0.83333331346512, settings.text.ins, false, 0.30, { 255, 255, 255, 255 },
            Modules.UI.font["Sunflower"], true, false)
    end


    cb(onPositionChange, math.round(X, 2), math.round(Y, 2))
end

function math.round(num, numDecimalPlaces)
    return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

Modules.UI.CacheSize = {}
function Modules.UI.CalculateCorrecteSizeForUI(ui_name, dict, sprite, maxX, maxY)
    if Modules.UI.CacheSize[ui_name] == nil then
        Modules.UI.CacheSize[ui_name] = {}
    end

    if Modules.UI.CacheSize[ui_name][dict..sprite] == nil then
        if HasStreamedTextureDictLoaded(dict) then
            local data = GetTextureResolution(dict, sprite)
            local x,y = Modules.UI.ConvertToPixel(data.x, data.y)
            Modules.UI.CacheSize[ui_name][dict..sprite] = {}
            Modules.UI.CacheSize[ui_name][dict..sprite].size = {x, y}
            Modules.UI.CacheSize[ui_name][dict..sprite].resizeDone = false
            local maxXsize, maxYsize = Modules.UI.ConvertToPixel(maxX, maxY)
            Modules.UI.CacheSize[ui_name][dict..sprite].maxSize = {maxXsize, maxYsize}
        else
            RequestStreamedTextureDict(dict, false)
        end
    end

    if Modules.UI.CacheSize[ui_name][dict..sprite] ~= nil then
        local self = Modules.UI.CacheSize[ui_name][dict..sprite]
        if not Modules.UI.CacheSize[ui_name][dict..sprite].resizeDone then
            if Modules.UI.CacheSize[ui_name][dict..sprite].size[1] > self.maxSize[1] then
                Modules.UI.CacheSize[ui_name][dict..sprite].size[1] = Modules.UI.CacheSize[ui_name][dict..sprite].size[1] / 1.1
                Modules.UI.CacheSize[ui_name][dict..sprite].size[2] = Modules.UI.CacheSize[ui_name][dict..sprite].size[2] / 1.1
            end

            if Modules.UI.CacheSize[ui_name][dict..sprite].size[2] > self.maxSize[2] then
                Modules.UI.CacheSize[ui_name][dict..sprite].size[2] = Modules.UI.CacheSize[ui_name][dict..sprite].size[2] / 1.1
                Modules.UI.CacheSize[ui_name][dict..sprite].size[1] = Modules.UI.CacheSize[ui_name][dict..sprite].size[1] / 1.1
            end

            if Modules.UI.CacheSize[ui_name][dict..sprite].size[1] <= self.maxSize[1] and Modules.UI.CacheSize[ui_name][dict..sprite].size[2] <= self.maxSize[2] then
                Modules.UI.CacheSize[ui_name][dict..sprite].resizeDone = true
            end
        end
    else
        return 0, 0, false
    end


    return Modules.UI.CacheSize[ui_name][dict..sprite].size[1], Modules.UI.CacheSize[ui_name][dict..sprite].size[2], Modules.UI.CacheSize[ui_name][dict..sprite].resizeDone
end