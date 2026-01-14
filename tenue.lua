local zones = {
    vector3(-663.00164794922, 317.94424438477, 88.016746520996),
    vector3(-539.50701904297, 7380.5947265625, 12.835194587708),
    vector3(1105.7364501953, 2738.1513671875, 38.709712982178)
}

Citizen.CreateThread(function()
    local attente = 1000
    while true do
        Wait(attente)
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        attente = 1000

        for _, zone in ipairs(zones) do
            local dst = GetDistanceBetweenCoords(pCoords, zone, true)
            if dst <= 20.0 then
                attente = 1
                DrawMarker(20, zone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 3, 254, 34, 255, 0, 0, 2, 1, nil, nil, 0)
                if dst <= 2.0 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_PICKUP~ pour reprendre vos affaires")
                    if IsControlJustReleased(1, 38) then
                        if not DansLeMal then
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                        else
                            ESX.ShowNotification("Tu ne peux pas prendre tes affaires pour l'instant")
                        end
                    end
                end
            end
        end
    end
end)