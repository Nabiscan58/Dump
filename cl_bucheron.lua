ESX = ESX or nil
local EnServiceBucheron = false
local MenuBucheron = false
local bucherblips = {}
local carryingLog = false
local carriedProp = nil
local axeProp = nil

-- Config spots
Config = Config or {}
Config.bucheron = {
    -- NPC/menu
    boss = vector3(-636.25994873047, 5493.349609375, 50.68408203125),   -- ton Jardinier était là ; on recycle l'endroit "forêt"
    -- Zones de coupe (arbres)
    trees = {
        { pos = vector3(-638.44653320312, 5503.5170898438, 50.297451019287), heading = 22.0, time = 3500 },
        { pos = vector3(-634.69372558594, 5505.1962890625, 50.241348266602), heading = 316.0, time = 3500 },
        { pos = vector3(-620.73950195312, 5498.0146484375, 50.299919128418), heading = 237.0, time = 3500 },
        { pos = vector3(-626.06317138672, 5474.7143554688, 52.288314819336), heading = 181.0, time = 3500 },
        { pos = vector3(-629.42510986328, 5470.6245117188, 52.691734313965), heading = 279.0, time = 3500 },
    },
    -- Dépôt (livraison du tronc)
    depot = vector3(-620.67224121094, 5509.5942382812, 50.234413146973), -- sawmill Paleto-ish, mets ce que tu veux
    -- Blips
    blipForest = { sprite = 568, color = 25, scale = 0.8, name = 'Bûcheron - Forêt' },
    blipDepot  = { sprite = 479, color = 2,  scale = 0.8, name = 'Bûcheron - Dépôt' },
    -- Récompense gérée côté serveur (events), mais tu peux afficher un range ici si tu veux
}

-- ESX boot
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    -- Menu RageUI
    RMenu.Add('bucheron', 'main', RageUI.CreateMenu("PRIME", "Bûcheron", 1, 100))
    RMenu:Get('bucheron', 'main'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('bucheron', 'main').EnableMouse = false
    RMenu:Get('bucheron', 'main').Closed = function() MenuBucheron = false end
end)

-- 👷 Ouvrir menu bûcheron
local function openBucheronMenu()
    if MenuBucheron then
        MenuBucheron = false
        return
    else
        MenuBucheron = true
        RageUI.Visible(RMenu:Get('bucheron', 'main'), true)

        Citizen.CreateThread(function()
            while MenuBucheron do
                RageUI.IsVisible(RMenu:Get('bucheron', 'main'), true, true, true, function()
                    RageUI.ButtonWithStyle("Prendre son service", "", { RightLabel = "→" }, true, function(_,_,Selected)
                        if Selected then
                            if not EnServiceBucheron then
                                EnServiceBucheron = true
                                RageUI.CloseAll()
                                MenuBucheron = false
                                StartBucheron()
                            else
                                ESX.ShowNotification("~r~Vous êtes déjà en service !")
                            end
                        end
                    end)

                    RageUI.ButtonWithStyle("Fin de service", "", { RightLabel = "→" }, true, function(_,_,Selected)
                        if Selected then
                            if EnServiceBucheron then
                                StopBucheron(true)
                                ESX.ShowNotification("~g~Fin de service.")
                            else
                                ESX.ShowNotification("~r~Vous n'êtes pas en service !")
                            end
                        end
                    end)
                end)
                Wait(0)
            end
        end)
    end
end

-- 📍 Zone du chef (ouvre menu)
Citizen.CreateThread(function()
    local p = Config.bucheron.boss
    local blip = AddBlipForCoord(p)
    SetBlipSprite(blip, 280)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 25)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName('Bûcheron')
    EndTextCommandSetBlipName(blip)

    while true do
        local near = false
        local ped = PlayerPedId()
        local pc = GetEntityCoords(ped)
        local dist = #(pc - p)
        if dist <= 2.0 then
            near = true
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler avec le chef bûcheron")
            DrawMarker(6, p.x, p.y, p.z, 0.0,0.0,0.0, -90.0,0.0,0.0, 0.6,0.6,0.6, 255,220,0,140, 0,0,2,1,nil,nil,0)
            if IsControlJustPressed(1,51) and not MenuBucheron then
                openBucheronMenu()
            end
        end
        Wait(near and 0 or 500)
    end
end)

-- 🧹 Clean blips & prop
local function cleanupBucheron()
    for _,b in pairs(bucherblips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
    end
    bucherblips = {}
    if carriedProp and DoesEntityExist(carriedProp) then
        DetachEntity(carriedProp, true, true)
        DeleteEntity(carriedProp)
        carriedProp = nil
    end

    if axeProp and DoesEntityExist(axeProp) then
        DetachEntity(axeProp, true, true)
        DeleteEntity(axeProp)
        axeProp = nil
    end

    carryingLog = false
    ClearPedTasks(PlayerPedId())
end

function StopBucheron(closeMenu)
    EnServiceBucheron = false
    cleanupBucheron()
    if closeMenu then
        RageUI.CloseAll()
        MenuBucheron = false
    end
end

-- 📌 Utils
local function LoadModel(model)
    local hash = (type(model) == 'number') and model or GetHashKey(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local i=0
        while not HasModelLoaded(hash) and i < 1000 do
            Citizen.Wait(10)
            i = i + 1
        end
    end
    return HasModelLoaded(hash) and hash or nil
end

local function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        local i=0
        while not HasAnimDictLoaded(dict) and i < 1000 do
            Citizen.Wait(10)
            i=i+1
        end
    end
    return HasAnimDictLoaded(dict)
end

-- 🎒 Commencer le job
function StartBucheron()
    ESX.ShowNotification("~g~Service bûcheron commencé !")
    -- Blip Forêt
    local bf = AddBlipForCoord(Config.bucheron.trees[1].pos)
    SetBlipSprite(bf, Config.bucheron.blipForest.sprite)
    SetBlipScale(bf,  Config.bucheron.blipForest.scale)
    SetBlipColour(bf, Config.bucheron.blipForest.color)
    SetBlipAsShortRange(bf, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.bucheron.blipForest.name)
    EndTextCommandSetBlipName(bf)
    table.insert(bucherblips, bf)

    -- Blip Dépôt
    local bd = AddBlipForCoord(Config.bucheron.depot)
    SetBlipSprite(bd, Config.bucheron.blipDepot.sprite)
    SetBlipScale(bd,  Config.bucheron.blipDepot.scale)
    SetBlipColour(bd, Config.bucheron.blipDepot.color)
    SetBlipAsShortRange(bd, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.bucheron.blipDepot.name)
    EndTextCommandSetBlipName(bd)
    table.insert(bucherblips, bd)

    -- Met le joueur en route
    SetNewWaypoint(Config.bucheron.trees[1].pos.x, Config.bucheron.trees[1].pos.y)

    -- Boucle de travail
    Citizen.CreateThread(function()
        while EnServiceBucheron do
            -- Si porte déjà un tronc -> pointer vers le dépôt
            if carryingLog then
                local ped = PlayerPedId()
                local pc = GetEntityCoords(ped)
                local d = #(pc - Config.bucheron.depot)
                if d <= 20.0 then
                    DrawMarker(20, Config.bucheron.depot.x, Config.bucheron.depot.y, Config.bucheron.depot.z + 1.0,
                        0.0,0.0,0.0, 0.0,0.0,0.0, 0.6,0.6,0.6, 0, 180, 60, 180, 0,0,2,1,nil,nil,0)
                    if d <= 3.0 then
                        ESX.ShowHelpNotification("Appuyez sur ~b~E~w~ pour déposer le tronc")
                        if IsControlJustPressed(1, 51) then
                            -- Déposer, payer
                            if carriedProp and DoesEntityExist(carriedProp) then
                                DetachEntity(carriedProp, true, true)
                                DeleteEntity(carriedProp)
                            end
                            carriedProp = nil
                            carryingLog = false
                            ClearPedTasksImmediately(ped)
                            TriggerServerEvent('bucheron:payStop')
                            ESX.ShowNotification("~g~Tronc livré ! ~s~Retournez couper un arbre.")
                            SetNewWaypoint(Config.bucheron.trees[1].pos.x, Config.bucheron.trees[1].pos.y)
                            Citizen.Wait(500)
                        end
                    end
                end

                Citizen.Wait(0)
            else
                -- Pas de tronc : chercher un arbre à couper
                local ped = PlayerPedId()
                local pc  = GetEntityCoords(ped)
                local nearAny = false

                for _,tree in ipairs(Config.bucheron.trees) do
                    local dist = #(pc - tree.pos)
                    if dist <= 35.0 then
                        nearAny = true
                        DrawMarker(20, tree.pos.x, tree.pos.y, tree.pos.z + 1.0,
                            0.0,0.0,0.0, 0.0,0.0,0.0, 0.5,0.5,0.5, 0, 255, 0, 170, 0,0,2,1,nil,nil,0)

                        if dist <= 3.0 then
                            ESX.ShowHelpNotification("Appuyez sur ~b~E~w~ pour couper l'arbre")
                            if IsControlJustPressed(1, 51) then
                                SetEntityCoords(PlayerPedId(), tree.pos)
                                SetEntityHeading(PlayerPedId(), tree.heading)

                                -- Petite anim de coupe + timer
                                local dict = "amb@world_human_hammering@male@base"
                                if LoadAnimDict(dict) then
                                    TaskPlayAnim(ped, dict, "base", 8.0, -8.0, tree.time or 3500, 1, 0.0, false, false, false)
                                end
                                -- >>> HACHE: spawn + attach (local uniquement)
                                local axeModel = LoadModel("prop_w_me_hatchet")
                                if axeModel then
                                    -- on crée juste devant le joueur pour être sûr
                                    local px,py,pz = table.unpack(GetEntityCoords(ped))
                                    axeProp = CreateObject(axeModel, px, py, pz + 0.2, true, false, false)
                                    if DoesEntityExist(axeProp) then
                                        local hand = GetPedBoneIndex(ped, 57005) -- main droite (57005 = SKEL_R_Hand)
                                        -- offset/rot peaufinés pour un rendu naturel
                                        AttachEntityToEntity(
                                            axeProp, ped, hand,
                                            0.120, 0.020, 0.020, -80.0, -30.0, -55.0,
                                            true, true, false, true, 1, true
                                        )
                                    else
                                        ESX.ShowNotification("~r~Impossible de créer le modèle de la hache.")
                                    end
                                else
                                    ESX.ShowNotification("~r~Impossible de charger le modèle de la hache.")
                                end
                                -- <<< HACHE

                                TriggerEvent("core:drawBar", tree.time or 3500, "🪓 Coupe en cours...")
                                Citizen.Wait(tree.time or 3500)
                                ClearPedTasksImmediately(ped)

                                if axeProp and DoesEntityExist(axeProp) then
                                    DetachEntity(axeProp, true, true)
                                    DeleteEntity(axeProp)
                                    axeProp = nil
                                end

                                -- Spawn tronc + attache + anim de portage
                                local model = LoadModel("prop_log_01")
                                if model then
                                    local prop = CreateObject(model, tree.pos.x, tree.pos.y, tree.pos.z, true, false, false)
                                    if DoesEntityExist(prop) then
                                        carriedProp = prop
                                        local bone = GetPedBoneIndex(ped, 28422) -- main droite
                                        -- Position/rot ajustées pour un rendu propre
                                        AttachEntityToEntity(prop, ped, bone, 0.25, 0.0, -0.05,  0.0, 0.0, 90.0, true, true, false, true, 1, true)

                                        -- Anim de portage (boîte) qui passe bien avec un log
                                        local carryDict = "anim@heists@box_carry@"
                                        if LoadAnimDict(carryDict) then
                                            TaskPlayAnim(ped, carryDict, "idle", 8.0, -8.0, -1, 51, 0.0, false, false, false)
                                        end

                                        carryingLog = true
                                        ESX.ShowNotification("~y~Transportez le tronc jusqu'au dépôt !")
                                        SetNewWaypoint(Config.bucheron.depot.x, Config.bucheron.depot.y)
                                    else
                                        ESX.ShowNotification("~r~Impossible de créer l'objet tronc.")
                                    end
                                else
                                    ESX.ShowNotification("~r~Impossible de charger le modèle du tronc.")
                                end
                            end
                        end
                    end
                end

                Citizen.Wait(nearAny and 0 or 300)
            end
        end
    end)
end

-- 🧭 Interaction monde (fallback ouverture menu près du boss)
Citizen.CreateThread(function()
    local p = Config.bucheron.boss
    while true do
        local ped = PlayerPedId()
        local pc = GetEntityCoords(ped)
        local d = #(pc - p)
        if d <= 2.0 and not MenuBucheron then
            -- déjà géré par la boucle du blip boss, on reste light ici
            Citizen.Wait(200)
        else
            Citizen.Wait(600)
        end
    end
end)

-- Sécurité : si joueur meurt/quit l’anim, on libère le tronc
AddEventHandler('esx:onPlayerDeath', function()
    if EnServiceBucheron then
        if carriedProp and DoesEntityExist(carriedProp) then
            DetachEntity(carriedProp, true, true)
            DeleteEntity(carriedProp)
        end
        carriedProp = nil
        carryingLog = false
        ClearPedTasksImmediately(PlayerPedId())
    end
end)

-- ===== Helpers =====
local function SafeDeleteEntity(ent)
    if not ent or ent == 0 then return end
    if DoesEntityExist(ent) then
        SetEntityAsMissionEntity(ent, true, true)
        DeleteObject(ent)
        if DoesEntityExist(ent) then
            DeleteEntity(ent)
        end
    end
end

-- ===== CLEAN ATTACHMENTS (panic) =====
function RemoveAllAttachedProps()
    local ped = PlayerPedId()

    -- 1) tes refs locales connues (si tu les utilises dans tes scripts)
    if carriedProp then
        DetachEntity(carriedProp, true, true)
        SafeDeleteEntity(carriedProp)
        carriedProp = nil
    end
    if axeProp then
        DetachEntity(axeProp, true, true)
        SafeDeleteEntity(axeProp)
        axeProp = nil
    end

    -- 2) balayage global des objets attachés au joueur (sécurise les autres cas)
    local allObjs = GetGamePool('CObject')  -- tous les objets locaux
    for _, obj in ipairs(allObjs) do
        if DoesEntityExist(obj) and IsEntityAttached(obj) then
            local parent = GetEntityAttachedTo(obj)
            if parent == ped then
                DetachEntity(obj, true, true)
                SafeDeleteEntity(obj)
            end
        end
    end

    -- 3) stoppe toute anim/secondary task qui pourrait re-attacher derrière
    ClearPedTasksImmediately(ped)
    ClearPedSecondaryTask(ped)

    -- 4) feedback
    if ESX and ESX.ShowNotification then
        ESX.ShowNotification("🧹 ~g~Tous les objets attachés ont été nettoyés.")
    end
end

RemoveAllAttachedProps()