
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
end)

local knockedOut = false
local wait = 15
local count = 60

Citizen.CreateThread(function()
	while true do
		local isinfight = false
		local isout = false
		local myPed = PlayerPedId()
		if IsPedInMeleeCombat(myPed) then
			isinfight = true
			if GetEntityHealth(myPed) < 115 then
				SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
				ESX.ShowNotification("~r~Tu es en rétablissement !")
				wait = 15
				knockedOut = true
				SetEntityHealth(myPed, 116)
			end
		end
		if knockedOut == true then
			isout = true
			DisablePlayerFiring(PlayerId(), true)
			SetPedToRagdoll(myPed, 1000, 1000, 0, 0, 0, 0)
			ResetPedRagdollTimer(myPed)
			
			if wait >= 0 then
				count = count - 1
				if count == 0 then
					count = 60
					wait = wait - 1
					SetEntityHealth(myPed, GetEntityHealth(myPed)+4)
				end
			else
				knockedOut = false
			end
		end
		if isinfight or isout then
			Citizen.Wait(0)
		else
			Citizen.Wait(500)
		end
	end
end)

function isKO()
	return knockedOut
end

exports("isKO", function ()
	return isKO()
end)