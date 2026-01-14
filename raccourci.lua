INVENTORY.Raccourci = {}
INVENTORY.Raccourci.WeaponEkip = false
INVENTORY.Raccourci.LastWeapon = "WEAPON_PISTOL"
INVENTORY.Raccourci.cd = true
function INVENTORY.KeyRegister(Controls, ControlName, Description, Action)
	RegisterKeyMapping(string.format('%s', ControlName), Description, "keyboard", Controls)
	RegisterCommand(string.format('%s', ControlName), function(source, args)
		if (Action ~= nil) then
			Action();
		end
	end, false)
end

function INVENTORY.Raccourci.Cooldown()
    CreateThread(function()
        INVENTORY.Raccourci.cd = false
        Wait(800)
        INVENTORY.Raccourci.cd = true
    end)
end

local coolDown = false
INVENTORY.KeyRegister("TAB", "Inventaire", "Inventaire", function()
    print(coolDown)
    if not coolDown then
        coolDown = true
        if not INVENTORY.OpenVehicle() then
            INVENTORY.UI.Other.CurrentWeight = "0.0"
            INVENTORY.UI.Other.MaxWeight = "0.0"
            if not INVENTORY.Open then
                INVENTORY.OpenMenu()
            else
                INVENTORY.Close()
            end
        end
        Wait(300)
        coolDown = false
    end

end)


-- local odl = GetVehicleNumberPlateText
-- local function GetVehicleNumberPlateText(veh)
--     -- Supposons que 'plate_text' est le texte de la plaque que vous avez récupéré
--     local plate_text = odl(veh)  -- Simulant un texte de plaque avec un espace à la fin

--     -- Supprimez l'espace à la fin en utilisant la fonction 'string.match' avec un pattern
--     local cleaned_plate_text = string.match(plate_text, "^(.-)%s*$")

--     return cleaned_plate_text
-- end

function INVENTORY.GetVehicleLockNear()
    local veh, dst = Utils.GetClosestVehicle(GetEntityCoords(PlayerPedId()))

    if veh == -1 then
        return true
    end
    local lockStatus = GetVehicleDoorLockStatus(veh)

    if lockStatus ~= 1 then
        return true
    else
        return false
    end
end

function INVENTORY.OpenVehicle()
    local veh, dst = Utils.GetClosestVehicle(GetEntityCoords(PlayerPedId()))

    if veh == -1 then
        return false
    end
    local lockStatus = GetVehicleDoorLockStatus(veh)

    if lockStatus ~= 1 then
        return false
    end
    local plate = GetVehicleNumberPlateText(veh)
    local class = GetVehicleClass(veh)
    local weight = 50.0
    if ConfigShared.Trunk.TrunkClassWeights[class] then
        weight = ConfigShared.Trunk.TrunkClassWeights[class]
    end
    local modelId = GetEntityModel(veh)
    local hash = GetHashKey(veh)
    local displayName = GetDisplayNameFromVehicleModel(modelId) -- Obtient le nom d'affichage du modèle de véhicule

-- Maintenant que vous avez le nom d'affichage (nom de spawn), obtenez le hash du nom de spawn
    local spawnNameHash = GetHashKey(displayName)
-- Obtenez le nom de spawn du modèle du véhicule
    local vehicleName = GetDisplayNameFromVehicleModel(modelId)
    if ConfigShared.Trunk.TrunkIndividualWeights[spawnNameHash] then
        weight = ConfigShared.Trunk.TrunkIndividualWeights[spawnNameHash]
    end
    if spawnNameHash == 751804762 then
        INVENTORY.UI.Other.MaxWeight = 350
    else
        INVENTORY.UI.Other.MaxWeight = weight
    end
    local zizi = nil
    if veh and dst <= 3 then
        if not INVENTORY.InOpening and INVENTORY.InClosing then
            if not INVENTORY.Open then
                TriggerServerEvent("inventory:server:openVehicle", plate, true)
                zizi =  true 
            end
        else
            zizi =  false
            if INVENTORY.Open then
                TriggerServerEvent("inventory:server:openVehicle", plate, false)
                zizi =  false
            end
        end
      
    end
    while zizi == nil do Wait(500) print("nil") end 
    return zizi
end


RegisterNetEvent("inventory:client:openVehicle", function (inv, plate)
    INVENTORY.Other = inv
    INVENTORY.UI.Other.Info = plate
    print(INVENTORY.UI.Other.Info, plate)
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
    INVENTORY.IsVehicle = true
    INVENTORY.OpenMenu()
end)

RegisterNetEvent("inventory:client:openSociety", function (inv, society, weight)
    INVENTORY.Other = inv
    INVENTORY.UI.Other.Info = society
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
    INVENTORY.IsSociety = true
    INVENTORY.UI.Other.MaxWeight = weight
    INVENTORY.OpenMenu()
end)

RegisterNetEvent("inventory:client:OpenFouille", function (id, inv, weight)
    ExecuteCommand("me fouille la personne")
    INVENTORY.Other = inv
    INVENTORY.UI.Other.Info = id
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
    INVENTORY.IsPlayer = true
    INVENTORY.UI.Other.MaxWeight = weight
    INVENTORY.OpenMenu()
end)

RegisterNetEvent("inventory:client:openProperty", function (inv, property, weight)
    INVENTORY.Other = inv
    INVENTORY.UI.Other.Info = "Propriété n°"..property
    INVENTORY.UI.Other.CurrentWeight = INVENTORY.GetCurrentWeight(inv)
    INVENTORY.IsSociety = false
    INVENTORY.IsProperty = true
    INVENTORY.IsPlayer = false
    INVENTORY.UI.Other.MaxWeight = weight
    INVENTORY.OpenMenu()
end)

RegisterNetEvent("inventory:client:closeInventory", function ()
    INVENTORY.Close()
end)

function INVENTORY.GetInventory()
    ESX.PlayerData = ESX.GetPlayerData()
    INVENTORY.Player = {}
    INVENTORY.Player = ESX.PlayerData.inventory
    INVENTORY.GetPlayerCurrentWeight()
    INVENTORY.UI.Player.FilterData = {}
    for key, value in pairs(INVENTORY.Player) do
        if not ConfigShared.Filter[5].item[string.upper(value.name)] and not ESX.IsContribWeapon(string.upper(value.name)) then
            table.insert(INVENTORY.UI.Player.FilterData, value)
        end
    end
        INVENTORY.UI.Player.FilterSelected = 1
    INVENTORY.UI.Player.Filter = "Rechercher"
end

function HasRaccourci(i)
    local has = false
 
    for k, v in pairs(INVENTORY.Player) do 
        if INVENTORY.UI.Player.PinItem[i] ~= nil then 
            if INVENTORY.UI.Player.PinItem[i].name == v.name then 
                has = true
            end
        end        
    end
    if not has then 
        INVENTORY.UI.Player.PinItem[i] = nil
    end
    return has
end

INVENTORY.KeyRegister("1", "raccourci_é", "Raccourci 1", function()
    INVENTORY.Raccourci.UseRaccourci(1)
end)


INVENTORY.KeyRegister("2", "raccourci_'", "Raccourci 2", function()
    INVENTORY.Raccourci.UseRaccourci(2)
end)

INVENTORY.KeyRegister("3", "raccourci_&", "Raccourci 3", function()
    INVENTORY.Raccourci.UseRaccourci(3)
end)

INVENTORY.KeyRegister("4", "raccourci_()", "Raccourci 4", function()
    INVENTORY.Raccourci.UseRaccourci(4)
end)

INVENTORY.KeyRegister("5", "raccourci__", "Raccourci 5", function()
    INVENTORY.Raccourci.UseRaccourci(5)
end)

RegisterNetEvent("inventory:server:updateRaccourci", function (id, data)
    if id ~= nil then
        AddRaccourci(id, data)
    end
end)


local cooldownoutfit = false
function INVENTORY.Raccourci.UseRaccourci(key)
    if INVENTORY.Raccourci.cd == false then
        return
    end
    INVENTORY.GetInventory()
    local has = HasRaccourci(key)
    if not has then return end
    INVENTORY.Raccourci.Cooldown()
    -- if INVENTORY.UI.InteractItem.CountInput
    if INVENTORY.UI.Player.PinItem[key] ~= nil then 
        if INVENTORY.UI.Player.PinItem[key].count <= 0 then
            -- TriggerServerEvent("inventory:server:updateRaccourci", key, nil)
            AddRaccourci(key, nil)

            INVENTORY.UI.Player.PinItem[key] = nil
            return
        end
    end
    if INVENTORY.UI.Player.PinItem[key] == nil then
        return
    end
    local data = INVENTORY.UI.Player.PinItem[key]
    local isWeapon = false
    local isOutfit = false
    if data.name == "money" or data.name == "dirtymoney" then
        return
    end

    if data.name == "identitycard" then
        if INVENTORY.Permis.Open then
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.DataId = {}
        else
            INVENTORY.Permis.DataId = data.metadatas.data
            INVENTORY.Permis.Open = true
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.OpenPeche = false
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.Open do
                    INVENTORY.Permis.DrawId()
                    Wait(1)
                end
            end)

            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestDistance ~= -1 and closestDistance <= 3.0 then
              
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataId)
			else
				ESX.ShowNotification("~r~Aucun joueur proche !")
			end
        end
        return
    end
    
    if data.name == "permisems" then
        if lastDui ~= nil then
            DestroyDui(lastDui)
            lastDui = nil
        end
        if INVENTORY.Permis.EmsOpen then
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.EmsOpen = false

            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.DataId = {}
        else
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.EmsOpen = true
            INVENTORY.Permis.DataEms = data.metadatas.data
            if data.metadatas.data.mugshot then 
            -- S'assurer que 'data.name' est unique pour chaque DUI
                local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname

                -- Créer un nouveau TXD
                local txd = CreateRuntimeTxd(uniqueDictName)
                -- Créer un DUI et obtenir son handle
                local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                lastDui = dui
                local duiHandle = GetDuiHandle(dui)
                -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)

                -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                INVENTORY.Permis.DataEms.textureDict = uniqueDictName
                INVENTORY.Permis.DataEms.textureName = uniqueTextureName
                -- DestroyDui(dui)
            end
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
            
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataEms)
            else
                ESX.ShowNotification("~r~Aucun joueur proche !")
            end
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.EmsOpen do
                    INVENTORY.Permis.DrawBadgeEms()
                    Wait(1)
                end
            end)
        end
        
        return
    end

    if data.name == "permissheriff" then
        if lastDui ~= nil then
            DestroyDui(lastDui)
            lastDui = nil
        end
        if INVENTORY.Permis.BcsoOpen then
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.EmsOpen = false

            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.DataId = {}
        else
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.BcsoOpen = true
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.DataBcso = data.metadatas.data
            if data.metadatas.data.mugshot then 
            -- S'assurer que 'data.name' est unique pour chaque DUI
                local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname

                -- Créer un nouveau TXD
                local txd = CreateRuntimeTxd(uniqueDictName)
                -- Créer un DUI et obtenir son handle
                local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                lastDui = dui
                local duiHandle = GetDuiHandle(dui)
                -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)

                -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                INVENTORY.Permis.DataBcso.textureDict = uniqueDictName
                INVENTORY.Permis.DataBcso.textureName = uniqueTextureName
                -- DestroyDui(dui)
            end
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
            
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataBcso)
            else
                ESX.ShowNotification("~r~Aucun joueur proche !")
            end
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.BcsoOpen do
                    INVENTORY.Permis.DrawBadgeSheriff()
                    Wait(1)
                end
            end)
        end
        
        return
    end

    if data.name == "permispolice" then
        if lastDui ~= nil then
            DestroyDui(lastDui)
            lastDui = nil
        end
        if INVENTORY.Permis.LspdOpen then
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.DataId = {}
        else
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.LspdOpen = true
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.DataLspd = data.metadatas.data
            if data.metadatas.data.mugshot then 
            -- S'assurer que 'data.name' est unique pour chaque DUI
                local uniqueDictName = 'dui_dict_' .. data.name..data.metadatas.data.firstname
                local uniqueTextureName = 'dui_tex_' .. data.name..data.metadatas.data.firstname

                -- Créer un nouveau TXD
                local txd = CreateRuntimeTxd(uniqueDictName)
                -- Créer un DUI et obtenir son handle
                local dui = CreateDui(data.metadatas.data.mugshot, 1920, 1080)
                lastDui = dui
                local duiHandle = GetDuiHandle(dui)
                -- S'assurer que 'CreateRuntimeTextureFromDuiHandle' est appelé avec les bons paramètres
                CreateRuntimeTextureFromDuiHandle(txd, uniqueTextureName, duiHandle)

                -- Enregistrer les noms dans votre structure pour une utilisation ultérieure
                INVENTORY.Permis.DataLspd.textureDict = uniqueDictName
                INVENTORY.Permis.DataLspd.textureName = uniqueTextureName
                -- DestroyDui(dui)
            end
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestDistance ~= -1 and closestDistance <= 3.0 then
            
                TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataLspd)
            else
                ESX.ShowNotification("~r~Aucun joueur proche !")
            end
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.LspdOpen do
                    INVENTORY.Permis.DrawBadgeLSPD()
                    Wait(1)
                end
            end)
        end
        
        return
    end

    if data.name == "permisweapon" then
        if INVENTORY.Permis.OpenWeapon then
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.DataWeapon = {}
        else
            INVENTORY.Permis.DataWeapon = data.metadatas.data
            INVENTORY.Permis.OpenWeapon = true
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.Open = false
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestDistance ~= -1 and closestDistance <= 3.0 then
              
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataWeapon)
			else
				ESX.ShowNotification("~r~Aucun joueur proche !")
			end
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.OpenWeapon do
                    INVENTORY.Permis.DrawWeapon()
                    Wait(1)
                end
            end)
        end
        return
    end

    if data.name == "permischasse" then
        if INVENTORY.Permis.OpenChasse then
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.DataWeapon = {}
        else
            INVENTORY.Permis.DataWeapon = data.metadatas.data
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenChasse = true
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.BcsoOpen = false

            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.OpenChasse do
                    INVENTORY.Permis.DrawChasse()
                    Wait(1)
                end
            end)
        end
        return
    end 

    if data.name == "permispeche" then
        if INVENTORY.Permis.OpenPeche then
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.OpenPeche = false
            INVENTORY.Permis.DataWeapon = {}
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.BcsoOpen = false
        else
            INVENTORY.Permis.DataWeapon = data.metadatas.data
            INVENTORY.Permis.OpenWeapon = false
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.OpenChasse = false
            INVENTORY.Permis.OpenPeche = true
            INVENTORY.Permis.LspdOpen = false
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.BcsoOpen = false

            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.OpenPeche do
                    INVENTORY.Permis.DrawPeche()
                    Wait(1)
                end
            end)
        end
        return
    end 

    if data.name == "permisauto" then
        if INVENTORY.Permis.OpenPermis then
            INVENTORY.Permis.OpenPermis = false
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.EmsOpen = false
            INVENTORY.Permis.DataPermis = {}
        else
            INVENTORY.Permis.DataPermis = data.metadatas.data
            INVENTORY.Permis.OpenPermis = true
            INVENTORY.Permis.Open = false
            INVENTORY.Permis.BcsoOpen = false
            INVENTORY.Permis.EmsOpen = false
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if closestDistance ~= -1 and closestDistance <= 3.0 then
              
				TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(closestPlayer), data.name, INVENTORY.Permis.DataPermis)
			else
				ESX.ShowNotification("~r~Aucun joueur proche !")
			end
            CreateThread(function ()
                while not INVENTORY.Open and INVENTORY.Permis.OpenPermis do
                    INVENTORY.Permis.DrawPermis()
                    Wait(1)
                end
            end)

        end
        return
    end
    if ConfigShared.Filter[3].item[(data.name)] then
        isOutfit = true
    end
    if ConfigShared.Filter[5].item[string.upper(data.name)] then
        isWeapon = true
    end

    if isWeapon then
        if exports["rg_core"]:InZoneSafe() then
            return
        end
        local lastdata = Utils.TableCopy(data)

        print("Utilisation du raccourci arme :", data.name)
        print(data.metadatas.ammo)

        if INVENTORY.Raccourci.WeaponEkip and INVENTORY.Raccourci.LastWeapon == data.name then
            INVENTORY.Raccourci.WeaponEkip = false
            INVENTORY.Raccourci.LastWeapon = data.name
            RemoveAllPedWeapons(PlayerPedId(), 1)
            SetCurrentPedWeapon(PlayerPedId(), 'WEAPON_UNARMED', true)
            INVENTORY.Weapon.Selected = {}
        elseif not INVENTORY.Raccourci.WeaponEkip and INVENTORY.Raccourci.LastWeapon ~= data.name then
            INVENTORY.Raccourci.WeaponEkip = true
            INVENTORY.Raccourci.LastWeapon = data.name
            GiveWeaponToPed(PlayerPedId(), GetHashKey(data.name), tonumber(data.count), data.metadatas.ammo, true)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey(data.name), true)
            
            if data.metadatas.ammo ~= nil then
                local playerPed = PlayerPedId() -- Récupère l'ID du joueur
                local weaponHash = GetHashKey(data.name) -- Récupère le hash de l'arme
                local totalAmmo = data.metadatas.ammo -- Munitions totales que tu veux donner
                local maxAmmoInClip = GetMaxAmmoInClip(playerPed, weaponHash, 1) -- Obtiens la capacité du chargeur
                local ammoInClip = math.min(totalAmmo, maxAmmoInClip) -- Si les munitions totales sont inférieures à la capacité du chargeur, on remplit au max.
                SetAmmoInClip(playerPed, weaponHash, ammoInClip) -- Remplit le chargeur
                SetPedAmmo(playerPed, weaponHash, totalAmmo) -- Définit les munitions de réserve
            else
                data.metadatas.ammo = 30 -- Définit une valeur par défaut si aucune munition n'est spécifiée
                local playerPed = PlayerPedId()
                local weaponHash = GetHashKey(data.name)
                SetPedAmmo(playerPed, weaponHash, 30)
                SetAmmoInClip(playerPed, weaponHash, 30)
                TriggerServerEvent("inventory:server:setDataWeapon", lastdata, data.metadatas) -- Met à jour les données côté serveur
            end

            INVENTORY.Weapon.Selected = data
            INVENTORY.Raccourci.SetComponent(data)
            

        elseif not INVENTORY.Raccourci.WeaponEkip and INVENTORY.Raccourci.LastWeapon == data.name then
            INVENTORY.Raccourci.WeaponEkip = true
            INVENTORY.Raccourci.LastWeapon = data.name
            GiveWeaponToPed(PlayerPedId(), GetHashKey(data.name), tonumber(data.count), data.metadatas.ammo, true)
            SetCurrentPedWeapon(PlayerPedId(), data.name, true)
            if data.metadatas.ammo ~= nil then
                local playerPed = PlayerPedId() -- Récupère l'ID du joueur
                local weaponHash = GetHashKey(data.name) -- Récupère le hash de l'arme
                local totalAmmo = data.metadatas.ammo -- Munitions totales que tu veux donner
                local maxAmmoInClip = GetMaxAmmoInClip(playerPed, weaponHash, 1) -- Obtiens la capacité du chargeur
                local ammoInClip = math.min(totalAmmo, maxAmmoInClip) -- Si les munitions totales sont inférieures à la capacité du chargeur, on remplit au max.
                SetAmmoInClip(playerPed, weaponHash, ammoInClip) -- Remplit le chargeur
                SetPedAmmo(playerPed, weaponHash, totalAmmo) -- Définit les munitions de réserve
            else
                data.metadatas.ammo = 30 -- Définit une valeur par défaut si aucune munition n'est spécifiée
                local playerPed = PlayerPedId()
                local weaponHash = GetHashKey(data.name)
                SetPedAmmo(playerPed, weaponHash, 30)
                SetAmmoInClip(playerPed, weaponHash, 30)
                TriggerServerEvent("inventory:server:setDataWeapon", lastdata, data.metadatas) -- Met à jour les données côté serveur
            end
            INVENTORY.Weapon.Selected = data
            INVENTORY.Raccourci.SetComponent(data)
        elseif INVENTORY.Raccourci.WeaponEkip and INVENTORY.Raccourci.LastWeapon ~= data.name then
            INVENTORY.Raccourci.WeaponEkip = true
            INVENTORY.Raccourci.LastWeapon = data.name
            GiveWeaponToPed(PlayerPedId(), GetHashKey(data.name), tonumber(data.count), data.metadatas.ammo, true)
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey(data.name), true)
            
            if data.metadatas.ammo ~= nil then
                local playerPed = PlayerPedId() -- Récupère l'ID du joueur
                local weaponHash = GetHashKey(data.name) -- Récupère le hash de l'arme
                local totalAmmo = data.metadatas.ammo -- Munitions totales que tu veux donner
                local maxAmmoInClip = GetMaxAmmoInClip(playerPed, weaponHash, 1) -- Obtiens la capacité du chargeur
                local ammoInClip = math.min(totalAmmo, maxAmmoInClip) -- Si les munitions totales sont inférieures à la capacité du chargeur, on remplit au max.
                SetAmmoInClip(playerPed, weaponHash, ammoInClip) -- Remplit le chargeur
                SetPedAmmo(playerPed, weaponHash, totalAmmo) -- Définit les munitions de réserve
            else
                data.metadatas.ammo = 30 -- Définit une valeur par défaut si aucune munition n'est spécifiée
                local playerPed = PlayerPedId()
                local weaponHash = GetHashKey(data.name)
                SetPedAmmo(playerPed, weaponHash, 30)
                SetAmmoInClip(playerPed, weaponHash, 30)
                TriggerServerEvent("inventory:server:setDataWeapon", lastdata, data.metadatas) -- Met à jour les données côté serveur
            end
            INVENTORY.Weapon.Selected = data
            INVENTORY.Raccourci.SetComponent(data)
            

            -- for key, value in pairs(data.components) do
            --     local componentHash = ESX.GetWeaponContiComponent(data.name, value).hash
            --     GiveWeaponComponentToPed(PlayerPedId(), data.name, componentHash)
            -- end
        end
        return
    elseif isOutfit then
        if not cooldownoutfit then
            cooldownoutfit = true
            if data.name ~= "outfit" then
                for k, v in pairs(ConfigShared.Outfit) do
                    if v.itemName == data.name then
                        if not v.equip then
                            v.equip = true
                            for type, value in pairs(data.metadatas.data) do
                                INVENTORY.ChangeClothOutfit(type, value)
                            end
                        else
                            for type, value in pairs(data.metadatas.data) do
                                INVENTORY.ChangeClothOutfit(type, value)
                            end
                        end
                    end
                end
                if INVENTORY.UI.Outfit.outfitEkip then
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        local datas = {}
                        for key, value in pairs(skin) do
                            for ke, va in pairs(INVENTORY.UI.Outfit.outfitEkipData.data) do
                                if key == ke then
                                    datas[key] = value
                                end
                            end
                        end
                        local metadatas = INVENTORY.UI.Outfit.outfitEkipData
                        metadatas.data = datas
                        TriggerServerEvent('inventory:server:changedatainventory', "outfit", INVENTORY.UI.Outfit.outfitEkipData, metadatas)
                        TriggerServerEvent("inventaire:server:trucbidule", data.name, data.metadatas)
                    end)
                end
            else
                INVENTORY.Raccourci.PlayAnim("outfit")
                INVENTORY.UI.Outfit.outfitEkip = true
                INVENTORY.UI.Outfit.outfitEkipData = data.metadatas
                TriggerServerEvent('inventory:server:updateOutfit', data.metadatas)

                Wait(5000)
                for type, value in pairs(data.metadatas.data) do
                    INVENTORY.ChangeClothOutfit(type, value)
                end
                INVENTORY.UI.Outfit.outfitEkip = true
            end
            INVENTORY.SyncOufit()

            TriggerEvent('skinchanger:getSkin', function(skin)
                TriggerServerEvent('esx_skin:save', skin)
            end)
            Wait(2000)
            cooldownoutfit = false
        end
        return
    else
        if data.name ~= "identitycard" and data.name ~= "permisauto" and data.name ~= "permisweapon"  then
            TriggerServerEvent("inventaire:server:useItem", data.name, 1, data.metadatas)
                
            if data.count == 0 then
                AddRaccourci(key, nil)
                return
            end
            
            data.count = data.count
            local dataSend = {
                name = INVENTORY.UI.Player.PinItem[key].name,
                label = INVENTORY.UI.Player.PinItem[key].label,
                weight = INVENTORY.UI.Player.PinItem[key].weight,
                metadatas = INVENTORY.UI.Player.PinItem[key].metadatas
            }
          
            AddRaccourci(key, dataSend)
            return
        end
    end
end

function INVENTORY.Raccourci.PlayAnim(type)
    CreateThread(function ()
        for key, value in pairs(ConfigShared.Outfit) do
            local type2 = 'pants'
            if type == 'outfit' then
                type2 = "pants"
            end
            if type2 == value.itemName then
                Utils.LoadAnimDict(value.anim.dict)
                TaskPlayAnim(PlayerPedId(), value.anim.dict, value.anim.anim, 8.0, -8.0, -1, 51, 0, 0, 0, 0)
                if type == "outfit" then
                    Wait(5000)
                else
                    Wait(1300)
                end
                ClearPedTasks(PlayerPedId())
            end
        end
    end)
end

function INVENTORY.Raccourci.SetComponent(data)
    if data.metadatas.component ~= nil and next(data.metadatas.component) then 
        for components, value in pairs(data.metadatas.component) do
            for _, skin in pairs(ConfigShared.AccessoriesWeapon) do
                if components == skin.component then 
                    for i,j in pairs(skin.weapons) do
                        if data.name == j.name then
                            GiveWeaponComponentToPed(PlayerPedId(), GetHashKey(data.name), GetHashKey(j.componentID))
                        end
                    end
                end
            end
        end
    end
end
local db = nil

Citizen.CreateThread(function()
    Citizen.Wait(15 * 1000)
    db = rockdb:new()
    INVENTORY.UI.Player.PinItem = db:GetTable("raccourci")
    if INVENTORY.UI.Player.PinItem == nil then
        INVENTORY.UI.Player.PinItem = {}
    end
end)

function AddRaccourci(id, data)
    if data ~= nil then 
        if INVENTORY.UI.Player.PinItem == nil then
            INVENTORY.UI.Player.PinItem = {}
        end
        if INVENTORY.UI.Player.PinItem[id] == nil then
            INVENTORY.UI.Player.PinItem[id] = {}
            INVENTORY.UI.Player.PinItem[id] = data
            if INVENTORY.UI.Player.PinItem[id].count == nil then 
                INVENTORY.UI.Player.PinItem[id].count = 1
            end
        else
            INVENTORY.UI.Player.PinItem[id] = data
            if INVENTORY.UI.Player.PinItem[id].count == nil then 
                INVENTORY.UI.Player.PinItem[id].count = 1
            end
        end
        SaveRaccourci()
    end
end


function SaveRaccourci()

    db:SaveTable("raccourci", INVENTORY.UI.Player.PinItem)
end


-- RegisterNetEvent("inventory:client:loadraccourci", function (data)
--     INVENTORY.UI.Player.PinItem = data
-- end)

RegisterNetEvent("inventaire:useoutfit", function (data)
    if INVENTORY.Raccourci.cd == false then
        return
    end
    INVENTORY.Raccourci.Cooldown()
    if not INVENTORY.UI.Outfit.outfitEkip then 
        if data.name ~= "outfit" then
            for k, v in pairs(ConfigShared.Outfit) do
                if v.itemName == data.name then
                    INVENTORY.Raccourci.PlayAnim(v.itemName)
                    Wait(1300)
                    if not v.equip then
                        v.equip = true
                        for type, value in pairs(data.metadatas.data) do
                            INVENTORY.ChangeClothOutfit(type, value)
                        end
                    else
                        v.equip = false
                        local playerPed = PlayerPedId() -- Obtient l'ID du pédé du joueur local
                        local male = false -- Définit une variable 'male' à false par défaut
                        
                        if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
                            male = true -- Si le modèle est celui du personnage masculin freemode, définit 'male' à true
                        end
                        if male  then
                            if v.skin ~= nil then
                                for key, value in pairs(v.skin.male) do
                                    INVENTORY.ChangeCloth(key, value)
                                end

                            else
                                INVENTORY.ChangeCloth(v.name, v.male.defaultValue)
                                INVENTORY.ChangeCloth(v.itemVariation, v.male.defaultValueVariation)
                            end

                        else
                            if v.skin ~= nil then
                                for key, value in pairs(v.skin.female) do
                                    INVENTORY.ChangeCloth(key, value)
                                end
                            else

                                INVENTORY.ChangeCloth(v.name, v.female.defaultValue)
                                INVENTORY.ChangeCloth(v.itemVariation, v.female.defaultValueVariation)
                            end
                        end
                    end
                end
            end
            if INVENTORY.UI.Outfit.outfitEkip then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    local datas = {}
                    for key, value in pairs(skin) do
                        for ke, va in pairs(INVENTORY.UI.Outfit.outfitEkipData.data) do
                            if key == ke then
                                datas[key] = value
                            end
                        end
                    end
                    local metadatas = INVENTORY.UI.Outfit.outfitEkipData
                    metadatas.data = datas
                    TriggerServerEvent('inventory:server:changedatainventory', "outfit", INVENTORY.UI.Outfit.outfitEkipData, metadatas)
                    TriggerServerEvent("inventaire:server:trucbidule", data.name, data.metadatas)
                end)
            end
        else
            INVENTORY.Raccourci.PlayAnim("outfit")
            INVENTORY.UI.Outfit.outfitEkip = true
            INVENTORY.UI.Outfit.outfitEkipData = data.metadatas
            TriggerServerEvent('inventory:server:updateOutfit', data.metadatas)
            Wait(5000)
            for type, value in pairs(data.metadatas.data) do
                INVENTORY.ChangeClothOutfit(type, value)
            end
            INVENTORY.UI.Outfit.outfitEkip = true
        end
    else
        local nibard = false
        for k, v in pairs(ConfigShared.Outfit) do
            if v.itemName == data.name then
                nibard = true
                INVENTORY.Raccourci.PlayAnim(v.itemName)
                Wait(1300)
                local playerPed = PlayerPedId() -- Obtient l'ID du pédé du joueur local
                local male = false -- Définit une variable 'male' à false par défaut
                
                if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
                    male = true -- Si le modèle est celui du personnage masculin freemode, définit 'male' à true
                end
                if male then
                    if v.skin ~= nil then
                        for key, value in pairs(v.skin.male) do
                            INVENTORY.ChangeCloth(key, value)
                        end
        
                    else
                        INVENTORY.ChangeCloth(v.name, v.male.defaultValue)
                        INVENTORY.ChangeCloth(v.itemVariation, v.male.defaultValueVariation)
                    end
        
                else
                    if v.skin ~= nil then
                        for key, value in pairs(v.skin.female) do
                            INVENTORY.ChangeCloth(key, value)
                        end
                    else
        
                        INVENTORY.ChangeCloth(v.name, v.female.defaultValue)
                        INVENTORY.ChangeCloth(v.itemVariation, v.female.defaultValueVariation)
                    end
                end
            end
        end
       if not nibard then
            Wait(5000)

            INVENTORY.UI.Outfit.outfitEkip = false
            INVENTORY.Raccourci.PlayAnim("pants")
            for k, v in pairs(ConfigShared.Outfit) do
                local male = false -- Définit une variable 'male' à false par défaut
                
                if GetEntityModel(playerPed) == GetHashKey('mp_m_freemode_01') then
                    male = true -- Si le modèle est celui du personnage masculin freemode, définit 'male' à true
                end
                if male then
                    if v.skin ~= nil then
                        for key, value in pairs(v.skin.male) do
                            INVENTORY.ChangeClothOutfit(key, value)
                        end

                    else
                        INVENTORY.ChangeClothOutfit(v.name, v.male.defaultValue)
                        INVENTORY.ChangeClothOutfit(v.itemVariation, v.male.defaultValueVariation)
                    end

                else
                    if v.skin ~= nil then
                        for key, value in pairs(v.skin.female) do
                            INVENTORY.ChangeClothOutfit(key, value)
                        end
                    else

                        INVENTORY.ChangeClothOutfit(v.name, v.female.defaultValue)
                        INVENTORY.ChangeClothOutfit(v.itemVariation, v.female.defaultValueVariation)
                    end
                end
            end
       end
    end
    -- INVENTORY.SyncOufit()

    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
    Wait(2000)
end)

RegisterNetEvent("inventory:client:syncRaccourci", function (key, data)
    INVENTORY.UI.Player.PinItem[key] = data
end)