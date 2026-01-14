RegisterNetEvent('skateItem:spawn')
AddEventHandler('skateItem:spawn', function()
    local modelHash = GetHashKey('skateboard')

    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Citizen.Wait(1)
    end

    local coords = GetEntityCoords(PlayerPedId())
    local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, GetEntityHeading(PlayerPedId()), true, false)

    SetVehicleNumberPlateText(vehicle, "BMX")
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetModelAsNoLongerNeeded(modelHash)

    exports.ox_target:addLocalEntity(vehicle, {
        {
            name = 'getBackSkate',
            icon = 'fa-solid fa-skateboard',
            label = 'Récupérer le skateboard',
            onSelect = function(data)
                DeleteEntity(vehicle)
                TriggerServerEvent('skateItem:give')
            end
        }
    })
end)