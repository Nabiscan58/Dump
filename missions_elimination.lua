local state = nil

local function pickSafeSpawn(center, minR, maxR)
    if minR > maxR then
        minR, maxR = maxR, minR
    end
    for i = 1, 30 do
        local a = math.random() * 6.28318530718
        local r = minR + math.random() * (maxR - minR)
        local x = center.x + math.cos(a) * r
        local y = center.y + math.sin(a) * r
        local ok, gz = GetGroundZFor_3dCoord(x, y, center.z + 1000.0, false)
        if ok then
            return vector3(x, y, gz + 1.0)
        end
    end
    return vector3(center.x, center.y, center.z + 1.0)
end

local function mkBlip(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 1)
    SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Zone d'élimination")
    EndTextCommandSetBlipName(blip)
    return blip
end

local function mkEnemyBlip(ped)
    local blip = AddBlipForEntity(ped)
    SetBlipSprite(blip, 310)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 1)
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Cible")
    EndTextCommandSetBlipName(blip)
    return blip
end

local function cleanup()
    if not state then return end
    if state.blip and DoesBlipExist(state.blip) then
        SetBlipRoute(state.blip, false)
        RemoveBlip(state.blip)
    end
    if state.blips then
        for ped, blip in pairs(state.blips) do
            if blip and DoesBlipExist(blip) then
                RemoveBlip(blip)
            end
        end
    end
    if state.peds then
        for _, ped in ipairs(state.peds) do
            if DoesEntityExist(ped) then DeletePed(ped) end
        end
    end
    state = nil
end

local function pickRandom(list)
    return list[math.random(1, #list)]
end

local function giveWeapon(ped, weaponName)
    local hash = GetHashKey(weaponName)
    GiveWeaponToPed(ped, hash, 9999, false, true)
    SetCurrentPedWeapon(ped, hash, true)
end

local REL_GROUP_ENEMY = GetHashKey("HATES_PLAYER")

local function spawnWave(params, center)
    local count      = params.count or 1
    local models     = params.models or {"g_m_y_mexgang_01"}
    local weaponName = params.weapon or "WEAPON_PISTOL"
    local hp         = params.health or 200
    local armor      = params.armor or 0
    local acc        = params.accuracy or 25
    local maxRadius  = params.spawnRadius or 80.0
    local minRadius  = params.spawnMinRadius or math.min(60.0, maxRadius * 0.6)
    local aggro      = params.aggressive ~= false

    local loaded = {}
    for _, m in ipairs(models) do
        local h = GetHashKey(m)
        RequestModel(h)
        while not HasModelLoaded(h) do Wait(0) end
        table.insert(loaded, h)
    end

    local spawned = {}
    local ids = {}

    for i = 1, count do
        local model = pickRandom(loaded)
        local pos = pickSafeSpawn(center, minRadius, maxRadius)
        local ped = CreatePed(30, model, pos.x, pos.y, pos.z, math.random(0, 360) + .0, true, false)
        SetEntityAsMissionEntity(ped, true, true)

        SetPedArmour(ped, armor)
        SetEntityHealth(ped, hp)
        SetPedAccuracy(ped, acc)
        SetPedDropsWeaponsWhenDead(ped, false)
        SetPedCombatAttributes(ped, 46, true)
        SetPedCombatAbility(ped, 2)
        SetPedCombatRange(ped, 2)
        SetPedFleeAttributes(ped, 0, false)
        SetPedRelationshipGroupHash(ped, REL_GROUP_ENEMY)

        giveWeapon(ped, weaponName)

        if aggro then
            TaskCombatHatedTargetsAroundPed(ped, 200.0, 0)
        end

        local eblip = mkEnemyBlip(ped)
        if state.blips then
            state.blips[ped] = eblip
        end

        local netId = NetworkGetNetworkIdFromEntity(ped)
        ids[#ids + 1] = netId

        SetModelAsNoLongerNeeded(model)
        table.insert(spawned, ped)
    end

    TriggerServerEvent("orgs:elim:registerPeds", { ids = ids })
    return spawned
end

CreateThread(function()
    while true do
        if state and state.peds and #state.peds > 0 then
            for i = #state.peds, 1, -1 do
                local ped = state.peds[i]
                if DoesEntityExist(ped) then
                    if IsPedDeadOrDying(ped, true) or GetEntityHealth(ped) <= 0 then
                        local netId = NetworkGetNetworkIdFromEntity(ped)
                        TriggerServerEvent("orgs:elim:reportKill", { netId = netId })

                        local blip = state.blips and state.blips[ped]
                        if blip and DoesBlipExist(blip) then
                            RemoveBlip(blip)
                        end
                        if state.blips then state.blips[ped] = nil end

                        DeletePed(ped)
                        table.remove(state.peds, i)
                    end
                else
                    local blip = state.blips and state.blips[ped]
                    if blip and DoesBlipExist(blip) then
                        RemoveBlip(blip)
                    end
                    if state.blips then state.blips[ped] = nil end

                    table.remove(state.peds, i)
                end
            end
            Wait(250)
        else
            Wait(500)
        end
    end
end)

RegisterNetEvent("orgs:elim:begin", function(data)
    cleanup()
    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)
    state = {
        id = data.id,
        coords = coords,
        params = data.params or {},
        expected = data.expected or 0,
        isHost = data.host == GetPlayerServerId(PlayerId()),
        peds = {},
        blips = {}
    }
    state.blip = mkBlip(coords)

    ESX.ShowNotification(("~y~Élimination~s~: %d cibles à neutraliser"):format(state.expected))

    if state.isHost then
        Citizen.CreateThread(function()
            local wait = 1000
            while wait > 0 do
                local pcoords = GetEntityCoords(PlayerPedId())
                local dist = #(pcoords - coords)
                if dist < 50.0 then
                    wait = 0
                else
                    wait = math.min(wait, 500)
                end
                Wait(wait)
            end
            state.peds = spawnWave(state.params, coords)
        end)
    end
end)

RegisterNetEvent("orgs:elim:progress", function(data)
    if state and data and data.id == state.id then
        ESX.ShowNotification(("Cibles neutralisées: ~g~%d~s~/~y~%d"):format(data.killed, data.expected))
    end
end)

RegisterNetEvent("orgs:elim:end", function(data)
    if state and data and data.id == state.id then
        if data.success then
            ESX.ShowNotification("~g~Mission réussie. Zone nettoyée")
        else
            ESX.ShowNotification("~r~Mission annulée")
        end
    end
    cleanup()
end)