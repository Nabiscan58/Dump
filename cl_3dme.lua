local defaultScale = 0.5
local color = { r = 230, g = 230, b = 230, a = 255 }
local font = 0
local displayTime = 5000
local distToDraw = 250
local pedDisplaying = {}

local function DrawText3D(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    local scale = 200 / (GetGameplayCamFov() * dist)

    SetTextColour(color.r, color.g, color.b, color.a)
    SetTextScale(0.0, defaultScale * scale)
    SetTextDropshadow(0, 0, 0, 0, 55)
    SetTextDropShadow()
    SetTextCentre(true)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

local function Display(ped, text)

    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local dist = #(playerCoords - pedCoords)

    if dist <= distToDraw then

        pedDisplaying[ped] = (pedDisplaying[ped] or 1) + 1

        local display = true

        Citizen.CreateThread(function()
            Wait(displayTime)
            display = false
        end)

        local offset = 0.8 + pedDisplaying[ped] * 0.1
        while display do
            if HasEntityClearLosToEntity(playerPed, ped, 17 ) then
                local x, y, z = table.unpack(GetEntityCoords(ped))
                z = z + offset
                DrawText3D(vector3(x, y, z), text)
            end
            Wait(0)
        end

        pedDisplaying[ped] = pedDisplaying[ped] - 1
    end
end

RegisterNetEvent('3dme:Show:Me', function(text, serverId)
    local player = GetPlayerFromServerId(serverId)
    if player ~= -1 then
        local ped = GetPlayerPed(player)
        local coords = GetEntityCoords(ped)
        local myPed = PlayerPedId()
        local myCoords = GetEntityCoords(myPed)
        local distance = Vdist2(coords, myCoords)
        if distance <= 50.0 then
            Display(ped, text)
        end
    end
end)

RegisterCommand("me", function(source, args)
    local text = table.concat(args, " ")
    local lowerText = string.lower(text)

    if string.find(text, '∑') or string.find(text, '÷') or string.find(text, '¦') or string.find(text, '%^') or
       string.find(lowerText, '%f[%a]top%f[%A]') or
       string.find(lowerText, '%f[%a]gang%f[%A]') or
       string.find(lowerText, '%f[%a]mafia%f[%A]') then
        return
    end

    TriggerServerEvent("3dme:Show:Me", args)
end, false)