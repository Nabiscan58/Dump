Citizen.CreateThread(function()
    while true do
        local pCoords = GetEntityCoords(PlayerPedId())
        local distance1 = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, 4840.571, -5174.425, 2.0, false)
        local distance2 = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, 4732.7255859375, 14054.213867188, 9.5573854446411, false)
        
        if distance1 < 1000.0 then
            if pCoords.z < -5 then
                for height = 1, 1000 do
                    SetEntityCoords(PlayerPedId(), pCoords.x, pCoords.y, height + 0.0)

                    local foundGround, zPos = GetGroundZFor_3dCoord(pCoords.x, pCoords.y, height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), pCoords.x, pCoords.y, height + 0.0)
                        break
                    end

                    Citizen.Wait(0)
                end
            end
        end
        if distance2 < 1000.0 then
            if pCoords.z < 5 then
                for height = 1, 1000 do
                    SetEntityCoords(PlayerPedId(), pCoords.x, pCoords.y, 15)

                    local foundGround, zPos = GetGroundZFor_3dCoord(pCoords.x, pCoords.y, height + 0.0)

                    if foundGround then
                        SetPedCoordsKeepVehicle(PlayerPedId(), pCoords.x, pCoords.y, height + 0.0)
                        break
                    end

                    Citizen.Wait(0)
                end
            end
        end

        if distance1 < 2500.0 then
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)
            Citizen.InvokeNative("0x5E1460624D194A38", true)
        else
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
            Citizen.InvokeNative("0x5E1460624D194A38", false)
        end
        
        Citizen.Wait(5000)
    end
end)