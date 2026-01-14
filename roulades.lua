local Config = {
    BlockedWeapons = {
        '',
    },

    AlsoBlockMeleeWhileAiming = true,

    DebugNotify = false
}

local BLOCKED_SET = {}
for _, name in ipairs(Config.BlockedWeapons) do
    BLOCKED_SET[GetHashKey(name)] = true
end

local function isBlockedWeapon(hash)
    return BLOCKED_SET[hash] == true
end

local function notifyOnce(txt)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(txt)
    EndTextCommandThefeedPostTicker(false, false)
end

CreateThread(function()
    local playerId = PlayerId()
    while true do
        local ped = PlayerPedId()

        if IsPedOnFoot(ped) and not IsEntityDead(ped) then
            local weap = GetSelectedPedWeapon(ped)

            if isBlockedWeapon(weap) and (IsPedAiming(ped) or IsPlayerFreeAiming(playerId)) then
                DisableControlAction(0, 22, true)

                if Config.AlsoBlockMeleeWhileAiming then
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 141, true)
                    DisableControlAction(0, 142, true)
                end

                if Config.DebugNotify and IsDisabledControlJustPressed(0, 22) then
                    notifyOnce("~r~Roulade interdite avec cette arme.")
                end

                Wait(0)
            else
                Wait(150)
            end
        else
            Wait(300)
        end
    end
end)