ESX = nil

local SheriffOpen = false

--Menu F6

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    PlayerData = ESX.GetPlayerData()
    grade = PlayerData.job.grade_name

end)

Citizen.CreateThread(function()
	RMenu.Add('menu', 'mainsheriff', RageUI.CreateMenu("PRIME", "Menu BCSO", 1, 100))
	RMenu.Add('menu', 'interactionssheriff', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
	RMenu.Add('menu', 'statussheriff', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
	RMenu.Add('menu', 'renfortsheriff', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
    RMenu.Add('menu', 'identity', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
    RMenu.Add('menu', 'escorter', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
    RMenu.Add('menu', 'mettrevehicule', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
    RMenu.Add('menu', 'sortirvehicule', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
	RMenu.Add('menu', 'braceletsheriff', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
    RMenu.Add('menu', 'bracelet_edit_sheriff', RageUI.CreateSubMenu(RMenu:Get('menu', 'braceletsheriff'), "PRIME", "Menu BCSO"))
    RMenu.Add('menu', 'amende', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
    RMenu.Add('menu', 'factures', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
	RMenu.Add('menu', 'k9sheriff', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
	RMenu.Add('menu', 'k9editSkinsheriff', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
	RMenu.Add('menu', 'k9searchPlayersheriff', RageUI.CreateSubMenu(RMenu:Get('menu', 'mainsheriff'), "PRIME", "Menu BCSO"))
	RMenu:Get('menu', 'mainsheriff'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'interactionssheriff'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'statussheriff'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'renfortsheriff'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'braceletsheriff'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'bracelet_edit_sheriff'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'identity'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'escorter'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'mettrevehicule'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'sortirvehicule'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'amende'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'k9sheriff'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'k9editSkinsheriff'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'k9searchPlayersheriff'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'mainsheriff').EnableMouse = false
    RMenu:Get('menu', 'mainsheriff').Closed = function()
		SheriffOpen = false
    end
	RMenu.Add('menu', 'principal_bcso', RageUI.CreateMenu("PRIME", "Garage BCSO", 1, 100))
	RMenu:Get('menu', 'principal_bcso'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'principal_bcso').EnableMouse = false
    RMenu:Get('menu', 'principal_bcso').Closed = function()
		GarageActif = false
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	PlayerData.job = job
	PlayerData.job.grade_name = grade
end)

function openBCSOMenu()
    if SheriffOpen then
        SheriffOpen = false
        return
    else
        SheriffOpen = true
        RageUI.Visible(RMenu:Get('menu', 'mainsheriff'), true)

        Citizen.CreateThread(function()
            while SheriffOpen do
                RageUI.IsVisible(RMenu:Get('menu', 'mainsheriff'), true, true, true, function()     
					if not userinservice then
						RageUI.ButtonWithStyle("~y~Prise de service", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local info = 'prise'
								local job = 'sheriff'
								TriggerServerEvent('police:PriseEtFinservice', info, job)
								TriggerServerEvent("BCSO:AddPlayer")
								ESX.ShowNotification("~y~Appels activés & service actif !")
								

								userinservice = true
							end
                    	end)
					elseif userinservice then
						RageUI.ButtonWithStyle("~r~Fin de service", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local info = 'fin'
								local job = 'sheriff'
								TriggerServerEvent('police:PriseEtFinservice', info, job)
								TriggerServerEvent("BCSO:RemovePlayer")
								
								ESX.ShowNotification("~r~Appels désactivés & service désactivé !")
								userinservice = false
							end
                    	end)
					end
					if userinservice then
                    	RageUI.ButtonWithStyle("Intéractions", nil, { RightLabel = "→" },true, function()
                    	end, RMenu:Get('menu', 'interactionssheriff'))
						RageUI.ButtonWithStyle("Demande de renfort", nil, { RightLabel = "→" },true, function()
						end, RMenu:Get('menu', 'renfortsheriff'))
                    	RageUI.ButtonWithStyle("Statut de l'agent", nil, { RightLabel = "→" },true, function()
                    	end, RMenu:Get('menu', 'statussheriff'))
						RageUI.ButtonWithStyle("Unité canine", nil, { RightLabel = "→" },true, function()
						end, RMenu:Get('menu', 'k9sheriff'))

						RageUI.ButtonWithStyle("Personnes sous bracelet électronique", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                tempData = {}
                                ESX.TriggerServerCallback("lspd:getBracelets", function(rep)
                                    tempData = rep
                                end)
                            end
                        end, RMenu:Get('menu', 'braceletsheriff'))
					end
                end, function()
                end)

				RageUI.IsVisible(RMenu:Get('menu', 'braceletsheriff'), true, true, true, function()

					for k,v in pairs(tempData) do
						RageUI.ButtonWithStyle(v.identity, "Appuyez sur SUPR pour retirer la personne des bracelets électroniques", {}, true, function(Hovered, Active, Selected)
							if Active then
								if IsControlJustPressed(0, 178) then
									RageUI.GoBack()

									TriggerServerEvent("lspd:bracelet:delete", v.identifier)
								end
							end

							if Selected then
								tempIndex = v
							end
						end, RMenu:Get('menu', 'bracelet_edit_sheriff'))
					end

                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'bracelet_edit_sheriff'), true, true, true, function()

					RageUI.ButtonWithStyle("Faire sonner", "Enverra une notification à la personne pour qu'elle sache qu'elle doit venir au poste", {}, true, function(Hovered, Active, Selected)
						if Selected then
							TriggerServerEvent("lspd:bracelet:sendAlert", tempIndex.identifier)
						end
					end)

					RageUI.ButtonWithStyle("Obtenir la position", nil, {}, true, function(Hovered, Active, Selected)
						if Selected then
							TriggerServerEvent("lspd:bracelet:getPos", tempIndex.identifier)
						end
					end)

                end, function()
				end)
                
                RageUI.IsVisible(RMenu:Get('menu', 'interactionssheriff'), true, true, true, function()                   

					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					RageUI.ButtonWithStyle("Escorter", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							if closestPlayer ~= -1 and closestDistance <= 3.0 then
							TriggerServerEvent('police:drag', GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification('Il n\'y a personne autour !')
							end
							RageUI.CloseAll()
                        	SheriffOpen = false
						end
                    end)
                    RageUI.ButtonWithStyle("Mettre dans un véhicule", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							if closestPlayer ~= -1 and closestDistance <= 3.0 then
							TriggerServerEvent('police:putInVehicle', GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification('Il n\'y a personne autour !')
							end
							RageUI.CloseAll()
                        	SheriffOpen = false
						end
                    end)
                    RageUI.ButtonWithStyle("Sortir d'un véhicule", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							if closestPlayer ~= -1 and closestDistance <= 3.0 then
							TriggerServerEvent('police:OutVehicle', GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification('Il n\'y a personne autour !')
							end
							RageUI.CloseAll()
                        	SheriffOpen = false
						end
                    end)

					RageUI.ButtonWithStyle("Bracelet électronique", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Active) then
							MarquerJoueur()
						end
						if (Selected) then
							if closestPlayer ~= -1 and closestDistance <= 3.0 then
								TriggerServerEvent('lspd:bracelet:add', GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification('Il n\'y a personne autour !')
							end
							RageUI.CloseAll()
                        	PoliceOpen = false
						end
                    end)

                end, function()
				end)
				
				RageUI.IsVisible(RMenu:Get('menu', 'statussheriff'), true, true, true, function()
                    RageUI.ButtonWithStyle("Pause de service", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'pause'
							local job = 'sheriff'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)
					RageUI.ButtonWithStyle("En attente de dispatch", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'standby'
							local job = 'sheriff'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)
					RageUI.ButtonWithStyle("Control routier en cours", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'control'
							local job = 'sheriff'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)
					RageUI.ButtonWithStyle("Délit de fuite en cours", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'refus'
							local job = 'sheriff'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)
					RageUI.ButtonWithStyle("Ajout de carburant", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'carburant'
							local job = 'sheriff'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)
					RageUI.ButtonWithStyle("Accident de la circulation", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'accident'
							local job = 'sheriff'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)           
                end, function()
				end)
				
				RageUI.IsVisible(RMenu:Get('menu', 'renfortsheriff'), true, true, true, function()
					local playerPed = PlayerPedId()
					local coords  = GetEntityCoords(playerPed)
					vehicle = ESX.Game.GetVehicleInDirection()
					local name = GetPlayerName(PlayerId())

					RageUI.ButtonWithStyle("Petite demande", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local raison = 'petit'
							local job = 'sheriff'
							TriggerServerEvent('police:renfort', coords, raison, job)
                        end
                    end)
					RageUI.ButtonWithStyle("Demande inter-police", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local raison = 'petitall'
							local job = 'sheriff'
							TriggerServerEvent('police:renfort', coords, raison, job)
                        end
                    end)
					RageUI.ButtonWithStyle("Demande importante", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local raison = 'importante'
							local job = 'sheriff'
							TriggerServerEvent('police:renfort', coords, raison, job)
						end
                    end)
					RageUI.ButtonWithStyle("Toutes les unités sont demandées !", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local raison = 'omgad'
							local job = 'sheriff'
							TriggerServerEvent('police:renfort', coords, raison, job)
							ExecuteCommand('me appuie sur son red button')
						end
					end)        
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'k9sheriff'), true, false, true, function()
            
					if not DoesEntityExist(K9.dogEntity) then
						RageUI.ButtonWithStyle("Faire venir un chien", nil, {RightLabel = "→→→"}, true, function(h, a, s)
							if s then
								Citizen.CreateThread(function()
									K9.SpawnDog()
								end)
							end
						end)
					else
						RageUI.ButtonWithStyle("Faire partir le chien", nil, {RightLabel = "→→→"}, true, function(h, a, s)
							if s then
								Citizen.CreateThread(function()
									K9.SpawnDog()
								end)
							end
						end)
					end

					if DoesEntityExist(K9.dogEntity) then
						RageUI.ButtonWithStyle("Modifier l'apparence", nil, {RightLabel = "→→→"}, true, function(h, a, s) end, RMenu:Get('menu', 'k9editSkinsheriff'))

						if K9.data.follow == nil then K9.data.follow = false end
						if K9.data.follow then
							RageUI.ButtonWithStyle("Ordonner de suivre", nil, {RightLabel = "→→→"}, true, function(h, a, s)
								if s then
									Citizen.CreateThread(function()
										K9.FollowDog()
									end)
								end
							end)
						else
							RageUI.ButtonWithStyle("Ordonner de ne plus suivre", nil, {RightLabel = "→→→"}, true, function(h, a, s)
								if s then
									Citizen.CreateThread(function()
										K9.FollowDog()
									end)
								end
							end)
						end

						if K9.data.stand == nil then K9.data.stand = false end
						if K9.data.stand then
							RageUI.ButtonWithStyle("Ordonner de se lever", nil, {RightLabel = "→→→"}, true, function(h, a, s)
								if s then
									Citizen.CreateThread(function()
										K9.SitDog()
									end)
								end
							end)
						else
							RageUI.ButtonWithStyle("Ordonner de s'asseoir", nil, {RightLabel = "→→→"}, true, function(h, a, s)
								if s then
									Citizen.CreateThread(function()
										K9.SitDog()
									end)
								end
							end)
						end

						if K9.data.inCar == nil then K9.data.inCar = true end
						if K9.data.inCar then
							RageUI.ButtonWithStyle("Ordonner de monter dans la voiture", nil, {RightLabel = "→→→"}, true, function(h, a, s)
								if s then
									Citizen.CreateThread(function()
										K9.CarDog()
									end)
								end
							end)
						else
							RageUI.ButtonWithStyle("Ordonner de descendre de la voiture", nil, {RightLabel = "→→→"}, true, function(h, a, s)
								if s then
									Citizen.CreateThread(function()
										K9.CarDog()
									end)
								end
							end)
						end

						RageUI.ButtonWithStyle("Ordonner de rechercher de la drogue", nil, {RightLabel = "→→→"}, true, function(h, a, s)
							if s then
								K9.searchType = 'drug'
							end
						end, RMenu:Get('menu', 'k9searchPlayersheriff'))

						RageUI.ButtonWithStyle("Ordonner de rechercher des armes", nil, {RightLabel = "→→→"}, true, function(h, a, s)
							if s then
								K9.searchType = 'weapons'
							end
						end, RMenu:Get('menu', 'k9searchPlayersheriff'))
					end
				
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'k9editSkinsheriff'), true, false, true, function()
            
					RageUI.ButtonWithStyle("Couleur globale", "Appuyez pour modifier", {RightLabel = "→→→"}, true, function(h, a, s)
						if s then
							if K9.currentColor == nil then K9.currentColor = 0 end
							if K9.currentColor + 1 > 4 then K9.currentColor = 0 end

							SetPedComponentVariation(K9.dogEntity, 0, 0, K9.currentColor, 2)
							
							K9.currentColor = K9.currentColor + 1
						end
					end)

					RageUI.ButtonWithStyle("Couleur gilet", "Appuyez pour modifier", {RightLabel = "→→→"}, true, function(h, a, s)
						if s then
							if K9.currentHands == nil then K9.currentHands = 0 end
							if K9.currentHands + 1 > 4 then K9.currentHands = 0 end

							SetPedComponentVariation(K9.dogEntity, 3, 0, K9.currentHands, 2)
							
							K9.currentHands = K9.currentHands + 1
						end
					end)

					RageUI.ButtonWithStyle("Insigne", "Appuyez pour modifier", {RightLabel = "→→→"}, true, function(h, a, s)
						if s then
							if K9.currentSign == nil then K9.currentSign = 0 end
							if K9.currentSign + 1 > 4 then K9.currentSign = 0 end

							SetPedComponentVariation(K9.dogEntity, 8, 0, K9.currentSign, 2)
							
							K9.currentSign = K9.currentSign + 1
						end
					end)
				
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'k9searchPlayersheriff'), true, false, true, function()
            
					for _, player in ipairs(GetActivePlayers()) do
						local dst = GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(player)), GetEntityCoords(PlayerPedId()), true)
						local coords = GetEntityCoords(GetPlayerPed(player))
		
						if dst < 3.0 then
							RageUI.ButtonWithStyle("Joueur #".._, nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
								if Active then
									DrawMarker(20, coords.x, coords.y, coords.z + 1.1, nil, nil, nil, nil, nil, nil, 0.4, 0.4, 0.4, 0, 255, 0, 100, true, true)
								end
								if Selected then
									if K9.searchType == 'drug' then
										K9.SearchDrug()
									end

									if K9.searchType == 'weapons' then
										K9.SearchWeapons()
									end
								end
							end)
						end
					end
				
				end, function()
				end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end


RegisterCommand("F6SHERIFF", function()
	local data = ESX.GetPlayerData()
	if data.job ~= nil and (data.job.name == 'sheriff') then
		if SheriffOpen == false then
			openBCSOMenu()
		end
	end
end, false)

RegisterKeyMapping("F6SHERIFF", "F6 sheriff", "keyboard", "F6")

RegisterNetEvent("bracelet:remove")
AddEventHandler("bracelet:remove", function()
    ESX.TriggerServerCallback("lspd:bracelet:remove", function(rep)
    end)
end)