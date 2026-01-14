---@param scenario string
---@param duration number
---@param label string
---@param cb function
function playAction(scenario, duration, label, cb)
    TaskStartScenarioInPlace(PlayerPedId(), scenario, 0, true)

    local timeout = GetGameTimer() + duration
    TriggerEvent("core:drawBar", duration, label)
    while GetGameTimer() < timeout do
        FreezeEntityPosition(PlayerPedId(), true)
        Wait(0)
    end

    FreezeEntityPosition(PlayerPedId(), false)
    ClearPedTasksImmediately(PlayerPedId())

    if cb then
        cb()
    end
end

local function getClosestVehicle()
    local vehicles = GetGamePool("CVehicle")
    local closestDist, closestVeh

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        local vehicleDist = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(vehicle))
        if not closestVeh or vehicleDist < closestDist then
            closestDist, closestVeh = vehicleDist, vehicle
        end
    end

    return closestDist, closestVeh
end

local function repairVehicle()
    local groups = {
        bennys = true,
        harmony = true,
        mayans = true,
        fourriere = true,
        streettuners = true
    }

    local coords = GetEntityCoords(PlayerPedId(), false)
    if not IsAnyVehicleNearPoint(coords.x, coords.y, coords.z, 5.0) then return end

    local vehicle
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    else
        local _, closestVeh = getClosestVehicle()
        vehicle = closestVeh
    end

    if not DoesEntityExist(vehicle) then return end

    NetworkRequestControlOfEntity(vehicle)
    while not NetworkHasControlOfEntity(vehicle) do
        Wait(0)
    end

    if not groups[playerJob] then
        local itemDelete = math.random(1, 2) == 1 and "kit" or "carokit"
        TriggerServerEvent("cJob_custom.deleteItem", itemDelete, 1)
    end

    playAction('PROP_HUMAN_BUM_BIN', 20000, "🔧 Réparation du véhicule...", function()
        SetVehicleFixed(vehicle)
        SetVehicleDeformationFixed(vehicle)
        SetVehicleUndriveable(vehicle, false)
        SetVehicleEngineOn(vehicle, true, true)

        ESX.ShowNotification('~y~Véhicule réparé avec succès !')
    end)
end

local function impoundVehicle(vehicle)
    if not DoesEntityExist(vehicle) then
        return
    end

    NetworkHasControlOfEntity(vehicle)

    local timeout = 2000
    while timeout > 0 and not IsEntityAMissionEntity(vehicle) do
        Wait(100)
        timeout = timeout - 100
    end

    SetEntityAsMissionEntity(vehicle, true, true)

    timeout = 2000
    while timeout > 0 and not IsEntityAMissionEntity(vehicle) do
        Wait(100)
        timeout = timeout - 100
    end

    Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))

    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
    end
end

exports.ox_target:addGlobalVehicle({
    {
        name = 'window_tinit',
        icon = 'fa-solid fa-droplet',
        label = 'Vérifier la teinte des fenêtres',
        distance = 2,
        groups = {"police", "sheriff", "marshall"},
        onSelect = function(data)
            local windowTint = GetVehicleWindowTint(data.entity)
            local tints <const> = {
                [0] = "Les vitres du véhicule ne sont pas teintées.",
                [1] = "Les vitres du véhicule ont une teinte pure noire.",
                [2] = "Les vitres du véhicule ont une teinte foncée.",
                [3] = "Les vitres du véhicule ont une teinte claire.",
                [4] = "Les vitres du véhicule ont une teinte de stock.",
            }

            ESX.ShowNotification("~y~" .. (tints[windowTint] or "Les vitres du véhicule ne sont pas teintées."))
        end
    },
    {
        name = 'checking_plate',
        icon = 'fas fa-search',
        label = 'Analyse de plaque',
        distance = 2,
        groups = {"fourriere", "police", "sheriff", "marshall"},
        onSelect = function(data)
            local plateEntity = GetVehicleNumberPlateText(data.entity)
            if not plateEntity then
                return
            end

            local input = lib.inputDialog('Analyse de plaque', {
                { type = 'checkbox', label = 'Utiliser la plaque du véhicule ciblé ?', checked = plateEntity ~= nil },
                { type = 'input', label = 'Ou entrer une plaque manuellement', placeholder = '12-XXX' }
            })
            if not input then
                return
            end

            local useTarget = input[1]
            local manualPlate = input[2]
            local plateToCheck = nil
    
            if useTarget and plateEntity then
                plateToCheck = plateEntity
            elseif manualPlate and manualPlate ~= '' then
                plateToCheck = manualPlate:upper()
            else
                ESX.ShowNotification('Aucune plaque valide fournie.')
                return
            end
    
            ESX.TriggerServerCallback('cJobs_target.getPlate', function(owner, found)
                if found then
                    ESX.ShowNotification("Propriétaire trouvé : " .. owner)
                else
                    ESX.ShowNotification("Plaque introuvable !")
                end
            end, plateToCheck)
        end
    },
    {
        name = 'fast_impound',
        icon = 'fas fa-truck-pickup',
        label = 'Fourrière rapide',
        distance = 2,
        groups = {"fourriere", "bennys", "harmony", "mayans", "streettuners", "mosley"},
        onSelect = function(data)
            DeleteEntity(data.entity)
        end
    },
    {
        name = 'fast_impound', -- !! [A TESTER]
        icon = 'fas fa-truck-pickup',
        label = 'Fourrière',
        distance = 2,
        groups = {"pdm", "paletoauto", "beachnsky", "marshall", "police", "sheriff"},
        onSelect = function(data)
            impoundVehicle(data.entity)
        end
    },
    {
        name = 'crochete',
        icon = 'fa-solid fa-screwdriver',
        label = 'Crocheter',
        distance = 2,
        groups = {"fourriere", "mosley", "police", "sheriff", "marshall", "bennys", "harmony", "mayans", "beachnsky", "paletoauto", "pdm", "streettuners"},
        onSelect = function(data)
            playAction("WORLD_HUMAN_WELDING", 5000, "🔧 Crochetage du véhicule...", function()
                SetVehicleDoorsLocked(data.entity, 1)
                SetVehicleDoorsLockedForAllPlayers(data.entity, false)

                ESX.ShowNotification('Le véhicule est ouvert !')
            end)
        end
    },
    {
        name = 'repair',
        icon = 'fa-solid fa-toolbox',
        label = 'Réparer',
        distance = 2,
        onSelect = function(data)
            local groups = {
                bennys = true,
                harmony = true,
                mayans = true,
                fourriere = true,
                streettuners = true
            }

            if groups[playerJob] then
                repairVehicle()
            else
                ESX.TriggerServerCallback("cJob_custom:hasItem", function(hasItem)
                    if hasItem then
                        repairVehicle()
                    else
                        ESX.ShowNotification("~r~Vous n'avez pas de kit de réparation ni de Carokit.")
                    end
                end)
            end
        end
    },
    {
        name = 'wash',
        icon = 'fa-solid fa-hand-sparkles',
        label = 'Laver',
        distance = 2,
        groups = {"fourriere", "mosley", "bennys", "harmony", "mayans", "beachnsky", "paletoauto", "pdm", "streettuners"},
        onSelect = function(data)
            playAction('WORLD_HUMAN_MAID_CLEAN', 10000, "🧽 Nettoyage du véhicule...", function()
                SetVehicleDirtLevel(data.entity, 0)

                ESX.ShowNotification('~y~Véhicule nettoyé avec succès !')
            end)
        end
    }
})