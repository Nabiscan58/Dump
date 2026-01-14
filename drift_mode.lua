Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local driftmode = false
local drift_speed_limit = 150.0

RegisterCommand("drift", function()
	ESX.PlayerData = ESX.GetPlayerData()
    local hasVip = false

	for _, rankInfo in ipairs(ESX.PlayerData.rank) do
        if rankInfo.name == "diamond" or rankInfo.name == "prime" then
            hasVip = true
        end
    end
    if not hasVip then
        ESX.ShowNotification('Vous n\'êtes pas VIP Diamond/Prime !')
        return
    end

	if IsPedInAnyVehicle(PlayerPedId()) then
		driftmode = not driftmode
		if driftmode then
			ESX.ShowNotification("~y~Mode Drift Activé")
			Wait(5000)
		else
			ESX.ShowNotification("~r~Mode Drift Désactivé")
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		local ped = PlayerPedId()
		if driftmode and IsPedInAnyVehicle(ped, false) then
			local vehicle = GetVehiclePedIsIn(ped, false)
			if GetPedInVehicleSeat(vehicle, -1) == ped then
				if GetEntitySpeed(vehicle) * 3.6 <= drift_speed_limit then
					if IsControlPressed(1, 21) then
						SetVehicleReduceGrip(vehicle, true)
					else
						SetVehicleReduceGrip(vehicle, false)
					end
				end
			end
		else
			Citizen.Wait(1000)
		end
	end
end)