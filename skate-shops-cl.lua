local PedShop = {} -- ✅ Store multiple NPCs
local closestStore = {}
local activeShop = nil -- ✅ Prevent duplicate shop checks
local npcSynced = false -- ✅ Ensure NPCs are only synced ONCE


Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local closestShop, closestDistance = nil, 20
        local closestShopName = nil

        -- ✅ Find the closest shop dynamically
        for shopName, shopCoords in pairs(Config.Coords.Peds) do
            local distance = #(playerCoords - vector3(shopCoords.x, shopCoords.y, shopCoords.z))
            if distance < closestDistance then
                closestDistance = distance
                closestShop = shopCoords
                closestShopName = shopName
            end
        end

        -- ✅ Ensure NPCs are synced ONLY ONCE per session
        if closestShop and closestDistance < 2.5 then
            Waits = 1

            -- ✅ Sync NPCs only once when entering the shop
            if not npcSynced then
                npcSynced = true
                TriggerServerEvent("BDX-Skate:SyncPeds")
            end

            -- ✅ Ensure the NPC exists in PedShop before interacting
            local npc = PedShop[closestShopName]
			
            if npc and DoesEntityExist(npc) and GetEntityType(npc) == 1 and not IsPedInAnyVehicle(playerPed, false) then
                -- ✅ Targeting System for QBCore / OX
                if Config.Target == "qb" then
                    exports['qb-target']:RemoveTargetEntity(npc) -- ✅ Prevent duplicate targets
                    exports['qb-target']:AddTargetEntity(npc, {
                        options = {
                            {
                                icon = "fas fa-shopping-cart",
                                label = Config.Language.Store['target'],
                                action = function()
                                    OpenMenu(closestShopName) -- ✅ Correct store name
                                end
                            }
                        },
                        distance = 2.0
                    })
                elseif Config.Target == "ox" then
                    exports.ox_target:removeLocalEntity(npc)
                    exports.ox_target:addLocalEntity(npc, {
                        {
                            label = Config.Language.Store['target'],
                            icon = "fas fa-shopping-cart",
                            onSelect = function()
                                OpenMenu(closestShopName) -- ✅ Correct store name
                            end
                        }
                    })
                elseif Config.Target == "none" then
                    DrawText3D(closestShop.x, closestShop.y - 0.2, closestShop.z + 1.0, Config.Language.Store['text'])
                    if IsControlJustPressed(0, 38) then
                        OpenMenu(closestShopName) -- ✅ Correct store name
                    end
                end
            end

            activeShop = closestShopName -- ✅ Track the active shop

        else
            -- ✅ Reset when leaving the shop area
            Waits = 5000
            if activeShop then
                activeShop = nil
				closestShop = nil
				closestDistance = 20
				closestShopName = nil
            end
        end

        Wait(Waits) -- ✅ Prevent unnecessary CPU usage
    end
end)
function OpenMenu(storeName)
	CurrentStore = storeName -- Store the current store in a global variable
	TriggerServerEvent("menu:requestOpen", CurrentStore)
end
RegisterNetEvent('SkateShop:pedHandlers', function(SkatenetIdTables)
    if Config.Debug then
        print("^2[INFO] Received NPC Data. Loading NPCs...^0")
    end

    for i = 1, #SkatenetIdTables do
        if SkatenetIdTables[i] and not PedShop[i] then -- ✅ Prevent re-loading
            if Config.Debug then
                print("^2[INFO] Spawning NPC " .. i .. " with NetID: " .. tostring(SkatenetIdTables[i]) .. "^0")
            end
            LoadNpcs(i, SkatenetIdTables[i])
        else
            if Config.Debug then
                print("^3[WARNING] NPC " .. i .. " is already loaded, skipping...^0")
            end
        end
    end
end)
function LoadNpcs(index, netID)
	CreateThread(function()
		while not NetworkDoesEntityExistWithNetworkId(netID) do
			Wait(50) 
		end
	
		local npc = NetworkGetEntityFromNetworkId(netID)
		if not npc or not DoesEntityExist(npc) then
			if Config.Debug then
				print("^1[ERROR] NPC with netID " .. tostring(netID) .. " does not exist!^0")
			end
			return
		end
	
		local storeData = Config.Shops.ShopPeds[index]
		if not storeData then
			if Config.Debug then print("^1[ERROR] StoreData is nil for index " .. index .. "!^0") end
			return
		end
	
		local storeName = storeData.StoreName -- ✅ Get correct store name
	
		-- ✅ Apply NPC properties (only once)
		SetEntityInvincible(npc, true)
		SetEntityProofs(npc, true, true, true, true, true, true, true, true)
		SetBlockingOfNonTemporaryEvents(npc, true)
		FreezeEntityPosition(npc, true)
		SetPedCanRagdollFromPlayerImpact(npc, false)
		SetPedCanRagdoll(npc, false)
		SetEntityAsMissionEntity(npc, true, true)
		SetEntityDynamic(npc, false)
		ClearPedTasksImmediately(npc)
		TaskStartScenarioInPlace(npc, storeData.Scenarios, 0, true)
	
		-- ✅ Always store the NPC in `PedShop`
		PedShop[storeName] = npc
		closestStore[storeName] = storeName
	
		if Config.Debug then
			print("^2[INFO] NPC " .. storeName .. " loaded successfully!^0")
		end
	end)
end
-- ✅ Function to Draw 3D Text Above NPC
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local scale = 0.35

    if onScreen then
        SetTextScale(scale, scale)
        SetTextFont(Config.TextFont)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextOutline()
        SetTextEntry("STRING")
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
