ESX = nil
local onBrouilleur = false
local onCoyote = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
end)

local RadarZone = {
    {x = 223.44, y = -1043.16, z = 28.89},
    {x = 394.152, y = -1049.98, z = 8.85},
    {x = 404.06, y = -954.26, z = 28.87},
    {x = 291.35, y = -854.42, z = 28.70},
    {x = 39.01, y = -768.27, z = 31.15},
    {x = -195.37, y = -891.77, z = 28.8},
    {x = -96.85, y = -1138.96, z = 25.37},
    {x = 149.26, y = -1392.29, z = 28.82},
    {x = -111.43, y = -697.24, z = 34.35},
    {x = 24.84, y = -303.64, z = 46.61},
    {x = 247.21, y = -619.68, z = 41.14},
    {x = -501.92, y = -835.12, z = 30.01},
    {x = -858.42, y = -834.56, z = 18.82},
    {x = -1079.91, y = -761.38, z = 18.881},
    {x = -1536.03, y = -672.69, z = 28.43},
    {x = -794.02, y = -68.65, z = 37.30},
    {x = 765.82, y = -35.08, z = 60.47},
    {x = 1607.71, y = 1069.81, z = 80.78},
    {x = 2076.416, y = 2637.080, z = 52.201}, 
    {x = 2611.445, y = 4291.455, z = 43.255}, 
    {x = 1178.238, y = 2682.901, z = 37.942}, 
    {x = -2657.091, y = 2642.114, z = 16.793}, 
    {x = -61.595, y = 6314.626, z = 31.300}, 
    {x = -235.101, y = 6299.659, z = 31.511}, 
    {x = -1199.509, y = -1243.117, z = 7.016}, 
    {x = -630.661, y = -351.474, z = 34.810}, 
    {x = -1007.083, y = -347.373, z = 37.885}, 
    {x = 186.835, y = -342.067, z = 44.062}, 
    {x = 793.725, y = -1934.862, z = 28.559}, 
    {x = 1605.019, y = 3673.189, z = 34.508},
    {x = -1874.16796875, y = -391.97225952148, z = 47.682926177979}
    
}

RegisterNetEvent("radar:getBrouilleurON")
AddEventHandler("radar:getBrouilleurON", function()
    onBrouilleur = true
end)

RegisterNetEvent("radar:getCoyoteON")
AddEventHandler("radar:getCoyoteON", function()
	for k, v in pairs(RadarZone) do
		local radius7 = AddBlipForRadius(v.x, v.y, v.z, 30.0)
		SetBlipSprite(radius7, 873)
		SetBlipColour(radius7, 40)
		SetBlipAlpha(radius7, 80)
		SetBlipAsShortRange(radius7, 1)
	end
	ESX.ShowNotification("~y~Vous avez activé votre coyote")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped)
        local coordsJoueur = GetEntityCoords(veh, true)
        local speed = GetEntitySpeed(veh)
        local calculatedspeed = speed*3.6
        if calculatedspeed >= 100.0 then
            for k,v in pairs(RadarZone) do
                local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, coordsJoueur, true)
                if distance <= 20.0 then
                    if GetPedInVehicleSeat(veh, -1) == ped then
                        local vitesse = ESX.Math.Round(calculatedspeed, 0)
                        if vitesse >= 170.0 and vitesse <= 190.0 then
                            if PlayerData.job.name == 'police' or PlayerData.job.name == 'ems' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'gouv' or PlayerData.job.name == 'lsfd' or PlayerData.job.name == 'marshall' or onBrouilleur == true then
                                return
                            elseif onBrouilleur == true then
                                ESX.ShowAdvancedNotification("RADAR", "~b~Brouilleur", "Vous avez évité un flash grace à votre brouilleur", "CHAR_LS_TOURIST_BOARD", 8)
                            else
                                PlaySoundFrontend(-1, "Camera_Shoot", "Phone_Soundset_Franklin", 1)
                                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
								ESX.ShowAdvancedNotification("RADAR", "~b~Excès de vitesse", "Vous avez été flashé !\n\nVitesse: ~b~"..vitesse.." Km/h\n\n~w~Vous n'avez pas été amendé, mais ~r~attention !", "CHAR_LS_TOURIST_BOARD", 8)
                            end
                        elseif vitesse >= 190.0 then
                            if PlayerData.job.name == 'police' or PlayerData.job.name == 'ems' or PlayerData.job.name == 'sheriff' or PlayerData.job.name == 'gouv' or PlayerData.job.name == 'lsfd' or PlayerData.job.name == 'marshall' then
                                return
                            elseif onBrouilleur == true then
								ESX.ShowAdvancedNotification("RADAR", "~b~Brouilleur", "Vous avez évité un flash grace à votre brouilleur", "CHAR_LS_TOURIST_BOARD", 8)
                            else
                                PlaySoundFrontend(-1, "Camera_Shoot", "Phone_Soundset_Franklin", 1)
                                PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 1)
                                local prix = ESX.Math.Round(vitesse*15, 0)
                                local playerId = GetPlayerIndex()
                                local id = GetPlayerServerId(playerId)
                                ESX.ShowAdvancedNotification("RADAR", "~b~Excès de vitesse", "Vous avez été flashé !\n\nVitesse: ~b~"..vitesse.." Km/h\n\n~s~Vous avez payé une amende de ~b~"..prix.." $ ~s~pour votre excès de vitesse !", "CHAR_LS_TOURIST_BOARD", 8)
                                TriggerServerEvent("LSPD:Radar", prix, vitesse, id)
                            end
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("LSPD:NotifRadar")
AddEventHandler("LSPD:NotifRadar", function(prix, vitesse, id)
    ESX.ShowAdvancedNotification("RADAR LSPD", "~b~Excès de vitesse", "Un citoyen à été flashé !\nVitesse: ~b~"..vitesse.." Km/h\n~w~Amende de ~r~"..prix.."~y~$~w~ donné.", "CHAR_LS_TOURIST_BOARD", 8)
end)