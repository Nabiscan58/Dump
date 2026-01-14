Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local KVP_KEY = "armor_value"
local APPLY_DELAY = 750

-- Utils
local function clamp(v, a, b)
    v = tonumber(v) or 0
    if v < a then return a end
    if v > b then return b end
    return v
end

local function getArmor()
    return (GetPedArmour(PlayerPedId()) or 0)
end

local function setArmor(val)
    SetPedArmour(PlayerPedId(), clamp(math.floor(val or 0), 0, 100))
end

local pendingRestoreValue = nil
AddEventHandler('onClientResourceStart', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    local stored = GetResourceKvpInt(KVP_KEY) or 0
    if stored and stored > 0 then
        pendingRestoreValue = clamp(stored, 0, 100)
        CreateThread(function()
            Wait(APPLY_DELAY)
            if pendingRestoreValue then
                setArmor(pendingRestoreValue)
            end
        end)
    else
        pendingRestoreValue = nil
    end
end)

AddEventHandler('playerSpawned', function()
    if not pendingRestoreValue then return end
    CreateThread(function()
        Wait(APPLY_DELAY)
        setArmor(pendingRestoreValue)
    end)
end)

AddEventHandler('onClientResourceStop', function(resName)
    if resName ~= GetCurrentResourceName() then return end
    local current = getArmor()
    SetResourceKvpInt(KVP_KEY, clamp(current, 0, 100))
end)

local obj = GetHashKey("prop_cs_heist_bag_02")
local OnUsingKev = false

RegisterNetEvent("prime.equitArmour")
AddEventHandler("prime.equitArmour", function(level)
    local player = PlayerPedId()
    local coords = GetOffsetFromEntityInWorldCoords(player, 0.0, 0.7, -1.0)
    local player_coords = GetEntityCoords(player)
    local time = level == "lourd" and math.random(20000,25000) or math.random(10000,15000)
    local amount = level == "lourd" and 200 or 50

    if IsPedInAnyVehicle(player, false) then
        ESX.ShowNotification("Vous avez déchiré votre gilet en essayant de l'utiliser dans un espace restreint. Il est inutilisable...")
        return
    end

    RequestModel(obj)
    while not HasModelLoaded(obj) do
        Wait(10)
    end

    local object = CreateObject(obj, coords, true, false, false)
    FreezeEntityPosition(object, true)

    ExecuteCommand("e mechanic4")
    ExecuteCommand("e stop")
    ExecuteCommand("e mechanic4")
    TriggerEvent("core:drawBar", time, "⌛ Ajout du gilet...")

    OnUsingKev = true
    Wait(time)

    if GetDistanceBetweenCoords(GetEntityCoords(player), player_coords, true) > 1.0 then
        ESX.ShowNotification("Vous n'avez pas pu mettre ce gilet pare-balles correctement car vous étiez en train de bouger.")
    else
        AddArmourToPed(player, amount)
        SetPedArmour(player, amount)
        ESX.ShowNotification(("~y~Vous avez mis votre gilet %s !"):format(level == "lourd" and "lourd" or "léger"))
    end

    PlaySoundFrontend(-1, "Object_Collect_Player", "GTAO_FM_Events_Soundset", 0)
    ClearPedTasks(player)
    TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(object))
    OnUsingKev = false
end)

function UsingGilet()
    return OnUsingKev
end