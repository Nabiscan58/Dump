ESX = nil

local inStalagmiteZone = false
local isPicking = false

-- spot actif
local currentIndex = 1
local activeStalagmiteBlip = nil

-- ========= CONFIG =========
local Config = {}

Config.ZoneCenter = vector3(5260.8330078125, 14195.421875, 10.021553993225)
Config.ZoneRadius = 80.0

Config.Stalagmites = {
    vector3(5265.373046875, 14184.725585938, 8.8323335647583),
    vector3(5260.58203125, 14187.7421875, 8.7969007492065),
    vector3(5255.8120117188, 14195.744140625, 8.7550888061523),
    vector3(5254.126953125, 14193.803710938, 8.8664417266846),
    vector3(5258.1513671875, 14200.252929688, 10.207853317261),
    vector3(5261.1293945312, 14200.202148438, 9.8062629699707),
    vector3(5261.3447265625, 14204.62890625, 10.779578208923),
    vector3(5265.3842773438, 14202.279296875, 10.670341491699),
    vector3(5266.2700195312, 14196.23046875, 10.183555603027),
    vector3(5278.263671875, 14191.534179688, 10.578706741333),
    vector3(5274.513671875, 14193.735351562, 10.549260139465),
    vector3(5270.3232421875, 14190.6171875, 10.315189361572),
    vector3(5279.2163085938, 14195.482421875, 10.73365688324),
    vector3(5270.177734375, 14185.765625, 8.9585647583008),
    vector3(5267.1381835938, 14188.279296875, 8.8339748382568),
    vector3(5257.8803710938, 14189.29296875, 9.0409145355225),
    vector3(5255.2890625, 14190.514648438, 8.7395782470703),
    vector3(5257.4360351562, 14183.76953125, 9.1193056106567),
    vector3(5249.279296875, 14183.047851562, 9.1232471466064),
}

Config.InteractDist = 1.8

Config.MarkerType = 20
Config.MarkerScale = vector3(0.35, 0.35, 0.35)

Config.PickScenario = "WORLD_HUMAN_GARDENER_PLANT"
Config.PickDuration = 10000

-- Rotation
Config.RotationMode = "next" -- "next" ou "random"
-- ==========================

ESX = exports["es_extended"]:getSharedObject()

-- ================== BLIPS ==================

local function UpdateActiveStalagmiteBlip()
    local pos = Config.Stalagmites[currentIndex]
    if not pos then return end

    if activeStalagmiteBlip and DoesBlipExist(activeStalagmiteBlip) then
        RemoveBlip(activeStalagmiteBlip)
        activeStalagmiteBlip = nil
    end

    activeStalagmiteBlip = AddBlipForCoord(pos.x, pos.y, pos.z)
    SetBlipSprite(activeStalagmiteBlip, 1)
    SetBlipDisplay(activeStalagmiteBlip, 4)
    SetBlipScale(activeStalagmiteBlip, 0.75)
    SetBlipColour(activeStalagmiteBlip, 5)
    SetBlipAsShortRange(activeStalagmiteBlip, false)
    SetBlipHighDetail(activeStalagmiteBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Stalagmite (active)")
    EndTextCommandSetBlipName(activeStalagmiteBlip)
end

Citizen.CreateThread(function()
    -- Blip zone
    local zoneBlip = AddBlipForCoord(Config.ZoneCenter.x, Config.ZoneCenter.y, Config.ZoneCenter.z)
    SetBlipSprite(zoneBlip, 478)
    SetBlipDisplay(zoneBlip, 4)
    SetBlipScale(zoneBlip, 0.9)
    SetBlipColour(zoneBlip, 46)
    SetBlipAsShortRange(zoneBlip, false)
    SetBlipHighDetail(zoneBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Zone de récolte de stalagmites")
    EndTextCommandSetBlipName(zoneBlip)

    -- Blip du spot actif
    UpdateActiveStalagmiteBlip()
end)

-- ================== UTILS ==================

local function ShowHelp(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function DrawStalagmiteMarker(pos)
    DrawMarker(
        Config.MarkerType,
        pos.x, pos.y, pos.z + 0.15,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        Config.MarkerScale.x, Config.MarkerScale.y, Config.MarkerScale.z,
        255, 220, 0, 160,
        false, true, 2, false, nil, nil, false
    )
end

local function NextIndex()
    if Config.RotationMode == "random" then
        if #Config.Stalagmites <= 1 then return end
        local newIndex = currentIndex
        while newIndex == currentIndex do
            newIndex = math.random(1, #Config.Stalagmites)
        end
        currentIndex = newIndex
    else
        currentIndex = currentIndex + 1
        if currentIndex > #Config.Stalagmites then
            currentIndex = 1
        end
    end

    UpdateActiveStalagmiteBlip()
end

local function PickStalagmite(pos)
    if isPicking then return end
    isPicking = true

    local ped = PlayerPedId()

    TaskTurnPedToFaceCoord(ped, pos.x, pos.y, pos.z, 600)
    Wait(600)

    TaskStartScenarioInPlace(ped, Config.PickScenario, 0, true)
    Wait(Config.PickDuration)
    ClearPedTasksImmediately(ped)

    TriggerServerEvent("stalagmites:server:harvest")

    -- 🔁 rotation spot
    NextIndex()

    isPicking = false
end

-- ================== MAIN LOOP ==================

Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)

        local distToZone = #(pCoords - Config.ZoneCenter)
        local wasInZone = inStalagmiteZone
        inStalagmiteZone = (distToZone <= Config.ZoneRadius)

        if inStalagmiteZone and not wasInZone then
            ESX.ShowNotification("Vous entrez dans la zone de récolte de stalagmites")
        end

        if inStalagmiteZone then
            local pos = Config.Stalagmites[currentIndex]
            if pos then
                local d = #(pCoords - pos)

                if d <= 20.0 then
                    DrawStalagmiteMarker(pos)
                end

                if d <= Config.InteractDist then
                    ShowHelp("Appuyez sur ~INPUT_CONTEXT~ pour ramasser une stalagmite")

                    if IsControlJustPressed(0, 51) then
                        PickStalagmite(pos)
                    end
                end
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)

--------------------------------------------------------------------------------------------

local shopOpen = false
local lastOpen = 0

local ConfigSellStalagmites = {}
ConfigSellStalagmites.Npc = {
    coords = vector3(4066.9089355469, 14370.624023438, 8.6152219772339),
    heading = 224.0,
    model = "s_m_m_scientist_01"
}

Citizen.CreateThread(function()
    -- Blip zone
    local scientBlip = AddBlipForCoord(4066.9089355469, 14370.624023438, 8.6152219772339)
    SetBlipSprite(scientBlip, 480)
    SetBlipDisplay(scientBlip, 4)
    SetBlipScale(scientBlip, 0.9)
    SetBlipColour(scientBlip, 46)
    SetBlipAsShortRange(scientBlip, false)
    SetBlipHighDetail(scientBlip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Scientifique")
    EndTextCommandSetBlipName(scientBlip)
end)

ConfigSellStalagmites.Exchanges = {
    { label = "10 Stalagmites → 75 000$", cost = 10, type = "money", value = 75000 },
    { label = "50 Stalagmites → 1 Gilet Lourd", cost = 50, type = "item", value = { name = "WEAPON_BULLET2", count = 1 } },
    { label = "1000 Stalagmites → 1 Pic de glace (PERMANENT)", cost = 1000, type = "item", value = { name = "WEAPON_ICEPICK", count = 1 } },
    { label = "1500 Stalagmites → 1 Hache d'hiver (PERMANENT)", cost = 1500, type = "item", value = { name = "WEAPON_ICEAXE", count = 1 } },
    { label = "3000 Stalagmites → 1 Katana de Glace (PERMANENT)", cost = 3000, type = "item", value = { name = "WEAPON_ICEKATANA", count = 1 } },
}

-- ========== RageUI ==========
Citizen.CreateThread(function()
    RMenu.Add('stalagmite', 'main', RageUI.CreateMenu("PRIME", "Échanges de stalagmites", 1, 100))
    RMenu:Get('stalagmite', 'main'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('stalagmite', 'main').EnableMouse = false

    RMenu:Get('stalagmite', 'main').Closed = function()
        shopOpen = false
    end
end)

local function ShowHelp(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function OpenShopMenu()
    if shopOpen then return end
    -- mini anti-spam ouverture
    local now = GetGameTimer()
    if now - lastOpen < 800 then return end
    lastOpen = now

    shopOpen = true
    RageUI.Visible(RMenu:Get('stalagmite', 'main'), true)

    Citizen.CreateThread(function()
        while shopOpen do
            RageUI.IsVisible(RMenu:Get('stalagmite', 'main'), true, true, true, function()

                RageUI.Separator("↓ Échanges disponibles ↓")

                for _, ex in ipairs(ConfigSellStalagmites.Exchanges) do
                    RageUI.ButtonWithStyle(
                        ex.label,
                        ("Coût : ~y~%d~s~ stalagmite(s)"):format(ex.cost),
                        { RightLabel = "→" },
                        true,
                        function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent("stalagmites:server:exchange", ex.cost, ex.type, ex.value)
                            end
                        end
                    )
                end

                RageUI.Separator(" ")
                RageUI.ButtonWithStyle("Fermer", "", { RightLabel = "→" }, true, function(_,_,Selected)
                    if Selected then
                        RageUI.CloseAll()
                        shopOpen = false
                    end
                end)

            end, function()
            end)

            Wait(0)
        end
    end)
end

-- ========== Spawn NPC ==========
Citizen.CreateThread(function()
    local model = GetHashKey(ConfigSellStalagmites.Npc.model)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end

    local ped = CreatePed(
        4, model,
        ConfigSellStalagmites.Npc.coords.x, ConfigSellStalagmites.Npc.coords.y, ConfigSellStalagmites.Npc.coords.z - 1.0,
        ConfigSellStalagmites.Npc.heading,
        false, true
    )

    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)

    -- petit scénario idle "scientifique"
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_CLIPBOARD", 0, true)
end)

-- ========== Interaction NPC ==========
Citizen.CreateThread(function()
    while true do
        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local dist = #(coords - ConfigSellStalagmites.Npc.coords)

        if dist <= 25.0 then
            -- marker discret
            DrawMarker(
                6,
                ConfigSellStalagmites.Npc.coords.x, ConfigSellStalagmites.Npc.coords.y, ConfigSellStalagmites.Npc.coords.z,
                0.0, 0.0, 0.0,
                -90.0, 0.0, 0.0,
                0.6, 0.6, 0.6,
                255, 220, 0, 140,
                false, true, 2, false, nil, nil, false
            )

            if dist <= 2.0 then
                ShowHelp("Appuyez sur ~INPUT_CONTEXT~ pour échanger vos stalagmites")
                if IsControlJustPressed(0, 51) then -- E
                    OpenShopMenu()
                end
            end

            Wait(0)
        else
            Wait(500)
        end
    end
end)