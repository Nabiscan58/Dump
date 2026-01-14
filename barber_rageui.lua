local barberMenuOpen = false
if RageUI then
    RageUI.PanelColour = RageUI.PanelColour or {}

    if not RageUI.PanelColour.HairCut then
        RageUI.PanelColour.HairCut = {}
        for i = 0, 63 do
            local shade = math.floor((i / 63) * 255)
            RageUI.PanelColour.HairCut[#RageUI.PanelColour.HairCut + 1] = { shade, shade, shade, 255 }
        end
    end

    RageUI.PanelColour.Makeup = RageUI.PanelColour.Makeup or RageUI.PanelColour.HairCut
    RageUI.PanelColour.Lipstick = RageUI.PanelColour.Lipstick or RageUI.PanelColour.Makeup
    RageUI.PanelColour.Blush = RageUI.PanelColour.Blush or RageUI.PanelColour.Makeup
end

local barberPaid = false

local barberRageData = nil
local barberRagePrices = nil
local barberOriginalValues = {}
local barberCurrentValues = {}

local barberUsingBusiness = false
local barberBusinessClientId = nil

local barberMainMenu = nil
local barberHairMenu = nil
local barberBeardMenu = nil
local barberEyesMenu = nil
local barberMakeupMenu = nil
local barberFadesMenu = nil

local c1 = barberCurrentValues["hair_color_1"] or 0
local c2 = barberCurrentValues["hair_color_2"] or 0

local barberListCache = {}
local barberPayMethodIndex = 1

local function Barber_ResetState()
    barberMenuOpen = false
    barberPaid = false
    barberRageData = nil
    barberRagePrices = nil
    barberOriginalValues = {}
    barberCurrentValues = {}
    barberUsingBusiness = false
    barberBusinessClientId = nil
    barberListCache = {}
end

local function Barber_CreateCamRageUI(clientId)
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
    local playerPed = clientId and GetPlayerPed(GetPlayerFromServerId(tonumber(clientId))) or PlayerPedId()
    heading = GetEntityHeading(playerPed) - 225.0
    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)
    changeCam(playerPed)
end

local function Barber_DeleteCamRageUI(isOwnerBarber)
    CLIENT_ID = nil
    CLIENT_PED = nil
    if cam then
        SetCamActive(cam, false)
        RenderScriptCams(false, true, 500, true, true)
        DestroyCam(cam, true)
        cam = nil
    end
    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FREEMODE_SOUNDSET", true)
    if not isOwnerBarber and Ped then
        DeletePed(Ped)
        Ped = nil
    end
    if isOwnerBarber and Config.Barbers[barberId] and Config.Barbers[barberId].Chairs and Config.Barbers[barberId].Chairs[chairId] then
        local coords = Config.Barbers[barberId].Chairs[chairId].position
        SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z)
    end
    heading = 0.0
    if barberId and chairId then
        TriggerServerEvent("vms_barber:sv:takeChair", barberId, chairId, false)
    end
    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasks(PlayerPedId())
    barberId = nil
    CURRENT_CHAIR = nil
    if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
        exports[Config.VMSTattooshopName]:reloadPlayerTattoos()
    end
end

local function Barber_RevertSkin()
    if Config.Core == "ESX" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
            unloadPlayerProps()
        end)
    elseif Config.Core == "QB-Core" then
        if Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
            TriggerEvent(Config.SkinManager .. ':client:reloadSkin')
        elseif Config.SkinManager == "qb-clothing" then
            TriggerServerEvent("qb-clothes:loadPlayerSkin")
            TriggerServerEvent("qb-clothing:loadPlayerSkin")
        end
        unloadPlayerProps()
    end
end

local function Barber_CloneData(data)
    barberOriginalValues = {}
    barberCurrentValues = {}
    barberListCache = {}

    for name, v in pairs(data) do
        local value = v.value
        barberOriginalValues[name] = value
        barberCurrentValues[name] = value
    end
end

local styleOpacityMap = {
    beard_1 = "beard_2",
    eyebrows_1 = "eyebrows_2",
    makeup_1 = "makeup_2",
    lipstick_1 = "lipstick_2",
    blush_1 = "blush_2"
}

local function Barber_SetComponent(key, value)
    if not barberRageData or not barberRageData[key] then
        return
    end

    local comp = barberRageData[key]
    if comp.min ~= nil and value < comp.min then
        value = comp.min
    end
    if comp.max ~= nil and value > comp.max then
        value = comp.max
    end
    if barberCurrentValues[key] == value then
        return
    end

    barberCurrentValues[key] = value
    comp.value = value

    if barberUsingBusiness and barberBusinessClientId then
        TriggerServerEvent("vms_barber:sv:updateClientSkin", barberBusinessClientId, key, value)
        return
    end

    if Config.SkinManager == "esx_skin" then
        Character_ESX[key] = value
        TriggerEvent('skinchanger:change', tostring(key), tonumber(value))
        unloadPlayerProps()
    elseif Config.SkinManager == "fivem-appearance" or Config.SkinManager == "illenium-appearance" then
        appearance_switcher(key, value)
    elseif Config.SkinManager == "qb-clothing" then
        if Character_QB then
            Character_QB[key] = value
        end
        TriggerEvent('skinchanger:change', tostring(key), tonumber(value))
        unloadPlayerProps()
    end

    local opacityKey = styleOpacityMap[key]
    if opacityKey and value and value > 0 and barberRageData[opacityKey] then
        local opComp = barberRageData[opacityKey]
        local opMin = opComp.min or 0
        local opMax = opComp.max or 10
        local opCur = barberCurrentValues[opacityKey] or opComp.value or opMin

        if opCur <= opMin then
            Barber_SetComponent(opacityKey, opMax)
        end
    end
end

local function Barber_BuildDiff()
    local diff = {}
    for k, v in pairs(barberOriginalValues) do
        local cur = barberCurrentValues[k]
        if cur == nil then
            cur = v
        end
        if tonumber(v) ~= tonumber(cur) then
            diff[k] = { default = v, value = cur }
        end
    end
    return diff
end

local function Barber_ComputePrice()
    if not barberRagePrices or not barberId then
        return 0, 0, {}
    end
    local barberData = Config.Barbers[barberId]
    if not barberData then
        return 0, 0, {}
    end

    local totalPrice = 0
    local taxAmount = 0
    local values = {}
    local diff = Barber_BuildDiff()

    if Config.UseVMSCityHall and Config.UseCityHallTaxes then
        for name, _ in pairs(diff) do
            if barberData.prices[name] then
                values[name] = barberData.prices[name].totalAmount
                totalPrice = totalPrice + barberData.prices[name].totalAmount
                taxAmount = taxAmount + barberData.prices[name].taxAmount
            end
        end
        if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
            for k, _ in pairs(currentTattoos) do
                if barberData.prices['hair_fade'] then
                    values['fade:' .. k] = barberData.prices['hair_fade'].totalAmount
                    totalPrice = totalPrice + barberData.prices['hair_fade'].totalAmount
                    taxAmount = taxAmount + barberData.prices['hair_fade'].totalAmount
                end
            end
        end
    else
        for name, _ in pairs(diff) do
            if barberData.prices[name] then
                values[name] = barberData.prices[name].price
                totalPrice = totalPrice + barberData.prices[name].price
            end
        end
        if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
            for k, _ in pairs(currentTattoos) do
                if barberData.prices['hair_fade'] then
                    values['fade:' .. k] = barberData.prices['hair_fade'].price
                    totalPrice = totalPrice + barberData.prices['hair_fade'].price
                end
            end
        end
    end

    return totalPrice, taxAmount, values
end

local function Barber_DrawSlider(label, key)
    if not barberRageData or not barberRageData[key] then
        return
    end
    local comp = barberRageData[key]
    local cur = barberCurrentValues[key] or comp.value or 0
    local max = comp.max or 0
    local min = comp.min or 0
    local right = tostring(cur) .. " / " .. tostring(max)
    RageUI.ButtonWithStyle(label, nil, { RightLabel = right }, true, function(Hovered, Active, Selected)
        if Active then
            if IsControlJustPressed(0, 174) then
                Barber_SetComponent(key, cur - 1)
            elseif IsControlJustPressed(0, 175) then
                Barber_SetComponent(key, cur + 1)
            end
        end
    end)
end

local function Barber_DrawList(label, key)
    if not barberRageData or not barberRageData[key] then
        return
    end
    local comp = barberRageData[key]
    local min = comp.min or 0
    local max = comp.max or 0
    if max < min then
        max = min
    end

    if not barberListCache[key] or barberListCache[key].min ~= min or barberListCache[key].max ~= max then
        local items = {}
        for i = min, max do
            items[#items + 1] = tostring(i)
        end
        barberListCache[key] = {
            items = items,
            min = min,
            max = max
        }
    end

    local cache = barberListCache[key]
    local cur = barberCurrentValues[key] or comp.value or min
    if cur < cache.min then
        cur = cache.min
    end
    if cur > cache.max then
        cur = cache.max
    end
    local index = (cur - cache.min) + 1

    RageUI.List(label, cache.items, index, nil, {}, true, function(Hovered, Active, Selected, Index)
        if Index ~= index then
            local newValue = cache.min + (Index - 1)
            Barber_SetComponent(key, newValue)
        end

        if not Active then
            return
        end

        if key == "hair_1" then
            local palette = RageUI.PanelColour.HairCut
            local maxColors = #palette

            local hairColor1 = (barberCurrentValues["hair_color_1"] or 0) + 1
            local hairColor2 = (barberCurrentValues["hair_color_2"] or 0) + 1

            if hairColor1 < 1 then
                hairColor1 = 1
            end
            if hairColor1 > maxColors then
                hairColor1 = maxColors
            end
            if hairColor2 < 1 then
                hairColor2 = 1
            end
            if hairColor2 > maxColors then
                hairColor2 = maxColors
            end

            RageUI.ColourPanel("Couleur principale", palette, 1, hairColor1, function(_, _, _, CurrentIndex)
                Barber_SetComponent("hair_color_1", CurrentIndex - 1)
            end)

            RageUI.ColourPanel("Reflets", palette, 1, hairColor2, function(_, _, _, CurrentIndex)
                Barber_SetComponent("hair_color_2", CurrentIndex - 1)
            end)

        elseif key == "beard_1" or key == "eyebrows_1" then
            local palette = RageUI.PanelColour.HairCut
            local maxColors = #palette

            local beardColor = (barberCurrentValues["beard_3"] or 0) + 1
            local browColor = (barberCurrentValues["eyebrows_3"] or 0) + 1

            if beardColor < 1 then
                beardColor = 1
            end
            if beardColor > maxColors then
                beardColor = maxColors
            end
            if browColor < 1 then
                browColor = 1
            end
            if browColor > maxColors then
                browColor = maxColors
            end

            RageUI.ColourPanel("Couleur barbe", palette, 1, beardColor, function(_, _, _, CurrentIndex)
                Barber_SetComponent("beard_3", CurrentIndex - 1)
            end)

            RageUI.ColourPanel("Couleur sourcils", palette, 1, browColor, function(_, _, _, CurrentIndex)
                Barber_SetComponent("eyebrows_3", CurrentIndex - 1)
            end)

        elseif key == "makeup_1" then
            local palette = RageUI.PanelColour.Makeup
            local maxColors = #palette

            local m1 = (barberCurrentValues["makeup_3"] or 0) + 1
            local m2 = (barberCurrentValues["makeup_4"] or 0) + 1

            if m1 < 1 then
                m1 = 1
            end
            if m1 > maxColors then
                m1 = maxColors
            end
            if m2 < 1 then
                m2 = 1
            end
            if m2 > maxColors then
                m2 = maxColors
            end

            RageUI.ColourPanel("Maquillage 1", palette, 1, m1, function(_, _, _, CurrentIndex)
                Barber_SetComponent("makeup_3", CurrentIndex - 1)
            end)

            RageUI.ColourPanel("Maquillage 2", palette, 1, m2, function(_, _, _, CurrentIndex)
                Barber_SetComponent("makeup_4", CurrentIndex - 1)
            end)

        elseif key == "lipstick_1" then
            local palette = RageUI.PanelColour.Lipstick
            local maxColors = #palette

            local lips = (barberCurrentValues["lipstick_3"] or 0) + 1
            if lips < 1 then
                lips = 1
            end
            if lips > maxColors then
                lips = maxColors
            end

            RageUI.ColourPanel("Couleur lèvres", palette, 1, lips, function(_, _, _, CurrentIndex)
                Barber_SetComponent("lipstick_3", CurrentIndex - 1)
            end)

        elseif key == "blush_1" then
            local palette = RageUI.PanelColour.Blush
            local maxColors = #palette

            local blush = (barberCurrentValues["blush_3"] or 0) + 1
            if blush < 1 then
                blush = 1
            end
            if blush > maxColors then
                blush = maxColors
            end

            RageUI.ColourPanel("Couleur blush", palette, 1, blush, function(_, _, _, CurrentIndex)
                Barber_SetComponent("blush_3", CurrentIndex - 1)
            end)
        end
    end)
end

local function Barber_DrawOpacity(label, key)
    if not barberRageData or not barberRageData[key] then
        return
    end

    local comp = barberRageData[key]
    local min = comp.min or 0
    local max = comp.max or 10
    if max < min then
        max = min
    end

    local cur = barberCurrentValues[key]
    if cur == nil then
        cur = comp.value or max
    end
    if cur < min then
        cur = min
    end
    if cur > max then
        cur = max
    end

    local steps = max - min + 1
    local sliderIndex = (cur - min) + 1

    local percent = 0
    if max ~= min then
        percent = math.floor(((cur - min) / (max - min)) * 100)
    end
    if percent < 0 then
        percent = 0
    end
    if percent > 100 then
        percent = 100
    end

    RageUI.Slider(label, sliderIndex, steps, tostring(percent) .. "%", false, {}, true, function(Hovered, Active, Selected, value)
        if not Active then
            return
        end

        if value < 1 then
            value = 1
        end
        if value > steps then
            value = steps
        end

        local newVal = min + (value - 1)
        if newVal ~= cur then
            Barber_SetComponent(key, newVal)
        end
    end)
end

local function Barber_DrawFades()
    if not Config.UseVMSTattooshop or not Config.UseHairFadeInBarber then
        return
    end
    if not CURRENT_FADES_LIST then
        return
    end
    for id, data in pairs(CURRENT_FADES_LIST) do
        local label = data.label or ("Fade " .. tostring(id))
        local checked = Character_Temp_Tattoos[tostring(id)] == true
        RageUI.Checkbox(label, nil, checked, {}, function(Hovered, Active, Selected, Checked)
            if not Selected then
                return
            end
            if barberUsingBusiness and barberBusinessClientId then
                TriggerServerEvent("vms_barber:sv:updateClientTattoos", barberBusinessClientId, id)
                return
            end
            if Checked then
                if Character_Temp_Tattoos[tostring(id)] then
                    Character_Temp_Tattoos[tostring(id)] = false
                    currentTattoos[tostring(id)] = true
                    if not CURRENT_FADES_LIST[tonumber(id)].hasTattoo then
                        currentTattoos[tostring(id)] = nil
                    end
                else
                    Character_Temp_Tattoos[tostring(id)] = true
                end
            else
                currentTattoos[tostring(id)] = nil
                if CURRENT_FADES_LIST[tonumber(id)] and CURRENT_FADES_LIST[tonumber(id)].hasTattoo then
                    Character_Temp_Tattoos[tostring(id)] = true
                    currentTattoos[tostring(id)] = nil
                else
                    Character_Temp_Tattoos[tostring(id)] = false
                end
            end

            exports[Config.VMSTattooshopName]:reloadPlayerTattoosByBarber(Character_Temp_Tattoos, function()
                if CURRENT_FADES_LIST[tonumber(id)] then
                    if CURRENT_FADES_LIST[tonumber(id)].hasTattoo then
                        if Character_Temp_Tattoos[tostring(id)] then
                            currentTattoos[tostring(id)] = nil
                        end
                    else
                        if Character_Temp_Tattoos[tostring(id)] then
                            currentTattoos[tostring(id)] = true
                        end
                    end
                end
            end)
        end)
    end
end

local function Barber_Pay(payType)
    local totalPrice, taxAmount, values = Barber_ComputePrice()
    if totalPrice <= 0 then
        CL.Notification("Aucun changement à payer.", 3000, "error")
        return
    end

    if barberUsingBusiness and barberBusinessClientId and payType == "receipt" then
        TriggerServerEvent("vms_barber:sv:buyClientReceipt", barberBusinessClientId, barberId, true, values, totalPrice, taxAmount)
        CL.Notification("Facture envoyée au client.", 3000, "success")
        return
    end

    if barberUsingBusiness and barberBusinessClientId then
        CL.Notification("Paiement direct désactivé en mode client, utilise la facture.", 3000, "error")
        return
    end

    if Config.Core == "ESX" then
        ESX.TriggerServerCallback("vms_barber:getMoney", function(success, callbackAmount)
            if success then
                currentTattoos = {}
                if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
                    CURRENT_FADES_LIST = exports[Config.VMSTattooshopName]:GetHairFadesList()
                    for k, v in pairs(CURRENT_FADES_LIST) do
                        if v.hasTattoo then
                            Character_Temp_Tattoos[tostring(k)] = true
                        end
                    end
                end
                barberPaid = true
                CL.Notification(TRANSLATE("notify.paid", callbackAmount), 3500, "success")
                if CURRENT_BARBER and CURRENT_BARBER.barber and Ped then
                    FreezeEntityPosition(Ped, false)
                    loadAnimDict(Config.AnimDict)
                    TaskPlayAnim(Ped, Config.AnimDict, Config.Anim, 8.0, 8.0, 15000, 0, 0, -1, -1, -1)
                end
                if Config.SkinManager == "esx_skin" then
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        TriggerServerEvent('esx_skin:save', skin)
                    end)
                elseif Config.SkinManager == "fivem-appearance" then
                    local playerPed = PlayerPedId()
                    local appearance = exports[Config.SkinManager]:getPedAppearance(playerPed)
                    TriggerServerEvent('fivem-appearance:save', appearance)
                elseif Config.SkinManager == "illenium-appearance" then
                    local playerPed = PlayerPedId()
                    local appearance = exports[Config.SkinManager]:getPedAppearance(playerPed)
                    TriggerServerEvent('illenium-appearance:server:saveAppearance', appearance)
                end
                unloadPlayerProps()
                RageUI.CloseAll()
                Barber_DeleteCamRageUI(false)
                Barber_ResetState()
            else
                CL.Notification(TRANSLATE("notify.nomoney"), 3500, "error")
            end
        end, totalPrice, payType, currentTattoos)
    elseif Config.Core == "QB-Core" then
        QBCore.Functions.TriggerCallback('vms_barber:getMoney', function(success, callbackAmount)
            if success then
                currentTattoos = {}
                if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
                    CURRENT_FADES_LIST = exports[Config.VMSTattooshopName]:GetHairFadesList()
                    for k, v in pairs(CURRENT_FADES_LIST) do
                        if v.hasTattoo then
                            Character_Temp_Tattoos[tostring(k)] = true
                        end
                    end
                end
                barberPaid = true
                CL.Notification(TRANSLATE("notify.paid", callbackAmount), 3500, "success")
                unloadPlayerProps()
                RageUI.CloseAll()
                Barber_DeleteCamRageUI(false)
                Barber_ResetState()
            else
                CL.Notification(TRANSLATE("notify.nomoney"), 3500, "error")
            end
        end, totalPrice, payType, currentTattoos)
    end
end

function OpenBarberRageMenu(payload, isBusiness, clientId)
    if barberMenuOpen then
        return
    end

    barberMenuOpen = true
    barberPaid = false
    barberUsingBusiness = isBusiness or false
    barberBusinessClientId = clientId

    barberRageData = payload.data or {}
    barberRagePrices = payload.prices or {}

    Barber_CloneData(barberRageData)

    if payload.hairFades then
        CURRENT_FADES_LIST = payload.hairFades
    end
    if payload.tempTattoos then
        Character_Temp_Tattoos = payload.tempTattoos
    end

    if isBusiness and clientId then
        CLIENT_ID = clientId
        CLIENT_PED = GetPlayerFromServerId(clientId)
    end

    Barber_CreateCamRageUI(clientId)

    if RageUI and RageUI.Settings and RageUI.Settings.Controls and RageUI.Settings.Controls.Mouse then
        RageUI.Settings.Controls.Mouse.Enabled = true
    end

    if RMenu['barber'] then
        for name, menu in pairs(RMenu['barber']) do
            RMenu:Delete('barber', name)
        end
    end

    RMenu.Add('barber', 'main', RageUI.CreateMenu("Barber", "Personnalisation", 1375, 100))
    RMenu.Add('barber', 'hair', RageUI.CreateSubMenu(RMenu:Get('barber', 'main'), "Cheveux", "Coupe et couleurs"))
    RMenu.Add('barber', 'beard', RageUI.CreateSubMenu(RMenu:Get('barber', 'main'), "Barbe & sourcils", "Pilosis facialis"))
    RMenu.Add('barber', 'eyes', RageUI.CreateSubMenu(RMenu:Get('barber', 'main'), "Yeux", "Regard"))
    if Config.CanMakeup then
        RMenu.Add('barber', 'makeup', RageUI.CreateSubMenu(RMenu:Get('barber', 'main'), "Maquillage", "Détails"))
    end
    if Config.UseVMSTattooshop and Config.UseHairFadeInBarber then
        RMenu.Add('barber', 'fades', RageUI.CreateSubMenu(RMenu:Get('barber', 'main'), "Fades", "Dégradés"))
    end

    barberMainMenu = RMenu:Get('barber', 'main')
    barberHairMenu = RMenu:Get('barber', 'hair')
    barberBeardMenu = RMenu:Get('barber', 'beard')
    barberEyesMenu = RMenu:Get('barber', 'eyes')
    barberMakeupMenu = Config.CanMakeup and RMenu:Get('barber', 'makeup') or nil
    barberFadesMenu = (Config.UseVMSTattooshop and Config.UseHairFadeInBarber) and RMenu:Get('barber', 'fades') or nil

    barberMainMenu:SetRectangleBanner(10, 10, 10, 200)
    barberHairMenu:SetRectangleBanner(10, 10, 10, 200)
    barberBeardMenu:SetRectangleBanner(10, 10, 10, 200)
    barberEyesMenu:SetRectangleBanner(10, 10, 10, 200)
    if barberMakeupMenu then
        barberMakeupMenu:SetRectangleBanner(10, 10, 10, 200)
    end
    if barberFadesMenu then
        barberFadesMenu:SetRectangleBanner(10, 10, 10, 200)
    end

    barberHairMenu.EnableMouse = true
    barberHairMenu.EnableControls = true

    barberBeardMenu.EnableMouse = true
    barberBeardMenu.EnableControls = true

    if barberMakeupMenu then
        barberMakeupMenu.EnableMouse = true
        barberMakeupMenu.EnableControls = true
    end

    barberMainMenu.Closed = function()
        if not barberPaid then
            Barber_RevertSkin()
        end
        Barber_DeleteCamRageUI(false)
        Barber_ResetState()
        if RageUI and RageUI.Settings and RageUI.Settings.Controls and RageUI.Settings.Controls.Mouse then
            RageUI.Settings.Controls.Mouse.Enabled = false
        end
    end

    RageUI.CloseAll()
    RageUI.Visible(barberMainMenu, true)

    Citizen.CreateThread(function()
        while barberMenuOpen do
            Citizen.Wait(1)

            RageUI.IsVisible(barberMainMenu, true, true, true, function()
                RageUI.ButtonWithStyle("Cheveux", nil, {}, true, function(Hovered, Active, Selected) end, barberHairMenu)
                RageUI.ButtonWithStyle("Barbe & sourcils", nil, {}, true, function(Hovered, Active, Selected) end, barberBeardMenu)
                RageUI.ButtonWithStyle("Yeux", nil, {}, true, function(Hovered, Active, Selected) end, barberEyesMenu)
                if Config.CanMakeup and barberMakeupMenu then
                    RageUI.ButtonWithStyle("Maquillage", nil, {}, true, function(Hovered, Active, Selected) end, barberMakeupMenu)
                end
                if barberFadesMenu then
                    RageUI.ButtonWithStyle("Fades", nil, {}, true, function(Hovered, Active, Selected) end, barberFadesMenu)
                end

                RageUI.Separator("")

                local totalPrice, taxAmount, values = Barber_ComputePrice()
                if barberUsingBusiness and barberBusinessClientId then
                    RageUI.ButtonWithStyle("Créer une facture", "Envoie une facture au client.", { RightLabel = "~g~" .. tostring(totalPrice) .. "$" }, totalPrice > 0, function(Hovered, Active, Selected)
                        if Selected then
                            Barber_Pay("receipt")
                        end
                    end)
                else
                    local items = { "Liquide", "Banque" }
                    RageUI.List("Payer", items, barberPayMethodIndex, nil, { RightLabel = "~g~" .. tostring(totalPrice) .. "$" }, totalPrice > 0, function(Hovered, Active, Selected, Index)
                        barberPayMethodIndex = Index
                        if Selected then
                            if Index == 1 then
                                Barber_Pay("cash")
                            else
                                Barber_Pay("bank")
                            end
                        end
                    end)
                end
            end)

            RageUI.IsVisible(barberHairMenu, true, true, true, function()
                Barber_DrawList("Coupe", "hair_1")
                Barber_DrawList("Variation", "hair_2")
            end)

            RageUI.IsVisible(barberBeardMenu, true, true, true, function()
                Barber_DrawList("Style de barbe", "beard_1")
                Barber_DrawOpacity("Opacité barbe", "beard_2")
                Barber_DrawList("Sourcils", "eyebrows_1")
                Barber_DrawOpacity("Opacité sourcils", "eyebrows_2")
            end)

            RageUI.IsVisible(barberEyesMenu, true, true, true, function()
                Barber_DrawList("Couleur des yeux", "eye_color")
            end)

            if barberMakeupMenu then
                RageUI.IsVisible(barberMakeupMenu, true, true, true, function()
                    Barber_DrawList("Maquillage", "makeup_1")
                    Barber_DrawOpacity("Opacité maquillage", "makeup_2")
                    Barber_DrawList("Rouge à lèvres", "lipstick_1")
                    Barber_DrawOpacity("Opacité lèvres", "lipstick_2")
                    Barber_DrawList("Blush", "blush_1")
                    Barber_DrawOpacity("Opacité blush", "blush_2")
                end)
            end

            if barberFadesMenu then
                RageUI.IsVisible(barberFadesMenu, true, true, true, function()
                    Barber_DrawFades()
                end)
            end
        end
    end)
end