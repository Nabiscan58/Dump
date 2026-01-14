ESX = nil

local OnCataActive = false
local lastcarout = {}
local prevdata = {}
local cache = {}
local cacheShowRoom = {}
cache.value = nil
local cacheName = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
    TriggerServerEvent("pdm:getCache")
	RMenu.Add('menu', 'Catalogue', RageUI.CreateMenu("PRIME", "PDM Autos", 1, 100))

    RMenu.Add('menu', 'concess_choose', RageUI.CreateSubMenu(RMenu:Get('menu', 'Catalogue'), "PRIME", "PDM Autos", 1, 100))
    RMenu.Add('menu', 'concess_choosecitoyen', RageUI.CreateSubMenu(RMenu:Get('menu', 'Catalogue'), "PRIME", "PDM Autos", 1, 100))
    RMenu:Get('menu', 'Catalogue'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'concess_choose'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'concess_choosecitoyen'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'Catalogue').EnableMouse = false
    RMenu:Get('menu', 'Catalogue').Closed = function()
        suppautoPDM()
    end
    RMenu:Get('menu', 'Catalogue').Closed = function()
		OnCataActive = false
    end

    RMenu:Get('menu', 'Catalogue').Closed = function()
		OnCataActive = false
    end

    for k,v in pairs(cfg_cataloguePDM.vehicles) do
        RMenu.Add('menu', v.value, RageUI.CreateSubMenu(RMenu:Get('menu', 'Catalogue'), "PRIME", "PDM Autos", 1, 100))
        RMenu:Get('menu', v.value):SetRectangleBanner(255, 220, 0, 140)
        RMenu:Get('menu', v.value):SetSubtitle(v.cat_name)
        RMenu:Get('menu', v.value).Closed = function()
            suppautoPDM()
        end
    end
end)

local alone = false

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
    Wait(10000)
    TriggerServerEvent("pdm:AddPlayer")
end)

RegisterNetEvent('esx:affiliateJob')
AddEventHandler('esx:affiliateJob', function(job)
	ESX.PlayerData.job = job

    if ESX.PlayerData.job.name == "pdm" or ESX.PlayerData.job.name == "beachnsky" then
        TriggerServerEvent("pdm:AddPlayer")
    end
end)

showCarPDM = function(car)
    Citizen.CreateThread(function()
        local car = GetHashKey(car)

        suppautoPDM()
    
        ESX.Game.SpawnLocalVehicle(car, {x = -37.035842895508, y = -1093.7409667969, z = 27.302309036255}, 160.46423339844, function(vehicle)
            table.insert(lastcarout, vehicle)
            FreezeEntityPosition(vehicle, true)
            SetVehicleUndriveable(vehicle, true)
            SetVehicleDoorsLocked(vehicle, 2)
            SetModelAsNoLongerNeeded(car)
        end)
    end)
end

function openCatalogueMenuPDM()
    local modelname = nil
    if OnCataActive then
        RageUI.CloseAll()
        OnCataActive = false
        return
    else
        OnCataActive = true
        RageUI.Visible(RMenu:Get('menu', 'Catalogue'), true)
 
        Citizen.CreateThread(function()
            while OnCataActive do
                RageUI.IsVisible(RMenu:Get('menu', 'Catalogue'), true, true, true, function()
                    RageUI.Separator("Catégories")
                    for k,v in pairs(cfg_cataloguePDM.vehicles) do
                        RageUI.ButtonWithStyle(v.cat_name, nil, {}, true, function(Hovered, Active, Selected)
                        end, RMenu:Get('menu', v.value))
                    end
                end, function()
                end)

                for k,v in pairs(cfg_cataloguePDM.vehicles) do
                    RageUI.IsVisible(RMenu:Get('menu', v.value), true, true, true, function()
                        RageUI.Separator("Véhicules")
                        for y,la in pairs(v.vehicles) do
                            RageUI.ButtonWithStyle(firstToUpper(la.name), nil, {RightLabel = ESX.Math.GroupDigits(la.price, 2).."$"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if prevdata[y] ~= y then
                                        prevdata[y-1] = nil
                                        prevdata[y+1] = nil

                                        showCarPDM(la.hash)

                                        prevdata[y] = y
                                    end
                                end
                                if ESX.PlayerData.job.name == 'pdm' then
                                    if Selected then
                                        cache.value = la.hash
                                        suppautoPDM()
                                        ESX.ShowNotification("~y~Vous avez sélectionné: " ..la.hash)
                                    end
                                end
                            end, RMenu:Get('menu', 'concess_choose'))
                        end
        
                    end, function()
                    end)
                end
                    RageUI.IsVisible(RMenu:Get('menu', 'concess_choose'), true, true, true, function()
                        local player, distance = ESX.Game.GetClosestPlayer()
                        
                        RageUI.Separator("Nom du véhicule: " ..cache.value)
                        RageUI.ButtonWithStyle('Sortir le véhicule pour test drive', nil, {}, true, function(Hovered, Active, Selected) 
                            if Selected then
                                ESX.Game.SpawnVehicle(cache.value, vector3(-20.430366516113, -1085.1015625, 27.04185295105), 69.79, function(vehicle)
                                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                                    SetVehicleNumberPlateText(vehicle, "TESTD")
                                    RageUI.CloseAll()
                                    OnCataActive = false
                                end)
                            end
                        end)
                        RageUI.ButtonWithStyle('Sortir le véhicule pour exposition', nil, {}, true, function(Hovered, Active, Selected) 
                            if Selected then
                                ESX.Game.SpawnVehicle(cachePA.value, vector3(-37.786502838135, -1098.2153320312, 27.2744140625), 62.78, function(vehicle)
                                    SetVehicleNumberPlateText(vehicle, "PDM")
                                    RageUI.CloseAll()
                                    OnCataActivePA = false
                                end)
                            end
                        end)
                        RageUI.ButtonWithStyle('Vendre le véhicule', nil, {}, true, function(Hovered, Active, Selected)
                            if Active then
                                MarquerJoueur()
                            end
                            if Selected then
                                if player ~= -1 and distance <= 3.0 then
                                    if cache.value ~= nil then
                                        local model = GetHashKey(cache.value)
                                        RequestModel(model)
                                        
                                        local attempts = 0
                                        while not HasModelLoaded(model) and attempts < 10 do
                                            Wait(500)
                                            attempts = attempts + 1
                                        end
                    
                                        if HasModelLoaded(model) then
                                            local newPlate = GeneratePlate()
                                            local vehicleProps = {
                                                model = model,
                                                position = vector3(-14.61, -1085.16, 27.04),
                                                heading = 69.31,
                                                plate = newPlate
                                            }
                    
                                            local vehicle = CreateVehicle(model, vehicleProps.position.x, vehicleProps.position.y, vehicleProps.position.z, vehicleProps.heading, true, false)
                    
                                            if vehicle then
                                                SetVehicleNumberPlateText(vehicle, vehicleProps.plate)
                                                local actualProps = ESX.Game.GetVehicleProperties(vehicle)
                                                actualProps.plate = vehicleProps.plate
                    
                                                TriggerServerEvent('concess:giveAutotoId', GetPlayerServerId(player), actualProps, GetDisplayNameFromVehicleModel(actualProps.model), true)
                    
                                                RageUI.CloseAll()
                                                OnCataActive = false
                                                suppautoPDM()
                                            else
                                                ESX.ShowNotification("~r~Erreur : Impossible de générer le véhicule.")
                                            end
                                        else
                                            ESX.ShowNotification("~r~Erreur : Le modèle du véhicule n'a pas pu être chargé.")
                                        end
                                    else
                                        ESX.ShowNotification("~r~Aucun véhicule sélectionné.")
                                    end
                                end
                            end
                        end)
                        RageUI.Separator("Emplacement")
                        for i = 1, 5 do
                            if i ~= 1 then
                                RageUI.ButtonWithStyle("Emplacement #"..i, nil, {RightLabel = "Libre"}, true, function(Hovered, Active, Selected)
                                    if Selected then
                                        TriggerServerEvent("pdm:spawnVehPresentoire", i, cache.value)
                                    end
                                end)
                            end
                        end
                    end, function()
                    end)
                Wait(0)
            end
        end, function()
        end, 1)
    end
end

function openCataGensPDM()
    local modelname = nil
    if OnCataActive then
        RageUI.Visible(RMenu:Get('menu', 'Catalogue'), false)
        OnCataActive = false
        return
    else
        OnCataActive = true
        RageUI.Visible(RMenu:Get('menu', 'Catalogue'), true)

        Citizen.CreateThread(function()
            while OnCataActive do
                RageUI.IsVisible(RMenu:Get('menu', 'Catalogue'), true, true, true, function()
                    RageUI.Separator("~p~-25% pour les VIP Diamond")
                    RageUI.Separator("~y~-10% pour les VIP Gold")
                    RageUI.Line()
                    for k, v in pairs(cfg_cataloguePDM.vehicles) do
                        RageUI.ButtonWithStyle(v.cat_name, nil, {}, true, function(Hovered, Active, Selected)
                        end, RMenu:Get('menu', v.value))
                    end
                end, function()
                end)

                for k, v in pairs(cfg_cataloguePDM.vehicles) do
                    RageUI.IsVisible(RMenu:Get('menu', v.value), true, true, true, function()

                        RageUI.Separator("Véhicules")
                        for y, la in pairs(v.vehicles) do
                            RageUI.ButtonWithStyle(firstToUpper(la.name), nil, {RightLabel = ESX.Math.GroupDigits(la.price, 2) .. "$"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if prevdata[y] ~= y then
                                        prevdata[y-1] = nil
                                        prevdata[y+1] = nil
                                        showCarPDM(la.hash)
                                        prevdata[y] = y
                                    end
                                    if Selected then
                                        cache.value = la.hash
                                        suppautoPDM()
                                        ESX.ShowNotification("~y~Vous avez sélectionné: " ..la.hash)
                                    end
                                end
                            end, RMenu:Get('menu', 'concess_choosecitoyen'))
                        end

                    end, function()
                    end)
                end

                RageUI.IsVisible(RMenu:Get('menu', 'concess_choosecitoyen'), true, true, true, function()
                    RageUI.Separator("Nom du véhicule: " ..cache.value)

                    local searchedModel = cache.value
                    
                    RageUI.ButtonWithStyle('Acheter le véhicule', nil, {}, true, function(Hovered, Active, Selected)
                        if Selected then
                            ESX.TriggerServerCallback('concess:ifHasMoney', function(hasMoney)
                                if not hasMoney then
                                    ESX.ShowNotification("~r~Vous n'avez pas assez d'argent !")
                                    return
                                else
                                    ESX.TriggerServerCallback('pdm:getIfCompanyOpen', function(playerFound)
                                        if playerFound then
                                            ESX.ShowNotification("~r~Vous ne pouvez pas acheter ce véhicule puisqu'un employé de la concession est en service !")
                                        else
                                            if cache.value ~= nil then
                                                local model = GetHashKey(cache.value)
                                                RequestModel(model)
                                                
                                                local attempts = 0
                                                while not HasModelLoaded(model) and attempts < 10 do
                                                    Wait(500)
                                                    attempts = attempts + 1
                                                end
                            
                                                if HasModelLoaded(model) then
                                                    local newPlate = GeneratePlate()
                                                    local vehicleProps = {
                                                        model = model,
                                                        position = vector3(-14.61, -1085.16, 27.04),
                                                        heading = 69.31,
                                                        plate = newPlate
                                                    }
                            
                                                    local vehicle = CreateVehicle(model, vehicleProps.position.x, vehicleProps.position.y, vehicleProps.position.z, vehicleProps.heading, true, false)
                            
                                                    if vehicle then
                                                        SetVehicleNumberPlateText(vehicle, vehicleProps.plate)
                                                        local actualProps = ESX.Game.GetVehicleProperties(vehicle)
                                                        actualProps.plate = vehicleProps.plate
                                                        TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                            
                                                        TriggerServerEvent('concess:giveAutotoId', GetPlayerServerId(PlayerId()), actualProps, GetDisplayNameFromVehicleModel(actualProps.model), false)
                            
                                                        RageUI.CloseAll()
                                                        OnCataActive = false
                                                        suppautoPDM()
                                                    else
                                                        ESX.ShowNotification("~r~Erreur : Impossible de générer le véhicule.")
                                                    end
                                                else
                                                    ESX.ShowNotification("~r~Erreur : Le modèle du véhicule n'a pas pu être chargé.")
                                                end
                                            else
                                                ESX.ShowNotification("~r~Aucun véhicule sélectionné.")
                                            end
                                        end
                                    end, "pdm")
                                end
                            end, cache.value)
                        end
                    end)

                end, function()
                end)

                Wait(0)
            end
        end, function()
        end, 1)
    end
end

Citizen.CreateThread(function()
	RMenu.Add('menu', 'main', RageUI.CreateMenu("PRIME", "Menu PDM", 1, 100))
	RMenu:Get('menu', 'main'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'main').EnableMouse = false
    RMenu:Get('menu', 'main').Closed = function()
		OnCataActive = false
    end
end)

function suppautoPDM()
    for k,v in pairs(lastcarout) do
		ESX.Game.DeleteVehicle(v)
		lastcarout[k] = nil
    end
end

local cataloguePDM = {
	{x = -31.168567657471, y = -1097.8732910156, z = 26.374394989014, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(cataloguePDM) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, cataloguePDM[k].x, cataloguePDM[k].y, cataloguePDM[k].z)

			if dist <= 3.0 then
				nearThing = true

                if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == 'pdm') then
                    ESX.ShowHelpNotification("Appuyez sur ~y~[E]~w~ pour ouvrir le menu de la concession")
                    DrawMarker(6, cataloguePDM[k].x, cataloguePDM[k].y, cataloguePDM[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
				    if IsControlJustPressed(1,38) then
                        local playerInService = exports["cJobs"]:inService()
                        if not playerInService then
                            ESX.ShowNotification("~r~Vous devez d'abord être en service !")
                        else
				    	    openCatalogueMenuPDM()
                        end
				    end
                end
			end
		end
		if nearThing then
            Citizen.Wait(0)
        else
            Citizen.Wait(500)
        end
	end
end)

local catagensPDM = {
	{x = -40.855026245117, y = -1094.7587890625, z = 26.374415969849, }
}

Citizen.CreateThread(function()
	while true do
		local nearThing = false

		for k in pairs(catagensPDM) do

			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, catagensPDM[k].x, catagensPDM[k].y, catagensPDM[k].z)

			if dist < 10.0 then
				nearThing = true
                DrawMarker(6, catagensPDM[k].x, catagensPDM[k].y, catagensPDM[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
				if dist < 3.0 then
                    ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour accéder au ~y~catalogue")
					if IsControlJustPressed(1, 38) then
                        if OnCataActive == false then
                            openCataGensPDM()
                        end
					end
				end
			end
		end
		if nearThing == true then
			Citizen.Wait(0)
		else
			Citizen.Wait(1000)
		end
	end
end)

local Config = {
    zoneCheckIntervalMs = 250,

    Showrooms = {
        {
            id   = "pdm_center",
            job  = "pdm",
            center = vector3(-56.5, -1096.4, 26.4),
            radius = 70.0,
            slots = {
                [1] = { coords = vector3(-42.288311004639, -1101.2624511719, 27.30228805542), heading = 180.0, rotSpeed = 12.0 },
                [2] = { coords = vector3(-54.594169616699, -1097.0043945312, 27.302289962769), heading = 180.0, rotSpeed = 8.0  },
                [3] = { coords = vector3(-47.757743835449, -1091.8947753906, 27.302299499512), heading = 180.0, rotSpeed = 8.0  },
                [4] = { coords = vector3(-49.913272857666, -1083.8636474609, 27.302289962769), heading = 180.0, rotSpeed = 8.0  },
            }
        },
        {
            id   = "paleto_show",
            job  = "paletoauto",
            center = vector3(-15.3, 6483.7, 31.4),
            radius = 60.0,
            slots = {
                [1] = { coords = vector3(-20.0, 6486.0, 31.2), heading = 135.0, rotSpeed = 9.0 },
                [2] = { coords = vector3(-11.8, 6489.2, 31.2), heading = 315.0, rotSpeed = 11.0 },
            }
        }
    }
}

local state = {
    modelByJob = {
        pdm = {},
        paletoauto = {}
    },
    active = {},
    inside = {}
}

local function ensureModel(modelName)
    local hash = (type(modelName) == 'number') and modelName or joaat(modelName)
    if not IsModelInCdimage(hash) or not IsModelAVehicle(hash) then return nil end
    RequestModel(hash)
    local t = GetGameTimer()
    while not HasModelLoaded(hash) do
        Wait(10)
        if GetGameTimer() - t > 5000 then break end
    end
    if not HasModelLoaded(hash) then return nil end
    return hash
end

local function safeDelete(entity)
    if not entity or entity == 0 then return end
    if DoesEntityExist(entity) then
        SetEntityAsMissionEntity(entity, true, true)
        DeleteEntity(entity)
    end
end

local function spawnLocalVehicle(hash, pos, heading)
    local veh = CreateVehicle(hash, pos.x, pos.y, pos.z, heading or 0.0, false, false) -- local only
    if veh == 0 then return 0 end

    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleOnGroundProperly(veh)
    SetVehicleEngineOn(veh, false, true, false)
    SetVehicleDirtLevel(veh, 0.0)
    SetVehicleDoorsLocked(veh, 2)
    SetVehicleUndriveable(veh, true)
    SetEntityInvincible(veh, true)
    SetVehicleCanBreak(veh, false)
    SetEntityCollision(veh, true, true)
    FreezeEntityPosition(veh, true) -- on freeze la position; on ne freeze pas la rotation yaw (heading)

    -- esthétique
    SetVehicleLights(veh, 2) -- phares on
    SetVehicleColours(veh, 0, 0)
    SetVehicleExtraColours(veh, 0, 0)
    SetVehicleNumberPlateText(veh, "SHOWROOM")

    return veh
end

local function getShowroomById(id)
    for _, s in ipairs(Config.Showrooms) do
        if s.id == id then return s end
    end
    return nil
end

local function startRotationLoop(showroomId)
    if state.active[showroomId] and state.active[showroomId]._rotLoop then return end

    state.active[showroomId] = state.active[showroomId] or {}
    local loop = true
    state.active[showroomId]._rotLoop = true

    Citizen.CreateThread(function()
        local last = GetGameTimer()
        while loop do
            Wait(10)
            if not state.inside[showroomId] then
                if not next(state.active[showroomId]) or (next(state.active[showroomId]) == "_rotLoop" and select(2, next(state.active[showroomId])) == true and not next(state.active[showroomId], "_rotLoop")) then
                    break
                end
            end

            local now = GetGameTimer()
            local dt = (now - last) / 1000.0
            last = now

            for slot, data in pairs(state.active[showroomId]) do
                if slot ~= "_rotLoop" and data.ent and DoesEntityExist(data.ent) then
                    data.heading = (data.heading + (data.speed or 10.0) * dt) % 360.0
                    SetEntityHeading(data.ent, data.heading)
                end
            end
        end
        state.active[showroomId]._rotLoop = nil
    end)
end

local function spawnShowroomVehicles(showroom)
    local id  = showroom.id
    local job = showroom.job
    state.active[id] = state.active[id] or {}

    for slot, def in pairs(showroom.slots) do
        local model = state.modelByJob[job][slot]
        if model and def.coords then
            local current = state.active[id][slot]
            if current and current.model == model and DoesEntityExist(current.ent) then
                goto continue
            end

            if current and current.ent then
                safeDelete(current.ent)
                state.active[id][slot] = nil
            end

            local mh = ensureModel(model)
            if mh then
                local ent = spawnLocalVehicle(mh, def.coords, def.heading or 0.0)
                SetModelAsNoLongerNeeded(mh)
                if ent ~= 0 then
                state.active[id][slot] = {
                    ent    = ent,
                    model  = model,
                    heading= def.heading or 0.0,
                    speed  = def.rotSpeed or 10.0
                }
                end
            end
        else
            if state.active[id][slot] and state.active[id][slot].ent then
                safeDelete(state.active[id][slot].ent)
                state.active[id][slot] = nil
            end
        end
        ::continue::
    end

    startRotationLoop(id)
end

local function clearShowroomVehicles(showroomId)
    local t = state.active[showroomId]
    if not t then return end
    for slot, data in pairs(t) do
        if slot ~= "_rotLoop" and data.ent then
            safeDelete(data.ent)
        end
    end
    state.active[showroomId] = {}
end

local function isInsideShowroom(pos, showroom)
    return #(pos - showroom.center) <= showroom.radius
end

Citizen.CreateThread(function()
    TriggerServerEvent("pdm:getCache")

    while true do
        Wait(Config.zoneCheckIntervalMs)
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        for _, s in ipairs(Config.Showrooms) do
            local inside = isInsideShowroom(pos, s)

            if inside and not state.inside[s.id] then
                state.inside[s.id] = true
                spawnShowroomVehicles(s)
            elseif (not inside) and state.inside[s.id] then
                state.inside[s.id] = false
                clearShowroomVehicles(s.id)
            end
        end
    end
end)

RegisterNetEvent("getCache", function(map)
    state.modelByJob.pdm = map or {}
    for _, s in ipairs(Config.Showrooms) do
        if s.job == "pdm" and state.inside[s.id] then
            spawnShowroomVehicles(s)
        end
    end
end)

RegisterNetEvent("spawnVehPresentoire", function(index, model)
    state.modelByJob.pdm[index] = model
    for _, s in ipairs(Config.Showrooms) do
        if s.job == "pdm" and state.inside[s.id] then
            spawnShowroomVehicles(s)
        end
    end
end)

RegisterNetEvent("spawnVehPresentoirepaletoauto", function(index, model)
    state.modelByJob.paletoauto[index] = model
    for _, s in ipairs(Config.Showrooms) do
        if s.job == "paletoauto" and state.inside[s.id] then
            spawnShowroomVehicles(s)
        end
    end
end)

RegisterNetEvent("deleteveh", function(index, model)
    if state.modelByJob.pdm[index] == model then state.modelByJob.pdm[index] = nil end
    if state.modelByJob.paletoauto[index] == model then state.modelByJob.paletoauto[index] = nil end

    for _, s in ipairs(Config.Showrooms) do
        if state.inside[s.id] then
            local act = state.active[s.id]
            if act and act[index] and act[index].model == model then
                safeDelete(act[index].ent)
                act[index] = nil
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    for id,_ in pairs(state.active) do
        clearShowroomVehicles(id)
    end
end)