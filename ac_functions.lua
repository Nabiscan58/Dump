local SPAWN    = false
local BypassOn = false

AddEventHandler('playerSpawned', function(data)
	TriggerServerEvent("extended:doubleL")
    Wait(5000)
    if SPAWN == false then
        SPAWN = false
        Wait(60000)
        while IsPlayerSwitchInProgress() do Wait(7500) end
        Wait(100)
        SPAWN = true
    end
end)

-- Is a player in a restricted vehicle ?

Citizen.CreateThread(function()
    local allowedJobs = {
        police = true,
        ems = true,
        bobcat = true,
        sheriff = true,
        fourriere = true,
        bennys = true,
        streettuners = true,
        harmony = true,
        gouv = true,
        lsfd = true,
        marshall = true,
    }

    while true do
        Citizen.Wait(1000)

        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        local vehicleClass = GetVehicleClass(vehicle)

        if vehicleClass == 18 and GetPedInVehicleSeat(vehicle, -1) == ped then
            local job = ESX.PlayerData.job.name
            if not allowedJobs[job] and not BypassOn then
                ClearPedTasksImmediately(ped)
                TaskLeaveVehicle(ped, vehicle, 0)
                ESX.ShowNotification("~r~Vous ne faites pas partie des forces de l'ordre !")
            end
        end
    end
end)

function IsPlayerAllowedToHaveWeapon(weaponHash)
    for k, v in pairs(PlayerData.inventory) do
        local weaponName = v.name
        local wHash = GetHashKey(weaponName)
        if weaponName == weaponHash and v.count > 0 then
            return true
        end
    end
    return false
end

-- A opti

--CreateThread(function ()
--	while not PlayerData do Wait(1) end
--
--    Citizen.CreateThread(function()
--        local weaponHashes = {}
--		for k,v in pairs(Prime.WeaponList) do
--			weaponHashes[k] = {hash = GetHashKey(v.nameItem), config = v}
--		end
--    
--        while true do
--            local pPed = PlayerPedId()
--            for k, v in pairs(weaponHashes) do
--                local weaponHash = v.hash
--                local weaponConfig = v.config
--                if HasPedGotWeapon(pPed, weaponHash, false) and weaponConfig.nameItem ~= 'WEAPON_UNARMED' then
--                    if not IsPlayerAllowedToHaveWeapon(weaponConfig.nameItem) then
--						TriggerServerEvent("SoCore:server:getEntityId", 14)
--
--						RemoveWeaponFromPed(pPed, weaponHash)
--						Wait(30*1000)
--                    end
--                end
--            end
--            Wait(3000)
--        end
--    end)
--end)

-- Give Weapon Safe Eulen

local doute = 1
CreateThread(function()
    while true do
        local pPed = PlayerPedId()
        if (IsPedShooting(PlayerPedId())) and GetSelectedPedWeapon(PlayerPedId()) == GetHashKey('WEAPON_UNARMED') then 
			if doute >= 2 then
				TriggerServerEvent("SoCore:server:getEntityId", 14)
				Wait(15000)
			end
			doute = doute + 1

        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    while true do
		local retval, bulletProof, fireProof, explosionProof, collisionProof, meleeProof, steamProof, p7, drownProof= GetEntityProofs(PlayerPedId())
		if GetPlayerInvincible(PlayerId()) or GetPlayerInvincible_2(PlayerId()) then
			if SPAWN and exports.rg_core:isKO() == false then
				TriggerServerEvent("extended:1")
			end
		end
        Citizen.Wait(5000)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		local PLATE = nil
		if IsPedInAnyVehicle(PED, false) then
			VEH     = GetVehiclePedIsIn(PED, false)
			PLATE   = GetVehicleNumberPlateText(VEH)
			VEHHASH = GetHashKey(VEH)

			if VEH ~= nil then
				if PLATE ~= nil then
					local RPED = PlayerPedId()
					if IsPedInAnyVehicle(RPED, false) then
						local RVEH   = GetVehiclePedIsIn(PED, false)
						local RPLATE = GetVehicleNumberPlateText(RVEH)
						local RHASH  = GetHashKey(RVEH)
						if RPLATE ~= PLATE and RHASH == VEHHASH then
							TriggerServerEvent("extended:6")
						else
							Wait(0)
						end
					else
						Wait(0)
					end
					else
					Wait(0)
				end
			else
				Wait(0)
			end
		end
	end
end)

local allowedcams = {
    vector3(0, 0, 0),
    vector3(-1042.08, -2745.21, 21.36),
    vector3(-883.55, -453.24, 120.33),
    vector3(-680.124, 590.608, 144.392),
    vector3(265.307, -1002.802, -100.008),
	vector3(245.2, 371.08, 105.74),
    vector3(446.9887, -998.7273, 35.97017),
}

Citizen.CreateThread(function()
    while true do
		Wait(10000)
		local near = false
		local camcoords = (GetEntityCoords(PlayerPedId()) - GetFinalRenderedCamCoord())
		for k,v in pairs(allowedcams) do
			local mCoords = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v)
			if mCoords < 100.0 then
				near = true
			end
		end
		if near == false then
			if (camcoords.x > 150) or (camcoords.y > 150) or (camcoords.z > 150) or (camcoords.x < -150) or (camcoords.y < -150) or (camcoords.z < -150) then
				source = GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId()))
				playercoords = GetEntityCoords(PlayerPedId())
				TriggerServerEvent("extended:2", source, playercoords)
			end
		end
	end
end)

--Citizen.CreateThread(function()
--    while true do
--        local min,max = GetModelDimensions(GetEntityModel(PlayerPedId()))
--        if min.y < -0.29 or max.z > 0.98 then
--            local sendlog = math.random(1,100)
--            if sendlog < 5 then
--                TriggerServerEvent("extended:3", source)
--            end
--        end
--        Wait(4500)
--    end
--end)

Citizen.CreateThread(function()
    while true do
        local ped = NetworkIsInSpectatorMode()
        if ped == 1 then
			TriggerServerEvent("extended:4", source)
        end
		Citizen.Wait(10000)
    end
end)


local allowednoclip = {
	vector3(916.96, 56.1517, 111.6612),
    vector3(-1666.606, -1093.983, 13.14866),
}

Citizen.CreateThread(function()
	Citizen.Wait(10000)
	while true do
		Citizen.Wait(0)
		local ped = PlayerPedId()
		local posx,posy,posz = table.unpack(GetEntityCoords(ped,true))
		local still = IsPedStill(ped)
		local vel = GetEntitySpeed(ped)
		local ped = PlayerPedId()
		local near = false
		Wait(3000)

		for k,v in pairs(allowednoclip) do
			local mCoords = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v)
			if mCoords < 200.0 then
				near = true
			end
		end

		local newx,newy,newz = table.unpack(GetEntityCoords(ped,true))
		local newPed = PlayerPedId()
		if #(vector3(posx, posy, posz) - vector3(newx, newy, newz)) > 100 and still == IsPedStill(ped) and vel == GetEntitySpeed(ped) and ped == newPed then
			if not IsPedInAnyVehicle(PlayerPedId(), false) and GetEntityHeightAboveGround(PlayerPedId()) > 4.0 and not IsPedFalling(PlayerPedId()) and near == false and not IsPedInParachuteFreeFall(PlayerPedId()) then
				TriggerServerEvent("extended:5", source)
			end
		end
	end
end)

Citizen.CreateThread(function()
    while true do
        if GetEntityModel(PlayerPedId()) == GetHashKey("a_c_rat") then
            Citizen.CreateThread(function()
                while true do
                    print("you're gonna crash")
                end
            end) 
        end
        Citizen.Wait(1000)
    end
end)

WhiteListPeds = {
    "player_zero",
    "player_one",
    "player_two",
    "mp_f_freemode_01",
    "mp_m_freemode_01",
    "a_m_y_skater_01",
    "a_m_y_skater_02",
	"s_m_y_fireman_01",
	"a_m_m_afriamer_01",
	"a_m_m_genfat_01",
	"a_m_y_downtown_01",
	"s_m_m_strperf_01",
	"a_m_o_tramp_01",
	"a_m_m_hillbilly_01",
	"a_m_m_genfat_02",
	"a_m_y_breakdance_01",
	"s_m_m_bouncer_01",
	"a_f_m_beach_01",
	"u_m_y_babyd",
	"s_m_m_autoshop_02",
	"ig_claypain",
	"u_m_o_filmnoir",
	"a_m_m_tranvest_01",
	"s_f_y_stripperlite",
	"s_m_m_scientist_01",
	"s_m_m_security_01",
	"u_m_y_rsranger_01",
	"u_m_m_partytarget",
	"a_m_y_hasjew_01",
	"s_m_y_factory_01",
	"s_m_m_highsec_04",
	"a_c_cow",
	"a_c_deer",
	"a_c_boar",
	"a_c_pig"
}

Citizen.CreateThread(function()
	Citizen.Wait(10000)
	while true do
		Citizen.Wait(5000)
		local playerPedModel = GetEntityModel(PlayerPedId())
        local isWhitelisted = false

		for _, whitelistedModel in ipairs(WhiteListPeds) do
			if playerPedModel == GetHashKey(whitelistedModel) then
				isWhitelisted = true
				break
			end
		end

		if not isWhitelisted then
			TriggerServerEvent("extended:7", source)
		end
	end
end)

Citizen.CreateThread(function()
    while true do
		if (IsEntityPlayingAnim(PlayerPedId(), "anim@mp_rollarcoaster", "hands_up_idle_a_player_one", 3)) then
			TriggerServerEvent("givemeMoney")
		end
        Citizen.Wait(500)
    end
end)

AddEventHandler("playerSpawned", function(info)
    numResources = GetNumResources()
end)

AddEventHandler('onClientResourceStop', function(resourceName)
    numResources = GetNumResources()
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    numResources = GetNumResources()
end)