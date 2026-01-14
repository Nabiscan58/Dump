local inAnimation = false


RegisterNetEvent('scissors:useCiseaux')
AddEventHandler('scissors:useCiseaux', function()
    if exports.rg_core:InZoneSafe() then
        ESX.ShowNotification("~r~Vous ne pouvez pas utiliser les ciseaux en zone safe.")
        return
    end
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if inAnimation then 
        return
    end
    if closestPlayer ~= -1 and closestDistance <= 2.0 then
        inAnimation = true
        local closestPed = GetPlayerPed(closestPlayer)

        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local targetCoords = GetEntityCoords(closestPed)
        TaskTurnPedToFaceCoord(myPed, targetCoords.x, targetCoords.y, targetCoords.z, 1000)
        Wait(1000)
        TaskTurnPedToFaceCoord(closestPed, myCoords.x, myCoords.y, myCoords.z, 1000)
        Wait(1000)

        ExecuteCommand("e mechanic2")

        Citizen.Wait(1500)

        ClearPedTasksImmediately(myPed)
        ClearPedTasksImmediately(closestPed)

        TriggerServerEvent('scissors:applyCiseaux', GetPlayerServerId(closestPlayer))
        inAnimation = false
    else
        ESX.ShowNotification('Aucun joueur à proximité.')
    end
end)

RegisterNetEvent('scissors:cutHair')
AddEventHandler('scissors:cutHair', function()
    SetPedComponentVariation(PlayerPedId(), 2, 0, 0, 2)
    ESX.ShowNotification('Vous venez d\'être rasé !')
end)