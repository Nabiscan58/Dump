GANG_GARAGE = {
    IsOpen = false,
    KnownVehicles = {},
 }

 function GANG_GARAGE.Open()
    if GANG_GARAGE.IsOpen then
        GANG_GARAGE.Close()
        return
    end

    local vehicles = Utils.TriggerServerCallback("gangs:garage:getAllVehicles", GANG_PLAYER.GangId)

    if vehicles then
        GANG_GARAGE.KnownVehicles = {}

        for _, vehicle in pairs(vehicles) do
            if vehicle.parts and vehicle.parts.plate then
                local cleanPlate = string.gsub(vehicle.parts.plate, "%s+", "")
                GANG_GARAGE.KnownVehicles[cleanPlate] = true
                print("[GANG GARAGE] Added to known vehicles from init: " .. cleanPlate)
            end

            if vehicle.isOut == 1 then
                local isValid = Utils.TriggerServerCallback('gangs:garage:isVehicleValid', GANG_PLAYER.GangId, vehicle.id)
                if not isValid then
                    Utils.TriggerServerCallback('gangs:garage:resetVehicleStatus', GANG_PLAYER.GangId, vehicle.id)
                end
            end
        end
        vehicles = Utils.TriggerServerCallback("gangs:garage:getAllVehicles", GANG_PLAYER.GangId)
    end

    local capacityInfo = Utils.TriggerServerCallback('gangs:garage:getCapacityInfo', GANG_PLAYER.GangId)
    local lastVehicle = nil
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        lastVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    else
        lastVehicle = GetVehiclePedIsIn(PlayerPedId(), true)
    end

    GANG_GARAGE.IsOpen = true

    -- Créer les menus (menu d'achat retiré)
    RMenu.Add('garage', 'main', RageUI.CreateMenu("Garage du Gang", "Gérer les véhicules du gang"))
    RMenu.Add('garage', 'store', RageUI.CreateSubMenu(RMenu:Get('garage', 'main'), "Stocker le Véhicule", "Stocker le véhicule actuel"))

    -- Définir le style pour tous les menus
    for _, menuName in pairs({ 'main', 'store' }) do
        RMenu:Get('garage', menuName):SetRectangleBanner(255, 220, 0, 140)
    end

    RageUI.Visible(RMenu:Get('garage', 'main'), true)
    RMenu:Get('garage', 'main').Closed = function()
        GANG_GARAGE.Close()
    end

    local plate = nil
    if lastVehicle and DoesEntityExist(lastVehicle) then
        plate = GetVehicleNumberPlateText(lastVehicle)
        if plate then
            plate = string.gsub(plate, "%s+", "")
        end
    end

    local isOwned = false
    if plate and plate ~= "" then
        isOwned = Utils.TriggerServerCallback('gangs:garage:isVehicleOwnedByGang', GANG_PLAYER.GangId, plate)
    end

    local displayName = GetDisplayNameFromVehicleModel(lastVehicle)
    local name = GetLabelText(displayName)
    
    if name == "NULL" or name == "" then
        name = displayName
    end

    Citizen.CreateThread(function()
        while GANG_GARAGE.IsOpen do
            RageUI.IsVisible(RMenu:Get('garage', 'main'), true, true, true, function()
                -- Afficher les informations de capacité en haut
                RageUI.Separator(string.format("Capacité du Garage : %d/%d", capacityInfo.current, capacityInfo.maximum))

                -- Section de stockage du véhicule
                if lastVehicle and DoesEntityExist(lastVehicle) then
                    local vehicleName = GANG_GARAGE.GetVehicleName(GetEntityModel(lastVehicle))
                    RageUI.Separator(" ~y~Stocker le Véhicule~s~ ")
                    RageUI.ButtonWithStyle("Stocker le Véhicule Actuel", "Modèle : " .. vehicleName, {
                        RightLabel = "»",
                     }, true, function(_, _, Selected)
                        if Selected then
                            local currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                            if not currentVehicle or currentVehicle == 0 then
                                Notify("error", "Vous devez être dans un véhicule")
                                return
                            end

                            local currentPlate = GetVehicleNumberPlateText(currentVehicle)
                            if currentPlate then
                                currentPlate = string.gsub(currentPlate, "%s+", "")
                            else
                                Notify("error", "Ce véhicule n'a pas de plaque")
                                return
                            end

                            print("[GANG GARAGE] Checking vehicle with plate: " .. tostring(currentPlate))

                            local currentlyOwned = false
                            if currentPlate and currentPlate ~= "" then
                                currentlyOwned = Utils.TriggerServerCallback('gangs:garage:isVehicleOwnedByGang', GANG_PLAYER.GangId, currentPlate)
                            end

                            if currentlyOwned or GANG_GARAGE.KnownVehicles[currentPlate] then
                                GANG_GARAGE.StoreVehicle(currentVehicle)

                                if GANG_GARAGE.KnownVehicles[currentPlate] then
                                    GANG_GARAGE.KnownVehicles[currentPlate] = nil
                                end

                                vehicles = Utils.TriggerServerCallback("gangs:garage:getAllVehicles", GANG_PLAYER.GangId)
                                capacityInfo = Utils.TriggerServerCallback('gangs:garage:getCapacityInfo', GANG_PLAYER.GangId)
                            else
                                Notify("error", "Vous ne pouvez pas stocker ce véhicule")
                            end
                        end
                    end)
                end

                -- Section des véhicules disponibles
                RageUI.Separator(" ~b~Véhicules Disponibles~s~ ")

                if vehicles and #vehicles > 0 then
                    for _, vehicle in pairs(vehicles) do
                        local vehicleName = GANG_GARAGE.GetVehicleName(vehicle.model)
                        local status = vehicle.isOut == 0 and "~y~Disponible" or "~r~En Sortie"

                        RageUI.ButtonWithStyle(vehicleName, "Modèle : " .. vehicleName .. "\nStatut : " .. (vehicle.isOut == 0 and "Disponible" or "En Sortie"), {
                            RightLabel = status .. "~s~ »",
                         }, vehicle.isOut == 0 or vehicle.isOut == false, function(_, Active, Selected)
                            if Selected then
                                GANG_GARAGE.SpawnVehicle(vehicle)
                                RageUI.CloseAll()
                                GANG_GARAGE.IsOpen = false
                            end

                            if Active then
                                SetTextFont(4)
                                SetTextScale(0.5, 0.5)
                                SetTextColour(255, 255, 255, 255)
                                SetTextCentre(true)
                                SetTextEntry("STRING")
                                AddTextComponentString(vehicleName .. "\nModèle : " .. vehicleName .. "\nStatut : " .. (vehicle.isOut == 0 and "Disponible" or "En Sortie"))
                                DrawText(0.5, 0.85)
                            end
                        end)
                    end
                else
                    RageUI.ButtonWithStyle("Aucun véhicule disponible", "Le gang n'a aucun véhicule", {}, false, function()
                    end)
                end
            end)

            Wait(0)
        end
    end)
end

function GANG_GARAGE.Close()
    GANG_GARAGE.IsOpen = false
    RageUI.CloseAll()
end

function GANG_GARAGE.StoreVehicle(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)

    if plate then
        plate = string.gsub(plate, "%s+", "")
    else
        Notify("error", "Ce véhicule n'a pas de plaque")
        return
    end

    print("[GANG GARAGE] Storing vehicle with plate: " .. plate)

    if GANG_GARAGE.KnownVehicles[plate] then
        GANG_GARAGE.KnownVehicles[plate] = nil
        print("[GANG GARAGE] Removed from known vehicles cache: " .. plate)
    end

    if GetNumModKits(vehicle) > 0 then
        SetVehicleModKit(vehicle, 0)
    end

    -- Get vehicle parts (mods)
    local parts = {
        plate = plate,
        mods = {},
        extras = {},
        colors = {
            primary = table.pack(GetVehicleColours(vehicle)),
            secondary = table.pack(GetVehicleExtraColours(vehicle)),
        },
        windowTint = GetVehicleWindowTint(vehicle),
        plateIndex = GetVehicleNumberPlateTextIndex(vehicle)
     }

    -- Get all mods

    for i = 0, 49 do
        parts.mods[i] = GetVehicleMod(vehicle, i)
    end
    --print("STORE : parts.mods" ..json.encode(parts.mods))
    -- Get extras
    for i = 0, 14 do
        if DoesExtraExist(vehicle, i) then
            parts.extras[i] = IsVehicleExtraTurnedOn(vehicle, i)
        end
    end

    -- Update server
    local success = Utils.TriggerServerCallback('gangs:garage:updatePartsByPlate', GANG_PLAYER.GangId, parts)
    if success then
        -- Get the vehicle ID based on plate first
        local vehicleData = Utils.TriggerServerCallback('gangs:garage:getVehicleByPlate', GANG_PLAYER.GangId, plate)

        -- Set vehicle as stored
        Utils.TriggerServerCallback('gangs:garage:updateStatusByPlate', GANG_PLAYER.GangId, parts, 0)

        -- Reset network ID tracking if we have the vehicle data
        if vehicleData and vehicleData.id then
            Utils.TriggerServerCallback('gangs:garage:resetVehicleStatus', GANG_PLAYER.GangId, vehicleData.id)
        end

        -- Delete vehicle
        DeleteEntity(vehicle)
        Notify("success", "Véhicule rangé dans le garage")
    else
        Notify("error", "Impossible de ranger le véhicule")
    end
end

--function GANG_GARAGE.SpawnVehicle(vehicleData)
--    -- First check if the vehicle is marked as out and validate its existence
--    if vehicleData.isOut == 1 then
--        local isValid = Utils.TriggerServerCallback('gangs:garage:isVehicleValid', GANG_PLAYER.GangId, vehicleData.id)
--        if not isValid then
--            -- If the vehicle is not valid, reset its status before spawning
--            Utils.TriggerServerCallback('gangs:garage:resetVehicleStatus', GANG_PLAYER.GangId, vehicleData.id)
--        else
--            Notify("error", "Ce véhicule est déjà sorti")
--            return
--        end
--    end
--    local isValid = Utils.TriggerServerCallback('gangs:garage:isVehicleValid', GANG_PLAYER.GangId, vehicleData.id)
--    if not isValid then
--        Utils.TriggerServerCallback('gangs:garage:resetVehicleStatus', GANG_PLAYER.GangId, vehicleData.id)
--    else
--        Notify("error", "Ce véhicule est déjà sorti")
--        return
--    end
--    local model = vehicleData.model
--    local parts = vehicleData.parts
--
--    RequestModel(model)
--    while not HasModelLoaded(model) do
--        Citizen.Wait(0)
--    end
--
--    local spawnPos = GANG_PLAYER.Data.vehiclePosition
--    local vehicle = CreateVehicle(model, spawnPos.x, spawnPos.y, spawnPos.z, GANG_PLAYER.Data.vehicleHeading, true, false)
--    SetEntityHeading(vehicle, GANG_PLAYER.Data.vehicleHeading)
--    SetVehicleOnGroundProperly(vehicle)
--    SetEntityAsMissionEntity(vehicle, true, true)
--    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
--    SetVehicleNeedsToBeHotwired(vehicle, false)
--    SetModelAsNoLongerNeeded(model)
--
--    -- Get network ID of the spawned vehicle
--    local netId = NetworkGetNetworkIdFromEntity(vehicle)
--
--    -- Set vehicle parts
--    if parts then
--        -- Set plate
--        if parts.plate then
--            SetVehicleNumberPlateText(vehicle, parts.plate)
--            local cleanPlate = string.gsub(parts.plate, "%s+", "")
--            GANG_GARAGE.KnownVehicles[cleanPlate] = true
--            print("[GANG GARAGE] Added vehicle to known vehicles: " .. cleanPlate)
--        else
--            local newParts = GANG_GARAGE.GetVehicleParts(vehicle)
--            Utils.TriggerServerCallback('gangs:garage:updateParts', GANG_PLAYER.GangId, vehicleData.id, newParts)
--            if newParts and newParts.plate then
--                local cleanPlate = string.gsub(newParts.plate, "%s+", "")
--                GANG_GARAGE.KnownVehicles[cleanPlate] = true
--                print("[GANG GARAGE] Added vehicle to known vehicles (new parts): " .. cleanPlate)
--            end
--        end
--
--        -- Set mods
--        if GetNumModKits(vehicle) > 0 then
--            SetVehicleModKit(vehicle, 0)
--        end
--
--        if parts.mods then
--            for modId, modValue in pairs(parts.mods) do
--                SetVehicleMod(vehicle, tonumber(modId), modValue, false)
--            end
--        end
--
--        -- Set colors
--        if parts.colors then
--            if parts.colors.primary then
--                SetVehicleColours(vehicle, table.unpack(parts.colors.primary))
--            end
--            if parts.colors.secondary then
--                SetVehicleExtraColours(vehicle, table.unpack(parts.colors.secondary))
--            end
--        end
--
--        -- Set extras
--        print("extras" ..json.encode(parts.extras))
--        if parts.extras then
--            for extraId, extraEnabled in pairs(parts.extras) do
--                SetVehicleExtra(vehicle, tonumber(extraId), not extraEnabled)
--            end
--        end
--    end
--
--    -- Update server with network ID
--    Utils.TriggerServerCallback('gangs:garage:setVehicleNetworkId', GANG_PLAYER.GangId, vehicleData.id, netId, model)
--
--    -- Put player in vehicle
--    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
--
--    Notify("success", "Véhicule sorti du garage")
--end

function GANG_GARAGE.SpawnVehicle(vehicleData)
    local model = vehicleData.model
    local parts = vehicleData.parts

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local pos = GANG_PLAYER.Data.vehiclePosition
    local heading = GANG_PLAYER.Data.vehicleHeading
    local vehicle = CreateVehicle(model, pos.x, pos.y, pos.z, heading, true, false)

    SetVehicleOnGroundProperly(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetEntityHeading(vehicle, heading)
    SetModelAsNoLongerNeeded(model)

    local netId = NetworkGetNetworkIdFromEntity(vehicle)

    if parts then
        -- Plaque
        if parts.plate then
            SetVehicleNumberPlateText(vehicle, parts.plate)
            GANG_GARAGE.KnownVehicles[parts.plate:gsub("%s+", "")] = true
        end

        -- ModKit
        if GetNumModKits(vehicle) > 0 then
            SetVehicleModKit(vehicle, 0)
        end

        -- Mods
        if parts.mods then
            for modId, modValue in pairs(parts.mods) do
                SetVehicleMod(vehicle, tonumber(modId), modValue, false)
            end
        end

        -- Extras
        if parts.extras then
            for extraId, state in pairs(parts.extras) do
                SetVehicleExtra(vehicle, tonumber(extraId), not state)
            end
        end

        -- Couleurs
        if parts.colors then
            if parts.colors.primary then
                SetVehicleColours(vehicle, table.unpack(parts.colors.primary))
            end
            if parts.colors.secondary then
                SetVehicleExtraColours(vehicle, table.unpack(parts.colors.secondary))
            end
        end

        -- Options custom
        ToggleVehicleMod(vehicle, 18, parts.turbo)
        ToggleVehicleMod(vehicle, 20, parts.tyreSmoke)
        ToggleVehicleMod(vehicle, 22, parts.xenon)

        if parts.neonColor then
            SetVehicleNeonLightsColour(vehicle, table.unpack(parts.neonColor))
        end
        if parts.neonEnabled then
            for i = 0, 3 do
                SetVehicleNeonLightEnabled(vehicle, i, parts.neonEnabled[i + 1])
            end
        end
        if parts.tyreSmokeColor then
            SetVehicleTyreSmokeColor(vehicle, table.unpack(parts.tyreSmokeColor))
        end

        -- Roues personnalisées
        if parts.wheelType then
            SetVehicleWheelType(vehicle, parts.wheelType)
        end
        if parts.mods[23] then
            SetVehicleMod(vehicle, 23, parts.mods[23], parts.customWheels)
        end
        if parts.windowTint then
            SetVehicleWindowTint(vehicle, parts.windowTint)
        end
        if parts.plateIndex then
            SetVehicleNumberPlateTextIndex(vehicle, parts.plateIndex)
        end
    end

    Utils.TriggerServerCallback('gangs:garage:setVehicleNetworkId', GANG_PLAYER.GangId, vehicleData.id, netId, model)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    Notify("success", "Véhicule sorti du garage")
end


function GANG_GARAGE.GetVehicleParts(vehicle)
    local parts = {
        plate = GetVehicleNumberPlateText(vehicle),
        mods = {},
        extras = {},
        colors = {
            primary = { GetVehicleColours(vehicle) },
            secondary = { GetVehicleExtraColours(vehicle) }
        },
        turbo = IsToggleModOn(vehicle, 18),
        tyreSmoke = IsToggleModOn(vehicle, 20),
        xenon = IsToggleModOn(vehicle, 22),
        windowTint = GetVehicleWindowTint(vehicle),
        neonColor = { GetVehicleNeonLightsColour(vehicle) },
        neonEnabled = {
            IsVehicleNeonLightEnabled(vehicle, 0),
            IsVehicleNeonLightEnabled(vehicle, 1),
            IsVehicleNeonLightEnabled(vehicle, 2),
            IsVehicleNeonLightEnabled(vehicle, 3)
        },
        tyreSmokeColor = { GetVehicleTyreSmokeColor(vehicle) },
        wheelType = GetVehicleWheelType(vehicle),
        customWheels = GetVehicleModVariation(vehicle, 23)
    }

    if GetNumModKits(vehicle) > 0 then
        SetVehicleModKit(vehicle, 0)
    end

    for i = 0, 49 do
        parts.mods[i] = GetVehicleMod(vehicle, i)
    end

    for i = 0, 14 do
        if DoesExtraExist(vehicle, i) then
            parts.extras[i] = IsVehicleExtraTurnedOn(vehicle, i)
        end
    end

    return parts
end


--function GANG_GARAGE.GetVehicleParts(vehicleEntity)
--    local parts = {
--        plate = GetVehicleNumberPlateText(vehicleEntity),
--        mods = {},
--        colors = {
--            primary = table.pack(GetVehicleColours(vehicleEntity)),
--            secondary = table.pack(GetVehicleExtraColours(vehicleEntity)),
--         },
--        extras = {},
--     }
--
--    -- Get all mods
--    for i = 0, 49 do
--        parts.mods[i] = GetVehicleMod(vehicleEntity, i)
--    end
--
--    -- Get extras
--    for i = 0, 14 do
--        if DoesExtraExist(vehicleEntity, i) then
--            parts.extras[i] = IsVehicleExtraTurnedOn(vehicleEntity, i)
--        end
--    end
--
--    return parts
--end

function GANG_GARAGE.GetVehicleName(model)
    if type(model) == "string" then
        model = GetHashKey(model)
    end
    
    local displayName = GetDisplayNameFromVehicleModel(model)
    local name = GetLabelText(displayName)
    
    if name == "NULL" or name == "" then
        name = displayName
    end
    
    return name
end