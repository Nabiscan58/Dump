local isMenuOpened, cat = false, "adminmenu"
local prefix = "~r~[Admin]~s~"
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
local creditsSent = false
local rainbow_mode, rocket, drag, reason, ban_time, ban_time_name, InfStamina, gloves, sonoplz = false, false, false, nil, nil, nil, false, false, false
local serviceStaffRec = {}
local nombreStaffActifs = 0

local hideTakenReports = false
local Filter = "Aucun filtre"
local function subCat(name)
    return cat .. name
end

-- «

local function msg(string)
    ESX.ShowNotification(string)
end

local function colorByState(bool)
    if bool then
        return "~y~"
    else
        return "~s~"
    end
end

local function statsSeparator()
    RageUI.Separator("Staff connectés: ~y~" .. staff .. "~s~ | Staff en service: ~y~" .. nombreStaffActifs)
    RageUI.Separator("Connectés: ~y~" .. connecteds.. "~s~ | Reports: ~y~" .. reportCount)
end

local function generateTakenBy(reportID)
    if localReportsTable[reportID].taken then
        return "~s~ | Pris par: ~y~" .. localReportsTable[reportID].takenBy
    else
        return ""
    end
end

local ranksRelative = {
    ["user"] = 1,
    ["help"] = 2,
    ["test"] = 3,
    ["mod"] = 4,
    ["admin"] = 5,
    ["superadmin"] = 6
}

local ranksInfos = {
    [1] = { label = "Joueur", rank = "user" },
    [2] = { label = "Helpeur", rank = "help" },
    [3] = { label = "Modérateur-Test", rank = "test" },
    [4] = { label = "Modérateur", rank = "mod" },
    [5] = { label = "Admin", rank = "admin" },
    [6] = { label = "SuperAdmin", rank = "superadmin" }
}

local function getRankDisplay(rank)
    local ranks = {
        ["superadmin"] = "~r~[S.Admin] ~s~",
        ["admin"] = "~r~[Admin] ~s~",
        ["mod"] = "~r~[Modo] ~s~",
        ["test"] = "~r~[Modo-Test] ~s~",
        ["help"] = "~r~[Helpeur] ~s~",
    }
    return ranks[rank] or ""
end

local function getIsTakenDisplay(bool)
    if bool then
        return ""
    else
        return "~r~[EN ATTENTE]~s~ "
    end
end

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function DrawTexts(x, y, text, center, scale, rgb, font, rightJustify, devmod, shadow)
    if rgb[4] >= 0 then
        if devmod then
            local x2 = GetControlNormal(0, 239)
            local y2 = GetControlNormal(0, 240)

            x = x2
            y = y2
            print(x, y)
            if IsControlJustReleased(0, 38) then
                TriggerEvent("addToCopy", x..", "..y)
            end
        end

        if shadow == nil then
            shadow = false
        end

        if rightJustify ~= 0 and rightJustify ~= false then
            SetTextJustification(2)
            SetTextWrap(0.0, x)
        end

        SetTextFont(font)
        SetTextScale(scale, scale)
        if shadow ~= nil and shadow == true then
            SetTextDropshadow(1, 0, 0, 0, 100)
            --SetTextDropShadow()
        end
        SetTextColour(rgb[1], rgb[2], rgb[3], math.floor(rgb[4]))
        SetTextEntry("STRING")
        SetTextCentre(center)
        AddTextComponentString(text)
        EndTextCommandDisplayText(x,y)
    end

end

PMA = exports["pma-voice"]

function openMenu()
    if menuOpen then
        return
    end

    if not permLevel or permLevel == nil then
        return
    end
        
    if permLevel == "user" then
        ESX.ShowNotification("~r~Vous n'avez pas accès à ce menu.")
        return
    end

    local selectedColor = 1
    local cVarLongC = { "~p~", "~r~", "~y~", "~y~", "~c~", "~y~", "~b~" }
    local cVar1, cVar2 = "~y~", "~r~"
    local cVarLong = function()
        return cVarLongC[selectedColor]
    end
    menuOpen = true

    RMenu.Add(cat, subCat("main"), RageUI.CreateMenu("PRIME", "Menu administratif", 1, 100))
    RMenu:Get(cat, subCat('main')):SetRectangleBanner(3, 254, 34, 225)
    RMenu:Get(cat, subCat("main")).Closed = function()
    end
    
    RMenu:Get(cat, subCat("main")):SetPosition(1320, 100)
    RMenu.Add(cat, subCat("personnal"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("personnal")).Closed = function()
    end

    RMenu.Add(cat, subCat("players"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("players")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("reports")).Closed = function()
    end

    RMenu.Add(cat, subCat("reports_take"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("reports")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("reports_take")).Closed = function()
    end

    RMenu.Add(cat, subCat("playersManage"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("players")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("playersManage")).Closed = function()
    end

    RMenu.Add(cat, subCat("setGroup"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("setGroup")).Closed = function()
    end

    RMenu.Add(cat, subCat("items"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("items")).Closed = function()
    end

    RMenu.Add(cat, subCat("vehicle"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("vehicle")).Closed = function()
    end

    RMenu.Add(cat, subCat("teleportation"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("teleportation")).Closed = function()
    end

    RMenu.Add(cat, subCat("getInv"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("getInv")).Closed = function()
    end

    RMenu.Add(cat, subCat("staff"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("main")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("staff")).Closed = function()
    end

    RMenu.Add(cat, subCat("peds"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("personnal")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("peds")).Closed = function()
    end

    RMenu.Add(cat, subCat("casier"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("playersManage")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("casier")).Closed = function()
    end

    RMenu.Add(cat, subCat("bans"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("casier")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("bans")).Closed = function()
    end

    RMenu.Add(cat, subCat("warns"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("casier")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("warns")).Closed = function()
    end

    RMenu.Add(cat, subCat("jails"), RageUI.CreateSubMenu(RMenu:Get(cat, subCat("casier")), "PRIME", "Menu administratif"))
    RMenu:Get(cat, subCat("jails")).Closed = function()
    end

    RageUI.Visible(RMenu:Get(cat, subCat("main")), true)

    ESX.TriggerServerCallback("Staff:GetPlayers", function(serviceStaff)
        nombreStaffActifs = #serviceStaff
    end)

    Citizen.CreateThread(function()
        while menuOpen do
            Wait(800)
            if cVar1 == "~y~" then
                cVar1 = "~y~"
            else
                cVar1 = "~y~"
            end
            if cVar2 == "~r~" then
                cVar2 = "~s~"
            else
                cVar2 = "~r~"
            end
        end
    end)
    Citizen.CreateThread(function()
        while menuOpen do
            Wait(250)
            selectedColor = selectedColor + 1
            if selectedColor > #cVarLongC then
                selectedColor = 1
            end
        end
    end)

    local canOpen, callback = false, false
    ESX.TriggerServerCallback("adminmenu:canOpenMenu", function(can, group)
        canOpen = can
        callback = true
    end)

    while callback == false do
        Citizen.Wait(100)
    end

    if not canOpen then
        ESX.ShowNotification("~r~Vous n'avez pas accès à ce menu")
        return
    end

    Citizen.CreateThread(function()
        while menuOpen do
            local shouldStayOpened = false
            RageUI.IsVisible(RMenu:Get(cat, subCat("main")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
              
                if isStaffMode then
                    RageUI.ButtonWithStyle("~r~Désactiver le Mode Staff", nil, { RightLabel = "❌" }, not serverInteraction, function(_, _, s)
                        if s then
                            TriggerEvent("adminhud:toggle", false)

                            serverInteraction = true
                            blipsActive = false
                            TriggerServerEvent("Staff:RemovePlayer")
                            TriggerServerEvent("adminmenu:setStaffState", false)
                            TriggerServerEvent('StaffModV2:SendLogFDS')
                            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                TriggerEvent('skinchanger:loadSkin', skin)
                            end)
                            ForceDeactivateNoclip()
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("~y~Activer le Mode Staff", nil, { RightLabel = "✅" }, not serverInteraction, function(_, _, s)
                        if s then
                            TriggerEvent("adminhud:toggle", true)

                            local model = GetEntityModel(PlayerPedId())
                            serverInteraction = true
                            TriggerServerEvent("Staff:AddPlayer")
                            TriggerServerEvent("adminmenu:setStaffState", true)
                            TriggerServerEvent('StaffModV2:SendLogPDS')
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                if skin.sex == "mp_m_freemode_01" then
                                    clothesSkin = {
                                        ['bags_1'] = 0, ['bags_2'] = 0,
                                        ['tshirt_1'] = 15, ['tshirt_2'] = 2,
                                        ['torso_1'] = 178, ['torso_2'] = 0,
                                        ['arms'] = 31,
                                        ['pants_1'] = 77, ['pants_2'] = 0,
                                        ['shoes_1'] = 55, ['shoes_2'] = 0,
                                        ['mask_1'] = 0, ['mask_2'] = 0,
                                        ['bproof_1'] = 0,
                                        ['chain_1'] = 0,
                                    }
                                else
                                    clothesSkin = {
                                        ['bags_1'] = 0, ['bags_2'] = 0,
                                        ['tshirt_1'] = 15, ['tshirt_2'] = 0,
                                        ['torso_1'] = 180, ['torso_2'] = 0,
                                        ['arms'] = 36, ['arms_2'] = 0,
                                        ['pants_1'] = 79, ['pants_2'] = 0,
                                        ['shoes_1'] = 58, ['shoes_2'] = 0,
                                        ['mask_1'] = 0, ['mask_2'] = 0,
                                        ['bproof_1'] = 0,
                                        ['chain_1'] = 0,
                                    }
                                end
                                TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
                            end)

                            -- Quand tu passes en staff mode -> demande un snapshot
                            TriggerServerEvent("adminhud:requestData")

                            Citizen.CreateThread(function()
                                while isStaffMode do

                                    TriggerServerEvent("adminhud:requestData")

                                    Citizen.Wait(60 * 1000)
                                end
                            end)
                        end
                    end)
                end

                RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Personnel", nil, { RightLabel = "»" }, isStaffMode, function()
                end, RMenu:Get(cat, subCat("personnal")))

                RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Reports (~r~" .. reportCount .. "~s~)", nil, { RightLabel = "»" }, isStaffMode, function(_, _, s)
                end, RMenu:Get(cat, subCat("reports")))

                RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Joueurs", nil, { RightLabel = "»" }, isStaffMode, function(h, a, s)
                    if s then 
                        TriggerServerEvent("admin:menu:GetAllPlayers")
                    end
                end, RMenu:Get(cat, subCat("players")))

                if permLevel ~= "help" then
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Véhicules", nil, { RightLabel = "»" }, isStaffMode, function()
                        end, RMenu:Get(cat, subCat("vehicle")))
                    end
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Staff en service", nil, { RightLabel = "»" }, isStaffMode, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.TriggerServerCallback("Staff:GetPlayers", function(serviceStaff)
                                serviceStaffRec = serviceStaff
                            end)
                        end
                    end, RMenu:Get(cat, subCat("staff")))
                end

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("personnal")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()

                if isStaffMode then
                    RageUI.Checkbox(cVarLong() .. "» " .. colorByState(isNoClip) .. "NoClip", nil, isNoClip, { }, function(Hovered, Selected, Active, Checked)
                        isNoClip = Checked;
                    end, function()
                        ToogleNoClip()
                    end, function()
                        ToogleNoClip()
                    end)

                    -- TODO -> Faire avec les DecorSetInt le grade du joueur et faire les couleurs avec les mpGamerTag
                    RageUI.Checkbox(cVarLong() .. "» " .. colorByState(isNameShown) .. "Affichage des noms", nil, isNameShown, { }, function(Hovered, Selected, Active, Checked)
                        isNameShown = Checked;
                    end, function()
                        showNames(true)
                    end, function()
                        showNames(false)
                    end)


                    RageUI.Checkbox(cVarLong() .. "» " .. colorByState(blipsActive) .. "Affichage des blips", nil, blipsActive, { }, function(Hovered, Selected, Active, Checked)
                        blipsActive = Checked;
                    end, function()
                    end, function()
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~TP sur Marqueur", nil, {}, true, function(_, _, s)
                        if s then
                            admin_tp_marker()
                        end
                    end)

                    if permLevel ~= "help" then
                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Soin", nil, {}, true, function(_, _, s)
                            if s then
                                SetEntityHealth(PlayerPedId(), 200)
					        	ESX.ShowNotification("~y~Vous vous êtes soigné")
                            end
                        end)

                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Armure", nil, {}, true, function(_, _, s)
                            if s then
                                SetPedArmour(PlayerPedId(), 200)
					    		ESX.ShowNotification("~y~Votre armure vous a été attribuée")
                            end
                        end)

                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Changer de couleur", nil, {}, true, function(_, _, s)
                            if s then
                                local couleur = math.random(0,9)
               		    		TriggerEvent('skinchanger:getSkin', function(skin)
                        			local clothesSkin = {
                            			['torso_2'] = couleur,
                            			['pants_2'] = couleur,
                            			['shoes_2'] = couleur,
                            			['helmet_2'] = couleur,
                        			}
                        			TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)
					    		end)
                            end
                        end)
                    end

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Téléportation", nil, { RightLabel = "»" }, isStaffMode, function()
                    end, RMenu:Get(cat, subCat("teleportation")))

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Peds", nil, { RightLabel = "»" }, canUse("platePed", permLevel), function()
                    end, RMenu:Get(cat, subCat("peds")))

                    if fastrun then
                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Fast Run", nil, { RightLabel = "~y~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                fastrun = not fastrun
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Fast Run", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                fastrun = not fastrun
                            end
                        end)
                    end

                    if SuperJump then
                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Super Jump", nil, { RightLabel = "~y~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                SuperJump = not SuperJump
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Super Jump", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                SuperJump = not SuperJump
                            end
                        end)
                    end

                    if InfStamina then
                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Stamina Infini", nil, { RightLabel = "~y~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                InfStamina = not InfStamina
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Stamina Infini", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                InfStamina = not InfStamina
                            end
                        end)
                    end

                    if sonoplz then
                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Bip Sonore", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                ExecuteCommand("sonooff")
                                sonoplz = not sonoplz
                            end
                        end)
                    else
                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Bip Sonore", nil, { RightLabel = "~y~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                            if s then
                                ExecuteCommand("sonooff")
                                sonoplz = not sonoplz
                            end
                        end)
                    end

                    if fastrun then
                        SetRunSprintMultiplierForPlayer(PlayerId(-1), 2.49)
                        SetPedMoveRateOverride(PlayerPedId(), 2.15)
                    else
                        SetRunSprintMultiplierForPlayer(PlayerId(-1), 1.0)
                        SetPedMoveRateOverride(PlayerPedId(), 1.0)
                    end
                    if SuperJump then
                        SetSuperJumpThisFrame(PlayerId(-1))
                    end
                    if InfStamina then
                        RestorePlayerStamina(PlayerId(-1), 1.0)
                    end
                end
                
            end, function()
            end, 1)
            
            RageUI.IsVisible(RMenu:Get(cat, subCat("players")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.ButtonWithStyle("Filtre", nil, { RightLabel = Filter }, true, function(_, _, s)
                    if s then
                        local name = tostring(KeyboardInput('Nom du joueur', "~y~filtrer les joueurs", '', 35))

                        if name ~= nil and name ~= "nil" and name ~= "" and name ~= " "then
                            Filter = name
                        else
                            Filter = "Aucun filtre"
                        end
                    end
                end)
                RageUI.Checkbox(cVarLong() .. "» " .. colorByState(showAreaPlayers) .. "Restreindre à ma zone", nil, showAreaPlayers, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    showAreaPlayers = Checked;
                end, function()
                end, function()
                end)
                RageUI.Separator("Joueurs")
                if not showAreaPlayers then
                    for source, player in pairs(localPlayers) do
                        if player.name ~= nil then
                            local l,a = "~g~", "🟢"
                            if localPlayers[source].score <= 0 and localPlayers[source].score <= 10 then l,a = "~g~", "🟢" end
                            if localPlayers[source].score <= 20 and localPlayers[source].score >= 10 then l,a = "~o~", "🟠" end
                            if localPlayers[source].score >= 20 then l,a = "~r~", "🔴" end

                            if Filter ~= "Aucun filtre"then  -- Vérifie que player.name est non-nul et assez long
                                local playerNameLower = player.name:lower()
                                local prefix = string.sub(playerNameLower, 1, #Filter)
                                local filterLower = Filter:lower()
                                local zizi = tostring(source)
                                local prefix2 = string.sub(zizi:lower(), 1, #Filter)
                    
                                if prefix == filterLower or prefix2 == filterLower then
                                    if source ~= GetPlayerServerId(PlayerId()) then 
                                        RageUI.ButtonWithStyle(getRankDisplay(player.rank) .. "~s~[~y~" .. source .. "~s~] " .. cVarLong() .. "» ~s~" .. player.name .. " (" .. player.timePlayed[2] .. "h " .. player.timePlayed[1] .. "min~s~)", nil, { RightLabel = a }, ranksRelative[permLevel] >= ranksRelative[player.rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                            if s then
                                                selectedPlayer = source
                                            end
                                        end, RMenu:Get(cat, subCat("playersManage")))
                                    end
                                end
                            else
                                if source ~= GetPlayerServerId(PlayerId()) then 
                                    RageUI.ButtonWithStyle(getRankDisplay(player.rank) .. "~s~[~y~" .. source .. "~s~] " .. cVarLong() .. "» ~s~" .. player.name .. " (" .. player.timePlayed[2] .. "h " .. player.timePlayed[1] .. "min~s~)", nil, { RightLabel = a }, (ranksRelative[permLevel] and ranksRelative[player.rank] and ranksRelative[permLevel] >= ranksRelative[player.rank]) and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                                        if s then
                                            selectedPlayer = source
                                        end
                                    end, RMenu:Get(cat, subCat("playersManage")))
                                end
                            end

                        end
                    end
                else
                    local playerPed = PlayerPedId()
                    local playerCoords = GetEntityCoords(playerPed)
                    local zoneRadius = 100

                    local sIDs = {}
                    for _, player in ipairs(GetActivePlayers()) do
                        local sID = GetPlayerServerId(player)
                        if localPlayers[sID] ~= nil then
                            local targetPed = GetPlayerPed(player)
                            local targetCoords = GetEntityCoords(targetPed)
                            local distance = Vdist(playerCoords.x, playerCoords.y, playerCoords.z, targetCoords.x, targetCoords.y, targetCoords.z)
                    
                            if distance <= zoneRadius then
                                table.insert(sIDs, sID)
                            end
                        end
                    end
                    -- table.sort(sIDs)
                    
                    for _, sID in ipairs(sIDs) do
                        RageUI.ButtonWithStyle(getRankDisplay(localPlayers[sID].rank) .. "~s~[~y~" .. sID .. "~s~] " .. cVarLong() .. "» ~s~" .. localPlayers[sID].name .. " (" .. localPlayers[sID].timePlayed[2] .. "h " .. localPlayers[sID].timePlayed[1] .. "min~s~)", nil, { RightLabel = "»" }, ranksRelative[permLevel] >= ranksRelative[localPlayers[sID].rank] and source ~= GetPlayerServerId(PlayerId()), function(_, _, s)
                            if s then
                                selectedPlayer = sID
                            end
                        end, RMenu:Get(cat, subCat("playersManage")))
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Paramètres")
                RageUI.Checkbox(colorByState(hideTakenReports) .. "Cacher les pris en charge", nil, hideTakenReports, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    hideTakenReports = Checked
                end)
            
                local sortedReports = {}
                for sender, infos in pairs(localReportsTable) do
                    local totalMinutes = infos.timeElapsed[2] * 60 + infos.timeElapsed[1]
                    table.insert(sortedReports, {sender = sender, infos = infos, totalMinutes = totalMinutes})
                end
            
                table.sort(sortedReports, function(a, b)
                    return a.totalMinutes > b.totalMinutes
                end)
            
                RageUI.Separator("Reports")
                for _, report in ipairs(sortedReports) do
                    local sender = report.sender
                    local infos = report.infos
                    if infos.taken then
                        if not hideTakenReports then
                            RageUI.ButtonWithStyle(getIsTakenDisplay(infos.taken) .. "[~b~" .. infos.id .. "~s~] " .. cVarLong() .. "» ~s~" .. infos.name .. " ~r~(" .. infos.graviter .. ")", "~y~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~b~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason .. "~n~~o~Catégorie~s~: " .. infos.category .. "~n~~r~Pris en charge par~s~: " .. infos.takenBy, { RightLabel = "»" }, true, function(_, _, s)
                                if s then
                                    selectedReport = sender
                                end
                            end, RMenu:Get(cat, subCat("reports_take")))
                        end
                    else
                        RageUI.ButtonWithStyle(getIsTakenDisplay(infos.taken) .. "[~b~" .. infos.id .. "~s~] " .. cVarLong() .. "» ~s~" .. infos.name .. " ~r~(" .. infos.graviter .. ")", "~y~Créé il y a~s~: "..infos.timeElapsed[1].."m"..infos.timeElapsed[2].."h~n~~b~ID Unique~s~: #" .. infos.id .. "~n~~y~Description~s~: " .. infos.reason .. "~n~~o~Catégorie~s~: " .. infos.category, { RightLabel = "»" }, true, function(_, _, s)
                            if s then
                                selectedReport = sender
                            end
                        end, RMenu:Get(cat, subCat("reports_take")))
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("reports_take")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                if localReportsTable[selectedReport] ~= nil then
                    RageUI.Separator("ID du Report: #" .. localReportsTable[selectedReport].uniqueId .. " ~s~| ID de l'auteur: ~y~" .. selectedReport .. generateTakenBy(selectedReport))
                    RageUI.Separator("Actions disponibles")
                    local infos = localReportsTable[selectedReport]
                    if not localReportsTable[selectedReport].taken then
                        RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Prendre en charge ce report", "~y~Description~s~: " .. infos.reason, { RightLabel = "»" }, true, function(_, _, s)
                            if s then
                                TriggerServerEvent("adminmenu:takeReport", selectedReport)
                            end
                        end)
                    end
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Cloturer ce report", "~y~Description~s~: " .. infos.reason, { RightLabel = "»" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:closeReport", selectedReport)
                        end
                    end)
                    RageUI.Separator("Actions rapides")
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Revive", "~y~Description~s~: " .. infos.reason, { RightLabel = "»" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Revive du joueur en cours...")
                            TriggerServerEvent("adminmenu:revive", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Soigner", "~y~Description~s~: " .. infos.reason, { RightLabel = "»" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Heal du joueur en cours...")
                            TriggerServerEvent("adminmenu:heal", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~TP sur lui", nil, { RightLabel = "»" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:goto", selectedReport)
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~TP sur moi", nil, { RightLabel = "»" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:bring", selectedReport, GetEntityCoords(PlayerPedId()))
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~TP Parking Central", "~y~Description~s~: " .. infos.reason, { RightLabel = "»" }, canUse("tppc", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Téléportation du joueur en cours...")
                            TriggerServerEvent("adminmenu:tppc", selectedReport)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~y~Actions avancées", "~y~Description~s~: " .. infos.reason.."~n~~r~Attention~s~: Cette action vous fera changer de menu", { RightLabel = "»" }, GetPlayerServerId(PlayerId()) ~= selectedReport, function(_, _, s)
                        if s then
                            selectedPlayer = selectedReport
                        end
                    end,RMenu:Get(cat,subCat("playersManage")))
                else
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Ce report n'est plus valide")
                    RageUI.Separator("")
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("playersManage")), true, true, true, function()

                shouldStayOpened = true

                if not localPlayers[selectedPlayer] then
                    RageUI.Separator("")
                    RageUI.Separator(cVar2 .. "Ce joueur n'est plus connecté !")
                    RageUI.Separator("")
                else
                    statsSeparator()

                    local l,a = "~g~", "Très bon joueur"
                    if localPlayers[selectedPlayer].score <= 0 and localPlayers[selectedPlayer].score <= 10 then l,a = "~g~", "Très bon joueur" end
                    if localPlayers[selectedPlayer].score <= 20 and localPlayers[selectedPlayer].score >= 10 then l,a = "~o~", "Joueur moyen" end
                    if localPlayers[selectedPlayer].score >= 20 then l,a = "~r~", "Joueur mauvais" end

                    RageUI.Separator("Niveau: "..l.." "..a)

                    RageUI.Separator("Gestion: ~y~" .. localPlayers[selectedPlayer].name .. " ~s~(~y~" .. selectedPlayer .. "~s~)")
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~S'y téléporter", nil, { RightLabel = "»" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:goto", selectedPlayer)
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Téléporter sur moi", nil, { RightLabel = "»" }, true, function(_, _, s)
                        if s then
                            TriggerServerEvent("adminmenu:bring", selectedPlayer, GetEntityCoords(PlayerPedId()))
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Casier", nil, { RightLabel = "»" }, canUse("casier", permLevel), function(_, _, s)
                        if s then

                        end
                    end, RMenu:Get(cat, subCat("casier")))

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Spectate", nil, { RightLabel = "»" }, canUse("spectate", permLevel), function(_, _, s)
                        if s then
                            -- ForceDeactivateNoclip()
                            TriggerServerEvent("spectate:start", selectedPlayer)
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Message", nil, { RightLabel = "»" }, canUse("mess", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Message", "", 100, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Envoi du message en cours...")
                                TriggerServerEvent("adminmenu:message", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Warn", nil, { RightLabel = "»" }, canUse("warn", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Warn", "", 100, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Envoi du warn en cours...")
                                TriggerServerEvent("adminmenu:warn", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Kick", nil, { RightLabel = "»" }, canUse("kick", permLevel), function(_, _, s)
                        if s then
                            local reason = input("Raison", "", 80, false)
                            if reason ~= nil and reason ~= "" then
                                ESX.ShowNotification("~y~Application de la sanction en cours...")
                                TriggerServerEvent("adminmenu:kick", selectedPlayer, reason)
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Bannir", nil, { RightLabel = "»" }, canUse("ban", permLevel), function(_, _, s)
                        if s then
                            local days = input("Durée du banissement (en heures)", "", 20, true)
                            if days ~= nil then
                                local reason = input("Raison", "", 80, false)
                                if reason ~= nil then
                                    ESX.ShowNotification("~y~Application de la sanction en cours...")
                                    ExecuteCommand(("sqlban %s %s %s"):format(selectedPlayer, days, reason))
                                end
                            end
                        end
                    end)
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Changer le groupe", nil, { RightLabel = "»" }, canUse("setGroup", permLevel), function(_, _, s)
                    end, RMenu:Get(cat, subCat("setGroup")))

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Revive", nil, { RightLabel = "»" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Revive du joueur en cours...")
                            TriggerServerEvent("adminmenu:revive", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Soigner", nil, { RightLabel = "»" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Heal du joueur en cours...")
                            TriggerServerEvent("adminmenu:heal", selectedPlayer)
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Donner un véhicule", nil, { RightLabel = "»" }, canUse("vehicles2", permLevel), function(Hovered, Active, Selected)
                        if Selected then
                            local veh = CustomString()
                            if veh ~= nil then
                                local model = GetHashKey(veh)
                                if IsModelValid(model) then
                                    RequestModel(model)
                                    while not HasModelLoaded(model) do
                                        Wait(1)
                                    end
                                    TriggerServerEvent("adminmenu:spawnVehicle", model, selectedPlayer)
                                else
                                    msg("Ce modèle n'existe pas")
                                end
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Voir l'inventaire", nil, { RightLabel = "»" }, canUse("revive", permLevel), function(_, _, s)
                        if s then
                            cash = {}
                            blackmoney = {}
                            hisitems = {}

                            ESX.TriggerServerCallback("adminmenu:getPlayerInventory", function(data)
                                table.insert(cash, {
                                    label    = ESX.Math.Round(data.money),
                                    value    = 'money',
                                    amount   = data.money
                                })
                        
                                for k,v in pairs(data.accounts) do
                                    if v.name == 'black_money' and v.money > 0 then
                                        table.insert(blackmoney, {
                                              label    = ESX.Math.Round(v.money),
                                              value    = 'black_money',
                                              itemType = 'item_account',
                                              amount   = v.money
                                        })
                                    end
                                end
                              
                                for k,v in pairs(data.inventory) do
                                    if v.count > 0 then
                                        table.insert(hisitems, {
                                              label    = v.label,
                                              right    = v.count,
                                              value    = v.name,
                                              itemType = 'item_standard',
                                              amount   = v.count
                                        })
                                    end
                                end
                            end, selectedPlayer)
                        end
                    end, RMenu:Get(cat, subCat("getInv")))

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Give un item", nil, { RightLabel = "»" }, canUse("give", permLevel), function(_, _, s)
                    end, RMenu:Get(cat, subCat("items")))

                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Wipe", nil, { RightLabel = "»" }, canUse("wipe", permLevel), function(_, _, s)
                        if s then
                            local result = tostring(KeyboardInput('Wipe', "~y~Écrivez 'Oui' pour confirmer", '', 35))
                            if result == "oui" or result == "Oui" or result == "OUI" then
                                ESX.ShowNotification("~y~Wipe du joueur en cours...")
                                TriggerServerEvent("adminmenu:wipe", selectedPlayer)
                            end
                        end
                    end)
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("casier")), true, true, true, function()
                
                RageUI.ButtonWithStyle("~r~>~s~ Liste des bannissements", nil, {RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        playerBans = {}
                        ESX.TriggerServerCallback("adminmenu:getBans", function(data)
                            playerBans = data
                        end, selectedPlayer)
                    end
                end, RMenu:Get(cat, subCat("bans")))

                RageUI.ButtonWithStyle("~r~>~s~ Liste des warns", nil, {RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        playerWarns = {}
                        ESX.TriggerServerCallback("adminmenu:getWarns", function(data)
                            playerWarns = data
                        end, selectedPlayer)
                    end
                end, RMenu:Get(cat, subCat("warns")))

                RageUI.ButtonWithStyle("~r~>~s~ Liste des jails", nil, {RightLabel = "→→→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        playerJails = {}
                        ESX.TriggerServerCallback("adminmenu:getJails", function(data)
                            playerJails = data
                        end, selectedPlayer)
                    end
                end, RMenu:Get(cat, subCat("jails")))

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("bans")), true, true, true, function()

                for k,v in pairs(playerBans) do
                    local reason = v.reason or "Aucune raison"
                    local staff = v.staff_name or "Inconnu"
                    local duration = v.duration and (v.duration .. " secondes") or "Permanent"
                    local date = v.timestamp or "Date inconnue"
            
                    local label = ("Raison: ~r~%s\n~s~Durée: %s\nStaff: %s\nDate: %s"):format(reason, duration, staff, date)
            
                    RageUI.ButtonWithStyle("Ban #" .. k, label, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then

                        end
                    end)
                end

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("warns")), true, true, true, function()

                for k,v in pairs(playerWarns) do
                    local reason = v.reason or "Aucune raison"
                    local staff = v.staff_name or "Inconnu"
                    local date = v.timestamp or "Date inconnue"

                    local label = ("Raison: ~y~%s\n~s~Staff: %s\nDate: %s"):format(reason, staff, date)

                    RageUI.ButtonWithStyle("Warn #" .. k, label, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then

                        end
                    end)
                end

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("jails")), true, true, true, function()

                for k,v in pairs(playerJails) do
                    local reason = v.reason or "Aucune raison"
                    local staff = v.staff_name or "Inconnu"
                    local duration = v.duration and (v.duration .. " min") or "Indéfini"
                    local date = v.timestamp or "Date inconnue"

                    local label = ("Raison: ~b~%s\n~s~Durée: %s\nStaff: %s\nDate: %s"):format(reason, duration, staff, date)

                    RageUI.ButtonWithStyle("Jail #" .. k, label, {RightLabel = "→→→"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            
                        end
                    end)
                end

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("getInv")), true, true, true, function()
                for k,v in pairs(cash) do
                    RageUI.ButtonWithStyle("~r~>~s~ Argent Liquide", nil, {RightLabel = ("%s $"):format(v.label) }, true, function(Hovered, Active, Selected)
                    end)
                end
                for k,v in pairs(blackmoney) do
                    RageUI.ButtonWithStyle("~r~>~s~ Argent sale", nil, {RightLabel = ("%s $"):format(v.label) }, true, function(Hovered, Active, Selected)
                    end)
                end
                RageUI.Separator()
                for k,v in pairs(hisitems) do
                    RageUI.ButtonWithStyle(("~r~> ~s~%s"):format(v.label), nil, { RightLabel = ("x%s"):format(v.right) }, true, function(Hovered, Active, Selected)
                        if Selected then
                            local result = KeyboardInput("REMOVE_ITEM", "Quantité à retirer", "", 4)
                            local count = tonumber(result)
                            if count and count > 0 then
                                TriggerServerEvent("adminmenu:removeItemFromPlayer", selectedPlayer, v.value, count, v.metadatas or {})
                            else
                                ESX.ShowNotification("~r~Quantité invalide.")
                            end
                        end
                    end)
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("items")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Gestion: ~y~" .. localPlayers[selectedPlayer].name .. " ~s~(~y~" .. selectedPlayer .. "~s~)")
                RageUI.List("Filtre:", filterArray, filter, nil, {}, true, function(_, _, _, i)
                    filter = i
                end)
                RageUI.Separator("Items disponibles")
                for id, itemInfos in pairs(items) do
                    if starts(itemInfos.label:lower(), filterArray[filter]:lower()) then 
                        if not canUse("funnyassshit", permLevel) then
                            RageUI.ButtonWithStyle(cVarLong() .. "» ~s~" .. itemInfos.label, nil, { RightLabel = "~b~Donner ~s~»" }, true, function(_, _, s)
                                if s then
                                    local qty = input("Quantité", "", 20, true)
                                    if qty ~= nil then
                                        ESX.ShowNotification("~y~Give de l'item...")
                                        TriggerServerEvent("adminmenu:give", selectedPlayer, itemInfos.name, qty)
                                    end
                                end
                            end)
                        elseif canUse("funnyassshit", permLevel) then 
                            RageUI.ButtonWithStyle(cVarLong() .. "» ~s~" .. itemInfos.label, nil, { RightLabel = "~b~Donner ~s~»" }, true, function(_, _, s)
                                if s then
                                    local qty = input("Quantité", "", 20, true)
                                    if qty ~= nil then
                                        ESX.ShowNotification("~y~Give de l'item...")
                                        TriggerServerEvent("adminmenu:give", selectedPlayer, itemInfos.name, qty)
                                    end
                                end
                            end)
                        end
                    end
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("setGroup")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("Gestion: ~y~" .. localPlayers[selectedPlayer].name .. " ~s~(~y~" .. selectedPlayer .. "~s~)")
                RageUI.Separator("Rangs disponibles")
                for i = 1, #ranksInfos do
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~" .. ranksInfos[i].label, nil, { RightLabel = "~b~Attribuer ~s~»" }, ranksRelative[permLevel] > i, function(_, _, s)
                        if s then
                            ESX.ShowNotification("~y~Application du rang...")
                            TriggerServerEvent("adminmenu:setGroup", selectedPlayer, ranksInfos[i].rank)
                        end
                    end)
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("vehicle")), true, true, true, function()
                shouldStayOpened = true
                statsSeparator()
                RageUI.Separator("")
                RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Spawn un véhicule", nil, { RightLabel = "»" }, canUse("vehicles2", permLevel), function(Hovered, Active, Selected)
                    if Selected then
                        local veh = CustomString()
                        if veh ~= nil then
                            local model = GetHashKey(veh)
                            if IsModelValid(model) then
                                RequestModel(model)
                                while not HasModelLoaded(model) do
                                    Wait(1)
                                end
                                TriggerServerEvent("adminmenu:spawnVehicle", model)
                            else
                                msg("Ce modèle n'existe pas")
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Supprimer le véhicule", nil, { RightLabel = "»" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            Citizen.CreateThread(function()
                                local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), nil)
                                NetworkRequestControlOfEntity(veh)
                                while not NetworkHasControlOfEntity(veh) do
                                    Wait(1)
                                end
                                DeleteEntity(veh)
                                ESX.ShowNotification("~y~Véhicule supprimé")
                            end)
                        else
                            ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
                        end
                    end
                end)
                RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Réparer le véhicule", nil, { RightLabel = "»" }, true, function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), nil)
                            NetworkRequestControlOfEntity(veh)
                            while not NetworkHasControlOfEntity(veh) do
                                Wait(1)
                            end
                            SetVehicleFixed(veh)
                            SetVehicleDeformationFixed(veh)
                            SetVehicleDirtLevel(veh, 0.0)
                            SetVehicleEngineHealth(veh, 1000.0)
                            ESX.ShowNotification("~y~Véhicule réparé")
                        else
                            ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
                        end
                    end
                end)

                RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Full Custom", nil, { RightLabel = "»" }, canUse("funnyassshit", permLevel), function(Hovered, Active, Selected)
                    if Active then
                        ClosetVehWithDisplay()
                    end
                    if Selected then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), nil)
                            NetworkRequestControlOfEntity(veh)
                            while not NetworkHasControlOfEntity(veh) do
                                Wait(1)
                            end
                            ESX.Game.SetVehicleProperties(veh, {
                                modEngine = 3,
                                modBrakes = 3,
                                modTransmission = 3,
                                modSuspension = 3,
                                modTurbo = true
                            })
                            SetVehicleWindowTint(veh, 2)
                            SetVehicleWindowTint(veh, 3)
                            ESX.ShowNotification("~y~Véhicule amélioré")
                        else
                            ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
                        end
                    end
                end)

                RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Changer la plaque", nil, { RightLabel = "»" }, canUse("platePed", permLevel), function(_, _, s)
                    if s then
                        if IsPedSittingInAnyVehicle(PlayerPedId()) then
                            local plaqueVehicule = input("Plaque", "", 8)
                            SetVehicleNumberPlateText(GetVehiclePedIsIn(PlayerPedId(), false) , plaqueVehicule)
                            ESX.ShowNotification("La plaque du véhicule est désormais : ~h~"..plaqueVehicule)
                        else
                            ESX.ShowNotification("~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !")
                        end
                    end
                end)

                if rainbow_mode then
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Mode Rainbow", nil, { RightLabel = "~y~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            rainbow_mode = not rainbow_mode
                        end
                    end)
                else
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Mode Rainbow", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            rainbow_mode = not rainbow_mode
                        end
                    end)
                end
                if rocket then
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Mode Fusée", nil, { RightLabel = "~y~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            rocket = not rocket
                        end
                    end)
                else
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Mode Fusée", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            rocket = not rocket
                        end
                    end)
                end
                if drag then
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Mode Dragster", nil, { RightLabel = "~y~Activé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            drag = not drag
                            if drag then
                                SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), false), 175.0 * 20.0)
                            else
                                SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), false), 0.1 * 20.0)
                            end
                        end
                    end)
                else
                    RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Mode Dragster", nil, { RightLabel = "~r~Désactivé" }, canUse("funnyassshit", permLevel), function(_, _, s)
                        if s then
                            drag = not drag
                            if drag then
                                SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), false), 175.0 * 20.0)
                            else
                                SetVehicleEnginePowerMultiplier(GetVehiclePedIsIn(PlayerPedId(), false), 0.1 * 20.0)
                            end
                        end
                    end)
                end

                if rainbow_mode then
                    local ra = RGBRainbow(1.0)
                    SetVehicleCustomPrimaryColour(GetVehiclePedIsUsing(PlayerPedId()), ra.r, ra.g, ra.b)
                    SetVehicleCustomSecondaryColour(GetVehiclePedIsUsing(PlayerPedId()), ra.r, ra.g, ra.b)
                end
                if rocket and IsPedInAnyVehicle(PlayerPedId(), true) then
                    if IsControlPressed(0, 209) then
                        SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId()), 70.0)
                    elseif IsControlPressed(0, 210) then
                        SetVehicleForwardSpeed(GetVehiclePedIsUsing(PlayerPedId()), 0.0)
                    end
                end

            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("teleportation")), true, true, true, function()
                shouldStayOpened = true
                RageUI.Separator("Lieux de téléportation")

                RageUI.ButtonWithStyle("Parking Central", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, -327.82, -899.74, 32.47, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Poste de police", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, 413.69, -980.12, 29.98, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Sandy Shores", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, 1755.12, 3741.03, 34.7, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Paleto Bay", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, 90.53, 6551.6, 31.61, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Base militaire", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, -2146.6, 3092.17, 34.61, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Port", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, 1218.4, -3087.35, 6.38, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Plage", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, -1796.29, -818.22, 8.68, false, false, false, true)
                    end
                end)
                RageUI.ButtonWithStyle("Aéroport", nil, {RightBadge = RageUI.BadgeStyle.Car}, true, function(_, Active, Selected)
                    if Selected then
                        local playerPed = PlayerPedId()
                        SetEntityCoordsNoOffset(playerPed, -1028.99, -2723.76, 20.47, false, false, false, true)
                    end
                end)
                
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("staff")), true, true, true, function()
                shouldStayOpened = true
                for k,v in pairs(serviceStaffRec) do
                    RageUI.ButtonWithStyle(v, nil, {}, true, function()
                    end)
                end
            end, function()
            end, 1)

            RageUI.IsVisible(RMenu:Get(cat, subCat("peds")), true, true, true, function()
                shouldStayOpened = true
                RageUI.Separator("Peds")

                RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Ped Custom", nil, { RightLabel = "»" }, canUse("platePed", permLevel), function(_, _, s)
                    if s then
                        local result = lib.inputDialog('Entrez le nom du personnage', {'Nom du ped'})
                        if not result or not result[1] or result[1] == "" then
                            return
                        end

                        local model = result[1]
                        if IsModelInCdimage(model) and IsModelValid(model) then
                            RequestModel(model)
                            while not HasModelLoaded(model) do
                              Wait(0)
                            end
                            SetPlayerModel(PlayerId(), model)
                            SetModelAsNoLongerNeeded(model)
                          end
                    end
                end)

                RageUI.ButtonWithStyle(cVarLong() .. "» ~s~Reprendre son apparence", nil, { RightLabel = "»" }, canUse("platePed", permLevel), function(_, _, s)
                    if s then
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

            end, function()
            end, 1)
            Wait(0)
        end
    end)
end

function admin_tp_marker()
	local WaypointHandle = GetFirstBlipInfoId(8)
	if DoesBlipExist(WaypointHandle) then
		local waypointCoords = GetBlipInfoIdCoord(WaypointHandle)
		for height = 1, 1000 do
			SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)
			local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)
			if foundGround then
				SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

				break
			end
			Citizen.Wait(0)
		end
	end
end

KEYBOARDACTIVE = false

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    KEYBOARDACTIVE = true
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, '', inputText, '', '', '', maxLength)

    while (UpdateOnscreenKeyboard() ~= 1) and (UpdateOnscreenKeyboard() ~= 2) do
        DisableAllControlActions(0)
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        KEYBOARDACTIVE = false
        return GetOnscreenKeyboardResult()
    else
        KEYBOARDACTIVE = false
        return nil
    end
end

function RGBRainbow(frequency)
	local result = {}
	local curtime = GetGameTimer() / 1000
 
	result.r = math.floor(math.sin(curtime * frequency + 0) * 127 + 128)
	result.g = math.floor(math.sin(curtime * frequency + 2) * 127 + 128)
	result.b = math.floor(math.sin(curtime * frequency + 4) * 127 + 128)
 
	return result
end

function getStaffMod()
    return isStaffMode
end
local staffInService = {}

exports("getPlayerInStaffMod", function (source)

    if staffInService[source] then
        return true
    else 
        return false
    end
end)

RegisterNetEvent("staffService", function(data)
    if data ~= nil then 
        staffInService = data
    end
end)