local cooldown = 0

local smokeBone = 20279
local smokeAsset = "core"
local smokeParticle = "exp_grd_bzgas_smoke"

local puffAnimDict = "mp_player_inteat@burger"
local puffAnim = "mp_player_int_eat_burger"

local function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

RegisterNetEvent("puff:start", function()
    if GetGameTimer() < cooldown then return ESX.ShowNotification("~r~Attendez 3 secondes entre chaque puff") end

    cooldown = GetGameTimer() + 3000
    local ped = PlayerPedId()

    LoadAnimDict(puffAnimDict)
    TaskPlayAnim(ped, puffAnimDict, puffAnim, 8.0, -8.0, 1500, 49, 0, false, false, false)

    PlaySoundFrontend(-1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)

	local closestPlayer = lib.getClosestPlayer(GetEntityCoords(ped), 7.0, true)
	if closestPlayer then
    	TriggerServerEvent("eff_smokes", PedToNet(ped), closestPlayer)
	end

    Wait(2800)
    ClearPedTasks(ped)
end)

RegisterNetEvent("c_eff_smokes", function(pedNet)
	print("display effect smoke")
    local ped = NetToPed(pedNet)
    if not DoesEntityExist(ped) then return end

	Wait(300)
    UseParticleFxAssetNextCall(smokeAsset)
    local fx = StartParticleFxLoopedOnEntityBone(smokeParticle, ped, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPedBoneIndex(ped, smokeBone), 2.5, false, false, false)
    
    Wait(3500)
    StopParticleFxLooped(fx, 1)
    RemoveParticleFxFromEntity(ped)
end)