local st = nil

local function mkAreaBlip(center, radius)
    local blip = AddBlipForRadius(center.x, center.y, center.z, radius + .0)
    SetBlipColour(blip, 3)
    SetBlipAlpha(blip, 120)
    return blip
end

local function mkDropBlip(drop)
    local blip = AddBlipForCoord(drop.x, drop.y, drop.z)
    SetBlipSprite(blip, 524)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 2)
    BeginTextCommandSetBlipName("STRING"); AddTextComponentString("Point de dépôt"); EndTextCommandSetBlipName(blip)
    return blip
end

local function cleanup()
    if not st then return end
    if st.blipArea and DoesBlipExist(st.blipArea) then RemoveBlip(st.blipArea) end
    if st.blipDrop and DoesBlipExist(st.blipDrop) then RemoveBlip(st.blipDrop) end
    st = nil
end

local function requestModel(m)
    local h = GetHashKey(m)
    RequestModel(h); while not HasModelLoaded(h) do Wait(0) end
    return h
end

local function getStreetAreaName(coords)
    local s1, s2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street = GetStreetNameFromHashKey(s1)
    local cross  = s2 ~= 0 and GetStreetNameFromHashKey(s2) or nil
    return cross and (street .. " / " .. cross) or street
end

local function resolveMissionVehicle()
    if not st then return 0 end
    if st.netId and NetworkDoesNetworkIdExist(st.netId) then
        local veh = NetToVeh(st.netId)
        if veh ~= 0 and DoesEntityExist(veh) then return veh end
    end
    if st.plateFrag and st.searchCenter then
        local player = PlayerPedId()
        local ppos = GetEntityCoords(player)
        if #(ppos - st.searchCenter) < (st.searchRadius + 30.0) then
            local veh = GetClosestVehicle(ppos.x, ppos.y, ppos.z, 50.0, 0, 70)
            if veh ~= 0 and DoesEntityExist(veh) then
                local plate = (GetVehicleNumberPlateText(veh) or ""):upper()
                local frag  = tostring(st.plateFrag):upper()
                if frag ~= "" and string.find(plate, frag, 1, true) then
                    return veh
                end
            end
        end
    end
    return 0
end

local function playLockAnim(ped, veh)
	RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@')
    while not HasAnimDictLoaded('anim@amb@clubhouse@tutorial@bkr_tut_ig3@') do
        Citizen.Wait(0)
    end
    TaskPlayAnim(GetPlayerPed(-1), 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer' ,8.0, -8.0, -1, 1, 0, false, false, false )	
end

local function clearLockAnim(ped)
    ClearPedTasks(ped)
end

RegisterNetEvent("orgs:car:begin", function(data)
    cleanup()
    local center = vector3(data.spawn.x, data.spawn.y, data.spawn.z)
    local drop   = vector3(data.drop.x, data.drop.y, data.drop.z)
    st = {
        id = data.id,
        isHost = (GetPlayerServerId(PlayerId()) == data.controller),
        searchCenter = center,
        searchRadius = data.searchRadius or 120.0,
        drop = drop,
        plateFrag = data.plateFrag,
        blipArea = mkAreaBlip(center, data.searchRadius or 120.0),
        blipDrop = 0,
        netId = nil,
        hintsShown = false,
        lockpick = { done = false, inProgress = false, nextTryAt = 0 },
        needHotwire = data.needHotwire or false,
        spawnHeading = data.spawn.h or 0.0,
        modelName = data.modelName or "sultan",
        lockLevel = data.lockLevel or 1,
        spawnWhenDist = 150.0,
        spawned = false
    }
    ESX.ShowNotification("~y~Vol de véhicule~s~: fouille la ~b~zone~s~, trouve la voiture, puis ~g~amène-la au dépôt")
end)

RegisterNetEvent("orgs:car:hints", function(data)
    if not st or data.id ~= st.id then return end
    if st.hintsShown then return end
    st.hintsShown = true
    local h = data.hints or {}
    local lines = {
        ("Classe: ~y~%s~s~"):format(h.class or "?"),
        ("Couleur: ~y~%s~s~"):format(h.color or "?"),
        ("Plaque contient: ~y~%s~s~"):format(h.plateFrag or "??"),
        ("Secteur: ~y~%s~s~"):format(h.area or "?")
    }
    if h.model then table.insert(lines, 1, ("Modèle: ~y~%s~s~"):format(h.model)) end
    ESX.ShowNotification(table.concat(lines, "\n"))
end)

CreateThread(function()
    while true do
        if st then
            if st.isHost and not st.spawned then
                local ped = PlayerPedId()
                local p = GetEntityCoords(ped)
                if #(p - st.searchCenter) <= (st.spawnWhenDist or 150.0) then
                    local hash = requestModel(st.modelName)
                    local colorIndex = math.random(0, 160)
                    local veh = CreateVehicle(hash, st.searchCenter.x, st.searchCenter.y, st.searchCenter.z, st.spawnHeading, true, true)
                    SetEntityAsMissionEntity(veh, true, true)
                    local plate = "SQSA ".. tostring(math.random(100,999))
                    SetVehicleNumberPlateText(veh, plate)
                    SetVehicleColours(veh, colorIndex, colorIndex)
                    SetVehicleExtraColours(veh, 0, 0)
                    if (st.lockLevel or 1) > 0 then
                        SetVehicleDoorsLocked(veh, 2)
                        SetVehicleAlarm(veh, true)
                    end
                    if st.needHotwire then SetVehicleNeedsToBeHotwired(veh, true) end
                    local netId = NetworkGetNetworkIdFromEntity(veh)
                    SetNetworkIdCanMigrate(netId, true)
                    local class = GetVehicleClass(veh)
                    local area  = getStreetAreaName(st.searchCenter)
                    TriggerServerEvent("orgs:car:register", {
                        netId = netId,
                        plate = plate,
                        modelHash = hash,
                        color = colorIndex,
                        class = class,
                        area  = area
                    })
                    st.netId = netId
                    st.spawned = true
                end
            end
        end
        Wait(200)
    end
end)

CreateThread(function()
    while true do
        if st then
            local ped = PlayerPedId()
            if not IsPedInAnyVehicle(ped, false) then
                local veh = resolveMissionVehicle()
                if veh ~= 0 then
                    local pPos = GetEntityCoords(ped)
                    local vPos = GetEntityCoords(veh)
                    local dist = #(pPos - vPos)
                    if dist <= 2.5 and not st.lockpick.done and not st.lockpick.inProgress then
                        local lockStatus = GetVehicleDoorLockStatus(veh)
                        if lockStatus ~= 1 then
                            if GetGameTimer() >= (st.lockpick.nextTryAt or 0) then
                                ESX.ShowHelpNotification("Appuie sur ~INPUT_PICKUP~ pour ~y~crocheter~s~ la serrure")
                                if IsControlJustPressed(0, 38) then
                                    st.lockpick.inProgress = true
                                    playLockAnim(ped, veh)
                                    StartVehicleAlarm(veh)
                                    local success = exports['rm_minigames']:timedLockpick(200)
                                    clearLockAnim(ped)
                                    if success then
                                        SetVehicleDoorsLocked(veh, 1)
                                        SetVehicleAlarm(veh, false)
                                        SetVehicleAlarmTimeLeft(veh, 0)
                                        if st.needHotwire then
                                            SetVehicleNeedsToBeHotwired(veh, false)
                                        end
                                        st.lockpick.done = true
                                        ESX.ShowNotification("~g~Crochetage réussi~s~. Le véhicule est ~b~déverrouillé~s~.")
                                    else
                                        StartVehicleAlarm(veh)
                                        ESX.ShowNotification("~r~Crochetage raté~s~. Réessaie plus tard...")
                                        st.lockpick.nextTryAt = GetGameTimer() + 2500
                                    end
                                    st.lockpick.inProgress = false
                                end
                            end
                        end
                    end
                end
            end
            Wait(5)
        else
            Wait(600)
        end
    end
end)

CreateThread(function()
    while true do
        if st then
            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                local veh = GetVehiclePedIsIn(ped, false)
                if veh ~= 0 then
                    local netId = NetworkGetNetworkIdFromEntity(veh)
                    if st.netId and netId == st.netId then
                        if st.blipDrop == 0 then st.blipDrop = mkDropBlip(st.drop) end
                        local p = GetEntityCoords(veh)
                        if #(p - st.drop) <= 6.0 then
                            TriggerServerEvent("orgs:car:deliver", { id = st.id, netId = st.netId })
                            SetEntityAsMissionEntity(veh, true, true)
                            DeleteVehicle(veh)
                            if st.blipDrop and DoesBlipExist(st.blipDrop) then RemoveBlip(st.blipDrop) end
                            Wait(1500)
                        end
                    end
                end
            end
            Wait(250)
        else
            Wait(600)
        end
    end
end)

RegisterNetEvent("orgs:car:end", function(data)
    if st and data and data.id == st.id then
        if data.success then
            ESX.ShowNotification("~g~Véhicule livré ! Mission réussie")
        else
            ESX.ShowNotification("~r~Mission annulée")
        end
    end
    cleanup()
end)