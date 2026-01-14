isStaffMode, serverInteraction = false,false

RegisterNetEvent("adminmenu:cbStaffState")
AddEventHandler("adminmenu:cbStaffState", function(isStaff)
    isStaffMode = isStaff
    serverInteraction = false
    DecorSetBool(PlayerPedId(), "isStaffMode", isStaffMode)
    if not isStaffMode then
        ForceDeactivateNoclip()
        showNames(false)
    end
end)

-- RegisterNetEvent("adminmenu:waitingForBucketAnswer")
-- AddEventHandler("adminmenu:waitingForBucketAnswer", function(bucket)
--     local a = amount or 0
--     local bucket = bucket
-- 
--     ESX.ShowAdvancedNotification("Staffmode", "Joueur en instance", "~b~Souhaitez-vous vous diriger vers l'instance du joueur ?\n\nE pour ~y~accepter~s~ | X pour ~r~refuser~s~", "CHAR_BLANK_ENTRY", 8)
-- 
--     Citizen.CreateThread(function()
-- 		local timer = 0
--         while true do
--             Wait(0)
-- 			timer = timer + 1
-- 
-- 			if timer > 450 then 
-- 				break 
-- 			end
-- 
--             if IsControlPressed(0, 38) then
--                 TriggerServerEvent('adminmenu:switchInstances', bucket)
--                 break
--             elseif IsControlPressed(0, 252) then
--                 break
--             end
--         end
--     end)
-- end)