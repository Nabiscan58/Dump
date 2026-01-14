DRUGTERRAIN = {
    ["spawnedPeds"] = {},
    ["groupPeds"] = {},
    ["allBlips"] = {},
    ["started"] = false,
    ["group"] = false,
    ["nearPed"] = false,
    ["loadedThreads"] = false,
    ["currentPed"] = nil,
    ["currentDrug"] = nil,
    ["loading"] = false,
}

local maxNPCs = 20 -- nombre maximum de PNJs à faire apparaître
local spawnDelay = 500 -- délai entre l'apparition de chaque PNJ (en millisecondes)
local spawnRadius = 100 -- rayon dans lequel les PNJs apparaissent autour du joueur
local totalNPCsSpawned = 0 -- nombre total de PNJs apparus
local interactedPeds = {} -- Table pour stocker les PNJs avec lesquels le joueur a interagi
-- Exemples des chances pour chaque situation
local situationChances = {
    accept = 700,   -- 50% de chance
    refuse = 200,   -- 40% de chance
    callPolice = 70, -- 7% de chance
    attack = 30     -- 3% de chance
}
local influenceCoords = vector3(4945.14, -5192.93, 2.5) -- Cayo Perico
local influenceRadius = 100.0  -- Distance d'influence

DrawSub = function(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
    EndTextCommandPrint(time, 1)
end

function adjustChancesBasedOnProximity(playerCoords, situationChances)
    local distance = #(playerCoords - influenceCoords)

    if distance <= influenceRadius then
        -- Si le joueur est à moins de 100m des coordonnées spécifiées, augmenter les chances d'attaque
        situationChances.attack = 100  -- Augmenter la chance d'attaque (ex. 10%)
        situationChances.refuse = 300  -- Réduire les autres chances en conséquence
        situationChances.callPolice = 50
        situationChances.accept = 550
    else
        -- Remettre les chances par défaut si le joueur est en dehors de la zone
        situationChances.attack = 30  -- 3%
        situationChances.refuse = 400  -- 40%
        situationChances.callPolice = 70  -- 7%
        situationChances.accept = 500  -- 50%
    end
end

-- Fonction pour déterminer le résultat basé sur les chances données
function getOutcomeBasedOnChance(chances)
    local totalChance = 0
    local randomValue = math.random(1, 1000) -- Utiliser une plus grande plage pour plus de précision (1-1000)

    for outcome, chance in pairs(chances) do
        totalChance = totalChance + chance
        if randomValue <= totalChance then
            return outcome
        end
    end
    return nil -- Dans le cas improbable où rien n'est retourné
end

-- Nouveau 14 05 2025
DRUGTERRAIN.spawnNPC = function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local spawnX, spawnY, spawnZ
    local foundSafeCoord, safeCoords
    local isInTerritory = false
    local maxAttempts = 10
    local isRoxwood = false

    local distToRoxwood = #(playerCoords - vector3(-1144.31, 7901.0, playerCoords.z))
    if distToRoxwood < 3500.0 then
        isRoxwood = true
    end

    for i = 1, maxAttempts do
        local rx, ry = math.random(-spawnRadius, spawnRadius), math.random(-spawnRadius, spawnRadius)
        spawnX = playerCoords.x + rx
        spawnY = playerCoords.y + ry

        if isRoxwood then
            spawnZ = playerCoords.z + 5.0
        else
            spawnZ = playerCoords.z + 1000.0
            foundSafeCoord, safeCoords = GetSafeCoordForPed(spawnX, spawnY, playerCoords.z, true, 16)
            if foundSafeCoord then
                spawnX, spawnY, spawnZ = safeCoords.x, safeCoords.y, safeCoords.z
            end
        end

        if TERRITORIES.isInCoords(vector3(spawnX, spawnY, spawnZ)) then
            isInTerritory = true
            break
        end
    end

    if not isInTerritory then
        print("Impossible de trouver une position dans un territoire valide après " .. maxAttempts .. " tentatives.")
        return
    end

    if not isRoxwood then
        local foundGround, groundZ = GetGroundZFor_3dCoord(spawnX, spawnY, spawnZ + 100.0, 0)
        if foundGround then
            spawnZ = groundZ
        else
            spawnZ = playerCoords.z
        end
    end

    local choosedPed = DRUGTERRAIN.getPed()
    if not HasModelLoaded(GetHashKey(choosedPed)) then
        RequestModel(GetHashKey(choosedPed))
        while not HasModelLoaded(GetHashKey(choosedPed)) do
            Citizen.Wait(100)
        end
    end

    local ped = CreatePed(1, choosedPed, spawnX, spawnY, spawnZ, math.random(0, 360), false, true)
    SetEntityVisible(ped, false, 0)
    SetEntityInvincible(ped, true)

    SetPedFleeAttributes(ped, 0, false)
    SetPedCombatAttributes(ped, 46, true)

    Citizen.CreateThread(function()
        while not HasCollisionLoadedAroundEntity(ped) do
            Citizen.Wait(0)
        end
        SetEntityVisible(ped, true, 0)

        while IsEntityInAir(ped) do
            Citizen.Wait(500)
        end

        SetEntityInvincible(ped, false)
    end)

    if not DecorIsRegisteredAsType("canBeRacketed", 2) then
        DecorRegister("canBeRacketed", 2)
    end
    DecorSetBool(ped, "canBeRacketed", false)

    table.insert(DRUGTERRAIN["spawnedPeds"], ped)
    TaskWanderStandard(ped, 10.0, 10)

    Citizen.CreateThread(function()
        local lastPosition = GetEntityCoords(ped)
        local freezeTimer = 0

        while DoesEntityExist(ped) and not interactedPeds[ped] do
            local pedCoords = GetEntityCoords(ped)
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = #(playerCoords - pedCoords)
            local inTerritory = TERRITORIES.isInCoords(pedCoords)

            if distance > spawnRadius or not inTerritory then
                if DoesEntityExist(ped) then DeleteEntity(ped) end
                DRUGTERRAIN.spawnNPC()
                return
            end

            if #(pedCoords - lastPosition) < 1.0 then
                freezeTimer = freezeTimer + 1
            else
                freezeTimer = 0
            end

            if freezeTimer > 3 then
                if DoesEntityExist(ped) then DeleteEntity(ped) end
                DRUGTERRAIN.spawnNPC()
                return
            end

            lastPosition = pedCoords
            Citizen.Wait(5000)
        end
    end)

    return ped
end

-- Save du 14 05 2025
-- DRUGTERRAIN.spawnNPC = function()
--     local playerPed = PlayerPedId()
--     local playerCoords = GetEntityCoords(playerPed)
--     local spawnX, spawnY, spawnZ
--     local foundSafeCoord, safeCoords
--     local isInTerritory = false
--     local maxAttempts = 10  -- Nombre maximum de tentatives pour trouver des coordonnées valides
-- 
--     for i = 1, maxAttempts do
--         local rx, ry = math.random(-spawnRadius, spawnRadius), math.random(-spawnRadius, spawnRadius)
--         spawnX = playerCoords.x + rx
--         spawnY = playerCoords.y + ry
--         spawnZ = playerCoords.z + 1000.0  -- Position initiale en hauteur
-- 
--         foundSafeCoord, safeCoords = GetSafeCoordForPed(spawnX, spawnY, playerCoords.z, true, 16)
--         if foundSafeCoord then
--             spawnX, spawnY, spawnZ = safeCoords.x, safeCoords.y, safeCoords.z
--         end
-- 
--         if TERRITORIES.isInCoords(vector3(spawnX, spawnY, spawnZ)) then
--             isInTerritory = true
--             break
--         end
--     end
-- 
--     if not isInTerritory then
--         print("Impossible de trouver une position dans un territoire valide après " .. maxAttempts .. " tentatives.")
--         return
--     end
-- 
--     local foundGround, groundZ = GetGroundZFor_3dCoord(spawnX, spawnY, spawnZ + 100.0, 0)
--     if foundGround then
--         spawnZ = groundZ
--     else
--         spawnZ = playerCoords.z  -- Fallback sur la hauteur du joueur si sol non trouvé
--     end
-- 
--     local choosedPed = DRUGTERRAIN.getPed()
-- 
--     if not HasModelLoaded(GetHashKey(choosedPed)) then
--         RequestModel(GetHashKey(choosedPed))
--         while not HasModelLoaded(GetHashKey(choosedPed)) do
--             Citizen.Wait(100)
--         end
--     end
-- 
--     local ped = CreatePed(1, choosedPed, spawnX, spawnY, spawnZ, math.random(0, 360), false, true)
--     SetEntityVisible(ped, false, 0)  -- On le rend invisible pendant la correction de sa position.
-- 
--     SetPedFleeAttributes(ped, 0, false)  -- Empêche la fuite
--     SetPedCombatAttributes(ped, 46, true)  -- Empêche la peur des tirs
-- 
--     Citizen.CreateThread(function()
--         while not HasCollisionLoadedAroundEntity(ped) do
--             Citizen.Wait(0)  -- Attendre que la collision autour du PNJ soit chargée
--         end
--         SetEntityVisible(ped, true, 0)  -- Maintenant qu'il est au sol, on le rend visible
--     end)
-- 
--     if not DecorIsRegisteredAsType("canBeRacketed", 2) then
--         DecorRegister("canBeRacketed", 2)  -- Enregistre une nouvelle clé de décor
--     end
--     DecorSetBool(ped, "canBeRacketed", false)  -- Marquer ce PNJ comme non-rackettable
-- 
--     table.insert(DRUGTERRAIN["spawnedPeds"], ped)
-- 
--     TaskWanderStandard(ped, 10.0, 10)
-- 
--     -- Vérification pour limiter le déplacement du PNJ à 50 mètres du joueur ou hors d'un territoire
--     Citizen.CreateThread(function()
--         local lastPosition = GetEntityCoords(ped)
--         local freezeTimer = 0
-- 
--         while DoesEntityExist(ped) and not interactedPeds[ped] do
--             local pedCoords = GetEntityCoords(ped)
--             local playerCoords = GetEntityCoords(PlayerPedId())
--             local distance = #(playerCoords - pedCoords)
--             local inTerritory = TERRITORIES.isInCoords(pedCoords)  -- Vérifie si le PNJ est dans un territoire
--             
--             -- Si le PNJ s'éloigne à plus de 50 mètres ou s'il est hors d'un territoire
--             if distance > spawnRadius or not inTerritory then
--                 if not inTerritory then
--                     print("PNJ en dehors du territoire, suppression et remplacement")
--                 else
--                     print("PNJ trop éloigné du joueur, repositionnement")
--                 end
-- 
--                 -- Supprimer le PNJ bloqué ou hors territoire
--                 if DoesEntityExist(ped) then
--                     DeleteEntity(ped)
--                 end
-- 
--                 -- Remplacer le PNJ par un nouveau
--                 DRUGTERRAIN.spawnNPC()
-- 
--                 -- Arrêter la boucle pour ce PNJ car il a été supprimé ou redirigé
--                 return
--             end
-- 
--             -- Vérifier si le PNJ est bloqué
--             if #(pedCoords - lastPosition) < 1.0 then
--                 freezeTimer = freezeTimer + 1
--             else
--                 freezeTimer = 0
--             end
-- 
--             if freezeTimer > 3 then  -- Si le PNJ n'a pas bougé pendant plus de 3 vérifications (~15 secondes)
--                 print("PNJ détecté bloqué, suppression et remplacement")
-- 
--                 -- Supprimer le PNJ bloqué
--                 if DoesEntityExist(ped) then
--                     DeleteEntity(ped)
--                 end
-- 
--                 -- Remplacer le PNJ par un nouveau
--                 DRUGTERRAIN.spawnNPC()
-- 
--                 -- Arrêter la boucle pour ce PNJ car il a été supprimé
--                 return
--             end
-- 
--             lastPosition = pedCoords
--             Citizen.Wait(5000)  -- Vérifier toutes les 5 secondes
--         end
--     end)
-- 
--     return ped
-- end

DrawText3DDrug = function(coords, text, size, a, font, dropShadow)
	local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
	local camCoords      = GetGameplayCamCoords()
	local dist           = GetDistanceBetweenCoords(camCoords, coords.x, coords.y, coords.z, true)
	local size           = size

	if size == nil then
		size = 1
	end

	local scale = (size / dist) * 2
	local fov   = (1 / GetGameplayCamFov()) * 100
	local scale = scale * fov
	local opacity = a or 255
	local font = font or 4

	if onScreen then
		SetTextScale(0.0 * scale, 0.55 * scale)
		SetTextFont(font)
		SetTextProportional(1)
		SetTextColour(255, 255, 255, opacity)
		SetTextDropshadow(1, 1, 1, 1, 255)
		SetTextCentre(1)
		SetTextEntry('STRING')

		AddTextComponentString(text)
		DrawText(x, y)
	end
end

-- Fonction pour gérer l'interaction avec le PNJ
DRUGTERRAIN.handleInteraction = function(ped)
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local pedCoords = GetEntityCoords(ped)
    local distance = #(playerCoords - pedCoords)
    local data = TERRITORIES.isIn()

    if IsPedInAnyVehicle(PlayerPedId(), false) then return end

    -- Empêcher le joueur d'interagir avec le même PNJ plusieurs fois
    if interactedPeds[ped] then
        ESX.ShowNotification("~r~Vous avez déjà interagi avec ce PNJ.")
        return
    end

    -- Si le joueur est proche du PNJ
    if distance < 2.0 then
        -- Marquer ce PNJ comme ayant déjà été interagi
        interactedPeds[ped] = true

        -- Arrêter le PNJ (il "parle" au joueur)
        ClearPedTasks(ped)

        -- Utiliser notre fonction pour ajuster les chances en fonction de la proximité
        adjustChancesBasedOnProximity(GetEntityCoords(PlayerPedId()), situationChances)

        -- Utiliser notre fonction de probabilité pour déterminer le résultat
        local outcome = getOutcomeBasedOnChance(situationChances)

        -- Cas 1 : Acceptation (50%)
        if outcome == "accept" then
            Citizen.CreateThread(function()
                -- Charger et jouer une animation pour l'interaction
                if not HasAnimDictLoaded("mp_common") then
                    RequestAnimDict("mp_common")  -- Exemple d'animation
                    while not HasAnimDictLoaded("mp_common") do
                        Citizen.Wait(10)
                    end
                end
            
                -- Jouer l'animation pour le joueur et le PNJ
                TaskPlayAnim(playerPed, "mp_common", "givetake1_a", 8.0, -8.0, 3000, 49, 0, false, false, false) -- Animation de donner pour le joueur
                TaskPlayAnim(ped, "mp_common", "givetake1_b", 8.0, -8.0, 3000, 49, 0, false, false, false) -- Animation de recevoir pour le PNJ
            end)

            DrawSub("~r~Client: ~s~" .. cfg_drugTerrain["randomPhrases"]["sayYes"][math.random(1, #cfg_drugTerrain["randomPhrases"]["sayYes"])], 2500)
            Citizen.Wait(1000)
            DRUGTERRAIN["loading"] = true
            local choosedTime = math.random(1000, 2500)
            TriggerEvent("core:drawBar", choosedTime, "⏳ Transaction en cours...")
            Citizen.Wait(choosedTime)
            DRUGTERRAIN["loading"] = false

            TriggerServerEvent("drugTerrain:accept", {
                drug = DRUGTERRAIN["currentDrug"],
                territorie = data,
            })

            local random = math.random(1, 100)
            if random <= 15 then
                local coords = GetEntityCoords(PlayerPedId())
                local streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 755.57, 4899.1, 0, true) <= 3000 then
                    TriggerServerEvent("police:appel", coords, "Vente de drogue vers " ..streetname.. " !", "sheriff")
                else
                    TriggerServerEvent("police:appel", coords, "Vente de drogue vers " ..streetname.. " !", "police")
                end
            end

        -- Cas 2 : Refus (40%)
        elseif outcome == "refuse" then
            DrawSub("~r~Client: ~s~" .. cfg_drugTerrain["randomPhrases"]["sayNo"][math.random(1, #cfg_drugTerrain["randomPhrases"]["sayNo"])], 2500)
            Citizen.Wait(1000)

        -- Cas 3 : Poucave aux flics (7%)
        elseif outcome == "callPolice" then
            DrawSub("~r~Client: ~s~" .. cfg_drugTerrain["randomPhrases"]["callPolice"][math.random(1, #cfg_drugTerrain["randomPhrases"]["callPolice"])], 2500)
            Citizen.Wait(1000)

            local coords = GetEntityCoords(PlayerPedId())
			local streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(coords.x, coords.y, coords.z))

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), 755.57, 4899.1, 0, true) <= 3000 then
                TriggerServerEvent("police:appel", coords, "Vente de drogue vers " ..streetname.. " !", "sheriff")
            else
                TriggerServerEvent("police:appel", coords, "Vente de drogue vers " ..streetname.. " !", "police")
            end
        -- Cas 4 : Le PNJ sort une arme et attaque (3%)
        elseif outcome == "attack" then
            DrawSub("~r~Client: ~s~" .. cfg_drugTerrain["randomPhrases"]["attack"][math.random(1, #cfg_drugTerrain["randomPhrases"]["attack"])], 2500)
            Citizen.Wait(1000)
            
            -- -- Charger un modèle d'arme et donner une arme au PNJ
            -- GiveWeaponToPed(ped, GetHashKey("WEAPON_PISTOL"), 50, false, true)
            -- TaskCombatPed(ped, playerPed, 0, 16) -- Le PNJ attaque le joueur

            -- -- Surveiller la vie du PNJ et le supprimer s'il meurt
            -- Citizen.CreateThread(function()
            --     while DoesEntityExist(ped) and not IsPedDeadOrDying(ped, 1) do
            --         Citizen.Wait(500)
            --     end

            --     if IsPedDeadOrDying(ped, 1) then
            --         Citizen.Wait(5000) -- Laisser quelques secondes après la mort avant la suppression
            --         if DoesEntityExist(ped) then
            --             DeleteEntity(ped)
            --             -- Remplacer le PNJ disparu par un nouveau
            --             Citizen.Wait(2000) -- Attendre 2 secondes avant de faire apparaître un nouveau PNJ
            --             DRUGTERRAIN.spawnNPC()
            --         end
            --     end
            -- end)
        end

        -- Après l'interaction, faire fuir le PNJ si ce n'est pas un cas d'attaque
        if outcome ~= "attack" then
            TaskSmartFleePed(ped, playerPed, 100.0, -1, false, false)

            -- Supprimer le PNJ après 15 secondes et en recréer un autre
            Citizen.SetTimeout(15000, function()
                if DoesEntityExist(ped) then
                    DeleteEntity(ped)
                    -- Remplacer le PNJ disparu par un nouveau après un court délai
                    Citizen.Wait(2000) -- Attendre 2 secondes avant de faire apparaître un nouveau PNJ
                    DRUGTERRAIN.spawnNPC()
                end
            end)
        end
    end
end

-- Fonction pour générer progressivement les PNJs
DRUGTERRAIN.spawnNPCs = function()
    Citizen.CreateThread(function()
        for i = 1, maxNPCs do
            if DRUGTERRAIN["started"] then
                -- Faire apparaître un PNJ
                local ped = DRUGTERRAIN.spawnNPC()

                -- Attendre avant de faire apparaître le prochain PNJ
                Citizen.Wait(spawnDelay)
            else
                break
            end
        end
    end)
end

-- Citizen.CreateThread(function()
--     for k,v in pairs(cfg_drugTerrain["allPoints"]) do
--         if v.poly then
--             v.zone = PolyZone:Create(v.poly, {
--                 name = v.name,
--                 minZ = 0.0,
--                 maxZ = 150.0,
--                 debugPoly = true,
--             })
--         end
--     end
-- end)

DRUGTERRAIN.onClose = function()
    DRUGTERRAIN["started"] = false
    DRUGTERRAIN["currentPed"] = nil

    TriggerServerEvent("drugTerrain:removeFromSellers")

    for _,entity in pairs(DRUGTERRAIN["spawnedPeds"]) do
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end

    ESX.ShowNotification("~r~Vous venez de fermer votre terrain de drogue")
end

RegisterNetEvent("DRUGTERRAIN.onOpen")
AddEventHandler("DRUGTERRAIN.onOpen", function()
    DRUGTERRAIN.onOpen()
end)

RegisterNetEvent("DRUGTERRAIN.forceClose")
AddEventHandler("DRUGTERRAIN.forceClose", function()
    DRUGTERRAIN.forceClose()
end)

-- Début de la session de vente de drogue
DRUGTERRAIN.onOpen = function(first, data)
    local founded = TERRITORIES.isIn()
    if not founded then
        ESX.ShowNotification("~r~Vous ne pouvez pas ouvrir de terrain dans cette zone")
        return
    end

    DRUGTERRAIN["started"] = true

    if first then
        ESX.ShowNotification("~y~Vous venez d'ouvrir votre terrain de drogue")
    end

    -- Faire apparaître les PNJs progressivement
    DRUGTERRAIN.spawnNPCs()

    -- Lancer un thread qui vérifie si le joueur est proche des PNJs
    Citizen.CreateThread(function()
        while DRUGTERRAIN["started"] do
            local interval = 500
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)

            founded = TERRITORIES.isIn()
            if not founded then
                DRUGTERRAIN.forceClose()
                return
            end

            for _, ped in pairs(DRUGTERRAIN["spawnedPeds"]) do
                if DoesEntityExist(ped) and not interactedPeds[ped] then
                    -- Vérifier si le joueur est proche du PNJ
                    local pedCoords = GetEntityCoords(ped)
                    local distance = #(playerCoords - pedCoords)

                    if distance < 5.5 then
                        interval = 0

                        local x,y,z = table.unpack(GetPedBoneCoords(ped, 12844, 0.0, 0.0, 0.0))
                        DrawText3DDrug(vector3(x, y, z + 0.40), "~y~[E]", 1.0)
                    end

                    if distance < 2.5 then
                        -- Afficher une notification pour indiquer l'interaction possible
                        -- zUtils.ShowHelpNotification("Appuyez sur [E] pour interagir avec le PNJ")

                        -- Attendre que le joueur appuie sur la touche [E] pour interagir
                        if IsControlJustReleased(0, 38) then -- 38 correspond à la touche 'E'
                            DRUGTERRAIN.handleInteraction(ped)
                        end
                    end
                end
            end

            Citizen.Wait(interval) -- Vérifier toutes les 500ms pour économiser des ressources
        end
    end)
end

local lastCalled = 0
DRUGTERRAIN.handle = function(terrainData)
    if DRUGTERRAIN["loading"] then return end

    DRUGTERRAIN["currentDrug"] = terrainData.drug

    Citizen.CreateThread(function()
        if DRUGTERRAIN["started"] then
            DRUGTERRAIN.onClose()
            return
        end
        
        local founded = TERRITORIES.isIn()
        -- for k,v in pairs(cfg_drugTerrain["allPoints"]) do
        --     if (zUtils.getDst(GetEntityCoords(PlayerPedId()), v.pos) < v.dst) then
        --         founded = true
        --         point = v
        --     end
        -- end
        if not founded then
            ESX.ShowNotification("~r~Vous ne pouvez pas ouvrir de terrain dans cette zone")
            return
        end
        
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            ESX.ShowNotification("~r~Vous ne pouvez pas ouvrir de terrain dans un véhicule")
            return
        end
        
        if GetGameTimer() > lastCalled then
            DRUGTERRAIN.onOpen(true, founded)
            lastCalled = GetGameTimer() + 5 * 1000
        end
    end)
    
    if not DRUGTERRAIN["loadedThreads"] then
        DRUGTERRAIN["loadedThreads"] = true
        Citizen.CreateThread(function()
            while true do
    
                -- if DRUGTERRAIN["group"] then
                --     for _,entity in pairs(DRUGTERRAIN["spawnedPeds"]) do
                --         if DoesEntityExist(entity) and zUtils.getDst(GetEntityCoords(PlayerPedId()), GetEntityCoords(entity)) > 5.0 and DRUGTERRAIN["groupPeds"][_] then
                --             DeleteEntity(entity)
                --         end
                --     end
                -- else
                --     for _,entity in pairs(DRUGTERRAIN["spawnedPeds"]) do
                --         if DoesEntityExist(entity) and zUtils.getDst(GetEntityCoords(PlayerPedId()), GetEntityCoords(entity)) > 5.0 and entity ~= DRUGTERRAIN["currentPed"] then
                --             DeleteEntity(entity)
                --         end
                --     end
                -- end

                -- local count = 0
                -- for k,v in pairs(DRUGTERRAIN["spawnedPeds"]) do
                --     count = count + 1
                -- end
                -- if count > 2 then
                --     DRUGTERRAIN.forceClose()
                -- end
    
                Citizen.Wait(15 * 1000)
            end
        end)
    end
end

DRUGTERRAIN.getPed = function()
    math.randomseed(GetGameTimer())
    return cfg_drugTerrain["allPeds"][math.random(1, #cfg_drugTerrain["allPeds"])]
end

DRUGTERRAIN.forceClose = function()
    DRUGTERRAIN["started"] = false
    DRUGTERRAIN["currentPed"] = nil

    for _,entity in pairs(DRUGTERRAIN["spawnedPeds"]) do
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end

    for _,blip in pairs(DRUGTERRAIN["allBlips"]) do
        if DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
    end
end

RegisterNetEvent("drugTerrain:cancelAll")
AddEventHandler("drugTerrain:cancelAll", function()
    DRUGTERRAIN["started"] = false
    DRUGTERRAIN["currentPed"] = nil

    for _,entity in pairs(DRUGTERRAIN["spawnedPeds"]) do
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
    end
end)

RegisterNetEvent("drugTerrain:sendRentability")
AddEventHandler("drugTerrain:sendRentability", function(list)
    RequestStreamedTextureDict("assetsalynia", 1)
    while not HasStreamedTextureDictLoaded("assetsalynia") do
        Wait(0)
    end

    for k, v in pairs(cfg_drugTerrain["allPoints"]) do
        if DoesBlipExist(v.blip) then
            RemoveBlip(v.blip)
        end

        v.blip = AddBlipForCoord(v.pos)
        SetBlipSprite(v.blip, v.sprite)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, 0.55)
        SetBlipColour(v.blip, cfg_drugTerrain["blipsColors"][list[k].rentability])
        SetBlipAsShortRange(v.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Points fréquentés")
        EndTextCommandSetBlipName(v.blip)
    end
end)