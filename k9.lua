K9 = {}
K9.data = {}

local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end

        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end

        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)

        local next = true
        repeat
        coroutine.yield(id)
        next, id = moveFunc(iter)
        until not next

        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end

function EnumerateObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function EnumeratePeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function EnumeratePickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

K9.GetPlayers = function()
	local maxPlayers = 255
	local players    = {}

	for i=0, maxPlayers, 1 do

		local ped = GetPlayerPed(i)

		if DoesEntityExist(ped) then
			table.insert(players, i)
		end
	end

	return players
end

K9.GetClosestPlayer = function(coords)
	local players         = K9.GetPlayers()
	local closestDistance = -1
	local closestPlayer   = -1
	local coords          = coords
	local usePlayerPed    = false
	local playerPed       = PlayerPedId()
	local playerId        = PlayerId()

	if coords == nil then
		usePlayerPed = true
		coords       = GetEntityCoords(playerPed)
	end

	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])

		if not usePlayerPed or (usePlayerPed and players[i] ~= playerId) then
			local targetCoords = GetEntityCoords(target)
			local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

			if closestDistance == -1 or closestDistance > distance then
				closestPlayer   = players[i]
				closestDistance = distance
			end
		end
	end

	return closestPlayer, closestDistance
end

K9.GetPlayersInArea = function(coords, area)
	local players       = K9.GetPlayers()
	local playersInArea = {}

	for i=1, #players, 1 do
		local target       = GetPlayerPed(players[i])
		local targetCoords = GetEntityCoords(target)
		local distance     = GetDistanceBetweenCoords(targetCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(playersInArea, players[i])
		end
	end

	return playersInArea
end

K9.SpawnDog = function()
    if not DoesEntityExist(K9.dogEntity) then
        local model = GetHashKey("a_c_shepherd")

        RequestModel(model)
        while not HasModelLoaded(model) do 
            Wait(0) 
        end
        
        K9.dogEntity = CreatePed(4, model, GetEntityCoords(PlayerPedId()), 0.0, true, false)
        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(K9.dogEntity), true)
        SetEntityAsMissionEntity(K9.dogEntity, true, true)
        SetModelAsNoLongerNeeded(model)

        SetEntityHealth(K9.dogEntity, 1000.0)
        -- SetEntityInvincible(K9.dogEntity, true)
        
        TaskFollowToOffsetOfEntity(K9.dogEntity, PlayerPedId(), 0.5, 0.0, 0.0, 7.0, -1, 0.0, 1)
        SetPedKeepTask(K9.dogEntity, true)
        CanPedRagdoll(K9.dogEntity, false)

        K9.dogBlip = AddBlipForEntity(K9.dogEntity)
        SetBlipSprite(K9.dogBlip, 273)
        SetBlipColour(K9.dogBlip, 0)
        SetBlipScale(K9.dogBlip, 0.50)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Chien de police")
        EndTextCommandSetBlipName(K9.dogBlip)

        Citizen.CreateThread(function()
            while GetEntityHealth(K9.dogEntity) > 0 do

                local dDst = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(K9.dogEntity), false)

                if dDst >= 500.0 then
                    SetEntityHealth(K9.dogEntity, 0.0)
                    DeleteEntity(K9.dogEntity)
                    K9.dogEntity = nil
                end

                SetEntityInvincible(K9.dogEntity, true)

                Citizen.Wait(1000)
            end
            DeleteEntity(K9.dogEntity)
            K9.dogEntity = nil
        end)
    else
        DeleteEntity(K9.dogEntity)
        K9.dogEntity = nil
    end
end

K9.FollowDog = function()
    RequestAnimDict('rcmnigel1c') 
    while not HasAnimDictLoaded('rcmnigel1c') do 
        Wait(0) 
    end
    TaskPlayAnim(PlayerPedId(), 'rcmnigel1c', 'hailing_whistle_waive_a', 8.0, -8, 100.0, 48, 0, false, false, false)

    if not K9.data.follow then
        ClearPedTasks(K9.dogEntity)
        K9.data.follow = true
    else
        TaskFollowToOffsetOfEntity(K9.dogEntity, PlayerPedId(), 0.5, 0.0, 0.0, 7.0, -1, 0.0, 1)
        SetPedKeepTask(K9.dogEntity, true)
        K9.data.follow = false
    end
end

K9.SitDog = function()
    if not K9.data.stand then
        K9.data.stand = not K9.data.stand
        RequestAnimDict('creatures@rottweiler@amb@world_dog_sitting@base') 
        while not HasAnimDictLoaded('creatures@rottweiler@amb@world_dog_sitting@base') do 
            Wait(0) 
        end
        TaskPlayAnim(K9.dogEntity, 'creatures@rottweiler@amb@world_dog_sitting@base', 'base', 8.0, -8, -1, 1, 0, false, false, false)
    else
        K9.data.stand = not K9.data.stand
        ClearPedTasks(K9.dogEntity)
    end
end

K9.CarDog = function()
    local coords = GetEntityCoords(PlayerPedId())
    local hundcoords = GetEntityCoords(K9.dogEntity)

    if #(coords - hundcoords) <= 10 then
        if IsPedInAnyVehicle(K9.dogEntity, false) then
            TaskLeaveVehicle(K9.dogEntity, GetVehiclePedIsIn(K9.dogEntity, false), 256)
            K9.data.inCar = true
        else
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local vehicle, seat = GetVehiclePedIsIn(PlayerPedId(), false), nil
                
                for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do
                    if IsVehicleSeatFree(vehicle, i) then
                        if seat == nil then
                            seat = i
                        end
                    end
                end

                TaskEnterVehicle(K9.dogEntity, vehicle, -1, seat, 5.0, 0)
                K9.data.inCar = false
            else
                ESX.ShowNotification("~r~Vous devez être dans un véhicule pour ceci")
            end
        end
    else
        ESX.ShowNotification("~r~Le chien est trop loin de vous")
    end
end

K9.SearchDrug = function()
    local coords = GetEntityCoords(PlayerPedId())
    local hundcoords = GetEntityCoords(K9.dogEntity)
    local dist = #(coords - hundcoords)

    if dist <= 5 then
        local closestPlayer, closestPlayerDistance = K9.GetClosestPlayer()

        ClearPedTasksImmediately(K9.dogEntity)
        TaskFollowToOffsetOfEntity(K9.dogEntity, GetPlayerPed(closestPlayer), 0.5, 0.0, 0.0, 7.0, -1, 0.0, 1)

        local playersInArea = K9.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 30.0)
        local inAreaData = {}

        for i=1, #playersInArea, 1 do
            table.insert(inAreaData, GetPlayerServerId(playersInArea[i]))
        end

        TriggerServerEvent('k9:search', GetPlayerServerId(closestPlayer), 'drugs', inAreaData, K9.dogEntity)

        Citizen.CreateThread(function()
            Citizen.Wait(5000)
            ClearPedTasks(K9.dogEntity)
            K9.data.follow = true
        end)
    else
        ESX.ShowNotification("~r~Le chien est trop loin de vous")
    end
end

K9.SearchWeapons = function()
    local coords = GetEntityCoords(PlayerPedId())
    local hundcoords = GetEntityCoords(K9.dogEntity)
    local dist = #(coords - hundcoords)

    if dist <= 5 then
        local closestPlayer, closestPlayerDistance = K9.GetClosestPlayer()

        ClearPedTasksImmediately(K9.dogEntity)
        TaskFollowToOffsetOfEntity(K9.dogEntity, GetPlayerPed(closestPlayer), 0.5, 0.0, 0.0, 7.0, -1, 0.0, 1)

        local playersInArea = K9.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 30.0)
        local inAreaData = {}

        for i=1, #playersInArea, 1 do
            table.insert(inAreaData, GetPlayerServerId(playersInArea[i]))
        end

        TriggerServerEvent('k9:search', GetPlayerServerId(closestPlayer), 'weapons', inAreaData, K9.dogEntity)

        Citizen.CreateThread(function()
            Citizen.Wait(5000)
            ClearPedTasks(K9.dogEntity)
            K9.data.follow = true
        end)
    else
        ESX.ShowNotification("~r~Le chien est trop loin de vous")
    end
end

K9.SearchCar = function(vehicle)
    local coords = GetEntityCoords(PlayerPedId())
    local hundcoords = GetEntityCoords(K9.dogEntity)
    local dist = #(coords - hundcoords)

    if dist <= 5 then
        local closestPlayer, closestPlayerDistance = K9.GetClosestPlayer()

        local vehicle, seat = GetVehiclePedIsIn(PlayerPedId(), false), nil
                
        for i=1, GetVehicleModelNumberOfSeats(GetEntityModel(vehicle)) do
            if IsVehicleSeatFree(vehicle, i) then
                if seat == nil then
                    seat = i
                end
            end
        end

        TaskEnterVehicle(K9.dogEntity, vehicle, -1, seat, 5.0, 0)

        -- ClearPedTasksImmediately(K9.dogEntity)
        -- TaskFollowToOffsetOfEntity(K9.dogEntity, vehicle, 0.5, 0.0, 0.0, 7.0, -1, 0.0, 1)

        local playersInArea = K9.GetPlayersInArea(GetEntityCoords(PlayerPedId()), 30.0)
        local inAreaData = {}

        for i=1, #playersInArea, 1 do
            table.insert(inAreaData, GetPlayerServerId(playersInArea[i]))
        end

        TriggerServerEvent('k9:searchCar', vehicle, 'car', inAreaData, K9.dogEntity)

        Citizen.CreateThread(function()
            Citizen.Wait(5000)
            TaskLeaveVehicle(K9.dogEntity, GetVehiclePedIsIn(K9.dogEntity, false), 256)
            -- ClearPedTasks(K9.dogEntity)
            K9.data.follow = true
        end)
    else
        ESX.ShowNotification("~r~Le chien est trop loin de vous")
    end
end

local function DrawMe3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    local scale = 200 / (GetGameplayCamFov() * dist)

	SetTextColour(230, 230, 230, 200)
    SetTextScale(0.0, 0.5 * scale)
    SetTextFont(0)
	SetTextDropshadow(0, 0, 0, 0, 55)
	SetTextDropShadow()
	SetTextCentre(true)

	BeginTextCommandDisplayText("STRING")
	AddTextComponentSubstringPlayerName(text)
	SetDrawOrigin(coords, 0)
	EndTextCommandDisplayText(0.0, 0.0)
	ClearDrawOrigin()
end

local function DisplayEntity(ped, text)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = nil
    local pedDisplaying = {}

    for k in EnumeratePeds() do
        if #(GetEntityCoords(k) - GetEntityCoords(playerPed)) < 100.0 then
            if GetEntityModel(k) == GetHashKey("a_c_shepherd") then
                ped = k
                pedCoords = GetEntityCoords(k)
            end
        end
    end

    local dist = #(playerCoords - pedCoords)

	if pedCoords ~= playerCoords then
        if dist <= 250 then

			pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

			local display = true

			Citizen.CreateThread(function()
				Wait(5000)
				display = false
			end)

			local offset = 0.4 + pedDisplaying[ped] * 0.1
            while display do
				local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
				DrawMe3D(vector3(x, y, z), text)
				Wait(0)
			end

			pedDisplaying[ped] = pedDisplaying[ped] - 1
		end
	end
end

RegisterNetEvent('k9:shareDisplayEntity')
AddEventHandler('k9:shareDisplayEntity', function(text, entityId)
    DisplayEntity(entityId, text)
end)

AddEventHandler("onResourceStop", function()
    DeleteEntity(K9.dogEntity)
end)