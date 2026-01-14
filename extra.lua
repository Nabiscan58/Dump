local Extra = false
local tin = false

RMenu.Add('menu', 'extra', RageUI.CreateMenu("PRIME", "Menu Extra", 1, 100))
RMenu:Get('menu', 'extra'):SetRectangleBanner(255, 220, 0, 140)
RMenu:Get('menu', 'extra').Closed = function()
    Extra = false
end;

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job
	ESX.PlayerData.job.grade_name = grade
end)

function AddMenuExtra()
	local coords = GetEntityCoords(PlayerPedId())
    if Extra then
        RageUI.CloseAll()
        Extra = false
        return
    else
        Extra = true
        RageUI.Visible(RMenu:Get('menu', 'extra'), true)

		local oldProps = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false))

		ESX.Game.SetVehicleProperties(GetVehiclePedIsIn(PlayerPedId(), false), oldProps)

        Citizen.CreateThread(function()
            while Extra do
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
					RageUI.CloseAll()
					Extra = false
				end

                RageUI.IsVisible(RMenu:Get('menu', 'extra'), true, true, true, function()
					if IsPedInAnyVehicle(PlayerPedId(), false) then
						local ped = PlayerPedId()
						local veh = GetVehiclePedIsIn(ped, false)
						
						for i = 1, 20 do 
							if DoesExtraExist(veh, i) then
								RageUI.Checkbox("Extra " .. i, "Permet d'ajouter des extras", IsVehicleExtraTurnedOn(veh, i), { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
								end, function()
									SetVehicleExtra(veh, i, false)
								end, function()
									SetVehicleExtra(veh, i, true)
								end)
							end
						end

						RageUI.Separator()

						local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
						local plaque = GetVehicleNumberPlateText(vehicle)
						local liveryCount = GetVehicleLiveryCount(vehicle)
						
						if liveryCount > 0 then
							for i = -1, liveryCount - 1, 1 do
								local modName = (i == -1) and 'Livrée de base' or 'Livrée ' .. i
								RageUI.ButtonWithStyle(modName, nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
									if Active then
										SetVehicleLivery(vehicle, i)
									end
								end)
							end
						end
						
						local modLiveryCount = GetNumVehicleMods(vehicle, 48)
						
						if modLiveryCount > 0 then
							for i = 0, modLiveryCount - 1, 1 do
								local modName = GetModTextLabel(vehicle, 48, i)
								modName = GetLabelText(modName)
								if modName == 'NULL' then modName = 'Livrée Custom ' .. i end
						
								RageUI.ButtonWithStyle(modName, nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
									if Selected then
										SetVehicleMod(vehicle, 48, i, false)
									end
								end)
							end
						end
						
						RageUI.Separator()
						
						RageUI.ButtonWithStyle("Retirer les vitres teintées", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected) 
							if Selected then
								SetVehicleWindowTint(veh, 0)
							end
						end)
					else
						RageUI.Separator("~r~Vous devez être dans un véhicule")
					end
				end, function()
				end)

                Wait(0)
            end
        end)
    end
end

function IsVehicleHealthy(vehicle)
    local vehHealth = GetVehicleBodyHealth(vehicle)

    if vehHealth > 980 then
        return true
    else
        return false
    end
end

local extrapos = {
	{x = -1265.8569, y = -278.2921, z = 37.7416, },
	{x = -1900.005, y = -332.9387, z = 48.23162, },
	{x = -358.6934, y = -89.34093, z = 38.09129, },
	{x = -688.85485839844, y = 352.13754272461, z = 175.80831298828, },
	{x = 1749.2774658203,y = 3870.7302246094,z = 33.746595001221, },
	{x = -581.85675048828,y = 7388.455078125,z = 11.939551925659, },
	{x = 48.519477844238,y = 6513.1474609375,z = 31.01283416748, },
	{x = -707.88812255859,y = 320.58728027344,z = 139.2481628418, },
	{x = -688.35131835938,y = 352.48211669922,z = 77.218263244629, },
	{x = -1077.6649,y = -845.0971,z = 3.8781, },
	{x = 1080.3074,y = 2742.6340,z = 37.6676, },
	{x = 1007.997253418,y = 2651.03125,z = 38.7185, },
	{x = 711.59344482422,y = 161.51870727539,z = 79.858987426758, },
	{x = 455.98452758789,y = -1022.6842041016,z = 28.27921257019, },
	{x = -1108.5280761719,y = -850.53033447266,z = 4.1615491867065, },
	{x = -1085.2299804688,y = -809.78637695312,z = 9.88022480011, },
	{x = -828.88482666016,y = -757.00579833984,z = 21.459687805176, }
}

local allowedjobs = {
	"police",
	"sheriff",
	"ems",
	"bennys",
	"streettuners",
	"harmony",
	"taxi",
	"marshall",
	"bobcat"
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false
		local allowed = false

		for k in pairs(extrapos) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, extrapos[k].x, extrapos[k].y, extrapos[k].z)

			if dist <= 7.0 then
				for i, j in pairs(allowedjobs) do
					if j == ESX.PlayerData.job.name then
						allowed = true
					end
				end
				if allowed == true then
					nearThing = true
					DrawMarker(6, extrapos[k].x, extrapos[k].y, extrapos[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
					ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour ouvrir le menu des extras de véhicules")
					if IsControlJustPressed(1,51) then
						if Extra == false then
							local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
							if IsPedInAnyVehicle(PlayerPedId(), false) then
								local engineHealth = GetVehicleEngineHealth(vehicle)
								if engineHealth < 700.0 then
									ESX.ShowNotification("~r~Vous ne pouvez pas modifier un véhicule lorsque celui-ci n'est pas en bon état ! Visitez un mécano dès aujourd'hui.")
								else
									AddMenuExtra()
								end
							else
								ESX.ShowNotification("~r~Vous devez être dans un véhicule.")
							end
						end
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