MISSIONS = {}
MISSIONS.ActiveMissions = {}

MISSIONS.MarkerTypes = {
    STANDARD = 1,
    RING = 25,
    PULSING_CIRCLE = 21,
}

MISSIONS.Colors = {
    AVAILABLE = {r = 50, g = 255, b = 50},  -- Green
    CONTESTED = {r = 255, g = 165, b = 0},  -- Orange
    ENEMY = {r = 255, g = 50, b = 50},      -- Red
}

function MISSIONS.Draw3DText(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function MISSIONS.DrawAnimatedMarkers(position, isOwnGang)
    local colors = isOwnGang and MISSIONS.Colors.AVAILABLE or MISSIONS.Colors.ENEMY
    local time = GetGameTimer() / 1000
    local baseScale = 1.0 + math.sin(time * 3) * 0.1 -- Pulsing effect

    DrawMarker(
        MISSIONS.MarkerTypes.STANDARD,
        position.x, position.y, position.z - 1.0,
        0, 0, 0,
        0, 0, 0,
        baseScale, baseScale, 0.1,
        colors.r, colors.g, colors.b, 200,
        false, false, 2, true, nil, nil, false
    )

    DrawMarker(
        MISSIONS.MarkerTypes.PULSING_CIRCLE,
        position.x, position.y, position.z + 1.0,
        0, 0, 0,
        0, 0, 0,
        baseScale * 0.5, baseScale * 0.5, baseScale * 0.5,
        colors.r, colors.g, colors.b, 100,
        false, false, 2, true, nil, nil, false
    )
end

function MISSIONS.CreateMissionBlip(position, isOwnGang)
    local blip = AddBlipForCoord(position.x, position.y, position.z)
    SetBlipSprite(blip, 437)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, isOwnGang and 2 or 1) -- Green for own gang, red for others
    SetBlipAsShortRange(blip, true)

    if isOwnGang then
        SetBlipRoute(blip, true)
        SetBlipRouteColour(blip, 2)
    end

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(isOwnGang and "Mission de Gang" or "Mission Contestée")
    EndTextCommandSetBlipName(blip)

    return blip
end

function MISSIONS.ShowHelpText(isOwnGang)
    if isOwnGang then
        BeginTextCommandDisplayHelp("STRING")
        AddTextComponentSubstringPlayerName("Appuyez sur ~INPUT_CONTEXT~ pour terminer la mission")
        EndTextCommandDisplayHelp(0, false, true, -1)
    else
        BeginTextCommandDisplayHelp("STRING")
        AddTextComponentSubstringPlayerName("Cette mission appartient à un gang rival, Appuyez sur ~INPUT_CONTEXT~ pour terminer la mission")
        EndTextCommandDisplayHelp(0, false, true, -1)
    end
end

function MISSIONS.StartMissionLogic(data)
    if GANG_PLAYER.GangId == nil or GANG_PLAYER.GangId == 0 then
        return
    end
    local missionId = data.missionId
    local position = data.position
    local isOwnGang = GANG_PLAYER.GangId == data.gangId
    MISSIONS.ActiveMissions[missionId] = true

    local blip = nil

    if isOwnGang then
        Notify('success', "Nouvelle mission disponible ! Consultez votre carte.", true)
        -- Optional: Play sound
        PlaySoundFrontend(-1, "Mission_Pass_Notify", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", false)
        blip = MISSIONS.CreateMissionBlip(position, isOwnGang)
    else
        Notify('info', "Un gang rival a commencé une mission. Vous recevrez la position bientôt.", true)

        Citizen.CreateThread(function()
            Wait(Config.Missions.AlertDelay*60*1000) -- Delay for position notification and blip
            if MISSIONS.ActiveMissions[missionId] then -- Check if mission is still active
                Notify('info', "Un gang rival a commencé une mission dans la zone. Position marquée sur la carte.", true)
                blip = MISSIONS.CreateMissionBlip(position, isOwnGang)
            end
        end)
    end

    local ped
    local object

    Citizen.CreateThread(function()
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)

        local distance = #(pCoords - position)
        while distance > 50.0 do
            pCoords = GetEntityCoords(pPed)
            distance = #(pCoords - position)
            Wait(100)
        end

        local pedModel = GetHashKey("mp_m_weapexp_01")
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(0)
        end

        ped = CreatePed(4, pedModel, position.x, position.y, position.z - 0.96, 0.0, false, true)
        SetEntityAsMissionEntity(ped, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)

        local objectModel = GetHashKey("v_ind_meatpacks")
        RequestModel(objectModel)
        while not HasModelLoaded(objectModel) do
            Wait(0)
        end

        object = CreateObject(objectModel, position.x, position.y - 1.5, position.z, true, true, true)
        SetEntityAsMissionEntity(object, true, true)
        PlaceObjectOnGroundProperly(object)
        FreezeEntityPosition(ped, true)
    end)

    while MISSIONS.ActiveMissions[missionId] do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local distance = #(playerCoords - position)

        if distance < 50.0 then
            MISSIONS.DrawAnimatedMarkers(position, isOwnGang)

            if distance < 2.0 then
                MISSIONS.Draw3DText(position.x, position.y, position.z + 1.5, isOwnGang and "Terminer la mission" or "Mission de gang rival")
                MISSIONS.ShowHelpText(isOwnGang)

                if IsControlJustPressed(0, 38) then
                    -- Optional: Add completion animation
                    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_CLIPBOARD", 0, true)
                    Wait(2000)
                    ClearPedTasks(playerPed)

                    TriggerServerEvent("gangs:missions:complete", missionId)
                end
            end
        end
        Wait(0)
    end

    if blip then
        RemoveBlip(blip)
    end

    if ped then
        FreezeEntityPosition(ped, false)
        TaskWanderStandard(ped, 10.0, 10)
        SetEntityAsNoLongerNeeded(ped)
    end

    if object then
        SetEntityAsNoLongerNeeded(object)
    end
end

RegisterNetEvent("gang:missions:started", function(missionData)
    MISSIONS.StartMissionLogic(missionData)
end)

RegisterNetEvent("gang:missions:completed", function(missionId)
    MISSIONS.ActiveMissions[missionId] = nil
end)