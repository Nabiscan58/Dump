local function notify(msg)
    if Pilule.UseOxLibNotifyIfAvailable and GetResourceState('ox_lib') == 'started' and lib and lib.notify then
        lib.notify({
            title = 'Mémoire',
            description = msg,
            type = 'info',
            position = 'top'
        })
    else
        -- Fallback ESX / native
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(false, true)
    end
end

RegisterNetEvent('pilule:notify', function(msg)
    notify(msg)
end)

RegisterNetEvent('pilule:consume', function()
    local dur = (Pilule.EffectDuration or 10) * 1000

    -- Notif RP
    notify('Tu as avalé la pilule... Tu as l\'étrange impression d\'avoir oublié les 20 dernières minutes.')

    -- Petit effet visuel / auditif pour l'ambiance
    DoScreenFadeOut(800)
    Wait(800)

    -- Effet drogue léger
    StartScreenEffect('DrugsMichaelAliensFight', 0, true)
    -- Bruit et flou
    ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.1)
    SetTimecycleModifier('BarryFadeOut')

    DoScreenFadeIn(1200)

    -- Titubement léger
    local ped = PlayerPedId()
    SetPedMovementClipset(ped, 'move_m@drunk@verydrunk', 1.0)

    -- Timer d'effet
    local endTime = GetGameTimer() + dur
    while GetGameTimer() < endTime do
        Wait(200)
    end

    -- Clear effets
    ResetPedMovementClipset(ped, 1.0)
    StopScreenEffect('DrugsMichaelAliensFight')
    ClearTimecycleModifier()

    -- Message de sortie
    notify('...ton cerveau bourdonne encore. Ce qui s\'est passé avant ? Mystère.')
end)