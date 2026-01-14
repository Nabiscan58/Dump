localReportsTable, reportCount, take = {},0,0

function generateReportDisplay()
    return "~s~Reports actifs: ~y~"..reportCount.."~s~ | En cours: ~y~"..take
end

RegisterNetEvent("adminmenu:cbReportTable")
AddEventHandler("adminmenu:cbReportTable", function(table)
    -- TODO -> Add a sound when report taken
    reportCount = 0
    take = 0
    for source,report in pairs(table) do
        reportCount = reportCount + 1
        if report.taken then take = take + 1 end
    end
    localReportsTable = table
end)

RegisterNetEvent("adminmenu:alreadyHasReport", function()
    local alert = lib.alertDialog({
        header = '🚨 Report déjà actif !',
        content = 'Vous avez déjà un report en attente.\nVoulez-vous le supprimer pour en refaire un ?',
        centered = true,
        cancel = true
    })
    if alert == "confirm" then
        TriggerServerEvent("adminmenu:cancelReport")
    end
end)

RegisterNetEvent("adminmenu:openInputReason", function()
    local input = lib.inputDialog('🚨 Faire un report', {
        {type = 'input', label = 'Description de votre report', placeholder = 'Décrivez votre problème...'},
        {type = 'select', label = 'Catégorie', options = {
            {label = 'Bug', value = 'Bug'},
            {label = 'Cheateur', value = 'Cheat'},
            {label = 'Troll / Nuisance', value = 'Troll'},
            {label = 'Support / Aide', value = 'Support'}
        }},
        {type = 'select', label = 'Gravité estimée', options = {
            {label = 'Mineur', value = 'Mineur'},
            {label = 'Modéré', value = 'Moderer'},
            {label = 'Urgent', value = 'Urgent'}
        }}
    })

    if input then
        local description = input[1]
        local category = input[2]
        local graviter = input[3]

        if description and description ~= "" and category and graviter then
            TriggerServerEvent("adminmenu:sendReport", {
                description = description,
                category = category,
                graviter = graviter
            })
        else
            lib.notify({
                title = 'Erreur',
                description = 'Merci de remplir tous les champs du report.',
                type = 'error'
            })
        end
    end
end)

RegisterNetEvent("playsoundsss", function()
    PlaySoundFrontend(-1,"TENNIS_MATCH_POINT", "HUD_AWARDS", 1)
end)