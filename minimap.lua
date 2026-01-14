-- Citizen.CreateThread(function()
--     while true do

--         DisplayRadar(true)

--         Citizen.Wait(1000)
--     end
-- end)

local FuelStations = {
    vector3(-72.949676513672, -1761.9945068359, 29.449575424194),
    vector3(175.3191986084, -1562.3745117188, 29.265085220337),
    vector3(265.66522216797, -1259.162109375, 29.142902374268),
    vector3(-318.10702514648, -1468.3903808594, 30.547063827515),
    vector3(-526.21423339844, -1206.7066650391, 18.329069137573),
    vector3(-721.93829345703, -935.22900390625, 19.017053604126),
    vector3(-2098.8615722656, -320.41018676758, 13.025465965271),
    vector3(-1799.8770751953, 801.12030029297, 138.51513671875),
    vector3(619.83850097656, 266.01623535156, 103.0894241333),
    vector3(1181.1540527344, -330.78674316406, 69.319580078125),
    vector3(1208.7867431641, -1402.3703613281, 35.224159240723),
    vector3(2577.5993652344, 364.28994750977, 108.45739746094),
    vector3(2680.6550292969, 3264.3952636719, 55.24471282959),
    vector3(2005.0419921875, 3774.2270507812, 32.403953552246),
    vector3(204.62635803223, -888.70501708984, 29.901882171631),
    vector3(-2554.8352050781, 2332.3383789062, 33.060031890869),
    vector3(179.68296813965, 6602.2924804688, 32.036636352539),
    vector3(1687.6477050781, 4929.6875, 42.078121185303),
    vector3(-1230.3656005859, 6916.232421875, 20.459592819214)
}

CreateThread(function()
    for _, pos in ipairs(FuelStations) do
        local blip = AddBlipForCoord(pos.x, pos.y, pos.z)
        SetBlipSprite(blip, 361)
        SetBlipScale(blip, 0.5)
        SetBlipColour(blip, 2)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName("Station essence")
        EndTextCommandSetBlipName(blip)
    end
end)