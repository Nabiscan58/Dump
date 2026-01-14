minimizedPropertys, minimizedBuildings, minimizedDeletePoints = {}, {}, {}

Citizen.CreateThread(function()
    Citizen.SetTimeout(5 * 1000, function()
        TriggerServerEvent("property:getMinimized")
    end)

    local lastCalled = 0
    while true do
        local interval = 2500

        for k,v in pairs(minimizedPropertys) do
            if not v.building then
                local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.door, true)

                if dst < 10.0 then
                    interval = 1
                    DrawMarker(6, v.door.x, v.door.y, v.door.z - 0.95, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
                end

                if dst < 2.5 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec la propriété", true)        

                    if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                        lastCalled = GetGameTimer() + 500
                        PROPERTY["propertyName"] = v.name
                        PROPERTY["handleMenu"](v)
                    end
                else
                    v.called = false
                end
            end
        end

        for k,v in pairs(minimizedBuildings) do
            if v.building then
                local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(v.door.x, v.door.y, v.door.z), true)

                if dst < 10.0 then
                    interval = 1
                    DrawMarker(6, v.door.x, v.door.y, v.door.z - 0.95, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
                end

                if dst < 2.5 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec le building", true) 

                    if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                        lastCalled = GetGameTimer() + 500
                        PROPERTY["propertyName"] = v.name
                        PROPERTY["handleMenu"](v)
                    end
                else
                    v.called = false
                end
            end
        end

        for k,v in pairs(minimizedDeletePoints) do
            if v.owner == playerUUID then
                local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(v.pos.x, v.pos.y, v.pos.z), true)

                if dst < 10.0 then
                    interval = 1
                    DrawMarker(6, v.pos.x, v.pos.y, v.pos.z - 0.95, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
                end

                if dst < 2.5 then
                    ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec le rangement véhicule", true) 

                    if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                        lastCalled = GetGameTimer() + 500
                        DeleteEntity(GetVehiclePedIsIn(PlayerPedId(), false))
                    end
                else
                    v.called = false
                end
            end
        end

        Citizen.Wait(interval)
    end
end)

Citizen.CreateThread(function()
    local called = {}
    while true do
        local interval = 800

        if PROPERTY["inProperty"] then
            interval = 1
            
            local entryDst = GetDistanceBetweenCoords(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].entry.x, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.y, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.z), GetEntityCoords(PlayerPedId()), true)
            if entryDst < 50.0 then
                DrawMarker(6, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.x, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.y, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.z - 0.95, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
            end

            if entryDst < 2.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec la propriété", true) 

                if IsControlJustPressed(0, 38) then
                    PROPERTY["exitMenu"]()
                end
            else
                called['entry'] = nil
            end

            local entryDst = GetDistanceBetweenCoords(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].chest.x, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.y, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.z), GetEntityCoords(PlayerPedId()), true)
            if entryDst < 50.0 then
                DrawMarker(6, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.x, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.y, PROPERTY["interiors"][PROPERTY["propertyId"]].chest.z - 0.95, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
            end

            if entryDst < 2.0 then    
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec le coffre de propriété", true) 

                if IsControlJustPressed(0, 38) then
                    PROPERTY["chestMenu"]()
                end
            else
                called['chest'] = nil
            end
        end

        if PROPERTY["inGarage"] then
            interval = 1

            local entryDst = GetDistanceBetweenCoords(vector3(PROPERTY["garages"][PROPERTY["garageInterior"]].entry.x, PROPERTY["garages"][PROPERTY["garageInterior"]].entry.y, PROPERTY["garages"][PROPERTY["garageInterior"]].entry.z), GetEntityCoords(PlayerPedId()), true)
            if entryDst < 50.0 then
                DrawMarker(6, PROPERTY["garages"][PROPERTY["garageInterior"]].entry.x, PROPERTY["garages"][PROPERTY["garageInterior"]].entry.y, PROPERTY["garages"][PROPERTY["garageInterior"]].entry.z - 0.95, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
            end

            if entryDst < 2.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir avec le garage", true) 

                if IsControlJustPressed(0, 38) then
                    PROPERTY["garageMenu"]()
                end
            else
                called['entry'] = nil
            end
        end

        Citizen.Wait(interval)
    end
end)

PROPERTY.isNearPoint = function()
    local near = false

    for k,v in pairs(minimizedPropertys) do
        if not v.building then
            local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.door, true)
            if dst < 2.5 then
                near = true
            end
        end
    end

    for k,v in pairs(minimizedBuildings) do
        if v.building then
            local dst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.door, true)
            if dst < 2.5 then
                near = true
            end
        end
    end

    if PROPERTY["propertyId"] then
        if PROPERTY["interiors"][PROPERTY["propertyId"]] then
            local entryDst = GetDistanceBetweenCoords(vector3(PROPERTY["interiors"][PROPERTY["propertyId"]].entry.x, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.y, PROPERTY["interiors"][PROPERTY["propertyId"]].entry.z), GetEntityCoords(PlayerPedId()), true)
            if entryDst < 2.0 then
                near = true
            end
        end
    end

    if PROPERTY["garageInterior"] then
        local entryDst = GetDistanceBetweenCoords(vector3(PROPERTY["garages"][PROPERTY["garageInterior"]].entry.x, PROPERTY["garages"][PROPERTY["garageInterior"]].entry.y, PROPERTY["garages"][PROPERTY["garageInterior"]].entry.z), GetEntityCoords(PlayerPedId()), true)
        if entryDst < 2.0 then
            near = true
        end
    end

    return near
end

Citizen.CreateThread(function()
    Citizen.SetTimeout(15 * 1000, function()
        TriggerServerEvent("property:checkLast")
    end)
end)