ESX = nil
local MenuDrugsOpened = false
local InLabo = false
local cooldown = false
local has = false
local youhave = false
local drug = ""
local sellingDrugs = false
local InZone = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getShtozaredObjtozect', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
    
    RMenu.Add('menu', 'entry', RageUI.CreateMenu("PRIME", "Laboratoire", 1, 100))
    RMenu.Add('menu', 'exit', RageUI.CreateMenu("PRIME", "Laboratoire", 1, 100))
    RMenu:Get('menu', 'entry'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'exit'):SetRectangleBanner(255, 117, 31, 225)
    RMenu:Get('menu', 'entry').EnableMouse = false
    RMenu:Get('menu', 'exit').EnableMouse = false
    RMenu:Get('menu', 'entry').Closed = function()
        MenuDrugsOpened = false
    end
    RMenu:Get('menu', 'exit').Closed = function()
        MenuDrugsOpened = false
    end
end)

local EnAction = false
local BoxTaked = false

Citizen.CreateThread(function()
    local lastCalled = 0
    while true do

        while not CFG_DRUGS.laboratoires do Wait(500) end

        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)

        for k,v in pairs(CFG_DRUGS.laboratoires) do

            local intervalrecolte = 1000

            if GetDistanceBetweenCoords(v.recolte, GetEntityCoords(PlayerPedId()), true) < 15.0 then
                InZone = true
                intervalrecolte = 0
                DrawMarker(20, v.recolte.x, v.recolte.y, v.recolte.z + 0.30, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 0, 157, 0, 155, false, true)
            end

            if GetDistanceBetweenCoords(v.recolte, GetEntityCoords(PlayerPedId()), true) < 2 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour récolter")
            
                if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                    ExecuteCommand("e box")

                    lastCalled = GetGameTimer() + 500
                    BoxTaked = true

                    Citizen.CreateThread(function()
                        while BoxTaked do
                            SetPedMoveRateOverride(PlayerPedId(), 1.10)
                            DisableControlAction(0, 22, true)
                            DisableControlAction(0, 102, true)
                            DisableControlAction(0, 258, true)
                            DisableControlAction(0, 259, true)
                            DisableControlAction(0, 350, true)
                            DisableControlAction(0, 21, true)
                            DisableControlAction(0, 137, true)
                            DisablePlayerFiring(PlayerPedId(), true)
                            Citizen.Wait(0)
                        end
                        DisablePlayerFiring(PlayerPedId(), false)
                        ExecuteCommand("e stop")
                        SetPedMoveRateOverride(PlayerPedId(), 1.0)
                    end)
                end
            end

            -- Traitement

            local intervaltraitement = 1000

            if GetDistanceBetweenCoords(v.traitement, GetEntityCoords(PlayerPedId()), true) < 15.0 then
                InZone = true
                intervaltraitement = 0
                DrawMarker(20, v.traitement.x, v.traitement.y, v.traitement.z + 0.30, nil, nil, nil, nil, nil, nil, 0.25, 0.25, 0.25, 0, 157, 0, 155, false, true)
            end

            if GetDistanceBetweenCoords(v.traitement, GetEntityCoords(PlayerPedId()), true) < 2 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour traiter")
                if IsControlJustPressed(0, 38) and GetGameTimer() > lastCalled then
                    if BoxTaked then
                        lastCalled = GetGameTimer() + 10 * 1000
                        BoxTaked = false

                        local finished = false

                        if k == "meth" then
                            ExecuteCommand("e stop")
                            ExecuteCommand("e methfarm")
                        elseif k == "weed" then
                            ExecuteCommand("e stop")
                            ExecuteCommand("e weedfarm")
                        else
                            ExecuteCommand("e stop")
                            ExecuteCommand("e seringue")
                        end
                        FreezeEntityPosition(PlayerPedId(), true)

                        BoxTaked = true
                        TriggerEvent("core:drawBar", 10000, "💊 Traitement en cours...")
                        Wait(10000)
                        finished = true
                        BoxTaked = false
                        ExecuteCommand("e stop")
                        FreezeEntityPosition(PlayerPedId(), false)
                        if finished then
                            TriggerServerEvent("laboratoires:giveDrugs", v.itemgive)
                        end
                    else
                        ESX.ShowNotification("Allez à la première étape")
                    end
                end
            end
        end
        if InZone then
            Citizen.Wait(0)
        else
            Citizen.Wait(1000)
        end
    end
end)

function GroupDigits(value)
	if value == nil then return 0 end
	local left,num,right = string.match(value, '^([^%d]*%d)(%d*)(.-)$')

	return left..(num:reverse():gsub('(%d%d%d)', '%1'.." "):reverse())
end

function capitalizeFirstLetter(str)
    return string.upper(string.sub(str, 1, 1)) .. string.sub(str, 2)
end

function Draw3DTextH(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   

    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(4)
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

takedBox = function()
    return BoxTaked
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

---- Usable drugs

function CheckOverdose(chance)
    local roll = math.random(1, 100)
    if roll <= chance then
        local playerPed = PlayerPedId()
        ESX.ShowNotification("~r~Vous avez fait une overdose...")
        SetTimecycleModifier("REDMIST_blend")
        AnimpostfxPlay("DrugsTrevorClownsFight", 5000, true)
        ShakeGameplayCam("DRUNK_SHAKE", 5.0)
        Citizen.Wait(2000)
        SetEntityHealth(playerPed, 0)
        return true
    end
    return false
end

RegisterNetEvent('drug-effect:onCoke')
AddEventHandler('drug-effect:onCoke', function()
    local playerPed = PlayerPedId()
  
    RequestAnimSet("MOVE_M@QUICK") 
    while not HasAnimSetLoaded("MOVE_M@QUICK") do
      Citizen.Wait(0)
    end    
    ESX.ShowNotification('Vous avez consommé de la coke !')
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)

    if CheckOverdose(10) then return end

    ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "MOVE_M@QUICK", true)
    SetPedIsDrunk(playerPed, true)
	SetPedMoveRateOverride(playerPed,10.0)
    SetRunSprintMultiplierForPlayer(playerPed,1.49)
    AnimpostfxPlay("DrugsMichaelAliensFight", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 3.0)
    Citizen.Wait(60000)
    SetPedMoveRateOverride(playerPed,1.0)
    SetRunSprintMultiplierForPlayer(playerPed,1.0)
    SetPedIsDrunk(playerPed, false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(playerPed)
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)

RegisterNetEvent('drug-effect:onWeed')
AddEventHandler('drug-effect:onWeed', function()
    local playerPed = PlayerPedId()
  
    RequestAnimSet("MOVE_M@DRUNK@VERYDRUNK") 
    while not HasAnimSetLoaded("MOVE_M@DRUNK@VERYDRUNK") do
      Citizen.Wait(0)
    end    
    ESX.ShowNotification('Vous avez consommé de la weed !')
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)

    if CheckOverdose(10) then return end

    ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator6")
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "MOVE_M@DRUNK@VERYDRUNK", true)
    SetPedIsDrunk(playerPed, true)
    AnimpostfxPlay("ChopVision", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 1.0)
	
    Citizen.Wait(60000)

    SetPedMoveRateOverride(playerPed,1.0)
    SetRunSprintMultiplierForPlayer(playerPed,1.0)
    SetPedIsDrunk(playerPed, false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(playerPed)
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)

RegisterNetEvent('drug-effect:onFentanyl')
AddEventHandler('drug-effect:onFentanyl', function()
    local playerPed = PlayerPedId()
  
    RequestAnimSet("move_m@hobo@a") 
    while not HasAnimSetLoaded("move_m@hobo@a") do
      Citizen.Wait(0)
    end

    ESX.ShowNotification('Vous avez consommé du fentanyl !')
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)

    if CheckOverdose(75) then return end

    ClearPedTasksImmediately(playerPed)
    SetTimecycleModifier("spectator3")
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@hobo@a", true)
    SetPedIsDrunk(playerPed, true)
    AnimpostfxPlay("HeistCelebPass", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 3.0)
	
    SetPedArmour(playerPed, 200)

    Citizen.Wait(60000)

    SetPedMoveRateOverride(playerPed,1.0)
    SetRunSprintMultiplierForPlayer(playerPed,1.0)
    SetPedIsDrunk(playerPed, false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(playerPed)
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)

RegisterNetEvent('drug-effect:onKetamine')
AddEventHandler('drug-effect:onKetamine', function()
    local playerPed = PlayerPedId()
  
    RequestAnimSet("move_m@buzzed") 
    while not HasAnimSetLoaded("move_m@buzzed") do
      Citizen.Wait(0)
    end

    ESX.ShowNotification('Vous avez consommé de la kétamine !')
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)

    if CheckOverdose(60) then return end

    ClearPedTasksImmediately(playerPed)
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@buzzed", true)
    SetPedIsDrunk(playerPed, true)
    SetTimecycleModifier("spectator5")
    AnimpostfxPlay("Rampage", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 1.5)
	
    SetPedArmour(playerPed, 50)

    Citizen.Wait(60000)

    SetPedMoveRateOverride(playerPed,1.0)
    SetRunSprintMultiplierForPlayer(playerPed,1.0)
    SetPedIsDrunk(playerPed, false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(playerPed)
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)

RegisterNetEvent('drug-effect:onMeth')
AddEventHandler('drug-effect:onMeth', function()
    local playerPed = PlayerPedId()
  
    RequestAnimSet("move_m@drunk@slightlydrunk") 
    while not HasAnimSetLoaded("move_m@drunk@slightlydrunk") do
      Citizen.Wait(0)
    end

    ESX.ShowNotification('Vous avez consommé de la meth !')
    TaskStartScenarioInPlace(playerPed, "WORLD_HUMAN_SMOKING_POT", 0, 1)
    Citizen.Wait(3000)

    if CheckOverdose(30) then return end

    ClearPedTasksImmediately(playerPed)
    SetPedMotionBlur(playerPed, true)
    SetPedMovementClipset(playerPed, "move_m@drunk@slightlydrunk", true)
    SetPedIsDrunk(playerPed, true)
    SetTimecycleModifier("spectator5")
    AnimpostfxPlay("SuccessMichael", 10000001, true)
    ShakeGameplayCam("DRUNK_SHAKE", 1.5)
	
    Citizen.Wait(60000)

    SetPedMoveRateOverride(playerPed,1.0)
    SetRunSprintMultiplierForPlayer(playerPed,1.0)
    SetPedIsDrunk(playerPed, false)		
    SetPedMotionBlur(playerPed, false)
    ResetPedMovementClipset(playerPed)
    AnimpostfxStopAll()
    ShakeGameplayCam("DRUNK_SHAKE", 0.0)
    SetTimecycleModifierStrength(0.0)
end)