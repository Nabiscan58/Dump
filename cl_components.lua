ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

-- RegisterNetEvent('components:useComponent')
-- AddEventHandler('components:useComponent', function(component, weapon, compID)
-- 	local ped = PlayerPedId()
-- 	local currentWeaponHash = GetSelectedPedWeapon(ped)

-- 	GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon), GetHashKey(compID))
-- end)

-- RegisterNetEvent('components:useClip')
-- AddEventHandler('components:useClip', function()
-- 	local ped = PlayerPedId()
-- 	local hash = nil

-- 	if IsPedArmed(ped, 4) then
-- 		hash = GetSelectedPedWeapon(ped)

-- 		if hash ~= nil then
-- 			AddAmmoToPed(ped, hash,25)
-- 			ESX.ShowNotification("Tu as utilisé un chargeur")
-- 		else
-- 			ESX.ShowNotification("Tu n'as pas d'armes en main !")
-- 		end
-- 	else
-- 		ESX.ShowNotification("Ce type de munitions ne convient pas !")
-- 	end
-- end)