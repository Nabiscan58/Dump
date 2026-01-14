-- client.lua (NUI x GANG_* intégré)
local RESOURCE = GetCurrentResourceName()

-- ========== Etat NUI local ==========
local OrgState = {
  orgName = "Votre Organisation",
  ranks = {},
  permissions = {},
  members = {},
  nearby = {},
  missions = {
  }
}

-- ========== Helpers ==========
function Send(action, payload)
  payload = payload or {}
  payload.action = action
  SendNUIMessage(payload)
end

function NuiOpen()
  SetNuiFocus(true, true)
  Send("openOrg", { resource = RESOURCE, data = OrgState })
end

function NuiClose()
  SetNuiFocus(false, false)
  Send("closeOrg", {})
end

function NuiSetMembers(list) Send("setMembers", { members = list or {} }) end
function NuiSetRanks(list)   Send("setRanks",   { ranks = list or {} }) end
function NuiSetPerms(perms)  Send("setPerms",   { permissions = perms or {} }) end
function NuiSetNearby(list)  Send("setNearby",  { nearby = list or {} }) end

function GetNearbyPlayers(maxDist)
  maxDist = maxDist or 5.0
  local players = {}
  local playerPed = PlayerPedId()
  local playerCoords = GetEntityCoords(playerPed)

  for _, ply in ipairs(GetActivePlayers()) do
    local targetPed = GetPlayerPed(ply)
    if targetPed ~= playerPed then
      local d = #(playerCoords - GetEntityCoords(targetPed))
      if d <= maxDist then
        table.insert(players, {
          source = GetPlayerServerId(ply),
          name   = GetPlayerName(ply),
        })
      end
    end
  end
  return players
end

-- ========== Chargements depuis TES callbacks ==========
function RefreshGangCore()
    -- Récupère gang, rank & data (ranks/permissions/leader)
    local data = Utils.TriggerServerCallback("gangs:members:getPlayerGang")
    if not data then return false end

    GANG_PLAYER.GangId = data.gangId
    GANG_PLAYER.Rank   = data.rank
    GANG_PLAYER.Data   = Utils.TriggerServerCallback("gangs:logic:getGangData", GANG_PLAYER.GangId)

    OrgState.orgName     = GANG_PLAYER.Data.name or "Votre Organisation"
    OrgState.ranks       = GANG_PLAYER.Data.ranks or {}
    OrgState.permissions = GANG_PLAYER.Data.permissions or {}

    return true
end

function RefreshMembers()
  OrgState.members = Utils.TriggerServerCallback('gangs:members:getAllMembers', GANG_PLAYER.GangId) or {}
  NuiSetMembers(OrgState.members)
end

function RefreshRanks()
  OrgState.ranks = (GANG_PLAYER.Data and GANG_PLAYER.Data.ranks) or {}
  if #OrgState.ranks == 0 then
    -- sécurité : re-fetch si vide
    GANG_PLAYER.Data = Utils.TriggerServerCallback("gangs:logic:getGangData", GANG_PLAYER.GangId)
    OrgState.ranks = (GANG_PLAYER.Data and GANG_PLAYER.Data.ranks) or {}
  end
  NuiSetRanks(OrgState.ranks)
end

function RefreshPerms()
  OrgState.permissions = (GANG_PLAYER.Data and GANG_PLAYER.Data.permissions) or {}
  NuiSetPerms(OrgState.permissions)
end

function RefreshNearby()
  OrgState.nearby = GetNearbyPlayers(5.0)
  NuiSetNearby(OrgState.nearby)
end

function DoFullRefresh()
  if RefreshGangCore() then
    print("do full")
    RefreshMembers()
    RefreshRanks()
    RefreshPerms()
    RefreshNearby()
    TriggerServerEvent("kxOrg:requestMissions")
    TriggerServerEvent("kxOrg:requestCraftInfo")
  end
end

-- ========== OUVERTURE ==========
function OpenGangNUI()
  -- reconstruit l'état avec TES callbacks
  DoFullRefresh()
  NuiOpen()
end

-- commande de test (désactive en prod si tu veux)
-- RegisterCommand("orgui", function()
--   OpenGangNUI()
-- end)

-- ========== Events utilitaires (si tu veux pousser des updates côté serveur) ==========
RegisterNetEvent("kxorgui:updateMembers", function(list)
  OrgState.members = list or OrgState.members
  NuiSetMembers(OrgState.members)
end)

RegisterNetEvent("kxorgui:updateRanks", function(list)
  OrgState.ranks = list or OrgState.ranks
  NuiSetRanks(OrgState.ranks)
end)

RegisterNetEvent("kxorgui:updatePerms", function(perms)
  OrgState.permissions = perms or OrgState.permissions
  NuiSetPerms(OrgState.permissions)
end)

RegisterNetEvent("kxorgui:updateNearby", function(list)
  OrgState.nearby = list or OrgState.nearby
  NuiSetNearby(OrgState.nearby)
end)

-- ========== NUI Callbacks : mappés sur TES routes ==========
-- Fermer
RegisterNUICallback("close", function(_, cb)
  NuiClose()
  cb({ ok = true })
end)

-- Refresh global → recharge via TES callbacks et renvoie les sections
RegisterNUICallback("refresh", function(_, cb)
  DoFullRefresh()
  cb({ ok = true })
end)

-- Promouvoir / changer rang
-- payload: { target = number|string, level = number }
RegisterNUICallback("members:promote", function(payload, cb)
  local target = payload and payload.target
  local level  = payload and tonumber(payload.level)
  if target and level then
    print("promote", target, level)
    local ok = Utils.TriggerServerCallback('gangs:members:promotePlayer', target, level)
    print(ok)
    if ok then RefreshMembers() else cb({ ok = false }) end
  end
  cb({ ok = true })
end)

-- Transférer leader
-- payload: { identifier = string }
RegisterNUICallback("members:changeLeader", function(payload, cb)
  local identifier = payload and payload.identifier
  if identifier then
    local ok = Utils.TriggerServerCallback('gangs:members:changeLeader', GANG_PLAYER.GangId, identifier)
    if ok then
      -- Recharger cœur + membres (le leader change de rang)
      DoFullRefresh()
    end
  end
  cb({ ok = true })
end)

-- Kick membre
-- payload: { target = number|string }
RegisterNUICallback("members:kick", function(payload, cb)
  local target = payload and payload.target
  if target then
    local ok = Utils.TriggerServerCallback('gangs:members:kickMember', target)
    if ok then RefreshMembers() end
  end
  cb({ ok = true })
end)

-- Recruter un joueur proche (ton ancien flux passait par un event server direct)
-- payload: { source = number }
RegisterNUICallback("members:recruit", function(payload, cb)
  local nearSrc = payload and tonumber(payload.source or 0)
  if nearSrc and nearSrc > 0 then
    -- garde ton event instantané + validation côté serveur
    print("recruit", nearSrc, GANG_PLAYER.GangId)
    TriggerServerEvent('gangs:members:recruitPlayer', nearSrc, GANG_PLAYER.GangId)
    -- Option: refaire un refresh soft des membres
    Citizen.SetTimeout(500, RefreshMembers)
  end
  cb({ ok = true })
end)

-- payload: { level = number (optionnel), name = string }
RegisterNUICallback("ranks:add", function(payload, cb)
  local name = payload and payload.name
  if name and name ~= "" then
    local ok = Utils.TriggerServerCallback('gangs:logic:addNewRank', GANG_PLAYER.GangId, name)
    if ok then
      -- re-fetch complet pour récupérer les nouveaux ranks + permissions à jour
      GANG_PLAYER.Data = Utils.TriggerServerCallback("gangs:logic:getGangData", GANG_PLAYER.GangId)
      RefreshRanks()
      RefreshMembers()
    end
  end
  cb({ ok = true })
end)

RegisterNUICallback("missions:buyTablet", function(payload, cb)
  TriggerServerEvent("orgsystem:buyTablet")
  cb({ ok = true })
end)

-- Rangs: renommer
-- payload: { level = number, name = string }
RegisterNUICallback("ranks:rename", function(payload, cb)
  local level = payload and tonumber(payload.level)
  local name  = payload and payload.name
  if level and name and name ~= "" then
    local ok = Utils.TriggerServerCallback('gangs:logic:updateRankName', GANG_PLAYER.GangId, level, name)
    if ok then
      RefreshRanks()
      RefreshMembers()
    end
  end
  cb({ ok = true })
end)

-- Rangs: supprimer
-- payload: { level = number }
RegisterNUICallback("ranks:delete", function(payload, cb)
  local level = payload and tonumber(payload.level)
  if level then
    local ok = Utils.TriggerServerCallback('gangs:logic:removeRank', GANG_PLAYER.GangId, level)
    if ok then
      RefreshRanks()
      RefreshMembers()
    end
  end
  cb({ ok = true })
end)

-- Rangs: déplacer (up/down)
-- payload: { level = number, dir = "up"|"down" }
RegisterNUICallback("ranks:move", function(payload, cb)
  local level = payload and tonumber(payload.level)
  local dir   = payload and tostring(payload.dir or "")
  if level and (dir == "up" or dir == "down") then
    local ok = Utils.TriggerServerCallback('gangs:logic:moveRankPosition', GANG_PLAYER.GangId, level, dir)
    if ok then
      RefreshRanks()
      RefreshMembers()
    end
  end
  cb({ ok = true })
end)

-- Permissions: MAJ (remplace entièrement la clé par la nouvelle liste de rangs)
-- payload: { key = string, ranks = number[] }
RegisterNUICallback("admin:updatePermissions", function(payload, cb)
  local key   = payload and payload.key
  local ranks = payload and payload.ranks
  if key and type(ranks) == "table" then
    -- construit un nouvel objet permissions en partant de l’actuel
    local perms = GANG_PLAYER.Data.permissions or {}
    perms[key] = ranks

    local ok = Utils.TriggerServerCallback('gangs:admin:updatePermissions', GANG_PLAYER.GangId, perms)
    if ok then
      GANG_PLAYER.Data.permissions = perms
      RefreshPerms()
    end
  end
  cb({ ok = true })
end)

-- Missions: ouvre ton menu missions (tu l’appelles déjà ailleurs, je relaye juste)
RegisterNUICallback("missions:open", function(_, cb)
  -- Si tu as un menu missions côté client :
  if MISSIONS_MENU and MISSIONS_MENU.Open then
    NuiClose()
    MISSIONS_MENU.Open()
  else
    -- ou passe par le serveur si besoin:
    TriggerServerEvent("kxorgui:missions:open")
  end
  cb({ ok = true })
end)

-- ========== Qualité de vie ==========
-- ferme avec ESC côté jeu si besoin
-- Citizen.CreateThread(function()
--   while true do
--     if IsControlJustReleased(0, 322) or IsControlJustReleased(0, 177) then
--       NuiClose()
--     end
--     Wait(0)
--   end
-- end)

-- Option: mettre à jour la liste des joueurs proches périodiquement pendant l’UI
CreateThread(function()
  while true do
    if IsNuiFocused() then
      RefreshNearby()
      Wait(1500)
    else
      Wait(1000)
    end
  end
end)

-- client/missions.lua
local RES_NAME = GetCurrentResourceName()
local nuiOpen = false

local function nui(msg)
  SendNUIMessage(msg)
end

local function openUI(data)
  if nuiOpen then return end
  nuiOpen = true
  SetNuiFocus(true, true)
  nui({
    action = "openOrg",
    resource = RES_NAME,
    data = data or { orgName = "Votre Organisation" }
  })
end

local function closeUI()
  if not nuiOpen then return end
  nuiOpen = false
  SetNuiFocus(false, false)
  nui({ action = "closeOrg" })
end

-- Reçoit l’ordre serveur d’ouvrir l’UI
RegisterNetEvent("kxOrg:openOrg", function(data)
  openUI(data)
  -- Demande le catalogue au serveur
  TriggerServerEvent("kxOrg:requestMissions")
end)

-- Reçoit le catalogue et le pousse dans la page “missions”
RegisterNetEvent("kxOrg:setMissions", function(list)
  nui({
    action = "setMissionsCatalog",
    missions = list or {}
  })
end)

-- NUI → Client : bouton “Commencer”
RegisterNUICallback("missions:start", function(data, cb)
  TriggerServerEvent("kxOrg:startMission", { id = data and data.id })
  -- optionnel: fermer l’UI après lancement
  -- closeUI()
  cb(true)
end)

-- NUI → Client : fermer
RegisterNUICallback("close", function(_, cb)
  closeUI()
  cb(true)
end)

-- -- Astuce debug pour tester sans menu :
-- RegisterCommand("org_missions", function()
--   openUI({ orgName = "Votre Organisation" })
--   TriggerServerEvent("kxOrg:requestMissions")
-- end)

RegisterNetEvent("kxOrg:setCraftInfo",function(info)
    nui({action="setCraftInfo",craft=info})
end)

RegisterNUICallback("craft:do",function(data,cb)
    local res=Utils.TriggerServerCallback('kxOrg:craftWeapon',data and data.item)
    cb(res or {ok=false})
end)

local CRAFT_DL={ exact=nil, rumor=nil, activeId=nil, endAt=0, target=nil, ped=nil }

local function loadModel(hash)
  if type(hash)=="string" then hash = GetHashKey(hash) end
  if not IsModelInCdimage(hash) then return nil end
  RequestModel(hash)
  local t=GetGameTimer()+5000
  while not HasModelLoaded(hash) do
    if GetGameTimer()>t then return nil end
    Wait(0)
  end
  return hash
end

local function spawnCraftPed(coords)
  -- modèle “dealer” (tu peux changer par "g_m_m_chigoon_02" ou autre)
  local model = loadModel(`s_m_y_dealer_01`)
  if not model then return nil end

  -- on le spawne un chouïa en dessous pour éviter le “pop” en l’air
  local ped = CreatePed(4, model, coords.x, coords.y, coords.z - 1.0, 0.0, false, true)
  SetEntityAsMissionEntity(ped, true, true)
  SetBlockingOfNonTemporaryEvents(ped, true)
  SetEntityInvincible(ped, true)
  FreezeEntityPosition(ped, true)
  SetPedCanRagdoll(ped, false)
  SetPedFleeAttributes(ped, 0, false)
  SetPedCombatAttributes(ped, 46, true) -- no flee
  SetPedDiesWhenInjured(ped, false)
  -- pas de scenario pour laisser le heading libre

  SetModelAsNoLongerNeeded(model)
  return ped
end

local function deleteCraftPed()
  if CRAFT_DL.ped and DoesEntityExist(CRAFT_DL.ped) then
    DeleteEntity(CRAFT_DL.ped)
  end
  CRAFT_DL.ped=nil
end

RegisterNetEvent("kxOrg:craft:deliveryStart",function(data)
    -- nettoie anciens éléments
    if CRAFT_DL.exact then RemoveBlip(CRAFT_DL.exact) end
    if CRAFT_DL.rumor then RemoveBlip(CRAFT_DL.rumor) end
    deleteCraftPed()

    -- état
    CRAFT_DL.activeId=data.id
    CRAFT_DL.endAt=GetGameTimer()+math.floor((data.ttl or 600)*1000)
    CRAFT_DL.target=vector3(data.coords.x,data.coords.y,data.coords.z)
    CRAFT_DL.hintShown=false

    -- blip exact + route
    local b=AddBlipForCoord(data.coords.x,data.coords.y,data.coords.z)
    SetBlipSprite(b,1)
    SetBlipScale(b,0.85)
    SetBlipColour(b,46)
    SetBlipAsShortRange(b,false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Retrait: "..(data.label or "Arme"))
    EndTextCommandSetBlipName(b)
    SetBlipRoute(b,true)
    CRAFT_DL.exact=b

    -- PNJ local
    local ped = spawnCraftPed(CRAFT_DL.target)
    if ped then
      -- face immédiatement le joueur à la création
      local pc = GetEntityCoords(PlayerPedId())
      local heading = GetHeadingFromVector_2d(pc.x - data.coords.x, pc.y - data.coords.y)
      SetEntityHeading(ped, heading)
      CRAFT_DL.ped = ped
    end
end)

RegisterNetEvent("kxOrg:craft:deliveryRumor",function(data)
  local b=AddBlipForCoord(data.coords.x,data.coords.y,data.coords.z)
  SetBlipSprite(b,161)
  SetBlipScale(b,1.0)
  SetBlipColour(b,5)
  SetBlipAsShortRange(b,false)
  BeginTextCommandSetBlipName("STRING")
  AddTextComponentString("Activité suspecte")
  EndTextCommandSetBlipName(b)
  CRAFT_DL.rumor=b
end)

RegisterNetEvent("kxOrg:craft:deliveryClear",function(id)
  if CRAFT_DL.activeId~=id and CRAFT_DL.activeId~=nil then return end
  if CRAFT_DL.exact then RemoveBlip(CRAFT_DL.exact) end
  if CRAFT_DL.rumor then RemoveBlip(CRAFT_DL.rumor) end
  deleteCraftPed()
  CRAFT_DL={ exact=nil, rumor=nil, activeId=nil, endAt=0, target=nil, ped=nil }
end)

CreateThread(function()
  while true do
      if CRAFT_DL.activeId and CRAFT_DL.target then
          local ped=PlayerPedId()
          local pc=GetEntityCoords(ped)
          local dist=#(pc-CRAFT_DL.target)

          -- fait tourner le PNJ vers le joueur
          if CRAFT_DL.ped and DoesEntityExist(CRAFT_DL.ped) then
              local px,py,pz = table.unpack(CRAFT_DL.target)
              local heading = GetHeadingFromVector_2d(pc.x - px, pc.y - py)
              -- évite de spammer si très proche du heading actuel
              if math.abs(GetEntityHeading(CRAFT_DL.ped) - heading) > 1.5 then
                  SetEntityHeading(CRAFT_DL.ped, heading)
              end
          end

          if dist < 2.5 then
              ESX.ShowHelpNotification("~y~Appuyez sur ~INPUT_PICKUP~ pour récupérer l'arme")

              if IsControlJustPressed(0,38) then
                  TriggerServerEvent("kxOrg:craft:claim", CRAFT_DL.activeId)
              end
          elseif dist < 30.0 and not CRAFT_DL.hintShown then
              ESX.ShowHelpNotification("~y~Approchez-vous du contact puis ~INPUT_PICKUP~ pour récupérer l'arme")
          end

          -- TTL expiré → cleanup local
          if GetGameTimer()>CRAFT_DL.endAt then
              TriggerEvent("kxOrg:craft:deliveryClear", CRAFT_DL.activeId)
          end
          Wait(0)
      else
          Wait(500)
      end
  end
end)