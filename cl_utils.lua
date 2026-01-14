vRP = nil
ESX = nil

if ConfigHose.Notifications.Enabled and ConfigHose.Notifications.Framework.vRP then
    local Tunnel = module("vrp", "lib/Tunnel")
    local Proxy = module("vrp", "lib/Proxy")
    vRP = Proxy.getInterface("vRP")
end

if ConfigHose.Notifications.Enabled and ConfigHose.Notifications.Framework.ESX then
    ESX = exports["es_extended"]:getSharedObject()
end

if ConfigHose.EnablePositioningCommand then
	TriggerEvent('chat:addSuggestion', '/'.."findhosepositioning", "Find positioning of the hose/supply line on your fire truck")
    
	RegisterCommand("findhosepositioning", function(source, args)

        local ped = PlayerPedId()
        local targetVehicle = GetVehiclePedIsIn(ped, false)
    
        if targetVehicle == nil or targetVehicle == 0 then
            Notify("No vehicle found!")
        else
            local model = `prop_poolball_8`
            SetEntityAlpha(targetVehicle, 150, false)
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end
            local ballProp = CreateObject(model, coords, false, false, false)

            while not DoesEntityExist(ballProp) do Wait(0) end

            SetModelAsNoLongerNeeded(model)
            local offSet = {0.0, 0.0, 0.0}
            local rotation = {0.0, 0.0, 0.0}
            local offSetComplete = false
            while not offSetComplete do
                if targetVehicle ~= nil and targetVehicle ~= 0 then
                    DetachEntity(ballProp, true, false)
                    AttachEntityToEntity(ballProp, targetVehicle, -1, offSet[1], offSet[2], offSet[3], rotation[1], rotation[2], rotation[3], true, false, true, false, 1, true)
                    if not IsControlReleased(0, ConfigHose.PositioningControls.down) then --page down
                        offSet = {offSet[1], offSet[2], offSet[3] - 0.01}
                    end

                    if not IsControlReleased(0, ConfigHose.PositioningControls.up) then --page up
                        offSet = {offSet[1], offSet[2], offSet[3] + 0.01}
                    end

                    if not IsControlReleased(0, ConfigHose.PositioningControls.backwards) then --arrow down
                        offSet = {offSet[1], offSet[2] - 0.01, offSet[3]}
                    end

                    if not IsControlReleased(0, ConfigHose.PositioningControls.forwards) then --arrow up
                        offSet = {offSet[1], offSet[2] + 0.01, offSet[3]}
                    end

                    if not IsControlReleased(0, ConfigHose.PositioningControls.left) then --arrow left
                        offSet = {offSet[1] - 0.01, offSet[2], offSet[3]}
                    end

                    if not IsControlReleased(0, ConfigHose.PositioningControls.right) then --arrow right
                        offSet = {offSet[1] + 0.01, offSet[2], offSet[3]}
                    end

                    if IsControlJustPressed(0, ConfigHose.PositioningControls.enter) then -- enter - finish
                        offSetComplete = true
                    end
                end

                Wait(0)
            end

            Notify("OffSet Values are now printed in your console")
            print("OffSet: {"..offSet[1]..", "..offSet[2]..", "..offSet[3].."}")
            DeleteEntity(ballProp)
            ResetEntityAlpha(targetVehicle)
        end
		
	end, false)
end

function Notify(text)

    if not ConfigHose.Notifications.Enabled then
        return
    end

    if ConfigHose.Notifications.Framework.ESX then
        if ESX ~= nil then
            ESX.ShowNotification(text)
        end
    elseif ConfigHose.Notifications.Framework.QBCore then
        TriggerEvent('QBCore:Notify', text, 'primary')
    elseif ConfigHose.Notifications.Framework.QBX then
        exports.qbx_core:Notify(text, 'primary')
    elseif ConfigHose.Notifications.Framework.vRP then
        vRP.notify(source, {text})
    elseif ConfigHose.Notifications.Framework.okok then
        exports['okokNotify']:Alert("Smart Hose", text, 2000, 'info', true)
    else
        showBaseNotification(text)
    end
end

function showBaseNotification(message)
    -- Base game notifications 
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0,1)
end

-- @GeneralFunctions
function DisplayHelpText(text)
    SetTextComponentFormat("STRING")
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, ConfigHose.Notifications.HelpTextSound, -1)
end

function drawInstructionalText(msg, coords)
    AddTextEntry('instructionalText', msg)
    SetFloatingHelpTextWorldPosition(1, coords)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('instructionalText')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(2, false, false, -1)
end

function IsFireHoseEnabled()
    return (HoseManager.nozzle and not HoseManager.nozzleDropped)
end
exports("IsFireHoseEnabled", IsFireHoseEnabled)

function IsFireHoseShooting()
    return HoseManager.pressed
end
exports("IsFireHoseShooting", IsFireHoseShooting)

function IsFireHoseShootingWater()
    return ParticleManager.isWaterDecal
end
exports("IsFireHoseShootingWater", IsFireHoseShootingWater)

function IsVehicleUsingWater(vehicleNetID)
    local settings = HoseManager.vehicleSettings[vehicleNetID]
    if not settings then return true end
    return settings.decalType
end
exports("IsVehicleUsingWater", IsVehicleUsingWater)

function GetCurrentDecalCoords()
    return ParticleManager.CurrentDecalCoords
end
exports("GetCurrentDecalCoords", GetCurrentDecalCoords)

function GetCurrentHosePressure()
    return ParticleManager.particleScale
end
exports("GetCurrentHosePressure", GetCurrentHosePressure)

if ConfigHose.InteractType.TruckInteraction.Custom then
    local function _toNetId(ent)
        if ent and DoesEntityExist(ent) then return ToNetId(ent) end
        return nil
    end

    local function _neighborsFor(netId)
        local list = {}
        if not netId then return list end
        local RM = RopeManager or {}
        local cv = RM.connectedVehicles and RM.connectedVehicles[netId]
        if type(cv) == 'number' then list[#list+1] = cv
        elseif type(cv) == 'table' then for nid,_ in pairs(cv) do list[#list+1] = tonumber(nid) or nid end end
        local ic = RM.incomingConnections and RM.incomingConnections[netId]
        if type(ic) == 'number' then list[#list+1] = ic
        elseif type(ic) == 'table' then for nid,_ in pairs(ic) do list[#list+1] = tonumber(nid) or nid end end
        return list
    end

    local function _buildCtx(vehicle)
        local ped   = PlayerPedId()
        local pos   = GetEntityCoords(ped)

        local model          = GetEntityModel(vehicle)
        local vs             = (ConfigHose.Rope.VehicleSettings[model] or {})
        local useBone        = vs.useBone or false
        local bones          = vs.bones or {}
        local offsets        = vs.offsets or { { x = 0.0, y = 0.0, z = 0.0 } }
        local pts            = getAttachmentPoints(vehicle, useBone, bones, offsets)
        if type(pts) ~= 'table' or #pts == 0 then pts = { GetEntityCoords(vehicle) } end

        local closest = pts[1]
        local minDist = #(pos - closest)
        for i = 2, #pts do
            local p = pts[i]
            local d = #(pos - p)
            if d < minDist then closest, minDist = p, d end
        end

        local meId    = GetPlayerServerId(PlayerId())
        local vehNet  = _toNetId(vehicle)
        local neigh   = _neighborsFor(vehNet)

        return {
            ped = ped,
            playerServerId = meId,

            vehicle = vehicle,
            vehNet = vehNet,
            vehModel = model,
            promptCoords = closest,
            vehicleDistance = minDist,
            neighbors = neigh,

            nozzle = HoseManager.nozzle,
            nozzleDropped = HoseManager.nozzleDropped,
            currentVehicle = HoseManager.currentVehicle,
            handLineActive = HoseManager.handLine[meId] and true or false,
            currentVehicleRelay = HoseManager.currentVehicleRelay,
            supplyEnabled = IsSupplyLineEnabled(),
        }
    end

    -- Actions you can call from your custom interactions
    HoseCustomActions = {
        GrabHose = function(ctx)
            HoseManager.currentVehicle = ctx.vehicle
            InitializeFireHose()
            AttachRopeToProp()
        end,
        StoreHose = function(ctx)
            if HoseManager.nozzle and HoseManager.currentVehicle == ctx.vehicle and not HoseManager.nozzleDropped then
                UnequipFireHose()
            else
                Notify(ConfigHose.Translations.cannotStoreHoseWhileOnGround)
            end
        end,
        GrabRelay = function(ctx)
            HoseManager.currentVehicleRelay = ctx.vehicle
            InitializeHandLine()
            AttachRopeToHand()
        end,
        StoreRelay = function(_ctx)
            DeinitializeHandLine()
        end,
        ConnectRelayHere = function(ctx)
            DeinitializeHandLine()
            ConnectRelayToVehicle(ctx.vehicle)
        end,
        QuickDisconnectNearest = function(ctx)
            if not ctx.vehNet or #ctx.neighbors == 0 then return end
            local best, bestD, myPos = nil, 1e9, GetEntityCoords(PlayerPedId())
            for _, n in ipairs(ctx.neighbors) do
                local ent = NetEnt(n)
                if ent and DoesEntityExist(ent) then
                    local d = #(myPos - GetEntityCoords(ent))
                    if d < bestD then best, bestD = n, d end
                elseif not best then
                    best = n
                end
            end
            if best then
                local sId, tId = canonicalPair(ctx.vehNet, best)
                DisconnectRelayLine(sId, tId, ctx.vehNet)
            end
        end,
        OpenPanel = function(_ctx)
            OpenControlPanel()
        end
    }

    --   ctx  = _buildCtx(vehicle)         (state for the vehicle/player)
    --   A    = HoseCustomActions          (ready actions)
    -- Draw helpers available: drawInstructionalText() / DisplayHelpText() from this file.
    -- Example below mirrors the original E/G/Z flow aka ConfigHose.TruckInteraction.InteractType.Drawtext.
    if not CustomInteractThink then
        -- CustomInteractThink = function(ctx, A)
        --     local lines = {}

        --     if ctx.nozzle then
        --         if ctx.currentVehicle == ctx.vehicle and not ctx.nozzleDropped then
        --             lines[#lines+1] = ConfigHose.Translations.storeHoseMessage
        --             if IsControlJustReleased(0, ConfigHose.Keys.Interact) then A.StoreHose(ctx) end
        --         else
        --             lines[#lines+1] = ConfigHose.Translations.cannotStoreHoseWhileOnGround
        --         end

        --     elseif ctx.handLineActive then
        --         if ctx.supplyEnabled then
        --             if ctx.currentVehicleRelay == ctx.vehicle then
        --                 if #ctx.neighbors > 0 then lines[#lines+1] = ConfigHose.Translations.disconnectLine end
        --                 lines[#lines+1] = ConfigHose.Translations.storeSupplyLine
        --                 if IsControlJustReleased(0, ConfigHose.Keys.GrabLine) then
        --                     if #ctx.neighbors > 0 then A.QuickDisconnectNearest(ctx) else A.StoreRelay(ctx) end
        --                 end
        --             else
        --                 if #ctx.neighbors > 0 then
        --                     lines[#lines+1] = ConfigHose.Translations.disconnectLine
        --                     if IsControlJustReleased(0, ConfigHose.Keys.GrabLine) then A.QuickDisconnectNearest(ctx) end
        --                 else
        --                     lines[#lines+1] = ConfigHose.Translations.connectRelayLineMessage
        --                     if IsControlJustReleased(0, ConfigHose.Keys.GrabLine) then A.ConnectRelayHere(ctx) end
        --                 end
        --             end
        --         end

        --     else
        --         if ctx.supplyEnabled then
        --             if #ctx.neighbors > 0 then
        --                 lines[#lines+1] = ConfigHose.Translations.grabHoseMessage
        --                 lines[#lines+1] = ConfigHose.Translations.disconnectLine
        --             else
        --                 lines[#lines+1] = ConfigHose.Translations.grabHoseMessage
        --                 lines[#lines+1] = ConfigHose.Translations.SupplyLine
        --             end
        --         else
        --             lines[#lines+1] = ConfigHose.Translations.grabHoseMessage
        --         end

        --         if IsControlJustReleased(0, ConfigHose.Keys.Interact) then A.GrabHose(ctx) end
        --         if ctx.supplyEnabled and IsControlJustReleased(0, ConfigHose.Keys.GrabLine) then A.GrabRelay(ctx) end
        --     end

        --     -- SHS Panel 
        --     if not ctx.nozzle and ctx.supplyEnabled then
        --         local showPanelHint = (ctx.handLineActive and ctx.currentVehicleRelay == ctx.vehicle) or (not ctx.nozzle and not ctx.handLineActive)
        --         if showPanelHint then
        --             lines[#lines+1] = ConfigHose.Translations.interactDisplay
        --             if IsControlJustReleased(0, ConfigHose.Keys.OpenDisplayPrompt) then A.OpenPanel(ctx) end
        --         end
        --     end

        --     if #lines > 0 then drawInstructionalText(table.concat(lines, "\n"), ctx.promptCoords) end
        -- end

        CustomInteractThink = function(ctx, A)
            -- Write logic here
            -- ctx = live state for the closest fire vehicle
            -- A   = actions you can call
        end
    end

    CreateThread(function()
        while true do
            Wait(1)

            local ped = PlayerPedId()
            if IsPedInAnyVehicle(ped, false) then
                Wait(500)
            else
                local pos = GetEntityCoords(ped)
                local vehicle = GetClosestVehicle(pos)

                if vehicle and DoesEntityExist(vehicle) and IsVehicleDriveable(vehicle, false) and HasWaterTank(vehicle) then
                    local ctx = _buildCtx(vehicle)
                    if ctx.vehicleDistance < 3.0 then
                        local ok, err = pcall(CustomInteractThink, ctx, HoseCustomActions)
                        if not ok then print("^1[CustomInteract] error:^0", err) end
                    else
                        Wait(250)
                    end
                else
                    Wait(750)
                end
            end
        end
    end)
end