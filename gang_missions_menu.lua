MISSIONS_MENU = {
    IsOpen = false,
 }

function MISSIONS_MENU.Open()
    if MISSIONS_MENU.IsOpen then
        MISSIONS_MENU.Close()
        return
    end

    MISSIONS_MENU.IsOpen = true

    -- Création des menus
    RMenu.Add('missions', 'main', RageUI.CreateMenu("Missions de Gang", "Missions disponibles"))
    RMenu.Add('missions', 'info', RageUI.CreateSubMenu(RMenu:Get('missions', 'main'), "Informations de Mission", "Détails de la Mission"))

    -- Style pour tous les menus
    for _, menuName in pairs({ 'main', 'info' }) do
        RMenu:Get('missions', menuName):SetRectangleBanner(255, 220, 0, 140)
    end

    RageUI.Visible(RMenu:Get('missions', 'main'), true)
    RMenu:Get('missions', 'main').Closed = function()
        MISSIONS_MENU.Close()
    end

    -- Récupération des données initiales
    local missionStatus = Utils.TriggerServerCallback('gangs:missions:getStatus', GANG_PLAYER.GangId)
    local selectedMission = nil

    Citizen.CreateThread(function()
        while MISSIONS_MENU.IsOpen do
            RageUI.IsVisible(RMenu:Get('missions', 'main'), true, true, true, function()
                if missionStatus then
                    -- Regrouper les missions par type (peut être étendu pour plus de catégories)
                    RageUI.Separator(" Missions d'Armes~s~ ")

                    for weaponType, data in pairs(missionStatus) do
                        -- Calcul du temps restant
                        local timeText = ""
                        if data.reset_time > 0 then
                            local hours = math.floor(data.reset_time / 3600)
                            local minutes = math.floor((data.reset_time % 3600) / 60)
                            timeText = string.format("Réinitialisation : %dh %dm", hours, minutes)
                        end

                        -- Étiquette de droite
                        local rightLabel = ""
                        if data.remaining > 0 then
                            rightLabel = string.format("~y~%d/%d~s~ »", data.remaining, data.max)
                        else
                            rightLabel = string.format("~r~%d/%d~s~ %s", data.remaining, data.max, timeText)
                        end

                        -- Bouton de mission
                        if data.remaining > 0 then
                            RageUI.ButtonWithStyle(
                                data.label,
                                string.format("Coût : $%s~n~Disponible : %d/%d", data.price, data.remaining, data.max),
                                { RightLabel = rightLabel },
                                true,
                                function(_, _, Selected)
                                    if Selected then
                                        selectedMission = {
                                            type = weaponType,
                                            data = data,
                                        }
                                    end
                                end,
                                RMenu:Get('missions', 'info')
                            )
                        else
                            RageUI.ButtonWithStyle(
                                data.label,
                                string.format("Coût : $%s~n~Disponible : %d/%d", data.price, data.remaining, data.max),
                                { RightLabel = rightLabel },
                                true,
                                function(_, _, Selected) end
                            )
                        end
                    end
                        RageUI.ButtonWithStyle(
                            "Acheter une tablette illégale",
                            nil,
                            { RightLabel = "50,000$" },
                            true,
                            function(_, _, Selected)
                                if Selected then
                                    TriggerServerEvent("orgsystem:buyTablet")
                                end
                            end
                        )
                else
                    
                    RageUI.ButtonWithStyle(
                        "Aucune mission disponible",
                        "Rejoignez un gang pour accéder aux missions",
                        {},
                        false,
                        function() end
                    )

                    RageUI.ButtonWithStyle(
                        "Acheter une tablette illégale",
                        nil,
                        { RightLabel = "50,000$" },
                        true,
                        function(_, _, Selected)
                            if Selected then
                                TriggerServerEvent("orgsystem:buyTablet")
                            end
                        end
                    )
                end
            end)

            -- Sous-menu : infos et confirmation de mission
            RageUI.IsVisible(RMenu:Get('missions', 'info'), true, true, true, function()
                if selectedMission then
                    local data = selectedMission.data

                    -- Détails de la mission
                    RageUI.Separator(" Détails de la Mission~s~ ")
                    RageUI.ButtonWithStyle("Arme", data.label, { RightLabel = "»" }, true)

                    RageUI.ButtonWithStyle(
                        "Coût",
                        "Coût de la mission prélevé dans la caisse du gang",
                        { RightLabel = "~y~$" .. data.price },
                        true
                    )

                    RageUI.ButtonWithStyle(
                        "Disponible",
                        "Missions disponibles aujourd'hui",
                        { RightLabel = data.remaining .. "/" .. data.max },
                        true
                    )

                    if data.reset_time > 0 then
                        local hours = math.floor(data.reset_time / 3600)
                        local minutes = math.floor((data.reset_time % 3600) / 60)
                        RageUI.ButtonWithStyle(
                            "Réinitialisation",
                            "Temps restant avant plus de missions",
                            { RightLabel = string.format("%dh %dm", hours, minutes) },
                            true
                        )
                    end

                    -- Séparateur avant les actions
                    RageUI.Separator(" ~y~Actions~s~ ")

                    -- Bouton pour démarrer la mission
                    RageUI.ButtonWithStyle(
                        "Démarrer la Mission",
                        "Commencer la mission pour acquérir cette arme",
                        { RightLabel = "~y~START~s~ »" },
                        true,
                        function(_, _, Selected)
                            if Selected then
                                local success, message, missionId = Utils.TriggerServerCallback(
                                    'gangs:missions:start',
                                    GANG_PLAYER.GangId,
                                    selectedMission.type
                                )
                                if success then
                                    MISSIONS_MENU.Close()
                                    GANG_PLAYER.CurrentMission = missionId
                                    Notify('success', string.format("Mission lancée pour %s", data.label))
                                else
                                    Notify('error', message)
                                end
                            end
                        end
                    )
                end
            end)

            Wait(0)
        end
    end)
end

function MISSIONS_MENU.Close()
    MISSIONS_MENU.IsOpen = false
    RageUI.CloseAll()
end

RegisterNetEvent('gang:missions:error')
AddEventHandler('gang:missions:error', function(message)
    Notify('error', message)
end)

RegisterNetEvent('gang:missions:success')
AddEventHandler('gang:missions:success', function(message)
    Notify('success', message)
end)