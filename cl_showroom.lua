ESX = nil
ShowroomEntities = {}
local ShowroomOpen = false
local showroomVehiclesCache = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    TriggerServerEvent('mosley:showroom:requestInit')
end)

RegisterNetEvent('mosley:showroom:refresh')
AddEventHandler('mosley:showroom:refresh', function()
    for slotId, ent in pairs(ShowroomEntities) do
        if DoesEntityExist(ent) then
            ESX.Game.DeleteVehicle(ent)
            DeleteEntity(ent)
        end
    end
    ShowroomEntities = {}

    ESX.TriggerServerCallback('mosley:showroom:getState', function(rows)
        currentState = {}
        for _, r in ipairs(rows or {}) do
            currentState[r.slot_id] = {
                plate = r.plate,
                vehicle = r.vehicle,
                pos = vector3(r.x, r.y, r.z),
                heading = r.heading
            }

            if r.vehicle and r.vehicle.model then
                local spawnPos = vector3(r.x, r.y, r.z - 0.97)
                local h = r.heading + 0.0

                ESX.Game.SpawnLocalVehicle(r.vehicle.model, spawnPos, h, function(v)
                    ESX.Game.SetVehicleProperties(v, r.vehicle)
                    SetVehicleFixed(v)
                    SetVehicleDirtLevel(v, 0.0)
                    SetEntityInvincible(v, true)
                    SetEntityAsMissionEntity(v, true, true)
                    FreezeEntityPosition(v, true)
                    SetVehicleDoorsLocked(v, 2)
                    SetVehicleCanBreak(v, false)
                    SetVehicleUndriveable(v, true)
                    SetVehicleOnGroundProperly(v)
                    ShowroomEntities[r.slot_id] = v
                end)
            end
        end
    end)
end)

Citizen.CreateThread(function()
    TriggerEvent('mosley:showroom:refresh')
end)

local selectedSlot = nil
local selectedPlate = nil
local currentState = {}

function refreshState()
    -- -- delete all vehicles spawned
    -- for _, ent in pairs(ShowroomEntities) do
    --     if DoesEntityExist(ent) then
    --         ESX.Game.DeleteVehicle(ent)
    --     end
    -- end
    -- ShowroomEntities = {}

    ESX.TriggerServerCallback('mosley:showroom:getState', function(rows)
        currentState = {}
        for _, r in ipairs(rows or {}) do
            currentState[r.slot_id] = {plate=r.plate, vehicle=r.vehicle, pos=vector3(r.x,r.y,r.z), heading=r.heading}
        end
    end)
end

-- RegisterNetEvent('mosley:showroom:refresh')
-- AddEventHandler('mosley:showroom:refresh', function()
--     refreshState()
-- end)

RegisterNetEvent('mosley:showroom:slotCleared')
AddEventHandler('mosley:showroom:slotCleared', function(slotId)
    local veh = ShowroomEntities[slotId]
    if veh and DoesEntityExist(veh) then
        ESX.Game.DeleteVehicle(veh)
        DeleteEntity(veh)
    end
    ShowroomEntities[slotId] = nil
    currentState[slotId] = nil
end)