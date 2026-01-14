local AppelPris = false
local AppelDejaPris = false
local AppelEnAttente = false 
local AppelCoords = nil

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
	ESX.PlayerData.job.grade_name = grade
end)

RegisterNetEvent("AppelemsGetCoords")
AddEventHandler("AppelemsGetCoords", function()
	local ped = PlayerPedId()
	local coords = GetEntityCoords(ped, true)
	local idJoueur = GetPlayerServerId(GetPlayerIndex())
	TriggerServerEvent("Server:emsAppel", coords, idJoueur)
end)

local TableDemandeAppel = {}

RegisterNetEvent("rEMS:AppelEMS")
AddEventHandler("rEMS:AppelEMS", function(coords, id, idAppel, date)
    local serverIdExiste = false

    for _, appel in ipairs(TableDemandeAppel) do
        if appel.ServerId == id then
            serverIdExiste = true
            break
        end
    end

    if not serverIdExiste then
        ESX.ShowNotification("~r~EMS\n~s~Un appel a été ajouté au registre.")
        table.insert(TableDemandeAppel, {
            ServerId = id,
            AppelCoords = coords,
            AppelID = idAppel,
            AppelDate = date,
            AppelPris = false,
        })
    else
        ESX.ShowNotification("~r~EMS\n~s~Cet appel existe déjà dans le registre.")
    end
end)

RegisterNetEvent("rEMS:SetCallStatus")
AddEventHandler("rEMS:SetCallStatus", function(CallId)
	for k,v in pairs(TableDemandeAppel) do
		if v.AppelID == CallId then
			v.AppelPris = true
		end
	end

	if callsList[playerId] then
		Citizen.CreateThread(function()
			while #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(playerId))) > 1.5 
				and GetPlayerPing(playerId) > 0 
				and GetPlayerPing(source) > 0 do

				local distance = #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(playerId)))
				TriggerClientEvent("ambulance:sendPos", playerId, ESX.Maths.Round(distance))
				Wait(15 * 1000)
			end
		end)
	end
end)

function EMS_TrackCallResponder(source, target)
	Citizen.CreateThread(function()
		while #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target))) > 1.5 
			and GetPlayerPing(target) > 0 
			and GetPlayerPing(source) > 0 do

			local distance = #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target)))
			TriggerClientEvent("ambulance:sendPos", target, zUtils.Round(distance))
			Wait(7.5 * 1000)
		end
	end)
end

Citizen.CreateThread(function()
	RMenu.Add('menu', 'main', RageUI.CreateMenu("PRIME", "Menu EMS", 1, 100))
	RMenu:Get('menu', 'main'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'main').EnableMouse = false
    RMenu:Get('menu', 'main').Closed = function()
		EMSCallsClosed = false
    end
end)

RegisterCommand("emsmenu", function()
	OpenCalls()
end)

function OpenCalls()
	if EMSCallsClosed then
        EMSCallsClosed = false
        return
    else
        EMSCallsClosed = true
        RageUI.Visible(RMenu:Get('menu', 'main'), true)

        Citizen.CreateThread(function()
            while EMSCallsClosed do
                Wait(0)
                RageUI.IsVisible(RMenu:Get('menu', 'main'), true, true, true, function()
                    RageUI.ButtonWithStyle("Vider la liste des appels pris", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
						if (Selected) then
							for k,v in ipairs(TableDemandeAppel) do
								if v.AppelPris then
									table.remove(TableDemandeAppel, k)
									ResetAllCalls()
								end
							end
						end
					end)
					RageUI.ButtonWithStyle("Vider toute la liste des appels", nil, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
						if (Selected) then
							for k,v in ipairs(TableDemandeAppel) do
								table.remove(TableDemandeAppel, k)
								ResetAllCalls()
							end
						end
					end)
					for k,v in ipairs(TableDemandeAppel) do
						local dst = GetDistanceBetweenCoords(v.AppelCoords, GetEntityCoords(PlayerPedId()), true)
						if not v.AppelPris then
							RageUI.ButtonWithStyle("~s~Appel de détresse: ~p~#"..v.AppelID.."~s~ - ~p~"..Round(dst, 0).."m", "~s~Identifiant de la victime: ~p~"..v.ServerId.."~s~\nHeure d'appel: ~p~"..v.AppelDate, {RightLabel = "~r~EN ATTENTE"}, true, function(Hovered, Active, Selected)
								if (Selected) then
									PriseAppel(v.ServerId, v.AppelCoords)
									TriggerServerEvent("rEMS:SetCallStatus", v.AppelID, v.ServerId)
								end
							end)
						else
							RageUI.ButtonWithStyle("~s~Appel de détresse: ~p~#"..v.AppelID.."~s~ - ~p~"..Round(dst, 0).."m", "~s~Identifiant de la victime: ~p~"..v.ServerId.."~s~\nHeure d'appel: ~p~"..v.AppelDate, { RightLabel = "~y~PRIS" }, true, function(Hovered, Active, Selected)
								if (Selected) then
									PriseAppel(v.ServerId, v.AppelCoords)
								end
							end)
						end
					end
                end, function()
                end)
            end
        end, function()
        end, 1)
    end
end

Round = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

local AllBlips = {}
local ResetAllCall = false

function ResetAllCalls()
	for k,v in pairs(AllBlips) do
		RemoveBlip(v)
	end
	ResetAllCall = true
end

local lib1_char_a, lib2_char_a, lib1_char_b, lib2_char_b, anim_start, anim_pump, anim_success = 'mini@cpr@char_a@cpr_def', 'mini@cpr@char_a@cpr_str', 'mini@cpr@char_b@cpr_def', 'mini@cpr@char_b@cpr_str', 'cpr_intro', 'cpr_pumpchest', 'cpr_success'
 
Citizen.CreateThread(function()
	RequestAnimDict(lib1_char_a)
	RequestAnimDict(lib2_char_a)
	RequestAnimDict(lib1_char_b)
	RequestAnimDict(lib2_char_b)
end)
   
RegisterNetEvent('ambulance:playCPR')
AddEventHandler('ambulance:playCPR', function(playerheading, playercoords, playerlocation)
	IsDead = false
	local playerPed = PlayerPedId()
	local cpr = true
	TriggerServerEvent('ambulance:RemoveLastDeathCause')
	Citizen.CreateThread(function()
		while cpr do
			Citizen.Wait(0)
			DisableAllControlActions(0)
			EnableControlAction(0, 249, true)
			EnableControlAction(0, 1, true)
		end
	end)
   
	ClampGameplayCamPitch(0.0, -90.0)
   
	local heading = 0.0
	local coords = GetEntityCoords(playerPed)
	local x, y, z = table.unpack(playercoords + playerlocation)
	NetworkResurrectLocalPlayer(x, y, z, playerheading, true, false)
	SetEntityHeading(playerPed, playerheading - 270.0)
   
	TaskPlayAnim(playerPed, lib1_char_b, anim_start, 8.0, 8.0, -1, 0, 0, false, false, false)
	Citizen.Wait(15800 - 900)
	for i=1, 15, 1 do
		Citizen.Wait(900)
		TaskPlayAnim(playerPed, lib2_char_b, anim_pump, 8.0, 8.0, -1, 0, 0, false, false, false)
	end
	
	cpr = false
	TriggerServerEvent("ems:removeappel", GetPlayerServerId(PlayerId()))
	TriggerEvent("status:refresh", 100, 100)
	TaskPlayAnim(playerPed, lib2_char_b, anim_success, 8.0, 8.0, -1, 0, 0, false, false, false)
end)


function checkPlayerStatus(XAid)
    -- Vérifier si le joueur est toujours sur le serveur
    if GetPlayerFromServerId(XAid) ~= -1 then
        local playerPed = GetPlayerPed(GetPlayerFromServerId(XAid))

        if IsEntityDead(playerPed) then
            return true
        else
            return false, "Le joueur est vivant"
        end
	end
	return true
end

local chargedPlayer = true
local coordsPedAppel = vector3(0, 0, 0)
local appelIsDead = true
RegisterNetEvent("rems:isconnected", function(bool, coords, dead)
	chargedPlayer = bool
	coordsPedAppel = coords
	if dead == nil then 
		appelIsDead = false
	else
		appelIsDead = dead 
	end
end)

function PriseAppel(XAid, XAcoords)
	Citizen.CreateThread(function()
		chargedPlayer = true
		coordsPedAppel = XAcoords
		appelIsDead = true
		ESX.ShowNotification("~r~EMS\n~s~Vous avez pris l'appel, suivez les indications du GPS")
		ResetAllCall = false
	    local emsBlip = AddBlipForCoord(XAcoords)
		SetBlipSprite(emsBlip, 353)
		SetBlipColour(emsBlip, 43)
		SetBlipShrink(emsBlip, true)
	    SetBlipScale(emsBlip, 1.2)
	    SetBlipPriority(emsBlio, 50)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName("~r~APPEL EMS")
		EndTextCommandSetBlipName(emsBlip)
		table.insert(AllBlips, emsBlip)

		local emsBlip2 = AddBlipForCoord(XAcoords)
		SetBlipSprite(emsBlip2, 42)
		SetBlipColour(emsBlip2, 5)
		SetBlipShrink(emsBlip2, true)
		SetBlipScale(emsBlip2, 1.2)
		SetBlipAlpha(emsBlip2, 120)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName("~r~APPEL EMS")
		EndTextCommandSetBlipName(emsBlip2)
		table.insert(AllBlips, emsBlip2)

	    SetBlipRoute(emsBlip, true)
	    SetThisScriptCanRemoveBlipsCreatedByAnyScript(true)
	    local rea = true
		CreateThread(function()
			while rea do 
				TriggerServerEvent("rems:isconnected", XAid)
				SetBlipCoords(emsBlip, coordsPedAppel.x, coordsPedAppel.y, coordsPedAppel.z)
				SetBlipCoords(emsBlip2, coordsPedAppel.x, coordsPedAppel.y, coordsPedAppel.z)

				XAcoords = coordsPedAppel
				Wait(15000)
			end
		end)

		while rea do
			if ResetAllCall then
				rea = false
			end
			-- not checkPlayerStatus(XAid) or 
			if not chargedPlayer or not appelIsDead then
				ESX.ShowNotification("La personne s'est rétablie, opération annulée.")
				rea = false
				RemoveBlip(emsBlip)
				RemoveBlip(emsBlip2)
				TriggerServerEvent("ems:removeappel", XAid)
				return
			end
			local attente = 0
			if GetDistanceBetweenCoords(XAcoords, GetEntityCoords(PlayerPedId())) < 100.0 then
				attente = 0
	            DrawMarker(1, XAcoords, 0, 0, 0, 0, 0, 0, 0.2, 0.2, 250.0, 66, 245, 87, 170, false, false, 2, true, false, false, false)
				if GetDistanceBetweenCoords(XAcoords, GetEntityCoords(PlayerPedId())) < 5.0 then
					Draw3DText(XAcoords.x, XAcoords.y, XAcoords.z, "💀\n~w~Une personne à besoin d'une réanimation ici...\n~y~[E] ~w~Pour la réanimer.", 4, 0.1, 0.1)
					if IsControlJustReleased(0, 38) then
						local playerPed = PlayerPedId()
						local pedenface = GetPlayerFromServerId(XAid)
						-- local isPlayerDead = IsPlayerDead(pedenface)

						-- if isPlayerDead then
                        	TriggerServerEvent("ambulance:requestCPR", XAid, GetEntityHeading(playerPed), GetEntityCoords(playerPed), GetEntityForwardVector(playerPed))
							ESX.ShowNotification("Réanimation en cours")
							ClearPedTasksImmediately(playerPed)
							ClearPedTasks(playerPed)
							TriggerServerEvent("ems:removeappel", XAid)

                        	local cpr = true

                        	Citizen.CreateThread(function()
                        	    while cpr do
                        	        Citizen.Wait(0)
                        	        DisableAllControlActions(0)
									EnableControlAction(0, 249, true)
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
							TriggerServerEvent('rems:emsRevive', XAid, GetEntityCoords(PlayerPedId()))
							ClearPedTasksImmediately(playerPed)
							ClearPedTasks(playerPed)

							RemoveAnimDict('mini@cpr@char_a@cpr_str')
	            			RemoveAnimDict('cpr_pumpchest')
	            			rea = false
	            			RemoveBlip(emsBlip)
							RemoveBlip(emsBlip2)
							local oPlayer = GetPlayerFromServerId(XAid)
							local oPed = GetPlayerPed(oPlayer)
							local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 2.0, 0.0)
							SetEntityCoords(oPed, offset, 0)
						-- else
						-- 	ESX.ShowNotification("~r~La personne est déja en vie !")
						-- 	rea = false
	            		-- 	RemoveBlip(emsBlip)
						-- 	RemoveBlip(emsBlip2)
						-- end
					end
				end
			else
				attente = 0
	        end
	        Wait(attente)
		end
	end)
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

RegisterNetEvent("ems:removeappel", function(id)
	for k,v in pairs(TableDemandeAppel) do
		if v.ServerId == id then
			table.remove(TableDemandeAppel, k)
		end
	end
end)