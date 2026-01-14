ESX = nil

local OnElevator = false
local curr_pl_billing = nil

local ElevatorCoords = {
	{x = -664.22381591797, y = 326.33172607422, z = 77.124000549316, },
    {x = -664.41052246094, y = 326.17614746094, z = 82.085662841797, },
    {x = -664.19348144531, y = 326.26821899414, z = 87.018699645996, },
    {x = -664.21899414062, y = 326.06362915039, z = 91.745018005371, },
    {x = -664.17864990234, y = 326.29818725586, z = 139.12258911133, }
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	
    RMenu.Add('menu', 'elevator', RageUI.CreateMenu("PRIME", "Ascenseur", 1, 100))
    RMenu:Get('menu', 'elevator'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'elevator').EnableMouse = false
    RMenu:Get('menu', 'elevator').Closed = function()
		OnElevator = false
    end
end)

function openElevatorMenu()
    local coords = GetEntityCoords(PlayerPedId())
    if OnElevator then
        OnElevator = false
        return
    else
        OnElevator = true
        RageUI.Visible(RMenu:Get('menu', 'elevator'), true)

        Citizen.CreateThread(function()
            while OnElevator do
                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                    RageUI.CloseAll()
                    OnElevator = false
                end

                RageUI.IsVisible(RMenu:Get('menu', 'elevator'), true, true, true, function()     
                    local playerPed = PlayerPedId()
                    RageUI.ButtonWithStyle("Étage -1", nil, { RightLabel = "→" },true, function(Hovered, Active, Selected)
                        if Selected then
                            transition(0)
                            SetEntityCoordsNoOffset(playerPed, -664.22381591797, 326.33172607422, 77.124000549316, false, false, false, true)
                        end
                    end)
                    RageUI.ButtonWithStyle("Étage 0", nil, { RightLabel = "→" },true, function(Hovered, Active, Selected)
                        if Selected then
                            transition(0)
                            SetEntityCoordsNoOffset(playerPed, -664.41052246094, 326.17614746094, 82.085662841797, false, false, false, true)
                        end
                    end)
                    RageUI.ButtonWithStyle("Étage 1", nil, { RightLabel = "→" },true, function(Hovered, Active, Selected)
                        if Selected then
                            transition(0)
                            SetEntityCoordsNoOffset(playerPed, -664.19348144531, 326.26821899414, 87.018699645996, false, false, false, true)
                        end
                    end)
                    RageUI.ButtonWithStyle("Étage 2", nil, { RightLabel = "→" },true, function(Hovered, Active, Selected)
                        if Selected then
                            transition(0)
                            SetEntityCoordsNoOffset(playerPed, -664.21899414062, 326.06362915039, 91.745018005371, false, false, false, true)
                        end
                    end)
                    RageUI.ButtonWithStyle("Toit", nil, { RightLabel = "→" },true, function(Hovered, Active, Selected)
                        if Selected then
                            transition(0)
                            SetEntityCoordsNoOffset(playerPed, -664.17864990234, 326.29818725586, 139.12258911133, false, false, false, true)
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

Citizen.CreateThread(function()
    while true do
        local nearThing = false

		for k in pairs(ElevatorCoords) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, ElevatorCoords[k].x, ElevatorCoords[k].y, ElevatorCoords[k].z)

            if dist <= 1.0 then
                nearThing = true
                DrawMarker(6, ElevatorCoords[k].x, ElevatorCoords[k].y, ElevatorCoords[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir le menu de l'ascenseur")
				if IsControlJustPressed(1,51) then
                    if OnElevator == false then
					    openElevatorMenu()
                    end
				end
			end
        end
        
        if nearThing then
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
	end
end)

function transition(timer)
    DoScreenFadeOut(1000)
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    Citizen.Wait(timer)
    DoScreenFadeIn(3000)
end