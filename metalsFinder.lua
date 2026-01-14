METALSFINDER = {
    ["started"] = true,
    ["position"] = {
        coords = vector3(-2145.35, 2681.09, 2.88),
        radius = 50.0,
        radiusR = 25.0,
    },
    ["inZone"] = false,
    ["menuOpenned"] = false,
}

ShowHelp = function(text, n)
    BeginTextCommandDisplayHelp(text)
    EndTextCommandDisplayHelp(n or 0, false, true, -1)
end

ShowFloatingHelp = function(text, pos)
    SetFloatingHelpTextWorldPosition(1, pos)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    ShowHelp(text, 2)
end

METALSFINDER["openSellerMenu"] = function()
	local coords = GetEntityCoords(PlayerPedId())

	RMenu.Add("seller", "main", RageUI.CreateMenu("Métaux illégaux", "Que voulez-vous faire ?", 1, 100))
	RMenu:Get('seller', 'main'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get("seller", "main").Closed = function()
        METALSFINDER["menuOpenned"] = false
        
        RMenu:Delete("seller", "main")
    end
    
    if METALSFINDER["menuOpenned"] then
        METALSFINDER["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        METALSFINDER["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('seller', 'main'), true)
    end

    Citizen.CreateThread(function()
        while METALSFINDER["menuOpenned"] do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                METALSFINDER["menuOpenned"] = false
            end

            RageUI.IsVisible(RMenu:Get('seller', 'main'), true, false, true, function()

                RageUI.ButtonWithStyle("Vendre mes métaux illégaux", nil, {RightLabel = "»»»"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if tempWait == nil then tempWait = 0 end

                        if GetGameTimer() > tempWait then
                            tempWait = GetGameTimer() + 5 * 1000
                            TriggerServerEvent("metalsFinder:sell")
                        end
                    end
                end)

            end)

        end
    end)
end

Citizen.CreateThread(function()
    local called = false
    while true do
        local interval = 1000

        if #(GetEntityCoords(PlayerPedId()) - vector3(287.76, 2843.86, 44.7)) < 2.5 then
            interval = 0

            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir")

            if IsControlJustReleased(1, 38) then
                METALSFINDER["openSellerMenu"]()
            end
        end

        Citizen.Wait(interval)
    end
end)

RegisterNetEvent("metalsFinder:start")
AddEventHandler("metalsFinder:start", function()
    METALSFINDER["started"] = true

    local blip = AddBlipForCoord(
        METALSFINDER["position"]["coords"].x, 
        METALSFINDER["position"]["coords"].y, 
        METALSFINDER["position"]["coords"].z
    )
    SetBlipSprite(blip, 618)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.75)
    SetBlipColour(blip, 11)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Activité illégale métaux")
    EndTextCommandSetBlipName(blip)

    local blip2 = AddBlipForCoord(287.76, 2843.86, 44.7)
    SetBlipSprite(blip2, 618)
    SetBlipDisplay(blip2, 4)
    SetBlipScale(blip2, 0.75)
    SetBlipColour(blip2, 11)
    SetBlipAsShortRange(blip2, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Vente de métaux")
    EndTextCommandSetBlipName(blip2)

    Citizen.CreateThread(function()
        while METALSFINDER["started"] do


            if #(GetEntityCoords(PlayerPedId()) - METALSFINDER["position"]["coords"]) <= 250.0 then
                DrawMarker(1, METALSFINDER["position"]["coords"].x, METALSFINDER["position"]["coords"].y, METALSFINDER["position"]["coords"].z - 35.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, METALSFINDER["position"]["radius"], METALSFINDER["position"]["radius"], METALSFINDER["position"]["radius"], 180, 0, 0, 220, false, false)
            end

            if #(GetEntityCoords(PlayerPedId()) - METALSFINDER["position"]["coords"]) <= METALSFINDER["position"]["radiusR"] and not METALSFINDER["inZone"] then
                TriggerEvent("metalsFinder:onEnter")
            end

            if #(GetEntityCoords(PlayerPedId()) - METALSFINDER["position"]["coords"]) > METALSFINDER["position"]["radiusR"] and METALSFINDER["inZone"] then
                TriggerEvent("metalsFinder:onLeave")
            end

            Citizen.Wait(0)
        end
        TriggerEvent("metalsFinder:onLeave")
    end)
end)

RegisterNetEvent("metalsFinder:stop")
AddEventHandler("metalsFinder:stop", function()
    METALSFINDER["started"] = false
    METALSFINDER["inZone"] = false

    if DoesEntityExist(METALSFINDER["propEntity"]) then
        DeleteEntity(METALSFINDER["propEntity"])
    end

    DeleteEntity(METALSFINDER["netId"])

    METALSFINDER["netId"] = nil
    METALSFINDER["clicked"] = false
    METALSFINDER["randomZone"] = nil
    METALSFINDER["spawned"] = false
end)

AddEventHandler("metalsFinder:onEnter", function()
    if DoesEntityExist(METALSFINDER["netId"]) then
        DeleteEntity(METALSFINDER["netId"])
    end

    METALSFINDER["inZone"] = true

    Citizen.CreateThread(function()
        while METALSFINDER["inZone"] do

            if METALSFINDER["randomZone"] ~= nil then
                AddTextEntry("TAKE_METAL", "E pour ramasser")
                ShowFloatingHelp("TAKE_METAL", vector3(METALSFINDER["randomZone"].x, METALSFINDER["randomZone"].y, METALSFINDER["randomZone"].z - 0.5))
            end

            Citizen.Wait(0)
        end
    end)

    while METALSFINDER["inZone"] do
        if not METALSFINDER["spawned"] then
            local cX, cY, cZ = METALSFINDER["position"]["coords"].x + math.random(-15.0, 15.0), METALSFINDER["position"]["coords"].y + math.random(-15.0, 15.0), METALSFINDER["position"]["coords"].z
            METALSFINDER["randomZone"] = vector3(cX, cY, cZ)
            
            METALSFINDER["spawned"] = true
        end

        while METALSFINDER["spawned"] do
            if #(GetEntityCoords(PlayerPedId()) - METALSFINDER["randomZone"]) < 3.0 then
                if IsControlJustPressed(0, 38) and not IsPedInAnyVehicle(PlayerPedId(), false) then
                    if not METALSFINDER["clicked"] then
                        METALSFINDER["spawned"] = false
                        METALSFINDER["netId"] = nil
                        METALSFINDER["randomZone"] = nil
                        
                        METALSFINDER["clicked"] = true

                        TaskStartScenarioInPlace(PlayerPedId(), "world_human_gardener_plant", 0, false)

                        Citizen.Wait(2000)
                        ClearPedTasksImmediately(PlayerPedId())

                        TriggerServerEvent("metalsFinder:take")
                        
                        DeleteEntity(METALSFINDER["netId"])
                        METALSFINDER["clicked"] = false
                    end
                end
            end
            Wait(1)
        end
    end
end)

AddEventHandler("metalsFinder:onLeave", function()
    METALSFINDER["inZone"] = false

    if DoesEntityExist(METALSFINDER["propEntity"]) then
        DeleteEntity(METALSFINDER["propEntity"])
    end

    DeleteEntity(METALSFINDER["netId"])

    METALSFINDER["netId"] = nil
    METALSFINDER["clicked"] = false
    METALSFINDER["randomZone"] = nil
    METALSFINDER["spawned"] = false
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        METALSFINDER["inZone"] = false

        if DoesEntityExist(METALSFINDER["propEntity"]) then
            DeleteEntity(METALSFINDER["propEntity"])
        end
    
        DeleteEntity(METALSFINDER["netId"])
    
        METALSFINDER["netId"] = nil
        METALSFINDER["clicked"] = false
        METALSFINDER["randomZone"] = nil
        METALSFINDER["spawned"] = false
	end
end)