local stunnedCache = {}
local stunnedStack = 0

local function FadeOutStunnedTimecycle(from)
    local strength = from
    local increments = from / 100

    for _i = 1, 100 do
        Wait(50)
        strength = strength - increments

        if stunnedStack >= 1 then
            return
        end

        if strength <= 0 then
            break
        end

        SetTimecycleModifierStrength(strength)
    end

    SetTimecycleModifierStrength(0.0)
    ClearTimecycleModifier()
end

local function DoTaserEffect(effectLength)
    stunnedStack = stunnedStack + 1
    SetTimecycleModifierStrength(0.5)
    SetTimecycleModifier("dont_tazeme_bro")

    ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 0.25)

    Wait(effectLength)
    stunnedStack = stunnedStack - 1
    if stunnedStack == 0 then
        FadeOutStunnedTimecycle(0.5)
        StopGameplayCamShaking(false)
    end
end

local function OnLocalPlayerStunned(playerPed, attacker)
    local groundTime = 5000 == 9000 and 5000 or math.random(5000, 9000)
    SetPedMinGroundTimeForStungun(playerPed, groundTime)

    SetTimeout(50, function()
        local gameTimer = GetGameTimer()
        if stunnedCache[attacker] and stunnedCache[attacker] + 2800 > gameTimer then
            return
        end

        if IsPedBeingStunned(playerPed, 0) then
            stunnedCache[attacker] = gameTimer
            DoTaserEffect(groundTime)
        end
    end)
end

local function OnNPCStunned(args)
    local ped = args[1]

    SetPedConfigFlag(ped, 281, true)
end

AddEventHandler('gameEventTriggered', function(event, args)
    if event == "CEventNetworkEntityDamage" then
        local playerPed = PlayerPedId()
        local attacker = args[2]
        local weaponHash = args[7]

        if playerPed == args[1] and attacker ~= -1 and (weaponHash == 911657153 or weaponHash == -1833087301) then
            OnLocalPlayerStunned(playerPed, attacker)
        elseif IsEntityAPed(args[1]) and not IsPedAPlayer(args[1]) and NetworkHasControlOfEntity(args[1]) and (weaponHash == 911657153 or weaponHash == -1833087301) then
            OnNPCStunned(args)
        end
    end
end)