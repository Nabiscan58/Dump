GANG_PLAYER = {}
GANG_PLAYER.GangId = nil
GANG_PLAYER.Rank = nil
GANG_PLAYER.Data = {}

Citizen.CreateThread(function()
    TriggerServerEvent("orgsystem:playerLoaded")
    Wait(1000)
    local data = Utils.TriggerServerCallback("gangs:members:getPlayerGang")
    if data then
        GANG_PLAYER.GangId = data.gangId
        GANG_PLAYER.Rank = data.rank
        GANG_PLAYER.Data = Utils.TriggerServerCallback("gangs:logic:getGangData", GANG_PLAYER.GangId)
    end
end)

local function GetPlayerGangName()
    if GANG_PLAYER and GANG_PLAYER.Data and GANG_PLAYER.Data.name then
        return GANG_PLAYER.Data.name
    else
        return nil
    end
end

local function getGangId()
    if GANG_PLAYER and GANG_PLAYER.Data and GANG_PLAYER.Data.id then
        return GANG_PLAYER.Data.id
    else
        return nil
    end
end

exports('getGangName', function()
    return GetPlayerGangName()
end)

exports('getGangId', function()
    return getGangId()
end)

RegisterNetEvent("orgsystem:reset", function()
    GANG_PLAYER.GangId = nil
    GANG_PLAYER.Rank = 0
    GANG_PLAYER.Data = {}
end)

RegisterNetEvent("orgsystem:gangUpdated", function(personnalData, data)
    GANG_PLAYER.GangId = personnalData.gangId
    GANG_PLAYER.Rank = personnalData.rank
    GANG_PLAYER.Data = data

    local vhs = {}
    local gangType = GANG_PLAYER.Data.groupType or "Gang"
    local availableVehicles = GarageConfig[gangType] and GarageConfig[gangType].vehicles or {}

    for _, vehicle in ipairs(availableVehicles) do
        if vehicle.model and vehicle.label then
            table.insert(vhs, {
                name = vehicle.model,    -- Utilisé pour le spawn
                label = vehicle.label,   -- Nom affiché dans le menu
                price = vehicle.price or 0 -- Prix du véhicule (par défaut à 0 si non défini)
            })
        end
    end
end)

RegisterNetEvent("orgsystem:removedFromGang", function()
    GANG_PLAYER.GangId = nil
    GANG_PLAYER.Rank = nil
    GANG_PLAYER.Data = {}

    if GANG_GARAGE_SELLER.IsOpen then GANG_GARAGE_SELLER.Close() end
    if GANG_MEMBERS.IsOpen then GANG_MEMBERS.Close() end
    if GANG_MONEY.IsOpen then GANG_MONEY.Close() end

    Notify("info", "Vous avez été retiré de votre gang")
end)

RegisterNetEvent("orgsystem:recruitedToGang", function(gangName)
    Notify("success", string.format("Vous avez été recruté dans %s !", gangName))
end)

exports("GetGroupColor", function()
    return {GANG_PLAYER.Data.groupColor.r, GANG_PLAYER.Data.groupColor.g, GANG_PLAYER.Data.groupColor.b}
end)

Citizen.CreateThread(function()
    while true do
        if GANG_PLAYER.GangId == nil then
            Wait(500)
        else
            local pPed = PlayerPedId()
            local isNearLocation = false

            if GANG_PLAYER.Data.chestPosition then
                if Utils.IsPedInDistance(pPed, GANG_PLAYER.Data.chestPosition, 30.0) then
                    isNearLocation = true
                    DrawMarker(Config.MarkerTypes.chest, GANG_PLAYER.Data.chestPosition.x, GANG_PLAYER.Data.chestPosition.y, GANG_PLAYER.Data.chestPosition.z - 0.65, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.50, 0.50, 0.50, GANG_PLAYER.Data.groupColor.r, GANG_PLAYER.Data.groupColor.g, GANG_PLAYER.Data.groupColor.b, 140, false, true, 2, false, nil, nil, false)
				    DrawMarker(6, GANG_PLAYER.Data.chestPosition.x, GANG_PLAYER.Data.chestPosition.y, GANG_PLAYER.Data.chestPosition.z - 1.0, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)

                    if Utils.IsPedInDistance(pPed, GANG_PLAYER.Data.chestPosition, 2.0) then
                        Utils.ShowDisplayHelp('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le coffre du gang', false, false, 0, -1)

                        if IsControlJustPressed(0, 38) then
                            GANG_MONEY.Open()
                        end
                    else
                        if GANG_MONEY.IsOpen then
                            GANG_MONEY.Close()
                        end
                    end
                end
            end

            if GANG_PLAYER.Data.armoryPosition then
                if Utils.IsPedInDistance(pPed, GANG_PLAYER.Data.armoryPosition, 30.0) then
                    isNearLocation = true
                    DrawMarker(Config.MarkerTypes.armory, GANG_PLAYER.Data.armoryPosition.x, GANG_PLAYER.Data.armoryPosition.y, GANG_PLAYER.Data.armoryPosition.z - 0.65, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.50, 0.50, 0.50, GANG_PLAYER.Data.groupColor.r, GANG_PLAYER.Data.groupColor.g, GANG_PLAYER.Data.groupColor.b, 140, false, true, 2, false, nil, nil, false)
				    DrawMarker(6, GANG_PLAYER.Data.armoryPosition.x, GANG_PLAYER.Data.armoryPosition.y, GANG_PLAYER.Data.armoryPosition.z - 1.0, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)

                    if Utils.IsPedInDistance(pPed, GANG_PLAYER.Data.armoryPosition, 2.0) then
                        Utils.ShowDisplayHelp('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir l\'armurerie du gang', false, false, 0, -1)

                        if IsControlJustPressed(0, 38) then
                            OpenGangNUI()
                            -- GANG_MEMBERS.Open()
                        end
                    else
                        if GANG_MEMBERS.IsOpen then
                            GANG_MEMBERS.Close()
                        end
                    end
                end
            end

            if GANG_PLAYER.Data.vehiclePosition then
                if Utils.IsPedInDistance(pPed, GANG_PLAYER.Data.vehiclePosition, 30.0) then
                    isNearLocation = true
                    DrawMarker(Config.MarkerTypes.vehicle, GANG_PLAYER.Data.vehiclePosition.x, GANG_PLAYER.Data.vehiclePosition.y, GANG_PLAYER.Data.vehiclePosition.z - 0.65, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.50, 0.50, 0.50, GANG_PLAYER.Data.groupColor.r, GANG_PLAYER.Data.groupColor.g, GANG_PLAYER.Data.groupColor.b, 140, false, true, 2, false, nil, nil, false)
                    DrawMarker(6, GANG_PLAYER.Data.vehiclePosition.x, GANG_PLAYER.Data.vehiclePosition.y, GANG_PLAYER.Data.vehiclePosition.z - 1.0, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)

                    if Utils.IsPedInDistance(pPed, GANG_PLAYER.Data.vehiclePosition, 2.0) then
                        Utils.ShowDisplayHelp('Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le garage du gang', false, false, 0, -1)

                        if IsControlJustPressed(0, 38) then
                            GANG_GARAGE.Open()
                        end
                    else
                        if GANG_GARAGE.IsOpen then
                            GANG_GARAGE.Close()
                        end
                    end
                end
            end

            if isNearLocation then
                Wait(1)
            else
                Wait(800)
            end
        end
    end
end)