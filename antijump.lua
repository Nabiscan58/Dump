
local ragdoll_chance = 0.4

Citizen.CreateThread(function()
	while true do
		local possible = false
		local ped = PlayerPedId()
		if IsPedOnFoot(ped) and not IsPedSwimming(ped) and (IsPedRunning(ped) or IsPedSprinting(ped)) and not IsPedClimbing(ped) and IsPedJumping(ped) and not IsPedRagdoll(ped) then
			possible = true
			local chance_result = math.random()
			if chance_result < ragdoll_chance then 
				Citizen.Wait(600)
                ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.08)
				SetPedToRagdoll(ped, 5000, 1, 2)
			else
				Citizen.Wait(2000)
			end
		end
		if possible then
			Citizen.Wait(0)
		else
			Citizen.Wait(5000)
		end
	end
end)

Citizen.CreateThread(function()
	SetWeaponsNoAutoswap(true)
end)