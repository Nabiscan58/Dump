ESX = nil
local InStaffJail = false
local JailTimerThreadRunning = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

JAILSTAFF = {
    ["points"] = {
        ["in"] = {
            {pos = vector3(482.5751, 4811.157, -58.3828)},
        },
		["out"] = {
            {pos = vector3(220.3547, -803.944, 30.83182)},
        },
    },
}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterCommand('jail', function(source, args, rawCommand)
    if #args < 3 then
        ESX.ShowNotification("Définissez correctement les arguments de la commande !")
        return
    end

    local id = args[1]
    local time = tonumber(args[2])
    local reason = table.concat(args, " ", 3)

    if id ~= nil and time ~= nil and reason ~= nil then
        local timeInSeconds = time * 60
        TriggerServerEvent("adminmenu:sendPlayerToJail", id, timeInSeconds, reason)
    else
        ESX.ShowNotification("Les arguments doivent être valides !")
    end
end, false)

RegisterCommand('warn', function(source, args, rawCommand)
    local id = tonumber(args[1])
    local reason = table.concat(args, " ", 2)

    TriggerServerEvent("adminmenu:warn", id, reason)
end, false)

RegisterNetEvent('adminmenu:sendJailTimer')
AddEventHandler('adminmenu:sendJailTimer', function(timetoout, reason)
    InStaffJail = true

    JailStaffTimer(timetoout, reason)

    for k,v in pairs(JAILSTAFF["points"]["in"]) do
        SetEntityCoords(PlayerPedId(), v.pos.x, v.pos.y, v.pos.z)
    end
end)

RegisterNetEvent('adminmenu:sendPlayerOutOfJail')
AddEventHandler('adminmenu:sendPlayerOutOfJail', function()
    InStaffJail = false
    for k,v in pairs(JAILSTAFF["points"]["out"]) do
        SetEntityCoords(PlayerPedId(), v.pos.x, v.pos.y, v.pos.z)
    end
end)

function JailStaffTimer(timetoout, reason)
    if JailTimerThreadRunning then return end
    JailTimerThreadRunning = true

    local jailTimer = ESX.Math.Round(timetoout)

    -- THREAD TIMER PRINCIPAL
    Citizen.CreateThread(function()
        while jailTimer > 0 and InStaffJail do
            Citizen.Wait(1000)
            jailTimer = jailTimer - 1

            if wintime then
                jailTimer = jailTimer - 300
            end

            if jailTimer % 300 == 0 then
                TriggerServerEvent("adminmenu:updateJailTimeExact", jailTimer)
            end
        end

        -- QUAND LE TEMPS EST FINI
        if jailTimer <= 0 and InStaffJail then
            InStaffJail = false
            JailTimerThreadRunning = false
            TriggerServerEvent("adminmenu:getOutJail")

            for k, v in pairs(JAILSTAFF["points"]["out"]) do
                SetEntityCoords(PlayerPedId(), v.pos.x, v.pos.y, v.pos.z)
            end
        end
    end)

    -- THREAD AFFICHAGE HUD
    Citizen.CreateThread(function()
        while jailTimer > 0 and InStaffJail do
            Citizen.Wait(0)
            local hours, mins, secs = secondsToClock(jailTimer)
            local text = "Vous avez été jail pour : ~y~" ..reason.. "~s~\nVous sortez de jail dans ~y~" ..string.format("%02d:%02d:%02d", hours, mins, secs)
            DrawGenericTextThisFrame()
            SetTextEntry("STRING")
            AddTextComponentString(text)
            DrawText(0.5, 0.85)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        if InStaffJail then
            local player = PlayerPedId()
            local coordsJoueur = GetEntityCoords(PlayerPedId(), true)
            local distance = GetDistanceBetweenCoords(485.40454101562, 4800.0659179688, -58.382816314697, coordsJoueur, true)

            if distance > 250 then
                SetEntityCoords(PlayerPedId(), 485.40454101562, 4800.0659179688, -58.382816314697)
            end

            DisableControlAction(2, 37, true)
            DisablePlayerFiring(player,true)
            DisableControlAction(0, 106, true)
            DisableControlAction(0, 64, true)

            if IsDisabledControlJustPressed(2, 37) then 
                SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
            end
            if IsDisabledControlJustPressed(0, 106) then
                SetCurrentPedWeapon(player,GetHashKey("WEAPON_UNARMED"),true)
            end
        end
        if InStaffJail then
            Citizen.Wait(0)
        else
            Citizen.Wait(2500)
        end
    end
end)

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.6)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function SelectNumber()
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP8", "", "", "", "", "", 128 + 1)
	
	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
	
	local result = GetOnscreenKeyboardResult()
	
	if result and result ~= "" then
		_quantite = tonumber(result)
        if _quantite > 7200 then
            ESX.ShowNotification("~r~Vous ne pouvez pas mettre plus de 7200 secondes !")
		end
	else
		_quantite = 600
	end
end

function GroupDigits(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ","):reverse())
end

RegisterCommand("unjail", function(source, args)
    local id = args[1]

    TriggerServerEvent("adminmenu:admin:getOutJail", id)
end)

function isPlayerInJail()
    return InStaffJail
end

function secondsToClock(seconds)
    local hours = math.floor(seconds / 3600)
    seconds = seconds % 3600
    local mins = math.floor(seconds / 60)
    local secs = seconds % 60
    return hours, mins, secs
end