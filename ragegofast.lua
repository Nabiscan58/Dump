ESX = nil
local OnMenuGoFast, OnMission, LivraisonStart, cooldowngofast = false, false, false, false
local CurrentMissionVehicle, CurrentMissionRouteKey, CurrentMissionData = nil, nil, nil
local HasPackage, CarryingProp = false, nil
local MissionBlip = nil
local CurrentDelivery = nil

local gofastLocations = {
    entry = {x = 1240.75, y = -438.89, z = 66.75},

    short = {
        deliveries = {
            {x = 1764.23, y = -1655.98, z = 111.7},
            {x = 490.10, y = -2159.20, z = 5.9},
            {x = -71.06, y = -2226.23, z = 7.8},
        },
        model = 2136773105,
        reward = 16000,
        car = "rocoto",
        time = 90000
    },

    medium = {
        deliveries = {
            {x = -1133.74, y = 2694.79, z = 18.8},
            {x = 1730.40, y = 3278.10, z = 41.16},
            {x = 165.52, y = 3053.10, z = 43.09},
        },
        model = 1909141499,
        reward = 31000,
        car = "fugitive",
        time = 300000
    },

    long = {
        deliveries = {
            {x = 1685.07, y = 6435.07, z = 32.32},
            {x = -215.20, y = 6172.40, z = 31.20},
            {x = -523.20, y = 7643.40, z = 6.7},
        },
        model = -1485523546,
        reward = 43000,
        car = "schafter3",
        time = 600000
    }
}

function LoadModel(model)
    local m = model
    if type(model) == "string" then
        m = GetHashKey(model)
    end
    RequestModel(m)
    while not HasModelLoaded(m) do
        Wait(0)
    end
    return m
end

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
    end
end

function CreateCarryBoxProp(ped)
    local model = LoadModel("prop_cs_cardbox_01")
    local coords = GetEntityCoords(ped)
    local obj = CreateObject(model, coords.x, coords.y, coords.z + 0.2, false, true, false)
    SetEntityCollision(obj, false, false)
    AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, 57005), 0.12, 0.02, -0.02, 80.0, 180.0, 10.0, true, true, false, true, 1, true)
    return obj
end

function ClearCarryBox(ped)
    if CarryingProp and DoesEntityExist(CarryingProp) then
        DetachEntity(CarryingProp, true, true)
        DeleteEntity(CarryingProp)
        CarryingProp = nil
    end
    ClearPedTasks(ped)
end

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    for _, menu in ipairs({"menugofast", "selection", "givemission"}) do
        RMenu.Add('menu', menu, RageUI.CreateMenu("PRIME", "Missions de GoFast", 1, 100))
        RMenu:Get('menu', menu):SetRectangleBanner(255, 220, 0, 140)
    end

    RMenu:Get('menu', 'menugofast').EnableMouse = false
    RMenu:Get('menu', 'menugofast').Closed = function()
        OnMenuGoFast = false
    end
end)

function openGoFastMenu()
    if OnMenuGoFast then
        OnMenuGoFast = false
        return
    end

    OnMenuGoFast = true
    RageUI.Visible(RMenu:Get('menu', 'menugofast'), true)

    Citizen.CreateThread(function()
        while OnMenuGoFast do
            RageUI.IsVisible(RMenu:Get('menu', 'menugofast'), true, true, true, function()
                for _, data in pairs({
                    {label = "GoFast Los Santos", key = "short"},
                    {label = "GoFast Sandy Shores", key = "medium"},
                    {label = "GoFast Paleto Bay", key = "long"}
                }) do
                    RageUI.ButtonWithStyle(data.label, nil, {}, true, function(_, _, Selected)
                        if Selected then
                            startGoFast(data.key)
                        end
                    end)
                end
            end)
            Wait(0)
        end
    end)
end

function startGoFast(routeKey)
    if cooldowngofast then
        return ESX.ShowNotification("~r~Vous ne pouvez faire qu'une seule mission toutes les 5 minutes !")
    end
    if OnMission then
        ESX.ShowAdvancedNotification("Gerald", "~o~GoFast", "T'es déjà en mission !", "CHAR_MP_GERALD", 8)
        OnMenuGoFast = false
        RageUI.CloseAll()
        return
    end

    local data = gofastLocations[routeKey]
    local list = data.deliveries or {}
    CurrentDelivery = list[math.random(1, #list)]

    if not CurrentDelivery then
        ESX.ShowNotification("~r~Aucun point de livraison configuré pour cette mission")
        return
    end

    CurrentMissionRouteKey = routeKey
    CurrentMissionData = data

    CurrentMissionVehicle = spawnCarGoFast(data.car)

    OnMenuGoFast = false
    RageUI.CloseAll()

    Citizen.CreateThread(function()
        PlayLoadingCinematic(CurrentMissionVehicle)
        ESX.ShowAdvancedNotification("Gerald", "~o~GoFast", "C'est chargé. Le GPS est configuré pour la livraison !", "CHAR_MP_GERALD", 8)
        triggerGoFastRoute(routeKey, data)
    end)
end

function spawnCarGoFast(carName)
    local model = LoadModel(carName)
    local vehicle = CreateVehicle(model, 1234.42, -430.8, 67.77, 189.1, true, false)
    SetVehicleNumberPlateText(vehicle, 'GOFAST')
    SetVehicleDoorsLocked(vehicle, 2)
    FreezeEntityPosition(vehicle, true)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    return vehicle
end

function PlayLoadingCinematic(vehicle)
    local ped = PlayerPedId()
    local vehCoords = GetEntityCoords(vehicle)

    TaskLeaveVehicle(ped, vehicle, 16)
    while IsPedInAnyVehicle(ped, false) do
        Wait(0)
    end

    local pnjModel = LoadModel("s_m_m_dockwork_01")
    local spawnOffset = GetOffsetFromEntityInWorldCoords(vehicle, -6.0, -2.0, 0.0)
    local npc = CreatePed(4, pnjModel, spawnOffset.x, spawnOffset.y, spawnOffset.z, GetEntityHeading(vehicle), false, true)

    SetEntityAsMissionEntity(npc, true, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetPedFleeAttributes(npc, 0, false)
    SetPedCombatAttributes(npc, 17, true)
    SetPedCanRagdoll(npc, false)

    LoadAnimDict("anim@heists@box_carry@")
    TaskPlayAnim(npc, "anim@heists@box_carry@", "idle", 8.0, -8.0, -1, 49, 0, false, false, false)

    local trunkPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "boot"))
    TaskGoStraightToCoord(npc, trunkPos.x, trunkPos.y, trunkPos.z, 1.0, -1, GetEntityHeading(vehicle), 0.0)

    local timeout = GetGameTimer() + 15000
    while #(GetEntityCoords(npc) - trunkPos) > 1.3 and GetGameTimer() < timeout do
        Wait(50)
    end

    SetVehicleDoorOpen(vehicle, 5, false, false)

    local boxObj = CreateCarryBoxProp(npc)

    LoadAnimDict("anim@heists@narcotics@trash")
    TaskPlayAnim(npc, "anim@heists@narcotics@trash", "throw_b", 8.0, -8.0, 1100, 0, 0, false, false, false)
    Wait(900)

    if DoesEntityExist(boxObj) then
        DetachEntity(boxObj, true, true)
        DeleteEntity(boxObj)
    end

    Wait(300)
    SetVehicleDoorShut(vehicle, 5, false)

    ClearPedTasks(npc)
    TaskGoStraightToCoord(npc, spawnOffset.x, spawnOffset.y, spawnOffset.z, 1.2, 8000, GetEntityHeading(vehicle), 0.0)
    Wait(2500)
    if DoesEntityExist(npc) then
        DeleteEntity(npc)
    end

    FreezeEntityPosition(vehicle, false)
    SetVehicleDoorsLocked(vehicle, 1)

    TaskEnterVehicle(ped, vehicle, 8000, -1, 1.0, 1, 0)
    timeout = GetGameTimer() + 12000
    while not IsPedInVehicle(ped, vehicle, false) and GetGameTimer() < timeout do
        Wait(0)
    end
end

function spawnScooter()
    local model = GetHashKey("faggio")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    local coords = GetEntityCoords(PlayerPedId())
    local scooter = CreateVehicle(model, coords.x + 2.0, coords.y, coords.z, GetEntityHeading(PlayerPedId()), true, false)
    SetVehicleNumberPlateText(scooter, "LOC 333")
end

function triggerGoFastRoute(routeKey, data)
    LivraisonStart, OnMission = true, true
    HasPackage = false
    ClearCarryBox(PlayerPedId())
    TriggerServerEvent("GoFast:setupPlayerMission")

    if MissionBlip then
        RemoveBlip(MissionBlip)
        MissionBlip = nil
    end

    MissionBlip = AddBlipForCoord(CurrentDelivery.x, CurrentDelivery.y, CurrentDelivery.z)
    SetBlipSprite(MissionBlip, 1)
    SetBlipScale(MissionBlip, 0.85)
    SetBlipColour(MissionBlip, 1)
    PulseBlip(MissionBlip)
    SetBlipRoute(MissionBlip, true)

    AddTimerBar("Temps restant", {endTime = GetGameTimer() + data.time})

    Citizen.CreateThread(function()
        local ped = PlayerPedId()
        local taking = false
        local delivering = false

        while LivraisonStart do
            ped = PlayerPedId()
            local plyCoords = GetEntityCoords(ped)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, CurrentDelivery.x, CurrentDelivery.y, CurrentDelivery.z)

            if dist <= 35.0 then
                DrawMarker(1, CurrentDelivery.x, CurrentDelivery.y, CurrentDelivery.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 2.0, 2.0, 1.0, 255, 220, 0, 120, false, false, 2, false, nil, nil, false)
            end

            if dist <= 7.0 then
                local vehicle = GetVehiclePedIsIn(ped, false)
                if vehicle ~= 0 then
                    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                    if vehicleProps.model == data.model and NetworkGetNetworkIdFromEntity(vehicle) == NetworkGetNetworkIdFromEntity(CurrentMissionVehicle) then
                        ESX.ShowHelpNotification("Garez-vous, descendez et allez au coffre.")
                    end
                end
            end

            if dist <= 6.0 then
                local vehicle = CurrentMissionVehicle
                if vehicle and DoesEntityExist(vehicle) then
                    local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

                    if vehicleProps.model == data.model then
                        if not HasPackage then
                            if IsPedInVehicle(ped, vehicle, false) then
                                ESX.ShowHelpNotification("Descendez du véhicule.")
                            else
                                local trunkPos = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "boot"))
                                local trunkDist = #(GetEntityCoords(ped) - trunkPos)

                                if trunkDist <= 2.0 then
                                    ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour récupérer la marchandise.")
                                    if IsControlJustPressed(1, 51) and not taking then
                                        taking = true
                                        SetVehicleDoorOpen(vehicle, 5, false, false)

                                        LoadAnimDict("anim@heists@box_carry@")
                                        TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 8.0, -8.0, -1, 49, 0, false, false, false)

                                        CarryingProp = CreateCarryBoxProp(ped)
                                        HasPackage = true

                                        Wait(250)
                                        SetVehicleDoorShut(vehicle, 5, false)
                                        taking = false
                                    end
                                else
                                    ESX.ShowHelpNotification("Allez au coffre du véhicule.")
                                end
                            end
                        else
                            local deliverDist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, CurrentDelivery.x, CurrentDelivery.y, CurrentDelivery.z)

                            DrawMarker(1, CurrentDelivery.x, CurrentDelivery.y, CurrentDelivery.z - 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.8, 1.8, 1.0, 255, 220, 0, 160, false, false, 2, false, nil, nil, false)

                            if deliverDist <= 2.0 then
                                ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour livrer la marchandise.")
                                if IsControlJustPressed(1, 51) and not delivering then
                                    delivering = true

                                    ClearCarryBox(ped)
                                    HasPackage = false

                                    ESX.ShowAdvancedNotification("Gerald", "~o~GoFast", "Parfait. Voilà ta paie.", "CHAR_MP_GERALD", 8)
                                    TriggerServerEvent('GoFast:Reward', data.reward)

                                    TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(vehicle))

                                    LivraisonStart, OnMission = false, false
                                    spawnScooter()
                                    delivering = false
                                end
                            else
                                ESX.ShowHelpNotification("Va sur le marqueur pour livrer.")
                            end
                        end
                    end
                end
            end

            Wait(0)
        end

        RemoveTimerBar()
        if MissionBlip then
            RemoveBlip(MissionBlip)
            MissionBlip = nil
        end
    end)

    cooldowngofast = true
    Citizen.SetTimeout(300000, function()
        cooldowngofast = false
    end)
end

Citizen.CreateThread(function()
    while true do
        local dist = Vdist(GetEntityCoords(PlayerPedId()), gofastLocations.entry.x, gofastLocations.entry.y, gofastLocations.entry.z)
        if dist <= 3.0 then
            ESX.ShowHelpNotification("Appuyez sur [~o~E~w~] pour parler à Gerald")
            if IsControlJustPressed(1, 51) then
                openGoFastMenu()
            end
            Wait(0)
        else
            Wait(500)
        end
    end
end)