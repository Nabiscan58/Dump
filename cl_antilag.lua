ANTILAG = {}
ANTILAG.enabled = false

UTILS = {}

GetUtils = function()
    return UTILS
end

RegisterCommand("antilag", function(source, args, rawCommand)
    ESX.PlayerData = ESX.GetPlayerData()

    local ranks = ESX.PlayerData.rank
    local hasDiamond = false

    for _, rankInfo in ipairs(ranks) do
        if rankInfo.name == "essential" or rankInfo.name == "diamond" or rankInfo.name == "prime" then
            hasDiamond = true
            break
        end
    end

    if hasDiamond == true then
        if ANTILAG.enabled then
            ESX.ShowNotification("~r~Antilag désactivé")
            ANTILAG.enabled = false
        else
            ESX.ShowNotification("~y~Antilag activé")
            ANTILAG.enable()
        end
    else
        ESX.ShowNotification("~r~L'antilag est uniquement disponible pour les VIP Diamond !")
    end
end)

ANTILAG.enable = function()
    if GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 8 or GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 16 or GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 15 or GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 14 or GetVehicleClass(GetVehiclePedIsIn(PlayerPedId())) == 13 then ESX.ShowNotification("~r~Ce véhicule ne peut pas activer l'antilag") return end

    ANTILAG.enabled = true
    Citizen.CreateThread(function()
        while ANTILAG.enabled do
            local ped = PlayerPedId()

            if not IsControlPressed(1, 71) and not IsControlPressed(1, 72) then
                if IsPedInAnyVehicle(ped) then
                    local pedVehicle = GetVehiclePedIsIn(ped)
                    local vehiclePos = GetEntityCoords(pedVehicle)
                    local RPM = GetVehicleCurrentRpm(GetVehiclePedIsIn(PlayerPedId()))
                    local AntiLagDelay = (math.random(200, 700))
                    if GetPedInVehicleSeat(pedVehicle, -1) == ped then
                        if RPM > 0.75 then
                            local playersInArea = GetPlayersInArea(GetEntityCoords(PlayerPedId()), 100.0)
                            local inAreaData = {}

                            for i=1, #playersInArea, 1 do
                                table.insert(inAreaData, GetPlayerServerId(playersInArea[i]))
                            end
                            TriggerServerEvent("prime:antilag", inAreaData, GetVehicleNumberPlateText(pedVehicle))
                            AddExplosion(vehiclePos.x, vehiclePos.y, vehiclePos.z, 61, 0.0, true, true, 0.0, true)
                            SetVehicleTurboPressure(pedVehicle, 25)
                            Wait(AntiLagDelay)
                        end
                    end
                else
                    ANTILAG.enabled = false
                end
            end
            Wait(0)
        end
    end)
end

local p_flame_location = {
	"exhaust",
	"exhaust_2",
	"exhaust_3",
	"exhaust_4"	
}
local p_flame_particle = "veh_backfire"
local p_flame_particle_asset = "core" 
local p_flame_size = 2.5

RegisterNetEvent("prime:sendAntilag")
AddEventHandler("prime:sendAntilag", function(plate)
    local vehicles = GetVehicles()

    for k,v in pairs(vehicles) do
        if GetVehicleNumberPlateText(v) == plate then
            local vPos = GetEntityCoords(v)
            AddExplosion(vPos.x, vPos.y, vPos.z, 61, 0.0, true, true, 0.0, true)

            for _,bones in pairs(p_flame_location) do
                UseParticleFxAssetNextCall(p_flame_particle_asset)
                createdPart = StartParticleFxLoopedOnEntityBone(p_flame_particle, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetEntityBoneIndexByName(v, bones), p_flame_size, 0.0, 0.0, 0.0)
                StopParticleFxLooped(createdPart, 1)
            end
        end
    end
end)

GetPlayers = function()
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

GetPlayersInArea = function(coords, area)
	local players       = GetPlayers()
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

GetVehicles = function()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

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