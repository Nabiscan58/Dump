LICENSES = {
    ["myLicenses"] = {},
}

Citizen.CreateThread(function()
    Citizen.Wait(5 * 1000)
    TriggerServerEvent("licenses:get")
end)

RegisterNetEvent("licenses:send")
AddEventHandler("licenses:send", function(licenses)
    LICENSES["myLicenses"] = licenses

    print(json.encode(LICENSES["myLicenses"]))
end)


local menu = {
	['openned'] = false,
}

function SelectNumber(text)
	local i = nil

	exports.dialog:openDialog(text, function(value)
		i = value
	end)
	while i == nil do Wait(1) end
	i = tostring(i)
	
	return i
end

CreateMenu = function()
	RMenu.Add('llicenses', 'main', RageUI.CreateMenu('PRIME', 'Gouvernement', 1, 100))
	RMenu.Add('llicenses', 'second', RageUI.CreateSubMenu(RMenu:Get('llicenses', 'main'), 'PRIME', 'François'))
	RMenu:Get('llicenses', 'main').Closed = function()
		menu['openned'] = false

		RMenu:Delete('llicenses', 'main')
		RMenu:Delete('llicenses', 'second')
	end
	
	if menu['openned'] then
		menu['openned'] = false
		return
	else
		RageUI.CloseAll()

		menu['openned'] = true
		RageUI.Visible(RMenu:Get('llicenses', 'main'), true)
	end

	RMenu:Get('llicenses', 'main'):SetRectangleBanner(255, 220, 0, 140)

	local player = ESX.GetPlayerData()
	local elements = {}

	table.insert(elements, {label = "Carte d'identité", price = 5000, value = 'id_card'})
    table.insert(elements, {label = "Permis de pêche", price = 10000, value = 'peche'})
	table.insert(elements, {label = "Permis de chasse", price = 20000, value = 'chasse'})
    table.insert(elements, {label = "Accès bateau (Permis de conduire)", price = 50000, value = 'bateau'})
	table.insert(elements, {label = "Accès avions (Permis de conduire)", price = 450000, value = 'aeronef'})

	if player.job.name == "police" then
		table.insert(elements, {label = "Badge lspd", price = 10000, value = 'lspd'})
	end
	if player.job.name == "sheriff" then 
		table.insert(elements, {label = "Badge BCSO", price = 10000, value = 'sheriff'})
	end
	if player.job.name == "ambulance" or player.job.name == "ems" then 
		table.insert(elements, {label = "Badge EMS", price = 10000, value = 'ems'})
	end


	local coords = GetEntityCoords(PlayerPedId())

	Citizen.CreateThread(function()
		while menu['openned'] do
			Wait(1)

			if #(coords - GetEntityCoords(PlayerPedId())) > 5.0 then
				RageUI.CloseAll()
				menu['openned'] = false
			end

			RageUI.IsVisible(RMenu:Get('llicenses', 'main'), true, false, true, function()
				
				for k,v in pairs(elements) do
					RageUI.ButtonWithStyle(v.label, nil, {RightLabel = v.price ~= nil and ESX.Math.GroupDigits(v.price).."$"}, true, function(Hovered, Active, Selected)
						if Selected then
							if v.value == "sheriff" then
								local input = SelectNumber("Matricule")
								if tonumber(input) then 
									RageUI.CloseAll()
									menu['openned'] = false
									TriggerEvent("inventory:getMugshot", function (link)
										if link then
											TriggerServerEvent("licenses:groszeub", "sheriff", v.price, tonumber(input), link)
										else
											ESX.ShowNotification("Erreur lors de la prise de photo")
										end
									end)
                                	
								end
							end

							if v.value == "ems" then
								local input = SelectNumber("Matricule")
								if tonumber(input) then 
									RageUI.CloseAll()
									menu['openned'] = false
									TriggerEvent("inventory:getMugshot", function (link)
										if link then
											TriggerServerEvent("licenses:groszeub", "ems", v.price, tonumber(input), link)
										else
											ESX.ShowNotification("Erreur lors de la prise de photo")
										end
									end)
                                	
								end
							end
							if v.value == "lspd" then
								local input = SelectNumber("Matricule")
								print(input)
								if tonumber(input) then
									RageUI.CloseAll()
									menu['openned'] = false
									TriggerEvent("inventory:getMugshot", function (link)
										print(link)
										if link then
											TriggerServerEvent("licenses:groszeub", "lspd", v.price,  tonumber(input), link)
										else
											ESX.ShowNotification("Erreur lors de la prise de photo")
										end
									end)
								end
							end
							if v.value == "id_card" then
								TriggerEvent("inventory:getMugshot", function(link)
									print(link)
									if link then
										TriggerServerEvent("licenses:groszeub", "idcard", v.price, "", link)
									else
										ESX.ShowNotification("Erreur lors de la prise de photo")
									end
								end)

								RageUI.CloseAll()
								menu['openned'] = false
							end
							if v.value == "bateau" then
                                TriggerServerEvent("licenses:groszeub", "drive_boat", v.price)
								RageUI.CloseAll()
								menu['openned'] = false
							end

							if v.value == "chasse" then
                                TriggerServerEvent("licenses:groszeub", "chasse", v.price)
								RageUI.CloseAll()
								menu['openned'] = false
							end

							if v.value == "peche" then
                                TriggerServerEvent("licenses:groszeub", "peche", v.price)
								RageUI.CloseAll()
								menu['openned'] = false
							end

                            if v.value == "aeronef" then
                                TriggerServerEvent("licenses:groszeub", "drive_plane", v.price)
								RageUI.CloseAll()
								menu['openned'] = false
							end

						end
					end)
				end

			end)

		end
	end)
end

CreateThread(function()
	local markerPos = vector3(-545.11108398438, -612.95959472656, 34.743825531006)

	while true do
		local interval = 1000
		local playerCoords = GetEntityCoords(PlayerPedId())
		
		if #(playerCoords - markerPos) < 5.0 then
			interval = 0

			DrawMarker(6, markerPos.x, markerPos.y, markerPos.z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
			if #(playerCoords - markerPos) < 2.0 then
				ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu des licenses")

				if IsControlJustPressed(0, 38) then
                	CreateMenu()
				end
			end
		end

		Citizen.Wait(interval)
	end
end)