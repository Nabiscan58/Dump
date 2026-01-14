local CurrentAction, CurrentActionMsg, CurrentActionData = nil, '', {}
local HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum
local IsBusy = false
local spawnedVehicles, isInShopMenu = {}, false
local enService = false
local EMSF6OPEN = false

local Melee = { -1569615261, 1737195953, 1317494643, -1786099057, 1141786504, -2067956739, -868994466 }
local Knife = { -1716189206, 1223143800, -1955384325, -1833087301, 910830060, }
local Bullet = { 453432689, 1593441988, 584646201, -1716589765, 324215364, 736523883, -270015777, -1074790547, -2084633992, -1357824103, -1660422300, 2144741730, 487013001, 2017895192, -494615257, -1654528753, 100416529, 205991906, 1119849093 }
local Animal = { -100946242, 148160082 }
local FallDamage = { -842959696 }
local Explosion = { -1568386805, 1305664598, -1312131151, 375527679, 324506233, 1752584910, -1813897027, 741814745, -37975472, 539292904, 341774354, -1090665087 }
local Gas = { -1600701090 }
local Burn = { 615608432, 883325847, -544306709 }
local Drown = { -10959621, 1936677264 }
local Car = { 133987706, -1553120962 }

local lib1_char_a, lib2_char_a, lib1_char_b, lib2_char_b, anim_start, anim_pump, anim_success = 'mini@cpr@char_a@cpr_def', 'mini@cpr@char_a@cpr_str', 'mini@cpr@char_b@cpr_def', 'mini@cpr@char_b@cpr_str', 'cpr_intro', 'cpr_pumpchest', 'cpr_success'
 
Citizen.CreateThread(function()
	RequestAnimDict(lib1_char_a)
	RequestAnimDict(lib2_char_a)
	RequestAnimDict(lib1_char_b)
	RequestAnimDict(lib2_char_b)
end)

Citizen.CreateThread(function()
	RMenu.Add('menu', 'emsmenu', RageUI.CreateMenu("PRIME", "Menu EMS", 1, 100))
	RMenu.Add('menu', 'actionsems', RageUI.CreateSubMenu(RMenu:Get('menu', 'emsmenu'), "PRIME", "Menu EMS"))
	RMenu.Add('menu', 'facturationems', RageUI.CreateSubMenu(RMenu:Get('menu', 'emsmenu'), "PRIME", "Menu EMS"))
	RMenu.Add('menu', 'serviceems', RageUI.CreateSubMenu(RMenu:Get('menu', 'emsmenu'), "PRIME", "Menu EMS"))
	RMenu.Add('menu', 'annoncesems', RageUI.CreateSubMenu(RMenu:Get('menu', 'emsmenu'), "PRIME", "Menu EMS"))
    RMenu:Get('menu', 'emsmenu'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'actionsems'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'facturationems'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'serviceems'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'annoncesems'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'emsmenu').EnableMouse = false
    RMenu:Get('menu', 'emsmenu').Closed = function()
		EMSF6OPEN = false
    end
end)

local EnService = false

function OpenMobileAmbulanceActionsMenu()
    if EMSF6OPEN then
        EMSF6OPEN = false
        return
    else
        EMSF6OPEN = true
        RageUI.Visible(RMenu:Get('menu', 'emsmenu'), true)

        Citizen.CreateThread(function()
            while EMSF6OPEN do
				DisableControlAction(0, 167)
                RageUI.IsVisible(RMenu:Get('menu', 'emsmenu'), true, true, true, function()     
                    RageUI.ButtonWithStyle("Intéractions Citoyen", nil, { RightLabel = "→→→" },true, function()
					end, RMenu:Get('menu', 'actionsems'))
					RageUI.ButtonWithStyle("Facturation", nil, { RightLabel = "→→→" },true, function()
					end, RMenu:Get('menu', 'facturationems'))
					RageUI.ButtonWithStyle("Service", nil, { RightLabel = "→→→" },true, function()
					end, RMenu:Get('menu', 'serviceems'))

					if ESX.GotPerm("message") then
						RageUI.ButtonWithStyle("Annonces", nil, { RightLabel = "→→→" },true, function()
						end, RMenu:Get('menu', 'annoncesems'))
					end

					RageUI.ButtonWithStyle("Appels", nil, { RightLabel = "→→→" },true, function(Hovered, Active, Selected)
						if Selected then
							RageUI.CloseAll()
							EMSF6OPEN = false
							EMSCallsClosed = false
							ExecuteCommand("emsmenu")
						end
					end)
                end, function()
                end)

				RageUI.IsVisible(RMenu:Get('menu', 'emscallsmenu'), true, true, true, function()
					RageUI.ButtonWithStyle("Vider les appels sur le GPS", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ESX.ShowNotification("Vous avez vidé tous les appels actifs sur votre gps.")
							enService = false
                        end
					end)
                end, function()
                end)
				
				RageUI.IsVisible(RMenu:Get('menu', 'actionsems'), true, true, true, function()
					RageUI.ButtonWithStyle("Cause du coma", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Active) then
							MarquerJoueur()
						end
						if (Selected) then
							local player = GetPlayerPed(ESX.Game.GetClosestPlayer())
							local closestPlayer = ESX.Game.GetClosestPlayer()
							if closestPlayer ~= -1 then
								local playerPed = GetPlayerPed(closestPlayer)
								if playerPed then
									local serverId = GetPlayerServerId(closestPlayer)
									loadAnimDict("amb@medic@standing@kneel@base")
									loadAnimDict("anim@gangops@facility@servers@bodysearch@")

									TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base" ,"base" ,8.0, -8.0, -1, 1, 0, false, false, false )
									TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@" ,"player_search" ,8.0, -8.0, -1, 48, 0, false, false, false )

									Citizen.Wait(4000)

									ClearPedTasksImmediately(PlayerPedId())
				
									TriggerServerEvent("ambulance:GetCauseOffDeath", serverId)  -- Envoyer l'ID au serveur pour traiter
								end
							end
						end
					end)

					RageUI.ButtonWithStyle("Réanimation", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 4.0 then
								ESX.ShowNotification(_U('no_players'))
							else
								IsBusy = true
								local closestPlayerPed = GetPlayerPed(closestPlayer)
								local oPlayerId = GetPlayerServerId(closestPlayer)
								local playerPed = PlayerPedId()
								ESX.ShowNotification(_U('revive_inprogress'))
								TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')

								TriggerServerEvent("ambulance:requestCPR", oPlayerId, GetEntityHeading(closestPlayerPed), GetEntityCoords(closestPlayerPed), GetEntityForwardVector(closestPlayerPed))

								ClearPedTasksImmediately(playerPed)
								ClearPedTasks(playerPed)

								local cpr = true

								Citizen.CreateThread(function()
									while cpr do
										Citizen.Wait(0)
										DisableAllControlActions(0)
										EnableControlAction(0, 306, true)
										EnableControlAction(0, 1, true)
									end
								end)

								SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
								Wait(2000)
								TaskPlayAnim(playerPed, lib1_char_a, anim_start, 8.0, 8.0, -1, 0, 0, false, false, false)
								Citizen.Wait(15800 - 900)
								for i=1, 15, 1 do
									Citizen.Wait(900)
									TaskPlayAnim(playerPed, lib2_char_a, anim_pump, 8.0, 8.0, -1, 0, 0, false, false, false)
								end

								cpr = false
								TaskPlayAnim(playerPed, lib2_char_a, anim_success, 8.0, 8.0, -1, 0, 0, false, false, false)
								Citizen.Wait(23000)
								TriggerServerEvent('rems:emsRevive', oPlayerId, GetEntityCoords(PlayerPedId()))
								ClearPedTasksImmediately(playerPed)
								ClearPedTasks(playerPed)

								rea = false
								TriggerEvent("zeub")
								RemoveBlip(emsBlip)
								RemoveBlip(emsBlip2)
								local oPlayer = GetPlayerFromServerId(oPlayerId)
								local oPed = GetPlayerPed(oPlayer)
								local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
								SetEntityCoords(oPed, offset, 0)
								IsBusy = false
							end
						end
					end)
					RageUI.ButtonWithStyle("Chirurgie", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					
							if closestPlayer == -1 or closestDistance > 4.0 then
								ESX.ShowNotification(_U('no_players'))
							else

								if IsPlayerDead(closestPlayer) then
									IsBusy = true
									local closestPlayerPed = GetPlayerPed(closestPlayer)
									local oPlayerId = GetPlayerServerId(closestPlayer)
									local playerPed = PlayerPedId()
									ESX.ShowNotification(_U('revive_inprogress'))
									TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
						
									-- Request CPR on the server
									TriggerServerEvent("ambulance:requestCPR", oPlayerId, GetEntityHeading(closestPlayerPed), GetEntityCoords(closestPlayerPed), GetEntityForwardVector(closestPlayerPed))
						
									ClearPedTasksImmediately(playerPed)
									ClearPedTasks(playerPed)
						
									local cpr = true
						
									Citizen.CreateThread(function()
										while cpr do
											Citizen.Wait(0)
											DisableAllControlActions(0)
											EnableControlAction(0, 306, true)
											EnableControlAction(0, 1, true)
										end
									end)
						
									SetCurrentPedWeapon(playerPed, GetHashKey("WEAPON_UNARMED"), true)
						
									-- Final animation that revives the player
									cpr = false
									TaskPlayAnim(playerPed, "mini@cpr@char_a@cpr_str", "cpr_pumpchest", 8.0, 8.0, -1, 1, 0, false, false, false)
									Citizen.Wait(30000) -- Wait 30 seconds for the revive animation
						
									-- Trigger revive event
									TriggerServerEvent('rems:emsRevive', oPlayerId, GetEntityCoords(PlayerPedId()))
									TriggerServerEvent('rems:givePlatre', oPlayerId, 10, true)
									ClearPedTasksImmediately(playerPed)
									ClearPedTasks(playerPed)
						
									-- Finalize
									rea = false
									TriggerEvent("zeub")
									RemoveBlip(emsBlip)
									RemoveBlip(emsBlip2)
									local oPlayer = GetPlayerFromServerId(oPlayerId)
									local oPed = GetPlayerPed(oPlayer)
									local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
									SetEntityCoords(oPed, offset, 0)
									IsBusy = false
								else
									ESX.ShowNotification("~r~La personne n'est pas morte")
								end
							end
						end
					end)

					RageUI.ButtonWithStyle("Ajouter un platre", "Ajoutera un platre à la personne la plus proche pendant 10 minutes", {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
					
							if closestPlayer == -1 or closestDistance > 4.0 then
								ESX.ShowNotification(_U('no_players'))
							else
								local oPlayerId = GetPlayerServerId(closestPlayer)
								local time = 10
								ESX.ShowNotification(("Vous avez donné un plâtre de %s minutes à l'ID %s"):format(10, oPlayerId))
								TriggerServerEvent("rems:givePlatre", oPlayerId, 10, false)
							end
						end
					end)
					
					RageUI.ButtonWithStyle("Soigner des blessures mineures", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 4.0 then
								ESX.ShowNotification(_U('no_players'))
							else
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
	
										if health > 0 then
											local playerPed = PlayerPedId()

											IsBusy = true
											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
	
											TriggerServerEvent('esx_ambulancejob:removeItem', 'bandage')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'small')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_bandage'))
									end
								end, 'bandage')
							end
						end
					end)

					RageUI.ButtonWithStyle("Soigner des blessures graves", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 4.0 then
								ESX.ShowNotification(_U('no_players'))
							else	
								ESX.TriggerServerCallback('esx_ambulancejob:getItemAmount', function(quantity)
									if quantity > 0 then
										local closestPlayerPed = GetPlayerPed(closestPlayer)
										local health = GetEntityHealth(closestPlayerPed)
	
										if health > 0 then
											local playerPed = PlayerPedId()
	
											IsBusy = true
											ESX.ShowNotification(_U('heal_inprogress'))
											TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
											Citizen.Wait(10000)
											ClearPedTasks(playerPed)
	
											TriggerServerEvent('esx_ambulancejob:removeItem', 'medikit')
											TriggerServerEvent('esx_ambulancejob:heal', GetPlayerServerId(closestPlayer), 'big')
											ESX.ShowNotification(_U('heal_complete', GetPlayerName(closestPlayer)))
											IsBusy = false
										else
											ESX.ShowNotification(_U('player_not_conscious'))
										end
									else
										ESX.ShowNotification(_U('not_enough_medikit'))
									end
								end, 'medikit')
							end
						end
					end)

					RageUI.ButtonWithStyle("Mettre dans un véhicule", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
							local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

							if closestPlayer == -1 or closestDistance > 4.0 then
								ESX.ShowNotification(_U('no_players'))
							else
								TriggerServerEvent('esx_ambulancejob:putInVehicle', GetPlayerServerId(closestPlayer))
							end
                        end
					end)

					RageUI.ButtonWithStyle("Sortir une chaise roulante", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							local ped = PlayerPedId()
							local PlayerCoords = GetEntityCoords(ped)
							ESX.Game.SpawnVehicle("wheelchair", PlayerCoords, 180.0, function(vehicle)
								SetVehicleNumberPlateText(vehicle, "WHEELC")
							end)
						end
					end)

                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'facturationems'), true, true, true, function()
                    RageUI.ButtonWithStyle("Envoyer une facture", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
							TriggerEvent("esx_billing:sendBill", "society_ems")
							RageUI.CloseAll()
                        	EMSF6OPEN = false
                        end
					end)
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'serviceems'), true, true, true, function()
                    RageUI.ButtonWithStyle("Prise/Fin de service", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							if not EnService then
								EnService = true
								ESX.ShowNotification("Prise de service, vous allez maintenant recevoir les demandes de réanimation")
								TriggerServerEvent("EMS:AddPlayer")

								enService = true
							else
								ESX.ShowNotification("Service terminé")
								EnService = false
								TriggerServerEvent("EMS:RemovePlayer")
								enService = false
							end
                        end
					end)

					RageUI.ButtonWithStyle("Vider les appels sur le GPS", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ESX.ShowNotification("Vous avez vidé tous les appels actifs sur votre gps.")
							enService = false
                        end
					end)
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'annoncesems'), true, true, true, function()                   

                    RageUI.ButtonWithStyle("EMS disponible", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerServerEvent('AnnounceEMSOuvert')
                        end
					end)
					RageUI.ButtonWithStyle("EMS indisponible", nil, {}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                            TriggerServerEvent('AnnounceEMSFerme')
                        end
					end)
                end, function()
				end)

                Wait(0)
            end
        end, function()
        end, 1)
    end
end

-- Draw markers & Marker logic
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local letSleep, isInMarker, hasExited = true, false, false
		local currentHospital, currentPart, currentPartNum

		for hospitalNum,hospital in pairs(Config.Hospitals) do

			-- Pharmacies
			for k,v in ipairs(hospital.Pharmacies) do
				local distance = GetDistanceBetweenCoords(playerCoords, v, true)

				if distance < Config.DrawDistance then
					DrawMarker(20, v, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 0, 255, 17, Config.Marker.a, true, true, 2, Config.Marker.rotate, nil, nil, false)
					letSleep = false
				end

				if distance < Config.Marker.x then
					isInMarker, currentHospital, currentPart, currentPartNum = true, hospitalNum, 'Pharmacy', k
				end
			end

		end

		-- Logic for exiting & entering markers
		if isInMarker and not HasAlreadyEnteredMarker or (isInMarker and (LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)) then

			if
				(LastHospital ~= nil and LastPart ~= nil and LastPartNum ~= nil) and
				(LastHospital ~= currentHospital or LastPart ~= currentPart or LastPartNum ~= currentPartNum)
			then
				TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
				hasExited = true
			end

			HasAlreadyEnteredMarker, LastHospital, LastPart, LastPartNum = true, currentHospital, currentPart, currentPartNum

			TriggerEvent('esx_ambulancejob:hasEnteredMarker', currentHospital, currentPart, currentPartNum)

		end

		if not hasExited and not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_ambulancejob:hasExitedMarker', LastHospital, LastPart, LastPartNum)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('esx_ambulancejob:hasEnteredMarker', function(hospital, part, partNum)
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ems' then
		if part == 'AmbulanceActions' then
			CurrentAction = part
			CurrentActionMsg = _U('actions_prompt')
			CurrentActionData = {}
		elseif part == 'Pharmacy' then
			CurrentAction = part
			CurrentActionMsg = _U('open_pharmacy')
			CurrentActionData = {}
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then

				if CurrentAction == 'Pharmacy' then
					OpenPharmacyMenu()
				elseif CurrentAction == 'Vehicles' then
					OpenVehicleSpawnerMenu(CurrentActionData.hospital, CurrentActionData.partNum)
				elseif CurrentAction == 'Helicopters' then
					OpenHelicopterSpawnerMenu(CurrentActionData.hospital, CurrentActionData.partNum)
				elseif CurrentAction == 'FastTravelsPrompt' then
					FastTravel(CurrentActionData.to, CurrentActionData.heading)
				end

				CurrentAction = nil

			end
		else
			Citizen.Wait(500)
		end
	end
end)
RegisterCommand("F6EMS", function()
	local data = ESX.GetPlayerData()
	if data.job ~= nil and (data.job.name == 'ems') and not IsDead then
		OpenMobileAmbulanceActionsMenu()
	end
end, false)
RegisterKeyMapping("F6EMS", "F6 Ems", "keyboard", "F6")

RegisterNetEvent('esx_ambulancejob:putInVehicle')
AddEventHandler('esx_ambulancejob:putInVehicle', function()
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	if IsAnyVehicleNearPoint(coords, 5.0) then
		local vehicle = GetClosestVehicle(coords, 5.0, 0, 71)

		if DoesEntityExist(vehicle) then
			local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

			for i=maxSeats - 1, 0, -1 do
				if IsVehicleSeatFree(vehicle, i) then
					freeSeat = i
					break
				end
			end

			if freeSeat then
				TaskWarpPedIntoVehicle(playerPed, vehicle, freeSeat)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if isInShopMenu then
			DisableControlAction(0, 75, true)  -- Disable exit vehicle
			DisableControlAction(27, 75, true) -- Disable exit vehicle
		else
			Citizen.Wait(500)
		end
	end
end)

Citizen.CreateThread(function()
	RMenu.Add('menu', 'emsobjects', RageUI.CreateMenu("PRIME", "Menu EMS", 1, 100))
	RMenu.Add('menu', 'objetsems', RageUI.CreateSubMenu(RMenu:Get('menu', 'emsobjects'), "PRIME", "Menu EMS"))
    RMenu:Get('menu', 'emsobjects'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'objetsems'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'emsobjects').EnableMouse = false
    RMenu:Get('menu', 'emsobjects').Closed = function()
		EMSF6OPEN = false
    end
end)

function OpenPharmacyMenu()
    if EMSF6OPEN then
        EMSF6OPEN = false
        return
    else
        EMSF6OPEN = true
        RageUI.Visible(RMenu:Get('menu', 'emsobjects'), true)

        Citizen.CreateThread(function()
            while EMSF6OPEN do
                RageUI.IsVisible(RMenu:Get('menu', 'emsobjects'), true, true, true, function()     
                    RageUI.ButtonWithStyle("Objets", nil, { RightLabel = "→" },true, function()
					end, RMenu:Get('menu', 'objetsems'))
                end, function()
                end)
				
				RageUI.IsVisible(RMenu:Get('menu', 'objetsems'), true, true, true, function()

                    RageUI.ButtonWithStyle("Medikit", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							TriggerServerEvent('esx_ambulancejob:giveItem', 'medikit')
						end
					end)
					RageUI.ButtonWithStyle("Bandage", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							TriggerServerEvent('esx_ambulancejob:giveItem', 'bandage')
						end
					end)
					RageUI.ButtonWithStyle("Donut", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							TriggerServerEvent('esx_ambulancejob:giveItem', 'donut')
						end
					end)
					RageUI.ButtonWithStyle("Eau", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
						if (Selected) then
							TriggerServerEvent('esx_ambulancejob:giveItem', 'eau')
						end
					end)
			
                end, function()
				end)

                Wait(0)
            end
        end, function()
        end, 1)
    end
end

RegisterNetEvent('esx_ambulancejob:heal')
AddEventHandler('esx_ambulancejob:heal', function(healType, quiet)
	local playerPed = PlayerPedId()
	local maxHealth = GetEntityMaxHealth(playerPed)

	if healType == 'small' then
		local health = GetEntityHealth(playerPed)
		local newHealth = math.min(maxHealth, math.floor(health + maxHealth / 10))
		SetEntityHealth(playerPed, newHealth)
	elseif healType == 'big' then
		SetEntityHealth(playerPed, maxHealth)
	end

	if not quiet then
		ESX.ShowNotification(_U('healed'))
	end
end)

function checkArray(array, val)
	for name, value in ipairs(array) do
		if value == val then
			return true
		end
	end
	return false
end

function MarquerJoueur()
	local ped = GetPlayerPed(ESX.Game.GetClosestPlayer())
	local pos = GetEntityCoords(ped)
	local target, distance = ESX.Game.GetClosestPlayer()
	if distance <= 4.0 then
		DrawMarker(2, pos.x, pos.y, pos.z+1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 255, 0, 170, 0, 1, 2, 1, nil, nil, 0)
	end
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(1)
	end
end

local brancard = {
	{x = -681.09954833984, y = 334.27978515625, z = 77.122573852539}
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(brancard) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, brancard[k].x, brancard[k].y, brancard[k].z)

			if dist <= 3.0 then
				nearThing = true
				if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'ems') then
					DrawMarker(6, brancard[k].x, brancard[k].y, brancard[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
					ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour sortir un brancard")
					if IsControlJustPressed(1, 51) then
						TriggerEvent("ARPF-EMS:spawnStr")
					end
				end
			end
		end

		if nearThing then
			Wait(0)
		else
			Wait(250)
		end
	end
end)

RegisterNetEvent("rems:platre")
AddEventHandler("rems:platre", function(time)
    ESX.ShowNotification("Vous avez un plâtre pendant les "..time.." prochaines minutes.")
    local duration = time * 60 * 1000
    local endTime = GetGameTimer() + duration
    Citizen.CreateThread(function()
        while GetGameTimer() < endTime do
            local playerPed = PlayerPedId()
            local tshirtIndex = GetPedDrawableVariation(playerPed, 8)
			local sex = GetEntityModel(playerPed) == GetHashKey("mp_m_freemode_01")
			if sex then 
				SetPedComponentVariation(playerPed, 8, 354, 0, 2)
			else
				SetPedComponentVariation(playerPed, 5, 200, 0, 2)
			end

			SetCurrentPedWeapon(PlayerPedId(), GetHashKey("WEAPON_UNARMED"), true)

            Citizen.Wait(1000)
        end
		ESX.ShowNotification("~g~Vous n'avez plus de platre")

        local playerPed = PlayerPedId()
        SetPedComponentVariation(playerPed, 8, 15, 0, 2)
    end)
end)

RegisterNetEvent("rems:reset")
AddEventHandler("rems:reset", function()
	local playerPed = PlayerPedId()
	SetPedComponentVariation(playerPed, 8, 15, 0, 2)
end)

Citizen.CreateThread(function()
	Citizen.Wait(5 * 1000)
	TriggerServerEvent("rems:infoPlatre")
end)