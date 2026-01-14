ADMIN_GANG_MENU = {
    IsOpen = false,
    Cache = {
        gangs = {},
        selectedGang = nil
    },
    PreviewVehicle = nil,
    CurrentPreviewModel = nil,
    IsLoadingModel = false
}

function ADMIN_GANG_MENU.Open()
    if ADMIN_GANG_MENU.IsOpen then
        ADMIN_GANG_MENU.Close()
        return
    end

    ADMIN_GANG_MENU.Cache.gangs = Utils.TriggerServerCallback('gangs:admin:getAllGangs')
    ADMIN_GANG_MENU.IsOpen = true

    RMenu.Add('gangAdmin', 'main', RageUI.CreateMenu("Gangs", "Gérer tous les gangs"))
    RMenu.Add('gangAdmin', 'edit',
        RageUI.CreateSubMenu(RMenu:Get('gangAdmin', 'main'), "Éditer le Gang", "Éditer les détails du gang"))
    RMenu.Add('gangAdmin', 'positions',
        RageUI.CreateSubMenu(RMenu:Get('gangAdmin', 'edit'), "Positions du Gang", "Éditer les positions du gang"))
    RMenu.Add('gangAdmin', 'configs',
        RageUI.CreateSubMenu(RMenu:Get('gangAdmin', 'edit'), "Config du Gang", "Éditer les configurations du gang"))

    RMenu.Add('gangAdmin', 'armory',
        RageUI.CreateSubMenu(RMenu:Get('gangAdmin', 'configs'), "Config Armurerie", "Configurer l'armurerie du gang"))
    RMenu.Add('gangAdmin', 'armory_selected',
        RageUI.CreateSubMenu(RMenu:Get('gangAdmin', 'armory'), "Armes Sélectionnées", "Gérer les armes sélectionnées"))

    for categoryKey, category in pairs(Config.WeaponCategories) do
        RMenu.Add('gangAdmin', 'armory_' .. categoryKey,
            RageUI.CreateSubMenu(RMenu:Get('gangAdmin', 'armory'), category.name, "Configurer " .. category.name:lower()))
    end

    RMenu:Get('gangAdmin', 'main').Closed = function()
        ADMIN_GANG_MENU.Close()
    end

    for name, menu in pairs(RMenu['gangAdmin']) do
        RMenu:Get('gangAdmin', name):SetRectangleBanner(255, 220, 0, 140)
    end

    -- Créer un véhicule d'aperçu (caché initialement)
    local model = GetHashKey("adder")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    ADMIN_GANG_MENU.PreviewVehicle = CreateVehicle(model, 0.0, 0.0, 0.0, 0.0, false, false)
    SetEntityVisible(ADMIN_GANG_MENU.PreviewVehicle, false, false)
    SetEntityCollision(ADMIN_GANG_MENU.PreviewVehicle, false, false)

    RageUI.Visible(RMenu:Get('gangAdmin', 'main'), true)

    local membersCount = {}
    Citizen.CreateThread(function()
        for _, gang in pairs(ADMIN_GANG_MENU.Cache.gangs) do
            mem = Utils.TriggerServerCallback('gangs:members:getAllMembers', gang.id)

            for k, v in pairs(mem) do
                if not membersCount[gang.id] then membersCount[gang.id] = 0 end
                membersCount[gang.id] = membersCount[gang.id] + 1
            end
            Citizen.Wait(100)
        end
    end)

    Citizen.CreateThread(function()
        while ADMIN_GANG_MENU.IsOpen do
            RageUI.IsVisible(RMenu:Get('gangAdmin', 'main'), true, true, true, function()
                RageUI.Separator(" ~r~Gangs Existants~s~ ")

                -- Liste de tous les gangs
                for _, gang in pairs(ADMIN_GANG_MENU.Cache.gangs) do
                    RageUI.ButtonWithStyle(
                        gang.name,
                        string.format("Niveau : %d | Membres : %d | Leader : %s",
                            gang.level, membersCount[gang.id] or 0, gang.leader), -- Pourrait ajouter un callback pour le compte des membres
                        { RightLabel = "»" },
                        true,
                        function(_, _, Selected)
                            if Selected then
                                ADMIN_GANG_MENU.Cache.selectedGang = gang
                            end
                        end,
                        RMenu:Get('gangAdmin', 'edit')
                    )
                end
            end)

            -- Menu Éditer le Gang
            RageUI.IsVisible(RMenu:Get('gangAdmin', 'edit'), true, true, true, function()
                local gang = ADMIN_GANG_MENU.Cache.selectedGang
                if gang then
                    -- Informations de base
                    RageUI.ButtonWithStyle(
                        "Nom du Gang",
                        gang.name,
                        { RightLabel = "»" },
                        true,
                        function(_, _, Selected)
                            if Selected then
                                local newName = KeyboardInput("Entrez le nouveau nom du gang", gang.name, 30)
                                if newName then
                                    if Utils.TriggerServerCallback('gangs:admin:updateGangName', gang.id, newName) then
                                        gang.name = newName
                                        Notify('success', 'Nom du gang mis à jour')
                                    end
                                end
                            end
                        end
                    )

                    RageUI.ButtonWithStyle(
                        "Niveau du Gang",
                        "Niveau Actuel : " .. gang.level,
                        { RightLabel = "»" },
                        true,
                        function(_, _, Selected)
                            if Selected then
                                local newLevel = tonumber(KeyboardInput("Entrez le nouveau niveau du gang",
                                    tostring(gang.level), 3))
                                if newLevel then
                                    if Utils.TriggerServerCallback('gangs:admin:updateGangLevel', gang.id, newLevel) then
                                        gang.level = newLevel
                                        Notify('success', 'Niveau du gang mis à jour')
                                    end
                                end
                            end
                        end
                    )

                    -- Sous-menus
                    RageUI.ButtonWithStyle(
                        "Gérer les Positions",
                        "Éditer les points de localisation du gang",
                        { RightLabel = "»" },
                        true,
                        function() end,
                        RMenu:Get('gangAdmin', 'positions')
                    )

                    RageUI.ButtonWithStyle(
                        "Gérer les Configurations",
                        "Éditer les configurations et couleurs du gang",
                        { RightLabel = "»" },
                        true,
                        function() end,
                        RMenu:Get('gangAdmin', 'configs')
                    )

                    RageUI.Separator(" ~r~Zone de Danger~s~ ")

                    RageUI.ButtonWithStyle(
                        "Supprimer le Gang",
                        "~r~Supprimer définitivement ce gang",
                        { RightLabel = "~r~SUPPRIMER" },
                        true,
                        function(_, _, Selected)
                            if Selected then
                                local confirm = KeyboardInput("Tapez 'CONFIRM' pour supprimer", "", 7)
                                if confirm == "CONFIRM" then
                                    if Utils.TriggerServerCallback('gangs:admin:deleteGang', gang.id) then
                                        ADMIN_GANG_MENU.Cache.gangs = Utils.TriggerServerCallback(
                                            'gangs:admin:getAllGangs')
                                        ADMIN_GANG_MENU.Cache.selectedGang = nil
                                        RageUI.GoBack()
                                        Notify('success', 'Gang supprimé avec succès')
                                    end
                                end
                            end
                        end
                    )
                end
            end)

            -- Menu Positions
            RageUI.IsVisible(RMenu:Get('gangAdmin', 'positions'), true, true, true, function()
                local gang = ADMIN_GANG_MENU.Cache.selectedGang
                if gang then
                    for _, posType in pairs({ 'coffre', 'armurerie', 'véhicule' }) do
                        RageUI.ButtonWithStyle(
                            string.format("Définir la Position %s", posType),
                            "Utiliser la position actuelle",
                            { RightLabel = "»" },
                            true,
                            function(_, _, Selected)
                                if Selected then
                                    local pos = GetEntityCoords(PlayerPedId())
                                    if Utils.TriggerServerCallback('gangs:admin:updatePosition', gang.id, posType, pos) then
                                        Notify('success', string.format('Position %s mise à jour', posType))
                                    end
                                end
                            end
                        )
                    end

                    RageUI.ButtonWithStyle(
                        "Définir la Direction du Véhicule",
                        "Utiliser la direction actuelle",
                        { RightLabel = "»" },
                        true,
                        function(_, _, Selected)
                            if Selected then
                                local heading = GetEntityHeading(PlayerPedId())
                                if Utils.TriggerServerCallback('gangs:admin:updateVehicleHeading', gang.id, heading) then
                                    Notify('success', 'Direction du véhicule mise à jour')
                                end
                            end
                        end
                    )
                end
            end)

            -- Menu Configurations Modifiées
            RageUI.IsVisible(RMenu:Get('gangAdmin', 'configs'), true, true, true, function()
                local gang = ADMIN_GANG_MENU.Cache.selectedGang
                if gang then
                    -- Configuration de la couleur existante
                    RageUI.ButtonWithStyle(
                        "Couleur du Gang",
                        "Définir la couleur du gang (RGB)",
                        {
                            RightLabel = "»",
                            Color = {
                                BackgroundColor = { gang.groupColor.r, gang.groupColor.g, gang.groupColor.b },
                                HightLightColor = {
                                    gang.groupColor.r + gang.groupColor.g + gang.groupColor.b > 382 and 0 or 255,
                                    gang.groupColor.r + gang.groupColor.g + gang.groupColor.b > 382 and 0 or 255,
                                    gang.groupColor.r + gang.groupColor.g + gang.groupColor.b > 382 and 0 or 255
                                }
                            }
                        },
                        true,
                        function(_, _, Selected)
                            if Selected then
                                local r = KeyboardInput("Entrez la valeur Rouge (0-255)", tostring(gang.groupColor.r), 3)
                                if r then
                                    local g = KeyboardInput("Entrez la valeur Verte (0-255)", tostring(gang.groupColor.g),
                                        3)
                                    if g then
                                        local b = KeyboardInput("Entrez la valeur Bleue (0-255)",
                                            tostring(gang.groupColor.b), 3)
                                        if b then
                                            local color = {
                                                r = math.max(0, math.min(255, tonumber(r) or 255)),
                                                g = math.max(0, math.min(255, tonumber(g) or 255)),
                                                b = math.max(0, math.min(255, tonumber(b) or 255))
                                            }
                                            if Utils.TriggerServerCallback('gangs:admin:updateColor', gang.id, color) then
                                                gang.groupColor = color
                                                Notify('success', 'Couleur du gang mise à jour')
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    )

                    -- Bouton de configuration de l'armurerie
                    RageUI.ButtonWithStyle(
                        "Configurer l'Armurerie",
                        "Configurer les armes et les prix de l'armurerie du gang",
                        {
                            RightLabel = #(gang.armoryConfig.weapons or {}) > 0 and
                                ("~y~" .. #gang.armoryConfig.weapons .. " armes~s~ »") or "»"
                        },
                        true,
                        function() end,
                        RMenu:Get('gangAdmin', 'armory')
                    )
                end
            end)

            -- Menu Armurerie
            RageUI.IsVisible(RMenu:Get('gangAdmin', 'armory'), true, true, true, function()
                local gang = ADMIN_GANG_MENU.Cache.selectedGang
                if gang then
                    -- Afficher les armes sélectionnées
                    RageUI.ButtonWithStyle(
                        "Armes Sélectionnées",
                        "Gérer les armes actuellement sélectionnées",
                        {
                            RightLabel = #(gang.armoryConfig.weapons or {}) > 0 and
                                ("~y~" .. #gang.armoryConfig.weapons .. " armes~s~ »") or "»"
                        },
                        true,
                        function() end,
                        RMenu:Get('gangAdmin', 'armory_selected')
                    )

                    RageUI.Separator(" ~y~Ajouter des Armes~s~ ")

                    -- Boutons des catégories d'armes
                    for categoryKey, category in pairs(Config.WeaponCategories) do
                        RageUI.ButtonWithStyle(
                            category.name,
                            "Configurer " .. category.name:lower(),
                            { RightLabel = "»" },
                            true,
                            function() end,
                            RMenu:Get('gangAdmin', 'armory_' .. categoryKey)
                        )
                    end
                end
            end)

            -- Menu Armes Sélectionnées
            RageUI.IsVisible(RMenu:Get('gangAdmin', 'armory_selected'), true, true, true, function()
                local gang = ADMIN_GANG_MENU.Cache.selectedGang
                if gang then
                    if #(gang.armoryConfig.weapons or {}) == 0 then
                        
                        RageUI.Separator("~r~Aucune arme configurée")
                        
                    else
                        for i, weapon in ipairs(gang.armoryConfig.weapons) do
                            RageUI.ButtonWithStyle(
                                weapon.label,
                                "Prix : $" .. weapon.price,
                                { RightLabel = "~r~Supprimer~s~ »" },
                                true,
                                function(_, _, Selected)
                                    if Selected then
                                        table.remove(gang.armoryConfig.weapons, i)
                                        Utils.TriggerServerCallback('gangs:admin:updateArmoryConfig', gang.id,
                                            gang.armoryConfig)
                                        Notify("success", weapon.label .. " supprimée de l'armurerie")
                                    end
                                end
                            )
                        end
                    end
                end
            end)

            -- Menus des catégories d'armes
            for categoryKey, category in pairs(Config.WeaponCategories) do
                RageUI.IsVisible(RMenu:Get('gangAdmin', 'armory_' .. categoryKey), true, true, true, function()
                    ADMIN_GANG_MENU.HandleWeaponCategoryMenu(categoryKey)
                end)
            end

            Wait(0)
        end
    end)
end

function ADMIN_GANG_MENU.IsWeaponInArmory(weaponType)
    local gang = ADMIN_GANG_MENU.Cache.selectedGang
    if not gang or not gang.armoryConfig or not gang.armoryConfig.weapons then return false end

    for _, weapon in pairs(gang.armoryConfig.weapons) do
        if weapon.type == weaponType then
            return true
        end
    end
    return false
end

function ADMIN_GANG_MENU.HandleWeaponCategoryMenu(categoryKey)
    local gang = ADMIN_GANG_MENU.Cache.selectedGang
    if not gang then return end

    local category = Config.WeaponCategories[categoryKey]
    RageUI.Separator(" " .. category.separator .. " ")

    for _, weapon in pairs(Config.WeaponList) do
        if weapon.category == categoryKey then
            local isSelected = ADMIN_GANG_MENU.IsWeaponInArmory(weapon.type)
            RageUI.ButtonWithStyle(
                weapon.label,
                isSelected and "~r~Déjà dans l'armurerie~s~" or "Appuyez pour définir le prix et ajouter à l'armurerie",
                { RightLabel = isSelected and "~r~Sélectionné~s~" or "»»" },
                not isSelected,
                function(_, _, Selected)
                    if Selected then
                        if not gang.armoryConfig.weapons then
                            gang.armoryConfig.weapons = {}
                        end
                        table.insert(gang.armoryConfig.weapons, {
                            type = weapon.type,
                            label = weapon.label,
                            price = weapon.price,
                        })
                        Utils.TriggerServerCallback('gangs:admin:updateArmoryConfig', gang.id, gang.armoryConfig)
                        Notify("success", weapon.label .. " ajouté à l'armurerie ($" .. tostring(weapon.price) .. ")")
                    end
                end
            )
        end
    end
end

function ADMIN_GANG_MENU.DrawLoadingText(text)
    SetTextFont(4)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.5, 0.5)
end

function ADMIN_GANG_MENU.Close()
    ADMIN_GANG_MENU.IsOpen = false
    if ADMIN_GANG_MENU.PreviewVehicle and DoesEntityExist(ADMIN_GANG_MENU.PreviewVehicle) then
        DeleteEntity(ADMIN_GANG_MENU.PreviewVehicle)
        ADMIN_GANG_MENU.PreviewVehicle = nil
    end
    ADMIN_GANG_MENU.CurrentPreviewModel = nil
    ADMIN_GANG_MENU.IsLoadingModel = false
    RageUI.CloseAll()
end
