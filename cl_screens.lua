local inCasino              = false
local videoWallRenderTarget = nil
local showBigWin            = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

GroupDigits = function(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ","):reverse())
end

function startCasinoThreads()
    local interior = GetInteriorAtCoords(GetEntityCoords(PlayerPedId()))
    while not IsInteriorReady(interior) do Citizen.Wait(10) end
    RequestStreamedTextureDict('Prop_Screen_Vinewood')

    while not HasStreamedTextureDictLoaded('Prop_Screen_Vinewood') do
        Citizen.Wait(100)
    end

    RegisterNamedRendertarget('casinoscreen_01')

    LinkNamedRendertarget(`vw_vwint01_video_overlay`)

    videoWallRenderTarget = GetNamedRendertargetRenderId('casinoscreen_01')

    Citizen.CreateThread(function()
        local lastUpdatedTvChannel = 0

        while true do
            Citizen.Wait(0)

            if not inCasino then
                ReleaseNamedRendertarget('casinoscreen_01')

                videoWallRenderTarget = nil
                showBigWin            = false

                break
            end

            if videoWallRenderTarget then
                local currentTime = GetGameTimer()

                if showBigWin then
                    setVideoWallTvChannelWin()

                    lastUpdatedTvChannel = GetGameTimer() - 33666
                    showBigWin           = false
                else
                    if (currentTime - lastUpdatedTvChannel) >= 42666 then
                        setVideoWallTvChannel()

                        lastUpdatedTvChannel = currentTime
                    end
                end

                SetTextRenderId(videoWallRenderTarget)
                SetScriptGfxDrawOrder(4)
                SetScriptGfxDrawBehindPausemenu(true)
                DrawInteractiveSprite('Prop_Screen_Vinewood', 'BG_Wall_Colour_4x4', 0.25, 0.5, 0.5, 1.0, 0.0, 255, 255, 255, 255)
                DrawTvChannel(0.5, 0.5, 1.0, 1.0, 0.0, 255, 255, 255, 255)
                SetTextRenderId(GetDefaultScriptRendertargetRenderId())
            end
        end
    end)
end

function setVideoWallTvChannel()
    SetTvChannelPlaylist(0, 'CASINO_DIA_PL', true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(0)
end

function setVideoWallTvChannelWin()
    SetTvChannelPlaylist(0, 'CASINO_WIN_PL', true)
    SetTvAudioFrontend(true)
    SetTvVolume(-100.0)
    SetTvChannel(-1)
    SetTvChannel(0)
end

Citizen.CreateThread(function()
    while true do

        if not inCasino then
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(1096.18, 212.16, -49.0), true) < 150.0 then
                TriggerEvent("casino:entered")
            end
        else
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(1096.18, 212.16, -49.0), true) > 150.0 then
                TriggerEvent("casino:exited")
            end
        end

        Citizen.Wait(1000)
    end
end)

AddEventHandler("casino:entered", function()
    inCasino = true

    startCasinoThreads()

    ESX.TriggerServerCallback("casino:getJetons", function(jetons)
        if jetons then
            CASINO["myJetons"] = jetons
        end
    end)


end)

AddEventHandler("casino:exited", function()
    inCasino = false
end)

AddEventHandler("casino:bigWin", function()
    if not inCasino then
        return
    end

    showBigWin = true
end)