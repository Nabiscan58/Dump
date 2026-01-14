local AnimationDuration = -1
local ChosenAnimation = ""
local ChosenDict = ""
IsInAnimation = false
local MostRecentChosenAnimation = ""
local MostRecentChosenDict = ""
local MovementType = 0
local PlayerGender = "male"
local PlayerHasProp = false
local PlayerProps = {}
local PlayerParticles = {}
local SecondPropEmote = false
local PtfxNotif = false
local PtfxPrompt = false
local PtfxWait = 500
local PtfxNoProp = false
local AnimationThreadStatus = false
local CanCancel = true
local InExitEmote = false
local lasteCommand = nil
IsInAnimation = false

Citizen.CreateThread(function()
    Citizen.Wait(10 * 1000)
    local favWalk = GetResourceKvpString("favoriteWalk")

    local ped = PlayerPedId()
	if favWalk then
		RequestDemarcheThing(favWalk)
		SetPedMovementClipset(ped, favWalk, 0.2)
		RemoveAnimSet(favWalk)
	end

	local haveFavorite = GetResourceKvpString("favoritehumor")
	if haveFavorite then
		EmoteMenuStart(tostring(haveFavorite), "expression")
	end

    while true do
        local near = false
        
        if IsPedShooting(ped) and IsInAnimation then
            EmoteCancel()
        end
        if PtfxPrompt then
            near = true
            if not PtfxNotif then
                SimpleNotify(PtfxInfo)
                PtfxNotif = true
            end
            if IsControlPressed(0, 47) then
                PtfxStart()
                Wait(PtfxWait)
                PtfxStopDP()
            end
        end
       

        if near then 
            Wait(1)
        else
            Wait(1000)
        end
    end
end)


CreateThread(function ()
    while true do 
        Wait(30000)
        local favWalk = GetResourceKvpString("favoriteWalk")
        local ped = PlayerPedId()
        if favWalk then
            RequestDemarcheThing(favWalk)
            SetPedMovementClipset(ped, favWalk, 0.2)
            RemoveAnimSet(favWalk)
        end

        local haveFavorite = GetResourceKvpString("favoritehumor")
        if haveFavorite then
            EmoteMenuStart(tostring(haveFavorite), "expression")
        end
    end
end)
Citizen.CreateThread(function()
    TriggerEvent('chat:addSuggestion', '/e', 'Play an emote', { { name = "emotename", help = "dance, camera, sit or any valid emote." } })
    TriggerEvent('chat:addSuggestion', '/emote', 'Play an emote', { { name = "emotename", help = "dance, camera, sit or any valid emote." } })
    if CFGDPEMOTES.SqlKeybinding then
        TriggerEvent('chat:addSuggestion', '/emotebind', 'Bind an emote', { { name = "key", help = "num4, num5, num6, num7. num8, num9. Numpad 4-9!" }, { name = "emotename", help = "dance, camera, sit or any valid emote." } })
        TriggerEvent('chat:addSuggestion', '/emotebinds', 'Check your currently bound emotes.')
    end
    TriggerEvent('chat:addSuggestion', '/emotemenu', 'Open dpemotes menu (F5) by default.')
    TriggerEvent('chat:addSuggestion', '/emotes', 'List available emotes.')
    TriggerEvent('chat:addSuggestion', '/walk', 'Set your walkingstyle.', { { name = "style", help = "/walks for a list of valid styles" } })
    TriggerEvent('chat:addSuggestion', '/walks', 'List available walking styles.')
end)

RegisterCommand('e', function(source, args, raw)
    EmoteCommandStart(source, args, raw)
end)
RegisterCommand('emote', function(source, args, raw) EmoteCommandStart(source, args, raw) end)
if CFGDPEMOTES.SqlKeybinding then
    RegisterCommand('emotebind', function(source, args, raw) EmoteBindStart(source, args, raw) end)
    RegisterCommand('emotebinds', function(source, args, raw) EmoteBindsStart(source, args, raw) end)
end
-- RegisterCommand('emotemenu', function(source, args, raw) OpenEmoteMenu() end)
RegisterCommand('emotes', function(source, args, raw) EmotesOnCommand() end)
RegisterCommand('walk', function(source, args, raw) WalkCommandStart(source, args, raw) end)
RegisterCommand('walks', function(source, args, raw) WalksOnCommand() end)

RegisterNetEvent("dpemotes:askOtherEmote")
AddEventHandler("dpemotes:askOtherEmote", function(sourceId)
    if lasteCommand == nil then return end
    TriggerServerEvent("dpemotes:sendOtherEmote", lasteCommand, sourceId)
end)

RegisterNetEvent("dpemotes:playOtherEmote")
AddEventHandler("dpemotes:playOtherEmote", function(eName)
    if eName == nil then return end
    ExecuteCommand("e "..eName)
end)

AddEventHandler('onResourceStop', function(resource)
    local ped = PlayerPedId()
    if resource == GetCurrentResourceName() then
        DestroyAllPropsDP()
        ClearPedTasksImmediately(ped)
        ResetPedMovementClipset(ped)
    end
end)

RegisterNetEvent("dpemotes:cancelEmote")
AddEventHandler("dpemotes:cancelEmote", function()
    EmoteCancel()
    DestroyAllPropsDP()
end)

function EmoteCancel(force)
    if exports.property:takedBox() then return end
    if exports.various_items:UsingGilet() then return end
    if exports.rems:isUsingEMSItem() then return end
    if takedBox() then return end

    if InExitEmote then
        return
    end

    local ply = PlayerPedId()
	if not CanCancel and force ~= true then
        return
    end
    if ChosenDict == "MaleScenario" and IsInAnimation then
        ClearPedTasksImmediately(ply)
        IsInAnimation = false
        DebugPrint("Forced scenario exit")
    elseif ChosenDict == "Scenario" and IsInAnimation then
        ClearPedTasksImmediately(ply)
        IsInAnimation = false
        DebugPrint("Forced scenario exit")
    end

    PtfxNotif = false
    PtfxPrompt = false
	Pointing = false

    if IsInAnimation then
        if LocalPlayer.state.ptfx then
            PtfxStop()
        end
        DetachEntity(ply, true, false)
        CancelSharedEmote(ply)

        if ChosenAnimOptions and ChosenAnimOptions.ExitEmote then
            -- If the emote exit type is not spesifed it defaults to Emotes
            local options = ChosenAnimOptions
            local ExitEmoteType = options.ExitEmoteType or "Emotes"

            -- Checks that the exit emote actually exists
            if not RP[ExitEmoteType] or not RP[ExitEmoteType][options.ExitEmote] then
                DebugPrint("Exit emote was invalid")
                ClearPedTasks(ply)
                IsInAnimation = false
                return
            end

            OnEmotePlay(RP[ExitEmoteType][options.ExitEmote])
            DebugPrint("Playing exit animation")

            -- Check that the exit emote has a duration, and if so, set InExitEmote variable
            local animationOptions = RP[ExitEmoteType][options.ExitEmote].AnimationOptions
            if animationOptions and animationOptions.EmoteDuration then
                InExitEmote = true
                SetTimeout(animationOptions.EmoteDuration, function()
                    InExitEmote = false
                    DestroyAllPropsDP()
                    ClearPedTasks(ply)
                end)
                return
            end
        else
            ClearPedTasks(ply)
            IsInAnimation = false
        end
        DestroyAllPropsDP()
    end
    AnimationThreadStatus = false
end

IsPlayingAnim = function()
    return IsInAnimation
end

function EmoteChatMessage(args)
    if args == display then
        TriggerEvent("chatMessage", "^5Help^0", { 0, 0, 0 }, string.format(""))
    else
        TriggerEvent("chatMessage", "^5Help^0", { 0, 0, 0 }, string.format("" .. args .. ""))
    end
end

function DebugPrint(args)
    if CFGDPEMOTES.DebugDisplay then
        print(args)
    end
end

function PtfxStart()
    if PtfxNoProp then
        PtfxAt = PlayerPedId()
    else
        PtfxAt = prop
    end
    UseParticleFxAssetNextCall(PtfxAsset)
    Ptfx = StartNetworkedParticleFxLoopedOnEntityBone(PtfxName, PtfxAt, Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, GetEntityBoneIndexByName(PtfxName, "VFX"), 1065353216, 0, 0, 0, 1065353216, 1065353216, 1065353216, 0)
    SetParticleFxLoopedColour(Ptfx, 1.0, 1.0, 1.0)
    table.insert(PlayerParticles, Ptfx)
end

function PtfxStopDP()
    for a, b in pairs(PlayerParticles) do
        DebugPrint("Stopped PTFX: " .. b)
        StopParticleFxLooped(b, false)
        table.remove(PlayerParticles, a)
    end
end

function EmotesOnCommand(source, args, raw)
    local EmotesCommand = ""
    for a in pairsByKeys(DP.Emotes) do
        EmotesCommand = EmotesCommand .. "" .. a .. ", "
    end
    EmoteChatMessage(EmotesCommand)
    EmoteChatMessage(CFGDPEMOTES.Languages[lang]['emotemenucmd'])
end

function pairsByKeys(t, f)
    local a = {}
    for n in pairs(t) do
        table.insert(a, n)
    end
    table.sort(a, f)
    local i = 0 -- iterator variable
    local iter = function() -- iterator function
        i = i + 1
        if a[i] == nil then
            return nil
        else
            return a[i], t[a[i]]
        end
    end
    return iter
end

function EmoteMenuStart(args, hard)
    local name = args
    local etype = hard

    if etype == "dances" then
        if DP.Dances[name] ~= nil then
            if OnEmotePlay(DP.Dances[name], name) then end
        end
    elseif etype == "animals" then
        if DP.AnimalEmotes[name] ~= nil then
            if OnEmotePlay(DP.AnimalEmotes[name], name) then end
        end
    elseif etype == "props" then
        if DP.PropEmotes[name] ~= nil then
            if OnEmotePlay(DP.PropEmotes[name], name) then end
        end
    elseif etype == "emotes" then
        if DP.Emotes[name] ~= nil then
            if OnEmotePlay(DP.Emotes[name], name) then end
        else
            if name ~= "🕺 Dance Emotes" then end
        end
    elseif etype == "sit" then
        if DP.Sits[name] ~= nil then
            if OnEmotePlay(DP.Sits[name], name) then end
        end
    elseif etype == "pegi" then
        if DP.Pegi[name] ~= nil then
            if OnEmotePlay(DP.Pegi[name], name) then end
        end
    elseif etype == "sports" then
        if DP.Sports[name] ~= nil then
            if OnEmotePlay(DP.Sports[name], name) then end
        end
    elseif etype == "vehicle" then
        if DP.VehicleAnimations[name] ~= nil then
            if OnEmotePlay(DP.VehicleAnimations[name], name) then end
        end
    elseif etype == "salutes" then
        if DP.Salutes[name] ~= nil then
            if OnEmotePlay(DP.Salutes[name], name) then end
        end
    elseif etype == "poses" then
        if DP.Poses[name] ~= nil then
            if OnEmotePlay(DP.Poses[name], name) then end
        end
    elseif etype == "gangs" then
        if DP.Gangs[name] ~= nil then
            if OnEmotePlay(DP.Gangs[name], name) then end
        end
    elseif etype == "expression" then
        if DP.Expressions[name] ~= nil then
            if OnEmotePlay(DP.Expressions[name], name) then end
        end
    end
end

function EmoteCommandStart(source, args, raw)
    local ped = PlayerPedId()
    if IsPedBlockedForEmote(ped) then
        return
    end

    if IsPedFalling(ped) then return end
    if IsPedDeadOrDying(ped, false) then return end

    if #args > 0 then
        local name = string.lower(args[1])
        if name == "c" then
            if IsInAnimation or IsEntityPositionFrozen(ped) then
                EmoteCancel()
            else
                EmoteChatMessage(CFGDPEMOTES.Languages[lang]['nocancel'])
            end
            return
        elseif name == "help" then
            EmotesOnCommand()
            return
        end

        if IsInAnimation or IsEntityPositionFrozen(ped) then
            EmoteCancel()
            return
        end

        if DP.Emotes[name] ~= nil then
            if OnEmotePlay(DP.Emotes[name], name) then end
            return
        elseif DP.Sits[name] ~= nil then
            if OnEmotePlay(DP.Sits[name], name) then end
            return
        elseif DP.Pegi[name] ~= nil then
            if OnEmotePlay(DP.Pegi[name], name) then end
            return
        elseif DP.Sports[name] ~= nil then
            if OnEmotePlay(DP.Sports[name], name) then end
            return
        elseif DP.VehicleAnimations[name] ~= nil then
            if OnEmotePlay(DP.VehicleAnimations[name], name) then end
            return
        elseif DP.Salutes[name] ~= nil then
            if OnEmotePlay(DP.Salutes[name], name) then end
            return
        elseif DP.Poses[name] ~= nil then
            if OnEmotePlay(DP.Poses[name], name) then end
            return
        elseif DP.Gangs[name] ~= nil then
            if OnEmotePlay(DP.Gangs[name], name) then end
            return
        elseif DP.Dances[name] ~= nil then
            if OnEmotePlay(DP.Dances[name], name) then end
            return
        elseif DP.AnimalEmotes[name] ~= nil then
            if OnEmotePlay(DP.AnimalEmotes[name], name) then end
            return
        elseif DP.PropEmotes[name] ~= nil then
            if OnEmotePlay(DP.PropEmotes[name], name) then end
            return
        else
            return
            --EmoteChatMessage("'" .. name .. "' " .. CFGDPEMOTES.Languages[lang]['notvalidemote'] .. "")
        end
    end
end

function LoadDpemotesAnim(dict)
    if not DoesAnimDictExist(dict) then
        return false
    end

    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end

    return true
end

function LoadPropDict(model)
    while not HasModelLoaded(GetHashKey(model)) do
        RequestModel(GetHashKey(model))
        Wait(10)
    end
end

function PtfxThisDP(asset)
    while not HasNamedPtfxAssetLoaded(asset) do
        RequestNamedPtfxAsset(asset)
        Wait(10)
    end
    UseParticleFxAssetNextCall(asset)
end

function DestroyAllPropsDP()
    for _, v in pairs(PlayerProps) do
        DeleteEntity(v)
    end
    PlayerHasProp = false
    DebugPrint("Destroyed Props")
end

function AddPropToPlayerDP(prop1, bone, off1, off2, off3, rot1, rot2, rot3)
    local Player = PlayerPedId()
    local x, y, z = table.unpack(GetEntityCoords(Player))

    if not HasModelLoaded(prop1) then
        LoadPropDict(prop1)
    end

    prop = CreateObject(GetHashKey(prop1), x, y, z + 0.2, true, true, true)
    AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, bone), off1, off2, off3, rot1, rot2, rot3, true, true, false, true, 1, true)
    table.insert(PlayerProps, prop)
    PlayerHasProp = true
    SetModelAsNoLongerNeeded(prop1)
end

-----------------------------------------------------------------------------------------------------
-- V -- This could be a whole lot better, i tried messing around with "IsPedMale(ped)"
-- V -- But i never really figured it out, if anyone has a better way of gender checking let me know.
-- V -- Since this way doesnt work for ped models.
-- V -- in most cases its better to replace the scenario with an animation bundled with prop instead.
-----------------------------------------------------------------------------------------------------

function CheckGender()
    local hashSkinMale = GetHashKey("mp_m_freemode_01")
    local hashSkinFemale = GetHashKey("mp_f_freemode_01")
    local ped = PlayerPedId()

    if GetEntityModel(ped) == hashSkinMale then
        PlayerGender = "male"
    elseif GetEntityModel(ped) == hashSkinFemale then
        PlayerGender = "female"
    end
    DebugPrint("Set gender as = (" .. PlayerGender .. ")")
end

-----------------------------------------------------------------------------------------------------
------ This is the major function for playing emotes! -----------------------------------------------
-----------------------------------------------------------------------------------------------------

local currentEmote = {}

exports('getCurrentEmoteTT', function()
	return currentEmote
end)

function IsPedBlockedForEmote(ped)
    if IsEntityDead(ped) then
        return true
    end
    if IsPedDeadOrDying(ped, true) then
        return true
    end
    if IsPedRagdoll(ped) then
        return true
    end
    if IsPedFalling(ped) then
        return true
    end
    if IsPedInParachuteFreeFall(ped) then
        return true
    end
    if IsPedGettingIntoAVehicle(ped) then
        return true
    end
    return false
end

function OnEmotePlay(EmoteName, eName)
    local playerPed = PlayerPedId()
    if IsPedBlockedForEmote(playerPed) then
        return
    end

    if exports.gunfight:IsInGunFightZone() then return end
    if exports.property:takedBox() then return end
    if exports.various_items:UsingGilet() then return end
    if exports.rems:isUsingEMSItem() then return end
    if takedBox() then return end
    local playerPed = PlayerPedId()
    if IsPedInAnyVehicle(playerPed, false) then
        local vehicle = GetVehiclePedIsIn(playerPed, false)
        local driver = GetPedInVehicleSeat(vehicle, -1)
    
        if driver == playerPed then
            return
        end
    end
    local currentEmoteTable = EmoteName
    for _, tabledata in pairs(DP) do
        for command, emotedata in pairs(tabledata) do
            if emotedata == EmoteName then
                table.insert(currentEmoteTable, command)
                break
            end
        end
    end
    currentEmote = currentEmoteTable

    InVehicle = IsPedInAnyVehicle(PlayerPedId(), true)
    if not CFGDPEMOTES.AllowedInCars and InVehicle == 1 then
        return
    end

    if not DoesEntityExist(PlayerPedId()) then
        return false
    end

    if CFGDPEMOTES.DisarmPlayer then
        if IsPedArmed(PlayerPedId(), 7) then
            SetCurrentPedWeapon(PlayerPedId(), GetHashKey('WEAPON_UNARMED'), true)
        end
    end
    
    ChosenDict, ChosenAnimation, ename = table.unpack(EmoteName)

    lasteCommand = eName
    
    AnimationDuration = -1

    if PlayerHasProp then
        DestroyAllPropsDP()
    end

    if ChosenDict == "Expression" then
        SetFacialIdleAnimOverride(PlayerPedId(), ChosenAnimation, 0)
        return
    end

    if ChosenDict == "MaleScenario" or "Scenario" then
        CheckGender()
        if ChosenDict == "MaleScenario" then if InVehicle then return end
            if PlayerGender == "male" then
                ClearPedTasks(PlayerPedId())
                TaskStartScenarioInPlace(PlayerPedId(), ChosenAnimation, 0, true)
                DebugPrint("Playing scenario = (" .. ChosenAnimation .. ")")
                IsInAnimation = true
            else
                EmoteChatMessage(CFGDPEMOTES.Languages[lang]['maleonly'])
            end
            return
        elseif ChosenDict == "ScenarioObject" then if InVehicle then return end
            BehindPlayer = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0 - 0.5, -0.5);
            ClearPedTasks(PlayerPedId())
            TaskStartScenarioAtPosition(PlayerPedId(), ChosenAnimation, BehindPlayer['x'], BehindPlayer['y'], BehindPlayer['z'], GetEntityHeading(PlayerPedId()), 0, 1, false)
            DebugPrint("Playing scenario = (" .. ChosenAnimation .. ")")
            IsInAnimation = true
            return
        elseif ChosenDict == "Scenario" then if InVehicle then return end
            ClearPedTasks(PlayerPedId())
            TaskStartScenarioInPlace(PlayerPedId(), ChosenAnimation, 0, true)
            DebugPrint("Playing scenario = (" .. ChosenAnimation .. ")")
            IsInAnimation = true
            return
        end
    end

    ChosenDict = tostring(ChosenDict)
    ChosenDict = ChosenDict:lower()

    if not LoadDpemotesAnim(ChosenDict) then
        print(ChosenDict, "ChosenDict is bad :(")
        return
    end

    if EmoteName.AnimationOptions then
        if EmoteName.AnimationOptions.EmoteLoop then
            MovementType = 1
            if EmoteName.AnimationOptions.EmoteMoving then
                MovementType = 51
            end

        elseif EmoteName.AnimationOptions.EmoteMoving then
            MovementType = 51
        elseif EmoteName.AnimationOptions.EmoteMoving == false then
            MovementType = 0
        elseif EmoteName.AnimationOptions.EmoteStuck then
            MovementType = 50
        end

    else
        MovementType = 0
    end

    --if InVehicle == 1 then -- TO ALLOW VEHICLE ANIMATIONS
    --    MovementType = 51
    --end

    if EmoteName.AnimationOptions then
        if EmoteName.AnimationOptions.EmoteDuration == nil then
            EmoteName.AnimationOptions.EmoteDuration = -1
            AttachWait = 0
        else
            AnimationDuration = EmoteName.AnimationOptions.EmoteDuration
            AttachWait = EmoteName.AnimationOptions.EmoteDuration
        end

        if EmoteName.AnimationOptions.PtfxAsset then
            PtfxAsset = EmoteName.AnimationOptions.PtfxAsset
            PtfxName = EmoteName.AnimationOptions.PtfxName
            if EmoteName.AnimationOptions.PtfxNoProp then
                PtfxNoProp = EmoteName.AnimationOptions.PtfxNoProp
            else
                PtfxNoProp = false
            end
            Ptfx1, Ptfx2, Ptfx3, Ptfx4, Ptfx5, Ptfx6, PtfxScale = table.unpack(EmoteName.AnimationOptions.PtfxPlacement)
            PtfxInfo = EmoteName.AnimationOptions.PtfxInfo
            PtfxWait = EmoteName.AnimationOptions.PtfxWait
            PtfxNotif = false
            PtfxPrompt = true
            PtfxThisDP(PtfxAsset)
        else
            DebugPrint("Ptfx = none")
            PtfxPrompt = false
        end
    end
    TaskPlayAnim(PlayerPedId(), ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
    RemoveAnimDict(ChosenDict)
    IsInAnimation = true
    MostRecentDict = ChosenDict
    MostRecentAnimation = ChosenAnimation

    if EmoteName.AnimationOptions then
        if EmoteName.AnimationOptions.Prop then
            PropName = EmoteName.AnimationOptions.Prop
            PropBone = EmoteName.AnimationOptions.PropBone
            PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6 = table.unpack(EmoteName.AnimationOptions.PropPlacement)
            if EmoteName.AnimationOptions.SecondProp then
                SecondPropName = EmoteName.AnimationOptions.SecondProp
                SecondPropBone = EmoteName.AnimationOptions.SecondPropBone
                SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6 = table.unpack(EmoteName.AnimationOptions.SecondPropPlacement)
                SecondPropEmote = true
            else
                SecondPropEmote = false
            end
            Wait(AttachWait)
            AddPropToPlayerDP(PropName, PropBone, PropPl1, PropPl2, PropPl3, PropPl4, PropPl5, PropPl6)
            if SecondPropEmote then
                AddPropToPlayerDP(SecondPropName, SecondPropBone, SecondPropPl1, SecondPropPl2, SecondPropPl3, SecondPropPl4, SecondPropPl5, SecondPropPl6)
            end
        end
    end
    return true
end

local ADJUST_STEP = 0.01
local ADJUST_STEP_FAST = 0.05
local ADJUST_MAX_DIST = 5.0
local ADJUST_ROTATE_SPEED = 1.0

local isAdjusting = false

local function ShowAdjustHelp()
    ESX.ShowHelpNotification(
        "~b~[Ajustement emote]\n~s~" ..
        "↑ ↓ → ← : déplacer\n" ..
        "Q / E : rotation\n" ..
        "PageUp / PageDown : hauteur\n" ..
        "SHIFT : déplacement rapide\n" ..
        "ENTRÉE : valider\n" ..
        "BACKSPACE : annuler"
    )
end

RegisterCommand('ajuster', function(source, args, raw)
    local ped = PlayerPedId()

    if not IsInAnimation then
        EmoteChatMessage("Tu ne joues aucune emote actuellement.")
        return
    end

    if IsPedBlockedForEmote(ped) then
        EmoteChatMessage("Ton état ne permet pas d'ajuster l'emote.")
        return
    end

    if IsPedInAnyVehicle(ped, false) then
        return
    end

    if isAdjusting then
        EmoteChatMessage("Tu es déjà en train d'ajuster une emote.")
        return
    end

    if not currentEmote or type(currentEmote) ~= "table" or not currentEmote[1] or not ChosenDict or not ChosenAnimation then
        EmoteChatMessage("Aucune emote valide à ajuster.")
        return
    end

    local startPos = GetEntityCoords(ped)
    local startHeading = GetEntityHeading(ped)

    isAdjusting = true

    FreezeEntityPosition(ped, true)

    local clonePed = ClonePed(ped, false, true, true)

    SetEntityCoordsNoOffset(clonePed, startPos.x, startPos.y, startPos.z, false, false, false)
    SetEntityHeading(clonePed, startHeading)

    SetEntityAlpha(clonePed, 150, false)
    SetEntityInvincible(clonePed, true)
    SetEntityCollision(clonePed, false, false)
    SetEntityNoCollisionEntity(ped, clonePed, true)
    SetEntityNoCollisionEntity(clonePed, ped, true)
    FreezeEntityPosition(clonePed, true)

    ClearPedTasksImmediately(clonePed)

    if LoadDpemotesAnim(ChosenDict) then
        TaskPlayAnim(clonePed, ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
    end

    local currentHeading = startHeading
    local offsetX = 0.0
    local offsetY = 0.0
    local heightOffset = 0.0

    CreateThread(function()
        local confirmed = false
        local cancelled = false

        while isAdjusting do
            DisableControlAction(0, 30, true)
            DisableControlAction(0, 31, true)
            DisableControlAction(0, 32, true)
            DisableControlAction(0, 33, true)
            DisableControlAction(0, 34, true)
            DisableControlAction(0, 35, true)

            ShowAdjustHelp()

            if not IsEntityPlayingAnim(clonePed, ChosenDict, ChosenAnimation, 3) then
                TaskPlayAnim(clonePed, ChosenDict, ChosenAnimation, 2.0, 2.0, AnimationDuration, MovementType, 0, false, false, false)
            end

            local step = ADJUST_STEP
            if IsControlPressed(0, 21) then
                step = ADJUST_STEP_FAST
            end

            local rad = math.rad(currentHeading)
            local forwardX = math.sin(rad)
            local forwardY = math.cos(rad)
            local rightX = forwardY
            local rightY = -forwardX

            local moved = false

            if IsControlPressed(0, 172) then
                offsetX = offsetX + forwardX * step
                offsetY = offsetY + forwardY * step
                moved = true
            end
            if IsControlPressed(0, 173) then
                offsetX = offsetX - forwardX * step
                offsetY = offsetY - forwardY * step
                moved = true
            end
            if IsControlPressed(0, 174) then
                offsetX = offsetX - rightX * step
                offsetY = offsetY - rightY * step
                moved = true
            end
            if IsControlPressed(0, 175) then
                offsetX = offsetX + rightX * step
                offsetY = offsetY + rightY * step
                moved = true
            end

            if IsControlPressed(0, 44) then
                currentHeading = currentHeading - ADJUST_ROTATE_SPEED
            end
            if IsControlPressed(0, 38) then
                currentHeading = currentHeading + ADJUST_ROTATE_SPEED
            end

            if IsControlPressed(0, 10) then
                heightOffset = heightOffset + step
                moved = true
            end
            if IsControlPressed(0, 11) then
                heightOffset = heightOffset - step
                moved = true
            end

            if currentHeading < 0.0 then
                currentHeading = currentHeading + 360.0
            elseif currentHeading >= 360.0 then
                currentHeading = currentHeading - 360.0
            end

            local newX = startPos.x + offsetX
            local newY = startPos.y + offsetY
            local newZ = startPos.z + heightOffset

            local dx = newX - startPos.x
            local dy = newY - startPos.y
            local dz = newZ - startPos.z
            local dist = math.sqrt(dx * dx + dy * dy + dz * dz)

            if moved then
                if dist <= ADJUST_MAX_DIST then
                    SetEntityCoordsNoOffset(clonePed, newX, newY, newZ, false, false, false)
                else
                    local factor = ADJUST_MAX_DIST / dist
                    offsetX = offsetX * factor
                    offsetY = offsetY * factor
                    heightOffset = heightOffset * factor
                    newX = startPos.x + offsetX
                    newY = startPos.y + offsetY
                    newZ = startPos.z + heightOffset
                    SetEntityCoordsNoOffset(clonePed, newX, newY, newZ, false, false, false)
                end
            end

            SetEntityHeading(clonePed, currentHeading)

            if IsControlJustPressed(0, 201) then
                confirmed = true
                break
            end

            if IsControlJustPressed(0, 177) then
                cancelled = true
                break
            end

            Wait(0)
        end

        isAdjusting = false

        if DoesEntityExist(clonePed) then
            DeletePed(clonePed)
        end

        FreezeEntityPosition(ped, false)

        if cancelled then
            SetEntityCoordsNoOffset(ped, startPos.x, startPos.y, startPos.z, false, false, false)
            SetEntityHeading(ped, startHeading)
            ClearPedTasksImmediately(ped)
            Wait(10)
            OnEmotePlay(currentEmote, lasteCommand)
            EmoteChatMessage("Ajustement annulé.")
            return
        end

        if confirmed then
            local finalX = startPos.x + offsetX
            local finalY = startPos.y + offsetY
            local finalZ = startPos.z + heightOffset

            local dx = finalX - startPos.x
            local dy = finalY - startPos.y
            local dz = finalZ - startPos.z
            local dist = math.sqrt(dx * dx + dy * dy + dz * dz)

            if dist > ADJUST_MAX_DIST then
                SetEntityCoordsNoOffset(ped, startPos.x, startPos.y, startPos.z, false, false, false)
                SetEntityHeading(ped, startHeading)
                ClearPedTasksImmediately(ped)
                Wait(10)
                OnEmotePlay(currentEmote, lasteCommand)
                EmoteChatMessage(("Tu t'es déplacé trop loin (%.1fm), ajustement annulé."):format(dist))
                return
            end

            SetEntityCoordsNoOffset(ped, finalX, finalY, finalZ, false, false, false)
            SetEntityHeading(ped, currentHeading)
            ClearPedTasksImmediately(ped)
            Wait(10)
            OnEmotePlay(currentEmote, lasteCommand)
        end
    end)
end)