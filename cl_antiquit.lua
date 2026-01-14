ghostNPC = {}
permLevel = 'user'

RegisterNetEvent("adminmenu:cbPermLevel")
AddEventHandler("adminmenu:cbPermLevel", function(pLvl)
    permLevel = pLvl
end)

RegisterNetEvent("ghostNPC:add")
AddEventHandler("ghostNPC:add", function(data)
    if GetDistanceBetweenCoords(data.pos, vector3(152.5, -1004.75, -99.0), false) < 10.0 then return end

    Citizen.CreateThread(function()
        local index = #ghostNPC+1
        ghostNPC[index] = data
        ghostNPC[index].alpha = 255

        -- if data.skin then
        --     if data.skin.sex == 0 then data.skin.sex = "mp_m_freemode_01" end

        --     -- RequestModel(GetHashKey(data.skin.sex))
        --     -- while not HasModelLoaded(GetHashKey(data.skin.sex)) do
        --     --     Citizen.Wait(100)
        --     -- end
        --     -- ghostNPC[index].ped = CreatePed(5, GetHashKey(data.skin.sex), data.pos, math.random(1, 250), false)
        --     TriggerEvent("skinchanger:applySkinToPed", ghostNPC[index].ped, data.skin, data.skin)
        -- end

        Citizen.Wait(math.random(1000, 2500))

        -- if data.skin then
        --     SetBlockingOfNonTemporaryEvents(ghostNPC[index].ped, true)
        --     SetEntityInvincible(ghostNPC[index].ped, true)
        --     FreezeEntityPosition(ghostNPC[index].ped, true)
        --     SetEntityVisible(ghostNPC[index].ped, true)
        --     SetPedAlertness(ghostNPC[index].ped, 0.0)
        --     SetEntityCollision(ghostNPC[index].ped, false, true)
        --     SetEntityAlpha(ghostNPC[index].ped, ghostNPC[index].alpha)
        -- end

        Citizen.CreateThread(function()
            while ghostNPC[index] do
                local interval = 1000

                if GetDistanceBetweenCoords(ghostNPC[index].pos, GetEntityCoords(PlayerPedId()), false) < 10.0 then
                    interval = 0
                    ESX.Game.Utils.DrawText3D(vector3(ghostNPC[index].pos.x, ghostNPC[index].pos.y, ghostNPC[index].pos.z + 0.5), "Déconnexion\n"..ghostNPC[index].name.." ["..ghostNPC[index].ServerID.."]\nRaison: "..ghostNPC[index].reason, 1.0, 4)
                end

                Citizen.Wait(interval)
            end
        end)

        local time = GetGameTimer() + cfg_antiquit["showTime"]
        local n = 60
        while time > GetGameTimer() do

            if n > 5 and n < 10 then
                ghostNPC[index].alpha = 125
            elseif n > 10 and n < 30 then
                ghostNPC[index].alpha = 175
            elseif n > 40 and n < 60 then
                ghostNPC[index].alpha = 255
            end

            n = n - 1

            -- if data.skin then
            --     SetEntityAlpha(ghostNPC[index].ped, ghostNPC[index].alpha)
            -- end

            Citizen.Wait(1000)
        end
        -- if data.skin then
        --     DeleteEntity(ghostNPC[index].ped)
        -- end
        ghostNPC[index] = nil
    end)
end)