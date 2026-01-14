ESX = nil

local FourriereOpen = false
local action = false
local OnMenuActive = false
local EnAction = false
local SpawnVehicule = {coords = vector3(451.5693359375, -1153.4914550781, 29.418937683105)}
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9" }
local filter = 1
local citizen = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
	ESX.PlayerData.job.grade_name = grade
end)

Citizen.CreateThread(function()
	RMenu.Add('menu', 'main', RageUI.CreateMenu("PRIME", "Menu Fourrière", 1, 100))
	RMenu.Add('menu', 'auto', RageUI.CreateMenu("PRIME", "Menu Fourrière", 1, 100))
	RMenu.Add('menu', 'interactions', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "PRIME", "Menu Fourrière"))
	RMenu:Get('menu', 'main'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'auto'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'interactions'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'main').EnableMouse = false
    RMenu:Get('menu', 'main').Closed = function()
		FourriereOpen = false
    end
	RMenu:Get('menu', 'auto').Closed = function()
		FourriereOpen = false
    end
end)

function GetVehicleInDirection(coordFrom, coordTo)
	local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
	local a, b, c, d, vehicle = GetRaycastResult(rayHandle)
	return vehicle
end

local impoundedVehicles = {}
local myimpoundedVehicles = {}

RegisterNetEvent("impound:callback")
AddEventHandler("impound:callback", function(cb)
	impoundCallback = cb
end)

RegisterNetEvent("myimpound:callback")
AddEventHandler("myimpound:callback", function(cb)
	myimpoundCallback = cb
end)

RegisterNetEvent("impound:hourcallback")
AddEventHandler("impound:hourcallback", function(cb)
	hourCallback = cb
end)

function autoRetrait()
	if FourriereOpen then
        FourriereOpen = false
        return
    else
        FourriereOpen = true
        RageUI.Visible(RMenu:Get('menu', 'auto'), true)

		ESX.TriggerServerCallback('impound:getmyVehicles', function(data)
			myimpoundedVehicles = data
		end)

        Citizen.CreateThread(function()
            while FourriereOpen do
				RageUI.IsVisible(RMenu:Get('menu', 'auto'), true, true, true, function()
					RageUI.Separator("Vos véhicules saisis")
					for k,v in pairs(myimpoundedVehicles) do
						RageUI.ButtonWithStyle(v.plate, nil, { RightLabel = "70,000 $" },true, function(Hovered, Active, Selected)
							if Selected then
								RageUI.CloseAll()
								FourriereOpen = false
								TriggerServerEvent("impound:moveup", v.plate)

								myimpoundCallback = nil
								while not myimpoundCallback do Citizen.Wait(100) end
	
								if myimpoundCallback == 'can_spawn' then
									RequestModel(v.vehicle.model)
									while not HasModelLoaded(v.vehicle.model) do
										Citizen.Wait(100)
									end
									local vehicle = CreateVehicle(v.vehicle.model, Config.CitizenImpoundedVehicleSpawn, 270.42108154297, true, false)
									ESX.Game.SetVehicleProperties(vehicle, v.vehicle)
									SetVehicleNumberPlateText(vehicle, v.plate)
									TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
								end
							end
						end)
					end
				end, function()
				end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

function openFOURMenu()
	local coords = GetEntityCoords(PlayerPedId())

    if FourriereOpen then
        FourriereOpen = false
        return
    else
        FourriereOpen = true
        RageUI.Visible(RMenu:Get('menu', 'main'), true)

        Citizen.CreateThread(function()
            while FourriereOpen do

				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
					RageUI.CloseAll()
					FourriereOpen = false
				end

				RageUI.IsVisible(RMenu:Get('menu', 'main'), true, true, true, function()
                    RageUI.ButtonWithStyle("Intéractions Véhicules", nil, { RightLabel = "→" },true, function()
					end, RMenu:Get('menu', 'interactions'))
                end, function()
				end)
				
				RageUI.IsVisible(RMenu:Get('menu', 'interactions'), true, true, true, function()                   

					local elements  = {}
					local playerPed = PlayerPedId()
					local coords    = GetEntityCoords(playerPed)
					local vehicle   = ESX.Game.GetVehicleInDirection()

						local dst = GetDistanceBetweenCoords(Config.ImpoundedVehicleSpawn, GetEntityCoords(PlayerPedId()), true)

						RageUI.ButtonWithStyle("Mettre un véhicule en fourrière", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local invehicle = GetVehiclePedIsIn(PlayerPedId(), false)

								if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
									RageUI.CloseAll()
									FourriereOpen = false

									local vehicleProps = ESX.Game.GetVehicleProperties(invehicle)

									TriggerServerEvent("impound:check", vehicleProps)
									impoundCallback = nil
									while not impoundCallback do Citizen.Wait(100) end
									if impoundCallback == 'can_delete' then
										DeleteEntity(invehicle)
									end
									TriggerServerEvent("fourriere:vente")
									RageUI.CloseAll()
									FourriereOpen = false
								else
									ESX.ShowNotification("~r~Vous devez être dans un véhicule !")
									RageUI.CloseAll()
									FourriereOpen = false
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

Citizen.CreateThread(function()
    while true do
		local isFourriere = false

		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'fourriere') then
			isFourriere = true
			if IsControlJustPressed(0, 167) then
				if FourriereOpen == false then
					openFOURMenu()
				end
			end
		end

		if isFourriere then
			Citizen.Wait(0)
		else
			Citizen.Wait(2500)
		end
    end
end)


--Garage 

Citizen.CreateThread(function()
	RMenu.Add('menu', 'principal', RageUI.CreateMenu("PRIME", "Menu Fourrière", 1, 100))
	RMenu:Get('menu', 'principal'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'principal').EnableMouse = false
    RMenu:Get('menu', 'principal').Closed = function()
		OnMenuActive = false
    end
end)

local myvehicles = {
	{x = 460.71209716797, y = -1158.2111816406, z = 28.518937683105, }
}    

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(myvehicles) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, myvehicles[k].x, myvehicles[k].y, myvehicles[k].z)

			if dist <= 3.0 then
				nearThing = true
				DrawMarker(6, myvehicles[k].x, myvehicles[k].y, myvehicles[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
				ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour ouvrir le menu de la fourrière")
				if IsControlJustPressed(1,51) then
					if FourriereOpen == false then
						autoRetrait()
					end
				end
			end
		end

		if nearThing then
			Wait(0)
		else
			Wait(250)
		end
	end
end)

Citizen.CreateThread(function()
	RMenu.Add('menu', 'depot2', RageUI.CreateMenu("PRIME", "Menu Fourrière", 1, 100))
	RMenu.Add('menu', 'depot3', RageUI.CreateSubMenu(RMenu:Get('menu', 'depot2'), "PRIME", "Menu Fourrière"))
	RMenu.Add('menu', 'impounded_vehicles', RageUI.CreateSubMenu(RMenu:Get('menu', 'depot2'), "PRIME", "Menu Fourrière"))
    RMenu:Get('menu', 'depot2'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'depot3'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'impounded_vehicles'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'depot2').EnableMouse = false
    RMenu:Get('menu', 'depot2').Closed = function()
		OnDepotActive = false
    end
end)

function OpenDepotVehicule()
	local coords = GetEntityCoords(PlayerPedId())

    if OnDepotActive then
        OnDepotActive = false
        return
    else
        OnDepotActive = true
        RageUI.Visible(RMenu:Get('menu', 'depot2'), true)

        Citizen.CreateThread(function()
            while OnDepotActive do

				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
					RageUI.CloseAll()
					OnDepotActive = false
				end
                
                RageUI.IsVisible(RMenu:Get('menu', 'depot2'), true, true, true, function()         
					
					local playerPed = PlayerPedId()
					local coords    = GetEntityCoords(playerPed)
					local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
					

                    RageUI.ButtonWithStyle("Mettre un véhicule en fourrière", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							if IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 3.0) then
								RageUI.CloseAll()
								OnDepotActive = false

								local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

								TriggerServerEvent("impound:check", vehicleProps)

								impoundCallback = nil
								while not impoundCallback do Citizen.Wait(100) end
								if impoundCallback == 'can_delete' then DeleteEntity(vehicle) end
								TriggerServerEvent("fourriere:vente")
							else
								ESX.ShowNotification("~r~Vous devez être dans un véhicule !")
							end
						end
					end)

					RageUI.ButtonWithStyle("Voir les véhicules en fourrière", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
						if Selected then
							ESX.TriggerServerCallback('impound:getVehicles', function(data)
								impoundedVehicles = data
							end)
						end
					end, RMenu:Get('menu', 'impounded_vehicles'))

                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'impounded_vehicles'), true, true, true, function()

					RageUI.List("Filtre de Plaque:", filterArray, filter, nil, {}, true, function(_, _, _, i)
						filter = i
					end)
					RageUI.Separator("↓ ~y~Véhicules~s~ ↓")
					for k,v in pairs(impoundedVehicles) do
						if starts(v.plate:lower(), filterArray[filter]:lower()) then
							RageUI.ButtonWithStyle(v.plate, "Ce véhicule a été mis en fourrière le "..v.date, {RightLabel = string.upper(GetDisplayNameFromVehicleModel(v.vehicle.model))},true, function()end)
						end
					end

				end, function()
                end)

                Wait(0)
            end
        end, function()
        end, 1)
    end
end

local depotvehicule = {
	{x = 412.34359741211, y = -1147.7996826172, z = 28.518935775757, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(depotvehicule) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, depotvehicule[k].x, depotvehicule[k].y, depotvehicule[k].z)

			if dist <= 2.0 then
				nearThing = true
				if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'fourriere') then
					DrawMarker(6, depotvehicule[k].x, depotvehicule[k].y, depotvehicule[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
					ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour accéder au menu de gestion des véhicules de la fourrière")
					if IsControlJustPressed(1,51) then
						if FourriereOpen == false then
							OpenDepotVehicule()
						end
					end
				end
			end
		end

		if nearThing then
			Wait(0)
		else
			Wait(250)
		end
	end
end)

function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end