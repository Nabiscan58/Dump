RegisterNetEvent('bmxItem:spawn')
AddEventHandler('bmxItem:spawn', function()
    local modelHash = GetHashKey('bmx')

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
            name = 'getBackBMX',
            icon = 'fa-solid fa-bicycle',
            label = 'Récupérer le BMX',
            onSelect = function(data)
                DeleteEntity(vehicle)
                TriggerServerEvent('bmxItem:give')
            end
        }
    })
end)