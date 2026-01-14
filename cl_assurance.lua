-- Config
local pedCoords  = vector4(219.84187316895, 367.67459106445, 106.18545532227, 109.47980499268)
local pedModel   = `s_m_m_highsec_01`     -- change si tu veux un autre ped
local spawnRange = 30.0                   -- distance pour spawn/despawn
local interactRange = 2.2                 -- distance d’interaction (E)

-- Vars runtime
local pedHandle = nil

-- Util: affichage aide (ESX si dispo, sinon native)
local function showHelp(msg)
	if ESX and ESX.ShowHelpNotification then
		ESX.ShowHelpNotification(msg)
	else
		BeginTextCommandDisplayHelp("STRING")
		AddTextComponentSubstringPlayerName(msg)
		EndTextCommandDisplayHelp(0, false, true, -1)
	end
end

-- Util: load/unload model
local function loadModel(hash)
	RequestModel(hash)
	local t = GetGameTimer() + 10000
	while not HasModelLoaded(hash) do
		if GetGameTimer() > t then break end
		Wait(10)
	end
	return HasModelLoaded(hash)
end

local function spawnLocalPed()
	if pedHandle and DoesEntityExist(pedHandle) then return pedHandle end
	if not loadModel(pedModel) then return nil end

	local x, y, z, h = pedCoords.x, pedCoords.y, pedCoords.z, pedCoords.w or 0.0
	-- Ajuste Z au sol si possible
	local found, groundZ = GetGroundZFor_3dCoord(x, y, z, false)
	if found and groundZ > 0.0 then z = groundZ end

	-- CreatePed(pedType, modelHash, x,y,z, heading, isNetwork, bScriptHostPed)
	local ped = CreatePed(4, pedModel, x + 0.0, y + 0.0, z + 0.1, h, false, false) -- false => local
	if not ped or ped == 0 then return nil end

	SetEntityAsMissionEntity(ped, true, true)
	SetEntityHeading(ped, h)
	SetEntityInvincible(ped, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	SetPedCanRagdoll(ped, false)
	FreezeEntityPosition(ped, true)
	SetPedDiesWhenInjured(ped, false)
	SetEntityCanBeDamaged(ped, false)
	-- petite anim statique (optionnel)
	TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)

	pedHandle = ped
	return ped
end

local function deletePed()
	if pedHandle and DoesEntityExist(pedHandle) then
		ClearPedTasksImmediately(pedHandle)
		DeleteEntity(pedHandle)
	end
	pedHandle = nil
end

-- Main loop: spawn/despawn + interaction
CreateThread(function()
	local pedPos3 = vector3(pedCoords.x, pedCoords.y, pedCoords.z)

	while true do
		local pPed = PlayerPedId()
		local pPos = GetEntityCoords(pPed)
		local d = #(pPos - pedPos3)

		if d <= spawnRange then
			if not pedHandle or not DoesEntityExist(pedHandle) then
				spawnLocalPed()
			end

			-- Interaction à proximité
			if d <= interactRange then
				showHelp("Appuyez sur ~y~E~s~ pour parler")
				if IsControlJustPressed(0, 38) then -- 38 = E
					OpenGarage(true)
				end
				Wait(0) -- boucle fluide si collé au ped
			else
				Wait(150)
			end
		else
			if pedHandle and DoesEntityExist(pedHandle) then
				deletePed()
			end
			Wait(500) -- on est loin, on dort plus
		end
	end
end)

AddEventHandler('onResourceStop', function(res)
	if res ~= GetCurrentResourceName() then return end
	deletePed()
	if HasModelLoaded(pedModel) then SetModelAsNoLongerNeeded(pedModel) end
end)

RegisterNUICallback('insureVehicle', function(data, cb)
	TriggerServerEvent("garage:assure", data)
    cb('ok')
end)