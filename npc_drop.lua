
--local pnjCategories = {
--    'AMBIENT_GANG_LOST',
--    'AMBIENT_GANG_MEXICAN',
--    'AMBIENT_GANG_FAMILY',
--    'AMBIENT_GANG_BALLAS',
--    'AMBIENT_GANG_MARABUNTE',
--    'AMBIENT_GANG_CULT',
--    'AMBIENT_GANG_SALVA',
--    'AMBIENT_GANG_WEICHENG',
--    'AMBIENT_GANG_HILLBILLY',
--    'DEALER',
--    'COP',
--    'PRIVATE_SECURITY',
--    'SECURITY_GUARD',
--    'ARMY',
--    'MEDIC',
--    'FIREMAN',
--    'HATES_PLAYER',
--    'NO_RELATIONSHIP',
--    'SPECIAL',
--    'MISSION2',
--    'MISSION3',
--    'MISSION4',
--    'MISSION5',
--    'MISSION6',
--    'MISSION7',
--    'MISSION8'
--}
--
--CreateThread(function ()
--	while true do 
--		for _, group in ipairs(pnjCategories) do
--            SetRelationshipBetweenGroups(1, GetHashKey(group), GetHashKey("PLAYER"))
--        end
--		playerCount = #GetActivePlayers()
--		Wait(1000)
--	end	
--end)

local relationshipTypes = {
	"GANG_1",
	"GANG_2",
	"GANG_9",
	"GANG_10",
	"AMBIENT_GANG_LOST",
	"AMBIENT_GANG_MEXICAN",
	"AMBIENT_GANG_FAMILY",
	"AMBIENT_GANG_BALLAS",
	"AMBIENT_GANG_MARABUNTE",
	"AMBIENT_GANG_CULT",
	"AMBIENT_GANG_SALVA",
	"AMBIENT_GANG_WEICHENG",
	"AMBIENT_GANG_HILLBILLY",
	"DEALER",
	"HATES_PLAYER",
	"NO_RELATIONSHIP",
	"SPECIAL",
	"MISSION2",
	"MISSION3",
	"MISSION4",
	"MISSION5",
	"MISSION6",
	"MISSION7",
	"MISSION8",
}

function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		SetWeaponDrops()
	end
end)