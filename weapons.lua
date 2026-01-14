AddEventHandler('gameEventTriggered', function(name, args)
	if name == 'CEventNetworkEntityDamage' then
		if args[7] == GetHashKey('WEAPON_BEANBAG') and args[1] == PlayerPedId() then
			ClearEntityLastDamageEntity(PlayerPedId())
			SetTimecycleModifier("REDMIST_blend")
			ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)

			local time = GetGameTimer() + 7 * 1000
			Citizen.CreateThread(function()
				while time > GetGameTimer() do
					SetPedToRagdoll(PlayerPedId(), 100, 100, 0)
					Citizen.Wait(0)
				end
			end)

			Citizen.Wait(4000)
			SetTransitionTimecycleModifier("hud_def_desat_Trevor", 2.5)
			Citizen.Wait(3000)
			SetTransitionTimecycleModifier('default', 2.5)
			Citizen.Wait(500)
			ClearTimecycleModifier()
			StopGameplayCamShaking()
		end
	end
end)