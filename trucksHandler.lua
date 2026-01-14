local currentMission = nil
local attachedTrailer = false
local isAtDeliveryPoint = false
local deliveryNPC = nil
local npcSpawned = false
local npcCoords = vector3(-122.25481414795, -2508.7155761719, 6.1136779785156)
local playerPed = nil
local vehicleBlip = nil
local trailerBlip = nil
local deliveryBlip = nil
local vehicle = nil
local trailer = nil

local deliverysPosByJobs = {
    ["bahamas"] = vector3(794.09509277344, -58.378658294678, 80.63582611084),
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(2500)
            playerPed = PlayerPedId()
            local distance = #(GetEntityCoords(playerPed) - npcCoords)

            if distance < 75.0 and not npcSpawned then
                spawnDeliveryNPC()
            elseif distance >= 75.0 and npcSpawned then
                removeDeliveryNPC()
            end
        end
    end)
end)

local function generateTruckPlates()
    local randomPlate = string.format("%03d", math.random(1, 999))
    return randomPlate:upper()
end

function spawnDeliveryNPC()
    if not npcSpawned then
        local npcModel = GetHashKey("s_m_m_trucker_01")
        RequestModel(npcModel)
        while not HasModelLoaded(npcModel) do
            Citizen.Wait(10)
        end

        deliveryNPC = CreatePed(4, npcModel, npcCoords.x, npcCoords.y, npcCoords.z - 1.0, 144.62, false, true)
        SetEntityAsMissionEntity(deliveryNPC, true, true)
        SetPedDiesWhenInjured(deliveryNPC, false)
        SetPedCanRagdollFromPlayerImpact(deliveryNPC, false)
        SetBlockingOfNonTemporaryEvents(deliveryNPC, true)
        SetPedFleeAttributes(deliveryNPC, 0, false)
        SetPedCombatAttributes(deliveryNPC, 17, true)
        FreezeEntityPosition(deliveryNPC, true)

        npcSpawned = true
    end
end

function removeDeliveryNPC()
    if npcSpawned and DoesEntityExist(deliveryNPC) then
        DeleteEntity(deliveryNPC)
        npcSpawned = false
    end
end

Citizen.CreateThread(function()
    while true do
        local interval = 1000

        if npcSpawned then
            local playerPos = GetEntityCoords(playerPed)
            local distance = #(playerPos - npcCoords)

            if distance < 2.5 then
                interval = 0
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir ~y~centre de livraison~s~")

                if IsControlJustPressed(1, 38) then
                    if ESX.PlayerData.job.name == "elysian" then
                        TRUCKER.openMissions()
                    end
                end
            end
        end

        Citizen.Wait(interval)
    end
end)

local missionEnCours = false

function startMission(missionData)
    local playerPed = PlayerPedId()
    missionEnCours = true

    ESX.ShowNotification("~y~Allez au point indiqué pour prendre votre camion de livraison")

    vehicleBlip = AddBlipForCoord(missionData.startPos.x, missionData.startPos.y, missionData.startPos.z)
    SetBlipSprite(vehicleBlip, 477)
    SetBlipColour(vehicleBlip, 3)
    SetBlipRoute(vehicleBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Camion de livraison")
    EndTextCommandSetBlipName(vehicleBlip)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            local playerPos = GetEntityCoords(playerPed)
            local distanceToTruck = #(playerPos - missionData.startPos)

            if distanceToTruck < 50.0 then
                local truckModel = missionData.truckHash == nil and GetHashKey("hauler") or missionData.truckHash
                RequestModel(truckModel)
                while not HasModelLoaded(truckModel) do
                    Citizen.Wait(10)
                end

                vehicle = CreateVehicle(truckModel, missionData.startPos.x, missionData.startPos.y, missionData.startPos.z, missionData.truckHeading, true, false)
                SetVehicleFuelLevel(vehicle, 100.0)
                local plate = generateTruckPlates()
                SetVehicleNumberPlateText(vehicle, plate)
                RemoveBlip(vehicleBlip)

                while not IsPedInVehicle(PlayerPedId(), vehicle, true) do
                    ESX.ShowHelpNotification("Montez dans le ~y~camion~s~ pour démarrer la mission")
                    Citizen.Wait(0)
                end

                ESX.ShowNotification("~y~Allez chercher la remorque au point indiqué")
                addBlipForTrailer(missionData)
                break
            end
        end
    end)
end

function startSocietyMission(missionData)
    local playerPed = PlayerPedId()
    missionEnCours = true

    missionData.startPos = vector3(-111.33516693115, -2548.8757324219, 6.0016355514526)
    missionData.truckHeading = 322.0
    missionData.truckHash = "gbvoyager"
    missionData.trailerPos = vector3(-104.16275024414, -2513.9538574219, 5.6153855323792)
    missionData.trailerHeading = 233.0
    missionData.trailerHash = "trailers"
    missionData.deliveryPos = deliverysPosByJobs[missionData.society]

    ESX.ShowNotification("~y~Allez au point indiqué pour prendre votre camion de livraison")

    vehicleBlip = AddBlipForCoord(missionData.startPos.x, missionData.startPos.y, missionData.startPos.z)
    SetBlipSprite(vehicleBlip, 477)
    SetBlipColour(vehicleBlip, 3)
    SetBlipRoute(vehicleBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Camion de livraison")
    EndTextCommandSetBlipName(vehicleBlip)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            local playerPos = GetEntityCoords(playerPed)
            local distanceToTruck = #(playerPos - missionData.startPos)

            if distanceToTruck < 50.0 then
                local truckModel = missionData.truckHash == nil and GetHashKey("gbvoyager") or missionData.truckHash
                RequestModel(truckModel)
                while not HasModelLoaded(truckModel) do
                    Citizen.Wait(10)
                end

                vehicle = CreateVehicle(truckModel, missionData.startPos.x, missionData.startPos.y, missionData.startPos.z, missionData.truckHeading, true, false)
                SetVehicleFuelLevel(vehicle, 100.0)
                local plate = generateTruckPlates()
                SetVehicleNumberPlateText(vehicle, plate)
                RemoveBlip(vehicleBlip)

                while not IsPedInVehicle(PlayerPedId(), vehicle, true) do
                    ESX.ShowHelpNotification("Montez dans le ~y~camion~s~ pour démarrer la mission")
                    Citizen.Wait(0)
                end

                ESX.ShowNotification("~y~Allez chercher la remorque au point indiqué")
                addBlipForSocietyTrailer(missionData)
                break
            end
        end
    end)
end

function addBlipForSocietyTrailer(missionData)
    if trailerBlip then
        RemoveBlip(trailerBlip)
    end

    trailerBlip = AddBlipForCoord(missionData.trailerPos.x, missionData.trailerPos.y, missionData.trailerPos.z)
    SetBlipSprite(trailerBlip, 479)
    SetBlipColour(trailerBlip, 5)
    SetBlipRoute(trailerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Remorque")
    EndTextCommandSetBlipName(trailerBlip)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            local playerPos = GetEntityCoords(playerPed)
            local distanceToTrailer = #(playerPos - missionData.trailerPos)

            if distanceToTrailer < 100.0 then
                local trailerModel = missionData.trailerHash == nil and GetHashKey("tanker") or missionData.trailerHash
                RequestModel(trailerModel)
                while not HasModelLoaded(trailerModel) do
                    Citizen.Wait(10)
                end

                trailer = CreateVehicle(trailerModel, missionData.trailerPos.x, missionData.trailerPos.y, missionData.trailerPos.z, missionData.trailerHeading, true, false)
                local plate = generateTruckPlates()
                SetVehicleNumberPlateText(trailer, plate)
                RemoveBlip(trailerBlip)

                ESX.ShowNotification("~y~Attachez la remorque pour continuer la mission")
                monitorSocietyTrailerAttachment(missionData)
                break
            end
        end
    end)
end

function monitorSocietyTrailerAttachment(currentMission)
    Citizen.CreateThread(function()
        while not attachedTrailer do
            Citizen.Wait(1000)
            attachedTrailer = IsVehicleAttachedToTrailer(vehicle)
        end

        ESX.ShowNotification("~y~Remorque attachée, livrez cette remorque à la position indiquée sur votre carte !")
        addBlipForSocietyDelivery(currentMission)
    end)
end

function addBlipForSocietyDelivery(missionData)
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end

    deliveryBlip = AddBlipForCoord(missionData.deliveryPos.x, missionData.deliveryPos.y, missionData.deliveryPos.z)
    SetBlipSprite(deliveryBlip, 568)
    SetBlipColour(deliveryBlip, 2)
    SetBlipRoute(deliveryBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Point de livraison")
    EndTextCommandSetBlipName(deliveryBlip)

    Citizen.CreateThread(function()
        while not isAtDeliveryPoint do
            Citizen.Wait(1000)
    
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
            local distance = #(playerPos - missionData.deliveryPos)
    
            local currentVehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleModel = GetEntityModel(currentVehicle)
    
            if vehicleModel ~= GetHashKey("gbvoyager") then
                ESX.ShowHelpNotification("~r~Vous devez être dans le camion de livraison pour continuer.")
            end

            if distance < 25.0 and vehicleModel == GetHashKey("gbvoyager") then
                isAtDeliveryPoint = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour compléter la livraison")
            end
        end
    
        Citizen.CreateThread(function()
            while isAtDeliveryPoint do
                Citizen.Wait(0)
    
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour compléter la livraison")
    
                if IsControlJustPressed(0, 38) then
                    local playerPed = PlayerPedId()
                    local currentVehicle = GetVehiclePedIsIn(playerPed, false)
                    local vehicleModel = GetEntityModel(currentVehicle)
    
                    if vehicleModel == GetHashKey("gbvoyager") then
                        DetachVehicleFromTrailer(vehicle)
                        DeleteEntity(vehicle)
                        DeleteEntity(trailer)
                        completeMission(missionData.id)
                        isAtDeliveryPoint = false
                        local scooterCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0, 5.0, 0)
                        local scooterModel = GetHashKey("scout")
                        RequestModel(scooterModel)
                        while not HasModelLoaded(scooterModel) do
                            Citizen.Wait(1)
                        end
                        local scooter = CreateVehicle(scooterModel, scooterCoords.x, scooterCoords.y, scooterCoords.z, GetEntityHeading(playerPed), true, false)
                        SetVehicleNumberPlateText(scooter, "IEIW1923")
                        SetModelAsNoLongerNeeded(scooterModel)
                        TaskWarpPedIntoVehicle(playerPed, scooter, -1)
                    else
                        ESX.ShowNotification("~r~Vous devez être dans le camion de livraison pour compléter la mission.")
                    end
                end
            end
        end)
    end)    
end

function addBlipForTrailer(missionData)
    if trailerBlip then
        RemoveBlip(trailerBlip)
    end

    trailerBlip = AddBlipForCoord(missionData.trailerPos.x, missionData.trailerPos.y, missionData.trailerPos.z)
    SetBlipSprite(trailerBlip, 479)
    SetBlipColour(trailerBlip, 5)
    SetBlipRoute(trailerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Remorque")
    EndTextCommandSetBlipName(trailerBlip)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(500)
            local playerPos = GetEntityCoords(playerPed)
            local distanceToTrailer = #(playerPos - missionData.trailerPos)

            if distanceToTrailer < 100.0 then
                local trailerModel = missionData.trailerHash == nil and GetHashKey("tanker") or missionData.trailerHash
                RequestModel(trailerModel)
                while not HasModelLoaded(trailerModel) do
                    Citizen.Wait(10)
                end

                trailer = CreateVehicle(trailerModel, missionData.trailerPos.x, missionData.trailerPos.y, missionData.trailerPos.z, missionData.trailerHeading, true, false)
                local plate = generateTruckPlates()
                SetVehicleNumberPlateText(trailer, plate)
                RemoveBlip(trailerBlip)

                ESX.ShowNotification("~y~Attachez la remorque pour continuer la mission")
                monitorTrailerAttachment(missionData)
                break
            end
        end
    end)
end

function monitorTrailerAttachment(currentMission)
    Citizen.CreateThread(function()
        while not attachedTrailer do
            Citizen.Wait(1000)
            attachedTrailer = IsVehicleAttachedToTrailer(vehicle)
        end

        ESX.ShowNotification("~y~Remorque attachée, livrez cette remorque à la position indiquée sur votre carte !")
        addBlipForDelivery(currentMission)
    end)
end

function addBlipForDelivery(missionData)
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end

    deliveryBlip = AddBlipForCoord(missionData.deliveryPos.x, missionData.deliveryPos.y, missionData.deliveryPos.z)
    SetBlipSprite(deliveryBlip, 568)
    SetBlipColour(deliveryBlip, 2)
    SetBlipRoute(deliveryBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Point de livraison")
    EndTextCommandSetBlipName(deliveryBlip)

    Citizen.CreateThread(function()
        while not isAtDeliveryPoint do
            Citizen.Wait(1000)
    
            local playerPed = PlayerPedId()
            local playerPos = GetEntityCoords(playerPed)
            local distance = #(playerPos - missionData.deliveryPos)
    
            local currentVehicle = GetVehiclePedIsIn(playerPed, false)
            local vehicleModel = GetEntityModel(currentVehicle)
    
            if vehicleModel ~= GetHashKey("gbvoyager") then
                ESX.ShowHelpNotification("~r~Vous devez être dans le camion de livraison pour continuer.")
            end

            if distance < 25.0 and vehicleModel == GetHashKey("gbvoyager") then
                isAtDeliveryPoint = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour compléter la livraison")
            end
        end
    
        Citizen.CreateThread(function()
            while isAtDeliveryPoint do
                Citizen.Wait(0)
    
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour compléter la livraison")
    
                if IsControlJustPressed(0, 38) then
                    local playerPed = PlayerPedId()
                    local currentVehicle = GetVehiclePedIsIn(playerPed, false)
                    local vehicleModel = GetEntityModel(currentVehicle)
    
                    if vehicleModel == GetHashKey("gbvoyager") then
                        DetachVehicleFromTrailer(vehicle)
                        DeleteEntity(vehicle)
                        DeleteEntity(trailer)
                        completeMission(missionData.id)
                        isAtDeliveryPoint = false
                        local scooterCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0, 5.0, 0)
                        local scooterModel = GetHashKey("novak")
                        RequestModel(scooterModel)
                        while not HasModelLoaded(scooterModel) do
                            Citizen.Wait(1)
                        end
                        local scooter = CreateVehicle(scooterModel, scooterCoords.x, scooterCoords.y, scooterCoords.z, GetEntityHeading(playerPed), true, false)
                        SetVehicleNumberPlateText(scooter, "IEIW1923")
                        SetModelAsNoLongerNeeded(scooterModel)
                        TaskWarpPedIntoVehicle(playerPed, scooter, -1)
                    else
                        ESX.ShowNotification("~r~Vous devez être dans le camion de livraison pour compléter la mission.")
                    end
                end
            end
        end)
    end)    
end

function completeSocietyMission(missionId)
    TriggerServerEvent("trucker:finishSocietyMission", missionId)

    if trailerBlip then
        RemoveBlip(trailerBlip)
    end
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end

    missionEnCours = false
end

function completeMission(missionId)
    TriggerServerEvent("trucker:finishMission", missionId)

    if trailerBlip then
        RemoveBlip(trailerBlip)
    end
    if deliveryBlip then
        RemoveBlip(deliveryBlip)
    end

    missionEnCours = false
end

RegisterNetEvent("trucker:startMission")
AddEventHandler("trucker:startMission", function(missionData)
    if missionEnCours == false then
        startMission(missionData)
    else
        ESX.ShowNotification("Vous êtes déja en mission !")
    end
end)

RegisterNetEvent("trucker:startSocietyMission")
AddEventHandler("trucker:startSocietyMission", function(missionData)
    if missionEnCours == false then
        startSocietyMission(missionData)
    else
        ESX.ShowNotification("Vous êtes déja en mission !")
    end
end)