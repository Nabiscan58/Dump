local InDriftZone = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

-- Drift mode

local driftmode = false
local drift_speed_limit = 150.0
local cooldown = false

local reduceGripActive = false
local lastGripSwitch = 0
local minPressMs = 300
local minSwitchMs = 300

RegisterCommand('toggleDriftMode', function()
    ESX.PlayerData = ESX.GetPlayerData()
    local hasVip = false
    for _, rankInfo in ipairs(ESX.PlayerData.rank) do
        if rankInfo.name == "diamond" or rankInfo.name == "prime" then
            hasVip = true
        end
    end
    if not hasVip then
        ESX.ShowNotification("Vous n'êtes pas VIP Diamond/Prime !")
        return
    end
    if not cooldown then
        driftmode = not driftmode
        if not driftmode then
            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
            if veh ~= 0 and reduceGripActive then
                SetVehicleReduceGrip(veh, false)
            end
            reduceGripActive = false
            ESX.ShowNotification("~r~Mode Drift Désactivé")
            return
        end
        ESX.ShowNotification("~y~Mode Drift Activé")
        cooldown = true
        Citizen.Wait(5000)
        cooldown = false
    end
end, false)
RegisterKeyMapping('toggleDriftMode', 'Activer le mode drift', 'keyboard', '')

Citizen.CreateThread(function()
    while true do
        if driftmode then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                if GetPedInVehicleSeat(veh, -1) == ped then
                    local kmh = GetEntitySpeed(veh) * 3.6
                    local now = GetGameTimer()
                    local wantDrift = IsControlPressed(1, 21)
                    if kmh > drift_speed_limit + 1.0 then
                        if reduceGripActive then
                            SetVehicleReduceGrip(veh, false)
                            reduceGripActive = false
                            lastGripSwitch = now
                        end
                    else
                        if wantDrift and not reduceGripActive and (now - lastGripSwitch) >= minSwitchMs then
                            SetVehicleReduceGrip(veh, true)
                            reduceGripActive = true
                            lastGripSwitch = now
                        end
                        if not wantDrift and reduceGripActive and (now - lastGripSwitch) >= minPressMs then
                            SetVehicleReduceGrip(veh, false)
                            reduceGripActive = false
                            lastGripSwitch = now
                        end
                    end
                else
                    if reduceGripActive then
                        SetVehicleReduceGrip(GetVehiclePedIsIn(ped, false), false)
                        reduceGripActive = false
                        lastGripSwitch = GetGameTimer()
                    end
                end
            else
                if reduceGripActive then
                    reduceGripActive = false
                    lastGripSwitch = GetGameTimer()
                end
            end
        else
            Citizen.Wait(500)
        end
        Citizen.Wait(10)
    end
end)

-- AutoPilote

local autopilotActive = false
local lastMode = nil
local normalSpeed = 25.0
local normalDriveStyle = 786603
local crazySpeed = 100.0
local crazyDriveStyle = 1074528293

RegisterCommand('+normalautopilot', function()
    local player = PlayerPedId()
	ESX.PlayerData = ESX.GetPlayerData()
    local hasAccessToAutoPilot = false

	for _, rankInfo in ipairs(ESX.PlayerData.rank) do
        if rankInfo.name == "diamond" or rankInfo.name == "prime" then
            hasAccessToAutoPilot = true
        end
    end

    if not hasAccessToAutoPilot then
		ESX.ShowNotification('Vous n\'êtes pas VIP Diamond !')
        return
	end

    if not IsPedInAnyVehicle(player, false) then
        ESX.ShowNotification('Vous n\'êtes pas dans un véhicule !')
        return
    end

    if autopilotActive and lastMode == "normal" then
        ClearPedTasks(player)
        ESX.ShowNotification('Autopilote normal - Désactivé')
        autopilotActive = false
    else
        if DoesBlipExist(GetFirstBlipInfoId(8)) then
            local blip = GetFirstBlipInfoId(8)
            local bCoords = GetBlipCoords(blip)
            local vehicle = GetVehiclePedIsIn(player, false)
            TaskVehicleDriveToCoord(player, vehicle, bCoords, tonumber(normalSpeed), 0, vehicle, normalDriveStyle, 0, true)
            SetDriveTaskDrivingStyle(player, normalDriveStyle)
            ESX.ShowNotification('Autopilote normal - Activé')
            autopilotActive = true
            lastMode = "normal"
        else
            ESX.ShowNotification('Vous n\'avez pas défini de point de navigation !')
        end
    end
end, false)
RegisterKeyMapping('+normalautopilot', 'Autopilote normal', 'keyboard', '')

RegisterCommand('+crazyautopilot', function()
    local player = PlayerPedId()
	ESX.PlayerData = ESX.GetPlayerData()
    local hasAccessToAutoPilot = false

	for _, rankInfo in ipairs(ESX.PlayerData.rank) do
        if rankInfo.name == "diamond" or rankInfo.name == "prime" then
            hasAccessToAutoPilot = true
        end
    end

    if not hasAccessToAutoPilot then
		ESX.ShowNotification('Vous n\'êtes pas VIP Diamond/Prime !')
        return
	end

    if not IsPedInAnyVehicle(player, false) then
        ESX.ShowNotification('Vous n\'êtes pas dans un véhicule !')
        return
    end

    if autopilotActive and lastMode == "crazy" then
        ClearPedTasks(player)
        ESX.ShowNotification('Autopilote agressif - Désactivé')
        autopilotActive = false
    else
        if DoesBlipExist(GetFirstBlipInfoId(8)) then
            local blip = GetFirstBlipInfoId(8)
            local bCoords = GetBlipCoords(blip)
            local vehicle = GetVehiclePedIsIn(player, false)
            TaskVehicleDriveToCoord(player, vehicle, bCoords, tonumber(crazySpeed), 0, vehicle, crazyDriveStyle, 0, true)
            SetDriveTaskDrivingStyle(player, crazyDriveStyle)
            ESX.ShowNotification('Autopilote agressif - Activé')
            autopilotActive = true
            lastMode = "crazy"
        else
            ESX.ShowNotification('Vous n\'avez pas défini de point de navigation !')
        end
    end
end, false)
RegisterKeyMapping('+crazyautopilot', 'Autopilote agressif', 'keyboard', '')

function Draw3DTextH2(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(1)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

-- Propreté véhicules

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)

        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local veh = GetVehiclePedIsIn(playerPed, false)
            local driver = GetPedInVehicleSeat(veh, -1)

            if driver == playerPed then
                ESX.PlayerData = ESX.GetPlayerData()

                local ranks = ESX.PlayerData.rank
                local hasPrime = false

                for _, rankInfo in ipairs(ranks) do
                    if rankInfo.name == "prime" then
                        hasPrime = true
                        break
                    end
                end

                if hasPrime == true then
                    SetVehicleDirtLevel(veh, 0.0)
                end
            end
        end
    end
end)