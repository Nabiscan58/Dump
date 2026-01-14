local active = nil

local function createBlipAt(coords)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 408)
    SetBlipScale(blip, 0.9)
    SetBlipColour(blip, 46)
    SetBlipRoute(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Mallette")
    EndTextCommandSetBlipName(blip)
    return blip
end

local function spawnLocalBriefcase(coords)
    local model = `prop_ld_case_01`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    local obj = CreateObject(model, coords.x, coords.y, coords.z - 1.0, false, false, false)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    SetEntityAsMissionEntity(obj, true, false)
    SetModelAsNoLongerNeeded(model)
    return obj
end

local function cleanup()
    if active then
        if active.blip and DoesBlipExist(active.blip) then
            SetBlipRoute(active.blip, false)
            RemoveBlip(active.blip)
        end
        if active.obj and DoesEntityExist(active.obj) then
            DeleteObject(active.obj)
        end
        active = nil
    end
end

RegisterNetEvent("orgs:brief:begin", function(data)
    cleanup()
    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)
    active = {
        id    = data.id,
        coords= coords,
        blip  = createBlipAt(coords),
        obj   = spawnLocalBriefcase(coords),
        showingHelp = false
    }
    ESX.ShowNotification("~g~Mallette détectée.~s~ Rendez-vous au point et appuyez sur E pour la ramasser")
end)

RegisterNetEvent("orgs:brief:end", function(data)
    if active and data and data.id == active.id then
        if data.winner then
            if data.picker then
                ESX.ShowNotification(("~g~La mallette a été ramassée par ~w~%s~s~"):format(data.picker))
            end
        else
            ESX.ShowNotification("~r~La mallette a déjà été ramassée")
        end
    end
    cleanup()
end)

CreateThread(function()
    while true do
        if active then
            local ped = PlayerPedId()
            local p   = GetEntityCoords(ped)
            local dist = #(p - active.coords)

            if dist < 25.0 then
                DrawMarker(20, active.coords.x, active.coords.y, active.coords.z+0.25, 0.0,0.0,0.0, 0.0,0.0,0.0, 0.35,0.35,0.35, 255, 255, 100, 160, false, true, 2, nil, nil, false)

                if dist < 1.8 then
                    if not active.showingHelp then
                        active.showingHelp = true
                        BeginTextCommandDisplayHelp("STRING")
                        AddTextComponentSubstringPlayerName("Appuyez sur ~INPUT_CONTEXT~ pour ~g~ramasser la mallette")
                        EndTextCommandDisplayHelp(0, false, true, -1)
                    end

                    if IsControlJustPressed(0, 38) then -- E
                        TriggerServerEvent("orgs:brief:pickup", { id = active.id })
                    end
                    else
                    if active.showingHelp then
                        active.showingHelp = false
                        ClearAllHelpMessages()
                    end
                end
            end

            Wait(0)
        else
            Wait(250)
        end
    end
end)