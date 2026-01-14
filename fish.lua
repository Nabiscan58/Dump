PECHE = {}
PECHE.Canne = nil
PECHE.InPeche = false
PECHE.Appat = false
PECHE.Auto = false
PECHE.Index = 1
PECHE.Blips = {}
PECHE.MyData = {}
PECHE.Interval = false
PECHE.CanRestart = true
local hasDiamond = false

Player = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

function PECHE.Leave()
    ESX.ShowNotification("Vous venez de vous arrêté.")
    DeleteEntity(PECHE.Canne)
    DeleteObject(PECHE.Canne)
    ClearPedTasks(PlayerPedId())
    FreezeEntityPosition(PlayerPedId(), false)
    PECHE.InPeche = false
    PECHE.Appat = false
    PECHE.Auto = false
    PECHE.Index = 1
    PECHE.Blips = {}
    PECHE.MyData = {}
    RealWait(1000)
    PECHE.CanRestart  = true
end

function PECHE.DrawUI(data, playerFishingLevel)
    local x, y = UI.ConvertToPixel(297.5, 288.84)
    UI.DrawSpriteNew("peche", 'background_peche', 0.83802086114883, 0.38333332538605, x, y, 0, 255, 255, 255, 255, {
        devmod = false,
    }
    , function ()
        
    end)
    DisableControlAction(0, 22, true)

    DisableControlAction(0, 45, true)
    UI.DrawTexts(0.83697921037674, 0.35740739107132, "Pêche en cours...", false, 0.5, {255, 255, 255, 255}, 0, false, false, true)
    UI.DrawTexts(0.84427088499069, 0.41203701496124, data.label, false, 0.33, {255, 255, 255, 255}, 0, false, false, false)
    if playerFishingLevel then 
        UI.DrawTexts(0.84427088499069, 0.44629627466202, "Niveau: "..playerFishingLevel.."/"..ConfigFishing.NiveauMax, false, 0.33, {255, 255, 255, 255}, 0, false, false, false)
    end
    UI.DrawTexts(0.84427088499069, 0.48055553436279, "Santé de la canne : 100%", false, 0.33, {255, 255, 255, 255}, 0, false, false, false)
    UI.DrawTexts(0.84427088499069, 0.51574075222015, "% de chance : "..data.luck.."%", false, 0.33, {255, 255, 255, 255}, 0, false, false, false)
    if not PECHE.Appat then
        UI.DrawTexts(0.84427088499069, 0.55370366573334, "Appât : ~r~Désactivé", false, 0.33, {255, 255, 255, 255}, 0, false, false, false)
    else
        UI.DrawTexts(0.84427088499069, 0.55370366573334, "Appât : ~y~Activé", false, 0.33, {255, 255, 255, 255}, 0, false, false, false)
    end
    if not PECHE.Auto then
        UI.DrawTexts(0.84427088499069, 0.5888888835907, "Mode auto (VIP): ~r~Désactivé", false, 0.33, {255, 255, 255, 255}, 0, false, false, false)
    else
        UI.DrawTexts(0.84427088499069, 0.5888888835907, "Mode auto (VIP): ~y~Activé~s~", false, 0.33, {255, 255, 255, 255}, 0, false, false, false)
    end

end

function PECHE.AttachCanneToPed(prop, bone_ID)
	local BoneID = GetPedBoneIndex(PlayerPedId(), bone_ID)

	PECHE.Canne = CreateMyObject(prop,  GetEntityCoords(PlayerPedId()))
	AttachEntityToEntity(PECHE.Canne, PlayerPedId(),  BoneID, 0, 0, 0, 0, 0, 0,  false, false, false, false, 2, true)
end

function PECHE.StartFishing(playerFishingLevel)
    ESX.PlayerData = ESX.GetPlayerData()
    local ranks = ESX.PlayerData.rank

    for _, rankInfo in ipairs(ranks) do
        if rankInfo.name == "essential" or rankInfo.name == "diamond" or rankInfo.name == "prime" then
            hasDiamond = true
            break
        end
    end

    if not PECHE.CanRestart then return end

    if not PECHE.InPeche then
        PECHE.InPeche = true
        PECHE.CanRestart = false
        local fishingActive = true
        local data = ConfigFishing.Zone[PECHE.Index]
        LoadAnimationDict('amb@world_human_stand_fishing@idle_a')
        PECHE.AttachCanneToPed('prop_fishing_rod_01', 60309)
        TaskPlayAnim(PlayerPedId(), 'amb@world_human_stand_fishing@idle_a', 'idle_b', 8.0, 8.0, -1, 1, 1, 0, 0, 0)
        FreezeEntityPosition(PlayerPedId(), true)

        local fishActive = false

        CreateThread(function()
            while fishingActive do
                local message = "~INPUT_CONTEXT~ Activer/Désactiver les appâts\n"
                if hasDiamond then
                    message = message .. "~INPUT_RELOAD~ Mode Auto (VIP)\n"
                end
                message = message .. "~INPUT_VEH_DUCK~ Arrêter la pêche"
                if fishActive then
                    message = message .. "\n~INPUT_INTERACTION_MENU~ Attraper le poisson"
                end

                ESX.ShowHelpNotification(message, true, true, -1)
                Wait(50)
            end
        end)

        CreateThread(function()
            while fishingActive do
                PECHE.DrawUI(data, playerFishingLevel)
                Wait(0)
            end
        end)

        CreateThread(function()
            while fishingActive do
                if IsControlJustPressed(1, 51) then
                    if PECHE.Appat then
                        PECHE.Appat = false
                        ESX.ShowNotification("Vous venez de désactiver les appâts.")
                    else
                        PECHE.Appat = true
                        ESX.ShowNotification("Vous venez d'activer les appâts.")
                    end
                end

                if IsControlJustPressed(1, 73) then
                    PECHE.Leave()
                    PECHE.InPeche = false
                    fishingActive = false
                    ClearHelp(true)
                    return
                end

                if hasDiamond and IsControlJustPressed(1, 80) then
                    if PECHE.Auto then
                        PECHE.Auto = false
                        ESX.ShowNotification("Vous venez de désactiver le mode auto.")
                    else
                        PECHE.Auto = true
                        ESX.ShowNotification("Vous venez d'activer le mode auto.")
                    end
                end

                Wait(0)
            end
        end)

        CreateThread(function()
            while fishingActive do
                if not fishActive then
                    Wait(25000)
                    if not fishingActive then return end
                    fishActive = true

                    local fish = data.fish
                    local tables = {}
                    for key, value in pairs(fish) do
                        for i = 1, value.rarity do
                            table.insert(tables, key)
                        end
                    end
                    local randomFish = math.random(1, #tables)
                    local dataFish = data.fish[tables[randomFish]]

                    CreateThread(function()
                        Wait(10000)
                        if fishingActive and fishActive then
                            ESX.ShowNotification("Le poisson s'est échappé !")
                            fishActive = false
                        end
                    end)

                    CreateThread(function()
                        while fishingActive and fishActive and PECHE.InPeche do
                            if PECHE.Auto then
                                fishActive = false
                                local random = math.random(10, 100)
                                if random > 10 then
                                    TriggerServerEvent("SoCore:server:pecheAdd", PECHE.Index, nil, PECHE.Appat)
                                else
                                    ESX.ShowNotification("Le poisson s'est échappé")
                                end
                                PlaySoundFrontend(GetSoundId(), "PICKUP_WEAPON_SMOKEGRENADE", "HUD_FRONTEND_WEAPONS_PICKUPS_SOUNDSET", 1)
                                break
                            end
                            Wait(0)
                        end
                    end)

                    CreateThread(function()
                        while fishingActive and fishActive and PECHE.InPeche do
                            if not PECHE.Auto and IsControlJustPressed(1, 244) then
                                fishActive = false
                                local random = math.random(10, 100)
                                if random > 10 then
                                    ESX.ShowNotification("Vous avez attrapé : " .. dataFish.label)
                                    TriggerServerEvent("SoCore:server:pecheAdd", PECHE.Index, nil, PECHE.Appat)
                                else
                                    ESX.ShowNotification("Le poisson s'est échappé : " .. dataFish.label)
                                end
                                PlaySoundFrontend(GetSoundId(), "PICKUP_WEAPON_SMOKEGRENADE", "HUD_FRONTEND_WEAPONS_PICKUPS_SOUNDSET", 1)
                                break
                            end
                            Wait(0)
                        end
                    end)
                else
                    Wait(1000)
                end
            end
        end)

        CreateThread(function()
            while fishingActive do
                if #(GetEntityCoords(PlayerPedId()) - data.pos) >= data.radius then
                    ESX.ShowNotification("Vous avez quitté la zone de pêche.")
                    PECHE.Leave()
                    PECHE.InPeche = false
                    fishingActive = false
                    ClearHelp(true)
                    return
                end
                Wait(1000)
            end
        end)
    end
end

RegisterNetEvent("socore:peche:client:senddata", function (data)
    PECHE.MyData = data
end)

RegisterNetEvent("socore:client:start:peche", function (data, playerFishingLevel)
    if not PECHE.CanRestart then 
        return 
    end

    TriggerServerEvent("socore:server:startfishing")
    if data ~= nil then 
        PECHE.MyData = data
    end

    local inZone = false

    for key, value in pairs(ConfigFishing.Zone) do
        if #(GetEntityCoords(PlayerPedId()) - value.pos) <= value.radius then 
            inZone = true
            PECHE.Index = key
        end
    end

    if inZone then
        if playerFishingLevel >= ConfigFishing.Zone[PECHE.Index].levelMin then 
            PECHE.StartFishing(playerFishingLevel)
        else
            ESX.ShowNotification("Vous n'avez pas le niveau requis : \nvotre niveau ~y~"..playerFishingLevel.." ~s~\nniveau requis ~b~"..ConfigFishing.Zone[PECHE.Index].levelMin)
        end
    else
        ESX.ShowNotification("Vous ne pouvez pas pêcher ici")
    end
end)

CreateThread(function()
    Wait(5000)

    for key, value in pairs(ConfigFishing.Zone) do
        local blip = AddBlip("Zone de pêche", value.pos.xyz, 68, 0.70, 3)
        table.insert(PECHE.Blips, blip)
    end

    local sellBlip = AddBlip("Vente pêche", ConfigFishing.Sell.pos.xyz, 68, 0.70, 3)
    table.insert(PECHE.Blips, sellBlip)

    while true do
        local waitTime = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sellCoords = ConfigFishing.Sell.pos.xyz

        local distance = #(playerCoords - sellCoords)
        if distance <= 3.0 then
            waitTime = 0
            ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour vendre vos poissons.")
            if IsControlJustPressed(1, 51) then
                TriggerServerEvent("peche:sell:server")
            end
        end

        Wait(waitTime)
    end
end)

function AddBlip(name, pos, sprite, scale, color)
    local blip = AddBlipForCoord(pos)

    SetBlipSprite(blip, sprite)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(name)
    EndTextCommandSetBlipName(blip)
    return blip
end

function CreateMyObject(modelName, position)
    local model = LoadModel(modelName)
    if model ~= false then
        local object = CreateObject(model, position.x, position.y, position.z, true, true, false)
        SetEntityAsMissionEntity(object, true, true)
        return object
    else
        return false
    end
end

function LoadModel(modelName)
    local model = GetHashKey(modelName)
    if IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end
        return model
    else
        print("ERROR: Model " .. modelName .. " not found")
        return false
    end
end

function LoadAnimationDict(dict)
	while not HasAnimDictLoaded(dict) do
		print("Loading animation dict: " .. dict)
		RequestAnimDict(dict)
		Wait(1)
	end
end

function RealWait(ms, cb)
    local timer = GetGameTimer() + ms
	local timeLeft = GetGameTimer() - timer
    while GetGameTimer() < timer do
		timeLeft = GetGameTimer() - timer
        if cb ~= nil then
            cb(function(stop, setValue)
                if stop then
                    timer = 0
                    return
                end

				if setValue ~= nil then
					timer = GetGameTimer() + setValue
				end
            end, timeLeft)
        end
        Wait(0)
    end
end