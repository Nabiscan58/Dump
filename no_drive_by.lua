local passengerDriveBy = true

Citizen.CreateThread(function()
    while true do
        local playerPed = GetPlayerPed(-1)
        local playerId = PlayerId()
        local inVehicle = IsPedInAnyVehicle(playerPed, false)

        if inVehicle then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            local speed = GetEntitySpeed(vehicle) * 3.6
            
            if speed < 100 then
                SetPlayerCanDoDriveBy(playerId, true)
            else
                SetPlayerCanDoDriveBy(playerId, false)
            end
            
            Citizen.Wait(500)
        else
            SetPlayerCanDoDriveBy(playerId, false)
            Citizen.Wait(1000)
        end
    end
end)