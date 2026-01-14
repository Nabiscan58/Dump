GANG_BUILDER = {}
GANG_BUILDER.IsOpen = false
GANG_BUILDER.PreviewVehicle = nil

-- Variables to store new gang data
GANG_BUILDER.NewGang = {
    name = "",
    level = 1,
    chestPosition = nil,
    clothPosition = nil,
    armoryPosition = nil,
    vehiclePosition = nil,
    vehicleHeading = 0.0,
    blipColor = 1,
    color = {r = 255, g = 255, b = 255},
}

GANG_BUILDER.NewGang.armoryConfig = {
    weapons = {}  -- Will store {type = "WEAPON_NAME", label = "Label", price = 1000}
}

function GANG_BUILDER.ResetNewGang()
    GANG_BUILDER.NewGang = {
        name = "",
        level = 1,
        chestPosition = nil,
        clothPosition = nil,
        armoryPosition = nil,
        vehiclePosition = nil,
        vehicleHeading = 0.0,
        groupType = "Gang",
        blipColor = 1,
        color = {r = 255, g = 255, b = 255},
    }

    GANG_BUILDER.NewGang.armoryConfig = {
        weapons = {}  -- Will store {type = "WEAPON_NAME", label = "Label", price = 1000}
    }
end

GANG_BUILDER.PreviewMarkers = true
GANG_BUILDER.MarkerTypes = {
    chest = 2,      -- Checkpoint style
    cloth = 30,     -- Vertical cylinder
    armory = 29,    -- Horizontal cylinder
    vehicle = 36    -- Direction arrow
}

function GANG_BUILDER.GetWeaponByType(weaponType)
    for _, weapon in pairs(Config.WeaponList) do
        if weapon.type == weaponType then
            return weapon
        end
    end
    return nil
end

function GANG_BUILDER.IsWeaponInArmory(weaponType)
    for _, weapon in pairs(GANG_BUILDER.NewGang.armoryConfig.weapons) do
        if weapon.type == weaponType then
            return true
        end
    end
    return false
end

function GANG_BUILDER.GetVehicleByModel(model)
    for _, vehicle in pairs(Config.VehicleList) do
        if vehicle.model == model then
            return vehicle
        end
    end
    return nil
end

function GANG_BUILDER.Open()
    if GANG_BUILDER.IsOpen then
        GANG_BUILDER.Close()
        return
    end

    GANG_BUILDER.IsOpen = true

    RMenu.Add('menu', 'main', RageUI.CreateMenu("Créateur de Gang", "Menu de création de gang"))

    RMenu.Add('menu', 'list', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Liste de Gangs", "Gérer les gangs existants"))

    RMenu.Add('menu', 'armory', RageUI.CreateSubMenu(RMenu:Get('menu', 'main'), "Config de l'Armurerie", "Configurer l'armurerie du gang"))

    RMenu.Add('menu', 'armory_pistols', RageUI.CreateSubMenu(RMenu:Get('menu', 'armory'), "Pistolets", "Configurer les pistolets"))
    RMenu.Add('menu', 'armory_smgs', RageUI.CreateSubMenu(RMenu:Get('menu', 'armory'), "SMGs", "Configurer les SMGs"))
    RMenu.Add('menu', 'armory_rifles', RageUI.CreateSubMenu(RMenu:Get('menu', 'armory'), "Fusils", "Configurer les fusils"))
    RMenu.Add('menu', 'armory_shotguns', RageUI.CreateSubMenu(RMenu:Get('menu', 'armory'), "Fusils à Pompe", "Configurer les fusils à pompe"))
    RMenu.Add('menu', 'armory_heavy', RageUI.CreateSubMenu(RMenu:Get('menu', 'armory'), "Armes Lourdes", "Configurer les armes lourdes"))
    RMenu.Add('menu', 'armory_melee', RageUI.CreateSubMenu(RMenu:Get('menu', 'armory'), "Armes de Mêlée", "Configurer les armes de mêlée"))
    RMenu.Add('menu', 'armory_selected', RageUI.CreateSubMenu(RMenu:Get('menu', 'armory'), "Armes Sélectionnées", "Gérer les armes sélectionnées"))

    for _, menuName in pairs({'armory', 'armory_pistols', 'armory_smgs', 'armory_rifles', 'armory_shotguns', 'armory_heavy', 'armory_melee', 'armory_selected'}) do
        RMenu:Get('menu', menuName):SetRectangleBanner(255, 220, 0, 140)
    end

    RMenu:Get('menu', 'main'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'list'):SetRectangleBanner(255, 220, 0, 140)

    RMenu:Get('menu', 'main').EnableMouse = false
    RMenu:Get('menu', 'main').Closed = function()
        GANG_BUILDER.IsOpen = false
        GANG_BUILDER.ResetNewGang()

        if DoesEntityExist(GANG_BUILDER.PreviewVehicle) == 1 then
            DeleteEntity(GANG_BUILDER.PreviewVehicle)
        end
    end

    for name, menu in pairs(RMenu['menu']) do
        RMenu:Get('menu', name):SetRectangleBanner(255, 220, 0, 140)
    end

    RageUI.Visible(RMenu:Get('menu', 'main'), true)

    local model = GetHashKey("adder")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    GANG_BUILDER.PreviewVehicle = CreateVehicle(model, 0.0, 0.0, 0.0, 0.0, false, false)
    SetEntityVisible(GANG_BUILDER.PreviewVehicle, false, false)
    SetEntityCollision(GANG_BUILDER.PreviewVehicle, false, false)

    Citizen.CreateThread(function()
        while GANG_BUILDER.IsOpen do
            RageUI.IsVisible(RMenu:Get('menu', 'main'), true, true, true, function()
                GANG_BUILDER.DrawPositionPreviews()
                -- Section Liste de Gangs
                RageUI.ButtonWithStyle("Gérer les Gangs Existants", "Voir et modifier les gangs existants", {RightLabel = "»»"}, true, function(_, _, Selected)
                    if Selected then
                        GANG_BUILDER.IsOpen = false
                        GANG_BUILDER.ResetNewGang()
                        ADMIN_GANG_MENU.Open()
                    end
                end)

                -- Section Création de Gang
                RageUI.Separator(" Création de Gang ")

                RageUI.ButtonWithStyle("Nom du Gang", "Définir le nom du gang", {RightLabel = GANG_BUILDER.NewGang.name ~= "" and GANG_BUILDER.NewGang.name or "»"}, true, function(_, _, Selected)
                    if Selected then
                        local input = KeyboardInput("Entrez le nom du gang", "", 30)
                        if input then
                            GANG_BUILDER.NewGang.name = string.lower(input)
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Configurer l'Armurerie", "Configurer les armes et les prix de l'armurerie du gang", {
                    RightLabel = #GANG_BUILDER.NewGang.armoryConfig.weapons > 0 and ("~y~" .. #GANG_BUILDER.NewGang.armoryConfig.weapons .. " armes~s~ »") or "»"
                }, true, function()
                end, RMenu:Get('menu', 'armory'))

                RageUI.ButtonWithStyle("Définir la Position du Coffre", "Définir la position du coffre du gang", {RightLabel = GANG_BUILDER.NewGang.chestPosition and "~y~Défini~s~" or "»"}, true, function(_, _, Selected)
                    if Selected then
                        local coords = GetEntityCoords(PlayerPedId())
                        GANG_BUILDER.NewGang.chestPosition = coords
                        Notify("success", "Position du coffre définie !")
                    end
                end)

                -- RageUI.ButtonWithStyle("Définir la Position du Magasin de Vêtements", "Définir la position du magasin de vêtements", {RightLabel = GANG_BUILDER.NewGang.clothPosition and "~y~Défini~s~" or "»"}, true, function(_, _, Selected)
                --     if Selected then
                --         local coords = GetEntityCoords(PlayerPedId())
                --         GANG_BUILDER.NewGang.clothPosition = coords
                --         Notify("success", "Position du magasin de vêtements définie !")
                --     end
                -- end)

                RageUI.ButtonWithStyle("Définir la Position de l'Armurerie", "Définir la position de l'armurerie", {RightLabel = GANG_BUILDER.NewGang.armoryPosition and "~y~Défini~s~" or "»"}, true, function(_, _, Selected)
                    if Selected then
                        local coords = GetEntityCoords(PlayerPedId())
                        GANG_BUILDER.NewGang.armoryPosition = coords
                        Notify("success", "Position de l'armurerie définie !")
                    end
                end)

                RageUI.ButtonWithStyle("Définir la Position du Garage", "Définir le point de garage", {RightLabel = GANG_BUILDER.NewGang.vehiclePosition and "~y~Défini~s~" or "»"}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local coords = GetEntityCoords(PlayerPedId())
                        local heading = GetEntityHeading(PlayerPedId())
                        GANG_BUILDER.NewGang.vehiclePosition = coords
                        GANG_BUILDER.NewGang.vehicleHeading = heading
                        Notify("success", "Position et direction du véhicule définies !")
                    end

                    if Active then
                        SetEntityVisible(GANG_BUILDER.PreviewVehicle, true, false)
                        SetEntityAlpha(GANG_BUILDER.PreviewVehicle, 130, false)
                        local pPosition = GetEntityCoords(PlayerPedId())
                        local pHeading = GetEntityHeading(PlayerPedId())
                        SetEntityCoordsNoOffset(GANG_BUILDER.PreviewVehicle, pPosition.x, pPosition.y, pPosition.z, false, false, false)
                        SetEntityHeading(GANG_BUILDER.PreviewVehicle, pHeading)
                    else
                        SetEntityVisible(GANG_BUILDER.PreviewVehicle, false, false)
                    end
                end)

                if currentIndex == nil then currentIndex = 1 end
                if t == nil then
                    t = {
                        "Gang",
                        "Orga",
                        "Mafia",
                        "MC",
                    }
                end
                RageUI.List("Type de groupe", {
                    "Gang",
                    "Orga",
                    "Mafia",
                    "MC",
                }, currentIndex, nil, {}, true, function(_, _, Selected, index)
                    currentIndex = index
                    GANG_BUILDER.NewGang.groupType = t[currentIndex]
                end)

                RageUI.ButtonWithStyle("Couleur du territoire", nil, {RightLabel = GANG_BUILDER.NewGang.blipColor and GANG_BUILDER.NewGang.blipColor or "»"}, true, function(_, _, Selected)
                    if Selected then
                        local r = KeyboardInput("Entrez le numéro de la couleur", "", 3)
                        if r then
                            GANG_BUILDER.NewGang.blipColor = r
                            Notify("success", "Couleur du terreitoire définie !")
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Couleur du Gang", "Définir la couleur du gang (RGB)", {
                    RightLabel = "»",
                    Color = {
                        -- Utiliser la couleur actuelle du gang pour l'arrière-plan
                        BackgroundColor = { GANG_BUILDER.NewGang.color.r, GANG_BUILDER.NewGang.color.g, GANG_BUILDER.NewGang.color.b },
                        -- Utiliser du texte blanc/noir en fonction de la luminosité de l'arrière-plan
                        HightLightColor = {  -- Calculer si nous devons utiliser du texte noir ou blanc en fonction de la luminosité de la couleur de fond
                            GANG_BUILDER.NewGang.color.r + GANG_BUILDER.NewGang.color.g + GANG_BUILDER.NewGang.color.b > 382 and 0 or 255,
                            GANG_BUILDER.NewGang.color.r + GANG_BUILDER.NewGang.color.g + GANG_BUILDER.NewGang.color.b > 382 and 0 or 255,
                            GANG_BUILDER.NewGang.color.r + GANG_BUILDER.NewGang.color.g + GANG_BUILDER.NewGang.color.b > 382 and 0 or 255
                        },
                     },
                 }, true, function(_, _, Selected)
                    if Selected then
                        local r = KeyboardInput("Entrez la valeur Rouge (0-255)", "", 3)
                        if r then
                            local g = KeyboardInput("Entrez la valeur Verte (0-255)", "", 3)
                            if g then
                                local b = KeyboardInput("Entrez la valeur Bleue (0-255)", "", 3)
                                if b then
                                    GANG_BUILDER.NewGang.color = {
                                        r = math.max(0, math.min(255, tonumber(r) or 255)),
                                        g = math.max(0, math.min(255, tonumber(g) or 255)),
                                        b = math.max(0, math.min(255, tonumber(b) or 255)),
                                     }
                                    Notify("success", string.format("Couleur du gang définie à RGB(%d, %d, %d)", GANG_BUILDER.NewGang.color.r, GANG_BUILDER.NewGang.color.g, GANG_BUILDER.NewGang.color.b))
                                end
                            end
                        end
                    end
                end)

                -- Le bouton principal de création
                RageUI.ButtonWithStyle(
                    "~h~Créer un Gang~h~",
                    "Créer le gang : " .. (GANG_BUILDER.NewGang.name ~= "" and GANG_BUILDER.NewGang.name or "Définissez d'abord le nom du gang"),
                    {
                        RightLabel = "~h~[ ~y~CONFIRMER~s~ ~h~]",
                        Color = {
                            BackgroundColor = {0, 100, 0},
                            HightLightColor = {255, 255, 255}
                        }
                    },
                    GANG_BUILDER.ValidateGangData(),
                    function(_, Active, Selected)
                        if Active then
                            -- Optionnel : Ajouter un retour visuel lors du survol
                            DrawRect(0.5, 0.5, 0.001, 0.001, 0, 255, 0, 100)
                        end

                        if Selected then
                            -- Créer une table de données pour le callback
                            local gangData = {
                                name = GANG_BUILDER.NewGang.name,
                                level = GANG_BUILDER.NewGang.level,
                                chestPosition = GANG_BUILDER.NewGang.chestPosition,
                                clothPosition = GANG_BUILDER.NewGang.clothPosition,
                                armoryPosition = GANG_BUILDER.NewGang.armoryPosition,
                                vehiclePosition = GANG_BUILDER.NewGang.vehiclePosition,
                                vehicleHeading = GANG_BUILDER.NewGang.vehicleHeading,
                                groupType = GANG_BUILDER.NewGang.groupType,
                                blipColor = GANG_BUILDER.NewGang.blipColor,
                                groupColor = GANG_BUILDER.NewGang.color,
                                armoryConfig = GANG_BUILDER.NewGang.armoryConfig, -- Passer la configuration complète de l'armurerie avec les armes
                            }

                            -- Afficher d'abord un message de confirmation
                            RageUI.CloseAll()

                            -- Ajouter un petit délai pour un retour visuel
                            Citizen.CreateThread(function()
                                -- Afficher une notification "Création du gang..."
                                Notify("info", "Création du gang " .. gangData.name .. "...")
                                Wait(1000)

                                -- Déclencher le callback pour créer le gang
                                local success = Utils.TriggerServerCallback('gangs:admin:createGang', gangData)

                                if success then
                                    -- Animation/son de succès
                                    PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)

                                    -- Notifications de succès
                                    Notify("success", "Gang " .. gangData.name .. " créé avec succès !")
                                    Wait(500)
                                    Notify("info", "Niveau : " .. gangData.level)
                                    Wait(500)
                                    Notify("info", "Couleur : RGB(" .. gangData.groupColor.r .. "," .. gangData.groupColor.g .. "," .. gangData.groupColor.b .. ")")

                                    GANG_BUILDER.ResetNewGang() -- Réinitialiser le formulaire
                                else
                                    -- Son d'erreur
                                    PlaySoundFrontend(-1, "ERROR", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                                    Notify("error", "Échec de la création du gang. Veuillez réessayer.")
                                    -- Réouvrir le menu
                                    GANG_BUILDER.Open()
                                end
                            end)
                        end
                    end
                )
            end)

            RageUI.IsVisible(RMenu:Get('menu', 'armory_selected'), true, true, true, function()
                if #GANG_BUILDER.NewGang.armoryConfig.weapons == 0 then
                    
                    RageUI.Separator("~r~Aucune arme configurée")
                    
                else
                    for i, weapon in ipairs(GANG_BUILDER.NewGang.armoryConfig.weapons) do
                        RageUI.ButtonWithStyle(weapon.label, "Prix : $" .. weapon.price, {
                            RightLabel = "~r~Supprimer~s~ »"
                        }, true, function(_, _, Selected)
                            if Selected then
                                table.remove(GANG_BUILDER.NewGang.armoryConfig.weapons, i)
                                Notify("success", weapon.label .. " supprimée de l'armurerie")
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('menu', 'armory'), true, true, true, function()
                -- Afficher le nombre d'armes configurées
                RageUI.ButtonWithStyle("Armes Sélectionnées", "Gérer les armes actuellement sélectionnées", {
                    RightLabel = #GANG_BUILDER.NewGang.armoryConfig.weapons > 0 and ("~y~" .. #GANG_BUILDER.NewGang.armoryConfig.weapons .. " armes~s~ »") or "»"
                }, true, function()
                end, RMenu:Get('menu', 'armory_selected'))

                RageUI.Separator(" ~y~Ajouter des Armes~s~ ")

                -- Boutons de catégories d'armes
                RageUI.ButtonWithStyle("Pistolets", "Configurer les pistolets dans l'armurerie", {RightLabel = "»"}, true, function()
                end, RMenu:Get('menu', 'armory_pistols'))

                RageUI.ButtonWithStyle("SMGs", "Configurer les SMGs dans l'armurerie", {RightLabel = "»"}, true, function()
                end, RMenu:Get('menu', 'armory_smgs'))

                RageUI.ButtonWithStyle("Fusils", "Configurer les fusils dans l'armurerie", {RightLabel = "»"}, true, function()
                end, RMenu:Get('menu', 'armory_rifles'))

                RageUI.ButtonWithStyle("Fusils à Pompe", "Configurer les fusils à pompe dans l'armurerie", {RightLabel = "»"}, true, function()
                end, RMenu:Get('menu', 'armory_shotguns'))

                RageUI.ButtonWithStyle("Armes Lourdes", "Configurer les armes lourdes dans l'armurerie", {RightLabel = "»"}, true, function()
                end, RMenu:Get('menu', 'armory_heavy'))

                RageUI.ButtonWithStyle("Armes de Mêlée", "Configurer les armes de mêlée dans l'armurerie", {RightLabel = "»"}, true, function()
                end, RMenu:Get('menu', 'armory_melee'))
            end)

            for categoryKey, category in pairs(Config.WeaponCategories) do
                RageUI.IsVisible(RMenu:Get('menu', 'armory_' .. categoryKey), true, true, true, function()
                    GANG_BUILDER.HandleWeaponCategoryMenu(categoryKey)
                end)
            end

            -- Menu Liste de Gangs (placeholder pour l'instant)
            RageUI.IsVisible(RMenu:Get('menu', 'list'), true, true, true, function()
                RageUI.Separator(" Gangs Existants ")

                -- Placeholder pour la liste des gangs
                RageUI.ButtonWithStyle("À venir", "La gestion des gangs sera ajoutée plus tard", {RightLabel = "»"}, false, function()
                end)
            end)

            Wait(0)
        end

        DeleteVehicle(GANG_BUILDER.PreviewVehicle)
        if GANG_BUILDER.PreviewVehicle and DoesEntityExist(GANG_BUILDER.PreviewVehicle) then
            DeleteEntity(GANG_BUILDER.PreviewVehicle)
            GANG_BUILDER.PreviewVehicle = nil
        end
    end)

end

function GANG_BUILDER.HandleWeaponCategoryMenu(categoryKey)
    local category = Config.WeaponCategories[categoryKey]

    RageUI.Separator(" " .. category.separator .. " ")

    for _, weapon in pairs(Config.WeaponList) do
        if weapon.category == categoryKey then
            local isSelected = GANG_BUILDER.IsWeaponInArmory(weapon.type)
            RageUI.ButtonWithStyle(
                weapon.label,
                isSelected and "~r~Déjà dans l'armurerie~s~" or "Appuyez pour définir le prix et ajouter à l'armurerie",
                {RightLabel = isSelected and "~r~Sélectionné~s~" or "»»"},
                not isSelected,
                function(_, _, Selected)
                    if Selected then
                        table.insert(GANG_BUILDER.NewGang.armoryConfig.weapons, {
                            type = weapon.type,
                            label = weapon.label,
                            price = weapon.price,
                        })
                        Notify("success", weapon.label .. " ajouté à l'armurerie ("..weapon.price.."$)")
                    end
                end
            )
        end
    end
end

GANG_BUILDER.CurrentPreviewModel = nil
GANG_BUILDER.IsLoadingModel = false

-- Helper function to draw loading text
function GANG_BUILDER.DrawLoadingText(text)
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

function GANG_BUILDER.ValidateGangData()
    if GANG_BUILDER.NewGang.name == "" then
        return false
    end

    if not GANG_BUILDER.NewGang.chestPosition then
        return false
    end

    -- if not GANG_BUILDER.NewGang.clothPosition then
    --     return false
    -- end

    if not GANG_BUILDER.NewGang.armoryPosition then
        return false
    end

    if not GANG_BUILDER.NewGang.vehiclePosition then
        return false
    end

    return true
end

function GANG_BUILDER.Close()
    if GANG_BUILDER.PreviewVehicle and DoesEntityExist(GANG_BUILDER.PreviewVehicle) then
        DeleteEntity(GANG_BUILDER.PreviewVehicle)
        GANG_BUILDER.PreviewVehicle = nil
    end
    GANG_BUILDER.CurrentPreviewModel = nil
    GANG_BUILDER.IsLoadingModel = false
    GANG_BUILDER.IsOpen = false
    RageUI.CloseAll()
end

function GANG_BUILDER.DrawPositionPreviews()
    local color = GANG_BUILDER.NewGang.color
    local alpha = 100 -- Semi-transparent

    -- Position du Coffre
    if GANG_BUILDER.NewGang.chestPosition then
        DrawMarker(GANG_BUILDER.MarkerTypes.chest,
            GANG_BUILDER.NewGang.chestPosition.x,
            GANG_BUILDER.NewGang.chestPosition.y,
            GANG_BUILDER.NewGang.chestPosition.z,
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            1.0, 1.0, 1.0,
            color.r, color.g, color.b, alpha,
            false, true, 2, nil, nil, false, false
        )
        Draw3DText(
            GANG_BUILDER.NewGang.chestPosition.x,
            GANG_BUILDER.NewGang.chestPosition.y,
            GANG_BUILDER.NewGang.chestPosition.z + 1.0,
            "COFFRE",
            4, 0.7, 0.7,
            color
        )
    end

    -- Position du Magasin de Vêtements
    if GANG_BUILDER.NewGang.clothPosition then
        DrawMarker(GANG_BUILDER.MarkerTypes.cloth,
            GANG_BUILDER.NewGang.clothPosition.x,
            GANG_BUILDER.NewGang.clothPosition.y,
            GANG_BUILDER.NewGang.clothPosition.z,
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            1.0, 1.0, 1.0,
            color.r, color.g, color.b, alpha,
            false, true, 2, nil, nil, false, false
        )
        Draw3DText(
            GANG_BUILDER.NewGang.clothPosition.x,
            GANG_BUILDER.NewGang.clothPosition.y,
            GANG_BUILDER.NewGang.clothPosition.z + 1.0,
            "VÊTEMENTS",
            4, 0.7, 0.7,
            color
        )
    end

    -- Position de l'Armurerie
    if GANG_BUILDER.NewGang.armoryPosition then
        DrawMarker(GANG_BUILDER.MarkerTypes.armory,
            GANG_BUILDER.NewGang.armoryPosition.x,
            GANG_BUILDER.NewGang.armoryPosition.y,
            GANG_BUILDER.NewGang.armoryPosition.z,
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            1.0, 1.0, 1.0,
            color.r, color.g, color.b, alpha,
            false, true, 2, nil, nil, false, false
        )
        Draw3DText(
            GANG_BUILDER.NewGang.armoryPosition.x,
            GANG_BUILDER.NewGang.armoryPosition.y,
            GANG_BUILDER.NewGang.armoryPosition.z + 1.0,
            "ARMURERIE",
            4, 0.7, 0.7,
            color
        )
    end

    -- Position du Spawn du Véhicule
    if GANG_BUILDER.NewGang.vehiclePosition then
        DrawMarker(GANG_BUILDER.MarkerTypes.vehicle,
            GANG_BUILDER.NewGang.vehiclePosition.x,
            GANG_BUILDER.NewGang.vehiclePosition.y,
            GANG_BUILDER.NewGang.vehiclePosition.z,
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            1.0, 1.0, 1.0,
            color.r, color.g, color.b, alpha,
            false, true, 2, nil, nil, false, false
        )
        Draw3DText(
            GANG_BUILDER.NewGang.vehiclePosition.x,
            GANG_BUILDER.NewGang.vehiclePosition.y,
            GANG_BUILDER.NewGang.vehiclePosition.z + 1.0,
            "SPAWN DU VÉHICULE",
            4, 0.7, 0.7,
            color
        )

        -- Dessiner l'indicateur de direction
        local headingX = GANG_BUILDER.NewGang.vehiclePosition.x + math.sin(math.rad(-GANG_BUILDER.NewGang.vehicleHeading)) * 3.0
        local headingY = GANG_BUILDER.NewGang.vehiclePosition.y + math.cos(math.rad(-GANG_BUILDER.NewGang.vehicleHeading)) * 3.0

        -- Dessiner la ligne pour la direction
        DrawLine(
            GANG_BUILDER.NewGang.vehiclePosition.x,
            GANG_BUILDER.NewGang.vehiclePosition.y,
            GANG_BUILDER.NewGang.vehiclePosition.z,
            headingX, headingY,
            GANG_BUILDER.NewGang.vehiclePosition.z,
            color.r, color.g, color.b, 200
        )

        -- Dessiner une flèche à la fin
        DrawMarker(0,
            headingX, headingY,
            GANG_BUILDER.NewGang.vehiclePosition.z + 0.5,
            0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
            0.5, 0.5, 0.5,
            color.r, color.g, color.b, alpha,
            false, true, 2, nil, nil, false, false
        )
    end
end

-- TODO: Add permision checks
RegisterCommand('gangbuilder', function()
    ESX.TriggerServerCallback("gangbuilder:canOpen", function(can)
        if can == true then
            GANG_BUILDER.Open()
        else
            print('Pas les permissions nécessaires pour ouvrir le gangbuilder.')
        end
    end)
end, false)