ESX = ESX or nil

local EnServiceGuide = false
local MenuGuide = false
local guideBlips = {}
local routeBlip = nil
local tourBus = 0
local tourists = {}     -- peds locaux
local currentStop = 1
local inTour = false
local dwellMs = 6000
local lastAction = 0

Config = Config or {}
Config.guide = {
    boss = vector3(603.19671630859, 78.964698791504, 91.391799926758),     -- lieu “chef guide” (à ajuster)
    vehicle = 'tourbus',                        -- bus de tournée Vinewood
    busSpawn = { pos = vector3(610.57952880859, 86.932144165039, 91.118927001953), heading = 159.26637268066 }, -- spawn bus
    seatsToFill = {0,1,2,3,4,5},                -- sièges passagers à remplir (laisser -1 pour driver)
    touristsModels = {                          -- PNJ touristes (variés)
        'a_m_y_business_01','a_f_y_tourist_01','a_m_m_tourist_01','a_f_y_tourist_02','a_m_y_bevhills_02','a_f_y_yoga_01'
    },
    stops = {
        { name="Vinewood Blvd — Star Plaza", pos=vector3(293.71014404297, 175.90367126465, 104.0923614502) },
        { name="Rockford Hills — Rodeo Dr.", pos=vector3(-668.58264160156, -123.45452880859, 37.715370178223) },
        { name="Lifeinvader",                pos=vector3(-1084.0029296875, -270.00650024414, 37.655666351318) },
        { name="Richards Majestic",          pos=vector3(-1038.9956054688, -471.87426757812, 36.86157989502) },
        { name="Del Perro Promenade",        pos=vector3(-1565.0811767578, -523.15008544922, 35.560127258301) },
        { name="Backlot City Gate",          pos=vector3(-491.19705200195, -667.91809082031, 32.767971038818) },
    },
    blipBoss = { sprite=181, color=50, scale=0.8, name="Guide touristique" },
    payPerStop = { min=260, max=340 },          -- payé par arrêt (serveur valide)
    stopRadius = 18.0,                          -- rayon de détection
    speedMaxForStop = 3.0                       -- vitesse max (m/s) pour valider l'arrêt
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    RMenu.Add('guide', 'main', RageUI.CreateMenu("PRIME", "Guide touristique", 1, 100))
    RMenu:Get('guide', 'main'):SetRectangleBanner(255,220,0,140)
    RMenu:Get('guide', 'main').EnableMouse = false
    RMenu:Get('guide', 'main').Closed = function() MenuGuide = false end

    local p = Config.guide.boss
    local blip = AddBlipForCoord(p)
    SetBlipSprite(blip, Config.guide.blipBoss.sprite)
    SetBlipScale(blip,  Config.guide.blipBoss.scale)
    SetBlipColour(blip, Config.guide.blipBoss.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(Config.guide.blipBoss.name)
    EndTextCommandSetBlipName(blip)
    table.insert(guideBlips, blip)
end)

-- ======================
-- HELPERS
-- ======================
local function LoadModel(model)
    local hash = (type(model) == 'number') and model or GetHashKey(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local i=0
        while not HasModelLoaded(hash) and i<1000 do Citizen.Wait(10); i=i+1 end
    end
    return HasModelLoaded(hash) and hash or nil
end

local function SafeDelEntity(ent)
    if ent ~= 0 and ent and DoesEntityExist(ent) then
        SetEntityAsMissionEntity(ent, true, true)
        DeleteEntity(ent)
    end
end

local function CleanupGuide(full)
    if routeBlip and DoesBlipExist(routeBlip) then RemoveBlip(routeBlip) end
    routeBlip = nil
    -- delete local peds
    for _,p in ipairs(tourists) do
        if DoesEntityExist(p) then
            TaskLeaveVehicle(p, tourBus, 0)
            Citizen.Wait(50)
            SafeDelEntity(p)
        end
    end
    tourists = {}
    if full and tourBus ~= 0 then
        if DoesEntityExist(tourBus) then
            SetEntityAsMissionEntity(tourBus, true, true)
            DeleteVehicle(tourBus)
        end
        tourBus = 0
    end
    inTour = false
    currentStop = 1
end

local function SpawnTourBus()
    if tourBus ~= 0 and DoesEntityExist(tourBus) then return true end
    local sp = Config.guide.busSpawn
    local mdl = LoadModel(Config.guide.vehicle)
    if not mdl then ESX.ShowNotification("~r~Impossible de charger le bus."); return false end
    tourBus = CreateVehicle(mdl, sp.pos.x, sp.pos.y, sp.pos.z, sp.heading, true, false) -- networked
    SetEntityAsMissionEntity(tourBus, true, true)
    SetVehicleOnGroundProperly(tourBus)
    SetVehicleNumberPlateText(tourBus, "VINE"..math.random(100,999))
    SetVehicleDoorsLocked(tourBus, 1)
    -- warp driver
    TaskWarpPedIntoVehicle(PlayerPedId(), tourBus, -1)
    return true
end

local function SpawnTourists()
    -- déjà là ?
    for _,p in ipairs(tourists) do if DoesEntityExist(p) then return end end

    local ped = PlayerPedId()
    local models = Config.guide.touristsModels
    for _,seat in ipairs(Config.guide.seatsToFill) do
        if IsVehicleSeatFree(tourBus, seat) then
            local name = models[(math.random(#models))]
            local mdlHash = LoadModel(name)
            if mdlHash then
                local pc = GetEntityCoords(ped)
                local pz = CreatePed(4, mdlHash, pc.x, pc.y, pc.z, 0.0, false, false) -- local ped
                SetBlockingOfNonTemporaryEvents(pz, true)
                SetPedFleeAttributes(pz, 0, false)
                SetPedCanBeTargetted(pz, false)
                SetEntityInvincible(pz, true)
                TaskWarpPedIntoVehicle(pz, tourBus, seat)
                table.insert(tourists, pz)
            end
        end
    end
end

local function SetNextStopBlip()
    if not Config.guide.stops[currentStop] then currentStop = 1 end
    local dst = Config.guide.stops[currentStop].pos
    if routeBlip and DoesBlipExist(routeBlip) then RemoveBlip(routeBlip) end
    routeBlip = AddBlipForCoord(dst)
    SetBlipSprite(routeBlip, 280)
    SetBlipScale(routeBlip, 0.85)
    SetBlipColour(routeBlip, 46)
    SetBlipRoute(routeBlip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(("Arrêt: %s"):format(Config.guide.stops[currentStop].name))
    EndTextCommandSetBlipName(routeBlip)
    SetNewWaypoint(dst.x, dst.y)
end

local function StartTourLoop()
    if inTour then return end
    inTour = true
    currentStop = currentStop > 0 and currentStop or 1
    SetNextStopBlip()

    Citizen.CreateThread(function()
        while EnServiceGuide and inTour do
            if tourBus == 0 or not DoesEntityExist(tourBus) then
                -- bus détruit -> fin de tour mais service reste actif
                ESX.ShowNotification("~r~Bus détruit. Sortez un nouveau bus pour reprendre la tournée.")
                inTour = false
                if routeBlip and DoesBlipExist(routeBlip) then RemoveBlip(routeBlip) end
                routeBlip = nil
                CleanupGuide(true)
                break
            end

            local ped = PlayerPedId()
            local dst = Config.guide.stops[currentStop]
            if dst then
                local busPos = GetEntityCoords(tourBus)
                local d = #(busPos - dst.pos)
                if d <= Config.guide.stopRadius then
                    local speed = GetEntitySpeed(tourBus) -- m/s
                    DrawMarker(20, dst.pos.x, dst.pos.y, dst.pos.z+1.0, 0,0,0, 0,0,0, 0.8,0.8,0.8, 255,215,0,150, 0,0,2,1,nil,nil,0)
                    if speed <= Config.guide.speedMaxForStop then
                        ESX.ShowHelpNotification("Appuyez sur ~b~E~w~ pour présenter le site")
                        if IsControlJustPressed(1, 51) and (GetGameTimer() - lastAction > 1200) then
                            lastAction = GetGameTimer()
                            -- Petite “présentation”
                            TriggerEvent("core:drawBar", dwellMs, "🎤 Présentation en cours...")
                            -- (optionnel) gesture sur le conducteur
                            -- TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CHEERING", 0, true)
                            Citizen.Wait(dwellMs)
                            -- ClearPedTasksImmediately(ped)

                            -- Paye le stop (serveur)
                            TriggerServerEvent('guide:payStop')

                            -- Prochain arrêt
                            currentStop = currentStop + 1
                            if currentStop > #Config.guide.stops then currentStop = 1 end
                            SetNextStopBlip()
                            ESX.ShowNotification("➡️ Prochain arrêt indiqué sur le GPS.")
                            Citizen.Wait(600)
                        end
                    else
                        ESX.ShowHelpNotification("~y~Ralentissez pour l'arrêt (~b~E~w~ quand vous êtes à l'arrêt)")
                    end
                end
            end

            -- Maintient les PNJ dans le bus (si éjectés par hasard)
            for i,pz in ipairs(tourists) do
                if DoesEntityExist(pz) and not IsPedInVehicle(pz, tourBus, false) then
                    TaskWarpPedIntoVehicle(pz, tourBus, Config.guide.seatsToFill[i] or 0)
                end
            end

            Citizen.Wait(0)
        end
    end)
end

-- ======================
-- MENU
-- ======================
local function openGuideMenu()
    if MenuGuide then MenuGuide=false return end
    MenuGuide=true
    RageUI.Visible(RMenu:Get('guide','main'), true)

    Citizen.CreateThread(function()
        while MenuGuide do
            RageUI.IsVisible(RMenu:Get('guide','main'), true, true, true, function()
                RageUI.ButtonWithStyle(
                    EnServiceGuide and "~g~En service" or "Prendre son service",
                    "", {RightLabel="→"}, true,
                    function(_,_,Selected)
                        if Selected and not EnServiceGuide then
                            EnServiceGuide = true
                            ESX.ShowNotification("~g~Service Guide commencé !")
                        end
                    end
                )

                RageUI.ButtonWithStyle("Sortir le bus", "Fournit un Tourbus (Vinewood).", {RightLabel="→"}, EnServiceGuide, function(_,_,Selected)
                    if Selected then
                        if SpawnTourBus() then
                            SpawnTourists()
                            ESX.ShowNotification("🚌 Bus prêt. Les touristes sont à bord.")
                        end
                    end
                end)

                RageUI.ButtonWithStyle(inTour and "~y~Tournée en cours" or "Démarrer la tournée",
                    "Faites tous les arrêts en boucle.", {RightLabel="→"},
                    EnServiceGuide, function(_,_,Selected)
                        if Selected then
                            if tourBus == 0 or not DoesEntityExist(tourBus) then
                                ESX.ShowNotification("~r~Sortez le bus d'abord.")
                                return
                            end
                            SpawnTourists()
                            StartTourLoop()
                        end
                    end)

                RageUI.ButtonWithStyle("Fin de service", "", {RightLabel="→"}, true, function(_,_,Selected)
                    if Selected then
                        EnServiceGuide = false
                        CleanupGuide(true)
                        ESX.ShowNotification("~g~Fin de service Guide.")
                        RageUI.CloseAll()
                        MenuGuide=false
                    end
                end)
            end)
            Citizen.Wait(0)
        end
    end)
end

-- ======================
-- INTERACTION BOSS
-- ======================
Citizen.CreateThread(function()
    local p = Config.guide.boss
    while true do
        local ped = PlayerPedId()
        local pc = GetEntityCoords(ped)
        local d = #(pc - p)
        local near=false

        if d <= 15.0 then
            near=true
            DrawMarker(6, p.x, p.y, p.z, 0,0,0, -90,0,0, 0.6,0.6,0.6, 255,220,0,140, 0,0,2,1,nil,nil,0)
        end
        if d <= 2.0 then
            near=true
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler au responsable Guide")
            if IsControlJustPressed(1,51) and not MenuGuide then
                openGuideMenu()
            end
        end

        Citizen.Wait(near and 0 or 500)
    end
end)

-- ======================
-- CLEANUP
-- ======================
AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        CleanupGuide(true)
    end
end)

AddEventHandler('esx:onPlayerDeath', function()
    if EnServiceGuide then
        -- garde le bus, mais stop la tournée en cours
        if routeBlip and DoesBlipExist(routeBlip) then RemoveBlip(routeBlip) end
        routeBlip=nil
        inTour=false
    end
end)