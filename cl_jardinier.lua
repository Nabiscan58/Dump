ESX = nil
local servicetaken = false
local InAction = false
local actionIndex = 1
local actionBlip = nil
local goodcar = false
local jardinerie = false

--local ESX, servicetaken, InAction = nil, false, false

Items = {
    "WORLD_HUMAN_GARDENER_PLANT",
    "WORLD_HUMAN_GARDENER_LEAF_BLOWER",
    "WORLD_HUMAN_BUM_WASH"
}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	
    RMenu.Add('menu', 'jardinier', RageUI.CreateMenu("PRIME", "Jardinerie", 1, 100))
    RMenu:Get('menu', 'jardinier'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('menu', 'jardinier').EnableMouse = false
    RMenu:Get('menu', 'jardinier').Closed = function()
		jardinerie = false
    end
end)

function openJardinerieMenu()
    if jardinerie then
        jardinerie = false
        return
    else
        jardinerie = true
        RageUI.Visible(RMenu:Get('menu', 'jardinier'), true)

        Citizen.CreateThread(function()
            while jardinerie do
                RageUI.IsVisible(RMenu:Get('menu', 'jardinier'), true, true, true, function()     
                    RageUI.ButtonWithStyle("Prendre son service", "", { RightLabel = "→" },true, function(Hovered, Active, Selected)
                        if (Selected) then
                            servicetaken = true
                            StartService()
                            RageUI.CloseAll()
                            jardinerie = false
                        end
                    end)
                    RageUI.ButtonWithStyle("Prendre sa fin de service", "", { RightLabel = "→" },true, function(Hovered, Active, Selected)
                        if (Selected) then
                            servicetaken = false
                            End()
                            RemoveBlip(actionBlip)
                            RageUI.CloseAll()
                            jardinerie = false
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

local jardineriePlace = {
	{x = -1680.2 , y = 494.7, z = 127.87, }
}

Citizen.CreateThread(function()
    while true do
        local nearThing = false

		for k in pairs(jardineriePlace) do
			local plyCoords = GetEntityCoords(PlayerPedId(), false)
			local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, jardineriePlace[k].x, jardineriePlace[k].y, jardineriePlace[k].z)

            if dist <= 2.0 then
                nearThing = true
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour parler avec le chef jardinier.")
                DrawMarker(6, jardineriePlace[k].x, jardineriePlace[k].y, jardineriePlace[k].z, nil, nil, nil, -90, nil, nil, 0.6, 0.6, 0.6, 255, 220, 0, 140)
				if IsControlJustPressed(1,51) then
                    if jardinerie == false then
					    openJardinerieMenu()
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

function StartService()
    if servicetaken == true then
        TriggerEvent('skinchanger:getSkin', function(skin)
            local model = GetEntityModel(PlayerPedId())
            if model == GetHashKey("mp_m_freemode_01") then
                clothesSkin = {
                    ['bags_1'] = 0, ['bags_2'] = 0,
                    ['tshirt_1'] = 59, ['tshirt_2'] = 1,
                    ['torso_1'] = 56, ['torso_2'] = 0,
                    ['arms'] = 30,
                    ['pants_1'] = 36, ['pants_2'] = 0,
                    ['shoes_1'] = 25, ['shoes_2'] = 0
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
        ESX.Game.SpawnVehicle("bison3", vector3(-1676.67, 487.41, 128.88), 298.84, function(vehicle)
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
            SetVehicleNumberPlateText(vehicle, "JARD8288")
        end)
        ESX.ShowNotification("Tu es en service !")
        if actionBlip ~= nil and DoesBlipExist(actionBlip) then
            RemoveBlip(actionBlip)
        end
        inAction = false
        actionIndex = 1
        actionBlip = AddBlipForCoord(Config.jardineriePositions[actionIndex])
        SetBlipColour(actionBlip, 64)
        SetBlipRoute(actionBlip, true)
        RageUI.CloseAll()
        jardinerie = false
    end
end

function End()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
    RemoveBlip(actionBlip)
    ESX.ShowNotification("Tu n'es plus en service !")
    servicetaken = false
    RageUI.CloseAll()
    jardinerie = false
end

Citizen.CreateThread(function()
    while true do
        local interval = 250

        if servicetaken then
            interval = 0
            local dst = #(GetEntityCoords(PlayerPedId())-Config.jardineriePositions[actionIndex])
            if inAction then
                DisableControlAction(0, 73, true)
            else
                local actionZone = Config.jardineriePositions[actionIndex]
                dst = #(GetEntityCoords(PlayerPedId())-actionZone)
                if dst <= 30.0 then
                    DrawMarker(22, actionZone, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
                    if dst <= 1.0 then
                        ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour jardiner.")
                        if IsControlJustPressed(0, 51) then
                            TriggerServerEvent("jobs:setupPlayerMission")
                            inAction = true
                            TaskStartScenarioInPlace(PlayerPedId(), RandomItem(), 0, true)
                            TriggerEvent("core:drawBar", 10000, "⌛ Travail en cours...")
                            Wait(10000)
                            if actionBlip ~= nil and DoesBlipExist(actionBlip) then
                                RemoveBlip(actionBlip)
                            end
                            local newActionIndex = math.random(1, #Config.jardineriePositions)
                            if newActionIndex > #Config.jardineriePositions then
                                newActionIndex = 1
                            end
                            actionIndex = newActionIndex
                            actionBlip = AddBlipForCoord(Config.jardineriePositions[actionIndex])
                            SetBlipColour(actionBlip, 64)
                            SetBlipRoute(actionBlip, true)
                            inAction = false
                            ClearPedTasksImmediately(PlayerPedId())
                            TriggerServerEvent("jobs:pay", "jardinerie")
                        end
                    end
                end
            end
        end

        Wait(interval)
    end
end)

function RandomItem()
    return Items[math.random(#Items)]
end

Citizen.CreateThread(function()
    while true do
        Wait(5000)
        if servicetaken then
            if IsPedInVehicle(PlayerPedId()) then
                local car = GetVehiclePedIsIn(PlayerPedId(), false)
                local model = GetDisplayNameFromVehicleModel(GetEntityModel(car))
                if model ~= "BISON" then
                    End()
                    ESX.ShowNotification("Votre mission vient d'être annulée parce que vous n'étiez pas dans le bon véhicule.")
                end
            end
        end
	end
end)

Citizen.CreateThread(function()
	local jardinierblip = AddBlipForCoord(-1680.12, 494.97, 128.87)
	SetBlipSprite(jardinierblip, 385)
	SetBlipScale(jardinierblip, 0.8)
	SetBlipColour(jardinierblip, 16)
	SetBlipAsShortRange(jardinierblip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName('Jardinerie')
	EndTextCommandSetBlipName(jardinierblip)
end)