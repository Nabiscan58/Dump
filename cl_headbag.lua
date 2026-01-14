ESX = nil
local HaveBagOnHead = false
local onBagActive = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	
    RMenu.Add('menu', 'bagbagmenu', RageUI.CreateMenu("PRIME", "Sac", 1, 100))
    RMenu:Get('menu', 'bagbagmenu'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'bagbagmenu').EnableMouse = false
    RMenu:Get('menu', 'bagbagmenu').Closed = function()
		onBagActive = false
    end
end)

function NajblizszyGracz()
	local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	local player = PlayerPedId()

	if closestPlayer == -1 or closestDistance > 2.0 then 
	    ESX.ShowNotification('~r~Aucun joueur proche !')
	else
	  	if not HaveBagOnHead then
	    	TriggerServerEvent('headbag:sendclosest', GetPlayerServerId(closestPlayer))
	    	ESX.ShowNotification('~y~Vous avez mis un sac sur ~w~' .. GetPlayerName(closestPlayer))
	    	TriggerServerEvent('headbag:closest')
	  	else
	    	ESX.ShowNotification('~r~Ce joueur a déja un sac dans la tête !')
	  	end
	end
end

RegisterNetEvent('headbag:naloz') --This event open menu
AddEventHandler('headbag:naloz', function()
    OpenBagMenu()
    TriggerEvent("f5:closeAll")
end)

RegisterNetEvent('headbag:nalozNa')
AddEventHandler('headbag:nalozNa', function(gracz)
    local playerPed = PlayerPedId()
    Worek = CreateObject(GetHashKey("prop_money_bag_01"), 0, 0, 0, true, true, true)
    AttachEntityToEntity(Worek, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 12844), 0.2, 0.04, 0, 0, 270.0, 60.0, true, true, false, true, 1, true) -- Attach object to head
    HaveBagOnHead = true
    Citizen.CreateThread(function()
        while HaveBagOnHead do
            DrawRect(0.0, 0.0, 1000.0, 1000.0, 0, 0, 0, 255)
            Citizen.Wait(0)
        end
    end)
end)    

AddEventHandler('playerSpawned', function()
	DeleteEntity(Worek)
	SetEntityAsNoLongerNeeded(Worek)
	HaveBagOnHead = false
end)

RegisterNetEvent('headbag:zdejmijc')
AddEventHandler('headbag:zdejmijc', function(gracz)
    ESX.ShowNotification("~y~Quelqu'un vient de retirer le sac de votre tête !")
    DeleteEntity(Worek)
    SetEntityAsNoLongerNeeded(Worek)
    HaveBagOnHead = false
end)

function OpenBagMenu()
    if onBagActive then
        onBagActive = false
        return
    else
        onBagActive = true
        RageUI.Visible(RMenu:Get('menu', 'bagbagmenu'), true)

        Citizen.CreateThread(function()
            while onBagActive do
                RageUI.IsVisible(RMenu:Get('menu', 'bagbagmenu'), true, true, true, function()
					local player, distance = ESX.Game.GetClosestPlayer()
  
					if distance ~= -1 and distance <= 2.0 then
                    	RageUI.ButtonWithStyle("Mettre le sac dans la tête", nil, { RightLabel = "»" },true, function(Hovered, Active, Selected)
							if Selected then
								NajblizszyGracz()
                                RageUI.CloseAll()
								onBagActive = false
							end
                    	end)
						RageUI.ButtonWithStyle("Retirer le sac de la tête", nil, { RightLabel = "»" },true, function(Hovered, Active, Selected)
							if Selected then
								TriggerServerEvent('headbag:zdejmij')
                                RageUI.CloseAll()
								onBagActive = false
							end
                    	end)
					else
						RageUI.Separator("Aucun joueur autour !")
					end
                end, function()
                end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end