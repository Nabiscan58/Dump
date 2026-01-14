Citizen.CreateThread(function()
    while true do

        local favGunstyle = GetResourceKvpString("gunstyle")
        favGunstyle = tonumber(favGunstyle)
        if favGunstyle and DP.GunStyles[favGunstyle] and DP.GunStyles[favGunstyle].a then
            DecorSetInt(PlayerPedId(), "gunstyle", favGunstyle)
            SetWeaponAnimationOverride(PlayerPedId(), GetHashKey(DP.GunStyles[favGunstyle].a))
        end

        Citizen.Wait(15 * 1000)
    end
end)

CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(500)
    end

    DecorRegister("gunstyle", 3)

    CreateThread(function()
        while true do
            Wait(250)
            local ped, gunstyle = PlayerPedId(), DecorGetInt(PlayerPedId(), "gunstyle")

            if gunstyle and gunstyle > 1 and (DP.GunStyles[gunstyle] ~= nil and DP.GunStyles[gunstyle].b ~= nil and DP.GunStyles[gunstyle].c ~= nil) then
                local dict, anim = DP.GunStyles[gunstyle].b, DP.GunStyles[gunstyle].c
                if dict and anim and IsPedArmed(ped, 4) then
                    while not HasAnimDictLoaded(dict) do
                        Wait(25)
                        RequestAnimDict(dict)
                    end

                    local _, hash = GetCurrentPedWeapon(ped, 1)
                    -- if IsPlayerFreeAiming(PlayerId()) or (IsControlPressed(0, 24) and GetAmmoInClip(ped, hash) > 0) then
                    if IsControlPressed(0, 25) then
                        if not IsEntityPlayingAnim(ped, dict, anim, 3) then
                            TaskPlayAnim(ped, dict, anim, 8.0, -8.0, -1, 49, 0, 0, 0, 0)
                            SetEnableHandcuffs(ped, true)
                        end
                    elseif IsEntityPlayingAnim(ped, dict, anim, 3) then
                        ClearPedTasks(ped)
                        SetEnableHandcuffs(ped, false)
                    end
                end
            else
                Wait(750)
            end
        end
    end)

    while true do
        local sleep = 2500

        for _, player in pairs(GetActivePlayers()) do
            local ped = GetPlayerPed(player)
            local gunstyle = DecorGetInt(ped, "gunstyle")

            if gunstyle and gunstyle > 0 and DP.GunStyles[gunstyle] then
                SetWeaponAnimationOverride(ped, DP.GunStyles[gunstyle].a)
            end
        end

        Wait(2500)
    end
end)