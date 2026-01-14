
myRank = "user"

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.TriggerServerCallback("context:getMyRank", function(rank) 
        myRank = rank
    end)
end)

CreateThread(function() 
    ESX.TriggerServerCallback("context:getMyRank", function(rank) 
        myRank = rank
    end)
end)

models = {
	[`p_phonograph01x`]  = {
		label = "Phonograph"
	},
	[`prop_radio_01`] = {
		label = "Radio"
	},
	[`prop_boombox_01`] = {
		label = "Boombox"
	},
	[`prop_portable_hifi_01`] = {
		label = "Boombox"
	},
	[`prop_ghettoblast_01`] = {
		label = "Boombox"
	},
	[`prop_ghettoblast_02`] = {
		label = "Boombox"
	},
	[`prop_tapeplayer_01`] = {
		label = "Tape Player"
	},
	[`bkr_prop_clubhouse_jukebox_01a`] = {
		label = "Jukebox"
	},
	[`bkr_prop_clubhouse_jukebox_01b`] = {
		label = "Jukebox"
	},
	[`bkr_prop_clubhouse_jukebox_02a`] = {
		label = "Jukebox"
	},
	[`ch_prop_arcade_jukebox_01a`] = {
		label = "Jukebox"
	},
	[`prop_50s_jukebox`] = {
		label = "Jukebox"
	},
	[`prop_jukebox_01`] = {
		label = "Jukebox"
	},
	[`v_res_j_radio`] = {
		label = "Radio"
	},
	[`v_res_fa_radioalrm`] = {
		label = "Alarm Clock"
	},
	[`prop_mp3_dock`] = {
		label = "MP3 Dock"
	},
	[`v_res_mm_audio`] = {
		label = "MP3 Dock"
	},
	[`sm_prop_smug_radio_01`] = {
		label = "Radio"
	},
	[`ex_prop_ex_tv_flat_01`] = {
		label = "TV",
		renderTarget = "ex_tvscreen"
	},
	[`prop_tv_flat_01`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_tv_flat_02`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_tv_flat_02b`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_tv_flat_03`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_tv_flat_03b`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_tv_flat_michael`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_monitor_w_large`] = {
		label = "Monitor",
		renderTarget = "tvscreen"
	},
	[`hei_prop_dlc_tablet`] = {
		label = "Tablet",
		renderTarget = "tablet"
	},
	[`prop_trev_tv_01`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_tv_02`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_tv_03`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_tv_03_overlay`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_laptop_lester2`] = {
		label = "Laptop",
		renderTarget = "tvscreen"
	},
	[`des_tvsmash_start`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_flatscreen_overlay`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`prop_monitor_02`] = {
		label = "Monitor",
		renderTarget = "tvscreen"
	},
	[`prop_big_cin_screen`] = {
		label = "Cinema",
		renderTarget = "cinscreen"
	},
	[`v_ilev_cin_screen`] = {
		label = "Cinema",
		renderTarget = "cinscreen"
	},
	[`v_ilev_lest_bigscreen`] = {
		label = "Projector",
		renderTarget = "tvscreen"
	},
	[`v_ilev_mm_screen`] = {
		label = "Projector",
		renderTarget = "big_disp"
	},
	[`v_ilev_mm_screen2`] = {
		label = "Projector",
		renderTarget = "tvscreen"
	},
	[`ba_prop_battle_club_computer_01`] = {
		label = "Computer",
		renderTarget = "club_computer"
	},
	[`ba_prop_club_laptop_dj`] = {
		label = "Laptop",
		renderTarget = "laptop_dj"
	},
	[`ba_prop_club_laptop_dj_02`] = {
		label = "Laptop",
		renderTarget = "laptop_dj_02"
	},
	[`sm_prop_smug_monitor_01`] = {
		label = "Computer",
		renderTarget = "smug_monitor_01"
	},
	[`xm_prop_x17_tv_flat_01`] = {
		label = "TV",
		renderTarget = "tv_flat_01"
	},
	[`sm_prop_smug_tv_flat_01`] = {
		label = "TV",
		renderTarget = "tv_flat_01"
	},
	[`xm_prop_x17_computer_02`] = {
		label = "Monitor",
		renderTarget = "monitor_02"
	},
	[`xm_prop_x17_screens_02a_01`] = {
		label = "Screen",
		renderTarget = "prop_x17_8scrn_01"
	},
	[`xm_prop_x17_screens_02a_02`] = {
		label = "Screen",
		renderTarget = "prop_x17_8scrn_02"
	},
	[`xm_prop_x17_screens_02a_03`] = {
		label = "Screen",
		renderTarget = "prop_x17_8scrn_03"
	},
	[`xm_prop_x17_screens_02a_04`] = {
		label = "Screen",
		renderTarget = "prop_x17_8scrn_04"
	},
	[`xm_prop_x17_screens_02a_05`] = {
		label = "Screen",
		renderTarget = "prop_x17_8scrn_05"
	},
	[`xm_prop_x17_screens_02a_06`] = {
		label = "Screen",
		renderTarget = "prop_x17_8scrn_06"
	},
	[`xm_prop_x17_screens_02a_07`] = {
		label = "Screen",
		renderTarget = "prop_x17_8scrn_07"
	},
	[`xm_prop_x17_screens_02a_08`] = {
		label = "Screen",
		renderTarget = "prop_x17_8scrn_08"
	},
	[`xm_prop_x17_tv_ceiling_scn_01`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_ceil_scn_01"
	},
	[`xm_prop_x17_tv_ceiling_scn_02`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_ceil_scn_02"
	},
	[`xm_prop_x17_tv_scrn_01`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_01"
	},
	[`xm_prop_x17_tv_scrn_02`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_02"
	},
	[`xm_prop_x17_tv_scrn_03`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_03"
	},
	[`xm_prop_x17_tv_scrn_04`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_04"
	},
	[`xm_prop_x17_tv_scrn_05`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_05"
	},
	[`xm_prop_x17_tv_scrn_06`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_06"
	},
	[`xm_prop_x17_tv_scrn_07`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_07"
	},
	[`xm_prop_x17_tv_scrn_08`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_08"
	},
	[`xm_prop_x17_tv_scrn_09`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_09"
	},
	[`xm_prop_x17_tv_scrn_10`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_10"
	},
	[`xm_prop_x17_tv_scrn_11`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_11"
	},
	[`xm_prop_x17_tv_scrn_12`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_12"
	},
	[`xm_prop_x17_tv_scrn_13`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_13"
	},
	[`xm_prop_x17_tv_scrn_14`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_14"
	},
	[`xm_prop_x17_tv_scrn_15`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_15"
	},
	[`xm_prop_x17_tv_scrn_16`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_16"
	},
	[`xm_prop_x17_tv_scrn_17`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_17"
	},
	[`xm_prop_x17_tv_scrn_18`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_18"
	},
	[`xm_prop_x17_tv_scrn_19`] = {
		label = "TV",
		renderTarget = "prop_x17_tv_scrn_18"
	},
	[`xm_screen_1`] = {
		label = "Screen",
		renderTarget = "prop_x17_tv_ceiling_01"
	},
	[`ex_prop_monitor_01_ex`] = {
		label = "Computer",
		renderTarget = "prop_ex_computer_screen"
	},
	[`gr_prop_gr_laptop_01a`] = {
		label = "Laptop",
		renderTarget = "gr_bunker_laptop_01a"
	},
	[`gr_prop_gr_laptop_01b`] = {
		label = "Laptop",
		renderTarget = "gr_bunker_laptop_sq_01a"
	},
	[`gr_prop_gr_trailer_monitor_01`] = {
		label = "Monitor",
		renderTarget = "gr_trailer_monitor_01"
	},
	[`gr_prop_gr_trailer_monitor_02`] = {
		label = "Monitor",
		renderTarget = "gr_trailer_monitor_02"
	},
	[`gr_prop_gr_trailer_monitor_03`] = {
		label = "Monitor",
		renderTarget = "gr_trailer_monitor_03"
	},
	[`gr_prop_gr_trailer_tv`] = {
		label = "TV",
		renderTarget = "gr_trailertv_01"
	},
	[`gr_prop_gr_trailer_tv_02`] = {
		label = "TV",
		renderTarget = "gr_trailertv_02"
	},
	[`hei_prop_dlc_heist_board`] = {
		label = "Projector",
		renderTarget = "heist_brd"
	},
	[`hei_prop_hei_monitor_overlay`] = {
		label = "Monitor",
		renderTarget = "hei_mon"
	},
	[`sr_mp_spec_races_blimp_sign`] = {
		label = "Blimp",
		renderTarget = "blimp_text"
	},
	[`xm_prop_orbital_cannon_table`] = {
		label = "Orbital Cannon",
		renderTarget = "orbital_table"
	},
	[`imp_prop_impexp_lappy_01a`] = {
		label = "Laptop",
		renderTarget = "prop_impexp_lappy_01a"
	},
	[`w_am_digiscanner`] = {
		label = "Digiscanner",
		renderTarget = "digiscanner"
	},
	[`prop_phone_cs_frank`] = {
		label = "Phone",
		renderTarget = "npcphone"
	},
	[`prop_phone_proto`] = {
		label = "Phone",
		renderTarget = "npcphone"
	},
	[`prop_huge_display_01`] = {
		label = "Screen",
		renderTarget = "big_disp"
	},
	[`prop_huge_display_02`] = {
		label = "Screen",
		renderTarget = "big_disp"
	},
	[`hei_prop_hei_muster_01`] = {
		label = "Whiteboard",
		renderTarget = "planning"
	},
	[`ba_prop_battle_hacker_screen`] = {
		label = "Tablet",
		renderTarget = "prop_battle_touchscreen_rt"
	},
	[`xm_prop_x17_sec_panel_01`] = {
		label = "Panel",
		renderTarget = "prop_x17_p_01"
	},
	[`bkr_prop_clubhouse_laptop_01a`] = {
		label = "Laptop",
		renderTarget = "prop_clubhouse_laptop_01a"
	},
	[`bkr_prop_clubhouse_laptop_01b`] = {
		label = "Laptop",
		renderTarget = "prop_clubhouse_laptop_square_01a"
	},
	[`prop_tv_flat_01_screen`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`hei_prop_hst_laptop`] = {
		label = "Laptop",
		renderTarget = "tvscreen"
	},
	[`hei_bank_heist_laptop`] = {
		label = "Laptop",
		renderTarget = "tvscreen"
	},
	[`xm_prop_x17dlc_monitor_wall_01a`] = {
		label = "Screen",
		renderTarget = "prop_x17dlc_monitor_wall_01a"
	},
	[`ch_prop_ch_tv_rt_01a`] = {
		label = "TV",
		renderTarget = "ch_tv_rt_01a"
	},
	[`apa_mp_h_str_avunitl_01_b`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`apa_mp_h_str_avunitl_04`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`apa_mp_h_str_avunitm_01`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`apa_mp_h_str_avunitm_03`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`apa_mp_h_str_avunits_01`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`apa_mp_h_str_avunits_04`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`hei_heist_str_avunitl_03`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`xs_prop_arena_screen_tv_01`] = {
		label = "TV",
		renderTarget = "screen_tv_01"
	},
	[`xs_prop_arena_bigscreen_01`] = {
		label = "Jumbotron",
		renderTarget = "bigscreen_01"
	},
	[`vw_prop_vw_arcade_01_screen`] = {
		label = "Arcade Machine",
		renderTarget = "arcade_01a_screen"
	},
	[`vw_prop_vw_arcade_02_screen`] = {
		label = "Arcade Machine",
		renderTarget = "arcade_02a_screen"
	},
	[`vw_prop_vw_arcade_02b_screen`] = {
		label = "Arcade Machine",
		renderTarget = "arcade_02b_screen"
	},
	[`vw_prop_vw_arcade_02c_screen`] = {
		label = "Arcade Machine",
		renderTarget = "arcade_02c_screen"
	},
	[`vw_prop_vw_arcade_02d_screen`] = {
		label = "Arcade Machine",
		renderTarget = "arcade_02d_screen"
	},
	[`vw_prop_vw_cinema_tv_01`] = {
		label = "TV",
		renderTarget = "tvscreen"
	},
	[`pbus2`] = {
		attenuation = {sameRoom = 1.5, diffRoom = 6},
		range = 100,
		isVehicle = false
	},
	[`blimp3`] = {
		attenuation = {sameRoom = 0.6, diffRoom = 6},
		range = 150,
		isVehicle = false
	},
}
Citizen.CreateThread(function()
    for k,v in pairs(models) do
        k = GetHashKey(k)
    end
end)

function CheckQuantity(number)
	number = tonumber(number)
  
	if type(number) == 'number' then
	  	number = ESX.Math.Round(number)
  
	  	if number > 0 then
			return true, number
	  	end
	end
  
	return false, number
end

RegisterNetEvent("cn5:PLZremoveVehicleWheels")
AddEventHandler("cn5:PLZremoveVehicleWheels", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())

    if DoesEntityExist(vehicle) then
        for i = 0, 3 do
            BreakOffVehicleWheel(vehicle, i, true, false, true, false)
        end
    end
end)

RegisterNetEvent("cn5:PLZrepairVehicle")
AddEventHandler("cn5:PLZrepairVehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    NetworkRequestControlOfEntity(vehicle)
    while not NetworkHasControlOfEntity(vehicle) do
        Wait(1)
    end
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleEngineHealth(vehicle, 1000.0)
end)

RegisterNetEvent("cn5:PLZdestroyVehicle")
AddEventHandler("cn5:PLZdestroyVehicle", function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(vehicle))
end)

RegisterNetEvent('gangs:sendIdentityInfos')
AddEventHandler('gangs:sendIdentityInfos', function(firstname, lastname, name, sex, dob, height)
    ExecuteCommand("me prend une carte d'identité")
    ExecuteCommand("e idcard")

    if sex == "m" then
        sex = "Homme"
    elseif sex == "f" then
        sex = "Femme"
    end

    Citizen.Wait(1000)
    ESX.ShowAdvancedNotification('Identité', '~b~Citoyen', 'Prénom: ~y~'..firstname..'\n~w~Nom: ~y~' ..lastname..'\n~w~Taille: ~y~' ..height..'\n~w~Sex: ~y~' ..sex..'\n~w~Date de naissance: ~y~' ..dob..'\n~w~ID: ~y~' ..name, 'CHAR_BLANK_ENTRY', 8)
    Citizen.Wait(2000)

    ExecuteCommand("e stop_animation")
end)

RegisterNetEvent('gangs:openFouille')
AddEventHandler('gangs:openFouille', function(selectedTarget)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local targetPed = GetPlayerPed(GetPlayerFromServerId(selectedTarget))
    local targetCoords = GetEntityCoords(targetPed)
        
    if #(playerCoords - targetCoords) >= 3.0 then
        ESX.ShowNotification("Vous êtes trop loin")
        return
    end
    
    TriggerServerEvent("inventory:server:OpenFouille", selectedTarget)
end)

local carrying = false

exports("isCarrying", function()
	return carrying == true
end)

exports.ox_target:addGlobalPlayer({
    {
		name = 'cuff',
        icon = 'fa-solid fa-handcuffs',
        label = "Menotter/Démenotter",
        distance = 1,
        onSelect = function(data)
			local serverID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))

			if getIsHandcuffed() == false then
				if not IsEntityDead(GetPlayerPed(GetPlayerFromServerId(serverID))) then
        		    ExecuteCommand("me menotte quelqu'un")
        		    ExecuteCommand("e uncuff")
        		    TriggerServerEvent('braco:handcuff', serverID)
        		    Citizen.Wait(1000)
        		    ExecuteCommand("e stop_animation")
        		end
			else
				ESX.ShowNotification("~o~Vous ne pouvez pas effectuer cette action en étant menotté !")
			end
        end
    },
	{
		name = 'escort',
        icon = 'fa-solid fa-hands-bound',
        label = "Escorter",
        distance = 5,
        onSelect = function(data)
			local serverID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))

			if getIsHandcuffed() == false then
				carrying = not carrying
            	TriggerServerEvent('braco:drag', serverID)
			else
				ESX.ShowNotification("~o~Vous ne pouvez pas effectuer cette action en étant menotté !")
			end
        end
    },
	{
		name = 'inVehicle',
        icon = 'fa-solid fa-car-side',
        label = "Mettre dans un véhicule",
        distance = 5,
        onSelect = function(data)
			local serverID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))

			if getIsHandcuffed() == false then
				TriggerServerEvent('braco:putInVehicle', serverID)
			else
				ESX.ShowNotification("~o~Vous ne pouvez pas effectuer cette action en étant menotté !")
			end
        end
    },
	{
		name = 'search',
        icon = 'fa-solid fa-magnifying-glass',
        label = "Fouiller",
        distance = 5,
        onSelect = function(data)
			local serverID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))

			if getIsHandcuffed() == false then
				TriggerEvent("gangs:openFouille", serverID)
			else
				ESX.ShowNotification("~o~Vous ne pouvez pas effectuer cette action en étant menotté !")
			end
        end
    },
	{
		name = 'getIdentityFromPlayer',
        icon = 'fa-solid fa-passport',
        label = "Identité",
        distance = 5,
        onSelect = function(data)
			local serverID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))

			if getIsHandcuffed() == false then
				TriggerEvent("gangs:getIdentity2", serverID)
			else
				ESX.ShowNotification("~o~Vous ne pouvez pas effectuer cette action en étant menotté !")
			end
        end
    },
	{
		name = 'emoteCarry',
        icon = 'fa-solid fa-user-ninja',
        label = "Porter",
        distance = 5,
        onSelect = function(data)
			ExecuteCommand("nearby pcarrya1")
        end
    },
	{
		name = 'emoteImitation',
        icon = 'fa-solid fa-user-ninja',
        label = "Imiter l'animation",
        distance = 5,
        onSelect = function(data)
			local serverID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))

			if getIsHandcuffed() == false then
				TriggerServerEvent("dpemotes:getOtherEmote", serverID)
			else
				ESX.ShowNotification("~o~Vous ne pouvez pas effectuer cette action en étant menotté !")
			end
        end
    },
})

local maxDistance = 2.5

local modelsSoda = {
    'prop_vend_soda_01',
    'prop_vend_soda_02',
    'prop_vend_fridge01',
    'prop_food_bs_soda_01',
    'prop_food_cb_soda_01'
}

local optionsSoda = {
    {
        name = 'shark:sodaec',
        onSelect = function()
            lib.progressBar({
                duration = 4000,
                label = 'Achat du soda en cours...',
                useWhileDead = false,
                canCancel = true,
				distance = 2,
                disable = {
                    move = true,
                },
                anim = { dict = 'mini@sprunk', clip = 'plyr_buy_drink_pt1' },
            })
			TriggerServerEvent("context:buyStuff", 'coca')
        end,
        icon = 'fa-solid fa-jar',
        label = 'Acheter un eCola'
    },
}

exports.ox_target:addModel(modelsSoda, optionsSoda)

local modelsCoffee = {
    'ex_mp_h_acc_coffeemachine_01',
    'apa_mp_h_acc_coffeemachine_01',
    'hei_heist_kit_coffeemachine_01',
    'prop_coffee_mac_01',
    'prop_coffee_mac_02',
    'p_ld_coffee_vend_01',
    'prop_vend_coffe_01'
}

local optionsCoffee = {
    {
        name = 'coffee:get',
        onSelect = function()
            lib.progressBar({
                duration = 4000,
                label = 'Achat du café en cours...',
                useWhileDead = false,
				distance = 2,
                canCancel = true,
                disable = {
                    move = true,
                },
                anim = { dict = 'amb@prop_human_atm@male@idle_a', clip = 'idle_a' },
            })
			TriggerServerEvent("context:buyStuff", 'coffee')
        end,
        icon = 'fa-solid fa-jar',
        label = 'Acheter un café'
    },
}

exports.ox_target:addModel(modelsCoffee, optionsCoffee)

local modelsWater = {
    'prop_vend_water_01',
    'prop_watercooler_dark',
    'prop_vend_fridge01',
    'prop_watercooler'
}

local optionsWater = {
    {
        name = 'buy:water',
        onSelect = function()
            lib.progressBar({
                duration = 2000,
                label = "Remplissage de l'eau",
                useWhileDead = false,
				distance = 2,
                canCancel = true,
                disable = {
                    move = true,
                },
                anim = {
                    dict = 'amb@prop_human_atm@male@idle_a',
                    clip = 'idle_a'
                }
            })
			TriggerServerEvent("context:buyStuff", 'water')
        end,
        icon = 'fa-solid fa-bottle-water',
        label = "Acheter de l'eau"
    }
}

exports.ox_target:addModel(modelsWater, optionsWater)

local modelsSnack = {
    'prop_vend_snak_01',
    'prop_vend_snak_01_tu'
}

local optionsSnack = {
    {
        name = 'buy:chocolat',
        onSelect = function()
            lib.progressBar({
                duration = 2000,
                label = "Achat d'une barre de chocolat",
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = true,
                },
                anim = { dict = 'mini@sprunk', clip = 'plyr_buy_drink_pt1' },
            })
			TriggerServerEvent("context:buyStuff", 'snack')
        end,
        icon = 'fa-solid fa-cookie',
        label = "Acheter un snack"
    }
}

exports.ox_target:addModel(modelsSnack, optionsSnack)

local modelFernocot = {
    'fernocot'
}

local optionsEMSWOW = {
    {
        name = 'fernocotEMSPush',
        onSelect = function()
            ExecuteCommand("pushstr")
        end,
        icon = 'fa-solid fa-jar',
        label = 'Pousser le brancard'
    },
	{
        name = 'fernocotEMSSupp',
        onSelect = function()
            ExecuteCommand("deletestr")
        end,
        icon = 'fa-solid fa-jar',
        label = 'Supprimer le brancard'
    }
}

exports.ox_target:addModel(modelFernocot, optionsEMSWOW)

local modelAmbulance = {
    'sandbulance'
}

local optionsAmbulance = {
    {
        name = 'ambulanceInsertBran',
        onSelect = function()
            ExecuteCommand("togglestr")
        end,
        icon = 'fa-solid fa-jar',
        label = 'Insérer le brancard'
    },
	{
        name = 'ambulanceOpenDoors',
        onSelect = function()
            ExecuteCommand("openbaydoors")
        end,
        icon = 'fa-solid fa-jar',
        label = 'Ouvrir les portes'
    }
}

exports.ox_target:addModel(modelAmbulance, optionsAmbulance)

local atmModels = {
    'prop_fleeca_atm',
	'prop_atm_01',
	'prop_atm_02',
	'prop_atm_03'
}

local optionsATM = {
    {
        name = 'insertCard',
		distance = 1,
        onSelect = function()
			ExecuteCommand("e keyfob")
			Citizen.Wait(1000)
            TriggerEvent("banking:open")
        end,
        icon = 'fa-solid fa-jar',
        label = 'Insérer ma carte'
    }
}

exports.ox_target:addModel(atmModels, optionsATM)

local showers = {
    {-767.56, 327.43, 169.70},        -- High End Apartment
    {254.29, -1000.13, -99.93},       -- Low End Apartment
    {346.89, -995.13, -100.11},       -- Medium End Apartment
    {-38.57, -581.95, 77.87},         -- 4 Integrity Way, Apt 28
    {-32.47, -587.41, 82.95},         -- 4 Integrity Way, Apt 30    
    {-1453.75, -555.47, 71.88},       -- Dell Perro Heights, Apt 4
    {-1461.38, -534.96, 49.77},       -- Dell Perro Heights, Apt 7
    {-898.05, -368.57, 112.11},       -- Richard Majestic, Apt 2
    {-591.71, 49.14, 96.04},          -- Tinsel Towers, Apt 42
    {-796.38, 333.36, 209.93},        -- Eclipse Towers, Apt 3
    {-168.89, 489.73, 132.87},        -- 3655 Wild Oats Drive
    {335.91, 430.56, 145.6},          -- 2044 North Conker Avenue
    {373.9, 413.97, 141.13},          -- 2045 North Conker Avenue
    {-673.75, 588.4, 140.6},          -- 2862 Hillcrest Avenue
    {-765.49, 612.72, 139.36},        -- 2868 Hillcrest Avenue
    {-856.46, 682.36, 148.08},        -- 2874 Hillcrest Avenue
    {120.83, 551.01, 179.53},         -- 2677 Whispymound Drive    
    {-1287.27, 440.41, 93.12}         -- 2133 Mad Wayne Thunder
}

local isShowering = false

local function startShower()
    if isShowering then return end
    isShowering = true

    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		if skin.sex == 0 then
			local clothesSkin = {
			['bags_1'] = 0, ['bags_2'] = 0,
			['tshirt_1'] = 15, ['tshirt_2'] = 15,
			['torso_1'] = 15, ['torso_2'] = 0,
			['arms'] = 15,
			['pants_1'] = 61, ['pants_2'] = 6,
			['shoes_1'] = 34, ['shoes_2'] = 0,
			['mask_1'] = 0, ['mask_2'] = 0,
			['bproof_1'] = 0,
			['helmet_1'] = -1, ['helmet_2'] = 0,
			["decals_1"] = -1, ["decals_2"] = 0,
			['chain_1'] = 0, ['chain_2'] = 0,
			['glasses_1'] = 0, ['glasses_2'] = 0
			}
			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
		else
			local clothesSkinfemale = {
				['bags_1'] = 0, ['bags_2'] = 0,
				['tshirt_1'] = 15, ['tshirt_2'] = 15,
				['torso_1'] = 15, ['torso_2'] = 0,
				['arms'] = 15,
				['pants_1'] = 61, ['pants_2'] = 6,
				['shoes_1'] = 34, ['shoes_2'] = 0,
				['mask_1'] = 0, ['mask_2'] = 0,
				['bproof_1'] = 0,
				['helmet_1'] = -1, ['helmet_2'] = 0,
				["decals_1"] = -1, ["decals_2"] = 0,
				['chain_1'] = 0, ['chain_2'] = 0,
				['glasses_1'] = 0, ['glasses_2'] = 0
				}
				TriggerEvent('skinchanger:loadClothes', skin, clothesSkinfemale)
		end
	end)

    FreezeEntityPosition(playerPed, true)
    TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_STAND_IMPATIENT", 0, true)

    if not HasNamedPtfxAssetLoaded("core") then
        RequestNamedPtfxAsset("core")
        while not HasNamedPtfxAssetLoaded("core") do
            Wait(10)
        end
    end

    UseParticleFxAssetNextCall("core")
    local particles = StartParticleFxLoopedAtCoord("ent_sht_water", coords.x, coords.y, coords.z + 1.2, 0.0, 0.0, 0.0, 1.0, false, false, false, false)

    local timer = 8
    while timer > 0 do
        Wait(1000)
        timer = timer - 1
    end

    FreezeEntityPosition(playerPed, false)
    ClearPedTasksImmediately(playerPed)
    StopParticleFxLooped(particles, 0)

    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
		TriggerEvent('skinchanger:loadSkin', skin)
	end)

	lib.notify({
		title = 'Douche',
		description = "Vous êtes tout propre !",
		type = 'success',
		position = 'top',
		duration = 5000,
	})
    isShowering = false
end

for _, coords in ipairs(showers) do
    exports.ox_target:addSphereZone({
        coords = vec3(coords[1], coords[2], coords[3]),
        radius = 2,
        debug = false,
        options = {
            {
                label = "Prendre une douche",
                icon = "fa-solid fa-shower",
				distance = 2,
                onSelect = startShower
            }
        }
    })
end

-- FUEL :

local jerryCanItem = 'jerrycan'
local fuelPerUse = 20
local refillTime = 5000

local function refillVehicle(vehicle)
    if not vehicle or not DoesEntityExist(vehicle) then return end

    local currentFuel = GetVehicleFuelLevel(vehicle)
    if currentFuel >= 100 then
        lib.notify({ type = 'error', description = 'Le réservoir est déjà plein.' })
        return
    end

	ESX.TriggerServerCallback("fuel:getItem", function(isGood)
		if isGood then
			lib.progressCircle({
				duration = refillTime,
				position = 'bottom',
				useWhileDead = false,
				canCancel = true,
				disable = {
					move = true,
					car = true,
					combat = true,
				},
				anim = {
					dict = 'weapon@w_sp_jerrycan',
					clip = 'fire',
				},
			})
		
			local newFuel = math.min(currentFuel + fuelPerUse, 100)
			SetVehicleFuelLevel(vehicle, 100.0)
			DecorSetFloat(vehicle, "_ANDY_FUEL_DECORE_", 100.0)
		
			lib.notify({ type = 'success', description = 'Vous avez rempli le réservoir.' })
		else
			lib.notify({ type = 'error', description = "Vous n'avez pas de jerrycan sur vous !" })
			return
		end
	end)
end

exports.ox_target:addGlobalVehicle({
    label = 'Remplir avec un jerrycan',
    icon = 'fa-solid fa-gas-pump',
    distance = 2.5,
    onSelect = function(data)
        refillVehicle(data.entity)
    end
})

local modelChips = {
    'v_ret_247shelves01'
}

local optionsChips = {
    {
        name = 'buy:chips',
        onSelect = function()
            lib.progressBar({
                duration = 2000,
                label = "Vol de chips",
                useWhileDead = false,
				distance = 2,
                canCancel = true,
                disable = {
                    move = true,
                }
            })
			ExecuteCommand("me vole des chips")
			TriggerServerEvent("context:buyStuff", 'chips')
        end,
        icon = 'fa-solid fa-cookie',
        label = "Voler des chips"
    }
}

exports.ox_target:addModel(modelChips, optionsChips)

local modelNoodles = {
    'v_ret_247shelves05'
}

local optionsNoodles = {
    {
        name = 'buy:noodles',
        onSelect = function()
            lib.progressBar({
                duration = 2000,
                label = "Vol de nouilles",
                useWhileDead = false,
				distance = 2,
                canCancel = true,
                disable = {
                    move = true,
                }
            })
			ExecuteCommand("me vole des nouilles")
			TriggerServerEvent("context:buyStuff", 'nouilles')
        end,
        icon = 'fa-solid fa-cookie',
        label = "Voler des nouilles"
    }
}

exports.ox_target:addModel(modelNoodles, optionsNoodles)

local modelHotDogs = {
    'prop_hotdogstand_01'
}

local optionsHotdogs = {
    {
        name = 'buy:hotdog',
        onSelect = function()
            lib.progressBar({
                duration = 2000,
                label = "Achat de hotdog",
                useWhileDead = false,
				distance = 2,
                canCancel = true,
                disable = {
                    move = true,
                }
            })
			TriggerServerEvent("context:buyStuff", 'hotdog')
        end,
        icon = 'fa-solid fa-cookie',
        label = "Acheter un hotdog"
    }
}

exports.ox_target:addModel(modelHotDogs, optionsHotdogs)