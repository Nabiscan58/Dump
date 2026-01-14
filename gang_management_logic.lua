GANG_MEMBERS = {
    IsOpen = false,
    IsLoading = false,
    Cache = {
        members = {},
        ranks = {},
        isLeader = false,
     },
 }
 

-- function GANG_MEMBERS.Open()
--     if GANG_MEMBERS.IsOpen then
--         GANG_MEMBERS.Close()
--         return
--     end

--     GANG_MEMBERS.IsOpen = true
--     GANG_MEMBERS.IsLoading = true
--     local selectedPermission = nil

--     -- Créer les menus
--     RMenu.Add('members', 'main', RageUI.CreateMenu("Membres du Gang", "Gérer les membres du gang"))
--     RMenu.Add('members', 'recruit', RageUI.CreateSubMenu(RMenu:Get('members', 'main'), "Recruter des Membres", "Recruter de nouveaux membres"))
--     RMenu.Add('members', 'member_actions', RageUI.CreateSubMenu(RMenu:Get('members', 'main'), "Actions du Membre", "Gérer le membre"))

--     RMenu.Add('members', 'ranks', RageUI.CreateSubMenu(RMenu:Get('members', 'main'), "Gestion des Rangs", "Gérer les rangs du gang"))
--     RMenu.Add('members', 'edit_rank', RageUI.CreateSubMenu(RMenu:Get('members', 'ranks'), "Éditer le Rang", "Éditer les détails du rang"))

--     -- Définir le style
--     for _, menuName in pairs({ 'main', 'recruit', 'member_actions', 'ranks', 'edit_rank' }) do
--         RMenu:Get('members', menuName):SetRectangleBanner(255, 220, 0, 140)
--     end

--     RMenu.Add('members', 'permissions', RageUI.CreateSubMenu(RMenu:Get('members', 'main'), "Gestion des Permissions", "Configurer les permissions des rangs"))
--     RMenu.Add('members', 'select_rank', RageUI.CreateSubMenu(RMenu:Get('members', 'permissions'), "Sélectionner le Rang", "Sélectionner le rang requis"))
--     RMenu.Add('members', 'monopole', RageUI.CreateSubMenu(RMenu:Get('members', 'main'), "Monopole", "Que voulez-vous faire ?"))

--     for _, menuName in pairs({ 'main', 'recruit', 'member_actions', 'ranks', 'edit_rank', 'permissions' }) do
--         RMenu:Get('members', menuName):SetRectangleBanner(255, 220, 0, 140)
--     end

--     -- Charger les données initiales
--     Citizen.CreateThread(function()
--         GANG_MEMBERS.Cache.ranks = GANG_PLAYER.Data.ranks
--         GANG_MEMBERS.Cache.isLeader = Utils.TriggerServerCallback('gangs:logic:IsPlayerGangLeader')
--         GANG_MEMBERS.Cache.canRecruit = Utils.TriggerServerCallback('gangs:logic:isPlayerCanRecruit', GANG_PLAYER.GangId)
--         GANG_MEMBERS.Cache.members = Utils.TriggerServerCallback('gangs:members:getAllMembers', GANG_PLAYER.GangId)
--         GANG_MEMBERS.Cache.canManageRanks = Utils.TriggerServerCallback('gangs:logic:hasPermission', GANG_PLAYER.GangId, "MANAGE_RANKS")
--         GANG_MEMBERS.IsLoading = false

--         GANG_MEMBERS.RefreshRanks()
--     end)

--     RageUI.Visible(RMenu:Get('members', 'main'), true)

--     RMenu:Get('members', 'main').Closed = function()
--         GANG_MEMBERS.Close()
--     end

--     local infos = {}
--     Citizen.CreateThread(function()
--         local selectedMember = nil

--         while GANG_MEMBERS.IsOpen do
--             RageUI.IsVisible(RMenu:Get('members', 'main'), true, true, true, function()
--                 if GANG_MEMBERS.IsLoading then
                    
--                     RageUI.Separator("Chargement des données...~s~")
                    
--                 else
--                     RageUI.Separator(GANG_PLAYER.Data.name.." - "..GANG_MEMBERS.GetRankName(GANG_PLAYER.Rank))
                    
--                     if GANG_MEMBERS.Cache.canRecruit or GANG_MEMBERS.Cache.isLeader then
--                         RageUI.ButtonWithStyle("Recruter un nouveau membre", "Recruter un joueur près de vous", {
--                             RightLabel = "»",
--                         }, true, function()
--                         end, RMenu:Get('members', 'recruit'))

-- --                        RageUI.ButtonWithStyle("Activités illégales", nil, {
-- --                            RightLabel = "»",
-- --                        }, true, function(_, _, Selected)
-- --                            if Selected then
-- --                                tempIndex = nil
-- --                                ESX.TriggerServerCallback("orgs:getMonopole", function(rep, index)
-- --                                    infos = rep
-- --
-- --                                    tempIndex = index
-- --
-- --                                    for k,v in pairs(infos) do
-- --                                        RMenu.Add('members', 'monopole_'..v.name, RageUI.CreateSubMenu(RMenu:Get('members', 'main'), v.name, "Que voulez-vous faire ?"))
-- --                                    end
-- --                                end)
-- --                            end
-- --                        end, RMenu:Get('members', 'monopole'))
--                     end

--                     if GANG_MEMBERS.Cache.isLeader or (GANG_MEMBERS.Cache.canManageRanks ~= nil and GANG_MEMBERS.Cache.canManageRanks) then
--                         RageUI.ButtonWithStyle("Gérer les Rangs", "Configurer les rangs du gang", {
--                             RightLabel = "»",
--                         }, GANG_MEMBERS.Cache.isLeader, function()
--                         end, RMenu:Get('members', 'ranks'))

--                         RageUI.ButtonWithStyle("Gérer les Permissions", "Configurer les permissions des rangs", {
--                             RightLabel = "»",
--                         }, GANG_MEMBERS.Cache.isLeader, function()
--                         end, RMenu:Get('members', 'permissions'))
--                     end

--                     RageUI.ButtonWithStyle("Ouvrir le menu des Missions", "Ouvrir le menu des missions", {
--                         RightLabel = "»",
--                     }, true, function(_, _, Selected)
--                         if Selected then
--                             GANG_MEMBERS.Close()
--                             MISSIONS_MENU.Open()
--                         end
--                     end)

                    
--                     RageUI.Separator("Membres")
--                     local hasOnlineMembers = false
--                     for _, member in pairs(GANG_MEMBERS.Cache.members) do
--                         if member.isOnline then
--                             hasOnlineMembers = true
--                             local rankName = GANG_MEMBERS.GetRankName(member.rankLevel)
--                             RageUI.ButtonWithStyle(member.name, "Rang : " .. rankName .. "\nID : " .. member.source, {
--                                 RightLabel = "~y~En ligne~s~ »",
--                             }, GANG_MEMBERS.Cache.isLeader, -- Cliquable uniquement si leader
--                             function(_, _, Selected)
--                                 if Selected then
--                                     selectedMember = member
--                                 end
--                             end, RMenu:Get('members', 'member_actions'))
--                         else
--                             hasOfflineMembers = true
--                             local rankName = GANG_MEMBERS.GetRankName(member.rankLevel)
--                             RageUI.ButtonWithStyle(member.name, "Rang : " .. rankName .. "\nIdentifiant : " .. member.identifier, {
--                                 RightLabel = "~r~Hors ligne~s~ »",
--                             }, GANG_MEMBERS.Cache.isLeader, -- Cliquable uniquement si leader
--                             function(_, _, Selected)
--                                 if Selected then
--                                     selectedMember = member
--                                 end
--                             end, RMenu:Get('members', 'member_actions'))
--                         end
--                     end
--                 end
--             end)

--             RageUI.IsVisible(RMenu:Get('members', 'monopole'), true, true, true, function()

--                 for k,v in pairs(infos) do
--                     RageUI.ButtonWithStyle(v.name, nil, {
--                         RightLabel = "»",
--                     }, true, function(_, _, Selected)
--                     end, RMenu:Get('members', 'monopole_'..v.name))
--                 end

--             end)

--             for k,v in pairs(infos) do
--                 RageUI.IsVisible(RMenu:Get('members', 'monopole_'..v.name), true, true, true, function()

--                     for i,l in pairs(v.items) do
--                         if v.type == "shop" then
--                             if l.owned then
--                                 if l.owners == "Aucun" then
--                                     RageUI.ButtonWithStyle("~y~"..l.name, "~y~Cette arme n'appartient pas à un groupe, cliquez pour l'obtenir pour votre groupe", {
--                                         RightLabel = "»"
--                                     }, true, function(_, _, Selected)
--                                         if Selected then
--                                             RageUI.CloseAll()

--                                             l.index = tempIndex
--                                             TriggerServerEvent("orgs:monopole:getWeaponMonopole", l)
--                                         end
--                                     end)
--                                 else
--                                     if not l.confirm then
--                                         RageUI.ButtonWithStyle("~c~"..l.name.." ("..l.owners..")", "~r~Vous devez faire une guerre contre le groupe qui possède cette arme pour obtenir son monopole\n\n~s~Si l'arme n'appartient pas à un groupe, vous pouvez l'obtenir sans guerre directement", {
--                                             -- RightBadge = RageUI.BadgeStyle.Lock,
--                                             RightLabel = "~r~APPUYEZ POUR CONTESTER",
--                                         }, true, function(_, _, Selected)
--                                             if Selected then
--                                                 l.confirm = true
--                                             end
--                                         end)
--                                     else
--                                         RageUI.ButtonWithStyle("~c~"..l.name, "~r~Appuyez pour confirmer la guerre", {
--                                             -- RightBadge = RageUI.BadgeStyle.Lock,
--                                             RightLabel = "~r~CONFIRMEZ POUR CONTESTER",
--                                         }, true, function(_, _, Selected)
--                                             if Selected then
--                                                 l.index = tempIndex
--                                                 TriggerServerEvent("orgs:monopole:contest", l)
--                                             end
--                                         end)
--                                     end
--                                 end
--                             else
--                                 if l.byMyGroup then
--                                     RageUI.ButtonWithStyle(l.name, nil, {
--                                         RightLabel = ESX.Math.GroupDigits(l.price).."$"
--                                     }, true, function(_, _, Selected)
--                                         if Selected then
--                                             l.index = tempIndex
--                                             TriggerServerEvent("orgs:monopole:buy", l)
--                                         end
--                                     end)
--                                 else
--                                     RageUI.ButtonWithStyle("~y~"..l.name, "~y~Cette arme n'appartient pas à un groupe, cliquez pour l'obtenir pour votre groupe", {
--                                         RightLabel = "»"
--                                     }, true, function(_, _, Selected)
--                                         if Selected then
--                                             RageUI.CloseAll()

--                                             l.index = tempIndex
--                                             TriggerServerEvent("orgs:monopole:getWeaponMonopole", l)
--                                         end
--                                     end)
--                                 end
--                             end
--                         else
--                             RageUI.ButtonWithStyle(l.name, nil, {
--                                 RightLabel = "»"
--                             }, true, function(_, _, Selected)
--                                 if Selected then
--                                     if v.type == "exchange" then
--                                         TriggerServerEvent(l.event)
--                                     end
--                                 end
--                             end)
--                         end
--                     end
    
--                 end)
--             end

--             -- Menu Gestion des Rangs
--             RageUI.IsVisible(RMenu:Get('members', 'ranks'), true, true, true, function()
--                 -- Bouton pour ajouter un nouveau rang
--                 RageUI.ButtonWithStyle("Ajouter un Nouveau Rang", "Créer un nouveau niveau de rang", {
--                     RightLabel = "~y~+~s~ »",
--                 }, true, function(_, _, Selected)
--                     if Selected then
--                         local rankName = KeyboardInput("Entrez le nom du rang", "", 30)
--                         if rankName and rankName ~= "" then
--                             local success = Utils.TriggerServerCallback('gangs:logic:addNewRank', GANG_PLAYER.GangId, rankName)
--                             if success then
--                                 Notify("success", "Nouveau rang ajouté avec succès !")
--                                 GANG_MEMBERS.RefreshRanks()
--                             else
--                                 Notify("error", "Échec de l'ajout du nouveau rang")
--                             end
--                         end
--                     end
--                 end)

--                 RageUI.Separator(" Rangs Actuels~s~ ")

--                 -- Liste de tous les rangs
--                 for _, rank in pairs(GANG_MEMBERS.Cache.ranks) do
--                     -- Déterminer si le rang peut être édité/supprimé
--                     local canDelete = true
--                     local canRename = true
--                     local description = "Niveau " .. rank.level

--                     -- Vérifier si c'est un rang protégé (leader ou rang le plus bas)
--                     if rank.level == 1 or rank.level == #GANG_MEMBERS.Cache.ranks then
--                         description = description .. "\n~b~Rang protégé (peut être renommé)"
--                         canDelete = false
--                     end

--                     RageUI.ButtonWithStyle(rank.name, description, {
--                         RightLabel = "»",
--                     }, true, function(_, _, Selected)
--                         if Selected then
--                             selectedRank = rank
--                             selectedRank.canDelete = canDelete
--                             selectedRank.canRename = canRename
--                         end
--                     end, RMenu:Get('members', 'edit_rank'))
--                 end
--             end)

--             -- Menu Éditer le Rang
--             RageUI.IsVisible(RMenu:Get('members', 'edit_rank'), true, true, true, function()
--                 if selectedRank then
--                     RageUI.Separator(" " .. selectedRank.name .. " - Niveau " .. selectedRank.level .. " ")

--                     -- Renommer le rang (toujours autorisé)
--                     RageUI.ButtonWithStyle("Renommer le Rang", "Changer le nom du rang", {
--                         RightLabel = "»",
--                     }, true, function(_, _, Selected)
--                         if Selected then
--                             local newName = KeyboardInput("Entrez le nouveau nom du rang", "", 30)
--                             if newName and newName ~= "" then
--                                 local success = Utils.TriggerServerCallback('gangs:logic:updateRankName', GANG_PLAYER.GangId, selectedRank.level, newName)
--                                 if success then
--                                     Notify("success", "Nom du rang mis à jour avec succès !")
--                                     GANG_MEMBERS.RefreshRanks()
--                                     RageUI.GoBack()
--                                 else
--                                     Notify("error", "Échec de la mise à jour du nom du rang")
--                                 end
--                             end
--                         end
--                     end)

--                     -- Move rank position up or down
--                     if selectedRank.level > 1 and selectedRank.level < #GANG_MEMBERS.Cache.ranks then
                        
                        
--                         -- Move rank up (increase level)
--                         RageUI.ButtonWithStyle("↑ Monter le rang", "Augmenter la position du rang dans la hiérarchie", {
--                             RightLabel = "»",
--                         }, true, function(_, _, Selected)
--                             if Selected then
--                                 local success = Utils.TriggerServerCallback('gangs:logic:moveRankPosition', GANG_PLAYER.GangId, selectedRank.level, "up")
--                                 if success then
--                                     Notify("success", "Position du rang modifiée avec succès !")
--                                     GANG_MEMBERS.RefreshRanks()
--                                     RageUI.GoBack()
--                                 else
--                                     Notify("error", "Échec de la modification de la position du rang")
--                                 end
--                             end
--                         end)
                        
--                         -- Move rank down (decrease level)
--                         RageUI.ButtonWithStyle(" Descendre le rang", "Diminuer la position du rang dans la hiérarchie", {
--                             RightLabel = "»",
--                         }, true, function(_, _, Selected)
--                             if Selected then
--                                 local success = Utils.TriggerServerCallback('gangs:logic:moveRankPosition', GANG_PLAYER.GangId, selectedRank.level, "down")
--                                 if success then
--                                     Notify("success", "Position du rang modifiée avec succès !")
--                                     GANG_MEMBERS.RefreshRanks()
--                                     RageUI.GoBack()
--                                 else
--                                     Notify("error", "Échec de la modification de la position du rang")
--                                 end
--                             end
--                         end)
--                     else
--                         -- If rank is at the top or bottom, show disabled buttons
--                         if selectedRank.level == 1 then
                            
--                             RageUI.ButtonWithStyle("~c~↑ Monter le rang", "~c~Ce rang est déjà au niveau le plus bas", {}, false, function() end)
--                         elseif selectedRank.level == #GANG_MEMBERS.Cache.ranks then
                            
--                             RageUI.ButtonWithStyle("~c~ Descendre le rang", "~c~Ce rang est déjà au niveau le plus élevé", {}, false, function() end)
--                         end
--                     end

--                     -- Supprimer le rang (uniquement pour les rangs non protégés)
--                     if selectedRank.canDelete then
                        
--                         RageUI.ButtonWithStyle("~r~Supprimer le Rang", "Retirer ce niveau de rang\nLes membres seront déplacés vers un rang inférieur", {
--                             RightLabel = "~r~»»",
--                         }, #GANG_MEMBERS.Cache.ranks > 2, -- Assurer un minimum de 2 rangs
--                         function(_, _, Selected)
--                             if Selected then
--                                 -- Ajouter une confirmation
--                                 if KeyboardInput("Tapez 'confirm' pour supprimer le rang", "", 7) == "confirm" then
--                                     local success = Utils.TriggerServerCallback('gangs:logic:removeRank', GANG_PLAYER.GangId, selectedRank.level)
--                                     if success then
--                                         Notify("success", "Rang supprimé avec succès !")
--                                         GANG_MEMBERS.RefreshRanks()
--                                         RageUI.GoBack()
--                                     else
--                                         Notify("error", "Échec de la suppression du rang")
--                                     end
--                                 else
--                                     Notify("error", "Suppression du rang annulée")
--                                 end
--                             end
--                         end)
--                     else
                        
--                         RageUI.ButtonWithStyle("~c~Supprimer le Rang", "~c~Ce rang est protégé et ne peut pas être supprimé", {}, false, function() end)
--                     end
--                 end
--             end)

--             -- Menu Recrutement (accessible uniquement par le leader)
--             RageUI.IsVisible(RMenu:Get('members', 'recruit'), true, true, true, function()
--                 RageUI.Separator(" ~y~Joueurs à Proximité~s~ ")

--                 local nearbyPlayers = GANG_MEMBERS.GetNearbyPlayers()
--                 if #nearbyPlayers > 0 then
--                     for _, player in pairs(nearbyPlayers) do
--                         RageUI.ButtonWithStyle(player.name, "ID : " .. player.source, {
--                             RightLabel = "»",
--                         }, true, function(_, _, Selected)
--                             if Selected then
--                                 --local success = Utils.TriggerServerCallback('gangs:members:recruitPlayer', player.source, GANG_PLAYER.GangId)

--                                 TriggerServerEvent('gangs:members:recruitPlayer', player.source, GANG_PLAYER.GangId)
--                                 --if success then
--                                  --   Notify("success", "Joueur recruté avec succès !")
--                                    -- GANG_MEMBERS.RefreshMembers()
--                                -- else
--                                    -- Notify("error", "Échec du recrutement du joueur")
--                                 --end
--                             end
--                         end)
--                     end
--                 else
--                     RageUI.ButtonWithStyle("Aucun joueur à proximité", "", {}, false, function()
--                     end)
--                 end
--             end)

--             -- Menu Actions du Membre (accessible uniquement par le leader)
--             RageUI.IsVisible(RMenu:Get('members', 'member_actions'), true, true, true, function()
--                 if selectedMember then
--                     RageUI.Separator(" " .. selectedMember.name .. " ")

--                     -- Gestion des Rangs
--                     RageUI.Separator(" Gestion des Rangs~s~ ")

--                     for _, rank in ipairs(GANG_MEMBERS.Cache.ranks) do
--                         if rank.level ~= selectedMember.rankLevel then
--                             RageUI.ButtonWithStyle("Définir le rang : " .. rank.name, "Rang actuel : " .. GANG_MEMBERS.GetRankName(selectedMember.rankLevel), {
--                                 RightLabel = "»",
--                             }, true, function(_, _, Selected)
--                                 if Selected then
--                                     local success = Utils.TriggerServerCallback('gangs:members:promotePlayer', tonumber(selectedMember.source) or selectedMember.identifier, rank.level)
--                                     if success then
--                                         Notify("success", "Rang mis à jour avec succès !")
--                                         GANG_MEMBERS.RefreshMembers()
--                                         RageUI.GoBack()
--                                     else
--                                         Notify("error", "Échec de la mise à jour du rang")
--                                     end
--                                 end
--                             end)
--                         end
--                     end

--                     -- Option de renvoi
                    
--                     RageUI.ButtonWithStyle("~r~Expulser du gang", "Cette action est irréversible", {
--                         RightLabel = "~r~»»",
--                     }, true, function(_, _, Selected)
--                         if Selected then
--                             local success = Utils.TriggerServerCallback('gangs:members:kickMember', selectedMember.source or selectedMember.identifier)
--                             if success then
--                                 Notify("success", "Membre expulsé avec succès !")
--                                 GANG_MEMBERS.RefreshMembers()
--                                 RageUI.GoBack()
--                             else
--                                 Notify("error", "Échec de l'expulsion du membre")
--                             end
--                         end
--                     end)

--                     -- Transférer le leadership
--                     if selectedMember.identifier ~= GANG_PLAYER.Data.leader then
                        
--                         RageUI.ButtonWithStyle("Transférer le Leadership", "Transférer le leadership du gang à ce membre", {
--                             RightLabel = "»»",
--                         }, true, function(_, _, Selected)
--                             if Selected then
--                                 local success = Utils.TriggerServerCallback('gangs:members:changeLeader', GANG_PLAYER.GangId, selectedMember.identifier)
--                                 if success then
--                                     Notify("success", "Leadership transféré avec succès !")
--                                     GANG_MEMBERS.RefreshMembers()
--                                     RageUI.CloseAll()
--                                 else
--                                     Notify("error", "Échec du transfert du leadership")
--                                 end
--                             end
--                         end)
--                     end
--                 end
--             end)

--             -- Menu des permissions
--             RageUI.IsVisible(RMenu:Get('members', 'permissions'), true, true, true, function()
--                 if GANG_MEMBERS.Cache.isLeader then
--                     RageUI.Separator(" Paramètres des Permissions~s~ ")

--                     -- Définir les permissions avec descriptions
--                     local permissions = { 
--                         { key = "RECRUIT_MEMBERS", label = "Recruter des Membres", desc = "Rangs requis pour inviter de nouveaux membres" },
--                         { key = "MANAGE_RANKS", label = "Gérer les Rangs", desc = "Rangs requis pour promouvoir/démotiver les membres" },
--                         { key = "MANAGE_VEHICLES", label = "Gérer les Véhicules", desc = "Rangs requis pour gérer les véhicules du gang" },
--                         { key = "ACCESS_STORAGE", label = "Accéder au Stockage", desc = "Rangs requis pour accéder au stockage du gang" },
--                     }

--                     for _, perm in ipairs(permissions) do
--                         local currentRanks = GANG_PLAYER.Data.permissions[perm.key] or {}
--                         local currentRankNames = {}
--                         for _, rankLevel in ipairs(currentRanks) do
--                             table.insert(currentRankNames, GANG_MEMBERS.GetRankName(rankLevel) .. " (Niveau " .. rankLevel .. ")")
--                         end
--                         local currentRanksStr = table.concat(currentRankNames, ", ")

--                         RageUI.ButtonWithStyle(perm.label, string.format("Actuel : %s\n%s", currentRanksStr ~= "" and currentRanksStr or "Aucun", perm.desc), {
--                             RightLabel = "»",
--                         }, true, function(_, _, Selected)
--                             if Selected then
--                                 selectedPermission = perm
--                             end
--                         end, RMenu:Get('members', 'select_rank'))
--                     end

--                     -- Ajouter une section d'information
                    
--                     RageUI.Separator("~b~Information")
--                     RageUI.ButtonWithStyle("À propos des Permissions", "Le leader du gang a toujours toutes les permissions\nLes autres membres ont besoin du rang requis", {}, false, function()
--                     end)
--                 end
--             end)

--             -- Menu Sélectionner le Rang
--             RageUI.IsVisible(RMenu:Get('members', 'select_rank'), true, true, true, function()
--                 if selectedPermission then
--                     RageUI.Separator(" " .. selectedPermission.label .. "~s~ ")
--                     RageUI.Separator(selectedPermission.desc)
                    

--                     local currentRanks = GANG_PLAYER.Data.permissions[selectedPermission.key] or {}

--                     for _, rank in ipairs(GANG_MEMBERS.Cache.ranks) do
--                         -- Ne pas permettre de définir la permission au-dessus du rang leader
--                         if rank.level < #GANG_MEMBERS.Cache.ranks then
--                             local hasPermission = false
--                             for _, r in ipairs(currentRanks) do
--                                 if r == rank.level then
--                                     hasPermission = true
--                                     break
--                                 end
--                             end

--                             local buttonLabel = hasPermission and "Retirer" or "Ajouter"
--                             local buttonColor = hasPermission and "~r~" or "~y~"

--                             RageUI.ButtonWithStyle(
--                                 buttonColor .. rank.name .. " (" .. rank.level .. ")",
--                                 string.format("%s le rang %s à la permission %s", hasPermission and "Retirer" or "Ajouter", rank.name, selectedPermission.label),
--                                 { RightLabel = hasPermission and "Retirer" or "Ajouter" },
--                                 true,
--                                 function(_, _, Selected)
--                                     if Selected then
--                                         if hasPermission then
--                                             -- Retirer le rang de la permission
--                                             for i, r in ipairs(currentRanks) do
--                                                 if r == rank.level then
--                                                     table.remove(currentRanks, i)
--                                                     break
--                                                 end
--                                             end
--                                         else
--                                             -- Ajouter le rang à la permission
--                                             table.insert(currentRanks, rank.level)
--                                         end

--                                         -- Mettre à jour la permission
--                                         local newPermissions = GANG_PLAYER.Data.permissions
--                                         newPermissions[selectedPermission.key] = currentRanks

--                                         local success = Utils.TriggerServerCallback('gangs:admin:updatePermissions', GANG_PLAYER.GangId, newPermissions)
--                                         if success then
--                                             GANG_PLAYER.Data.permissions = newPermissions
--                                             Notify("success", string.format("Permission %s mise à jour : %s le rang %s", selectedPermission.label, hasPermission and "Retiré" or "Ajouté", rank.name))
--                                         else
--                                             Notify("error", "Échec de la mise à jour de la permission")
--                                         end
--                                     end
--                                 end
--                             )
--                         end
--                     end
--                 end
--             end)

--             Wait(0)
--         end
--     end)
-- end

-- Rest of the helper functions remain the same
function GANG_MEMBERS.Close()
    GANG_MEMBERS.IsOpen = false
    RageUI.CloseAll()
end

function GANG_MEMBERS.RefreshRanks()
    local data = Utils.TriggerServerCallback("gangs:members:getPlayerGang")
    if data then
        GANG_PLAYER.GangId = data.gangId
        GANG_PLAYER.Rank = data.rank
        GANG_PLAYER.Data = Utils.TriggerServerCallback("gangs:logic:getGangData", GANG_PLAYER.GangId)
    end
    GANG_MEMBERS.Cache.ranks = GANG_PLAYER.Data.ranks
end

function GANG_MEMBERS.RefreshMembers()
    GANG_MEMBERS.IsLoading = true
    GANG_MEMBERS.Cache.members = Utils.TriggerServerCallback('gangs:members:getAllMembers', GANG_PLAYER.GangId)
    GANG_MEMBERS.IsLoading = false
end

function GANG_MEMBERS.GetRankName(level)
    for _, rank in pairs(GANG_MEMBERS.Cache.ranks) do
        if rank.level == level then
            return rank.name
        end
    end
    return "Unknown"
end

function GANG_MEMBERS.GetNearbyPlayers()
    local players = {}
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)

    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        if targetPed ~= playerPed then
            local targetCoords = GetEntityCoords(targetPed)
            local distance = #(playerCoords - targetCoords)

            if distance <= 5.0 then
                table.insert(players, {
                    source = GetPlayerServerId(player),
                    name = GetPlayerName(player),
                 })
            end
        end
    end

    return players
end

COMMANDS = {
    ["menuOpenned"] = false
}
COMMANDS.openCommand = function()
    local coords = GetEntityCoords(PlayerPedId())

    RMenu.Add('commands', 'main', RageUI.CreateMenu("Fournisseur d'armes", 'Que voulez-vous faire ?', 1, 100))
    RMenu:Get('commands', 'main').Closed = function()
        COMMANDS["menuOpenned"] = false
        
        RMenu:Delete('commands', 'main')
        RMenu:Delete('commands', 'second')
    end

    for _, menuName in pairs({ 'main' }) do
        RMenu:Get('commands', menuName):SetRectangleBanner(255, 220, 0, 140)
    end
    
    if COMMANDS["menuOpenned"] then
        COMMANDS["menuOpenned"] = false
        return
    else
        RageUI.CloseAll()

        COMMANDS["menuOpenned"] = true
        RageUI.Visible(RMenu:Get('commands', 'main'), true)
    end

    local commands = {}
    ESX.TriggerServerCallback("org:getCommands", function(rep)
        commands = rep
    end)

    Citizen.CreateThread(function()
        while COMMANDS["menuOpenned"] do
            Citizen.Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                COMMANDS["menuOpenned"] = false
            end

            RageUI.IsVisible(RMenu:Get('commands', 'main'), true, false, true, function()
                
                if #commands > 0 then
                    for k,v in pairs(commands) do
                        RageUI.ButtonWithStyle("x"..v.count.." "..v.label, nil, {
                            RightLabel = "»»»",
                        }, true, function(_, _, Selected)
                            if Selected then
                                RageUI.CloseAll()
                                COMMANDS["menuOpenned"] = false

                                TriggerServerEvent("org:getCommand", v)
                            end
                        end)
                    end
                else
                    RageUI.Separator("~r~Aucune commande à récupérer")
                end

            end)

        end
    end)
end

RegisterNetEvent("org:sendCommand")
AddEventHandler("org:sendCommand", function(coords)
    local active = true

    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, 586)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, 1)
	SetBlipScale(blip, 0.85)
	SetBlipAsShortRange(blip, false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("~r~Commande GL à récupérer")
    SetBlipRoute(blip, true)
	EndTextCommandSetBlipName(blip)

    Citizen.SetTimeout(60 * 60 * 1000, function()
        RemoveBlip(blip)
        active = false
    end)

    Citizen.CreateThread(function()
        while #(GetEntityCoords(PlayerPedId()) - coords) > 100.0 do
            Citizen.Wait(100)
        end

        local called = false
        local lastCalled = 0
        while active do
            local interval = 1000

            if #(GetEntityCoords(PlayerPedId()) - coords) < 50.0 then
                interval = 0
                DrawMarker(6, coords.x, coords.y, coords.z - 0.95, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
            end

            if #(GetEntityCoords(PlayerPedId()) - coords) < 2.5 then
                if not called then
                    called = true
                    PlaySoundFrontend(-1, 'WEAPON_ATTACHMENT_UNEQUIP', 'HUD_AMMO_SHOP_SOUNDSET', 1)
                end

                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour interagir")

                if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                    lastCalled = GetGameTimer() + 500
                    COMMANDS.openCommand()
                end
            else
                called = false
            end
    
            Citizen.Wait(0)
        end
    end)
end)

RegisterNetEvent("orgs:monopole:startContestInfo")
AddEventHandler("orgs:monopole:startContestInfo", function()
    local active = true

    TriggerEvent("login:monopole:showAlert")
end)

local blipsCreated = {}

RegisterNetEvent("orgs:monopole:contestInfo")
AddEventHandler("orgs:monopole:contestInfo", function(coords)
    local active = true

    local blip = AddBlipForCoord(coords)
    SetBlipSprite(blip, 586)
	SetBlipDisplay(blip, 4)
	SetBlipColour(blip, 1)
	SetBlipScale(blip, 0.85)
	SetBlipAsShortRange(blip, false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("~r~Territoire à défendre")
    SetBlipRoute(blip, true)
	EndTextCommandSetBlipName(blip)

    table.insert(blipsCreated, blip)
end)

RegisterNetEvent("monopoles:removeBlips")
AddEventHandler("monopoles:removeBlips", function()
    for k,v in pairs(blipsCreated) do
        if DoesBlipExist(v) then
            RemoveBlip(v)
        end
    end
end)

-- Prompt de recrutement natif (E = accepter / X = refuser) avec timer
local RecruitPrompt = {
    active    = false,
    expiresAt = 0,   -- anciennement: until
    leader    = nil,
    gangId    = nil
}

local function showHelp(text)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function finishRecruitPrompt(accept)
    if not RecruitPrompt.active then return end
    PlaySoundFrontend(-1, accept and "SELECT" or "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
    TriggerServerEvent("gangs:members:recruitPlayerConfirm", RecruitPrompt.leader, RecruitPrompt.gangId, accept and "oui" or "non")
    RecruitPrompt.active = false
    -- optionnel: nettoie l'aide
    if ClearAllHelpMessages then ClearAllHelpMessages() end
end

RegisterNetEvent("gangs:members:askRecruitPlayer", function(leaderId, gangId)
    -- Si un prompt est déjà affiché, on écrase le précédent proprement
    RecruitPrompt.active = false
    Citizen.Wait(50)

    RecruitPrompt.active    = true
    RecruitPrompt.leader    = leaderId
    RecruitPrompt.gangId    = gangId
    RecruitPrompt.expiresAt = GetGameTimer() + 15000  -- 15s pour répondre

    Citizen.CreateThread(function()
        while RecruitPrompt.active do
            local now  = GetGameTimer()
            local left = math.max(0, math.ceil((RecruitPrompt.expiresAt - now) / 1000))

            if now >= RecruitPrompt.expiresAt then
                -- Temps écoulé -> refus
                finishRecruitPrompt(false)
                break
            end

            -- Aide à l’écran (natif)
            showHelp(("\n~y~Invitation de gang~s~\n~g~E~s~ Accepter   ~r~X~s~ Refuser\n~c~%ds restantes"):format(left))

            -- E = accepter (INPUT_CONTEXT = 38)
            if IsControlJustReleased(0, 38) then
                finishRecruitPrompt(true)
                break
            end
            -- X = refuser (73)
            if IsControlJustReleased(0, 73) then
                finishRecruitPrompt(false)
                break
            end

            Citizen.Wait(0)
        end
    end)
end)