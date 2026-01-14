ESX = nil

local PoliceOpen = false
local action = false
local OnMenuActive = false
local PoliceOpen = false
local userinservice = false
local EnAction = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Wait(10)
	end

    PlayerData = ESX.GetPlayerData()
    grade = PlayerData.job.grade_name
end)

Citizen.CreateThread(function()
	RMenu.Add('menu', 'firstmenu', RageUI.CreateMenu("PRIME", "Menu LSPD", 1, 100))
	RMenu.Add('menu', 'actions', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
	RMenu.Add('menu', 'actuel', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
	RMenu.Add('menu', 'help', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
    RMenu.Add('menu', 'identity', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
    RMenu.Add('menu', 'escorter', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
    RMenu.Add('menu', 'mettrevehicule', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
    RMenu.Add('menu', 'sortirvehicule', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
    RMenu.Add('menu', 'bracelet', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
    RMenu.Add('menu', 'bracelet_edit_police', RageUI.CreateSubMenu(RMenu:Get('menu', 'bracelet'), "PRIME", "Menu LSPD"))
    RMenu.Add('menu', 'amende', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
    RMenu.Add('menu', 'factures', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
	RMenu.Add('menu', 'k9', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
	RMenu.Add('k9', 'k9editSkin', RageUI.CreateSubMenu(RMenu:Get('menu', 'firstmenu'), "PRIME", "Menu LSPD"))
	RMenu.Add('menu', 'k9searchPlayer', RageUI.CreateSubMenu(RMenu:Get('menu', 'k9'), "PRIME", "Menu LSPD"))
	RMenu:Get('menu', 'firstmenu'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'actions'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'bracelet'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'bracelet_edit_police'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'actuel'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'help'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'k9'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('k9', 'k9editSkin'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'k9searchPlayer'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'firstmenu').EnableMouse = false
    RMenu:Get('menu', 'firstmenu').Closed = function()
		PoliceOpen = false
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

function openLSPDMenu()
    if PoliceOpen then
        PoliceOpen = false
        return
    else
        PoliceOpen = true
        RageUI.Visible(RMenu:Get('menu', 'firstmenu'), true)

        Citizen.CreateThread(function()
            while PoliceOpen do
                RageUI.IsVisible(RMenu:Get('menu', 'firstmenu'), true, true, true, function()
					if not userinservice then
						RageUI.ButtonWithStyle("~y~Prise de service", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local info = 'prise'
								local job = 'police'
								TriggerServerEvent('police:PriseEtFinservice', info, job)
								TriggerServerEvent("LSPD:AddPlayer")
								ESX.ShowNotification("~y~Appels activés & service actif !")
								
								userinservice = true
							end
                    	end)
					elseif userinservice then
						RageUI.ButtonWithStyle("~r~Fin de service", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local info = 'fin'
								local job = 'police'
								TriggerServerEvent('police:PriseEtFinservice', info, job)
								TriggerServerEvent("LSPD:RemovePlayer")
								ESX.ShowNotification("~r~Appels désactivés & service désactivé !")
								
								userinservice = false
							end
                    	end)
					end
					if userinservice then
                    	RageUI.ButtonWithStyle("Intéractions", nil, { RightLabel = "→" },true, function()
                    	end, RMenu:Get('menu', 'actions'))
						RageUI.ButtonWithStyle("Demande de renfort", nil, { RightLabel = "→" },true, function()
						end, RMenu:Get('menu', 'help'))
                    	RageUI.ButtonWithStyle("Statut de l'agent", nil, { RightLabel = "→" },true, function()
                    	end, RMenu:Get('menu', 'actuel'))
						RageUI.ButtonWithStyle("Unité canine", nil, { RightLabel = "→" },true, function()
						end, RMenu:Get('menu', 'k9'))

						RageUI.ButtonWithStyle("Personnes sous bracelet électronique", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                tempData = {}
                                ESX.TriggerServerCallback("lspd:getBracelets", function(rep)
                                    tempData = rep
                                end)
                            end
                        end, RMenu:Get('menu', 'bracelet'))
					end
                end, function()
                end)

				RageUI.IsVisible(RMenu:Get('menu', 'bracelet'), true, true, true, function()
					if tempData then 
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
							end, RMenu:Get('menu', 'bracelet_edit_police'))
						end
					end
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'bracelet_edit_police'), true, true, true, function()

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
                RageUI.IsVisible(RMenu:Get('menu', 'actions'), true, true, true, function()                   

					local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

					RageUI.ButtonWithStyle("Escorter", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Active) then
							MarquerJoueur()
						end
						if (Selected) then
							if closestPlayer ~= -1 and closestDistance <= 3.0 then
								TriggerServerEvent('police:drag', GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification('Il n\'y a personne autour !')
							end
							RageUI.CloseAll()
                        	PoliceOpen = false
						end
                    end)
                    RageUI.ButtonWithStyle("Mettre dans un véhicule", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Active) then
							MarquerJoueur()
						end
						if (Selected) then
							if closestPlayer ~= -1 and closestDistance <= 3.0 then
								TriggerServerEvent('police:putInVehicle', GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification('Il n\'y a personne autour !')
							end
							RageUI.CloseAll()
                        	PoliceOpen = false
						end
                    end)
                    RageUI.ButtonWithStyle("Sortir d'un véhicule", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Active) then
							MarquerJoueur()
						end
						if (Selected) then
							if closestPlayer ~= -1 and closestDistance <= 3.0 then
								TriggerServerEvent('police:OutVehicle', GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification('Il n\'y a personne autour !')
							end
							RageUI.CloseAll()
                        	PoliceOpen = false
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
				
				RageUI.IsVisible(RMenu:Get('menu', 'actuel'), true, true, true, function()
                    RageUI.ButtonWithStyle("Pause de service", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'pause'
							local job = 'police'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)
					RageUI.ButtonWithStyle("En attente de dispatch", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'standby'
							local job = 'police'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)
					RageUI.ButtonWithStyle("Control routier en cours", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'control'
							local job = 'police'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)
					RageUI.ButtonWithStyle("Délit de fuite en cours", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'refus'
							local job = 'police'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)
					RageUI.ButtonWithStyle("Ajout de carburant", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'carburant'
							local job = 'police'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)
					RageUI.ButtonWithStyle("Accident de la circulation", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local info = 'accident'
							local job = 'police'
							TriggerServerEvent('police:PriseEtFinservice', info, job)
						end
					end)
                end, function()
				end)
				
				RageUI.IsVisible(RMenu:Get('menu', 'help'), true, true, true, function()

					RageUI.ButtonWithStyle("Petite demande", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local raison = 'petit'
							local coords  = GetEntityCoords(playerPed)
							local job = 'police'
							TriggerServerEvent('police:renfort', coords, raison, job)
                        end
                    end)
					RageUI.ButtonWithStyle("Demande inter-police", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            local raison = 'petitall'
							local job = 'police'
							TriggerServerEvent('police:renfort', coords, raison, job)
                        end
                    end)
					RageUI.ButtonWithStyle("Demande importante", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local raison = 'importante'
							local coords  = GetEntityCoords(playerPed)
							local job = 'police'
							TriggerServerEvent('police:renfort', coords, raison, job)
						end
                    end)
					RageUI.ButtonWithStyle("Toutes les unités sont demandées !", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local raison = 'omgad'
							local coords  = GetEntityCoords(playerPed)
							local job = 'police'
							TriggerServerEvent('police:renfort', coords, raison, job)
							ExecuteCommand('me appuie sur son red button')
						end
					end)        
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'k9'), true, false, true, function()
            
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
						RageUI.ButtonWithStyle("Modifier l'apparence", nil, {RightLabel = "→→→"}, true, function(h, a, s) end, RMenu:Get('k9', 'k9editSkin'))

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
						end, RMenu:Get('menu', 'k9searchPlayer'))

						RageUI.ButtonWithStyle("Ordonner de rechercher des armes", nil, {RightLabel = "→→→"}, true, function(h, a, s)
							if s then
								K9.searchType = 'weapons'
							end
						end, RMenu:Get('menu', 'k9searchPlayer'))
					end
				
				end, function()
				end)

				RageUI.IsVisible(RMenu:Get('k9', 'k9editSkin'), true, false, true, function()
            
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

				RageUI.IsVisible(RMenu:Get('menu', 'k9searchPlayer'), true, false, true, function()
            
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

Citizen.CreateThread(function()
    while true do
		local isPolice = false

		if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'police') then
			isPolice = true
			if IsControlJustPressed(0, 167) then
				if PoliceOpen == false then
					openLSPDMenu()
				end
			end
		end

		if isPolice then
			Wait(0)
		else
			Wait(2500)
		end
    end
end)
RegisterCommand("f6POLICE", function()
	local data = ESX.GetPlayerData()
	if data.job ~= nil and (data.job.name == 'police') then
		if PoliceOpen == false then
			openLSPDMenu()
		end
	end
end, false)

RegisterKeyMapping("f6POLICE", "F6 Police", "keyboard", "F6")

function MarquerJoueur()
        local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
        local pos = GetEntityCoords(ped)
        local target, distance = ESX.Game.GetClosestPlayer()
        if distance <= 4.0 then
        DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 1, nil, nil, 0)
    end
end

RegisterNetEvent("bracelet:remove")
AddEventHandler("bracelet:remove", function()
    ESX.TriggerServerCallback("lspd:bracelet:remove", function(rep)
    end)
end)

RegisterNetEvent("lspd:bracelet:sendPos")
AddEventHandler("lspd:bracelet:sendPos", function(coords)
	ESX.ShowNotification("~r~Un agent vous a localisé grâce à votre bracelet électronique !")
    local alpha = 250
    local alpha2 = 170
    local info = AddBlipForCoord(coords)
    local info2 = AddBlipForCoord(coords)
    
    SetBlipSprite(info, 161)
    SetBlipDisplay(info, 4)
    SetBlipColour(info, 30)
    SetBlipScale(info, 1.0)
    SetBlipAsShortRange(info, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("")
    EndTextCommandSetBlipName(info)

    SetBlipSprite(info2, 280)
    SetBlipDisplay(info2, 4)
    SetBlipColour(info2, 30)
    SetBlipScale(info2, 0.75)
    SetBlipAsShortRange(info2, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("")
    EndTextCommandSetBlipName(info2)

	while alpha ~= 0 do
		Citizen.Wait(50 * 4)
		alpha = alpha - 1
		SetBlipAlpha(info, alpha)
		SetBlipAlpha(info2, alpha)

		if alpha == 0 then
			RemoveBlip(info)
			RemoveBlip(info2)
			return
		end
	end
end)

RegisterNetEvent("lspd:bracelet:sendAlert")
AddEventHandler("lspd:bracelet:sendAlert", function()
    for i=1, 5 do
        PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", false)
        Citizen.Wait(150)
    end
    ESX.ShowNotification("~r~Un agent vous a localisé grâce à votre bracelet électronique !")
end)