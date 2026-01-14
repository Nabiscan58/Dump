
ESX = nil

local robbed = false
local forcing = false

TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)

RegisterNetEvent('robatm:starthacking')
AddEventHandler('robatm:starthacking', function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped)
	local streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))
	TriggerServerEvent("police:appel", coords, "Suspect rôdant autour d'un ATM vers " ..streetname.. " !", "police")
	forcing = true
	TriggerEvent("core:drawBar", 10000, "⌛ Installation du périphérique de piratage...")
	ESX.ShowNotification("~y~Le forçage de l'ATM vient de commencer !")
	RequestAnimDict("mini@repair")
	while (not HasAnimDictLoaded("mini@repair")) do
		Citizen.Wait(0)
	end
	TaskPlayAnim(PlayerPedId(), "mini@repair" ,"fixing_a_ped" ,8.0, -8.0, -1, 50, 0, false, false, false )
	Citizen.Wait(10000)
	ClearPedTasks(PlayerPedId())
	forcing = false
	TriggerEvent("mhacking:show")
	TriggerEvent("mhacking:start",7,35,mycb)
end)

function mycb(succes)
	if succes then
		TriggerEvent('mhacking:hide')
		TriggerServerEvent("robatm:succes")
		robbed = true
		Citizen.Wait(600000)
		robbed = false
	else
		TriggerEvent('mhacking:hide')
		ESX.ShowNotification("~r~Le forçage de l'ATM n'a pas fonctionné, recommencez plus-tard !")
		robbed = true
		Citizen.Wait(300000)
		robbed = false
	end
end

Citizen.CreateThread(function()
    while true do
		local isOnGoing = false
			if forcing then
            	isOnGoing = true
				DisableControlAction(0, 32, true)
				DisableControlAction(0, 34, true)
				DisableControlAction(0, 31, true)
				DisableControlAction(0, 30, true)
				DisableControlAction(0, 22, true)
				DisableControlAction(0, 44, true)
			end
		if isOnGoing then
			Citizen.Wait(0)
		else
			Citizen.Wait(500)
		end
    end
end)