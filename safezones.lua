----------------------------
--SAFE ZONES----------------
----------------------------

local zones = {
	{ ['x'] = -321.27, ['y'] = -888.52, ['z'] = 31.07}, -- PC Central
	{ ['x'] = -675.71746826172, ['y'] = 321.88220214844, ['z'] = 83.083168029785 }, -- Hôpital
	{ ['x'] = -250.6276, ['y'] = 6319.943, ['z'] = 33.69866 }, -- Hôpital Nord
	{ ['x'] = -1388.812, ['y'] = -602.4538, ['z'] = 29.46681 }, -- Bahamas
	{ ['x'] = 231.1, ['y'] = -794.27, ['z'] = 30.59 }, -- Square
	{ ['x'] = -192.31, ['y'] = -1188.91, ['z'] = 21.85 }, -- Fourrière
	{ ['x'] = 482.7752, ['y'] = 4811.157, ['z'] = -58.38287 }, -- Jail HRP
	{ ['x'] = 389.0119934082, ['y'] = 4827.7524414062, ['z'] = -58.999652862549 }, -- Jail HRP 2
	{ ['x'] = -1417.44, ['y'] = -445.92, ['z'] = 35.91 }, -- Street Tuners
	{ ['x'] = -37.627815246582, ['y'] = -1661.583984375, ['z'] = 29.630504608154 }, -- Mosley
	{ ['x'] = 1114.24, ['y'] = 238.64, ['z'] = -49.84 }, -- Casino
	{ ['x'] = -1392.57, ['y'] = -614.0895, ['z'] = 31.17713 }, -- Bahamas
	{ ['x'] = 803.3502, ['y'] = -752.8791, ['z'] = 26.78086 }, -- Pizzeria
	{ ['x'] = 129.7641, ['y'] = -1300.098, ['z'] = 28.30769 }, -- Unicorn
	{ ['x'] = -1266.8, ['y'] = -3011.354, ['z'] = -47.01814 }, -- Zone AFK
	{ ['x'] = -240.46846008301, ['y'] = 6211.1748046875, ['z'] = 32.066986083984 }, -- Paleto Motors
	{ ['x'] = -774.32525634766, ['y'] = -228.81816101074, ['z'] = 36.573204040527 }, -- Concessionnaire
	{ ['x'] = -1043.9871, ['y'] = -1399.2217, ['z'] = 5.0750 }, -- Caserne Pompier
	{ ['x'] = 1702.6765, ['y'] = 4926.1440, ['z'] = 42.0637 }, -- LTD Nord
	{ ['x'] = 56.9126, ['y'] = 6522.7329, ['z'] = 31.9128 }, -- Harmony
	{ ['x'] = 696.9126, ['y'] = 136.7329, ['z'] = 80.9128 }, -- Benny's
	{ ['x'] = -342.47561645508, ['y'] = -763.93670654297, ['z'] = 33.92699432373 }, -- Parking rouge

	-- Clothing shops :

	{ ['x'] = 423.22268676758, ['y'] = -800.81176757812, ['z'] = 28.49342918396 },
    { ['x'] = 77.648490905762, ['y'] = -1398.3321533203, ['z'] = 28.378427505493 },
    { ['x'] = -825.73181152344, ['y'] = -1078.2236328125, ['z'] = 10.330401420593 },
    { ['x'] = -1192.9029541016, ['y'] = -774.93121337891, ['z'] = 16.329011917114 },
    { ['x'] = 121.5486831665, ['y'] = -217.99000549316, ['z'] = 53.557655334473 },
    { ['x'] = 1690.8974609375, ['y'] = 4827.9189453125, ['z'] = 41.065380096436 },
    { ['x'] = 620.08636474609, ['y'] = 2759.3217773438, ['z'] = 41.088218688965 },
    { ['x'] = -1104.052734375, ['y'] = 2705.3447265625, ['z'] = 18.110151290894 },
    { ['x'] = -3174.0808105469, ['y'] = 1049.5626220703, ['z'] = 19.863349914551 },
    { ['x'] = 7.3645577430725, ['y'] = 6517.7827148438, ['z'] = 30.880138397217 },
    { ['x'] = 1191.2204589844, ['y'] = 2707.9565429688, ['z'] = 37.224899291992 },
    { ['x'] = -711.18353271484, ['y'] = -150.35595703125, ['z'] = 36.415191650391 },
    { ['x'] = -164.43942260742, ['y'] = -305.75686645508, ['z'] = 38.733337402344 },
    { ['x'] = -332.3341, ['y'] = 7214.3999, ['z'] = 5.8096 },
}

local notifIn = false
local notifOut = false
local closestZone = 1

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	PlayerData = ESX.GetPlayerData()
end)

local function isLSFD()
    local jobName = ESX and ESX.PlayerData and ESX.PlayerData.job and ESX.PlayerData.job.name
    return jobName == 'lsfd'
end

AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData = ESX.PlayerData or {}
    ESX.PlayerData.job = job
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		local playerPed = PlayerPedId()
		local x, y, z = table.unpack(GetEntityCoords(playerPed, true))
		local minDistance = 100000
		for i = 1, #zones, 1 do
			dist = Vdist(zones[i].x, zones[i].y, zones[i].z, x, y, z)
			if dist < minDistance then
				minDistance = dist
				closestZone = i
			end
		end
		Citizen.Wait(15000)
	end
end)

Citizen.CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Citizen.Wait(0)
	end
	
	while true do
		Citizen.Wait(0)
		local player = PlayerPedId()
		local x,y,z = table.unpack(GetEntityCoords(player, true))
		local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
		local nearThing = false

		if dist <= 30.0 then
			nearThing = true
			if not notifIn then
				exports["PRM_StatusHud"]:SafeZoneShowFor(5000)
				ESX.ShowNotification("Vous entrez en zone safe ! Le port du masque est interdit comme dans tous les lieux publics.")

				if isLSFD() then
					-- LSFD : pas de restriction d’armes
					NetworkSetFriendlyFireOption(true)
					SetEntityInvincible(PlayerPedId(), false)
				else
					-- autres joueurs : safe classique
					NetworkSetFriendlyFireOption(false)
					ClearPlayerWantedLevel(PlayerId())
					SetEntityInvincible(PlayerPedId(), true)
					SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
				end

				TriggerEvent("UI:ShowSafe")
				notifIn = true
				notifOut = false
			end
		else
			if not notifOut then
				ESX.ShowNotification("Vous sortez de la zone safe !")
				NetworkSetFriendlyFireOption(true)
				SetEntityInvincible(PlayerPedId(), false)
				TriggerEvent("UI:HideSafe")
				notifOut = true
				notifIn = false
			end
		end
		
		if nearThing then
			Wait(0)
		else
			Wait(250)
		end
		if notifIn then
			if not isLSFD() then
				DisableControlAction(2, 37, true)   -- weapon wheel
				DisablePlayerFiring(player, true)   -- tir
				DisableControlAction(0, 106, true)  -- clic gauche
				DisableControlAction(0, 64, true)   -- divers
				SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)

				if IsDisabledControlJustPressed(2, 37) or IsDisabledControlJustPressed(0, 106) then
					SetCurrentPedWeapon(player, GetHashKey("WEAPON_UNARMED"), true)
				end
			end
		end
	end
end)

exports("InZoneSafe", function()
	local player = PlayerPedId()
	local x,y,z = table.unpack(GetEntityCoords(player, true))
	local dist = Vdist(zones[closestZone].x, zones[closestZone].y, zones[closestZone].z, x, y, z)
	local nearThing = false

	if dist <= 50.0 then
		return true 
	else
		return false 
	end 
end)