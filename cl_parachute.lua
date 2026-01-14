RegisterNetEvent("rgCore:parachute", function()
    SetPedGadget(ped, 0xfbab5776, true)
    SetPlayerHasReserveParachute(PlayerId())
    GiveWeaponToPed(GetPlayerPed(-1), GetHashKey("gadget_parachute"), 1, false, false)

end)