Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
end)

PROPERTY["openCreator"] = function()
    RMenu.Add('property', 'main', RageUI.CreateMenu("Création de propriété", "Liste des possibilités", 1, 100))
    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false

        if PROPERTY["creatorData"]["inInteriorPreview"] and PROPERTY["creatorData"]["lastCoords"] then
            PROPERTY["creatorData"]["inInteriorPreview"] = false
            PROPERTY["creatorData"]["lastInterior"] = nil
            SetEntityCoords(PlayerPedId(), PROPERTY["creatorData"]["lastCoords"])
            PROPERTY["creatorData"]["lastCoords"] = nil
        end

        if PROPERTY["creatorData"]["vehiclesSpawned"] then
            for k,v in pairs(PROPERTY["creatorData"]["vehiclesSpawned"]) do
                DeleteEntity(v)
            end
        end

        RMenu:Delete('property', 'main')
    end

    for name, menu in pairs(RMenu['property']) do
        RMenu:Get('property', name):SetRectangleBanner(255, 220, 0, 140)
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('property', 'main'), true)
    end

    PROPERTY["creatorData"]["inventory"] = {
        ["enabled"] = false,
    }
    PROPERTY["creatorData"]["garage"] = {
        ["enabled"] = false,
    }

    PROPERTY["creatorData"]["interiorIndex"] = 1
    PROPERTY["creatorData"]["lastInterior"] = nil
    PROPERTY["creatorData"]["lastCoords"] = nil
    PROPERTY["creatorData"]["door"] = nil
    PROPERTY["creatorData"]["inInteriorPreview"] = false

    PROPERTY["creatorData"]["garageIndex"] = 1
    PROPERTY["creatorData"]["garageInteriorIndex"] = 1
    PROPERTY["creatorData"]["lastGarageInterior"] = nil
    PROPERTY["creatorData"]["lastGarageCoords"] = nil
    PROPERTY["creatorData"]["inGarageInteriorPreview"] = false

    PROPERTY["creatorData"]["vehiclesSpawned"] = {}
    PROPERTY["creatorData"]["rentPrice"] = 0
    PROPERTY["creatorData"]["interiorSettings"] = {}
    PROPERTY["creatorData"]["garageSettings"] = {}

    PROPERTY["creatorData"]["insideBuilding"] = false

    local allInteriors = PROPERTY["interiors"]
    -- for k,v in pairs(allInteriors) do
    --     if v.hided then
    --         allInteriors[k] = nil
    --     end
    -- end

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            if PROPERTY["creatorData"].door then
                ESX.Game.Utils.DrawText3D(vector3(PROPERTY["creatorData"].door.x, PROPERTY["creatorData"].door.y, PROPERTY["creatorData"].door.z - 0.15), "🚪 Porte d'entrée", 1.5, 4)
                DrawMarker(6, PROPERTY["creatorData"].door.x, PROPERTY["creatorData"].door.y, PROPERTY["creatorData"].door.z - 0.95, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
            end

            if PROPERTY["creatorData"]["inInteriorPreview"] then
                ESX.Game.Utils.DrawText3D(vector3(allInteriors[PROPERTY["creatorData"]["interiorIndex"]].chest.x, allInteriors[PROPERTY["creatorData"]["interiorIndex"]].chest.y, allInteriors[PROPERTY["creatorData"]["interiorIndex"]].chest.z - 0.15), "📦 Point du coffre", 1.5, 4)
                DrawMarker(6, allInteriors[PROPERTY["creatorData"]["interiorIndex"]].chest.x, allInteriors[PROPERTY["creatorData"]["interiorIndex"]].chest.y, allInteriors[PROPERTY["creatorData"]["interiorIndex"]].chest.z - 0.95, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
            end

            if PROPERTY["creatorData"].garage.spawn then
                ESX.Game.Utils.DrawText3D(vector3(PROPERTY["creatorData"].garage.spawn.x, PROPERTY["creatorData"].garage.spawn.y, PROPERTY["creatorData"].garage.spawn.z - 0.15), "🚘 Point de spawn", 1.5, 4)
                DrawMarker(6, PROPERTY["creatorData"].garage.spawn.x, PROPERTY["creatorData"].garage.spawn.y, PROPERTY["creatorData"].garage.spawn.z - 0.95, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
            end

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                RageUI.ButtonWithStyle("Mettre dans un building", nil, {RightLabel = PROPERTY["creatorData"]["insideBuilding"] and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        PROPERTY["creatorData"]["insideBuilding"] = not PROPERTY["creatorData"]["insideBuilding"]
                        if PROPERTY["creatorData"]["insideBuilding"] then
                            TriggerServerEvent("property:getBuildings")
                        end

                        PROPERTY["creatorData"]["lastCoords"] = GetEntityCoords(PlayerPedId())
                    end

                    if Active then
                        if PROPERTY["creatorData"]["inInteriorPreview"] then
                            PROPERTY["creatorData"]["inInteriorPreview"] = false
                            PROPERTY["creatorData"]["lastInterior"] = nil
                            if PROPERTY["creatorData"]["lastCoords"] and PROPERTY["creatorData"]["lastCoords"].x ~= 0 then
                                SetEntityCoords(PlayerPedId(), PROPERTY["creatorData"]["lastCoords"])
                            end
                            PROPERTY["creatorData"]["lastCoords"] = nil
                        end
                    end
                end)

                if PROPERTY["creatorData"]["insideBuilding"] then
                    if #PROPERTY["buildings"] > 0 then
                        if PROPERTY["creatorData"]["buildingIndex"] == nil then PROPERTY["creatorData"]["buildingIndex"] = 1 end
                        if PROPERTY["creatorData"]["lastBuildingIndex"] == nil then PROPERTY["creatorData"]["lastBuildingIndex"] = nil end
                        RageUI.ButtonWithStyle("Building", nil, {RightLabel = "← Building "..PROPERTY["buildings"][PROPERTY["creatorData"]["buildingIndex"]].name.." →"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if not PROPERTY["creatorData"]["inInteriorPreview"] then
                                    PROPERTY["creatorData"]["inInteriorPreview"] = true
                                end

                                if PROPERTY["creatorData"]["lastBuildingIndex"] ~= PROPERTY["creatorData"]["buildingIndex"] then
                                    PROPERTY["creatorData"]["lastBuildingIndex"] = PROPERTY["creatorData"]["buildingIndex"]
                                    SetEntityCoords(PlayerPedId(), vector3(PROPERTY["buildings"][PROPERTY["creatorData"]["buildingIndex"]].coords.x, PROPERTY["buildings"][PROPERTY["creatorData"]["buildingIndex"]].coords.y, PROPERTY["buildings"][PROPERTY["creatorData"]["buildingIndex"]].coords.z))
                                end

                                if IsControlJustPressed(0, 174) then
                                    if PROPERTY["creatorData"]["buildingIndex"] - 1 < 1 then
                                        PROPERTY["creatorData"]["buildingIndex"] = #PROPERTY["buildings"]
                                    else
                                        PROPERTY["creatorData"]["buildingIndex"] = PROPERTY["creatorData"]["buildingIndex"] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
        
                                if IsControlJustPressed(0, 175) then
                                    if PROPERTY["creatorData"]["buildingIndex"] + 1 > #PROPERTY["buildings"] then
                                        PROPERTY["creatorData"]["buildingIndex"] = 1
                                    else
                                        PROPERTY["creatorData"]["buildingIndex"] = PROPERTY["creatorData"]["buildingIndex"] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle("~r~Aucun building de disponible", nil, {RightLabel = "❌"}, true, function(Hovered, Active, Selected) end)
                    end
                else
                    RageUI.ButtonWithStyle("Porte d'entrée", nil, {RightLabel = PROPERTY["creatorData"].door ~= nil and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    
                            PROPERTY["creatorData"].door = {
                                x = x,
                                y = y,
                                z = z,
                            }
                        end
                        
                        if Active then
                            if PROPERTY["creatorData"]["inInteriorPreview"] then
                                PROPERTY["creatorData"]["inInteriorPreview"] = false
                                PROPERTY["creatorData"]["lastInterior"] = nil
                                if PROPERTY["creatorData"]["lastCoords"] and PROPERTY["creatorData"]["lastCoords"].x ~= 0 then
                                    SetEntityCoords(PlayerPedId(), PROPERTY["creatorData"]["lastCoords"])
                                end
                                PROPERTY["creatorData"]["lastCoords"] = nil
                            end
                        end
                    end)
                end

                RageUI.ButtonWithStyle("Coffre", nil, {RightLabel = PROPERTY["creatorData"].inventory.enabled and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        PROPERTY["creatorData"].inventory.enabled = not PROPERTY["creatorData"].inventory.enabled
                    end

                    if Active then
                        if PROPERTY["creatorData"]["inInteriorPreview"] then
                            PROPERTY["creatorData"]["inInteriorPreview"] = false
                            PROPERTY["creatorData"]["lastInterior"] = nil

                            if PROPERTY["creatorData"]["lastCoords"] and PROPERTY["creatorData"]["lastCoords"].x ~= 0 then
                                SetEntityCoords(PlayerPedId(), PROPERTY["creatorData"]["lastCoords"])
                            end
                            
                            PROPERTY["creatorData"]["lastCoords"] = nil
                        end

                        if PROPERTY["creatorData"]["inGaragePreview"] then
                            PROPERTY["creatorData"]["inGaragePreview"] = false
                            for k,v in pairs(PROPERTY["creatorData"]["vehiclesSpawned"]) do
                                DeleteEntity(v)
                            end
                        end
                    end
                end)

                if PROPERTY["creatorData"].inventory.enabled then
                    RageUI.ButtonWithStyle("Capacité du coffre", nil, {RightLabel = PROPERTY["creatorData"].inventory.capacity ~= nil and ESX.Math.GroupDigits(PROPERTY["creatorData"].inventory.capacity).."KG" or "À définir"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local capacity = UTILS.KeyboardInput("Entrez la capacité du coffre", "", 20)
                            capacity = tonumber(capacity)

                            if capacity == nil then return end
                            if capacity < 1 then return end

                            PROPERTY["creatorData"].inventory.capacity = capacity
                        end

                        if Active then
                            if PROPERTY["creatorData"]["inInteriorPreview"] then
                                PROPERTY["creatorData"]["inInteriorPreview"] = false
                                PROPERTY["creatorData"]["lastInterior"] = nil

                                if PROPERTY["creatorData"]["lastCoords"].x ~= 0 then
                                    SetEntityCoords(PlayerPedId(), PROPERTY["creatorData"]["lastCoords"])
                                end

                                PROPERTY["creatorData"]["lastCoords"] = nil
                            end
                        end
                    end)
                end

                RageUI.ButtonWithStyle("Intérieur", nil, {RightLabel = "← "..allInteriors[PROPERTY["creatorData"]["interiorIndex"]].name.." →"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if not PROPERTY["creatorData"]["inInteriorPreview"] then
                            PROPERTY["creatorData"]["inInteriorPreview"] = true
                        end

                        if PROPERTY["creatorData"]["lastInterior"] ~= allInteriors[PROPERTY["creatorData"]["interiorIndex"]].name then
                            PROPERTY["creatorData"]["lastInterior"] = allInteriors[PROPERTY["creatorData"]["interiorIndex"]].name

                            if PROPERTY["creatorData"]["lastCoords"] == nil then
                                PROPERTY["creatorData"]["lastCoords"] = GetEntityCoords(PlayerPedId())
                            end

                            SetEntityCoords(PlayerPedId(), allInteriors[PROPERTY["creatorData"]["interiorIndex"]].entry)
                        end

                        if IsControlJustPressed(0, 174) then
                            if PROPERTY["creatorData"]["interiorIndex"] - 1 < 1 then
                                PROPERTY["creatorData"]["interiorIndex"] = #allInteriors
                            else
                                PROPERTY["creatorData"]["interiorIndex"] = PROPERTY["creatorData"]["interiorIndex"] - 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end

                        if IsControlJustPressed(0, 175) then
                            if PROPERTY["creatorData"]["interiorIndex"] + 1 > #allInteriors then
                                PROPERTY["creatorData"]["interiorIndex"] = 1
                            else
                                PROPERTY["creatorData"]["interiorIndex"] = PROPERTY["creatorData"]["interiorIndex"] + 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end
                    end
                end)

                if allInteriors[PROPERTY["creatorData"]["interiorIndex"]].editables then
                    for k,v in pairs(allInteriors[PROPERTY["creatorData"]["interiorIndex"]].editables) do
                        if v.type == "interiorStyles" then
                            if v.index == nil then v.index = 1 end
                            if v.last == nil then v.last = '' end

                            RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "← "..v.list[v.index].name.." →"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if v.last ~= v.list[v.index].name then
                                        v.last = v.list[v.index].name
                                        PROPERTY["creatorData"]["interiorSettings"]["interiorStyle"] = v.index
                                        local coords = GetEntityCoords(PlayerPedId())
                                        v.list[v.index].action()
                                        SetEntityCoords(PlayerPedId(), coords)
                                    end

                                    if IsControlJustPressed(0, 174) then
                                        if v.index - 1 < 1 then
                                            v.index = #v.list
                                        else
                                            v.index = v.index - 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end
                                    if IsControlJustPressed(0, 175) then
                                        if v.index + 1 > #v.list then
                                            v.index = 1
                                        else
                                            v.index = v.index + 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end
                                end
                            end)
                        end

                        if v.type == "strip" then
                            if v.last == nil then v.last = false end
                            if v.toggle == nil then v.toggle = false end
                            RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.toggle and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    v.toggle = not v.toggle
                                    PROPERTY["creatorData"]["interiorSettings"]["strip"] = v.toggle
                                    local coords = GetEntityCoords(PlayerPedId())
                                    v.action(v.toggle)
                                    -- SetEntityCoords(PlayerPedId(), coords)
                                end
                            end)
                        end

                        if v.type == "booze" then
                            if v.last == nil then v.last = false end
                            if v.toggle == nil then v.toggle = false end
                            RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.toggle and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    v.toggle = not v.toggle
                                    PROPERTY["creatorData"]["interiorSettings"]["booze"] = v.toggle
                                    local coords = GetEntityCoords(PlayerPedId())
                                    v.action(v.toggle)
                                    -- SetEntityCoords(PlayerPedId(), coords)
                                end
                            end)
                        end

                        if v.type == "chairs" then
                            if v.last == nil then v.last = false end
                            if v.toggle == nil then v.toggle = false end
                            RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.toggle and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    v.toggle = not v.toggle
                                    PROPERTY["creatorData"]["interiorSettings"]["chairs"] = v.toggle
                                    local coords = GetEntityCoords(PlayerPedId())
                                    v.action(v.toggle)
                                    -- SetEntityCoords(PlayerPedId(), coords)
                                end
                            end)
                        end

                        if v.type == "bunkerEquipment" then
                            if v.last == nil then v.last = false end
                            if v.toggle == nil then v.toggle = false end
                            RageUI.ButtonWithStyle(v.name, nil, {RightLabel = v.toggle and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    v.toggle = not v.toggle
                                    PROPERTY["creatorData"]["interiorSettings"]["bunkerEquipment"] = v.toggle
                                    local coords = GetEntityCoords(PlayerPedId())
                                    v.action(v.toggle)
                                    -- SetEntityCoords(PlayerPedId(), coords)
                                end
                            end)
                        end

                        if v.type == "casinoDecors" then
                            if v.index == nil then v.index = 1 end
                            if v.last == nil then v.last = '' end

                            RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "← "..v.list[v.index].name.." →"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if v.last ~= v.list[v.index].name then
                                        v.last = v.list[v.index].name
                                        PROPERTY["creatorData"]["interiorSettings"]["casinoDecor"] = v.index
                                        local coords = GetEntityCoords(PlayerPedId())
                                        v.list[v.index].action()
                                        -- SetEntityCoords(PlayerPedId(), coords)
                                    end

                                    if IsControlJustPressed(0, 174) then
                                        if v.index - 1 < 1 then
                                            v.index = #v.list
                                        else
                                            v.index = v.index - 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end
                                    if IsControlJustPressed(0, 175) then
                                        if v.index + 1 > #v.list then
                                            v.index = 1
                                        else
                                            v.index = v.index + 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end
                                end
                            end)
                        end

                        if v.type == "casinoDecorsBar" then
                            if v.index == nil then v.index = 1 end
                            if v.last == nil then v.last = '' end

                            RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "← "..v.list[v.index].name.." →"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if v.last ~= v.list[v.index].name then
                                        v.last = v.list[v.index].name
                                        PROPERTY["creatorData"]["interiorSettings"]["casinoDecorsBar"] = v.index
                                        local coords = GetEntityCoords(PlayerPedId())
                                        v.list[v.index].action()
                                        -- SetEntityCoords(PlayerPedId(), coords)
                                    end

                                    if IsControlJustPressed(0, 174) then
                                        if v.index - 1 < 1 then
                                            v.index = #v.list
                                        else
                                            v.index = v.index - 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end
                                    if IsControlJustPressed(0, 175) then
                                        if v.index + 1 > #v.list then
                                            v.index = 1
                                        else
                                            v.index = v.index + 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end
                                end
                            end)
                        end
                    end
                end

                RageUI.ButtonWithStyle("Garage", nil, {RightLabel = PROPERTY["creatorData"].garage.enabled and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        PROPERTY["creatorData"].garage.enabled = not PROPERTY["creatorData"].garage.enabled

                        if PROPERTY["creatorData"].garage.enabled then
                            PROPERTY["creatorData"]["garageIndex"] = 2
                        end
                    end

                    if Active then
                        if PROPERTY["creatorData"]["inInteriorPreview"] then
                            PROPERTY["creatorData"]["inInteriorPreview"] = false
                            PROPERTY["creatorData"]["lastInterior"] = nil
                            SetEntityCoords(PlayerPedId(), PROPERTY["creatorData"]["lastCoords"])
                            PROPERTY["creatorData"]["lastCoords"] = nil
                        end
                    end
                end)

                if PROPERTY["creatorData"].garage.enabled then
                    if PROPERTY["creatorData"]["garageIndex"] == 2 then
                        RageUI.ButtonWithStyle("Intérieur du garage", nil, {RightLabel = "← "..PROPERTY["garages"][PROPERTY["creatorData"]["garageInteriorIndex"]].name.." →"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if PROPERTY["creatorData"]["lastCoords"] == nil then
                                    PROPERTY["creatorData"]["lastCoords"] = GetEntityCoords(PlayerPedId())
                                end

                                if not PROPERTY["creatorData"]["inInteriorPreview"] then
                                    PROPERTY["creatorData"]["inInteriorPreview"] = true
                                end
        
                                if PROPERTY["creatorData"]["lastInterior"] ~= PROPERTY["garages"][PROPERTY["creatorData"]["garageInteriorIndex"]].name then
                                    for k,v in pairs(PROPERTY["creatorData"]["vehiclesSpawned"]) do
                                        DeleteEntity(v)
                                    end

                                    PROPERTY["creatorData"]["lastInterior"] = PROPERTY["garages"][PROPERTY["creatorData"]["garageInteriorIndex"]].name
        
                                    if PROPERTY["creatorData"]["lastGarageCoords"] == nil then
                                        PROPERTY["creatorData"]["lastGarageCoords"] = GetEntityCoords(PlayerPedId())
                                    end
        
                                    SetEntityCoords(PlayerPedId(), PROPERTY["garages"][PROPERTY["creatorData"]["garageInteriorIndex"]].entry)

                                    if #PROPERTY["garages"][PROPERTY["creatorData"]["garageInteriorIndex"]].places > 0 then
                                        for k,v in pairs(PROPERTY["garages"][PROPERTY["creatorData"]["garageInteriorIndex"]].places) do
                                            local hash = PROPERTY["randomVehicles"][math.random(1, #PROPERTY["randomVehicles"])]
                                            RequestModel(hash)
                                            while not HasModelLoaded(hash) do
                                                Citizen.Wait(100)
                                            end

                                            local vehicle = CreateVehicle(hash, v.pos, v.heading, false, false)
                                            SetVehicleDoorsLocked(vehicle, 2)
                                            table.insert(PROPERTY["creatorData"]["vehiclesSpawned"], vehicle)
                                            Citizen.Wait(5)
                                        end
                                    end
                                end
        
                                if IsControlJustPressed(0, 174) then
                                    if PROPERTY["creatorData"]["garageInteriorIndex"] - 1 < 1 then
                                        PROPERTY["creatorData"]["garageInteriorIndex"] = #PROPERTY["garages"]
                                    else
                                        PROPERTY["creatorData"]["garageInteriorIndex"] = PROPERTY["creatorData"]["garageInteriorIndex"] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
        
                                if IsControlJustPressed(0, 175) then
                                    if PROPERTY["creatorData"]["garageInteriorIndex"] + 1 > #PROPERTY["garages"] then
                                        PROPERTY["creatorData"]["garageInteriorIndex"] = 1
                                    else
                                        PROPERTY["creatorData"]["garageInteriorIndex"] = PROPERTY["creatorData"]["garageInteriorIndex"] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                            end
                        end)
                    end

                    RageUI.ButtonWithStyle("Point de sortie", nil, {RightLabel = PROPERTY["creatorData"].garage.spawn ~= nil and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
    
                            PROPERTY["creatorData"].garage.spawn = {
                                x = x,
                                y = y,
                                z = z,
                            }
                            PROPERTY["creatorData"].garage.heading = GetEntityHeading(PlayerPedId())
                        end
                        
                        if Active then
                            if PROPERTY["creatorData"]["inInteriorPreview"] then
                                PROPERTY["creatorData"]["inInteriorPreview"] = false
                                PROPERTY["creatorData"]["lastInterior"] = nil
                                SetEntityCoords(PlayerPedId(), PROPERTY["creatorData"]["lastCoords"])
                                PROPERTY["creatorData"]["lastCoords"] = nil
                            end
                        end
                    end)

                    if allInteriors[PROPERTY["creatorData"]["interiorIndex"]].helipad then
                        if allInteriors[PROPERTY["creatorData"]["interiorIndex"]].helipad.enabled then
                            if PROPERTY["creatorData"]["garageSettings"]["helipad"] == nil then PROPERTY["creatorData"]["garageSettings"]["helipad"] = false end
                            RageUI.ButtonWithStyle("Helipad", nil, {RightLabel = PROPERTY["creatorData"]["garageSettings"]["helipad"] and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    PROPERTY["creatorData"]["garageSettings"]["helipad"] = not PROPERTY["creatorData"]["garageSettings"]["helipad"]
                                end

                                if Active then
                                    if PROPERTY["creatorData"]["inInteriorPreview"] then
                                        PROPERTY["creatorData"]["inInteriorPreview"] = false
                                        PROPERTY["creatorData"]["lastInterior"] = nil
                                        SetEntityCoords(PlayerPedId(), PROPERTY["creatorData"]["lastCoords"])
                                        PROPERTY["creatorData"]["lastCoords"] = nil
                                    end
                                end
                            end)
                        end
                    end

                    if allInteriors[PROPERTY["creatorData"]["interiorIndex"]].rooftop then
                        if allInteriors[PROPERTY["creatorData"]["interiorIndex"]].rooftop.enabled then
                            if PROPERTY["creatorData"]["interiorSettings"]["rooftop"] == nil then PROPERTY["creatorData"]["interiorSettings"]["rooftop"] = false end
                            RageUI.ButtonWithStyle("Accès rooftop", nil, {RightLabel = PROPERTY["creatorData"]["interiorSettings"]["rooftop"] and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                    PROPERTY["creatorData"]["interiorSettings"]["rooftop"] = not PROPERTY["creatorData"]["interiorSettings"]["rooftop"]
                                end

                                if Active then
                                    if PROPERTY["creatorData"]["inInteriorPreview"] then
                                        PROPERTY["creatorData"]["inInteriorPreview"] = false
                                        PROPERTY["creatorData"]["lastInterior"] = nil
                                        SetEntityCoords(PlayerPedId(), PROPERTY["creatorData"]["lastCoords"])
                                        PROPERTY["creatorData"]["lastCoords"] = nil
                                    end
                                end
                            end)
                        end
                    end
                end

                RageUI.ButtonWithStyle("Prix de la location", nil, {RightLabel = PROPERTY["creatorData"]["rentPrice"] ~= 0 and ESX.Math.GroupDigits(PROPERTY["creatorData"]["rentPrice"]).."$" or "❌"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local price = UTILS.KeyboardInput("Entrez le prix de la location", "", 20)
                        price = tonumber(price)

                        if price == nil then return end
                        if price < 1 then return end

                        PROPERTY["creatorData"]["rentPrice"] = price
                    end

                    if Active then
                        if PROPERTY["creatorData"]["inInteriorPreview"] then
                            PROPERTY["creatorData"]["inInteriorPreview"] = false
                            PROPERTY["creatorData"]["lastInterior"] = nil
                            SetEntityCoords(PlayerPedId(), PROPERTY["creatorData"]["lastCoords"])
                            PROPERTY["creatorData"]["lastCoords"] = nil
                        end
                    end
                end)

                RageUI.Separator("")

                RageUI.ButtonWithStyle("~y~Créer la propriété", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        for k,v in pairs(PROPERTY["creatorData"]["vehiclesSpawned"]) do
                            DeleteEntity(v)
                        end

                        if allInteriors[PROPERTY["creatorData"]["interiorIndex"]].shop then
                            ESX.ShowNotification("~r~Vous ne pouvez pas créer de propriété avec cet intérieur~s~\nIntérieur boutique")
                            return
                        end

                        local garageTable = {}
                        if PROPERTY["creatorData"]["garageIndex"] == 1 then
                            garageTable = {
                                enabled = PROPERTY["creatorData"].garage.enabled,
                                pos = PROPERTY["creatorData"].garage.pos,
                                spawn = PROPERTY["creatorData"].garage.spawn,
                            }
                        elseif PROPERTY["creatorData"]["garageIndex"] == 2 then
                            garageTable = {
                                enabled = PROPERTY["creatorData"].garage.enabled,
                                type = PROPERTY["creatorData"]["garageIndex"],
                                interior = PROPERTY["creatorData"]["garageInteriorIndex"],
                                spawn = PROPERTY["creatorData"].garage.spawn,
                                heading = PROPERTY["creatorData"].garage.heading,
                            }
                        end

                        local streetName, crossingRoad = nil, nil
                        if PROPERTY["creatorData"].door then
                            streetName, crossingRoad = GetStreetNameAtCoord(PROPERTY["creatorData"].door.x, PROPERTY["creatorData"].door.y, PROPERTY["creatorData"].door.z)
                        else
                            streetName, crossingRoad = GetStreetNameAtCoord(PROPERTY["buildings"][PROPERTY["creatorData"]["buildingIndex"]].coords.x, PROPERTY["buildings"][PROPERTY["creatorData"]["buildingIndex"]].coords.y, PROPERTY["buildings"][PROPERTY["creatorData"]["buildingIndex"]].coords.z)
                        end
                        local realstreetname = GetStreetNameFromHashKey(streetName)

                        local door = nil
                        if PROPERTY["creatorData"]["insideBuilding"] then
                            door = {
                                x = PROPERTY["buildings"][PROPERTY["creatorData"]["buildingIndex"]].coords.x,
                                y = PROPERTY["buildings"][PROPERTY["creatorData"]["buildingIndex"]].coords.y,
                                z = PROPERTY["buildings"][PROPERTY["creatorData"]["buildingIndex"]].coords.z,
                            }
                        else
                            door = {
                                x = PROPERTY["creatorData"].door.x,
                                y = PROPERTY["creatorData"].door.y,
                                z = PROPERTY["creatorData"].door.z,
                            }
                        end
                        print(allInteriors[PROPERTY["creatorData"]["interiorIndex"]].type)
                        PROPERTY["creatorData"]["interiorSettings"]["laboType"] = ""
                        if allInteriors[PROPERTY["creatorData"]["interiorIndex"]].type ~= nil then 
                            PROPERTY["creatorData"]["interiorSettings"]["laboType"] = allInteriors[PROPERTY["creatorData"]["interiorIndex"]].type
                        end
                        TriggerServerEvent("property:create", {
                            door = door,
                            chest = {
                                enabled = PROPERTY["creatorData"].inventory.enabled,
                                capacity = PROPERTY["creatorData"].inventory.capacity,
                                inventory = {},
                                money = 0,
                                dirty = 0,
                                webhooks = {
                                    chest = false,
                                },
                            },
                            interior = PROPERTY["creatorData"]["interiorIndex"],
                            garage = garageTable,
                            price = PROPERTY["creatorData"]["rentPrice"],
                            name = math.random(1, 5000) .." - "..allInteriors[PROPERTY["creatorData"]["interiorIndex"]].name,
                            interiorSettings = {
                                interiorStyle = PROPERTY["creatorData"]["interiorSettings"]["interiorStyle"],
                                strip = PROPERTY["creatorData"]["interiorSettings"]["strip"] or nil,
                                booze = PROPERTY["creatorData"]["interiorSettings"]["booze"] or nil,
                                chairs = PROPERTY["creatorData"]["interiorSettings"]["chairs"] or nil,
                                bunkerEquipment = PROPERTY["creatorData"]["interiorSettings"]["bunkerEquipment"] or nil,
                                casinoDecor = PROPERTY["creatorData"]["interiorSettings"]["casinoDecor"] or nil,
                                casinoDecorsBar = PROPERTY["creatorData"]["interiorSettings"]["casinoDecorsBar"] or nil,
                                rooftop = PROPERTY["creatorData"]["interiorSettings"]["rooftop"] or nil,
                                laboType = PROPERTY["creatorData"]["interiorSettings"]["laboType"]
                            },
                            interiorProps = {},
                            garageSettings = {
                                helipad = PROPERTY["creatorData"]["garageSettings"]["helipad"] or nil,
                            },
                            building = PROPERTY["creatorData"]["insideBuilding"] and PROPERTY["buildings"][PROPERTY["creatorData"]["buildingIndex"]].id or 0,
                            letterbox = {
                                inventory = {},
                                money = 0,
                                dirty = 0,
                            },
                        })

                        PROPERTY["creatorData"] = {}

                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false
                    end

                    if Active then
                        if PROPERTY["creatorData"]["inInteriorPreview"] then
                            PROPERTY["creatorData"]["inInteriorPreview"] = false
                            PROPERTY["creatorData"]["lastInterior"] = nil
                            SetEntityCoords(PlayerPedId(), PROPERTY["creatorData"]["lastCoords"])
                            PROPERTY["creatorData"]["lastCoords"] = nil
                        end
                    end
                end)

            end, function()
            end)
        end
    end)
end

PROPERTY["openBuildingCreator"] = function()
    TriggerServerEvent("property:getBuildings")

    RMenu.Add('property', 'main', RageUI.CreateMenu("Création de building", "Liste des possibilités", 1, 100))
    RMenu.Add('property', 'add', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Que voulez-vous faire ?"))
    RMenu.Add('property', 'select', RageUI.CreateSubMenu(RMenu:Get('property', 'main'), "Propriété", "Que voulez-vous faire ?"))
    RMenu:Get('property', "main").Closed = function()
        PROPERTY["menuOpenned"] = false

        RMenu:Delete('property', 'main')
    end

    for name, menu in pairs(RMenu['property']) do
        RMenu:Get('property', name):SetRectangleBanner(255, 220, 0, 140)
    end

    if PROPERTY["menuOpenned"] then
        PROPERTY["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        PROPERTY["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('property', 'main'), true)
    end

    PROPERTY["buildingCreatorData"] = {}

    Citizen.CreateThread(function()
        while PROPERTY["menuOpenned"] do
            Wait(1)

            RageUI.IsVisible(RMenu:Get('property', 'main'), true, true, true, function()

                RageUI.ButtonWithStyle("Ajouter un building", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) end, RMenu:Get('property', 'add'))

                if #PROPERTY["buildings"] > 0 then
                    RageUI.Separator("")
                    
                    for k,v in pairs(PROPERTY["buildings"]) do
                        RageUI.ButtonWithStyle(v.name, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                if not temptable then temptable = v end
                            end
                        end)
                    end
                end

            end, function()
            end)

            RageUI.IsVisible(RMenu:Get('property', 'add'), true, true, true, function()

                RageUI.ButtonWithStyle("Nom du building", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local name = UTILS.KeyboardInput("Indiquez le nom du building", "", 30)
                        name = tostring(name)

                        PROPERTY["buildingCreatorData"]["name"] = name
                    end
                end)

                RageUI.ButtonWithStyle("Point d'interaction", nil, {RightLabel = PROPERTY["buildingCreatorData"]["interact"] ~= nil and "✅" or "❌"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))

                        PROPERTY["buildingCreatorData"]["interact"] = {
                            x = x,
                            y = y,
                            z = z,
                        }
                    end
                end)

                RageUI.Separator("")

                RageUI.ButtonWithStyle("~y~Créer le building", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        RageUI.CloseAll()
                        PROPERTY["menuOpenned"] = false

                        TriggerServerEvent("property:createBuilding", {
                            interact = PROPERTY["buildingCreatorData"]["interact"],
                            name = PROPERTY["buildingCreatorData"]["name"],
                        })
                    end
                end)

            end, function()
            end)
        end
    end)
end

RegisterCommand('immo', function()
    ESX.PlayerData = ESX.GetPlayerData()
    if ESX.PlayerData.job.name == "immo" then
        PROPERTY["openCreator"]()
    else
        ESX.ShowNotification("Vous n'avez pas le job nécessaire !")
    end
end)

RegisterCommand('immob', function()
    ESX.PlayerData = ESX.GetPlayerData()
    if ESX.PlayerData.job.name == "immo" then
        PROPERTY["openBuildingCreator"]()
    else
        ESX.ShowNotification("Vous n'avez pas le job nécessaire !")
    end
end)