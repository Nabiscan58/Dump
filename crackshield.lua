local function crackshieldCameraShake(durationMs, amplitude)
    durationMs = durationMs or 2000
    amplitude = amplitude or 0.35

    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', amplitude)
    Wait(durationMs)
    StopGameplayCamShaking(true)
end

local function isPedValid(ped)
    return ped and ped ~= 0 and DoesEntityExist(ped) and not IsEntityDead(ped)
end

local lastArmour = 0
local wasArmoured = false
local cooldownUntil = 0

CreateThread(function()
    while true do
        Wait(120)

        local ped = PlayerPedId()
        if not isPedValid(ped) then
            lastArmour = 0
            wasArmoured = false
            cooldownUntil = 0
        else
            local armour = GetPedArmour(ped)
            local now = GetGameTimer()

            if armour > 0 then
                wasArmoured = true
            end

            if wasArmoured and lastArmour > 0 and armour <= 0 and now >= cooldownUntil then
                cooldownUntil = now + 2500
                crackshieldCameraShake(2000, 0.35)
                TriggerEvent('crackshield:cracked')
                wasArmoured = false
            end

            lastArmour = armour
        end
    end
end)

exports('crackshieldCameraShake', crackshieldCameraShake)
exports('onCrackshieldCracked', function(cb)
    AddEventHandler('crackshield:cracked', cb)
end)