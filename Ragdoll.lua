local isInRagdoll = false

RegisterCommand("ragdollme", function()
    if IsPedOnFoot(PlayerPedId()) then
	    if isInRagdoll then
            isInRagdoll = false
        else
            isInRagdoll = true

            Citizen.CreateThread(function()
                while isInRagdoll do
                    SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
                    Citizen.Wait(0)
                end
            end)

            Wait(500)
        end
    end
end, false)
RegisterKeyMapping('ragdollme', 'Raccourci Ragdoll', 'keyboard', '')