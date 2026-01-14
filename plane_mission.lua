PLANE = {}
PLANE.isMissionActive = false
PLANE.dropObject = nil
PLANE.dropBlip = nil
PLANE.dropZone = nil
PLANE.planeEntity = nil
PLANE.checkpointHandle = nil
local quantity = {1, 10, 100, 500}

function PLANE.StartMission(key, drugName, quantity, price)
    if PLANE.isMissionActive then return end
    PLANE.isMissionActive = true
    local playerPed = PlayerPedId()

    local cfg = ConfigPlane[key]
    local spawnPos = cfg.posSpawn
    local planeModel = GetHashKey("cuban800")

    RequestModel(planeModel)
    while not HasModelLoaded(planeModel) do Wait(0) end

    PLANE.planeEntity = CreateVehicle(planeModel, spawnPos.x, spawnPos.y, spawnPos.z, spawnPos.w, true, false)
    SetEntityAsMissionEntity(PLANE.planeEntity, true, true)
    SetVehicleNumberPlateText(PLANE.planeEntity, "XXXX0000")
    PLANE.dropZone = cfg.rewardPoint[math.random(#cfg.rewardPoint)]

    PLANE.dropBlip = AddBlipForCoord(PLANE.dropZone)
    SetBlipSprite(PLANE.dropBlip, 478)
    SetBlipScale(PLANE.dropBlip, 0.9)
    SetBlipColour(PLANE.dropBlip, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Point de livraison")
    EndTextCommandSetBlipName(PLANE.dropBlip)
    ESX.ShowNotification("~b~Mission avion lancée~s~ ! Allez au point de livraison.")

    lib.showTextUI("Allez dans l'avion pour commencer la mission", { position = "bottom-center"})

    while not IsPedInAnyPlane(PlayerPedId()) and not (GetVehiclePedIsIn(playerPed, false) == PLANE.planeEntity) do 
        Wait(0)
    end
    lib.hideTextUI()
    CreateThread(function()
        local ped = PlayerPedId()
    
        while not (IsPedInAnyPlane(ped) and GetVehiclePedIsIn(ped, false) == PLANE.planeEntity) do
            Wait(0)
        end
    
        while PLANE.isMissionActive do
            Wait(1000)
            local height = GetEntityHeightAboveGround(PlayerPedId())
            if height > 30.0 then
                CreateThread(function ()
                    while IsPedInAnyVehicle(ped, false) do 
                       
                        Wait(100)
                    end 
                    PLANE.isMissionActive = false
                    if DoesEntityExist(PLANE.planeEntity) then
                        DeleteEntity(PLANE.planeEntity)
                    end
                    if DoesBlipExist(PLANE.dropBlip) then RemoveBlip(PLANE.dropBlip) end
                    lib.hideTextUI()
                end)
                break
            end
        end

        if math.random(1, 100) <= 5 then
            local veh = GetVehiclePedIsIn(ped, false)
            if veh and veh ~= 0 then
                SetVehicleEngineHealth(veh, 0.0)
                SetVehicleEngineOn(veh, false, true, true)
                ESX.ShowNotification("~r~Votre avion est tombé en panne en plein vol !")
            end
        end
    end)
    lib.showTextUI("Livrez la cargaison au coordonées gps", { position = "bottom-center"})
    while PLANE.isMissionActive do
        if PLANE.isMissionActive and PLANE.dropZone then
            if not PLANE.checkpointHandle then
                PLANE.checkpointHandle = CreateCheckpoint(16, PLANE.dropZone.x, PLANE.dropZone.y, PLANE.dropZone.z, 0.0, 0.0, 0.0, 15.0,255, 0, 0, 200, 0 )
                SetCheckpointCylinderHeight(PLANE.checkpointHandle, 3.0, 3.0, 1.0)
            end

            local playerPed = PlayerPedId()
            local coords = GetEntityCoords(playerPed)
            if #(coords - PLANE.dropZone) < 20.0 and (GetVehiclePedIsIn(playerPed, false) == PLANE.planeEntity) and  PLANE.isMissionActive then
                ESX.ShowNotification("~y~Vous avez réussi la mission !")
                TriggerServerEvent("plane:server:finish", drugName, quantity, price, key)
                if DoesBlipExist(PLANE.dropBlip) then RemoveBlip(PLANE.dropBlip) end
                if PLANE.checkpointHandle then DeleteCheckpoint(PLANE.checkpointHandle) PLANE.checkpointHandle = nil end

                PLANE.isMissionActive = false
                PLANE.dropZone = nil
                PLANE.planeEntity = nil
                PLANE.dropBlip = nil
            end
        elseif PLANE.checkpointHandle then
            DeleteCheckpoint(PLANE.checkpointHandle)
            PLANE.checkpointHandle = nil
        end
        Wait(0)

    end
    lib.hideTextUI()
    if  PLANE.isMissionActive then 
        local model = GetHashKey("prop_box_wood02a_pu")
        loadModel(model)
        
        local coords = GetEntityCoords(PlayerPedId())
        local obj = CreateObjectNoOffset(model, coords.x, coords.y, coords.z, true, false, false)
        SetEntityAlpha(obj, 255, false)
        SetEntityAsMissionEntity(obj, true, true)
        SetEntityCollision(obj, false, true)
        ActivatePhysics(obj)
        CreateThread(function()
            Wait(15000)
            if DoesEntityExist(obj) then
                DeleteEntity(obj)
            end
        end)
    end

end
PLANE.MenuOpen = false
Citizen.CreateThread(function()
	RMenu.Add('plane', 'main', RageUI.CreateMenu("PRIME", "Vendeur drogue", 1, 100))
	RMenu:Get('plane', 'main'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('plane', 'main').EnableMouse = false
    RMenu:Get('plane', 'main').Closed = function()
		PLANE.MenuOpen = false
    end
end)

function PLANE.Menu(coords, index)

    if PLANE.MenuOpen then
        PLANE.MenuOpen = false
        return
    else
        PLANE.MenuOpen = true
        RageUI.Visible(RMenu:Get('plane', 'main'), true)
        local data = ConfigPlane[index]
        Citizen.CreateThread(function()
            while PLANE.MenuOpen do

				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), coords, true) > 5.0 then
					RageUI.CloseAll()
					PLANE.MenuOpen = false
				end

				RageUI.IsVisible(RMenu:Get('plane', 'main'), true, true, true, function()
                    for key, value in pairs(data.drugs) do
                        RageUI.List(value.label, quantity, value.index, nil, {}, true, function(Hovered, Active, Selected, Index)
                            value.index = Index
                            if Selected then 
                                TriggerServerEvent("plane:server:canStartPlaneMission", index, value.name, quantity[value.index], value.price)
                            end
                        end)
                    end
                end, function()
				end)
                Wait(0)
            end
        end)
    end
end

CreateThread(function ()
    while true do
        local pNear = false
        for key, value in pairs(ConfigPlane) do
            local dst = GetEntityCoords(PlayerPedId())

            if #(dst - value.pos.xyz) <= 5.0 then
                ESX.ShowHelpNotification("Appuyez sur [~y~E~w~] pour parler avec la personne")
                if IsControlJustPressed(0, 38) and not PLANE.MenuOpen then 
                    PLANE.Menu(value.pos, key)
                end
                pNear = true
            end
        end
        if pNear then
            Wait(1)
        else
            Wait(500)
        end
    end
end)

RegisterNetEvent("plane:client:canStartPlaneMission", function (key, name, quantity, price)
    PLANE.StartMission(key, name, quantity, price)
end)