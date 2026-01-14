GANG_MONEY = {
    IsOpen = false,
 }

function GANG_MONEY.Open()
    if GANG_MONEY.IsOpen then
        GANG_MONEY.Close()
        return
    end

    GANG_MONEY.IsOpen = true

    -- Créer les menus
    RMenu.Add('money', 'main', RageUI.CreateMenu("Argent de Gang", "Gérer les finances du gang"))
    RMenu.Add('money', 'clean', RageUI.CreateSubMenu(RMenu:Get('money', 'main'), "Argent Propre", "Gérer l'argent propre"))
    RMenu.Add('money', 'dirty', RageUI.CreateSubMenu(RMenu:Get('money', 'main'), "Argent Sale", "Gérer l'argent sale"))
    RMenu.Add('money', 'storage', RageUI.CreateSubMenu(RMenu:Get('money', 'main'), "Stockage", "Stockage du gang"))

    -- Définir le style pour tous les menus
    for _, menuName in pairs({ 'main', 'clean', 'dirty', 'storage' }) do
        RMenu:Get('money', menuName):SetRectangleBanner(255, 220, 0, 140)
    end

    RageUI.Visible(RMenu:Get('money', 'main'), true)
    RMenu:Get('money', 'main').Closed = function()
        GANG_MONEY.Close()
    end

    -- Obtenir les soldes actuels et le statut de leader en dehors de la boucle
    local balances = Utils.TriggerServerCallback('gangs:money:getBalance', GANG_PLAYER.GangId)
    local isLeader = Utils.TriggerServerCallback('gangs:logic:IsPlayerGangLeader')
    local canAccessStorage = Utils.TriggerServerCallback('gangs:logic:hasPermission', GANG_PLAYER.GangId, "ACCESS_STORAGE")

    Citizen.CreateThread(function()
        while GANG_MONEY.IsOpen do
            RageUI.IsVisible(RMenu:Get('money', 'main'), true, true, true, function()
                if balances then
                    -- Section Argent Propre
                    RageUI.ButtonWithStyle("Gérer l'Argent Propre", string.format("Solde Actuel : $%s", balances.clean), {
                        RightLabel = "~y~$" .. balances.clean .. "~s~ »",
                     }, true, function()
                    end, RMenu:Get('money', 'clean'))

                    -- Section Argent Sale
                    RageUI.ButtonWithStyle("Gérer l'Argent Sale", string.format("Solde Actuel : $%s", balances.dirty), {
                        RightLabel = "~r~$" .. balances.dirty .. "~s~ »",
                     }, true, function()
                    end, RMenu:Get('money', 'dirty'))

                    -- Section Stockage
                    RageUI.ButtonWithStyle("Ouvrir le Stockage", "Accéder au stockage du gang", {
                        RightLabel = "»",
                     }, true, function(_, _, Selected)
                        if Selected then
                            local hasPermission = Utils.TriggerServerCallback('gangs:logic:hasPermission', GANG_PLAYER.GangId, "ACCESS_STORAGE")
                            if hasPermission then
                                GANG_MONEY.Close()
                                TriggerEvent("coffres:openCoffre", GANG_PLAYER.GangId)
                            else
                                Notify("error", "Vous n'avez pas la permission d'accéder au stockage")
                            end
                        end
                    end)
                end
            end)

            -- Menu Argent Propre
            RageUI.IsVisible(RMenu:Get('money', 'clean'), true, true, true, function()
                RageUI.Separator("Solde actuel: ~y~$" .. balances.clean .. "~s~")

                -- Bouton Déposer
                RageUI.ButtonWithStyle("Déposer de l'Argent", "Entrez le montant à déposer", {
                    RightLabel = "»",
                 }, true, function(_, _, Selected)
                    if Selected then
                        local input = KeyboardInput("Entrez le montant à déposer", "", 10)
                        if input then
                            local amount = tonumber(input)
                            if amount and amount > 0 then
                                local success = Utils.TriggerServerCallback('gangs:money:deposit', GANG_PLAYER.GangId, amount, 'clean')
                                if success then
                                    balances = Utils.TriggerServerCallback('gangs:money:getBalance', GANG_PLAYER.GangId)
                                    Notify("success", "Vous avez déposé avec succès $" .. amount)
                                else
                                    Notify("error", "Échec du dépôt de l'argent")
                                end
                            else
                                Notify("error", "Montant invalide")
                            end
                        end
                    end
                end)

                -- Bouton Retirer (Leader Seulement)
                RageUI.ButtonWithStyle("Retirer de l'Argent", (isLeader or canAccessStorage) and "Entrez le montant à retirer" or "Seul le leader peut retirer de l'argent", {
                    RightLabel = (isLeader or canAccessStorage) and "»" or "~r~VERROUILLÉ~s~",
                 }, isLeader or canAccessStorage, function(_, _, Selected)
                    if Selected then
                        local input = KeyboardInput("Entrez le montant à retirer", "", 10)
                        if input then
                            local amount = tonumber(input)
                            if amount and amount > 0 then
                                local success = Utils.TriggerServerCallback('gangs:money:withdraw', GANG_PLAYER.GangId, amount, 'clean')
                                if success then
                                    balances = Utils.TriggerServerCallback('gangs:money:getBalance', GANG_PLAYER.GangId)
                                    Notify("success", "Vous avez retiré avec succès $" .. amount)
                                else
                                    Notify("error", "Échec du retrait de l'argent")
                                end
                            else
                                Notify("error", "Montant invalide")
                            end
                        end
                    end
                end)
            end)

            -- Menu Argent Sale
            RageUI.IsVisible(RMenu:Get('money', 'dirty'), true, true, true, function()
                RageUI.Separator("Solde actuel: ~r~$" .. balances.dirty .. "~s~")

                -- Bouton Déposer
                RageUI.ButtonWithStyle("Déposer de l'Argent", "Entrez le montant à déposer", {
                    RightLabel = "»",
                 }, true, function(_, _, Selected)
                    if Selected then
                        local input = KeyboardInput("Entrez le montant à déposer", "", 10)
                        if input then
                            local amount = tonumber(input)
                            if amount and amount > 0 then
                                local success = Utils.TriggerServerCallback('gangs:money:deposit', GANG_PLAYER.GangId, amount, 'dirty')
                                if success then
                                    balances = Utils.TriggerServerCallback('gangs:money:getBalance', GANG_PLAYER.GangId)
                                    Notify("success", "Vous avez déposé avec succès $" .. amount)
                                else
                                    Notify("error", "Échec du dépôt de l'argent")
                                end
                            else
                                Notify("error", "Montant invalide")
                            end
                        end
                    end
                end)

                -- Bouton Retirer (Leader Seulement)
                RageUI.ButtonWithStyle("Retirer de l'Argent", (isLeader or canAccessStorage) and "Entrez le montant à retirer" or "Seul le leader peut retirer de l'argent", {
                    RightLabel = (isLeader or canAccessStorage) and "»" or "~r~VERROUILLÉ~s~",
                 }, isLeader or canAccessStorage, function(_, _, Selected)
                    if Selected then
                        local input = KeyboardInput("Entrez le montant à retirer", "", 10)
                        if input then
                            local amount = tonumber(input)
                            if amount and amount > 0 then
                                local success = Utils.TriggerServerCallback('gangs:money:withdraw', GANG_PLAYER.GangId, amount, 'dirty')
                                if success then
                                    balances = Utils.TriggerServerCallback('gangs:money:getBalance', GANG_PLAYER.GangId)
                                    Notify("success", "Vous avez retiré avec succès $" .. amount)
                                else
                                    Notify("error", "Échec du retrait de l'argent")
                                end
                            else
                                Notify("error", "Montant invalide")
                            end
                        end
                    end
                end)
            end)

            Wait(0)
        end
    end)
end

function GANG_MONEY.Close()
    GANG_MONEY.IsOpen = false
    RageUI.CloseAll()
end
