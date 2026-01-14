ESX = nil

local OnMenuActive = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	
	RMenu.Add('menu', 'peds', RageUI.CreateMenu("PRIME", "Menu Peds", 1, 100))
	RMenu.Add('menu', 'animals', RageUI.CreateSubMenu(RMenu:Get('menu', 'peds'), "PRIME", "Menu Peds"))
	RMenu.Add('menu', 'kids', RageUI.CreateSubMenu(RMenu:Get('menu', 'peds'), "PRIME", "Menu Peds"))
	RMenu.Add('menu', 'gangs', RageUI.CreateSubMenu(RMenu:Get('menu', 'peds'), "PRIME", "Menu Peds"))
	RMenu.Add('menu', 'special', RageUI.CreateSubMenu(RMenu:Get('menu', 'peds'), "PRIME", "Menu Peds"))
    RMenu:Get('menu', 'peds'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'animals'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'kids'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'gangs'):SetRectangleBanner(255, 220, 0, 140)
	RMenu:Get('menu', 'special'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'peds').EnableMouse = false
    RMenu:Get('menu', 'peds').Closed = function()
		OnMenuActive = false
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
	ESX.PlayerData.job.grade_name = grade
end)

function openPedsMenu()
    if OnMenuActive then
        OnMenuActive = false
        return
    else
        OnMenuActive = true
        RageUI.Visible(RMenu:Get('menu', 'peds'), true)

        Citizen.CreateThread(function()
            while OnMenuActive do
                RageUI.IsVisible(RMenu:Get('menu', 'peds'), true, true, true, function()
					RageUI.ButtonWithStyle("Reprendre son apparence", nil, {}, true, function(Hovered, Active, Selected)
						if (Selected) then
							ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
								local isMale = skin.sex == "mp_m_freemode_01"
								TriggerEvent('skinchanger:loadDefaultModel', isMale, function()
									ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
										TriggerEvent('skinchanger:loadSkin', skin)
									end)
								end)
							end)
						end
					end)
					RageUI.Separator()
					RageUI.ButtonWithStyle("Peds animaux", "", { RightLabel = "" },true, function()
                    end, RMenu:Get('menu', 'animals'))
					RageUI.ButtonWithStyle("Peds gangs", "", { RightLabel = "" },true, function()
                    end, RMenu:Get('menu', 'gangs'))
					RageUI.ButtonWithStyle("Peds spéciaux", "", { RightLabel = "" },true, function()
                    end, RMenu:Get('menu', 'special'))
                end, function()
                end)
                
                RageUI.IsVisible(RMenu:Get('menu', 'animals'), true, true, true, function()
					for k,v in pairs(VIPConfig.animals) do
						RageUI.ButtonWithStyle(v.label, nil, {}, true, function(Hovered, Active, Selected)
							if (Selected) then
								if v.name == "a_c_shepherd" then
									print(ESX.PlayerData.job.name)
									if ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "sheriff" then
										local ped = PlayerId()
										local askedped = GetHashKey(v.name)
										RequestModel(askedped)
										while not HasModelLoaded(askedped) do
											Wait(100)
										end
										SetPlayerModel(ped, askedped)
										SetModelAsNoLongerNeeded(askedped)
										TriggerEvent("skinchanger:change", 'torso_1', 2)
									else
										ESX.ShowNotification("~r~Vous ne pouvez pas sélectionner ce chien sans être du LSPD ou BCSO.")
									end
								else
									local ped = PlayerId()
									local askedped = GetHashKey(v.name)
									RequestModel(askedped)
									while not HasModelLoaded(askedped) do
										Wait(100)
									end
									SetPlayerModel(ped, askedped)
									SetModelAsNoLongerNeeded(askedped)
									if v.name == "a_c_husky" or v.name == "a_c_retriever" or v.name == "a_c_panther" then
										TriggerEvent("skinchanger:change", 'torso_1', 2)
									end
								end
							end
						end)
					end
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'gangs'), true, true, true, function()
					for k,v in pairs(VIPConfig.gangs) do
						RageUI.ButtonWithStyle(v.label, nil, {}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local ped = PlayerId()
								local askedped = GetHashKey(v.name)
								RequestModel(askedped)
								while not HasModelLoaded(askedped) do
									Wait(100)
								end
								SetPlayerModel(ped, askedped)
								SetModelAsNoLongerNeeded(askedped)
							end
						end)
					end
                end, function()
				end)

				RageUI.IsVisible(RMenu:Get('menu', 'special'), true, true, true, function()
					for k,v in pairs(VIPConfig.special) do
						RageUI.ButtonWithStyle(v.label, nil, {}, true, function(Hovered, Active, Selected)
							if (Selected) then
								local ped = PlayerId()
								local askedped = GetHashKey(v.name)
								RequestModel(askedped)
								while not HasModelLoaded(askedped) do
									Wait(100)
								end
								SetPlayerModel(ped, askedped)
								SetModelAsNoLongerNeeded(askedped)
							end
						end)
					end
                end, function()
				end)
				
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

RegisterNetEvent('peds:openMenu')
AddEventHandler('peds:openMenu', function()
	local ranks = ESX.PlayerData.rank
    local hasDiamond = false

    for _, rankInfo in ipairs(ranks) do
        if rankInfo.name == "diamond" or rankInfo.name == "prime" then
            hasDiamond = true
            break
        end
    end

	if hasDiamond == true then
		openPedsMenu()
	else
		ESX.ShowNotification("~r~Vous devez être VIP Diamond/Prime pour accéder à ce menu !")
	end
end)