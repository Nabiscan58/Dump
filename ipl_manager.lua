local interiorsRulesById = {}
local appliedStates = {}
local radiusEntries = (Config.RadiusIpls and Config.RadiusIpls.entries) or {}
local radiusEnableNotifications = Config.RadiusIpls and Config.RadiusIpls.enableNotifications and Config.Notify and
Config.Notify.debug
local hasRadiusCfg = {}
for i = 1, #radiusEntries do
	local e = radiusEntries[i]
	if e and e.ipl then
		hasRadiusCfg[e.ipl] = e
	end
end
local radiusApplied = {}
local function isPlayerInsideEntry(entry)
	local ped = PlayerPedId()
	local playerInterior = GetInteriorFromEntity(ped)
	if playerInterior ~= 0 then
		local targetInterior = GetInteriorAtCoords(entry.pos.x, entry.pos.y, entry.pos.z)
		if targetInterior ~= 0 and playerInterior == targetInterior then
			return true
		end
	end
	return false
end

local function notify(msg)
	local cfg = Config.Notify or { mode = 'none' }
	local text = (cfg.prefix and (cfg.prefix .. ' ') or '') .. msg
	if cfg.mode == 'chat' then
		TriggerEvent('chat:addMessage', { args = { text } })
	elseif cfg.mode == 'feed' then
		BeginTextCommandThefeedPost('STRING')
		AddTextComponentSubstringPlayerName(text)
		EndTextCommandThefeedPostTicker(false, false)
	end
end

local function addHash(set, h)
	if h and h ~= 0 then set[h] = true end
end

local function resolveInteriorIdsFromConfig()
	for name, v in pairs(Config.INTERIORS or {}) do
		if v.locations and #v.locations > 0 then
			for i = 1, #v.locations do
				local coords = v.locations[i]
				local interior = GetInteriorAtCoords(coords.x, coords.y, coords.z)

				if interior ~= 0 then
					if not interiorsRulesById[interior] then
						interiorsRulesById[interior] = { rules = {} }
						appliedStates[interior] = {}
					end

					if v.iplRules then
						for _, rule in ipairs(v.iplRules) do
							local roomHashSet = {}

							if rule.room then
								local h = rule.room.hash or (rule.room.name and GetHashKey(rule.room.name)) or 0
								addHash(roomHashSet, h)
							end
							if rule.rooms then
								for _, rr in ipairs(rule.rooms) do
									local h = rr.hash or (rr.name and GetHashKey(rr.name)) or 0
									addHash(roomHashSet, h)
								end
							end

							table.insert(interiorsRulesById[interior].rules, {
								label = rule.label,
								ipls = rule.ipls or {},
								_roomHashSet = roomHashSet,
							})
						end
					end
				else
					if Config.Notify and Config.Notify.debug then
						print(("^3[WARN] Cannot find interior '%s' at coords %s^7"):format(name,
							coords.x .. ", " .. coords.y .. ", " .. coords.z .. "^7"))
					end
				end
			end
		end
	end
end


local function matchesAnyRoom(rule, playerRoomHash)
	if not rule._roomHashSet or next(rule._roomHashSet) == nil then
		return true
	end
	return rule._roomHashSet[playerRoomHash] == true
end

local function setIpls(ipls, remove)
	if not ipls then return end
	for _, ipl in ipairs(ipls) do
		if remove then
			if Config.Notify and Config.Notify.debug then
				print("^1[IPL REMOVE] " .. ipl .. "^7")
			end
			RemoveIpl(ipl)
		else
			if Config.Notify and Config.Notify.debug then
				print("^2[IPL REQUEST] " .. ipl .. "^7")
			end
			RequestIpl(ipl)
		end
	end
end

local function bootstrapAllIpls()
	local uniq = {}
	for _, data in pairs(interiorsRulesById) do
		for _, rule in ipairs(data.rules or {}) do
			for _, ipl in ipairs(rule.ipls or {}) do
				if not hasRadiusCfg[ipl] then
					uniq[ipl] = true
				end
			end
		end
	end
	for ipl, _ in pairs(uniq) do
		if Config.Notify and Config.Notify.debug then
			print("^3[IPL BOOTSTRAP] " .. ipl .. "^7")
		end
		RequestIpl(ipl)
	end
	if Config.Notify and Config.Notify.debug then
		notify('Bootstrap: requested all configured IPLs')
	end
end

AddEventHandler('onClientResourceStart', function(res)
	if res == GetCurrentResourceName() then
		resolveInteriorIdsFromConfig()
		bootstrapAllIpls()
	end
end)

CreateThread(function()
	if next(interiorsRulesById) == nil then
		resolveInteriorIdsFromConfig()
		bootstrapAllIpls()
	end

	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		local playerInterior = GetInteriorFromEntity(ped)
		local playerRoomHash = 0

		if playerInterior ~= 0 and IsValidInterior(playerInterior) then
			playerRoomHash = GetRoomKeyFromEntity(ped) or 0
		end

		-- 1) Décisions par règle + set global des IPL à retirer
		local decisions = {}       -- [interiorId] = { [ruleIdx] = bool }
		local removeSet = {}       -- [ipl] = true

		for interiorId, data in pairs(interiorsRulesById) do
			local rules = data.rules or {}
			decisions[interiorId] = decisions[interiorId] or {}

			for idx, rule in ipairs(rules) do
				local apply = false
				if playerInterior == interiorId then
					if matchesAnyRoom(rule, playerRoomHash) then
						apply = true
					end
				end
				decisions[interiorId][idx] = apply

				if apply and rule.ipls then
					for _, ipl in ipairs(rule.ipls) do
						removeSet[ipl] = true
					end
				end
			end
		end

		-- 2) Phase removals (avant toute request)
		for interiorId, rules in pairs(interiorsRulesById) do
			for idx, rule in ipairs(rules.rules or {}) do
				local apply = decisions[interiorId] and decisions[interiorId][idx]
				local already = appliedStates[interiorId][idx] == true
				if apply and not already then
					setIpls(rule.ipls, true)
					if Config.Notify and Config.Notify.debug then
						notify((rule.label or 'Rule') .. ': removed ' .. tostring(#(rule.ipls or {})) .. ' IPL(s)')
					end
					appliedStates[interiorId][idx] = true
				end
			end
		end

		-- 3) Phase requests (seulement pour les IPL non requis par d'autres règles)
		for interiorId, rules in pairs(interiorsRulesById) do
			for idx, rule in ipairs(rules.rules or {}) do
				local apply = decisions[interiorId] and decisions[interiorId][idx]
				local already = appliedStates[interiorId][idx] == true

				if (not apply) and already then
					local toRequest = {}
					for _, ipl in ipairs(rule.ipls or {}) do
						if not removeSet[ipl] then
							toRequest[#toRequest + 1] = ipl
						end
					end
					if #toRequest > 0 then
						setIpls(toRequest, false)
						if Config.Notify and Config.Notify.debug then
							notify((rule.label or 'Rule') .. ': requested ' .. tostring(#toRequest) .. ' IPL(s)')
						end
					end
					appliedStates[interiorId][idx] = false
				end
			end
		end

		-- 4) Gestion Radius (demande/suppression selon distance, avec garde si joueur à l'intérieur)
		local radius = Config.RadiusIpls
		if radius and radius.entries and #radius.entries > 0 then
			local camCoords = GetFinalRenderedCamCoord()
			for i = 1, #radius.entries do
				local entry = radius.entries[i]
				local pos = entry.pos
				local dist = #(vector3(camCoords.x, camCoords.y, camCoords.z) - vector3(pos.x, pos.y, pos.z))
				local isLoaded = radiusApplied[entry.ipl] == true
				if dist <= (entry.radius or 0) then
					if not isLoaded then
						RequestIpl(entry.ipl)
						radiusApplied[entry.ipl] = true
						if radiusEnableNotifications then
							notify(('[PullSizePatch] request %s (%.1fm)'):format(entry.ipl, dist))
						end
					end
				else
					if isLoaded then
						if isPlayerInsideEntry(entry) then
							if radiusEnableNotifications then
								notify(('[PullSizePatch] joueur à l\'intérieur, %s non retiré (%.1fm)'):format(entry.ipl,
									dist))
							end
						else
							RemoveIpl(entry.ipl)
							radiusApplied[entry.ipl] = false
							if radiusEnableNotifications then
								notify(('[PullSizePatch] remove %s (%.1fm)'):format(entry.ipl, dist))
							end
						end
					end
				end
			end
		end
		Wait(Config.IPL_POLL_INTERVAL or 1000)
	end
end)

-- RegisterCommand('iphere', function()
-- 	local ped = PlayerPedId()
-- 	local coords = GetEntityCoords(ped)
-- 	local interior = GetInteriorFromEntity(ped)
-- 	local roomHash = 0
-- 	if interior ~= 0 and IsValidInterior(interior) then
-- 		roomHash = GetRoomKeyFromEntity(ped) or 0
-- 		print(("[IPL DEBUG] coords: (%.2f, %.2f, %.2f), interior: %d, roomHash: %d (0x%X)"):format(coords.x, coords.y, coords.z, interior, roomHash, roomHash))
-- 	else
-- 		print(("[IPL DEBUG] coords: (%.2f, %.2f, %.2f), NO INTERIOR"):format(coords.x, coords.y, coords.z))
-- 	end
-- end, false)