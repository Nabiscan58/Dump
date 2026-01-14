TABLET = {}
TABLET.UI = {}
TABLET.UI.MAIN = {}
TABLET.UI.MAIN.Alpha = 0

ESX = nil

Citizen.CreateThread(function ()
    while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    Modules.UI.LoadStreamDict("tablet")
end)

RegisterNetEvent("tablet:toggle")
AddEventHandler("tablet:toggle", function()
    local playerPed = PlayerPedId()

    if Modules.UI.IsActive("tablet") then
        DisplayRadar(true)
        Modules.UI.SetPageInactive("tablet")
    else
        if IsPedInAnyVehicle(playerPed, false) and GetPedInVehicleSeat(GetVehiclePedIsIn(playerPed, false), -1) == playerPed then
            ESX.ShowNotification("Vous ne pouvez pas utiliser votre tablette en voiture.")
        else
            DisplayRadar(false)
            Modules.UI.SetPageActive("tablet")
        end
    end
end)

local closeCoords = {
    x = 0.64895838499069,
    y = 0.15277777612209,
}

local choosedCat = 1
local buttons = {
    {
        base = "weapons_button",
        selected = "weapon_button_hovered",
        cat = "weapons",
        catId = 1,
    },
    {
        base = "objects_button",
        selected = "objects_button_hovered",
        cat = "objects",
        catId = 2,
    },
    {
        base = "drugs_button",
        selected = "drugs_button_hovered",
        cat = "drugs",
        catId = 3,
    }
}
local min = 1
local max = 16

Citizen.CreateThread(function()
    sepX = Modules.UI.ConvertToPixel(6, 6)
    secondSepX, secondSepY = Modules.UI.ConvertToPixel(10, 10)

    wS, hS = Modules.UI.ConvertToPixel(244, 173)
end)

local questNPCs = {
    { coords = vector3(575.8477, -1635.8312, 25.9887), heading = 51.0, model = "ig_lamardavis" },
    { coords = vector3(539.5377, -1944.8313, 24.9851), heading = 306.0, model = "ig_lamardavis" },
    { coords = vector3(753.7730, -3192.9238, 6.0732), heading = 263.0, model = "ig_lamardavis" },
    { coords = vector3(270.7795, -3055.8271, 5.8474), heading = 330.0, model = "ig_lamardavis" },
    { coords = vector3(-458.1075, -2274.4365, 8.5158), heading = 279.0, model = "ig_lamardavis" },
    { coords = vector3(-1016.1346, -1907.3175, 14.4752), heading = 354.0, model = "ig_lamardavis" },
    { coords = vector3(-630.7487, -1727.8036, 24.0824), heading = 105.0, model = "ig_lamardavis" },
    { coords = vector3(-1139.9543, -433.3123, 35.9689), heading = 279.0, model = "ig_lamardavis" },
    { coords = vector3(-444.7004, 344.0906, 105.2865), heading = 3.0, model = "ig_lamardavis" },
    { coords = vector3(414.9391, -216.6278, 59.9105), heading = 329.0, model = "ig_lamardavis" },
    { coords = vector3(-34.1085, -319.8000, 46.4246), heading = 354.0, model = "ig_lamardavis" },
    { coords = vector3(-601.7255, -1142.0668, 25.8581), heading = 270.0, model = "ig_lamardavis" },
    { coords = vector3(-1109.8130, -1453.6572, 5.0699), heading = 295.0, model = "ig_lamardavis" },
    { coords = vector3(-3416.3406, 966.7654, 8.3467), heading = 278.0, model = "ig_lamardavis" },
    { coords = vector3(173.8690, 2778.4128, 46.0773), heading = 272.0, model = "ig_lamardavis" },
    { coords = vector3(402.9625, 2583.7393, 43.5196), heading = 128.0, model = "ig_lamardavis" },
    { coords = vector3(1546.7577, 3701.5503, 35.0896), heading = 109.0, model = "ig_lamardavis" },
    { coords = vector3(1682.7837, 3287.6313, 41.1465), heading = 215.0, model = "ig_lamardavis" },
    { coords = vector3(2327.2773, 2530.5647, 46.6677), heading = 166.0, model = "ig_lamardavis" },
    { coords = vector3(2309.4731, 4885.1938, 41.8082), heading = 48.0, model = "ig_lamardavis" },
    { coords = vector3(1638.2363, 4879.2251, 42.0345), heading = 100.0, model = "ig_lamardavis" },
    { coords = vector3(97.7575, 3682.6448, 39.7313), heading = 6.0, model = "ig_lamardavis" },
    { coords = vector3(-343.1177, 6097.8354, 31.3131), heading = 320.0, model = "ig_lamardavis" },
    { coords = vector3(64.8321, 6652.3735, 32.2742), heading = 320.0, model = "ig_lamardavis" },
    { coords = vector3(-528.9565, 7670.2974, 6.8685), heading = 206.0, model = "ig_lamardavis" },
    { coords = vector3(-1094.7280, 6648.4214, 3.4180), heading = 286.0, model = "ig_lamardavis" },
    { coords = vector3(-1790.1759, 6468.7075, 16.8781), heading = 167.0, model = "ig_lamardavis" }
}

local playerOnQuest = false
local blip = nil
local currentQuestNPC = nil
local npcEntity = nil

-- Fonction de commande via la tablette
function ShowBuyed(item)
    -- Vérifier si le joueur a déjà une commande en cours
    if playerOnQuest then
        ESX.ShowNotification("Vous avez déjà une commande en cours.")
        return
    end

    AddTextEntry("FMMC_KEY_TIP1", "Entrez la quantité")
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", "", "", "", "", 4) 

    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Citizen.Wait(0)
    end

    local result = GetOnscreenKeyboardResult()

    if not result then
        ESX.ShowNotification("Saisie annulée.")
        return
    end

    local quantity = tonumber(result)
    if not quantity or quantity <= 0 then
        ESX.ShowNotification("Quantité invalide.")
        return
    end

    playerOnQuest = true

    -- Sélection aléatoire d'un PNJ
    local npcIndex = math.random(1, #questNPCs)
    currentQuestNPC = questNPCs[npcIndex]

    -- Notification pour informer le joueur
    ESX.ShowNotification("Vous avez commandé " .. quantity .. "x " .. item.name .. ". Rendez-vous auprès du PNJ pour le récupérer.")

    -- Ajout du blip pour le PNJ
    blip = AddBlipForCoord(currentQuestNPC.coords.x, currentQuestNPC.coords.y, currentQuestNPC.coords.z)
    SetBlipSprite(blip, 1) -- Icône classique
    SetBlipColour(blip, 2) -- Couleur rouge
    SetBlipScale(blip, 0.8) -- Taille du blip
    SetBlipAsShortRange(blip, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Récupérez votre commande")
    EndTextCommandSetBlipName(blip)

    -- Vérification de la proximité et apparition du PNJ
    Citizen.CreateThread(function()
        while playerOnQuest do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - currentQuestNPC.coords)
            local near = false

            if distance < 50.0 and not npcEntity then
                SpawnNPC(currentQuestNPC) -- Faire apparaître le PNJ localement
            elseif distance > 50.0 and npcEntity then
                DeleteEntity(npcEntity)
                npcEntity = nil
            end

            if distance < 2.0 then
                near = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récupérer votre commande.")
                if IsControlJustPressed(0, 38) then
                    CompleteQuest(item, quantity)
                end
            end

            if near then
                Citizen.Wait(0)
            else
                Citizen.Wait(500)
            end
        end
    end)
end

function SpawnNPC(npc)
    RequestModel(npc.model)
    while not HasModelLoaded(npc.model) do
        Citizen.Wait(100)
    end

    npcEntity = CreatePed(4, GetHashKey(npc.model), npc.coords.x, npc.coords.y, npc.coords.z - 1.0, npc.heading, false, true)
    SetEntityInvincible(npcEntity, true)
    SetBlockingOfNonTemporaryEvents(npcEntity, true)
    FreezeEntityPosition(npcEntity, true)
end

function CompleteQuest(item, quantity)
    TriggerServerEvent("tablet:buyItem", item.sprite, quantity)

    playerOnQuest = false
    currentQuestNPC = nil

    if npcEntity then
        DeleteEntity(npcEntity)
        npcEntity = nil
    end

    if blip then
        RemoveBlip(blip)
        blip = nil
    end
end

GroupDigits = function(value)
	local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)','%1' .. ","):reverse())
end

function TABLET.UI.MAIN.Draw()
    if IsControlJustPressed(0, 37) or IsControlJustPressed(0, 192) or IsControlJustPressed(0, 204) or IsControlJustPressed(0, 211) or IsControlJustPressed(0, 349) then
        DisplayRadar(true)
        Modules.UI.SetPageInactive("tablet")
    end

    local hovering = false

    local baseXGood, baseYGood = 0.2139583849907, 0.08277777612208
    local w, h = Modules.UI.ConvertToPixel(1111, 907)
    Modules.UI.DrawSpriteNew("tablet", "container_blank", baseXGood, baseYGood, w, h, 0, 255, 255, 255, 255, {
        NoHover            = false,
        NoSelect           = true,
        devmod             = false,
        CustomHoverTexture = nil,
    }, function(onSelected, onHovered)

    end)

    local wClose, hClose = Modules.UI.ConvertToPixel(50, 50)
    Modules.UI.DrawSpriteNew("tablet", "close_icon", 0.77545838499067, 0.06627777612208, wClose, hClose, 0, 255, 255, 255, 255, {
        NoHover            = false,
        NoSelect           = false,
        devmod             = false,
        CustomHoverTexture = nil,
    }, function(onSelected, onHovered)
        if onHovered then
            hovering = true
        end

        if onSelected then
            PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FREEMODE_SOUNDSET", true)
            DisplayRadar(true)
            Modules.UI.SetPageInactive("tablet")
        end
    end)

    local baseX = 0.1564583849907
    for k,v in pairs(buttons) do
        if choosedCat == k then
            local w, h = Modules.UI.ConvertToPixel(142, 55)
            Modules.UI.DrawSpriteNew("tablet", v.selected, baseX + (w + sepX) * k, 0.11277777612208, w, h, 0, 255, 255, 255, 255, {
                NoHover            = false,
                NoSelect           = false,
                devmod             = false,
                CustomHoverTexture = { "tablet", v.selected },
            }, function(onSelected, onHovered)
                if onHovered then
                    hovering = true
                end

                if onSelected then
                    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FREEMODE_SOUNDSET", true)
                    choosedCat = k
                    min = 1
                    max = 16
                end
            end)
        else
            local w, h = Modules.UI.ConvertToPixel(142, 55)
            Modules.UI.DrawSpriteNew("tablet", v.base, baseX + (w + sepX) * k, 0.11277777612208, w, h, 0, 255, 255, 255, 255, {
                NoHover            = false,
                NoSelect           = false,
                devmod             = false,
                CustomHoverTexture = { "tablet", v.selected },
            }, function(onSelected, onHovered)
                if onHovered then
                    hovering = true
                end

                if onSelected then
                    PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FREEMODE_SOUNDSET", true)
                    choosedCat = k
                    min = 1
                    max = 16
                end
            end)
        end
    end

    local pBaseX = 0.2424583849907
    local pBaseY = 0.20777777612209
    local elementCountForLine = 0
    local lines = 0
    local posX = pBaseX
    local posY = (pBaseY)

    if TABLETDATA.getItems()[choosedCat] then
        for k,v in pairs(TABLETDATA.getItems()[choosedCat]) do
            if k >= min and k <= max then 
                if TABLETDATA.getItems()[choosedCat][k] then
                    posX = (pBaseX) + (wS + secondSepX) * (elementCountForLine)
                    if elementCountForLine >= 4 then
                        elementCountForLine = 0
                        lines = lines + 1
                        posY = (pBaseY) + (hS + secondSepY) * lines
                        posX = (pBaseX) + (wS + secondSepX) * (elementCountForLine)
                    end

                    local wA, hA = Modules.UI.ConvertToPixel(244, 173)
                    local sizeX, sizeY, resizeDone = Modules.UI.CalculateCorrecteSizeForUI("tabletu", "tablet", v.sprite, 100, 100)

                    Modules.UI.DrawRectangle(vector2(posX, posY), vector2(wA, hA), {0, 0, 0, 50}, true, {0, 0, 0, 50}, function ()
            
                    end, function ()
                
                    end)

                    local wB, hB = Modules.UI.ConvertToPixel(244, 40)
                    Modules.UI.DrawRectangle(vector2(posX, posY + 0.121), vector2(wB, hB), {0, 0, 0, 50}, false, {0, 0, 0, 0}, function()
            
                    end, function()

                    end)

                    Modules.UI.DrawSpriteNew("tablet", v.sprite, posX + 0.040, posY + 0.017, sizeX, sizeY, 0, 255, 255, 255, 255, {
                        NoHover            = false,
                        NoSelect           = false,
                        devmod             = false,
                        CustomHoverTexture = nil,
                    }, function(onSelected, onHovered)
                        
                    end)

                    local wBuy, hBuy = Modules.UI.ConvertToPixel(80, 29)
                    Modules.UI.DrawSpriteNew("tablet", "buy_button", posX + 0.082, posY + 0.126, wBuy, hBuy, 0, 255, 255, 255, 255, {
                        NoHover            = false,
                        NoSelect           = false,
                        devmod             = false,
                        CustomHoverTexture = {"tablet", "buy_button_hovered"},
                    }, function(onSelected, onHovered)
                        if onHovered then
                            hovering = true
                        end

                        if onSelected then
                            TABLETDATA.buy(v)
                        end
                    end)

                    Modules.UI.DrawTexts(posX + 0.005, posY + 0.130, v.name, false, 0.265, { 255, 255, 255, 200 }, 8, false, false)
                    Modules.UI.DrawTexts(posX + 0.005, posY + 0.010, GroupDigits(v.price).."$", false, 0.265, { 255, 255, 255, 200 }, 8, false, false)

                    elementCountForLine = elementCountForLine + 1
                end
            end
        end
    end

    if IsDisabledControlPressed(0, 180) or IsControlPressed(0, 180) then
        if max < #TABLETDATA.getItems()[choosedCat] then
            min = min + 5
            max = max + 5
        end
    end
    if IsDisabledControlPressed(0, 115) or IsControlPressed(0, 115) then
        if min > 1 then
            min = min - 5
            max = max - 5
        end
    end

    local w, h = Modules.UI.ConvertToPixel(40, 40)
    Modules.UI.DrawSpriteNew("tablet", "dirty_icon", 0.68345838499068, 0.12127777612208, w, h, 0, 255, 255, 255, 255, {
        NoHover            = false,
        NoSelect           = true,
        devmod             = false,
        CustomHoverTexture = nil,
    }, function(onSelected, onHovered)

    end)

    Modules.UI.DrawTexts(0.70795838499068, 0.12127777612208, "Argent sale", false, 0.265, { 255, 255, 255, 200 }, 8, false, false)
    Modules.UI.DrawTexts(0.70845838499068, 0.13727777612208, TABLETDATA.getDirty(), false, 0.295, { 255, 98, 98, 255 }, 8, false, false)

    if hovering then
        SetMouseCursorSprite(3)
    else
        SetMouseCursorSprite(1)
    end

    -- Modules.UI.DrawTexts(0.85195838499069, 0.11877777612208, "Argent sale", false, 0.485, { 255, 255, 255, 145 }, 22, false, false)

    -- Modules.UI.DrawSpriteNew("tablet", "background", 0.0, 0.0, 1920, 1080, 0, 255, 255, 255, 255, {
    --     devmod = false,
    --     NoSelect = true,
    --     NoHover = true,
    --     centerDraw = false
    -- }, function()
    -- end)

    if IsControlPressed(0, 187) then
        -- down
        closeCoords.y = closeCoords.y - 0.0005
    end
    if IsControlPressed(0, 188) then
        -- up
        closeCoords.y = closeCoords.y + 0.0005
    end

    if IsControlPressed(0, 189) then
        -- left
        closeCoords.x = closeCoords.x - 0.0005
    end
    if IsControlPressed(0, 190) then
        -- right
        closeCoords.x = closeCoords.x + 0.0005
    end

    if IsControlJustPressed(0, 38) then
        print(json.encode(closeCoords))
    end
end