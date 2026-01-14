local cooldown = false

Citizen.CreateThread(function()
    local called = false
    while true do
        local interval = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local isNearPoint = false

        for _, enterprise in pairs(cfg_callSociety.Enterprises) do
            local distance = #(playerCoords - enterprise.coords)

            if distance < 7.0 then
                interval = 0
                DrawMarker(6, enterprise.coords.x, enterprise.coords.y, enterprise.coords.z - 0.95, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
            end

            if distance < 2.0 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour appeller '"..enterprise.label.."'")
    
                if IsControlJustPressed(0, 38) and not cooldown then
                    TriggerServerEvent('kxCallSociety:callEnterprise', enterprise.name)
                    cooldown = true

                    Citizen.SetTimeout(cfg_callSociety.Cooldown * 1000, function()
                        cooldown = false
                    end)
                end
            end
        end

        Citizen.Wait(interval)
    end
end)

RegisterNetEvent("kxCallSociety:alertMap")
AddEventHandler("kxCallSociety:alertMap", function(pos)
    Citizen.CreateThread(function()
        local time = GetGameTimer() + 20 * 1000
        while time > GetGameTimer() do
            
            if IsControlJustPressed(0, 47) then
                SetNewWaypoint(pos.x, pos.y)
            end

            Citizen.Wait(0)
        end
    end)

    local alpha = 250
    local alpha2 = 170
    local bl2 = AddBlipForRadius(pos, 75.0)
    local bl = AddBlipForRadius(pos, 50.0)
    local info = AddBlipForCoord(pos)

	SetBlipHighDetail(bl, true)
	SetBlipColour(bl, 43)
	SetBlipAlpha(bl, alpha)
    SetBlipAsShortRange(bl, true)
    
    SetBlipHighDetail(bl2, true)
	SetBlipColour(bl2, 43)
	SetBlipAlpha(bl2, alpha2)
    SetBlipAsShortRange(bl2, true)
    
    SetBlipSprite(info, 480)
    SetBlipDisplay(info, 4)
    SetBlipColour(info, 43)
    SetBlipScale(info, 0.8)
    SetBlipAsShortRange(info, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Appel client")
    EndTextCommandSetBlipName(info)

	while alpha ~= 0 do
		Citizen.Wait(30 * 4)
		alpha = alpha - 1
		SetBlipAlpha(bl, alpha)
		SetBlipAlpha(bl2, alpha)
		SetBlipAlpha(info, alpha)

		if alpha == 0 then
			RemoveBlip(bl)
			RemoveBlip(bl2)
			RemoveBlip(info)
			return
		end
	end
end)