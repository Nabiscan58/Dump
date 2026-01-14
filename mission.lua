local cooldown, mission = false, false
local taxiNPC, taxiBlip, taxiDestBlip = nil, nil, nil

local NpcTaxiSpawn <const> = {
	vector3(2484.266, 4096.516, 38.03397),
	vector3(1798.084, 4579.208, 36.54569),
	vector3(1543.641, 3784.253, 34.05507),
	vector3(224.043, 3163.017, 42.33317),
	vector3(-1105.175, 2693.6, 18.61158),
	vector3(-2553.538, 2318.525, 33.20124),
	vector3(-1777.846, 48.11143, 68.00174),
	vector3(-2188.569, -362.2508, 13.10201),
	vector3(-1707.155, -562.8764, 36.56107),
	vector3(-1205.868, -1152.035, 7.699143),
	vector3(-551.0773, -1045.344, 22.56311),
	vector3(1180.245, -1450.401, 34.86432),
	vector3(838.878, 530.7098, 125.9142),
	vector3(-602.3339, 248.176, 82.05513),
	vector3(-0.7544376, 277.843, 108.9533),
	vector3(119.3213, -162.7759, 54.72859),
	vector3(-291.8375, -14.79115, 48.88467),
	vector3(-769.0762, -38.87459, 37.8338),
	vector3(-1348.332, -411.0558, 36.10377),
	vector3(-825.1642, -848.5597, 19.98683),
	vector3(-117.6863, -898.5429, 29.27865),
	vector3(78.18667, -1251.369, 29.29173),
	vector3(93.72096, -1490.713, 29.29442),
	vector3(-1068.918, -2701.035, 13.66431)
}

local DestCoordsTaxi <const> = {
	vector3(2484.266, 4096.516, 38.03397),
	vector3(1798.084, 4579.208, 36.54569),
	vector3(1543.641, 3784.253, 34.05507),
	vector3(224.043, 3163.017, 42.33317),
	vector3(-1105.175, 2693.6, 18.61158),
	vector3(-2553.538, 2318.525, 33.20124),
	vector3(-1777.846, 48.11143, 68.00174),
	vector3(-2188.569, -362.2508, 13.10201),
	vector3(-1707.155, -562.8764, 36.56107),
	vector3(-1205.868, -1152.035, 7.699143),
	vector3(-551.0773, -1045.344, 22.56311),
	vector3(1180.245, -1450.401, 34.86432),
	vector3(838.878, 530.7098, 125.9142),
	vector3(-602.3339, 248.176, 82.05513),
	vector3(-0.7544376, 277.843, 108.9533),
	vector3(119.3213, -162.7759, 54.72859),
	vector3(-291.8375, -14.79115, 48.88467),
	vector3(-769.0762, -38.87459, 37.8338),
	vector3(-1348.332, -411.0558, 36.10377),
	vector3(-825.1642, -848.5597, 19.98683),
	vector3(-117.6863, -898.5429, 29.27865),
	vector3(78.18667, -1251.369, 29.29173),
	vector3(93.72096, -1490.713, 29.29442),
	vector3(-1068.918, -2701.035, 13.66431)
}

local function RandomTaxiNPC()
    local index = GetRandomIntInRange(1, #NpcTaxiSpawn)
    return NpcTaxiSpawn[index]
end

local function RandomTaxiDest()
    local index = GetRandomIntInRange(1, #DestCoordsTaxi)
    return DestCoordsTaxi[index]
end

function missionTaxi()
    local pnjModel = "a_m_m_tourist_01"
    if cooldown then
        ESX.ShowNotification("Veuillez patienter avant de lancer une nouvelle mission.")
        return
    end
    if mission then
        if taxiBlip and DoesBlipExist(taxiBlip) then RemoveBlip(taxiBlip) end
        if taxiDestBlip and DoesBlipExist(taxiDestBlip) then RemoveBlip(taxiDestBlip) end
        if taxiNPC and DoesEntityExist(taxiNPC) then DeleteEntity(taxiNPC) end
        PlaySoundFrontend(-1, "Team_Capture_Start", "GTAO_Magnate_Yacht_Attack_Soundset", 1)
        ESX.ShowAdvancedNotification("Centrale", "~y~Taxi", "Vous avez annulé votre mission !", "CHAR_MULTIPLAYER", 8)
        taxiNPC, taxiBlip, taxiDestBlip = nil, nil, nil
        mission = false
        return
    end

    mission = true
    cooldown = true
    PlaySoundFrontend(-1, "Team_Capture_Start", "GTAO_Magnate_Yacht_Attack_Soundset", 1)

    RequestModel(GetHashKey(pnjModel))
    while not HasModelLoaded(GetHashKey(pnjModel)) do Wait(0) end

    local spawn = RandomTaxiNPC()
    if taxiNPC and DoesEntityExist(taxiNPC) then DeleteEntity(taxiNPC) end
    taxiNPC = CreatePed(4, GetHashKey(pnjModel), spawn.x, spawn.y, spawn.z - 1.0, 143.21, false, false)
    TaskWanderStandard(taxiNPC, 10.0, 10)

    if taxiBlip and DoesBlipExist(taxiBlip) then RemoveBlip(taxiBlip) end
    taxiBlip = AddBlipForEntity(taxiNPC)
    SetBlipSprite(taxiBlip, 103)
    SetBlipColour(taxiBlip, 5)
    SetBlipScale(taxiBlip, 0.8)
    SetBlipRoute(taxiBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Client')
    EndTextCommandSetBlipName(taxiBlip)
    ESX.ShowAdvancedNotification("Centrale", "~y~Taxi", "J'ai un client qui t'attend !", "CHAR_MULTIPLAYER", 8)

    while mission and taxiNPC and DoesEntityExist(taxiNPC) and #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(taxiNPC)) > 4.5 do
        Wait(100)
    end
    if not mission or not taxiNPC or not DoesEntityExist(taxiNPC) then
        cooldown = false
        return
    end

    local veh = GetVehiclePedIsUsing(PlayerPedId())
    if veh ~= 0 then TaskWarpPedIntoVehicle(taxiNPC, veh, 2) end
    ESX.ShowAdvancedNotification("Centrale", "~y~Taxi", "Le client est monté, ramène le à la destination affichée sur ta carte.", "CHAR_MULTIPLAYER", 8)

    if taxiBlip and DoesBlipExist(taxiBlip) then RemoveBlip(taxiBlip) end
    local dest = RandomTaxiDest()
    if taxiDestBlip and DoesBlipExist(taxiDestBlip) then RemoveBlip(taxiDestBlip) end
    taxiDestBlip = AddBlipForCoord(dest.x, dest.y, dest.z)
    SetBlipSprite(taxiDestBlip, 103)
    SetBlipColour(taxiDestBlip, 2)
    SetBlipScale(taxiDestBlip, 0.8)
    SetBlipRoute(taxiDestBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Destination')
    EndTextCommandSetBlipName(taxiDestBlip)

    while mission and #(GetEntityCoords(PlayerPedId()) - dest) > 10.0 do
        Wait(200)
    end
    if taxiDestBlip and DoesBlipExist(taxiDestBlip) then RemoveBlip(taxiDestBlip) end
    if taxiNPC and DoesEntityExist(taxiNPC) then DeleteEntity(taxiNPC) end
    taxiNPC, taxiBlip, taxiDestBlip = nil, nil, nil

    if mission then
        ESX.ShowAdvancedNotification("Centrale", "~b~Taxi", "Le client est descendu, je te vire ton argent !", "CHAR_MULTIPLAYER", 8)
        TriggerServerEvent('cJobs_taxi.mission')
    end
    mission = false
	
    Citizen.SetTimeout(150000, function()
        cooldown = false
        ESX.ShowAdvancedNotification("Centrale", "~y~Taxi", "Cooldown terminé ! Relancez une mission quand vous le souhaitez !", "CHAR_MULTIPLAYER", 8)
    end)
end