ESX = nil

local OnCataActiveBNS = false
local lastcarout = {}
local prevdata = {}
local cache = {}
local cacheShowRoom = {}
cache.value = nil
local cacheName = {}
local inVehicleCheck = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
    TriggerServerEvent("pdm:getCache")
	RMenu.Add('menu', 'CatalogueBNS', RageUI.CreateMenu("PRIME", "PDM Autos", 1, 100))

    RMenu.Add('menu', 'concess_chooseBNS', RageUI.CreateSubMenu(RMenu:Get('menu', 'CatalogueBNS'), "PRIME", "PDM Autos", 1, 100))
    RMenu.Add('menu', 'concess_choosecitoyenBNS', RageUI.CreateSubMenu(RMenu:Get('menu', 'CatalogueBNS'), "PRIME", "PDM Autos", 1, 100))
    RMenu.Add('menu', 'displaycatbns', RageUI.CreateSubMenu(RMenu:Get('menu', 'CatalogueBNS'), "PRIME", "PDM Autos", 1, 100))
    RMenu:Get('menu', 'CatalogueBNS'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'concess_chooseBNS'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'concess_choosecitoyenBNS'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'displaycatbns'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'CatalogueBNS').EnableMouse = false
    RMenu:Get('menu', 'displaycatbns').Closable = false
    RMenu:Get('menu', 'CatalogueBNS').Closed = function()
        suppautoBNS()
    end
    RMenu:Get('menu', 'CatalogueBNS').Closed = function()
		OnCataActiveBNS = false
    end

    RMenu:Get('menu', 'CatalogueBNS').Closed = function()
		OnCataActiveBNS = false
    end

    for k,v in pairs(cfg_catalogueBNS.vehicles) do
        RMenu.Add('menu', v.value, RageUI.CreateSubMenu(RMenu:Get('menu', 'CatalogueBNS'), "PRIME", "PDM Autos", 1, 100))
        RMenu:Get('menu', v.value):SetRectangleBanner(255, 220, 0, 140)
        RMenu:Get('menu', v.value):SetSubtitle(v.cat_name)
        RMenu:Get('menu', v.value).Closed = function()
            suppautoBNS()
        end
    end
end)

local alone = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
	ESX.PlayerData.job.grade_name = grade
end)

showCarBNS = function(car)
    Citizen.CreateThread(function()
        local car = GetHashKey(car)

        suppautoBNS()
    
        ESX.Game.SpawnLocalVehicle(car, {x = -37.035842895508, y = -1093.7409667969, z = 27.302309036255}, 160.46423339844, function(vehicle)
            table.insert(lastcarout, vehicle)
            FreezeEntityPosition(vehicle, true)
            SetVehicleUndriveable(vehicle, true)
            SetVehicleDoorsLocked(vehicle, 2)
            SetModelAsNoLongerNeeded(car)
        end)
    end)
end

function openCatalogueMenuBNS()
    local modelname = nil
    if OnCataActiveBNS then
        RageUI.CloseAll()
        OnCataActiveBNS = false
        return
    else
        OnCataActiveBNS = true
        RageUI.Visible(RMenu:Get('menu', 'CatalogueBNS'), true)
 
        Citizen.CreateThread(function()
            while OnCataActiveBNS do
                RageUI.IsVisible(RMenu:Get('menu', 'CatalogueBNS'), true, true, true, function()
                    RageUI.Separator("Catégories")
                    for k,v in pairs(cfg_catalogueBNS.vehicles) do
                        RageUI.ButtonWithStyle(v.cat_name, nil, {}, true, function(Hovered, Active, Selected)
                        end, RMenu:Get('menu', v.value))
                    end
                end, function()
                end)

                for k,v in pairs(cfg_catalogueBNS.vehicles) do
                    RageUI.IsVisible(RMenu:Get('menu', v.value), true, true, true, function()
                        RageUI.Separator("Véhicules")
                        for y,la in pairs(v.vehicles) do
                            RageUI.ButtonWithStyle(firstToUpper(la.name), nil, {RightLabel = ESX.Math.GroupDigits(la.price, 2).."$"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if prevdata[y] ~= y then
                                        prevdata[y-1] = nil
                                        prevdata[y+1] = nil

                                        showCarBNS(la.hash)

                                        prevdata[y] = y
                                    end
                                end
                                if ESX.PlayerData.job.name == 'beachnsky' then
                                    if Selected then
                                        cache.value = la.hash
                                        suppautoBNS()
                                        ESX.ShowNotification("~y~Vous avez sélectionné: " ..la.hash)
                                    end
                                end
                            end, RMenu:Get('menu', 'concess_chooseBNS'))
                        end
        
                    end, function()
                    end)
                end
                    RageUI.IsVisible(RMenu:Get('menu', 'concess_chooseBNS'), true, true, true, function()
                        local player, distance = ESX.Game.GetClosestPlayer()
                        
                        RageUI.Separator("Nom du véhicule: " ..cache.value)
                        RageUI.ButtonWithStyle('Vendre le véhicule', nil, {}, true, function(Hovered, Active, Selected)
                            if Active then
                                MarquerJoueur()
                            end
                            if Selected then
                                if player ~= -1 and distance <= 3.0 then
                                    if cache.value ~= nil then
                                        local model = GetHashKey(cache.value)
                                        local newPlate = GeneratePlate()
                                        local vehicleProps = {
                                            model = model,
                                            plate = newPlate
                                        }
                                                        
                                        TriggerServerEvent('bns:giveAutotoId', GetPlayerServerId(player), vehicleProps, GetDisplayNameFromVehicleModel(model), true)
                
                                        RageUI.CloseAll()
                                        OnCataActiveBNS = false
                                        suppautoBNS()
                                    else
                                        ESX.ShowNotification("~r~Aucun véhicule sélectionné.")
                                    end
                                end
                            end
                        end)
                    end, function()
                    end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

function openCataGensBNS()
    local modelname = nil
    if OnCataActiveBNS then
        RageUI.Visible(RMenu:Get('menu', 'CatalogueBNS'), false)
        OnCataActiveBNS = false
        return
    else
        OnCataActiveBNS = true
        RageUI.Visible(RMenu:Get('menu', 'CatalogueBNS'), true)

        Citizen.CreateThread(function()
            while OnCataActiveBNS do
                RageUI.IsVisible(RMenu:Get('menu', 'CatalogueBNS'), true, true, true, function()
                    RageUI.Separator("~p~-25% pour les VIP Diamond")
                    RageUI.Separator("~y~-10% pour les VIP Gold")
                    RageUI.Line()
                    for k, v in pairs(cfg_catalogueBNS.vehicles) do
                        RageUI.ButtonWithStyle(v.cat_name, nil, {}, true, function(Hovered, Active, Selected)
                        end, RMenu:Get('menu', v.value))
                    end
                end, function()
                end)

                for k, v in pairs(cfg_catalogueBNS.vehicles) do
                    RageUI.IsVisible(RMenu:Get('menu', v.value), true, true, true, function()

                        RageUI.Separator("Véhicules")
                        for y, la in pairs(v.vehicles) do
                            RageUI.ButtonWithStyle(firstToUpper(la.name), nil, {RightLabel = ESX.Math.GroupDigits(la.price, 2) .. "$"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if Selected then
                                        cache.value = la.hash
                                        ESX.ShowNotification("~y~Vous avez sélectionné: " ..la.hash)
                                    end
                                end
                            end, RMenu:Get('menu', 'concess_choosecitoyenBNS'))
                        end

                    end, function()
                    end)
                end

                RageUI.IsVisible(RMenu:Get('menu', 'concess_choosecitoyenBNS'), true, true, true, function()
                    RageUI.Separator("Nom du véhicule: " ..cache.value)

                    local searchedModel = cache.value
                    
                    RageUI.ButtonWithStyle('Acheter le véhicule', nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.TriggerServerCallback('bns:ifHasMoney', function(hasMoney)
                                if not hasMoney then
                                    ESX.ShowNotification("~r~Vous n'avez pas assez d'argent !")
                                    return
                                else
                                    ESX.TriggerServerCallback('bns:getIfCompanyOpen', function(playerFound)
                                        if playerFound then
                                            ESX.ShowNotification("~r~Vous ne pouvez pas acheter ce véhicule puisqu'un employé de la concession est en service !")
                                        else
                                            if cache.value ~= nil then
                                                local model = GetHashKey(cache.value)
                                                local newPlate = GeneratePlate()
                                                local vehicleProps = {
                                                    model = model,
                                                    plate = newPlate
                                                }
                        
                                                TriggerServerEvent('bns:giveAutotoId', GetPlayerServerId(PlayerId()), vehicleProps, GetDisplayNameFromVehicleModel(model), false)
                        
                                                RageUI.CloseAll()
                                                OnCataActiveBNS = false
                                                suppautoBNS()
                                            else
                                                ESX.ShowNotification("~r~Aucun véhicule sélectionné.")
                                            end
                                        end
                                    end, "beachnsky")
                                end
                            end, cache.value)
                        end
                    end)

                    RageUI.ButtonWithStyle('Voir le véhicule', nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            BuySpawnBns(cache.value)
                        end
                    end, RMenu:Get('menu', 'displaycatbns'))
                end, function()
                end)

                RageUI.IsVisible(RMenu:Get('menu', 'displaycatbns'), true, true, true, function()
					RageUI.Separator("Vous observez: " ..GetDisplayNameFromVehicleModel(cache.value))
					RageUI.ButtonWithStyle("Arrêter de regarder", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
						if (Selected) then
							delCarCatBns()
						end
					end)
				end, function()
                end)

                Wait(0)
            end
        end, function()
        end, 1)
    end
end

RegisterKeyMapping("openBeachF6", "Ouvrir le menu F6 Beach N Sky", "keyboard", "F6")


Citizen.CreateThread(function()
	RMenu.Add('menu', 'main', RageUI.CreateMenu("PRIME", "Menu PDM", 1, 100))
	RMenu:Get('menu', 'main'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'main').EnableMouse = false
    RMenu:Get('menu', 'main').Closed = function()
		OnCataActiveBNS = false
    end
end)

function suppautoBNS()
    for k,v in pairs(lastcarout) do
		ESX.Game.DeleteVehicle(v)
		lastcarout[k] = nil
    end
end

local catalogueBNS = {
	{x = -805.84936523438, y = -1368.9346923828, z = 4.2783442497253, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(catalogueBNS) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, catalogueBNS[k].x, catalogueBNS[k].y, catalogueBNS[k].z)

			if dist <= 3.0 then
				nearThing = true

                if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'beachnsky') then
                    ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour ouvrir le menu de la concession")
                    DrawMarker(6, catalogueBNS[k].x, catalogueBNS[k].y, catalogueBNS[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
				    if IsControlJustPressed(1,38) then
                        local playerInService = exports["cJobs"]:inService()
                        if not playerInService then
                            ESX.ShowNotification("~r~Vous devez d'abord être en service !")
                        else
                            openCatalogueMenuBNS()
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

local catagensBNS = {
	{x = -806.68170166016, y = -1353.8619384766, z = 4.2783480644226, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(catagensBNS) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, catagensBNS[k].x, catagensBNS[k].y, catagensBNS[k].z)

			if dist < 10.0 then
				nearThing = true
                DrawMarker(6, catagensBNS[k].x, catagensBNS[k].y, catagensBNS[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
				if dist < 3.0 then
                    ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour accéder au ~y~catalogue")
					if IsControlJustPressed(1, 38) then
                        if OnCataActiveBNS == false then
                            openCataGensBNS()
                        end
					end
				end
			end
		end
		if nearThing == true then
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end
	end
end)

function BuySpawnBns(vehicleProps)
    ESX.Game.SpawnLocalVehicle(vehicleProps, {x = -832.09, y = -1300.82, z = 5.00}, 24.1, function(vehicle)
        local playerPed = GetPlayerPed(-1)
        
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        SetVehicleFixed(vehicle)
        FreezeEntityPosition(vehicle, true)
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleDirtLevel(vehicle, 0.0)
        NetworkFadeInEntity(vehicle, true, true)
        SetModelAsNoLongerNeeded(vehicleProps)
        SetEntityAsMissionEntity(vehicle, true, true)

        DisableControlAction(0, 75, true)
        DisableControlAction(27, 75, true)
    end)
end

function BuySpawnBns(vehicleProps)
    local coords, heading
    if IsThisModelABoat(vehicleProps.model) then
        coords = vector3(-868.0258, -1365.7822, -0.4745)
        heading = 199.9701
    else
        coords = vector3(-832.09, -1300.82, 5.00)
        heading = 24.1
    end

    ESX.Game.SpawnLocalVehicle(vehicleProps, coords, heading, function(vehicle)
        local playerPed = GetPlayerPed(-1)
        local inVehicleCheck = true
        
        TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
        SetVehicleFixed(vehicle)
        FreezeEntityPosition(vehicle, true)
        SetVehicleDoorsLocked(vehicle, 2)
        SetVehicleDirtLevel(vehicle, 0.0)
        NetworkFadeInEntity(vehicle, true, true)
        SetModelAsNoLongerNeeded(vehicleProps)
        SetEntityAsMissionEntity(vehicle, true, true)

        Citizen.CreateThread(function()
            while inVehicleCheck do
                Citizen.Wait(10)  -- Contrôle rapide pour réactivité
                if not IsPedSittingInVehicle(playerPed, vehicle) then
                    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                end
            end
        end)
    end)
end

function delCarCatBns()
	local playerPed = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(playerPed)
    inVehicleCheck = false
	ESX.Game.DeleteVehicle(vehicle)
	SetEntityCoords(playerPed, -806.77703857422, -1353.8415527344, 4.278346157074, 1, 0, 0, 1)
	RageUI.CloseAll()
	OnCataActiveBNS = false
end