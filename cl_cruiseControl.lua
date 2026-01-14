local isSpeedLimited = false
local limitedSpeed = 0.0

local function EnableSpeedLimiter(vehicle)
    isSpeedLimited = true
    limitedSpeed = GetEntitySpeed(vehicle)

    SetVehicleMaxSpeed(vehicle, limitedSpeed)

    local speedKMH = math.floor(limitedSpeed * 3.6 + 0.5)
    ESX.ShowNotification('Limitateur de vitesse fixé à ' .. speedKMH .. ' km/h')

    Entity(vehicle).state:set('isSpeedLimited', true, true)
end

local function ToggleSpeedLimiter()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)

    if not IsPedInAnyVehicle(ped, false) or GetPedInVehicleSeat(vehicle, -1) ~= ped then
        return
    end

    if not isSpeedLimited then
        EnableSpeedLimiter(vehicle)
    else
        DisableSpeedLimiter(vehicle)
    end
end

function DisableSpeedLimiter(vehicle)
    isSpeedLimited = false

    SetVehicleMaxSpeed(vehicle, 0.0)
    ESX.ShowNotification('Limitateur de vitesse désactivé')
    Entity(vehicle).state:set('isSpeedLimited', false, true)
end

RegisterCommand('limitateur', function()
    ToggleSpeedLimiter()
end, false)

RegisterKeyMapping('limitateur', 'Limiteur de vitesse', 'keyboard', '')
