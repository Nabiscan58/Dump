local InAfkZone = false
active_vehicle = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
    PlayerData = ESX.GetPlayerData()
end)

AFK = {
    ["points"] = {
        ["afkzones"] = {
            {pos = vector3(214.2682800293, -863.15490722656, 28.674325942993)},
            {pos = vector3(-2034.6221923828, -462.95101928711, 10.508394813538)},
        },
		["boutique"] = {
            {pos = vector3(-1274.8911132812, -3006.1984863281, -49.489894866943)},
        },
        ["spawn"] = {
            {pos = vector3(-1266.799, -3021.931, -49.49028)},
        },
        ["sortie"] = {
            {pos = vector3(-1258.9895019531, -3006.1589355469, -49.490177154541)},
        },
        ["entree"] = {
            {pos = vector3(-293.07147216797, -886.27374267578, 30.000614089966)},
        },
        ["vehicules"] = {
            {pos = vector3(896.9922, -2105.902, 30.23097)},
        },
        ["sauvetage"] = {
            {pos = vector3(-1258.9895019531, -3006.1589355469, -49.490177154541)},
        },
    },
	listVehicles = {
        {label = 'Arias', model = 'arias', price = 1000},
        {label = 'Spritzer', model = 'spritzer', price = 2500},
        {label = 'Dubsta4x4', model = 'dubsta4x4', price = 4000},
        {label = 'Itali GTR', model = 'italigtr', price = 4500},
        {label = 'Torie', model = 'gsttorle1', price = 5000},
        {label = 'Overland', model = 'gstoverland1', price = 6000},
        {label = 'Bhow', model = 'gstbhow1', price = 7000},
        {label = 'CTX Barb', model = 'gstvstr1', price = 9000},
        {label = 'SPH', model = 'gstsph1', price = 10000},
	},
	listMoney = {
		{label = '50,000$ IG', model = '50000', price = 120},
		{label = '250,000$ IG', model = '250000', price = 480},
		{label = '500,000$ IG', model = '500000', price = 840},
        {label = '1,000,000$ IG', model = '1000000', price = 1440},
	},
    listItem = {
        {label = 'Pistolet de détresse', model = 'WEAPON_FLAREGUN', price = 200},
        {label = 'Gilet pare-balles lourd', model = 'WEAPON_BULLET2', price = 100},
		{label = 'Pistolet Lourd', model = 'WEAPON_HEAVYPISTOL', price = 450},
		{label = 'SMG MK2', model = 'WEAPON_SMG_MK2', price = 800},
	},
	['menuOpenned'] = false
}

Citizen.CreateThread(function()
	TriggerServerEvent("afk:joined")

    local coords = vector3(224.57443237305, -866.70794677734, 29.674325942993)
    local model = GetHashKey("s_m_y_ammucity_01")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(100)
    end
    local npc = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetEntityHeading(npc, 163.18402099609)
    SetBlockingOfNonTemporaryEvents(npc, true)

    local coords = vector3(214.37258911133, -862.8857421875, 29.674318313599)
    local model = GetHashKey("s_m_y_ammucity_01")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(100)
    end
    local npc = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, coords.w, false, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetEntityHeading(npc, 158.18402099609)   
    SetBlockingOfNonTemporaryEvents(npc, true)

	while true do
		local nearThing = false

        if not InAfkZone then
		    for k,v in pairs(AFK["points"]["afkzones"]) do
		    	local plyCoords = GetEntityCoords(PlayerPedId(), false)
		    	local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos.x, v.pos.y, v.pos.z)

		    	if dist < 35.0 then
		    		nearThing = true
                    -- DrawMarker(1, v.pos.x, v.pos.y, v.pos.z, nil, nil, nil, 90, nil, nil, 2.9, 2.9, 0.5, 255, 220, 0, 140, true, false)
                    Draw3DTextH(v.pos.x, v.pos.y, v.pos.z + 0.2, "Zone AFK", 4, 0.1, 0.1, 1)
		    		if dist < 3.0 then
		    			ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour accéder à la zone AFK")
		    			if IsControlJustPressed(1, 38) then
                            TriggerEvent("afk:enteringAFKZone")
		    			end
		    		end
		    	end
		    end

            for k,v in pairs(AFK["points"]["sauvetage"]) do
		    	local plyCoords = GetEntityCoords(PlayerPedId(), false)
		    	local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos.x, v.pos.y, v.pos.z)

		    	if dist < 40.0 then
                    DrawMarker(1, v.pos.x, v.pos.y, v.pos.z, nil, nil, nil, 90, nil, nil, 2.9, 2.9, 0.5, 255, 220, 0, 140, true, false)
                    Draw3DTextH(v.pos.x, v.pos.y, v.pos.z - 0.5, "Sortie d'urgence", 4, 0.2, 0.2, 4)
                    nearThing = true
		    		ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour sortir d'urgence de la zone AFK")
		    		if IsControlJustPressed(1, 38) then
						if AFK['menuOpenned'] == false then
		    				TriggerServerEvent("afk:LeaveAFKZone")
						end
		    		end
		    	end
		    end
        end

		if nearThing == true then
			Citizen.Wait(0)
		else
			Citizen.Wait(1500)
		end
	end
end)

RegisterNetEvent('afk:enteringAFKZone')
AddEventHandler('afk:enteringAFKZone', function()
	TriggerServerEvent("afk:EnterAFKZone")
    TriggerServerEvent("leaderboard:requestTopPlayersOnDemand")
    InAfkZone = true
    AFKTimer()
end)

local canRollWheel = true

Citizen.CreateThread(function()
	while true do
        local near = false

        if InAfkZone then
            near = true
            for k, v in pairs(AFK["points"]["sortie"]) do
		    	local plyCoords = GetEntityCoords(PlayerPedId(), false)
		    	local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos.x, v.pos.y, v.pos.z)

		    	if dist < 40.0 then
                    DrawMarker(1, v.pos.x, v.pos.y, v.pos.z, nil, nil, nil, 90, nil, nil, 2.9, 2.9, 0.5, 255, 220, 0, 140, true, false)
                    Draw3DTextH(v.pos.x, v.pos.y, v.pos.z - 0.5, "Sortie", 4, 0.1, 0.1, 4)
		    		if dist < 3.0 then
		    			ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour sortir de la zone AFK")
		    			if IsControlJustPressed(1, 38) then
		    				TriggerServerEvent("afk:LeaveAFKZone")
                            InAfkZone = false
                            SetEntityInvincible(PlayerPedId(), false)
	                        SetPlayerInvincible(PlayerPedId(), false)
		    			end
		    		end
		    	end
		    end

            for k, v in pairs(AFK["points"]["boutique"]) do
		    	local plyCoords = GetEntityCoords(PlayerPedId(), false)
		    	local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos.x, v.pos.y, v.pos.z)

		    	if dist < 40.0 then
                    DrawMarker(1, v.pos.x, v.pos.y, v.pos.z, nil, nil, nil, 90, nil, nil, 2.9, 2.9, 0.5, 255, 220, 0, 140, true, false)
                    Draw3DTextH(v.pos.x, v.pos.y, v.pos.z - 0.5, "Boutique", 4, 0.2, 0.2, 4)
		    		if dist < 3.0 then
		    			ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour ouvrir la boutique de la zone AFK")
		    			if IsControlJustPressed(1, 38) then
							if AFK['menuOpenned'] == false then
		    					AFK.openShop()
							end
		    			end
		    		end
		    	end
		    end

            SetPedMoveRateOverride(PlayerPedId(), 2.50)
        end

        if near then
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
	end
end)

TextPanels = {
    Background = {
        Width = 640,
        Height = 360
    }
}

function BiRenderVehiclesss(Dictionary, Texture)
    local screenW, screenH = GetActiveScreenResolution()

    local offsetX = 250
    local offsetY = -150

    local x = (screenW / 2) + offsetX
    local y = (screenH * (2 / 3)) + offsetY

    RenderSprite(Dictionary, Texture, x, y, TextPanels.Background.Width, TextPanels.Background.Height, 0, 255, 255, 255, 255)
end

AFK.openShop = function()
    local coords = GetEntityCoords(PlayerPedId())
    RMenu.Add('afk', 'main', RageUI.CreateMenu('Boutique AFK', 'Que voulez-vous faire ?', 1, 100))
    RMenu:Get('afk', 'main').Closed = function()
        AFK['menuOpenned'] = false
        
        RMenu:Delete('afk', 'main')
    end
    
    if AFK['menuOpenned'] then
        AFK['menuOpenned'] = false
        return
    else
        RageUI.CloseAll()

        AFK['menuOpenned'] = true
        RageUI.Visible(RMenu:Get('afk', 'main'), true)
    end

    for name, menu in pairs(RMenu['afk']) do
        RMenu:Get('afk', name):SetRectangleBanner(255, 220, 0, 140)
    end

    local mypoints = 0
    ESX.TriggerServerCallback('BOUTIQUE:getAFKPoints', function(points)
        if points then
            mypoints = points
        end
    end)

    Citizen.CreateThread(function()
        while AFK['menuOpenned'] do
            Wait(1)

            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 2.5 then
                RageUI.CloseAll()
                AFK['menuOpenned'] = false
            end

            RageUI.IsVisible(RMenu:Get('afk', 'main'), true, false, true, function()

				RageUI.Separator("Vous avez " ..mypoints.. " AFK Coins")

                for i = 1, #AFK.listVehicles, 1 do
                    RageUI.ButtonWithStyle(AFK.listVehicles[i].label, nil, {RightLabel = ESX.Math.GroupDigits(AFK.listVehicles[i].price).." AFK Coins"}, true, function(Hovered, Active, Selected)
                        if Active then
                            RageUI.RenderVehiclesss('afk', AFK.listVehicles[i].model)
                        end
                        if Selected then
                            RageUI.CloseAll()
                            AFK['menuOpenned'] = false
                            TriggerServerEvent("BOUTIQUE:BuyAFKVehicle", i)
                        end
                    end)
                end

                for i = 1, #AFK.listMoney, 1 do
                    RageUI.ButtonWithStyle(AFK.listMoney[i].label, nil, {RightLabel = ESX.Math.GroupDigits(AFK.listMoney[i].price).." AFK Coins"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            AFK['menuOpenned'] = false
                            TriggerServerEvent("BOUTIQUE:BuyAFKMoney", i)
                        end
                    end)
                end

                for i = 1, #AFK.listItem, 1 do
                    RageUI.ButtonWithStyle(AFK.listItem[i].label, nil, {RightLabel = ESX.Math.GroupDigits(AFK.listItem[i].price).." AFK Coins"}, true, function(Hovered, Active, Selected)
                        if Selected then
                            RageUI.CloseAll()
                            AFK['menuOpenned'] = false
                            TriggerServerEvent("BOUTIQUE:BuyAFKItem", i)
                        end
                    end)
                end
            end)
        end
    end)
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2500)
        if InAfkZone then
            local coordsJoueur = GetEntityCoords(PlayerPedId(), true)
            local distance = GetDistanceBetweenCoords(-1266.799, -3021.931, -48.4998, coordsJoueur, true)

            if distance > 50 then
                SetEntityCoords(PlayerPedId(), -1266.799, -3021.931, -48.4998)
            end
        end
    end
end)

function secondsToClock(seconds)
    local seconds = tonumber(seconds)

    if seconds <= 0 then
        return 0, 0
    else
        local hours = math.floor(seconds / 3600)
        local mins = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60

        return mins, secs
    end
end

function AFKTimer()
	local afkTimer = ESX.Math.Round(10*60*1000 / 1000)

	Citizen.CreateThread(function()
		while afkTimer > 0 do
			Citizen.Wait(1000)

			if afkTimer > 0 then
				afkTimer = afkTimer - 1
			end
		end
	end)

	Citizen.CreateThread(function()
		local text, timeHeld = "", 0

		while afkTimer > 0 and InAfkZone do
			Citizen.Wait(0)
			local mins, secs = secondsToClock(afkTimer)
            local text = "Réception de votre prochain gain dans ~y~" ..string.format("%02d:%02d", mins, secs)

			timeHeld = 0

			DrawGenericTextThisFrame()

			SetTextEntry("STRING")
			AddTextComponentString(text)
			DrawText(0.5, 0.92)
		end
			
		if afkTimer < 1 and InAfkZone then
			TriggerServerEvent("afk:addPoints")
            AFKTimer()
		end
	end)
end

function DrawGenericTextThisFrame()
	SetTextFont(4)
	SetTextScale(0.0, 0.8)
	SetTextColour(255, 255, 255, 255)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(true)
end

function Draw3DTextH(x,y,z,textInput,fontId,scaleX,scaleY,font)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextDropshadow(1, 1, 1, 1, 255)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(textInput)
    SetDrawOrigin(x,y,z+2, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

function getAFKStatus()
    return InAfkZone
end

exports("getAFKStatus", function ()
    return getAFKStatus()
end)

-- client.lua
local topPedActive = false
local topPedUntil = 0
local topPedEntities = {}
local topObjEntities = {}
local onDemandTitleThread = nil

local AFKZoneCenter = vector3(-1267.06, -3017.74, -49.49)
local displayPedModels = {`a_m_y_hipster_01`, `a_m_y_hipster_02`, `a_m_y_hipster_03`, `a_f_y_hipster_01`}
local objectModel = `prop_table_03b`
local Leaderboards = {
    ["afk"] = {
        title = "🎖️ TOP AFK",
        centerPosition = vector3(-1266.8599853516, -3002.0693359375, -49.489864349365), -- Coordonnées pour le classement des votes
        heading = 181.96,
        leaderboardType = "afk",
        pedOffsets = {  
            {x = 0.0, y = 0.0, z = 1.0}, -- Premier sur la table
            {x = -1.0, y = 1.0, z = 0.0}, -- Deuxième au sol
            {x = 1.0, y = 1.0, z = 0.0}, -- Troisième au sol
            {x = -1.5, y = 2.0, z = 0.0}, -- Quatrième au sol
            {x = 1.5, y = 2.0, z = 0.0} -- Cinquième au sol
        },
        distance = 100.0,
    }
}

function clearOnDemandPeds()
    for _, e in ipairs(topPedEntities) do
        if e and DoesEntityExist(e) then DeleteEntity(e) end
    end
    for _, o in ipairs(topObjEntities) do
        if o and DoesEntityExist(o) then DeleteEntity(o) end
    end
    topPedEntities = {}
    topObjEntities = {}
    topPedActive = false
    topPedUntil = 0
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        clearOnDemandPeds()
    end
end)

-- Fonction pour ajuster les positions selon le heading
function RotatePositionAroundCenter(center, position, heading)
    local angle = math.rad(heading)
    local cosTheta = math.cos(angle)
    local sinTheta = math.sin(angle)

    -- Calculer les nouveaux offsets en fonction du heading
    local dx = position.x - center.x
    local dy = position.y - center.y

    local rotatedX = center.x + (dx * cosTheta - dy * sinTheta)
    local rotatedY = center.y + (dx * sinTheta + dy * cosTheta)

    return vector3(rotatedX, rotatedY, position.z)
end

RegisterNetEvent("leaderboard:sendTopPlayersPedOnDemand")
AddEventHandler("leaderboard:sendTopPlayersPedOnDemand", function(leaderboardType, results)
    clearOnDemandPeds()
    local cfg = Leaderboards[leaderboardType]
    if not cfg or #(results or {}) == 0 then return end

    RequestModel(objectModel)
    while not HasModelLoaded(objectModel) do Citizen.Wait(0) end
    local pedModel = GetHashKey("mp_m_freemode_01")
    RequestModel(pedModel)
    while not HasModelLoaded(pedModel) do Citizen.Wait(0) end

    local center = cfg.centerPosition
    local posTitle = vector3(center.x, center.y, center.z + 3.5)
    local icons = { "🏆","🥈","🥉","4️⃣","5️⃣" }

    for i, r in ipairs(results) do
        local off = cfg.pedOffsets[i]; if not off then break end
        local base = vector3(center.x + off.x, center.y + off.y, center.z + off.z)
        local pedPos = RotatePositionAroundCenter(center, base, cfg.heading)
        local obj = nil
        if i == 1 then
            obj = CreateObject(objectModel, pedPos.x, pedPos.y, pedPos.z - 1.0, false, false, true)
            FreezeEntityPosition(obj, true)
            pedPos = vector3(pedPos.x, pedPos.y, pedPos.z - 0.15)
            table.insert(topObjEntities, obj)
        end
        local ped = CreatePed(4, pedModel, pedPos.x, pedPos.y, pedPos.z, cfg.heading, false, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        TaskStartScenarioInPlace(ped, "WORLD_HUMAN_HANG_OUT_STREET", 0, true)
        TriggerEvent("skinchanger:applySkinToPed", ped, r.skin, r.skin)
        table.insert(topPedEntities, ped)

        Citizen.CreateThread(function()
            while topPedActive and DoesEntityExist(ped) do
                local dist = #(GetEntityCoords(PlayerPedId()) - center)
                if dist > 150.0 then break end
                Citizen.Wait(0)
                local c = GetEntityCoords(ped)
                ESX.Game.Utils.DrawText3D(vector3(c.x, c.y, c.z + 1.0), (icons[i] or tostring(i)) .. " " .. (r.name or r.license or "Inconnu"), 1.0)
            end
        end)
    end

    if onDemandTitleThread then TerminateThread(onDemandTitleThread) end
    topPedActive = true
    onDemandTitleThread = Citizen.CreateThread(function()
        while topPedActive do
            local dist = #(GetEntityCoords(PlayerPedId()) - center)
            if dist > 150.0 then break end
            Citizen.Wait(0)
            ESX.Game.Utils.DrawText3D(posTitle, cfg.title, 2.0)
        end
    end)

    Citizen.CreateThread(function()
        while topPedActive do
            local dist = #(GetEntityCoords(PlayerPedId()) - center)
            if dist > 150.0 then break end
            Citizen.Wait(250)
        end
        clearOnDemandPeds()
        SetModelAsNoLongerNeeded(objectModel)
        SetModelAsNoLongerNeeded(pedModel)
    end)
end)