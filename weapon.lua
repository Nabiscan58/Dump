
local isReloading = false
local lastAmmoCount = 0
INVENTORY.Weapon = {}
INVENTORY.Weapon.Selected = {}
CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local isArmed = false
        
        if IsPedArmed(ped, 4) or GetSelectedPedWeapon(ped) == GetHashKey('WEAPON_PETROLCAN') and (INVENTORY.Weapon.Selected ~= nil or INVENTORY.ActivateInv) then -- Vérifie si le joueur a une arme à feu
            isArmed = true
            local weapon = GetSelectedPedWeapon(ped) 
            local ammoCount = GetAmmoInPedWeapon(ped, weapon) 
            if ammoCount ~= lastAmmoCount then
                if INVENTORY.Weapon.Selected.metadatas ~= nil and INVENTORY.Weapon.Selected.metadatas.ammo ~= nil then 
                    TriggerServerEvent("inventory:server:newAmmo", INVENTORY.Weapon.Selected.name, INVENTORY.Weapon.Selected.metadatas, ammoCount)
                    INVENTORY.Weapon.Selected.metadatas.ammo = ammoCount
                end
                
                if GetSelectedPedWeapon(ped) == GetHashKey('WEAPON_PETROLCAN') then 
                    if ammoCount <= 0 then
                        if INVENTORY.ActivateInv then 
                            TriggerServerEvent("inventaire:server:trucbidule", "WEAPON_PETROLCAN", INVENTORY.Weapon.Selected.metadatas)
                        end
                    end
                end
            end
            
            lastAmmoCount = ammoCount
        else
            isReloading = false
            lastAmmoCount = 0
        end
        if isArmed then
            Wait(200)
        else
            Wait(1000)
        end
    end
end)



RegisterNetEvent('components:useClip')
AddEventHandler('components:useClip', function(type)
	local ped = PlayerPedId()
	local hash = nil
	if IsPedArmed(ped, 4) then
		hash = GetSelectedPedWeapon(ped)
        local good = false
        if type == "clip" then 
            good = true
        end
        if type ~= "clip" then 
            for key, value in pairs(ConfigShared.Clip[type]) do
                if GetHashKey(key) == hash then
                    good = true
                end
            end
        end
        if good then
            if hash ~= nil then
                local ammo =  GetAmmoInPedWeapon(ped, hash)
                AddAmmoToPed(ped, hash, 25)
                -- if INVENTORY.ActivateInv then 
                TriggerServerEvent("inventory:server:newAmmo", INVENTORY.Weapon.Selected.name, INVENTORY.Weapon.Selected.metadatas, ammo+25)
                INVENTORY.Weapon.Selected.metadatas.ammo = ammo + 25
                -- end
                ESX.ShowNotification("Tu as utilisé un chargeur")
                TriggerServerEvent("components:server:remove", type)
            else
                ESX.ShowNotification("Tu n'as pas d'armes en main !")
            end
        else
            ESX.ShowNotification("Pas le bon chargeur !")
        end
	else
		ESX.ShowNotification("Ce type de munitions ne convient pas !")
	end
end)


RegisterNetEvent('components:useComponent')
AddEventHandler('components:useComponent', function(component, weapon, compID)
    local ped = PlayerPedId()
	local hash = nil
	local currentWeaponHash = GetSelectedPedWeapon(ped)
    if IsPedArmed(ped, 4) then
		hash = GetSelectedPedWeapon(ped)
        if GetHashKey(weapon) == hash then
            if hash ~= nil then
                print(json.encode(INVENTORY.Weapon.Selected.metadatas.component))
                if INVENTORY.Weapon.Selected.metadatas.component == nil then 
                    TriggerServerEvent("inventory:server:newComponent", INVENTORY.Weapon.Selected.name, INVENTORY.Weapon.Selected.metadatas, component)

                    INVENTORY.Weapon.Selected.metadatas.component = {}
                    INVENTORY.Weapon.Selected.metadatas.component[component] = true
                    for key, value in pairs(INVENTORY.UI.Player.PinItem) do
                        if value.metadatas then 
                            if value.metadatas.id and value.metadatas.id == INVENTORY.Weapon.Selected.metadatas.id then 
                                INVENTORY.UI.Player.PinItem[key].metadatas = INVENTORY.Weapon.Selected.metadatas
                                SaveRaccourci()
                            end
                        end
                    end
                    GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon), GetHashKey(compID))

                else
                    if INVENTORY.Weapon.Selected.metadatas.component[component] then
                        TriggerServerEvent("inventory:server:newComponent", INVENTORY.Weapon.Selected.name, INVENTORY.Weapon.Selected.metadatas, component, true)

                        INVENTORY.Weapon.Selected.metadatas.component[component] = nil
                        for key, value in pairs(INVENTORY.UI.Player.PinItem) do
                            if value.metadatas then 
                                if value.metadatas.id and value.metadatas.id == INVENTORY.Weapon.Selected.metadatas.id then 
                                    INVENTORY.UI.Player.PinItem[key].metadatas = INVENTORY.Weapon.Selected.metadatas
                                    SaveRaccourci()
                                end
                            end
                        end
                        RemoveWeaponComponentFromPed(PlayerPedId(), GetHashKey(weapon), GetHashKey(compID))
                    else
                        TriggerServerEvent("inventory:server:newComponent", INVENTORY.Weapon.Selected.name, INVENTORY.Weapon.Selected.metadatas, component)

                        INVENTORY.Weapon.Selected.metadatas.component[component] = true
                        for key, value in pairs(INVENTORY.UI.Player.PinItem) do
                            if value.metadatas then 
                                if value.metadatas.id and value.metadatas.id == INVENTORY.Weapon.Selected.metadatas.id then 
                                    INVENTORY.UI.Player.PinItem[key].metadatas = INVENTORY.Weapon.Selected.metadatas
                                    SaveRaccourci()
                                end
                            end
                        end
                        GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon), GetHashKey(compID))
                    end
                end
            else
                ESX.ShowNotification("Tu n'as pas d'armes en main !")
            end
        end
	else
		ESX.ShowNotification("Ce type de d'accessoire ne fonctionne pas ne convient pas !")
	end
	-- GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(weapon), GetHashKey(compID))
end)


exports("getCurrentWeapon", function ()
    return INVENTORY.Weapon.Selected
end)