local inNoClip = false
local saveentity = 0
local devOption = false
local isInSpectate = false

function ForceDeactivateNoclip()
    if inNoClip then
        inNoClip = false
        SetEnabled(false)
        devOption = false
        SetNoClipAttributes(GetPlayerPed(-1), false)
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local get, z = GetGroundZFor_3dCoord(pCoords.x, pCoords.y, pCoords.z, true, 0)
        if get then
            SetEntityCoordsNoOffset(PlayerPedId(), pCoords.x, pCoords.y, z + 1.0, 0.0, 0.0, 0.0)
        end
    end
end

function ToogleNoClip()
    if inNoClip then
        inNoClip = false
        SetEnabled(false)
        SetNoClipAttributes(GetPlayerPed(-1), false)
        local pPed = PlayerPedId()
        local pCoords = GetEntityCoords(pPed)
        local get, z = GetGroundZFor_3dCoord(pCoords.x, pCoords.y, pCoords.z, true, 0)
        if get then
            SetEntityCoordsNoOffset(PlayerPedId(), pCoords.x, pCoords.y, z + 1.0, 0.0, 0.0, 0.0)
        end
        return
    else
        inNoClip = true
        SetEnabled(true)
        Citizen.CreateThread(function()
            while inNoClip do
                CameraLoop()
                SetNoClipAttributes(PlayerPedId(), true)
                Wait(1)
            end
        end)
    end
end

function SetNoClipAttributes(ped, status)
    if status then
        SetEntityInvincible(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityCollision(ped, false, false)
        SetEntityVisible(ped, false, false)

        -- print(GetCamCoord(_internal_camera))
    else
        SetEntityInvincible(ped, false)
        FreezeEntityPosition(ped, false)
        SetEntityCollision(ped, true, true)
        SetEntityVisible(ped, true, true)
    end
end

local INPUT_SPRINT = 21
local INPUT_CHARACTER_WHEEL = 19
local INPUT_LOOK_LR = 1
local INPUT_LOOK_UD = 2
local INPUT_COVER = 44
local INPUT_MULTIPLAYER_INFO = 20
local INPUT_MOVE_UD = 31
local INPUT_MOVE_LR = 30

--------------------------------------------------------------------------------

_internal_camera = nil
local _internal_isFrozen = false

local _internal_pos = nil
local _internal_rot = nil
local _internal_fov = nil
local _internal_vecX = nil
local _internal_vecY = nil
local _internal_vecZ = nil

--------------------------------------------------------------------------------

local settings = {
    --Camera
    fov = 45.0,
    -- Mouse
    mouseSensitivityX = 6.5,
    mouseSensitivityY = 6.5,
    -- Movement
    normalMoveMultiplier = 1,
    fastMoveMultiplier = 10,
    slowMoveMultiplier = 0.1,
    -- On enable/disable
    enableEasing = false,
    easingDuration = 1000
}

--------------------------------------------------------------------------------

local function IsFreecamFrozen()
    return _internal_isFrozen
end

local function SetFreecamFrozen(frozen)
    local frozen = frozen == true
    _internal_isFrozen = frozen
end

--------------------------------------------------------------------------------

local function GetFreecamPosition()
    return _internal_pos
end

local function SetFreecamPosition(x, y, z)
    local pos = vector3(x, y, z)
    SetCamCoord(_internal_camera, pos)

    _internal_pos = pos
end

--------------------------------------------------------------------------------

local function GetFreecamRotation()
    return _internal_rot
end

local function SetFreecamRotation(x, y, z)
    local x = Clamp(x, -90.0, 90.0)
    local y = y % 360
    local z = z % 360
    local rot = vector3(x, y, z)
    local vecX, vecY, vecZ = EulerToMatrix(x, y, z)

    LockMinimapAngle(math.floor(z))
    SetCamRot(_internal_camera, rot)

    _internal_rot = rot
    _internal_vecX = vecX
    _internal_vecY = vecY
    _internal_vecZ = vecZ
end

--------------------------------------------------------------------------------

local function GetFreecamFov()
    return _internal_fov
end

local function SetFreecamFov(fov)
    local fov = Clamp(fov, 0.0, 90.0)
    SetCamFov(_internal_camera, fov)
    _internal_fov = fov
end

--------------------------------------------------------------------------------

local function GetFreecamMatrix()
    return _internal_vecX, _internal_vecY, _internal_vecZ, _internal_pos
end

local function GetFreecamTarget(distance)
    local target = _internal_pos + (_internal_vecY * distance)
    return target
end

--------------------------------------------------------------------------------

local function IsFreecamEnabled()
    return IsCamActive(_internal_camera) == 1
end

local controls = { 12, 13, 14, 15, 16, 17, 18, 19, 50, 85, 96, 97, 99, 115, 180, 181, 198, 261, 262 }
local function LockControls()
    for k, v in pairs(controls) do
        DisableControlAction(0, v, true)
    end
    EnableControlAction(0, 166, true)
end

local function SetFreecamEnabled(enable)
    if enable == IsFreecamEnabled() then
        return
    end

    if enable then
        local pos = GetGameplayCamCoord()
        local rot = GetGameplayCamRot()

        _internal_camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)

        SetFreecamFov(settings.fov)
        SetFreecamPosition(pos.x, pos.y, pos.z)
        SetFreecamRotation(rot.x, rot.y, rot.z)
    else
        DestroyCam(_internal_camera)
        ClearFocus()
        UnlockMinimapPosition()
        UnlockMinimapAngle()
    end
    RenderScriptCams(enable, settings.enableEasing, settings.easingDuration)
end

--------------------------------------------------------------------------------

function IsEnabled()
    return IsFreecamEnabled()
end

function SetEnabled(enable)
    return SetFreecamEnabled(enable)
end

function IsFrozen()
    return IsFreecamFrozen()
end

function SetFrozen(frozen)
    return SetFreecamFrozen(frozen)
end

function GetFov()
    return GetFreecamFov()
end

function SetFov(fov)
    return SetFreecamFov(fov)
end

function GetTarget(distance)
    return { table.unpack(GetFreecamTarget(distance)) }
end

function GetPosition()
    return { table.unpack(GetFreecamPosition()) }
end

function SetPosition(x, y, z)
    return SetFreecamPosition(x, y, z)
end

function GetRotation()
    return { table.unpack(GetFreecamRotation()) }
end

function SetRotation(x, y, z)
    return SetFreecamRotation(x, y, z)
end

function GetPitch()
    return GetFreecamRotation().x
end

function GetRoll()
    return GetFreecamRotation().y
end

function GetYaw()
    return GetFreecamRotation().z
end

--------------------------------------------------------------------------------
function GetSpeedMultiplier()
    if IsDisabledControlPressed(0, 180) then
        if settings.normalMoveMultiplier > 1.0 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier - 0.5
        elseif settings.normalMoveMultiplier > 0.2 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier - 0.1
        else
            settings.normalMoveMultiplier = settings.normalMoveMultiplier - 0.01
        end
        
    elseif IsDisabledControlPressed(0, 181) then
        if settings.normalMoveMultiplier < 0.2 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier + 0.01
        elseif settings.normalMoveMultiplier > 1.0 then
            settings.normalMoveMultiplier = settings.normalMoveMultiplier + 0.5
        else
            settings.normalMoveMultiplier = settings.normalMoveMultiplier + 0.1
        end
    end

    if settings.normalMoveMultiplier < 0 then
        settings.normalMoveMultiplier = 0
    end
    if settings.normalMoveMultiplier > 10.0 then 
        settings.normalMoveMultiplier = 10.0 
    end
    return settings.normalMoveMultiplier
end

function CameraLoop()
    if not IsFreecamEnabled() or IsPauseMenuActive() then
        return
    end
    if not IsFreecamFrozen() then
        local vecX, vecY = GetFreecamMatrix()
        local vecZ = vector3(0, 0, 1)
        local pos = GetFreecamPosition()
        local rot = GetFreecamRotation()
        -- Get speed multiplier for movement
        local frameMultiplier = GetFrameTime() * 60
        local speedMultiplier = GetSpeedMultiplier() * frameMultiplier
        -- Get mouse input
        local mouseX = GetDisabledControlNormal(0, INPUT_LOOK_LR)
        local mouseY = GetDisabledControlNormal(0, INPUT_LOOK_UD)
        -- Get keyboard input
        local moveWS = GetDisabledControlNormal(0, INPUT_MOVE_UD)
        local moveAD = GetDisabledControlNormal(0, INPUT_MOVE_LR)
        local moveQZ = GetDisabledControlNormalBetween(0, INPUT_COVER, INPUT_MULTIPLAYER_INFO)
        -- Calculate new rotation.
        local rotX = rot.x + (-mouseY * settings.mouseSensitivityY)
        local rotZ = rot.z + (-mouseX * settings.mouseSensitivityX)
        local rotY = 0.0
        -- Adjust position relative to camera rotation.
        if not isInSpectate and not KEYBOARDACTIVE then 
            pos = pos + (vecX * moveAD * speedMultiplier)
            pos = pos + (vecY * -moveWS * speedMultiplier)
            pos = pos + (vecZ * moveQZ * speedMultiplier)
        end

        if #(pos - GetEntityCoords(GetPlayerPed(-1))) > 20.0 then
            pos = GetEntityCoords(GetPlayerPed(-1))
        end

        -- Adjust new rotation
        rot = vector3(rotX, rotY, rotZ)
        if IsControlJustPressed(0, 38) then
            if devOption then 
                devOption = false
            else
                devOption = true
            end
        end
        -- Update camera
        if devOption then 
            UpdateEntityLooking()
        end
        SetFreecamPosition(pos.x, pos.y, pos.z)
        SetFreecamRotation(rot.x, rot.y, rot.z)

        LockControls()
        ClearFocus()
        SetEntityCoordsNoOffset(GetPlayerPed(-1), pos.x, pos.y, pos.z, 0.0, 0.0, 0.0)
    end
end

function Clamp(x, min, max)
    return math.min(math.max(x, min), max)
end

function GetDisabledControlNormalBetween(inputGroup, control1, control2)
    local normal1 = GetDisabledControlNormal(inputGroup, control1)
    local normal2 = GetDisabledControlNormal(inputGroup, control2)
    return normal1 - normal2
end

function EulerToMatrix(rotX, rotY, rotZ)
    local radX = math.rad(rotX)
    local radY = math.rad(rotY)
    local radZ = math.rad(rotZ)

    local sinX = math.sin(radX)
    local sinY = math.sin(radY)
    local sinZ = math.sin(radZ)
    local cosX = math.cos(radX)
    local cosY = math.cos(radY)
    local cosZ = math.cos(radZ)

    local vecX = {}
    local vecY = {}
    local vecZ = {}

    vecX.x = cosY * cosZ
    vecX.y = cosY * sinZ
    vecX.z = -sinY

    vecY.x = cosZ * sinX * sinY - cosX * sinZ
    vecY.y = cosX * cosZ - sinX * sinY * sinZ
    vecY.z = cosY * sinX

    vecZ.x = -cosX * cosZ * sinY + sinX * sinZ
    vecZ.y = -cosZ * sinX + cosX * sinY * sinZ
    vecZ.z = cosX * cosY

    vecX = vector3(vecX.x, vecX.y, vecX.z)
    vecY = vector3(vecY.x, vecY.y, vecY.z)
    vecZ = vector3(vecZ.x, vecZ.y, vecZ.z)

    return vecX, vecY, vecZ
end


local function DrawTexts(x, y, text, center, scale, rgb, font, justify)
    SetTextFont(font)
    SetTextScale(scale, scale)

    SetTextColour(rgb[1], rgb[2], rgb[3], rgb[4])
    SetTextEntry("STRING")
    --SetTextJustification(justify)
    --SetTextRightJustify(justify)
    SetTextCentre(center)
    AddTextComponentString(text)
    EndTextCommandDisplayText(x, y)
end

local function RotationToDirection(rotation)
    local adjustedRotation =
    {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction =
    {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

local function RayCastGamePlayCamera(distance, ignoreEntity)
    if ignoreEntity == nil then ignoreEntity = -1 end
    local cameraRotation = GetCamRot(_internal_camera, 2)
    local cameraCoord = GetCamCoord(_internal_camera)
    local direction = RotationToDirection(cameraRotation)
    local destination =
    {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x
        , destination.y, destination.z, -1, ignoreEntity, 1))
    return b, c, e
end

local function AcquireEntityControl(entity, timeout)
    if not DoesEntityExist(entity) then return false end
    local start = GetGameTimer()
    local netId = NetworkGetNetworkIdFromEntity(entity)
    if netId and netId ~= 0 then SetNetworkIdCanMigrate(netId, true) end
    NetworkRequestControlOfEntity(entity)
    while not NetworkHasControlOfEntity(entity) and GetGameTimer() - start < (timeout or 1200) do
        NetworkRequestControlOfEntity(entity)
        Wait(0)
    end
    return NetworkHasControlOfEntity(entity)
end

RegisterNetEvent('cn5:applyVehicleRepair', function(netId, props)
    local vehicle = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(vehicle) then
        return
    end

    while not NetworkHasControlOfEntity(vehicle) do
        NetworkRequestControlOfEntity(vehicle)
        Wait(0)
    end

    ESX.Game.SetVehicleProperties(vehicle, props)

    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehiclePetrolTankHealth(vehicle, 1000.0)
    SetVehicleDirtLevel(vehicle, 0.0)
    SetVehicleDoorShut(vehicle, 4, false, false)
end)

function UpdateEntityLooking()
    local hit, pos, entity = RayCastGamePlayCamera(3000, PlayerPedId())

    if hit then
        local pos = GetEntityCoords(entity)
        local entityType = GetEntityType(entity)

        local LiseretColor = { 3, 254, 34 }
        local baseX = 0.65 -- gauche / droite ( plus grand = droite )
        local baseY = 0.25 -- Hauteur ( Plus petit = plus haut )
        local baseWidth = 0.15 -- Longueur
        local baseHeight = 0.03 -- Epaisseur

        -- DrawMarker(0, pos.xyz, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 50.0, 255, 255, 255, 200, 0, 1, 2, 0, nil, nil, 0)

        DrawRect(baseX, baseY - 0.017, baseWidth, baseHeight - 0.025, LiseretColor[1], LiseretColor[2], LiseretColor[3],
            255) -- Liseret
        DrawRect(baseX, baseY, baseWidth, baseHeight, 28, 28, 28, 170) -- Bannière

        if entityType == 0 then
            DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~r~Inconnue", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
            SetEntityDrawOutline(saveentity, false)
        else
            if entity ~= saveentity then 
                SetEntityDrawOutline(saveentity, false)
                saveentity = entity
            end
            
            local model = GetEntityModel(entity)
            local entity = entity
            local haveDeleteEntity = false
            local heading = GetEntityHeading(entity)
            local coords = GetEntityCoords(entity)

            if entityType == 1 then
                if IsPedAPlayer(entity) then
                    SetEntityDrawOutline(entity, true)
                    SetEntityDrawOutlineColor(255, 220, 0, 140)
                end
            else
                SetEntityDrawOutline(entity, true)
                SetEntityDrawOutlineColor(255, 220, 0, 140)
            end

            if entityType == 1 then
                if IsPedAPlayer(entity) then
                    DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~y~Joueur", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                    haveDeleteEntity = true
                else
                    DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~y~Ped", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                    haveDeleteEntity = true
                end
            elseif entityType == 2 then
                DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~y~Véhicule", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                haveDeleteEntity = true
            elseif entityType == 3 then
                DrawTexts(baseX, baseY - 0.013, "Type d'entité: ~y~Objet", true, 0.35, { 255, 255, 255, 255 }, 6, 0) -- title
                haveDeleteEntity = true
            end

            if haveDeleteEntity then
                DrawRect(baseX, baseY + (0.016 * 2), baseWidth, baseHeight, 28, 28, 28, 180)
                DrawTexts(baseX, baseY + (0.016 * 2) - 0.013, "Modèle: " .. model, true, 0.35, { 255, 255, 255, 255 }, 6
                    , 0) -- level

                DrawRect(baseX, baseY + (0.0215 * 3), baseWidth, baseHeight, 28, 28, 28, 180)
                DrawTexts(baseX, baseY + (0.0215 * 3) - 0.013, "Heading: " .. heading, true, 0.35, { 255, 255, 255, 255 }
                    , 6, 0) -- level

                DrawRect(baseX, baseY + (0.0236 * 4), baseWidth, baseHeight, 28, 28, 28, 180)
                DrawTexts(baseX, baseY + (0.0236 * 4) - 0.013, "Pos: " .. tostring(coords), true, 0.35,
                    { 255, 255, 255, 255 }, 6, 0) -- level

                if entityType == 1 then
                    DrawRect(baseX, baseY + (0.0253 * 5), baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + (0.0253 * 5) - 0.013, "Touche X = Revive le joueur", true, 0.35,
                        { 255, 255, 255, 255 }, 6, 0)

                    if IsControlJustReleased(0, 73) then
                        local playerServerId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entity))

                        TriggerServerEvent("adminmenu:revive", playerServerId)
                    end
                elseif entityType == 2 or entityType == 3 then
                    DrawRect(baseX, baseY + (0.0253 * 5), baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + (0.0253 * 5) - 0.013, "Touche X = Delete entité", true, 0.35,
                        { 255, 255, 255, 255 }, 6, 0) -- Delete Entité
                    
                    if IsControlJustReleased(0, 73) then
                        TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(entity))
                        DeleteEntity(entity)
                        SetEntityCoordsNoOffset(entity, 90000.0, 0.0, -500.0, 0.0, 0.0, 0.0)
                    end
                end
    
                if entityType  == 2 then 
                    DrawRect(baseX, baseY + (0.0264 * 6), baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + (0.0264 * 6) - 0.013, "Touche R = Réparer véhicule", true, 0.35,
                        { 255, 255, 255, 255 }, 6, 0) -- Delete Entité

                    DrawRect(baseX, baseY + (0.0272 * 7), baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + (0.0272 * 7) - 0.013, "Touche H = Envoyer en fourrière", true, 0.35,
                        { 255, 255, 255, 255 }, 6, 0)

                    DrawRect(baseX, baseY + (0.0272 * 8), baseWidth, baseHeight, 28, 28, 28, 180)
                    DrawTexts(baseX, baseY + (0.0272 * 8) - 0.013, "Touche F = Remettre sur les roues", true, 0.35,
                        { 255, 255, 255, 255 }, 6, 0)
                        
                    if IsControlJustReleased(0, 45) then
                        local driver, driverId = nil, nil
                        driver = GetPedInVehicleSeat(entity, -1)
                        local vehicle = entity
                        NetworkRequestControlOfEntity(entity)
                        SetVehicleFixed(vehicle)
                        SetVehicleDeformationFixed(vehicle)
                        SetVehicleUndriveable(vehicle, false)
                        SetVehicleEngineOn(vehicle, true, true)
                        SetVehicleEngineHealth(vehicle, 700.0)
                        SetVehiclePetrolTankHealth(vehicle, 700.0)
                        SetVehicleEngineHealth(vehicle, 1000.0)
                        SetVehiclePetrolTankHealth(vehicle, 1000.0)
                        SetVehicleDoorShut(vehicle, 4, false, false)
                        if driver ~= nil then 
                            driverId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(driver))
                            local props = ESX.Game.GetVehicleProperties(vehicle)
                            TriggerServerEvent('cn5:repairVehicle', driverId, NetworkGetNetworkIdFromEntity(vehicle), props)
                        end
                    end

                    if IsControlJustReleased(0, 49) or IsControlJustReleased(0, 23) or IsControlJustReleased(0, 75) then
                        if AcquireEntityControl(entity, 1200) then
                            local h = GetEntityHeading(entity)
                            local coords = GetEntityCoords(entity)
                            SetEntityAsMissionEntity(entity, true, false)
                            FreezeEntityPosition(entity, true)
                            SetEntityVelocity(entity, 0.0, 0.0, 0.0)
                            SetVehicleForwardSpeed(entity, 0.0)
                            SetEntityRotation(entity, 0.0, 0.0, h, 2, true)
                            SetEntityCoordsNoOffset(entity, coords.x, coords.y, coords.z + 1.0, true, true, true)
                            SetVehicleOnGroundProperly(entity)
                            FreezeEntityPosition(entity, false)
                        end
                    end

                    if IsControlJustReleased(0, 74) then
                        local vehicleProps = ESX.Game.GetVehicleProperties(entity)
						TriggerServerEvent("impound:check", vehicleProps)
                        TriggerServerEvent("DeleteEntity", NetworkGetNetworkIdFromEntity(entity))
                        DeleteEntity(entity)
                        SetEntityCoordsNoOffset(entity, 90000.0, 0.0, -500.0, 0.0, 0.0, 0.0)
                    end
                end

                if IsControlJustPressed(0, 38) then
                    TriggerEvent("addToCopy",
                        "{hash = " ..
                        model .. ", pos = vector4(" .. coords.x .. ", " .. coords.y ..
                        ", " .. coords.z .. ", " .. heading .. ")},")
                end
            end
        end
    end
end

AddEventHandler("adminmenu:getCamera", function (cb)
    cb(_internal_camera)
end)

AddEventHandler("adminmenu:client:SetSpectateStatus", function(stats, pos, id)
    isInSpectate = stats
    idSpectate = id
    if stats then
        if pos ~= nil then
            SetFreecamPosition(pos.x, pos.y, pos.z)
        end
    end
end)