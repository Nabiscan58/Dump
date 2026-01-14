ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    ESX.PlayerData = ESX.GetPlayerData()

    if ESX.PlayerData.job.name == "streettuners" or ESX.PlayerData.job.name == "harmony" or ESX.PlayerData.job.name == "bennys" or ESX.PlayerData.job.name == "mayans" then
        loadMecanoDatas()
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
    if ESX.PlayerData.job.name == "streettuners" or ESX.PlayerData.job.name == "harmony" or ESX.PlayerData.job.name == "bennys" or ESX.PlayerData.job.name == "mayans" then
        loadMecanoDatas()
    end
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
	ESX.PlayerData.job.grade_name = grade
    if ESX.PlayerData.job.name == "streettuners" or ESX.PlayerData.job.name == "harmony" or ESX.PlayerData.job.name == "bennys" or ESX.PlayerData.job.name == "mayans" then
        loadMecanoDatas()
    end
end)

loadMecanoDatas = function()
    local LSC = {}
    LSC.oldProps = {}
    LSC.menuOpenned = false

    Citizen.CreateThread(function()
        while true do
            local nearThing = false
    
            for k,v in pairs(cfg_mecano.posList) do
                local plyCoords = GetEntityCoords(PlayerPedId(), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos)
    
                if dist <= 5.0 then
                    nearThing = true
                    ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour ouvrir le menu de customisation")
                    DrawMarker(6, v.pos, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
                    if IsControlJustPressed(1,38) and IsPedInAnyVehicle(PlayerPedId(), false) then
                        if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == 'streettuners' or ESX.PlayerData.job.name == 'harmony' or ESX.PlayerData.job.name == 'bennys' or ESX.PlayerData.job.name == 'mayans' then
                            if LSC.menuOpenned == false then
                                LSCopenMenu()
                                break
                            end
                        end
                    end
                end
            end

            for k,v in pairs(GetGamePool('CVehicle')) do
                if GetEntityModel(v) == GetHashKey("servicevan") and #(GetEntityCoords(v) - GetEntityCoords(PlayerPedId())) < 8.0 then
                    nearThing = true
                    local truckCoords = GetEntityCoords(v)
                    local markerDistance = 3.5
                    local markerHeading = GetEntityHeading(v)
                    local markerOffsetX = -markerDistance * math.cos(math.rad(markerHeading))
                    local markerOffsetY = -markerDistance * math.sin(math.rad(markerHeading))
            
                    if ESX.PlayerData.job.name == "harmony" and GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)) ~= GetHashKey("servicevan") then
                        ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour ouvrir le menu custom du camion")
                        DrawMarker(6, truckCoords.x + markerOffsetX, truckCoords.y + markerOffsetY, truckCoords.z - 1.2, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
                        if IsControlJustPressed(0, 38) and IsPedInAnyVehicle(PlayerPedId(), false) then
                            if LSC.menuOpenned == false then
                                LSCopenMenu()
                                break
                            end
                        end
                    end
                end
            end

            if nearThing then
                Citizen.Wait(0)
            else
                Citizen.Wait(500)
            end
        end
    end)

    function tablesAreEqual(table1, table2)
        if #table1 ~= #table2 then
            return false
        end
    
        for i, v in ipairs(table1) do
            if v ~= table2[i] then
                return false
            end
        end
    
        return true
    end
    
    RegisterNetEvent('custommenu:installMod')
    AddEventHandler('custommenu:installMod', function(modName, modValue)
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if (modName == "wheels") then
            if GetVehicleClass(vehicle) ~= 8 then
                LSC.oldProps["wheels"] = modValue[1]
                LSC.oldProps["modFrontWheels"] = modValue[2]
            else
                LSC.oldProps["wheels"] = modValue[1]
                LSC.oldProps["modFrontWheels"] = modValue[2]
                LSC.oldProps["modBackWheels"] = modValue[2]
            end
        elseif (modName == "neonEnabled" and tablesAreEqual(modValue, {1,1,1,1})) then
            LSC.oldProps[modName] = modValue
            LSC.oldProps.neonColor = {255, 255, 255}
        elseif (modName == "tyreSmokeColor") then
            LSC.oldProps.modSmokeEnabled = 1
            LSC.oldProps.tyreSmokeColor = modValue
        else
            LSC.oldProps[modName] = modValue
        end
        
        ESX.Game.SetVehicleProperties(vehicle, LSC.oldProps)
        myCar = ESX.Game.GetVehicleProperties(vehicle)
        LSC.oldProps = ESX.Game.GetVehicleProperties(vehicle)
        TriggerServerEvent('custommenu:refreshOwnedVehicle', myCar)
    end)

    RegisterNetEvent("custommenu:cancelInstallMod")
    AddEventHandler("custommenu:cancelInstallMod", function()
        ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false), LSC.oldProps)
    end)

    LSC.buy = function(modPrice, name, modName, modValue, plaque)
        TriggerServerEvent("custommenu:buyMod", modPrice, name, modName, modValue, plaque)
    end

    LSC.definePrice = function(vehiclePrice, modPrice)
        if vehiclePrice == 0 then return "GRATUIT" end
        if modPrice == 0 then return "GRATUIT" end
        if vehiclePrice * modPrice / 500 == 0 then return "GRATUIT" end

        return GroupDigits(vehiclePrice * modPrice / 500).."$"
    end
    
    LSC.gotBennys = function()
        if
        GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 25)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 26)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 27)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 28)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 29)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 30)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 31)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 32)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 33)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 34)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 35)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 36)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 37)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 38)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 39)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 40)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 41)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 42)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 43)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 44)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 45)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 46)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 48) > 0 then return true end

        return false
    end

    LSC.gotBodyparts = function()
        if
        GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false),   8)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 9)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 0)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 3)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 5)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 7)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 6)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 1)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 2)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 4)
        + GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 10) > 0 then return true end

        return false
    end

    LSCopenMenu = function()
        LSC.oldProps = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false))
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), true)

        local vehiclePrice = 4000000
        for k,v in pairs(cfg_mecano.vehicles) do
            for i,l in pairs(v.vehicles) do
                if GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false)) == GetHashKey(l.hash) then
                    vehiclePrice = l.price
                    break
                end
            end
        end

        RMenu.Add('lsc', 'main', RageUI.CreateMenu('PRIME', 'Menu de customisation', 1, 100))
        RMenu:Get('lsc', 'main'):SetRectangleBanner(255, 220, 0, 140)

        RMenu.Add('lsc', 'cosmetics', RageUI.CreateSubMenu(RMenu:Get('lsc', 'main'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'windowTint', RageUI.CreateSubMenu(RMenu:Get('lsc', 'cosmetics'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modHorns', RageUI.CreateSubMenu(RMenu:Get('lsc', 'cosmetics'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'neonEnabled', RageUI.CreateSubMenu(RMenu:Get('lsc', 'cosmetics'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'neonColors', RageUI.CreateSubMenu(RMenu:Get('lsc', 'neonEnabled'), "PRIME", "Menu de customisation"))
        
        RMenu.Add('lsc', 'wheels', RageUI.CreateSubMenu(RMenu:Get('lsc', 'cosmetics'), "PRIME", "Menu de customisation"))
        
        RMenu.Add('lsc', 'bennysc', RageUI.CreateSubMenu(RMenu:Get('lsc', 'cosmetics'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modPlateHolder', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modVanityPlate', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modTrimA', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modOrnaments', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modDashboard', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modDial', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modDoorSpeaker', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modSeats', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modSteeringWheel', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modShifterLeavers', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modAPlate', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modSpeakers', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modTrunk', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modHydrolic', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modEngineBlock', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        --RMenu.Add('lsc', 'modAirFilter', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modStruts', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modArchCover', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modAerials', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modTrimB', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modTank', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modWindows', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modLivery', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bennysc'), "PRIME", "Menu de customisation"))
        
        RMenu.Add('lsc', 'modXenon', RageUI.CreateSubMenu(RMenu:Get('lsc', 'cosmetics'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'xenonColour', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modXenon'), "PRIME", "Menu de customisation"))
        
        RMenu.Add('lsc', 'modFrontWheelsTypes', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheels'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'sport', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modFrontWheelsTypes'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'muscle', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modFrontWheelsTypes'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'lowrider', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modFrontWheelsTypes'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'suv', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modFrontWheelsTypes'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'allterrain', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modFrontWheelsTypes'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'tuning', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modFrontWheelsTypes'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'motorcycle', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modFrontWheelsTypes'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'highend', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modFrontWheelsTypes'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'bennys', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modFrontWheelsTypes'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'bespoke', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modFrontWheelsTypes'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'street', RageUI.CreateSubMenu(RMenu:Get('lsc', 'modFrontWheelsTypes'), "PRIME", "Menu de customisation"))
        
        RMenu.Add('lsc', 'modFrontWheelsColor', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheels'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'tyreSmokeColor', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheels'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'customTires', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheels'), "PRIME", "Menu de customisation"))
        
        RMenu.Add('lsc', 'resprays', RageUI.CreateSubMenu(RMenu:Get('lsc', 'cosmetics'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'plateIndex', RageUI.CreateSubMenu(RMenu:Get('lsc', 'resprays'), "PRIME", "Menu de customisation"))
        
        RMenu.Add('lsc', 'color1', RageUI.CreateSubMenu(RMenu:Get('lsc', 'resprays'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1black', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1white', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1grey', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1red', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1pink', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1blue', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1yellow', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1green', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1orange', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1brown', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1purple', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1chrome', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '1gold', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color1'), "PRIME", "Menu de customisation"))
        
        RMenu.Add('lsc', 'color2', RageUI.CreateSubMenu(RMenu:Get('lsc', 'resprays'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2black', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2white', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2grey', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2red', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2pink', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2blue', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2yellow', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2green', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2orange', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2brown', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2purple', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2chrome', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '2gold', RageUI.CreateSubMenu(RMenu:Get('lsc', 'color2'), "PRIME", "Menu de customisation"))
    
        RMenu.Add('lsc', 'pearlescentColor', RageUI.CreateSubMenu(RMenu:Get('lsc', 'resprays'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3black', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3white', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3grey', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3red', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3pink', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3blue', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3yellow', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3green', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3orange', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3brown', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3purple', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3chrome', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '3gold', RageUI.CreateSubMenu(RMenu:Get('lsc', 'pearlescentColor'), "PRIME", "Menu de customisation"))
    
        RMenu.Add('lsc', 'interiorColour', RageUI.CreateSubMenu(RMenu:Get('lsc', 'resprays'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4black', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4white', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4grey', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4red', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4pink', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4blue', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4yellow', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4green', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4orange', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4brown', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4purple', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4chrome', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '4gold', RageUI.CreateSubMenu(RMenu:Get('lsc', 'interiorColour'), "PRIME", "Menu de customisation"))
    
        RMenu.Add('lsc', 'dashboardColour', RageUI.CreateSubMenu(RMenu:Get('lsc', 'resprays'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5black', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5white', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5grey', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5red', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5pink', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5blue', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5yellow', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5green', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5orange', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5brown', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5purple', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5chrome', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '5gold', RageUI.CreateSubMenu(RMenu:Get('lsc', 'dashboardColour'), "PRIME", "Menu de customisation"))
    
        RMenu.Add('lsc', 'wheelColor', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheels'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6black', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6white', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6grey', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6red', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6pink', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6blue', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6yellow', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6green', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6orange', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6brown', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6purple', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6chrome', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', '6gold', RageUI.CreateSubMenu(RMenu:Get('lsc', 'wheelColor'), "PRIME", "Menu de customisation"))
    
        RMenu.Add('lsc', 'bodyparts', RageUI.CreateSubMenu(RMenu:Get('lsc', 'cosmetics'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modFender', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bodyparts'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modRightFender', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bodyparts'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modSpoilers', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bodyparts'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modSideSkirt', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bodyparts'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modFrame', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bodyparts'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modHood', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bodyparts'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modGrille', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bodyparts'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modFrontBumper', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bodyparts'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modRearBumper', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bodyparts'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modExhaust', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bodyparts'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modRoof', RageUI.CreateSubMenu(RMenu:Get('lsc', 'bodyparts'), "PRIME", "Menu de customisation"))
        
        RMenu.Add('lsc', 'upgrades', RageUI.CreateSubMenu(RMenu:Get('lsc', 'main'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modEngine', RageUI.CreateSubMenu(RMenu:Get('lsc', 'upgrades'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modBrakes', RageUI.CreateSubMenu(RMenu:Get('lsc', 'upgrades'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modTransmission', RageUI.CreateSubMenu(RMenu:Get('lsc', 'upgrades'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modSuspension', RageUI.CreateSubMenu(RMenu:Get('lsc', 'upgrades'), "PRIME", "Menu de customisation"))
        RMenu.Add('lsc', 'modTurbo', RageUI.CreateSubMenu(RMenu:Get('lsc', 'upgrades'), "PRIME", "Menu de customisation"))

        RMenu:Get('lsc', 'main').Closed = function()
            LSC.menuOpenned = false

            FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)

            for name, menu in pairs(RMenu['lsc']) do
                RMenu:Delete('lsc', name)
            end
        end
    
        for name, menu in pairs(RMenu['lsc']) do
            RMenu:Get('lsc', name).Closed = function()
                SetVehicleDoorsShut(GetVehiclePedIsIn(PlayerPedId(), false), false)
            end
        end
    
        LSC.menuOpenned = true
        RageUI.Visible(RMenu:Get('lsc', 'main'), true)
    
        LSC.antiSpam = {}
        ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false), LSC.oldProps)
    
        Citizen.CreateThread(function()
            while LSC.menuOpenned do
                Wait(1)
    
                local found = false
                if not RageUI.Visible(RMenu:Get('lsc', 'main')) then
                    for name, menu in pairs(RMenu['lsc']) do
                        if RageUI.Visible(RMenu:Get('lsc', name)) then
                            found = true
                        end
                    end
                    if not found then
                        LSC.menuOpenned = false

                        ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false), LSC.oldProps)
                        FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
                    end
                end

                if not IsPedInAnyVehicle(PlayerPedId(), false) then
                    LSC.menuOpenned = false
                    RageUI.CloseAll()

                    ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), true), LSC.oldProps)
                    FreezeEntityPosition(GetVehiclePedIsIn(PlayerPedId(), false), false)
                end
    
                RageUI.IsVisible(RMenu:Get('lsc', 'main'), true, true, true, function()
    
                    RageUI.Separator("Véhicule : ~y~" .. GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)))
                    RageUI.ButtonWithStyle("Performances", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'upgrades'))
                    RageUI.ButtonWithStyle("Cosmétiques", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'cosmetics'))

                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('lsc', 'upgrades'), true, true, true, function()
    
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 11)-1 > 0 then
                        RageUI.ButtonWithStyle("Moteur", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modEngine'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 12)-1 > 0 then
                        RageUI.ButtonWithStyle("Freinage", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modBrakes'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 13)-1 > 0 then
                        RageUI.ButtonWithStyle("Transmission", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modTransmission'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 15)-1 > 0 then
                        RageUI.ButtonWithStyle("Suspension", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modSuspension'))
                    end
                    RageUI.ButtonWithStyle("Turbo", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modTurbo'))
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modEngine'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 11) - 1
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}

                    modCount = math.min(modCount, 3)
                    if modCount > 0 then
                        for i = -1, modCount, 1 do
                            if LSC.oldProps.modEngine == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modEngine'][i])} end
                            RageUI.ButtonWithStyle(cfg_mecano.upgradeNames['modEngine'][i], nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modEngine == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modEngine'][i] / 500, cfg_mecano.upgradeNames['modEngine'][i], "modEngine", i, plaque)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modBrakes'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 12)-1
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}

                    modCount = math.min(modCount, 2)
                    if modCount > 0 then
                        for i = -1, modCount, 1 do
                            if LSC.oldProps.modBrakes == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modBrakes'][i])} end
                            RageUI.ButtonWithStyle(cfg_mecano.upgradeNames['modBrakes'][i], nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modBrakes == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modEngine'][i] / 500, cfg_mecano.upgradeNames['modBrakes'][i], 'modBrakes', i, plaque)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modTransmission'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 13)-1
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}

                    modCount = math.min(modCount, 2)
                    if modCount > 0 then
                        for i = -1, modCount, 1 do
                            if LSC.oldProps.modTransmission == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modTransmission'][i])} end
                            RageUI.ButtonWithStyle(cfg_mecano.upgradeNames['modTransmission'][i], nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modTransmission == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modTransmission'][i] / 500, cfg_mecano.upgradeNames['modTransmission'][i], 'modTransmission', i, plaque)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modSuspension'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 15)-1
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}

                    modCount = math.min(modCount, 3)
                    if modCount > 0 then
                        for i = -1, modCount, 1 do
                            if LSC.oldProps.modSuspension == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modSuspension'][i])} end
                            RageUI.ButtonWithStyle(cfg_mecano.upgradeNames['modSuspension'][i], nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modSuspension == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modSuspension'][i] / 500, cfg_mecano.upgradeNames['modSuspension'][i], 'modSuspension', i, plaque)
                                end
                                
                                if Active then
                                     SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 15, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modTurbo'), true, true, true, function()
    
                    local stock = {}
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    if not (LSC.oldProps.modTurbo == 1) then stock[1] = {RightBadge = RageUI.BadgeStyle.Cash} else stock[1] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modTurbo'][0])} end
                    RageUI.ButtonWithStyle("Turbo Stock", nil, stock[1], true, function(Hovered, Active, Selected)
                        if Selected then
                            if LSC.oldProps.modTurbo == 0 then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                            LSC.buy(vehiclePrice * cfg_mecano.modPrices['modTurbo'][0] / 500, "Turbo Stock", 'modTurbo', 0, plaque)
                        end
                    end)
    
                    if (LSC.oldProps.modTurbo == 1) then stock[2] = {RightBadge = RageUI.BadgeStyle.Cash} else stock[2] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modTurbo'][1])} end
                    RageUI.ButtonWithStyle("Turbo activé", nil, stock[2], true, function(Hovered, Active, Selected)
                        if Selected then
                            if LSC.oldProps.modTurbo == 1 then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                            LSC.buy(vehiclePrice * cfg_mecano.modPrices['modTurbo'][1] / 500, "Turbo activé", 'modTurbo', 1, plaque)
                        end
                    end)
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'cosmetics'), true, true, true, function()
    
                    if LSC.gotBodyparts() then
                        RageUI.ButtonWithStyle("Carrosserie", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'bodyparts'))
                    end
                    if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) ~= 8 then
                        RageUI.ButtonWithStyle("Fenêtre", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'windowTint'))
                    end
                    RageUI.ButtonWithStyle("Klaxon", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modHorns'))
                    if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) ~= 8 or not IsThisModelAQuadbike(GetEntityModel(GetVehiclePedIsUsing(PlayerPedId()))) then
                        RageUI.ButtonWithStyle("Neons", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'neonEnabled'))
                    end
                    RageUI.ButtonWithStyle("Xenon", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modXenon'))
                    RageUI.ButtonWithStyle("Peinture", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'resprays'))
                    RageUI.ButtonWithStyle("Roues", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'wheels'))

                    if LSC.gotBennys() then
                        RageUI.ButtonWithStyle("Benny's", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'bennysc'))
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'bennysc'), true, true, true, function()
    
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 25) > 0 then
                        RageUI.ButtonWithStyle("Contour de plaque", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 25)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modPlateHolder'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 26) > 0 then
                        RageUI.ButtonWithStyle("Plaque avant", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 26)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modVanityPlate'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 27) > 0 then
                        RageUI.ButtonWithStyle("Intérieur", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 27)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modTrimA'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 28) > 0 then
                        RageUI.ButtonWithStyle("Figurine", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 28)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modOrnaments'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 29) > 0 then
                        RageUI.ButtonWithStyle("Tableau de bord", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 29)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modDashboard'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 30) > 0 then
                        RageUI.ButtonWithStyle("Compteur", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 30)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modDial'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 31) > 0 then
                        RageUI.ButtonWithStyle("Enceintes portières", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 31)..")~s~ →→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local currVehicle = GetVehiclePedIsUsing(PlayerPedId())
                                for i=1, 6 do
                                    SetVehicleDoorOpen(currVehicle, i, false, false)
                                end
                            end
                        end, RMenu:Get('lsc', 'modDoorSpeaker'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 32) > 0 then
                        RageUI.ButtonWithStyle("Sièges", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 32)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modSeats'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 33) > 0 then
                        RageUI.ButtonWithStyle("Volant", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 33)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modSteeringWheel'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 34) > 0 then
                        RageUI.ButtonWithStyle("Levier de vitesse", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 34)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modShifterLeavers'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 35) > 0 then
                        RageUI.ButtonWithStyle("Plaque banquette", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 35)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modAPlate'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 36) > 0 then
                        RageUI.ButtonWithStyle("Sono", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 36)..")~s~ →→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                local currVehicle = GetVehiclePedIsUsing(PlayerPedId())
                                for i=1, 6 do
                                    SetVehicleDoorOpen(currVehicle, i, false, false)
                                end
                            end
                        end, RMenu:Get('lsc', 'modSpeakers'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 37) > 0 then
                        RageUI.ButtonWithStyle("Coffre", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 37)..")~s~ →→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                if Selected then
                                    local currVehicle = GetVehiclePedIsUsing(PlayerPedId())
                                    SetVehicleDoorOpen(currVehicle, 5, false, false)
                                end
                            end
                        end, RMenu:Get('lsc', 'modTrunk'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 38) > 0 then
                        RageUI.ButtonWithStyle("Hydrolique", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 38)..")~s~ →→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                if Selected then
                                    local currVehicle = GetVehiclePedIsUsing(PlayerPedId())
                                    SetVehicleDoorOpen(currVehicle, 5, false, false)
                                end
                            end
                        end, RMenu:Get('lsc', 'modHydrolic'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 39) > 0 then
                        RageUI.ButtonWithStyle("Bloc moteur", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 39)..")~s~ →→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                if Selected then
                                    local currVehicle = GetVehiclePedIsUsing(PlayerPedId())
                                    SetVehicleDoorOpen(currVehicle, 4, false, false)
                                end
                            end
                        end, RMenu:Get('lsc', 'modEngineBlock'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 40) > 0 then
                        RageUI.ButtonWithStyle("Filtre à air", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 40)..")~s~ →→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                if Selected then
                                    local currVehicle = GetVehiclePedIsUsing(PlayerPedId())
                                    SetVehicleDoorOpen(currVehicle, 4, false, false)
                                end
                            end
                        end, RMenu:Get('lsc', 'modAirFilter'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 41) > 0 then
                        RageUI.ButtonWithStyle("Struts", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 41)..")~s~ →→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                if Selected then
                                    local currVehicle = GetVehiclePedIsUsing(PlayerPedId())
                                    SetVehicleDoorOpen(currVehicle, 4, false, false)
                                end
                            end
                        end, RMenu:Get('lsc', 'modStruts'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 42) > 0 then
                        RageUI.ButtonWithStyle("Décoration", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 42)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modArchCover'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 43) > 0 then
                        RageUI.ButtonWithStyle("Antennes", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 43)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modAerials'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 44) > 0 then
                        RageUI.ButtonWithStyle("Ailes", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 44)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modTrimB'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 45) > 0 then
                        RageUI.ButtonWithStyle("Réservoir d'essence", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 45)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modTank'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 46) > 0 then
                        RageUI.ButtonWithStyle("Fenêtres", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 46)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modWindows'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 48) > 0 then
                        RageUI.ButtonWithStyle("Stickers", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 48)..")~s~ →→→"}, true, function(Hovered, Active, Selected)
                        end, RMenu:Get('lsc', 'modLivery'))
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modLivery'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 48)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 48, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Stickers' end
                        if LSC.oldProps.modLivery == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modLivery'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modLivery == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modLivery'] / 500, modName, 'modLivery', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 48, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modWindows'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 46)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 46, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Fenêtres' end
                        if LSC.oldProps.modWindows == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modWindows'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modWindows == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modWindows'] / 500, modName, 'modWindows', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 46, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modTank'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 45)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 45, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Réservoir d\'essence' end
                        if LSC.oldProps.modTank == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modTank'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modTank == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modTank'] / 500, modName, 'modTank', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 45, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modTrimB'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 44)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 44, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Ailes' end
                        if LSC.oldProps.modTrimB == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modTrimB'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modTrimB == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modTrimB'] / 500, modName, 'modTrimB', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 44, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modAerials'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 43)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 43, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Antennes' end
                        if LSC.oldProps.modAerials == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modAerials'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modAerials == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modAerials'] / 500, modName, 'modAerials', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 43, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modArchCover'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 42)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 42, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Décoration' end
                        if LSC.oldProps.modArchCover == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modArchCover'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modArchCover == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modArchCover'] / 500, modName, 'modArchCover', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 42, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modStruts'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 41)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 41, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Struts' end
                        if LSC.oldProps.modStruts == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modStruts'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modStruts == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modStruts'] / 500, modName, 'modStruts', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 41, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modAirFilter'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 40)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 40, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Filtre à air' end
                        if LSC.oldProps.modAirFilter == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modAirFilter'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modAirFilter == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modAirFilter'] / 500, modName, 'modAirFilter', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 40, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modEngineBlock'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 39)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 39, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Bloc moteur' end
                        if LSC.oldProps.modEngineBlock == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modEngineBlock'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modEngineBlock == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modEngineBlock'] / 500, modName, 'modEngineBlock', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 39, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modHydrolic'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 38)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 38, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Hydrolique' end
                        if LSC.oldProps.modHydrolic == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modHydrolic'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modHydrolic == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modHydrolic'] / 500, modName, 'modHydrolic', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 38, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modTrunk'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 37)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 37, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Coffre' end
                        if LSC.oldProps.modTrunk == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modTrunk'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modTrunk == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modTrunk'] / 500, modName, 'modTrunk', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 37, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modSpeakers'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 36)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 36, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Sono' end
                        if LSC.oldProps.modSpeakers == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modSpeakers'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modSpeakers == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modSpeakers'] / 500, modName, 'modSpeakers', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 36, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modAPlate'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 35)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 35, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Plaque banquette' end
                        if LSC.oldProps.modAPlate == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modAPlate'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modAPlate == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modAPlate'] / 500, modName, 'modAPlate', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 35, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modShifterLeavers'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 34)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 34, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Levier de vitesse' end
                        if LSC.oldProps.modShifterLeavers == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modShifterLeavers'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modShifterLeavers == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modShifterLeavers'] / 500, modName, 'modShifterLeavers', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 34, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modSteeringWheel'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 33)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 33, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Volant' end
                        if LSC.oldProps.modSteeringWheel == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modSteeringWheel'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modSteeringWheel == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modSteeringWheel'] / 500, modName, 'modSteeringWheel', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 33, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modSeats'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 32)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 32, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Sièges' end
                        if LSC.oldProps.modSeats == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modSeats'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modSeats == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modSeats'] / 500, modName, 'modSeats', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 32, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modDoorSpeaker'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 31)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 31, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Enceintes portières' end
                        if LSC.oldProps.modDoorSpeaker == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modDoorSpeaker'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modDoorSpeaker == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modDoorSpeaker'] / 500, modName, 'modDoorSpeaker', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 31, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modDial'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 30)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 30, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Compteur' end
                        if LSC.oldProps.modDial == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modDial'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modDial == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modDial'] / 500, modName, 'modDial', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 30, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modDashboard'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 29)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 29, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Tableau de bord' end
                        if LSC.oldProps.modDashboard == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modDashboard'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modDashboard == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modDashboard'] / 500, modName, 'modDashboard', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 29, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modOrnaments'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 28)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 28, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Figurine' end
                        if LSC.oldProps.modOrnaments == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modOrnaments'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modOrnaments == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modOrnaments'] / 500, modName, 'modOrnaments', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 28, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modTrimA'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 27)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 27, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Intérieur' end
                        if LSC.oldProps.modTrimA == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modTrimA'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modTrimA == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modTrimA'] / 500, modName, 'modTrimA', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 27, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modVanityPlate'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 26)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 26, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Plaque avant' end
                        if LSC.oldProps.modVanityPlate == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modVanityPlate'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modVanityPlate == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modVanityPlate'] / 500, modName, 'modVanityPlate', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 26, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modPlateHolder'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 25)-1, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 25, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 1 then modName = 'Stock Plaque' end
                        if LSC.oldProps.modPlateHolder == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modPlateHolder'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modPlateHolder == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modPlateHolder'] / 500, modName, 'modPlateHolder', i, plaque)
                            end
    
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 25, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'wheels'), true, true, true, function()
    
                    RageUI.ButtonWithStyle("Type de roues", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modFrontWheelsTypes'))
                    RageUI.ButtonWithStyle("Couleur des roues", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'wheelColor'))
                    RageUI.ButtonWithStyle("Fumée de pneu", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'tyreSmokeColor'))
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'tyreSmokeColor'), true, true, true, function()
    
                    for k,v in pairs(GetNeons()) do
                        local right    = {}
                        if v.r == LSC.oldProps.tyreSmokeColor[1] and v.g == LSC.oldProps.tyreSmokeColor[2] and v.b == LSC.oldProps.tyreSmokeColor[3] then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['tyreSmokeColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if (v.r == LSC.oldProps.tyreSmokeColor[1] and v.g == LSC.oldProps.tyreSmokeColor[2] and v.b == LSC.oldProps.tyreSmokeColor[3]) then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['tyreSmokeColor'] / 500, "Fumée de pneu "..v.label, 'tyreSmokeColor', {v.r, v.g, v.b}, plaque)
                            end
        
                            if Active then
                                SetVehicleTyreSmokeColor(GetVehiclePedIsIn(PlayerPedId(), false), v.r, v.g, v.b)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modFrontWheelsTypes'), true, true, true, function()
    
                    if not IsThisModelABike(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) then
                        RageUI.ButtonWithStyle("Sport", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'sport'))
                        RageUI.ButtonWithStyle("Muscle", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'muscle'))
                        RageUI.ButtonWithStyle("Lowrider", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'lowrider'))
                        RageUI.ButtonWithStyle("SUV", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'suv'))
                        RageUI.ButtonWithStyle("Tout terrain", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'allterrain'))
                        RageUI.ButtonWithStyle("Tuning", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'tuning'))
                    end
    
                    RageUI.ButtonWithStyle("Moto", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'motorcycle'))
                    
                    if not IsThisModelABike(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) then
                        RageUI.ButtonWithStyle("Highend", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'highend'))
                        RageUI.ButtonWithStyle("Benny's", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'bennys'))
                        RageUI.ButtonWithStyle("Sur mesure", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'bespoke'))
                        RageUI.ButtonWithStyle("Street", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'street'))
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'sport'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    local wheelType = GetVehicleWheelType(vehicle)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i=-1, 300, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 5 then modName = 'Sport Stock' end
                        if modName == 'NULL' and i > 5 then modName = 'Inconnu' end
                        if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['sport'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['sport'] / 500, "Roues "..modName, 'wheels', {0, i}, plaque)
                            end
    
                            if Active then
                                if not IsThisModelABike(GetEntityModel(GetVehiclePedIsIn(PlayerPedId(), false))) then
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 0)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                else
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 0)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 24, i, false)
                                end
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'muscle'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    local wheelType = GetVehicleWheelType(vehicle)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for i=0, 200, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 5 then modName = 'Muscle Stock' end
                        if modName == 'NULL' and i > 5 then modName = 'Inconnu' end
                        if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['muscle'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['muscle'] / 500, "Roues "..modName, 'wheels', {1, i}, plaque)
                            end
    
                            if Active then
                                if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 1)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                else
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 1)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 24, i, false)
                                end
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'lowrider'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local wheelType = GetVehicleWheelType(vehicle)
                    local right    = {}
                    for i=0, 200, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 5 then modName = 'Lowrider Stock' end
                        if modName == 'NULL' and i > 5 then modName = 'Inconnu' end
                        if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['lowrider'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['lowrider'] / 500, "Roues "..modName, 'wheels', {2, i}, plaque)
                            end
    
                            if Active then
                                if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 2)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                else
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 2)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 24, i, false)
                                end
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'suv'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local wheelType = GetVehicleWheelType(vehicle)
                    local right    = {}
                    for i=0, 200, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 5 then modName = 'SUV Stock' end
                        if modName == 'NULL' and i > 5 then modName = 'Inconnu' end
                        if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['suv'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['suv'] / 500, "Roues "..modName, 'wheels', {3, i}, plaque)
                            end
    
                            if Active then
                                if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 3)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                else
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 3)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 24, i, false)
                                end
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'allterrain'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local wheelType = GetVehicleWheelType(vehicle)
                    local right    = {}
                    for i=0, 200, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 5 then modName = 'Allterrain Stock' end
                        if modName == 'NULL' and i > 5 then modName = 'Inconnu' end
                        if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['allterrain'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['allterrain'] / 500, "Roues "..modName, 'wheels', {4, i}, plaque)
                            end
    
                            if Active then
                                if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 4)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                else
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 4)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 24, i, false)
                                end
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'tuning'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local wheelType = GetVehicleWheelType(vehicle)
                    local right    = {}
                    for i=0, 200, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 5 then modName = 'Tuning Stock' end
                        if modName == 'NULL' and i > 5 then modName = 'Inconnu' end
                        if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['tuning'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['tuning'] / 500, "Roues "..modName, 'wheels', {5, i}, plaque)
                            end
    
                            if Active then
                                if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 5)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                else
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 5)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 24, i, false)
                                end
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'motorcycle'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local wheelType = GetVehicleWheelType(vehicle)
                    local right    = {}
                    for i=-1, 200, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 5 then modName = 'Motorcycle Stock' end
                        if modName == 'NULL' and i > 5 then modName = 'Inconnu' end
                        if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['motorcycle'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['motorcycle'] / 500, "Roues "..modName, 'wheels', {6, i}, plaque)
                            end
    
                            if Active then
                                if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 6)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                else
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 6)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 24, i, false)
                                end
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'highend'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local wheelType = GetVehicleWheelType(vehicle)
                    local right    = {}
                    for i=0, 200, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 5 then modName = 'Highend Stock' end
                        if modName == 'NULL' and i > 5 then modName = 'Inconnu' end
                        if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['highend'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['highend'] / 500, "Roues "..modName, 'wheels', {7, i}, plaque)
                            end
    
                            if Active then
                                if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 7)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                else
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 7)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 24, i, false)
                                end
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'bennys'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local wheelType = GetVehicleWheelType(vehicle)
                    local right    = {}
                    for i=0, 217, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 5 then modName = 'Benny\'s Stock' end
                        if modName == 'NULL' and i > 5 then modName = 'Inconnu' end
                        if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['bennys'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['bennys'] / 500, "Roues "..modName, 'wheels', {8, i}, plaque)
                            end
    
                            if Active then
                                if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 8)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                else
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 8)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 24, i, false)
                                end
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'bespoke'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local wheelType = GetVehicleWheelType(vehicle)
                    local right    = {}
                    for i=0, 200, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 5 then modName = 'Bespoke Stock' end
                        if modName == 'NULL' and i > 5 then modName = 'Inconnu' end
                        if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['bespoke'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['bespoke'] / 500, "Roues "..modName, 'wheels', {9, i}, plaque)
                            end
    
                            if Active then
                                if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 9)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                else
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 9)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 24, i, false)
                                end
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'street'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local wheelType = GetVehicleWheelType(vehicle)
                    local right    = {}
                    for i=0, 200, 1 do
                        local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 23, i)
                        modName = GetLabelText(modName)
                        if modName == 'NULL' and i < 5 then modName = 'Street Stock' end
                        if modName == 'NULL' and i > 5 then modName = 'Inconnu' end
                        if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['street'])} end
                        RageUI.ButtonWithStyle(modName, nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modFrontWheels == i and wheelType == LSC.oldProps.wheels then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['street'] / 500, "Roues " .. modName, 'wheels', {10, i}, plaque)
                            end
    
                            if Active then
                                if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId(), false)) ~= 8 then
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 10)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                else
                                    SetVehicleWheelType(GetVehiclePedIsIn(PlayerPedId(), false), 10)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 23, i, false)
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 24, i, false)
                                end
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'resprays'), true, true, true, function()
    
                    RageUI.ButtonWithStyle("Peinture principale", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'color1'))
                    RageUI.ButtonWithStyle("Peinture secondaire", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'color2'))
                    RageUI.ButtonWithStyle("Nacrage", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'pearlescentColor'))
                    RageUI.ButtonWithStyle("Intérieur", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'interiorColour'))
                    RageUI.ButtonWithStyle("Tableau de bord", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'dashboardColour'))
                    RageUI.ButtonWithStyle("Plaque", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'plateIndex'))
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'plateIndex'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    for i = 0, 4, 1 do
                        if LSC.oldProps.plateIndex == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['plateIndex'])} end
                        RageUI.ButtonWithStyle(GetPlatesName(i), nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.plateIndex == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['plateIndex'] / 500, "Plaque "..GetPlatesName(i), "plateIndex", i, plaque)
                            end
                            
                            if Active then
                                SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(PlayerPedId(), false), i)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'color1'), true, true, true, function()
    
                    RageUI.ButtonWithStyle("Noir", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1black'))
                    RageUI.ButtonWithStyle("Blanc", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1white'))
                    RageUI.ButtonWithStyle("Gris", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1grey'))
                    RageUI.ButtonWithStyle("Rouge", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1red'))
                    RageUI.ButtonWithStyle("Rose", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1pink'))
                    RageUI.ButtonWithStyle("Bleu", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1blue'))
                    RageUI.ButtonWithStyle("Jaune", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1yellow'))
                    RageUI.ButtonWithStyle("Vert", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1green'))
                    RageUI.ButtonWithStyle("Orange", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1orange'))
                    RageUI.ButtonWithStyle("Marron", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1brown'))
                    RageUI.ButtonWithStyle("Violet", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1purple'))
                    RageUI.ButtonWithStyle("Chrome", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1chrome'))
                    RageUI.ButtonWithStyle("Or", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '1gold'))
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'color2'), true, true, true, function()
    
                    RageUI.ButtonWithStyle("Noir", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2black'))
                    RageUI.ButtonWithStyle("Blanc", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2white'))
                    RageUI.ButtonWithStyle("Gris", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2grey'))
                    RageUI.ButtonWithStyle("Rouge", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2red'))
                    RageUI.ButtonWithStyle("Rose", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2pink'))
                    RageUI.ButtonWithStyle("Bleu", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2blue'))
                    RageUI.ButtonWithStyle("Jaune", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2yellow'))
                    RageUI.ButtonWithStyle("Vert", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2green'))
                    RageUI.ButtonWithStyle("Orange", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2orange'))
                    RageUI.ButtonWithStyle("Marron", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2brown'))
                    RageUI.ButtonWithStyle("Violet", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2purple'))
                    RageUI.ButtonWithStyle("Chrome", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2chrome'))
                    RageUI.ButtonWithStyle("Or", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '2gold'))
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'pearlescentColor'), true, true, true, function()
    
                    RageUI.ButtonWithStyle("Noir", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3black'))
                    RageUI.ButtonWithStyle("Blanc", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3white'))
                    RageUI.ButtonWithStyle("Gris", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3grey'))
                    RageUI.ButtonWithStyle("Rouge", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3red'))
                    RageUI.ButtonWithStyle("Rose", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3pink'))
                    RageUI.ButtonWithStyle("Bleu", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3blue'))
                    RageUI.ButtonWithStyle("Jaune", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3yellow'))
                    RageUI.ButtonWithStyle("Vert", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3green'))
                    RageUI.ButtonWithStyle("Orange", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3orange'))
                    RageUI.ButtonWithStyle("Marron", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3brown'))
                    RageUI.ButtonWithStyle("Violet", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3purple'))
                    RageUI.ButtonWithStyle("Chrome", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3chrome'))
                    RageUI.ButtonWithStyle("Or", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '3gold'))
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'interiorColour'), true, true, true, function()
    
                    RageUI.ButtonWithStyle("Noir", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4black'))
                    RageUI.ButtonWithStyle("Blanc", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4white'))
                    RageUI.ButtonWithStyle("Gris", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4grey'))
                    RageUI.ButtonWithStyle("Rouge", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4red'))
                    RageUI.ButtonWithStyle("Rose", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4pink'))
                    RageUI.ButtonWithStyle("Bleu", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4blue'))
                    RageUI.ButtonWithStyle("Jaune", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4yellow'))
                    RageUI.ButtonWithStyle("Vert", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4green'))
                    RageUI.ButtonWithStyle("Orange", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4orange'))
                    RageUI.ButtonWithStyle("Marron", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4brown'))
                    RageUI.ButtonWithStyle("Violet", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4purple'))
                    RageUI.ButtonWithStyle("Chrome", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4chrome'))
                    RageUI.ButtonWithStyle("Or", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '4gold'))
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'dashboardColour'), true, true, true, function()
    
                    RageUI.ButtonWithStyle("Noir", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5black'))
                    RageUI.ButtonWithStyle("Blanc", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5white'))
                    RageUI.ButtonWithStyle("Gris", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5grey'))
                    RageUI.ButtonWithStyle("Rouge", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5red'))
                    RageUI.ButtonWithStyle("Rose", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5pink'))
                    RageUI.ButtonWithStyle("Bleu", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5blue'))
                    RageUI.ButtonWithStyle("Jaune", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5yellow'))
                    RageUI.ButtonWithStyle("Vert", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5green'))
                    RageUI.ButtonWithStyle("Orange", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5orange'))
                    RageUI.ButtonWithStyle("Marron", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5brown'))
                    RageUI.ButtonWithStyle("Violet", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5purple'))
                    RageUI.ButtonWithStyle("Chrome", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5chrome'))
                    RageUI.ButtonWithStyle("Or", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '5gold'))
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'wheelColor'), true, true, true, function()
    
                    RageUI.ButtonWithStyle("Noir", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6black'))
                    RageUI.ButtonWithStyle("Blanc", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6white'))
                    RageUI.ButtonWithStyle("Gris", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6grey'))
                    RageUI.ButtonWithStyle("Rouge", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6red'))
                    RageUI.ButtonWithStyle("Rose", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6pink'))
                    RageUI.ButtonWithStyle("Bleu", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6blue'))
                    RageUI.ButtonWithStyle("Jaune", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6yellow'))
                    RageUI.ButtonWithStyle("Vert", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6green'))
                    RageUI.ButtonWithStyle("Orange", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6orange'))
                    RageUI.ButtonWithStyle("Marron", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6brown'))
                    RageUI.ButtonWithStyle("Violet", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6purple'))
                    RageUI.ButtonWithStyle("Chrome", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6chrome'))
                    RageUI.ButtonWithStyle("Or", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', '6gold'))
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6black'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('black')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6white'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('white')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6grey'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('grey')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6red'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('red')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6pink'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('pink')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6blue'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('blue')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6yellow'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('yellow')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6green'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('green')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6orange'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('orange')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6brown'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('brown')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6purple'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('purple')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6chrome'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('chrome')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '6gold'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('gold')) do
                        if LSC.oldProps.wheelColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['wheelColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.wheelColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['wheelColor'] / 500, "Peinture "..v.label, 'wheelColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), pearlescentColor, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5black'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('black')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5white'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('white')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5grey'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('grey')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5red'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('red')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5pink'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('pink')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5blue'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('blue')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5yellow'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('yellow')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5green'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('green')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
    
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5orange'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('orange')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5brown'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('brown')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5purple'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('purple')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5chrome'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('chrome')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '5gold'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('gold')) do
                        if LSC.oldProps.dashboardColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['dashboardColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.dashboardColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['dashboardColour'] / 500, "Peinture "..v.label, 'dashboardColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleDashboardColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4black'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('black')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['interiorColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4white'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('white')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['interiorColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4grey'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('grey')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['interiorColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4red'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('red')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['interiorColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4pink'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('pink')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['interiorColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4blue'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('blue')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['interiorColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4yellow'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('yellow')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['interiorColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4green'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('green')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['interiorColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
    
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4orange'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('orange')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['interiorColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4brown'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('brown')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['interiorColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4purple'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('purple')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['interiorColour'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4chrome'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('chrome')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '4gold'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('gold')) do
                        if LSC.oldProps.interiorColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.interiorColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['interiorColour'] / 500, "Peinture "..v.label, 'interiorColor', v.index, plaque)
                            end
                            
                            if Active then
                                SetVehicleInteriorColour(GetVehiclePedIsIn(PlayerPedId()), v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3black'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('black')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3white'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('white')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3grey'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('grey')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3red'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('red')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3pink'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('pink')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3blue'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('blue')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3yellow'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('yellow')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3green'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('green')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
    
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3orange'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('orange')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3brown'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('brown')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3purple'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('purple')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3chrome'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('chrome')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '3gold'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('gold')) do
                        if LSC.oldProps.pearlescentColor == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['pearlescentColor'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.pearlescentColor == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['pearlescentColor'] / 500, "Peinture "..v.label, 'pearlescentColor', v.index, plaque)
                            end
                            
                            if Active then
                                local pearlescentColor, wheelColor = GetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleExtraColours(GetVehiclePedIsIn(PlayerPedId()), v.index, wheelColor)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2black'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('black')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2white'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('white')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2grey'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('grey')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2red'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('red')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2pink'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('pink')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2blue'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('blue')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2yellow'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('yellow')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2green'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('green')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
    
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2orange'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('orange')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2brown'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('brown')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2purple'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('purple')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2chrome'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('chrome')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '2gold'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('gold')) do
                        if LSC.oldProps.color2 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color2'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color2 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color2'] / 500, "Peinture "..v.label, 'color2', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), color1, v.index)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1black'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('black')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1white'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('white')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1grey'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('grey')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1red'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('red')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1pink'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('pink')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1blue'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('blue')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1yellow'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('yellow')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1green'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('green')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1orange'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('orange')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1brown'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('brown')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1purple'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('purple')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1chrome'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('chrome')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', '1gold'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for k,v in pairs(GetColors('gold')) do
                        if LSC.oldProps.color1 == v.index then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['color1'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.color1 == v.index then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['color1'] / 500, "Peinture "..v.label, 'color1', v.index, plaque)
                            end
                            
                            if Active then
                                local color1, color2 = GetVehicleColours(GetVehiclePedIsIn(PlayerPedId()))
                                SetVehicleColours(GetVehiclePedIsIn(PlayerPedId()), v.index, color2)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'modXenon'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local stock = {}
                    if not (LSC.oldProps.modXenon == 1) then stock[1] = {RightBadge = RageUI.BadgeStyle.Cash} else stock[1] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modXenon'][0])} end
                    RageUI.ButtonWithStyle("Xenon Stock", nil, stock[1], true, function(Hovered, Active, Selected)
                        if Selected then
                            if LSC.oldProps.modXenon == 0 then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                            LSC.buy(vehiclePrice * cfg_mecano.modPrices['modXenon'][0] / 500, "Xenon Stock", 'modXenon', 0, plaque)
                        end
                        
                        if Active then
                            ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 22, false)
                        end
                    end)
    
                    if (LSC.oldProps.modXenon == 1) then stock[2] = {RightBadge = RageUI.BadgeStyle.Cash} else stock[2] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modXenon'][1])} end
                    RageUI.ButtonWithStyle("Xenon activés", nil, stock[2], true, function(Hovered, Active, Selected)
                        if Selected then
                            if LSC.oldProps.modXenon == 1 then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                            LSC.buy(vehiclePrice * cfg_mecano.modPrices['modXenon'][1] / 500, "Xenon activés", 'modXenon', 1, plaque)
                        end
                        
                        if Active then
                            ToggleVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 22, true)
                        end
                    end)
    
                    if (LSC.oldProps.modXenon == 1) then
                        RageUI.ButtonWithStyle("Couleur xenons", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'xenonColour'))
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'xenonColour'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    for i = 0, 12, 1 do
                        local right    = {}
                        if LSC.oldProps.xenonColor == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['xenonColor'])} end
                        RageUI.ButtonWithStyle(GetXenonColorName(i), nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.xenonColor == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['xenonColor'] / 500, "Couleur Xenon "..GetXenonColorName(i), 'xenonColor', i, plaque)
                            end
        
                            if Active then
                                SetVehicleHeadlightsColour(GetVehiclePedIsIn(PlayerPedId(), false), i)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'neonEnabled'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local stock = {}
                    if not (LSC.oldProps.neonEnabled[1] == 1) then stock[1] = {RightBadge = RageUI.BadgeStyle.Cash} else stock[1] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['neonEnabled'][0])} end
                    RageUI.ButtonWithStyle("Neon Stock", nil, stock[1], true, function(Hovered, Active, Selected)
                        if Selected then
                            if LSC.oldProps.neonEnabled[1] == 0 then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                            LSC.buy(vehiclePrice * cfg_mecano.modPrices['neonEnabled'][0] / 500, "Neon Stock", 'neonEnabled', {0,0,0,0}, plaque)
                        end
                        
                        if Active then
                            SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId()), 0, false)
                            SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId()), 1, false)
                            SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId()), 2, false)
                            SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId()), 3, false)
                        end
                    end)
    
                    if (LSC.oldProps.neonEnabled[1] == 1) then stock[2] = {RightBadge = RageUI.BadgeStyle.Cash} else stock[2] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['neonEnabled'][1])} end
                    RageUI.ButtonWithStyle("Neon activés", nil, stock[2], true, function(Hovered, Active, Selected)
                        if Selected then
                            if LSC.oldProps.neonEnabled[1] == 1 then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                            LSC.buy(vehiclePrice * cfg_mecano.modPrices['neonEnabled'][1] / 500, "Neon activés", 'neonEnabled', {1,1,1,1}, plaque)
                        end
                        
                        if Active then
                            SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId()), 0, true)
                            SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId()), 1, true)
                            SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId()), 2, true)
                            SetVehicleNeonLightEnabled(GetVehiclePedIsIn(PlayerPedId()), 3, true)
                            SetVehicleNeonLightsColour(GetVehiclePedIsIn(PlayerPedId()), 255, 255, 255)
                        end
                    end)
    
                    if (LSC.oldProps.neonEnabled[1] == 1) then
                        RageUI.ButtonWithStyle("Couleur néons", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'neonColors'))
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'neonColors'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    for k,v in pairs(GetNeons()) do
                        local right    = {}
                        if v.r == LSC.oldProps.neonColor[1] and v.g == LSC.oldProps.neonColor[2] and v.b == LSC.oldProps.neonColor[3] then right[k] = {RightBadge = RageUI.BadgeStyle.Cash} else right[k] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['neonColors'])} end
                        RageUI.ButtonWithStyle(v.label, nil, right[k], true, function(Hovered, Active, Selected)
                            if Selected then
                                if (v.r == LSC.oldProps.neonColor[1] and v.g == LSC.oldProps.neonColor[2] and v.b == LSC.oldProps.neonColor[3]) then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['neonColors'] / 500, "Couleur néons "..v.label, 'neonColor',  {v.r , v.g , v.b} , plaque)
                            end
        
                            if Active then
                                SetVehicleNeonLightsColour(GetVehiclePedIsIn(PlayerPedId(), false), v.r, v.g, v.b)
                            end
                        end)
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modHorns'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for i=-1, 45, 1 do
                        if LSC.oldProps.modHorns == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modHorns'][i])} end
                        RageUI.ButtonWithStyle(GetHornName(i), nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.modHorns == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['modHorns'][i] / 500, "Klaxon "..GetHornName(i), 'modHorns', i, plaque)
                            end
                            
                            if Active then
                                SetVehicleMod(GetVehiclePedIsIn(PlayerPedId()), 14, i, false)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'windowTint'), true, true, true, function()
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right = {}
                    for i=0, GetNumVehicleWindowTints(), 1 do
                        if LSC.oldProps.windowTint == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['windowTint'][i])} end
                        RageUI.ButtonWithStyle(cfg_mecano.windowsTintNames[i], nil, right[i], true, function(Hovered, Active, Selected)
                            if Selected then
                                if LSC.oldProps.windowTint == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                LSC.buy(vehiclePrice * cfg_mecano.modPrices['windowTint'][i] / 500, "Fenêtre "..cfg_mecano.windowsTintNames[i], 'windowTint', i, plaque)
                            end
                            
                            if Active then
                                SetVehicleWindowTint(GetVehiclePedIsIn(PlayerPedId(), false), i)
                            end
                        end)
                    end
    
                end, function()
                end)
    
                RageUI.IsVisible(RMenu:Get('lsc', 'bodyparts'), true, true, true, function()
    
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 8)  > 0 then
                        RageUI.ButtonWithStyle("Aile gauche", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 8)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modFender'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 9)  > 0 then
                        RageUI.ButtonWithStyle("Aile droite", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 9)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modRightFender'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 0)  > 0 then
                        RageUI.ButtonWithStyle("Spoilers", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 0)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modSpoilers'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 3)  > 0 then
                        RageUI.ButtonWithStyle("Bas de caisse", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 3)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modSideSkirt'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 5)  > 0 then
                        RageUI.ButtonWithStyle("Cage", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 5)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modFrame'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 7)  > 0 then
                        RageUI.ButtonWithStyle("Capot", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 7)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modHood'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 6)  > 0 then
                        RageUI.ButtonWithStyle("Grille", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 6)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modGrille'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 1)  > 0 then
                        RageUI.ButtonWithStyle("Pare-chocs avant", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 1)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modFrontBumper'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 2)  > 0 then
                        RageUI.ButtonWithStyle("Pare-chocs arrière", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 2)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modRearBumper'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 4)  > 0 then
                        RageUI.ButtonWithStyle("Pot d'échappement", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 4)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modExhaust'))
                    end
                    if GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 10)  > 0 then
                        RageUI.ButtonWithStyle("Toit", nil, {RightLabel = "~c~("..GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 10)..")~s~ →→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('lsc', 'modRoof'))
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modFender'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 8) 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    if modCount > 0 then
                        for i = -1, modCount - 1, 1 do
                            local name = "Aile gauche #"..i
                            if i < 0 then name = "Stock Aile" end
                            local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 8, i)
                            if GetLabelText(modName) ~= 'NULL' then name = GetLabelText(modName) end
                            if LSC.oldProps.modFender == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modFender'][i])} end
                            RageUI.ButtonWithStyle(name, nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modFender == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modFender'][i] / 500, name, 'modFender', i, plaque)
                                end
                                
                                if Active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 8, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modRightFender'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 9) 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    if modCount > 0 then
                        for i = -1, modCount - 1, 1 do
                            local name = "Aile droite #"..i
                            if i < 0 then name = "Stock Aile" end
                            local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 9, i)
                            if GetLabelText(modName) ~= 'NULL' then name = GetLabelText(modName) end
                            if LSC.oldProps.modRightFender == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modRightFender'][i])} end
                            RageUI.ButtonWithStyle(name, nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modRightFender == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modRightFender'][i] / 500, name, 'modRightFender', i, plaque)
                                end
                                
                                if Active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 9, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modSpoilers'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 0) 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    if modCount > 0 then
                        for i = -1, modCount - 1, 1 do
                            local name = "Spoilers #"..i
                            if i < 0 then name = "Stock Spoilers" end
                            local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 0, i)
                            if GetLabelText(modName) ~= 'NULL' then name = GetLabelText(modName) end
                            if LSC.oldProps.modSpoilers == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modSpoilers'][i])} end
                            RageUI.ButtonWithStyle(name, nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modSpoilers == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modSpoilers'][i] / 500, name, 'modSpoilers', i, plaque)
                                end
                                
                                if Active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 0, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modSideSkirt'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 3) 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    if modCount > 0 then
                        for i = -1, modCount - 1, 1 do
                            local name = "Bas de caisse #"..i
                            if i < 0 then name = "Stock Bas de caisse" end
                            local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 3, i)
                            if GetLabelText(modName) ~= 'NULL' then name = GetLabelText(modName) end
                            if LSC.oldProps.modSideSkirt == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modSideSkirt'][i])} end
                            RageUI.ButtonWithStyle(name, nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modSideSkirt == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modSideSkirt'][i] / 500, name, 'modSideSkirt', i, plaque)
                                end
                                
                                if Active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 3, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modFrame'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 5) 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    if modCount > 0 then
                        for i = -1, modCount - 1, 1 do
                            local name = "Cage #"..i
                            if i < 0 then name = "Stock Cage" end
                            local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 5, i)
                            if GetLabelText(modName) ~= 'NULL' then name = GetLabelText(modName) end
                            if LSC.oldProps.modFrame == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modFrame'][i])} end
                            RageUI.ButtonWithStyle(name, nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modFrame == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modFrame'][i] / 500, name, 'modFrame', i, plaque)
                                end
                                
                                if Active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 5, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modHood'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 7) 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    if modCount > 0 then
                        for i = -1, modCount - 1, 1 do
                            local name = "Capot #"..i
                            if i < 0 then name = "Stock Capot" end
                            local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 7, i)
                            if GetLabelText(modName) ~= 'NULL' then name = GetLabelText(modName) end
                            if LSC.oldProps.modHood == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modHood'][i])} end
                            RageUI.ButtonWithStyle(name, nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modHood == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modHood'][i] / 500, name, 'modHood', i, plaque)
                                end
                                
                                if Active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 7, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modGrille'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 6) 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    if modCount > 0 then
                        for i = -1, modCount - 1, 1 do
                            local name = "Grille #"..i
                            if i < 0 then name = "Stock Grille" end
                            local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 6, i)
                            if GetLabelText(modName) ~= 'NULL' then name = GetLabelText(modName) end
                            if LSC.oldProps.modGrille == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modGrille'][i])} end
                            RageUI.ButtonWithStyle(name, nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modGrille == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modGrille'][i] / 500, name, 'modGrille', i, plaque)
                                end
                                
                                if Active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 6, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modFrontBumper'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 1) 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    if modCount > 0 then
                        for i = -1, modCount - 1, 1 do
                            local name = "Pare-chocs avant #"..i
                            if i < 0 then name = "Stock Pare-chocs avant" end
                            local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 1, i)
                            if GetLabelText(modName) ~= 'NULL' then name = GetLabelText(modName) end
                            if LSC.oldProps.modFrontBumper == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modFrontBumper'][i])} end
                            RageUI.ButtonWithStyle(name, nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modFrontBumper == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modFrontBumper'][i] / 500, name, 'modFrontBumper', i, plaque)
                                end
                                
                                if Active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 1, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modRearBumper'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 2) 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    if modCount > 0 then
                        for i = -1, modCount - 1, 1 do
                            local name = "Pare-chocs arrière #"..i
                            if i < 0 then name = "Stock Pare-chocs arrière" end
                            local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 2, i)
                            if GetLabelText(modName) ~= 'NULL' then name = GetLabelText(modName) end
                            if LSC.oldProps.modRearBumper == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modRearBumper'][i])} end
                            RageUI.ButtonWithStyle(name, nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modRearBumper == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modRearBumper'][i] / 500, name, 'modRearBumper', i, plaque)
                                end
                                
                                if Active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 2, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modExhaust'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 4) 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    if modCount > 0 then
                        for i = -1, modCount - 1, 1 do
                            local name = "Pot d'échappement #"..i
                            if i < 0 then name = "Stock Pot d'échappement" end
                            local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 4, i)
                            if GetLabelText(modName) ~= 'NULL' then name = GetLabelText(modName) end
                            if LSC.oldProps.modExhaust == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modExhaust'][i])} end
                            RageUI.ButtonWithStyle(name, nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modExhaust == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modExhaust'][i] / 500, name, 'modExhaust', i, plaque)
                                end
                                
                                if Active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 4, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('lsc', 'modRoof'), true, true, true, function()
    
                    local modCount = GetNumVehicleMods(GetVehiclePedIsIn(PlayerPedId(), false), 10) 
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		            local plaque = GetVehicleNumberPlateText(vehicle)
                    local right    = {}
                    if modCount > 0 then
                        for i = -1, modCount - 1, 1 do
                            local name = "Toit #"..i
                            if i < 0 then name = "Stock Toit" end
                            local modName = GetModTextLabel(GetVehiclePedIsIn(PlayerPedId(), false), 10, i)
                            if GetLabelText(modName) ~= 'NULL' then name = GetLabelText(modName) end
                            if LSC.oldProps.modRoof == i then right[i] = {RightBadge = RageUI.BadgeStyle.Cash} else right[i] = {RightLabel = LSC.definePrice(vehiclePrice, cfg_mecano.modPrices['modRoof'][i])} end
                            RageUI.ButtonWithStyle(name, nil, right[i], true, function(Hovered, Active, Selected)
                                if Selected then
                                    if LSC.oldProps.modRoof == i then ESX.ShowNotification("~r~Vous avez déjà acheté cette amélioration") return end
                                    LSC.buy(vehiclePrice * cfg_mecano.modPrices['modRoof'][i] / 500, name, 'modRoof', i, plaque)
                                end
                                
                                if Active then
                                    SetVehicleMod(GetVehiclePedIsIn(PlayerPedId(), false), 10, i, false)
                                end
                            end)
                        end
                    end
    
                end, function()
                end)
            end
        end)
    end
end

function GroupDigits(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ","):reverse())
end

