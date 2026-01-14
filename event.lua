local IsHandcuffed = false

RegisterNetEvent('braco:handcuff')
AddEventHandler('braco:handcuff', function()
    IsHandcuffed    = not IsHandcuffed;
    local playerPed = PlayerPedId()
    Citizen.CreateThread(function()
        if IsHandcuffed then
            RequestAnimDict('mp_arresting')
            while not HasAnimDictLoaded('mp_arresting') do
              Wait(100)
            end
            TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            SetEnableHandcuffs(playerPed, true)
            SetPedCanPlayGestureAnims(playerPed, false)
        else
            ClearPedSecondaryTask(playerPed)
            SetEnableHandcuffs(playerPed, false)
            SetPedCanPlayGestureAnims(playerPed,  true)
        end
    end)
end)

RegisterNetEvent('braco:putInVehicle')
AddEventHandler('braco:putInVehicle', function()
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)

    if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then
        local vehicle = GetClosestVehicle(coords.x,  coords.y,  coords.z,  5.0,  0,  71)
        if DoesEntityExist(vehicle) then
            local maxSeats = GetVehicleMaxNumberOfPassengers(vehicle)
            local freeSeat = nil
            for i=maxSeats - 1, 0, -1 do
                if IsVehicleSeatFree(vehicle,  i) then
                    freeSeat = i
                    break
                end
            end
            if freeSeat ~= nil then
                TaskWarpPedIntoVehicle(playerPed,  vehicle,  freeSeat)
            end
        end
    end
end)

RegisterNetEvent('braco:putInVehicle2')
AddEventHandler('braco:putInVehicle2', function()
    isPut = true
end)

RegisterNetEvent('braco:OutVehicle')
AddEventHandler('braco:OutVehicle', function(t)
    local ped = GetPlayerPed(t)
    ClearPedTasksImmediately(ped)
    plyPos = GetEntityCoords(PlayerPedId(),  true)
    local xnew = plyPos.x+2
    local ynew = plyPos.y+2
    SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z)
end)

RegisterNetEvent('braco:OutVehicle2')
AddEventHandler('braco:OutVehicle2', function(t)
    isPut = false
end)

lockedControls = {
    {24, 30, 31, 32, 33, 34, 35, 69, 70, 92, 114, 121, 140, 141, 142, 257, 263, 264, 331, 17, 16, 15, 14, 241, 242, 332, 333, 14, 15, 16, 17, 27, 50, 96, 97, 99, 115, 180, 181, 198, 241, 242, 261, 262, 334, 335, 336, 348, 81, 82, 83, 84, 85}
}

Citizen.CreateThread(function()
    while true do
        local onhandcuffs = false

        if IsHandcuffed then
            onhandcuffs = true
            for k, v in pairs(lockedControls[1]) do
                DisableControlAction(0, v)
            end
            DisableControlAction(0, 142)
            DisableControlAction(0, 30)
            DisableControlAction(0, 31)
            DisableControlAction(0, 19)
        end

        if onhandcuffs then
            Wait(0)
        else
            Wait(1000)
        end
    end
end)

RegisterNetEvent('braco:drag')
AddEventHandler('braco:drag', function(cop)
    IsDragged = not IsDragged
    CopPed = tonumber(cop)
end)

local isPut = false

Citizen.CreateThread(function()
    while true do
        local onHands = false
        if IsHandcuffed then
            onHands = true
            if IsDragged then
                local ped = GetPlayerPed(GetPlayerFromServerId(CopPed))
                local myped = PlayerPedId()
                AttachEntityToEntity(myped, ped, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, true, false, 2, true)
            else
                DetachEntity(PlayerPedId(), true, false)
            end
        end
        
        if onHands then
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
    end
end)

RegisterNetEvent('gangs:getIdentity2')
AddEventHandler('gangs:getIdentity2', function(player)
    TriggerServerEvent("gangs:getPersonIdentity2", player)
end)

RegisterNetEvent('gangs:sendIdentityInfos2')
AddEventHandler('gangs:sendIdentityInfos2', function(firstname, lastname, name, sex, dob, height)
    ExecuteCommand("me prend une carte d'identité")
    ExecuteCommand("e idcard")

    if sex == "m" then
        sex = "Homme"
    elseif sex == "f" then
        sex = "Femme"
    end

    Citizen.Wait(1000)
    ESX.ShowAdvancedNotification('Identité', '~b~Citoyen', 'Prénom: ~y~'..firstname..'\n~w~Nom: ~y~' ..lastname..'\n~w~Taille: ~y~' ..height..'\n~w~Sex: ~y~' ..sex..'\n~w~Date de naissance: ~y~' ..dob..'\n~w~ID: ~y~' ..name, 'CHAR_BLANK_ENTRY', 8)
    Citizen.Wait(2000)

    ExecuteCommand("e stop_animation")
end)

function getIsHandcuffed()
    return IsHandcuffed
end