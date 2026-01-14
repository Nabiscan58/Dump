--Roxwood Bird height script

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()
        local PlayerInRoxwood = false
            if IsEntityInAngledArea(ped, -1393.7, 6955.44, 49.73, -348.747, 6781.35, 49.73, 410, 0, 0, 0)
                or IsEntityInAngledArea(ped, -1164.63, 6532.6, 49.73, -421.063, 7418.74, 49.73, 724, 0, 0, 0)
            then 
                PlayerInRoxwood = true
            end

        if PlayerInRoxwood then
            SetGlobalMinBirdFlightHeight(130)
        else
            Citizen.Wait(0)
        end
    end
end)