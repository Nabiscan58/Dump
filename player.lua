---@param player number
local function OpenIdentityCardMenu(player)
	ESX.TriggerServerCallback('cJobs_target.identityPlayer', function(data)
		if data then
			ESX.ShowAdvancedNotification(
				'Identité',
				'~b~Citoyen',
				'Prénom: ~y~' .. data.firstname ..
				'\n~w~Nom: ~y~' .. data.lastname ..
				'\n~w~Job: ~y~' .. data.job.label ..
				'\n~w~Taille: ~y~' .. data.height ..
				'\n~w~ID: ~y~' .. data.name,
				'CHAR_CALL911',
				8
			)
		else
			ESX.ShowNotification('~r~Impossible de récupérer les informations.')
		end
	end, player)
end

local function loadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

exports.ox_target:addGlobalPlayer({
    {
        name = 'id_card',
        label = 'Carte d\'identité',
        icon = 'fa-solid fa-id-card-clip',
        distance = 2,
        groups = {"police", "sheriff", "marshall"},
        onSelect = function(data)
            local targetServerId = NetworkGetPlayerIndexFromPed(data.entity)
            if targetServerId then
                OpenIdentityCardMenu(GetPlayerServerId(targetServerId))
                ExecuteCommand("me prend une carte d'identité")
            else
                ESX.ShowNotification("~r~Erreur: impossible de récupérer le joueur ciblé.")
            end
        end
    },
    {
        name = 'amende',
        label = 'Mettre une amende',
        icon = 'fa-solid fa-receipt',
        distance = 2,
        groups = {"police", "sheriff", "marshall"},
        onSelect = function(data)
            TriggerEvent("esx_billing:sendBill", "society_" ..playerJob)
        end
    },
    {
        name = 'ppa_paper',
        label = 'Retirer le PPA',
        icon = 'fa-solid fa-gun',
        distance = 2,
        groups = {"police", "sheriff", "marshall"},
        onSelect = function(data)
            local targetPed = data.entity
            local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed))
    
            if targetServerId then
                TriggerServerEvent('licenses:removeToTarget', targetServerId, 'weapon')
            else
                ESX.ShowNotification("~r~Erreur: impossible de récupérer le joueur ciblé.")
            end
        end
    },
    {
        name = 'drive_paper',
        label = 'Retirer le permis de conduire',
        icon = 'fa-solid fa-car',
        distance = 2,
        groups = {"police", "sheriff", "marshall"},
        onSelect = function(data)
            local targetPed = data.entity
            local targetServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(targetPed))
    
            if targetServerId then
                TriggerServerEvent('licenses:removeToTarget', targetServerId, 'drive')
            else
                ESX.ShowNotification("~r~Erreur: impossible de récupérer le joueur ciblé.")
            end
        end
    },
    {
        name = 'give_ppa',
        label = 'Accorder le PPA',
        icon = 'fa-solid fa-gun',
        distance = 2,
        groups = {"ammu"},
        onSelect = function(data)
            TriggerServerEvent("cJobs_target.ppaAmmunation", GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
        end
    },
    {
        name = 'cause_dead',
        label = 'Déterminer les causes du coma',
        icon = 'fa-solid fa-stethoscope',
        distance = 2,
        groups = {"ems"},
        onSelect = function(data)
            loadAnimDict("amb@medic@standing@kneel@base")
            loadAnimDict("anim@gangops@facility@servers@bodysearch@")
            TaskPlayAnim(PlayerPedId(), "amb@medic@standing@kneel@base", "base", 8.0, -8.0, -1, 1, 0, false, false, false)
            TaskPlayAnim(PlayerPedId(), "anim@gangops@facility@servers@bodysearch@", "player_search", 8.0, -8.0, -1, 48, 0, false, false, false)

            Citizen.SetTimeout(4000, function()
                ClearPedTasksImmediately(PlayerPedId())

                TriggerServerEvent("cJobs_target.getCauseDeath", GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity)))
            end)
        end
    },
})