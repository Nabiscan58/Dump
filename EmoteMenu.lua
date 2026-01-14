-- TriggerServerEvent("dp:CheckVersion")

local EmoteTable = {}
local FavEmoteTable = {}
local KeyEmoteTable = {}
local DanceTable = {}
local AnimalTable = {}
local PropETable = {}
local WalkTable = {}
local FaceTable = {}
local ShareTable = {}
local FavoriteEmote = ""
emotePed = nil

local searchTerm = ""

function matchesSearch(key, label)
    if not searchTerm or searchTerm == "" then return true end
    local s = string.lower(searchTerm)
    if key and string.find(string.lower(tostring(key)), s, 1, true) then return true end
    if label and string.find(string.lower(tostring(label)), s, 1, true) then return true end
    return false
end

function SearchHeader(title)
    RageUI.ButtonWithStyle("Recherche", nil, {RightLabel = (searchTerm ~= "" and ("« "..searchTerm.." »") or "»»»")}, true, function(Hovered, Active, Selected)
        if Selected then
            searchTerm = KeyboardInputSimple(title, searchTerm, 60)
        end
    end)
    RageUI.ButtonWithStyle("Effacer la recherche", nil, {}, searchTerm ~= "", function(Hovered, Active, Selected)
        if Selected then
            searchTerm = ""
        end
    end)
end

function KeyboardInputSimple(title, defaultText, maxLength)
    AddTextEntry("FMMC_KEY_TIP1", title)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", defaultText or "", "", "", "", maxLength or 60)
    while UpdateOnscreenKeyboard() == 0 do
        Wait(0)
    end
    local res = GetOnscreenKeyboardResult()
    if res then return res end
    return ""
end

RequestDemarcheThing = function(animSet, cb)
	if not HasAnimSetLoaded(animSet) then
		RequestAnimSet(animSet)

		while not HasAnimSetLoaded(animSet) do
			Citizen.Wait(1)
		end
	end

	if cb ~= nil then
		cb()
	end
end

local prop = nil

CreateThread(function ()
    while true do
        if not inMenu or not RMenu:Get('animation', "main") then 
            if emotePed ~= nil  then 
                DeleteEntity(emotePed)
                if prop ~= nil then 
                    DeleteEntity(prop)
                    prop = nil
                end
                emotePed = nil
            end
        end
        Wait(800)
    end
end)

CreatedProps = {}
local currentEmote = nil
OpenEmoteMenu = function()
    RMenu.Add('animation', 'main', RageUI.CreateMenu("PRIME", "Que voulez-vous faire ?", 1, 100))
    RMenu.Add('animation', 'humor', RageUI.CreateSubMenu(RMenu:Get('animation', 'main'), "Humeurs", "Que voulez-vous faire ?"))

    RMenu.Add('animation', 'aimstyles', RageUI.CreateSubMenu(RMenu:Get('animation', 'main'), "Style de visée", "Que voulez-vous faire ?"))
    RMenu.Add('animation', 'holsterAnim', RageUI.CreateSubMenu(RMenu:Get('animation', 'main'), "Animation sortie", "Que voulez-vous faire ?"))

    RMenu.Add('animation', 'walks', RageUI.CreateSubMenu(RMenu:Get('animation', 'main'), "Démarches", "Que voulez-vous faire ?"))

    RMenu.Add('animation', 'animations', RageUI.CreateSubMenu(RMenu:Get('animation', 'main'), "Animation", "Que voulez-vous faire ?"))
    RMenu.Add('animation', 'danses', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Danses", "Liste des danses"))
    RMenu.Add('animation', 'vehicle', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "En véhicule", "Liste des animations"))
    RMenu.Add('animation', 'animals', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Animaux", "Liste des animations"))
    RMenu.Add('animation', 'objects', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Objets", "Liste des animations"))
    RMenu.Add('animation', 'shared', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Partagées", "Liste des animations"))
    RMenu.Add('animation', 'sit', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "S'asseoir", "Liste des animations"))
    RMenu.Add('animation', 'pegi', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Pegi 18", "Liste des animations"))
    RMenu.Add('animation', 'sports', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Sport", "Liste des animations"))
    RMenu.Add('animation', 'salutes', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Saluts", "Liste des animations"))
    RMenu.Add('animation', 'poses', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Poses", "Liste des animations"))
    RMenu.Add('animation', 'gangs', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Gang", "Liste des animations"))
    RMenu.Add('animation', 'noel', RageUI.CreateSubMenu(RMenu:Get('animation', 'animations'), "Noël", "Liste des animations de Noël"))

    RMenu:Get('animation', 'main'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'main'):SetPosition(1340, 200)

    RMenu:Get('animation', 'humor'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'humor'):SetPosition(1340, 200)

    RMenu:Get('animation', 'aimstyles'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'aimstyles'):SetPosition(1340, 200)

    RMenu:Get('animation', 'holsterAnim'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'holsterAnim'):SetPosition(1340, 200)

    RMenu:Get('animation', 'walks'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'walks'):SetPosition(1340, 200)

    RMenu:Get('animation', 'animations'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'animations'):SetPosition(1340, 200)

    RMenu:Get('animation', 'danses'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'danses'):SetPosition(1340, 200)

    RMenu:Get('animation', 'animals'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'animals'):SetPosition(1340, 200)

    RMenu:Get('animation', 'objects'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'objects'):SetPosition(1340, 200)

    RMenu:Get('animation', 'shared'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'shared'):SetPosition(1340, 200)

    RMenu:Get('animation', 'sit'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'sit'):SetPosition(1340, 200)

    RMenu:Get('animation', 'pegi'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'pegi'):SetPosition(1340, 200)

    RMenu:Get('animation', 'vehicle'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'vehicle'):SetPosition(1340, 200)

    RMenu:Get('animation', 'sports'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'sports'):SetPosition(1340, 200)

    RMenu:Get('animation', 'salutes'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'salutes'):SetPosition(1340, 200)

    RMenu:Get('animation', 'poses'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'poses'):SetPosition(1340, 200)

    RMenu:Get('animation', 'gangs'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'gangs'):SetPosition(1340, 200)

    RMenu:Get('animation', 'noel'):SetRectangleBanner(255, 220, 0, 140)
    RMenu:Get('animation', 'noel'):SetPosition(1340, 200)

    RMenu:Get('animation', "main").Closed = function()
        inMenu = false
        if emotePed ~= nil then 
            DeleteEntity(emotePed)
            emotePed = nil
        end
        if prop ~= nil then 
            DeleteEntity(prop)
            prop = nil
        end
        for k,v in pairs(CreatedProps) do
            DeleteEntity(v)
        end
        RMenu:Delete('animation', 'main')
        RMenu:Delete('animation', 'animations')
        RMenu:Delete('animation', 'aimstyles')
        RMenu:Delete('animation', 'holsterAnim')
        RMenu:Delete('animation', 'danses')
        RMenu:Delete('animation', 'animals')
        RMenu:Delete('animation', 'objects')
        RMenu:Delete('animation', 'shared')
        RMenu:Delete('animation', 'sit')
        RMenu:Delete('animation', 'pegi')
        RMenu:Delete('animation', 'vehicle')
        RMenu:Delete('animation', 'sports')
        RMenu:Delete('animation', 'salutes')
        RMenu:Delete('animation', 'poses')
        RMenu:Delete('animation', 'gangs')
        RMenu:Delete('animation', 'noel')
    end

    if inMenu then
        inMenu = false
        return
    else
        RageUI.CloseAll()

        inMenu = true
        RageUI.Visible(RMenu:Get('animation', 'main'), true)
    end

    for k,v in pairsByKeys(DP.Emotes) do
        EmoteTable[k] = k
    end

    local choices = {
        [1] = "▶",
        [2] = "🛑",
    }
    for i=1, 5 do
        choices[2+i] = "Raccourcis #"..i
    end

    local expression = {
        [1] = "▶",
        [2] = "⭐",
    }

    local currentIndex = {}

    local holsterAnims = {
        {name = "", label = "Par défaut"},
        {name = "BackHolsterAnimation", label = "Sort du dos"},
        {name = "SideHolsterAnimation", label = "Sort du côté droit"},
        --{name = "SideLegHolsterAnimation", label = "Sort du côté droit #2"},
        {name = "FrontHolsterAnimation", label = "Sort du côté gauche"},
        --{name = "AgressiveFrontHolsterAnimation", label = "Sort du côté gauche agressif"},
    }

    local function createClone()
        local clone = ClonePed(PlayerPedId(), false, false, true)
        FreezeEntityPosition(clone, true)
        SetEntityVisible(clone, false, false)
        SetEntityInvincible(clone, true)
        SetEntityCanBeDamaged(clone, false)
        SetPedCanRagdoll(clone, false)
        SetPedCanRagdollFromPlayerImpact(clone, false)
        SetEntityCollision(clone, false, false)
        SetBlockingOfNonTemporaryEvents(clone, false)
        SetPedCanRagdoll(clone, true)
        SetPedCanPlayAmbientAnims(clone, true)
        SetPedCanPlayAmbientBaseAnims(clone, true)

        return clone
    end
    local function RotationToDirection(rotation)
        local adjustedRotation = vector3(
            (math.pi / 180) * rotation.x,
            (math.pi / 180) * rotation.y,
            (math.pi / 180) * rotation.z
        )
        local direction = vector3(
            -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
            math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
            math.sin(adjustedRotation.x)
        )
        return direction
    end
    
    if emotePed ~= nil then 
        DeletePed(emotePed)
    end
    emotePed = nil
    emotePed = createClone()
    currentEmote = nil
    local lastAnim = nil
    Citizen.CreateThread(function()
        while inMenu do
            Wait(1)

            if emotePed then -- Vérifiez si le menu est visible
                local coordsCam = GetGameplayCamCoord()
                local rot = GetGameplayCamRot(2)
                local forward = RotationToDirection(rot)
                local right = RotationToDirection(vector3(rot.x, rot.y, rot.z - 90.0))
                local up = vector3(0.0, 0.0, 1.0)

                -- Ajustez ces valeurs pour positionner le Ped à côté du menu RageUI
                local forwardOffset = 5.2 -- Distance devant la caméra
                local rightOffset = 1.2 -- Distance à la droite de la caméra
                local upOffset = 0.5 -- Hauteur relative à la caméra

                local pedCoords = coordsCam + forward * forwardOffset + right * rightOffset + up * upOffset

                SetEntityCoordsNoOffset(emotePed, pedCoords.x, pedCoords.y, pedCoords.z, true, true, true)
                SetEntityVisible(emotePed, true, false)
                SetEntityHeading(emotePed, rot.z + 180)
                CreateThread(function()
                end)
                if currentEmote ~= nil then
                    if currentEmote.dict ~= nil and currentEmote.anim == nil then
                        if currentEmote.dict == "zizi" then
                            ClearPedTasksImmediately(emotePed)
                            ResetPedMovementClipset(emotePed)
                            lastAnim = nil

                        else
                            ClearPedTasksImmediately(emotePed)
                            if lastAnim == nil then 
                                lastAnim = currentEmote
                                RequestDemarcheThing(tostring(currentEmote.dict))
                                SetPedMovementClipset(emotePed, tostring(currentEmote.dict), 0.2)
                                RemoveAnimSet(tostring(currentEmote.dict))

                            end
                            if lastAnim ~= nil and lastAnim.dict ~= nil then 
                                if lastAnim.dict ~= currentEmote.dict then
                                    lastAnim = currentEmote
                                    RequestDemarcheThing(tostring(currentEmote.dict))
                                    SetPedMovementClipset(emotePed, tostring(currentEmote.dict), 0.2)
                                    RemoveAnimSet(tostring(currentEmote.dict))
                                end
                            end
                        end
                    end
                    if currentEmote.dict ~= nil and currentEmote.anim ~= nil  then
                        if lastAnim == nil then 
                            lastAnim = currentEmote
                            if prop ~= nil then 
                                DeleteEntity(prop)
                                prop = nil
                            end
                            if currentEmote.dict ~= "MaleScenario" and currentEmote.dict ~= "Scenario" and currentEmote.dict ~= "Expression" then
                                Citizen.CreateThread(function()
                                    ClearPedTasksImmediately(emotePed)
                                    while not HasAnimDictLoaded(currentEmote.dict) do
                                        RequestAnimDict(currentEmote.dict)
                                        Wait(10)
                                    end
                                    TaskPlayAnim(emotePed, currentEmote.dict, currentEmote.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
                                end)
                            else
                                if currentEmote.dict == "Expression" then
                                    SetFacialIdleAnimOverride(emotePed, currentEmote.anim, 0)
                                else
                                    ClearPedTasksImmediately(emotePed)
                                    TaskStartScenarioInPlace(emotePed, currentEmote.anim, 0, true)
                                end
                            end
                        end
                        if lastAnim ~= nil and lastAnim.dict ~= nil and lastAnim.anim ~= nil then
                            if not currentEmote.dict then
                                return
                            end
                            if lastAnim.anim ~= currentEmote.anim then
                                if prop ~= nil then 
                                    DeleteEntity(prop)
                                    prop = nil
                                end
                                if currentEmote.dict ~= "MaleScenario" and currentEmote.dict ~= "Scenario" and currentEmote.dict ~= "Expression" then
                                    ClearPedTasksImmediately(emotePed)

                                    Citizen.CreateThread(function()
                                        while not HasAnimDictLoaded(currentEmote.dict) do
                                            RequestAnimDict(currentEmote.dict)
                                            Wait(10)
                                        end
                                        TaskPlayAnim(emotePed, currentEmote.dict, currentEmote.anim, 8.0, -8.0, -1, 1, 0, false, false, false)
                                    end)
                                else
                                    if currentEmote.dict == "Expression" then
                                        SetFacialIdleAnimOverride(emotePed, currentEmote.anim, 0)
                                    else
                                        ClearPedTasksImmediately(emotePed)
                                        TaskStartScenarioInPlace(emotePed, currentEmote.anim, 0, true)
                                    end
                                end
                                lastAnim = currentEmote
                                if currentEmote.prop ~= nil and currentEmote.propbone ~= nil and currentEmote.PropPlacement ~= nil then 
                                    if prop ~= nil then 
                                        DeleteEntity(prop)
                                        prop = nil
                                    end
                                    local Player = emotePed
                                    local x, y, z = table.unpack(GetEntityCoords(Player))
                                    if currentEmote.dict ~= "MaleScenario" and currentEmote.dict ~= "Scenario" and currentEmote.dict ~= "Expression" and currentEmote.prop ~= nil then
                                        if IsModelInCdimage(GetHashKey(currentEmote.prop)) and IsModelValid(GetHashKey(currentEmote.prop)) then
                                            Citizen.CreateThread(function()
                                                LoadPropDict(currentEmote.prop)
                                                for k,v in pairs(CreatedProps) do
                                                    DeleteEntity(v)
                                                end

                                                prop = CreateObject(GetHashKey(currentEmote.prop), x, y, z + 0.2, false, false, false)
                                                table.insert(CreatedProps, prop)
                                                if currentEmote.PropPlacement == nil then
                                                    currentEmote.PropPlacement = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0}
                                                end
                                                AttachEntityToEntity(prop, Player, GetPedBoneIndex(Player, currentEmote.propbone), currentEmote.PropPlacement[1], currentEmote.PropPlacement[2], currentEmote.PropPlacement[3], currentEmote.PropPlacement[4], currentEmote.PropPlacement[5], currentEmote.PropPlacement[6], true, true, false, true, 1, true)
                                                SetModelAsNoLongerNeeded(currentEmote.prop)
                                            end)
                                        else
                                            print("passe pas "..currentEmote.prop)
                                        end
                                    end
                                end
                            end
                        end 
                    end
                end

            else
                if emotePed then
                    SetEntityVisible(emotePed, false, false) -- Cachez le Ped si le menu n'est pas visible
                end
            end
   
            RageUI.IsVisible(RMenu:Get('animation', 'main'), true, false, true, function()
                RageUI.ButtonWithStyle("Animations", nil, {RightLabel = "»»»"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'animations'))
                RageUI.ButtonWithStyle("Humeur", nil, {RightLabel = "»»»"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'humor'))
                RageUI.ButtonWithStyle("Démarche", nil, {RightLabel = "»»»"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'walks'))
                RageUI.ButtonWithStyle("Animation sortie d'arme", nil, {RightLabel = "»»»"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'holsterAnim'))
            end)
            
            RageUI.IsVisible(RMenu:Get('animation', 'holsterAnim'), true, false, true, function()

                for k,v in pairs(holsterAnims) do
                    RageUI.ButtonWithStyle(v.label, nil, {RightLabel = "»»»"}, true, function(Hovered, Active, Selected)
                        -- if Active then
                        -- end
                        if Selected then
                            SetResourceKvp("HolsterAnim", v.name)
                            playerHolsterAnim = GetResourceKvpString("HolsterAnim")
                        end
                    end)
                end

            end)

--            RageUI.IsVisible(RMenu:Get('animation', 'aimstyles'), true, false, true, function()
--
--                if currentIndex["aimstyle"] == nil then currentIndex["aimstyle"] = 1 end
--                RageUI.ButtonWithStyle("Style de visée", nil, {RightLabel = "« "..DP.GunStyles[currentIndex["aimstyle"]].name.." »"}, true, function(Hovered, Active, Selected)
--                    if Active then
--                        if IsControlJustPressed(0, 174) then
--                            if currentIndex["aimstyle"] - 1 < 1 then
--                                currentIndex["aimstyle"] = #DP.GunStyles
--                            else
--                                currentIndex["aimstyle"] = currentIndex["aimstyle"] - 1
--                            end
--                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
--                        end
--
--                        if IsControlJustPressed(0, 175) then
--                            if currentIndex["aimstyle"] + 1 > #DP.GunStyles then
--                                currentIndex["aimstyle"] = 1
--                            else
--                                currentIndex["aimstyle"] = currentIndex["aimstyle"] + 1
--                            end
--                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
--                        end
--                        if DP.GunStyles[currentIndex["aimstyle"]].a ~= nil and DP.GunStyles[currentIndex["aimstyle"]].b ~= nil and DP.GunStyles[currentIndex["aimstyle"]].c ~= nil  then
--                            currentEmote = {dict = DP.GunStyles[currentIndex["aimstyle"]].b, anim = DP.GunStyles[currentIndex["aimstyle"]].c}
--                        elseif DP.GunStyles[currentIndex["aimstyle"]].a ~= nil and DP.GunStyles[currentIndex["aimstyle"]].b == nil and DP.GunStyles[currentIndex["aimstyle"]].c == nil then 
--                            currentEmote = {dict = "zizi"}
--
--                        end                    end
--
--                    if Selected then
--                        SetResourceKvp("gunstyle", tostring(currentIndex["aimstyle"]))
--
--                        DecorSetInt(PlayerPedId(), "gunstyle", currentIndex["aimstyle"])
--                        SetWeaponAnimationOverride(PlayerPedId(), GetHashKey(DP.GunStyles[currentIndex["aimstyle"]].a))
--                        ClearPedTasksImmediately(PlayerPedId())
--                    end
--                end)
--
--            end)

            RageUI.IsVisible(RMenu:Get('animation', 'walks'), true, false, true, function()

                if currentIndex["Par défaut"] == nil then currentIndex["Par défaut"] = 1 end
                RageUI.ButtonWithStyle("Par défaut", nil, {RightLabel = "« "..expression[currentIndex["Par défaut"]].." »"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if IsControlJustPressed(0, 174) then
                            if currentIndex["Par défaut"] - 1 < 1 then
                                currentIndex["Par défaut"] = #expression
                            else
                                currentIndex["Par défaut"] = currentIndex["Par défaut"] - 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end

                        if IsControlJustPressed(0, 175) then
                            if currentIndex["Par défaut"] + 1 > #expression then
                                currentIndex["Par défaut"] = 1
                            else
                                currentIndex["Par défaut"] = currentIndex["Par défaut"] + 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end
                        currentEmote = {dict = "zizi"}
                    end

                    if Selected then
                        if expression[currentIndex["Par défaut"]] == "▶" then
                            if GetResourceKvpString("favoriteWalk") then
                                DeleteResourceKvp("favoriteWalk")
                            end
                            ResetPedMovementClipset(PlayerPedId())
                        elseif expression[currentIndex["Par défaut"]] == "⭐" then
                            if GetResourceKvpString("favoriteWalk") then
                                DeleteResourceKvp("favoriteWalk")
                            end

                            ResetPedMovementClipset(PlayerPedId())
                        end
                    end
                end)

                for k,v in pairsByKeys(DP.Walks) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(k, nil, {RightLabel = "« "..expression[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #expression
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #expression then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end
                            if DP.Walks[k] then
                                currentEmote = { dict = x }
                            end
                        end

                        if Selected then
                            if expression[currentIndex[k]] == "▶" then
                                RequestDemarcheThing(tostring(x))
                                SetResourceKvp("favoriteWalk", tostring(x))

                                SetPedMovementClipset(PlayerPedId(), tostring(x), 0.2)
                                RemoveAnimSet(tostring(x))
                            elseif expression[currentIndex[k]] == "⭐" then
                                SetResourceKvp("favoriteWalk", tostring(x))
                                RequestDemarcheThing(tostring(x))
                                SetPedMovementClipset(PlayerPedId(), tostring(x), 0.2)
                                RemoveAnimSet(tostring(x))
                            end
                        end
                    end)
                end
                
            end)
            
            RageUI.IsVisible(RMenu:Get('animation', 'humor'), true, false, true, function()

                if currentIndex["Par défaut"] == nil then currentIndex["Par défaut"] = 1 end
                RageUI.ButtonWithStyle("Par défaut", nil, {RightLabel = "« "..expression[currentIndex["Par défaut"]].." »"}, true, function(Hovered, Active, Selected)
                    if Active then
                        if IsControlJustPressed(0, 174) then
                            if currentIndex["Par défaut"] - 1 < 1 then
                                currentIndex["Par défaut"] = #expression
                            else
                                currentIndex["Par défaut"] = currentIndex["Par défaut"] - 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end

                        if IsControlJustPressed(0, 175) then
                            if currentIndex["Par défaut"] + 1 > #expression then
                                currentIndex["Par défaut"] = 1
                            else
                                currentIndex["Par défaut"] = currentIndex["Par défaut"] + 1
                            end
                            RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                        end
                    end

                    if Selected then
                        if expression[currentIndex["Par défaut"]] == "▶" then
                            ClearFacialIdleAnimOverride(PlayerPedId())
                            
                        elseif expression[currentIndex["Par défaut"]] == "⭐" then
                            if GetResourceKvpString("favoritehumor") then
                                DeleteResourceKvp("favoritehumor")
                            end
                            ClearFacialIdleAnimOverride(PlayerPedId())
                        end
                    end
                end)

                for k,v in pairsByKeys(DP.Expressions) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(k, nil, {RightLabel = "« "..expression[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #expression
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #expression then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end
                            currentEmote = {dict = DP.Expressions[k][1], anim = DP.Expressions[k][2]}

                        end

                        if Selected then
                            if expression[currentIndex[k]] == "▶" then
                                EmoteMenuStart(tostring(k), "expression")
                                SetResourceKvp("favoritehumor", tostring(k))
                            elseif expression[currentIndex[k]] == "⭐" then
                                SetResourceKvp("favoritehumor", tostring(k))
                                EmoteMenuStart(tostring(k), "expression")
                            end
                        end
                    end)
                end
                
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'animations'), true, false, true, function()
                SearchHeader("Rechercher dans Animations")
                RageUI.ButtonWithStyle("Ajuster l'animation", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                    if Selected then
                        ExecuteCommand("ajuster")
                        inMenu = false
                        RageUI.CloseAll()
                    end
                end)
                RageUI.Separator("")
                RageUI.ButtonWithStyle("Danses", nil, {RightLabel = "🕺🏽"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'danses'))
                RageUI.ButtonWithStyle("Animations en véhicule", nil, {RightLabel = "🚘"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'vehicle'))
                RageUI.ButtonWithStyle("Animations d'animaux", nil, {RightLabel = "🐶"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'animals'))
                RageUI.ButtonWithStyle("Animations avec objet", nil, {RightLabel = "📦"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'objects'))
                RageUI.ButtonWithStyle("Animations partagées", nil, {RightLabel = "🧒🏽"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'shared'))
                RageUI.ButtonWithStyle("Animations pour s'asseoir", nil, {RightLabel = "🪑"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'sit'))
                RageUI.ButtonWithStyle("Animations de sport", nil, {RightLabel = "🏋🏽‍♀️"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'sports'))
                RageUI.ButtonWithStyle("Animations de saluts", nil, {RightLabel = "🖖🏽"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'salutes'))
                RageUI.ButtonWithStyle("Animations de poses", nil, {RightLabel = "🕺🏽"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'poses'))
                RageUI.ButtonWithStyle("Animations PEGI 18", nil, {RightLabel = "🔞"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'pegi'))
                RageUI.ButtonWithStyle("Animations de gangs", nil, {RightLabel = "🔪"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'gangs'))
                RageUI.ButtonWithStyle("Animations de Noël", nil, {RightLabel = "🎄"}, true, function(Hovered, Active, Selected) end, RMenu:Get('animation', 'noel'))

                RageUI.Separator("")
                for k,v in pairsByKeys(DP.Emotes) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z = table.unpack(v)
                    if matchesSearch(k, z) then
                        RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.Emotes[k][1] ~= nil and DP.Emotes[k][2] ~= nil then
                                    if DP.Emotes[k].AnimationOptions ~= nil and DP.Emotes[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.Emotes[k][1], anim = DP.Emotes[k][2], prop = DP.Emotes[k].AnimationOptions.Prop, propbone = DP.Emotes[k].AnimationOptions.PropBone, PropPlacement = DP.Emotes[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.Emotes[k][1], anim = DP.Emotes[k][2]}
                                    end
                                end
                            end
                            if Selected then
                                if choices[currentIndex[k]] == "▶" then
                                    EmoteMenuStart(tostring(string.lower(k)), "emotes")
                                elseif choices[currentIndex[k]] == "🛑" then
                                    EmoteCancel()
                                else
                                    if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                        local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                        currentKey = tonumber(currentKey)
                                        SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                    end
                                end
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'noel'), true, false, true, function()
                SearchHeader("Rechercher dans Noël")

                for index, data in ipairs(DP.Noel) do
                    if data.label and data.key and data.type then
                        local idxKey = "noel_"..index
                        if currentIndex[idxKey] == nil then
                            currentIndex[idxKey] = 1
                        end

                        local rightLabelChoice = "« "..choices[currentIndex[idxKey]].." »"
                        local subtitle = ""

                        if data.type == "shared" then
                            subtitle = "/nearby (~y~"..data.key.."~s~)"
                        else
                            subtitle = "/e ("..data.key..")"
                        end

                        if matchesSearch(data.key, data.label) then
                            RageUI.ButtonWithStyle(data.label, subtitle, {RightLabel = rightLabelChoice}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if IsControlJustPressed(0, 174) then
                                        if currentIndex[idxKey] - 1 < 1 then
                                            currentIndex[idxKey] = #choices
                                        else
                                            currentIndex[idxKey] = currentIndex[idxKey] - 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end

                                    if IsControlJustPressed(0, 175) then
                                        if currentIndex[idxKey] + 1 > #choices then
                                            currentIndex[idxKey] = 1
                                        else
                                            currentIndex[idxKey] = currentIndex[idxKey] + 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end

                                    local emoteData = DP.Emotes[data.key]
                                        or DP.Dances and DP.Dances[data.key]
                                        or DP.AnimalEmotes and DP.AnimalEmotes[data.key]
                                        or DP.PropEmotes and DP.PropEmotes[data.key]
                                        or DP.Sits and DP.Sits[data.key]
                                        or DP.Pegi and DP.Pegi[data.key]
                                        or DP.VehicleAnimations and DP.VehicleAnimations[data.key]
                                        or DP.Sports and DP.Sports[data.key]
                                        or DP.Salutes and DP.Salutes[data.key]
                                        or DP.Poses and DP.Poses[data.key]
                                        or DP.Gangs and DP.Gangs[data.key]
                                        or DP.Shared and DP.Shared[data.key]

                                    if emoteData and emoteData[1] and emoteData[2] then
                                        if emoteData.AnimationOptions ~= nil and emoteData.AnimationOptions.Prop then
                                            currentEmote = {
                                                dict = emoteData[1],
                                                anim = emoteData[2],
                                                prop = emoteData.AnimationOptions.Prop,
                                                propbone = emoteData.AnimationOptions.PropBone,
                                                PropPlacement = emoteData.AnimationOptions.PropPlacement
                                            }
                                        else
                                            currentEmote = {
                                                dict = emoteData[1],
                                                anim = emoteData[2]
                                            }
                                        end
                                    end
                                end

                                if Selected then
                                    local choice = choices[currentIndex[idxKey]]

                                    if choice == "▶" then
                                        if data.type == "shared" then
                                            local target, distance = GetClosestPlayer()
                                            if distance ~= -1 and distance < 3 then
                                                TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), data.key)
                                                SimpleNotify(CFGDPEMOTES.Languages[lang]['sentrequestto']..GetPlayerName(target))
                                            else
                                                SimpleNotify(CFGDPEMOTES.Languages[lang]['nobodyclose'])
                                            end
                                        else
                                            EmoteCommandStart(0, {
                                                [1] = tostring(string.lower(data.key))
                                            })
                                        end
                                    elseif choice == "🛑" then
                                        EmoteCancel()
                                    else
                                        if data.type ~= "shared" and currentIndex[idxKey] > 2 and currentIndex[idxKey] <= 7 then
                                            local currentKey = string.gsub(choices[currentIndex[idxKey]], "Raccourcis #", "")
                                            currentKey = tonumber(currentKey)
                                            SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(data.key)))
                                        end
                                    end
                                end
                            end)
                        end
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'danses'), true, false, true, function()
                SearchHeader("Rechercher dans Danses")
                for k,v in pairsByKeys(DP.Dances) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z = table.unpack(v)
                    if matchesSearch(k, z) then
                        RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.Dances[k][1] ~= nil and DP.Dances[k][2] ~= nil then
                                    if DP.Dances[k].AnimationOptions ~= nil and DP.Dances[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.Dances[k][1], anim = DP.Dances[k][2], prop = DP.Dances[k].AnimationOptions.Prop, propbone = DP.Dances[k].AnimationOptions.PropBone, PropPlacement = DP.Dances[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.Dances[k][1], anim = DP.Dances[k][2]}
                                    end
                                end
                            end
                            if Selected then
                                if choices[currentIndex[k]] == "▶" then
                                    EmoteMenuStart(tostring(string.lower(k)), "dances")
                                elseif choices[currentIndex[k]] == "🛑" then
                                    EmoteCancel()
                                else
                                    if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                        local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                        currentKey = tonumber(currentKey)
                                        SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                    end
                                end
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'animals'), true, false, true, function()
                SearchHeader("Rechercher dans Animaux")
                for k,v in pairsByKeys(DP.AnimalEmotes) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z = table.unpack(v)
                    if matchesSearch(k, z) then
                        RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.AnimalEmotes[k][1] ~= nil and DP.AnimalEmotes[k][2] ~= nil then
                                    if DP.AnimalEmotes[k].AnimationOptions ~= nil and DP.AnimalEmotes[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.AnimalEmotes[k][1], anim = DP.AnimalEmotes[k][2], prop = DP.AnimalEmotes[k].AnimationOptions.Prop, propbone = DP.AnimalEmotes[k].AnimationOptions.PropBone, PropPlacement = DP.AnimalEmotes[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.AnimalEmotes[k][1], anim = DP.AnimalEmotes[k][2]}
                                    end
                                end
                            end
                            if Selected then
                                if choices[currentIndex[k]] == "▶" then
                                    EmoteMenuStart(tostring(string.lower(k)), "animals")
                                elseif choices[currentIndex[k]] == "🛑" then
                                    EmoteCancel()
                                else
                                    if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                        local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                        currentKey = tonumber(currentKey)
                                        SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                    end
                                end
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'objects'), true, false, true, function()
                SearchHeader("Rechercher dans Objets")
                for k,v in pairsByKeys(DP.PropEmotes) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z = table.unpack(v)
                    if matchesSearch(k, z) then
                        RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.PropEmotes[k][1] ~= nil and DP.PropEmotes[k][2] ~= nil then
                                    if DP.PropEmotes[k].AnimationOptions ~= nil and DP.PropEmotes[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.PropEmotes[k][1], anim = DP.PropEmotes[k][2], prop = DP.PropEmotes[k].AnimationOptions.Prop, propbone = DP.PropEmotes[k].AnimationOptions.PropBone, PropPlacement = DP.PropEmotes[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.PropEmotes[k][1], anim = DP.PropEmotes[k][2]}
                                    end
                                end
                            end
                            if Selected then
                                if choices[currentIndex[k]] == "▶" then
                                    EmoteMenuStart(tostring(string.lower(k)), "props")
                                elseif choices[currentIndex[k]] == "🛑" then
                                    EmoteCancel()
                                else
                                    if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                        local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                        currentKey = tonumber(currentKey)
                                        SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                    end
                                end
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'shared'), true, false, true, function()
                SearchHeader("Rechercher dans Partagées")
                for k,v in pairsByKeys(DP.Shared) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z, otheremotename = table.unpack(v)
                    if otheremotename == nil then
                        if matchesSearch(k, z) then
                            RageUI.ButtonWithStyle(z, "/nearby (~y~"..k.."~s~)", {RightLabel = "»»»"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if IsControlJustPressed(0, 174) then
                                        if currentIndex[k] - 1 < 1 then
                                            currentIndex[k] = #choices
                                        else
                                            currentIndex[k] = currentIndex[k] - 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end
                                    if IsControlJustPressed(0, 175) then
                                        if currentIndex[k] + 1 > #choices then
                                            currentIndex[k] = 1
                                        else
                                            currentIndex[k] = currentIndex[k] + 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end
                                    if DP.Shared[k][1] ~= nil and DP.Shared[k][2] ~= nil then
                                        if DP.Shared[k].AnimationOptions ~= nil and DP.Shared[k].AnimationOptions.Prop then
                                            currentEmote = {dict = DP.Shared[k][1], anim = DP.Shared[k][2], prop = DP.Shared[k].AnimationOptions.Prop, propbone = DP.Shared[k].AnimationOptions.PropBone, PropPlacement = DP.Shared[k].AnimationOptions.PropPlacement}
                                        else
                                            currentEmote = {dict = DP.Shared[k][1], anim = DP.Shared[k][2]}
                                        end
                                    end
                                end
                                if Selected then
                                    target, distance = GetClosestPlayer()
                                    if (distance ~= -1 and distance < 3) then
                                        _, _, rename = table.unpack(DP.Shared[tostring(string.lower(k))])
                                        TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), tostring(string.lower(k)))
                                        SimpleNotify(CFGDPEMOTES.Languages[lang]['sentrequestto']..GetPlayerName(target))
                                    else
                                        SimpleNotify(CFGDPEMOTES.Languages[lang]['nobodyclose'])
                                    end
                                end
                            end)
                        end
                    else
                        if matchesSearch(k, z) then
                            RageUI.ButtonWithStyle(z, "/nearby (~y~"..k.."~s~) "..CFGDPEMOTES.Languages[lang]['makenearby'].." (~y~"..otheremotename.."~s~)", {RightLabel = "»»»"}, true, function(Hovered, Active, Selected)
                                if Active then
                                    if IsControlJustPressed(0, 174) then
                                        if currentIndex[k] - 1 < 1 then
                                            currentIndex[k] = #choices
                                        else
                                            currentIndex[k] = currentIndex[k] - 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end
                                    if IsControlJustPressed(0, 175) then
                                        if currentIndex[k] + 1 > #choices then
                                            currentIndex[k] = 1
                                        else
                                            currentIndex[k] = currentIndex[k] + 1
                                        end
                                        RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                    end
                                end
                                if Selected then
                                    target, distance = GetClosestPlayer()
                                    if (distance ~= -1 and distance < 3) then
                                        _, _, rename = table.unpack(DP.Shared[tostring(string.lower(k))])
                                        TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), tostring(string.lower(k)))
                                        SimpleNotify(CFGDPEMOTES.Languages[lang]['sentrequestto']..GetPlayerName(target))
                                    else
                                        SimpleNotify(CFGDPEMOTES.Languages[lang]['nobodyclose'])
                                    end
                                end
                            end)
                        end
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'sit'), true, false, true, function()
                SearchHeader("Rechercher dans S'asseoir")
                for k,v in pairsByKeys(DP.Sits) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z = table.unpack(v)
                    if matchesSearch(k, z) then
                        RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.Sits[k][1] ~= nil and DP.Sits[k][2] ~= nil then
                                    if DP.Sits[k].AnimationOptions ~= nil and DP.Sits[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.Sits[k][1], anim = DP.Sits[k][2], prop = DP.Sits[k].AnimationOptions.Prop, propbone = DP.Sits[k].AnimationOptions.PropBone, PropPlacement = DP.Sits[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.Sits[k][1], anim = DP.Sits[k][2]}
                                    end
                                end
                            end
                            if Selected then
                                if choices[currentIndex[k]] == "▶" then
                                    EmoteMenuStart(tostring(string.lower(k)), "sit")
                                elseif choices[currentIndex[k]] == "🛑" then
                                    EmoteCancel()
                                else
                                    if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                        local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                        currentKey = tonumber(currentKey)
                                        SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                    end
                                end
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'pegi'), true, false, true, function()
                SearchHeader("Rechercher dans PEGI 18")
                for k,v in pairsByKeys(DP.Pegi) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z = table.unpack(v)
                    if matchesSearch(k, z) then
                        RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.Pegi[k][1] ~= nil and DP.Pegi[k][2] ~= nil then
                                    if DP.Pegi[k].AnimationOptions ~= nil and DP.Pegi[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.Pegi[k][1], anim = DP.Pegi[k][2], prop = DP.Pegi[k].AnimationOptions.Prop, propbone = DP.Pegi[k].AnimationOptions.PropBone, PropPlacement = DP.Pegi[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.Pegi[k][1], anim = DP.Pegi[k][2]}
                                    end
                                end
                            end
                            if Selected then
                                if choices[currentIndex[k]] == "▶" then
                                    EmoteMenuStart(tostring(string.lower(k)), "pegi")
                                elseif choices[currentIndex[k]] == "🛑" then
                                    EmoteCancel()
                                else
                                    if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                        local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                        currentKey = tonumber(currentKey)
                                        SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                    end
                                end
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'vehicle'), true, false, true, function()
                SearchHeader("Rechercher dans En véhicule")
                for k,v in pairsByKeys(DP.VehicleAnimations) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z = table.unpack(v)
                    if matchesSearch(k, z) then
                        RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.VehicleAnimations[k][1] ~= nil and DP.VehicleAnimations[k][2] ~= nil then
                                    if DP.VehicleAnimations[k].AnimationOptions ~= nil and DP.VehicleAnimations[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.VehicleAnimations[k][1], anim = DP.VehicleAnimations[k][2], prop = DP.VehicleAnimations[k].AnimationOptions.Prop, propbone = DP.VehicleAnimations[k].AnimationOptions.PropBone, PropPlacement = DP.VehicleAnimations[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.VehicleAnimations[k][1], anim = DP.VehicleAnimations[k][2]}
                                    end
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                            end
                            if Selected then
                                if choices[currentIndex[k]] == "▶" then
                                    EmoteMenuStart(tostring(string.lower(k)), "vehicle")
                                elseif choices[currentIndex[k]] == "🛑" then
                                    EmoteCancel()
                                else
                                    if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                        local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                        currentKey = tonumber(currentKey)
                                        SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                    end
                                end
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'sports'), true, false, true, function()
                SearchHeader("Rechercher dans Sport")
                for k,v in pairsByKeys(DP.Sports) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z = table.unpack(v)
                    if matchesSearch(k, z) then
                        RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.Sports[k][1] ~= nil and DP.Sports[k][2] ~= nil then
                                    if DP.Sports[k].AnimationOptions ~= nil and DP.Sports[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.Sports[k][1], anim = DP.Sports[k][2], prop = DP.Sports[k].AnimationOptions.Prop, propbone = DP.Sports[k].AnimationOptions.PropBone, PropPlacement = DP.Sports[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.Sports[k][1], anim = DP.Sports[k][2]}
                                    end
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                            end
                            if Selected then
                                if choices[currentIndex[k]] == "▶" then
                                    EmoteMenuStart(tostring(string.lower(k)), "sports")
                                elseif choices[currentIndex[k]] == "🛑" then
                                    EmoteCancel()
                                else
                                    if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                        local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                        currentKey = tonumber(currentKey)
                                        SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                    end
                                end
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'salutes'), true, false, true, function()
                SearchHeader("Rechercher dans Saluts")
                for k,v in pairsByKeys(DP.Salutes) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z = table.unpack(v)
                    if matchesSearch(k, z) then
                        RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.Salutes[k][1] ~= nil and DP.Salutes[k][2] ~= nil then
                                    if DP.Salutes[k].AnimationOptions ~= nil and DP.Salutes[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.Salutes[k][1], anim = DP.Salutes[k][2], prop = DP.Salutes[k].AnimationOptions.Prop, propbone = DP.Salutes[k].AnimationOptions.PropBone, PropPlacement = DP.Salutes[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.Salutes[k][1], anim = DP.Salutes[k][2]}
                                    end
                                end
                            end
                            if Selected then
                                if choices[currentIndex[k]] == "▶" then
                                    EmoteMenuStart(tostring(string.lower(k)), "salutes")
                                elseif choices[currentIndex[k]] == "🛑" then
                                    EmoteCancel()
                                else
                                    if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                        local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                        currentKey = tonumber(currentKey)
                                        SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                    end
                                end
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'poses'), true, false, true, function()
                SearchHeader("Rechercher dans Poses")
                for k,v in pairsByKeys(DP.Poses) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z = table.unpack(v)
                    if matchesSearch(k, z) then
                        RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.Poses[k][1] ~= nil and DP.Poses[k][2] ~= nil then
                                    if DP.Poses[k].AnimationOptions ~= nil and DP.Poses[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.Poses[k][1], anim = DP.Poses[k][2], prop = DP.Poses[k].AnimationOptions.Prop, propbone = DP.Poses[k].AnimationOptions.PropBone, PropPlacement = DP.Poses[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.Poses[k][1], anim = DP.Poses[k][2]}
                                    end
                                end
                            end
                            if Selected then
                                if choices[currentIndex[k]] == "▶" then
                                    EmoteMenuStart(tostring(string.lower(k)), "poses")
                                elseif choices[currentIndex[k]] == "🛑" then
                                    EmoteCancel()
                                else
                                    if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                        local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                        currentKey = tonumber(currentKey)
                                        SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                    end
                                end
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'gangs'), true, false, true, function()
                SearchHeader("Rechercher dans Gangs")
                for k,v in pairsByKeys(DP.Gangs) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end
                    local x, y, z = table.unpack(v)
                    if matchesSearch(k, z) then
                        RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                            if Active then
                                if IsControlJustPressed(0, 174) then
                                    if currentIndex[k] - 1 < 1 then
                                        currentIndex[k] = #choices
                                    else
                                        currentIndex[k] = currentIndex[k] - 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if IsControlJustPressed(0, 175) then
                                    if currentIndex[k] + 1 > #choices then
                                        currentIndex[k] = 1
                                    else
                                        currentIndex[k] = currentIndex[k] + 1
                                    end
                                    RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                                end
                                if DP.Gangs[k][1] ~= nil and DP.Gangs[k][2] ~= nil then
                                    if DP.Gangs[k].AnimationOptions ~= nil and DP.Gangs[k].AnimationOptions.Prop then
                                        currentEmote = {dict = DP.Gangs[k][1], anim = DP.Gangs[k][2], prop = DP.Gangs[k].AnimationOptions.Prop, propbone = DP.Gangs[k].AnimationOptions.PropBone, PropPlacement = DP.Gangs[k].AnimationOptions.PropPlacement}
                                    else
                                        currentEmote = {dict = DP.Gangs[k][1], anim = DP.Gangs[k][2]}
                                    end
                                end
                            end
                            if Selected then
                                if choices[currentIndex[k]] == "▶" then
                                    EmoteMenuStart(tostring(string.lower(k)), "gangs")
                                elseif choices[currentIndex[k]] == "🛑" then
                                    EmoteCancel()
                                else
                                    if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                        local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                        currentKey = tonumber(currentKey)
                                        SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                    end
                                end
                            end
                        end)
                    end
                end
            end)

            RageUI.IsVisible(RMenu:Get('animation', 'sit'), true, false, true, function()

                for k,v in pairsByKeys(DP.Sits) do
                    if currentIndex[k] == nil then currentIndex[k] = 1 end

                    x, y, z = table.unpack(v)

                    RageUI.ButtonWithStyle(z, "/e ("..k..")", {RightLabel = "« "..choices[currentIndex[k]].." »"}, true, function(Hovered, Active, Selected)
                        if Active then
                            if IsControlJustPressed(0, 174) then
                                if currentIndex[k] - 1 < 1 then
                                    currentIndex[k] = #choices
                                else
                                    currentIndex[k] = currentIndex[k] - 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end

                            if IsControlJustPressed(0, 175) then
                                if currentIndex[k] + 1 > #choices then
                                    currentIndex[k] = 1
                                else
                                    currentIndex[k] = currentIndex[k] + 1
                                end
                                RageUI.PlaySound("HUD_FRONTEND_DEFAULT_SOUNDSET", "NAV_LEFT_RIGHT")
                            end
                            if DP.Sits[k][1] ~= nil and DP.Sits[k][2] ~= nil then
                                if DP.Sits[k].AnimationOptions ~= nil and DP.Sits[k].AnimationOptions.Prop then 
                                    currentEmote = {dict = DP.Sits[k][1], anim = DP.Sits[k][2], prop = DP.Sits[k].AnimationOptions.Prop, propbone = DP.Sits[k].AnimationOptions.PropBone, PropPlacement = DP.Sits[k].AnimationOptions.PropPlacement}
                                else
                                    currentEmote = {dict = DP.Sits[k][1], anim = DP.Sits[k][2]}

                                end
                            end
                        end

                        if Selected then
                            if choices[currentIndex[k]] == "▶" then
                                EmoteMenuStart(tostring(string.lower(k)), "sit")
                            elseif choices[currentIndex[k]] == "🛑" then
                                EmoteCancel()
                            else
                                if currentIndex[k] > 2 and currentIndex[k] <= 7 then
                                    local currentKey = string.gsub(choices[currentIndex[k]], "Raccourcis #", "")
                                    currentKey = tonumber(currentKey)

                                    SetResourceKvp("bindedanim_"..currentKey, tostring(string.lower(k)))
                                end
                            end
                        end
                    end)
                end
                
            end)

        end
    end)
end

rightPosition = { x = 1450, y = 100 }
leftPosition = { x = 0, y = 100 }
menuPosition = { x = 0, y = 200 }

if CFGDPEMOTES.MenuPosition then
    if CFGDPEMOTES.MenuPosition == "left" then
        menuPosition = leftPosition
    elseif CFGDPEMOTES.MenuPosition == "right" then
        menuPosition = rightPosition
    end
end

if CFGDPEMOTES.CustomMenuEnabled then
    local RuntimeTXD = CreateRuntimeTxd('Custom_Menu_Head')
    local Object = CreateDui(CFGDPEMOTES.MenuImage, 512, 128)
    _G.Object = Object
    local TextureThing = GetDuiHandle(Object)
    local Texture = CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'Custom_Menu_Head', TextureThing)
    Menuthing = "Custom_Menu_Head"
else
    Menuthing = "shopui_title_sm_hangar"
end

-- _menuPool = NativeUI.CreatePool()
-- mainMenu = NativeUI.CreateMenu("dp Emotes", "", menuPosition["x"], menuPosition["y"], Menuthing, Menuthing)
-- _menuPool:Add(mainMenu)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

-- if CFGDPEMOTES.FavKeybindEnabled then
--     Citizen.CreateThread(function()
--         while true do
--             if IsControlPressed(0, CFGDPEMOTES.FavKeybind) then
--                 if not IsPedSittingInAnyVehicle(PlayerPedId()) then
--                     if FavoriteEmote ~= "" then
--                         EmoteCommandStart(nil, { FavoriteEmote, 0 })
--                         Wait(3000)
--                     end
--                 end
--             end
--             Citizen.Wait(1)
--         end
--     end)
-- end

lang = CFGDPEMOTES.MenuLanguage

function AddEmoteMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, CFGDPEMOTES.Languages[lang]['emotes'], "", "", Menuthing, Menuthing)
    local dancemenu = _menuPool:AddSubMenu(submenu, CFGDPEMOTES.Languages[lang]['danceemotes'], "", "", Menuthing, Menuthing)
    local animalmenu = _menuPool:AddSubMenu(submenu, CFGDPEMOTES.Languages[lang]['animalemotes'], "", "", Menuthing, Menuthing)
    local propmenu = _menuPool:AddSubMenu(submenu, CFGDPEMOTES.Languages[lang]['propemotes'], "", "", Menuthing, Menuthing)
    table.insert(EmoteTable, CFGDPEMOTES.Languages[lang]['danceemotes'])
    table.insert(EmoteTable, CFGDPEMOTES.Languages[lang]['danceemotes'])
    table.insert(EmoteTable, CFGDPEMOTES.Languages[lang]['animalemotes'])

    if CFGDPEMOTES.SharedEmotesEnabled then
        sharemenu = _menuPool:AddSubMenu(submenu, CFGDPEMOTES.Languages[lang]['shareemotes'], CFGDPEMOTES.Languages[lang]['shareemotesinfo'], "", Menuthing, Menuthing)
        shareddancemenu = _menuPool:AddSubMenu(sharemenu, CFGDPEMOTES.Languages[lang]['sharedanceemotes'], "", "", Menuthing, Menuthing)
        table.insert(ShareTable, 'none')
        table.insert(EmoteTable, CFGDPEMOTES.Languages[lang]['shareemotes'])
    end

    if not CFGDPEMOTES.SqlKeybinding then
        unbind2item = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['rfavorite'], CFGDPEMOTES.Languages[lang]['rfavorite'])
        unbinditem = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['prop2info'], "")
        favmenu = _menuPool:AddSubMenu(submenu, CFGDPEMOTES.Languages[lang]['favoriteemotes'], CFGDPEMOTES.Languages[lang]['favoriteinfo'], "", Menuthing, Menuthing)
        favmenu:AddItem(unbinditem)
        favmenu:AddItem(unbind2item)
        table.insert(FavEmoteTable, CFGDPEMOTES.Languages[lang]['rfavorite'])
        table.insert(FavEmoteTable, CFGDPEMOTES.Languages[lang]['rfavorite'])
        table.insert(EmoteTable, CFGDPEMOTES.Languages[lang]['favoriteemotes'])
    else
        table.insert(EmoteTable, "keybinds")
        keyinfo = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['keybinds'], CFGDPEMOTES.Languages[lang]['keybindsinfo'] .. " /emotebind [~y~num4-9~s~] [~y~emotename~s~]")
        submenu:AddItem(keyinfo)
    end

    for a, b in pairsByKeys(DP.Emotes) do
        x, y, z = table.unpack(b)
        emoteitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
        submenu:AddItem(emoteitem)
        table.insert(EmoteTable, a)
        if not CFGDPEMOTES.SqlKeybinding then
            favemoteitem = NativeUI.CreateItem(z, CFGDPEMOTES.Languages[lang]['set'] .. z .. CFGDPEMOTES.Languages[lang]['setboundemote'])
            favmenu:AddItem(favemoteitem)
            table.insert(FavEmoteTable, a)
        end
    end

    for a, b in pairsByKeys(DP.Dances) do
        x, y, z = table.unpack(b)
        danceitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
        sharedanceitem = NativeUI.CreateItem(z, "")
        dancemenu:AddItem(danceitem)
        if CFGDPEMOTES.SharedEmotesEnabled then
            shareddancemenu:AddItem(sharedanceitem)
        end
        table.insert(DanceTable, a)
    end

    for a, b in pairsByKeys(DP.AnimalEmotes) do
        x, y, z = table.unpack(b)
        animalitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
        animalmenu:AddItem(animalitem)
        table.insert(AnimalTable, a)
    end

    if CFGDPEMOTES.SharedEmotesEnabled then
        for a, b in pairsByKeys(DP.Shared) do
            x, y, z, otheremotename = table.unpack(b)
            if otheremotename == nil then
                shareitem = NativeUI.CreateItem(z, "/nearby (~y~" .. a .. "~s~)")
            else
                shareitem = NativeUI.CreateItem(z, "/nearby (~y~" .. a .. "~s~) " .. CFGDPEMOTES.Languages[lang]['makenearby'] .. " (~y~" .. otheremotename .. "~s~)")
            end
            sharemenu:AddItem(shareitem)
            table.insert(ShareTable, a)
        end
    end

    for a, b in pairsByKeys(DP.PropEmotes) do
        x, y, z = table.unpack(b)
        propitem = NativeUI.CreateItem(z, "/e (" .. a .. ")")
        propmenu:AddItem(propitem)
        table.insert(PropETable, a)
        if not CFGDPEMOTES.SqlKeybinding then
            propfavitem = NativeUI.CreateItem(z, CFGDPEMOTES.Languages[lang]['set'] .. z .. CFGDPEMOTES.Languages[lang]['setboundemote'])
            favmenu:AddItem(propfavitem)
            table.insert(FavEmoteTable, a)
        end
    end

    if not CFGDPEMOTES.SqlKeybinding then
        favmenu.OnItemSelect = function(sender, item, index)
            if FavEmoteTable[index] == CFGDPEMOTES.Languages[lang]['rfavorite'] then
                FavoriteEmote = ""
                ShowNotification(CFGDPEMOTES.Languages[lang]['rfavorite'], 2000)
                return
            end
            if CFGDPEMOTES.FavKeybindEnabled then
                FavoriteEmote = FavEmoteTable[index]
                ShowNotification("~o~" .. firstToUpper(FavoriteEmote) .. CFGDPEMOTES.Languages[lang]['newsetemote'])
            end
        end
    end

    dancemenu.OnItemSelect = function(sender, item, index)
        EmoteMenuStart(DanceTable[index], "dances")
    end

    animalmenu.OnItemSelect = function(sender, item, index)
        EmoteMenuStart(AnimalTable[index], "animals")
    end

    if CFGDPEMOTES.SharedEmotesEnabled then
        sharemenu.OnItemSelect = function(sender, item, index)
            if ShareTable[index] ~= 'none' then
                target, distance = GetClosestPlayer()
                if (distance ~= -1 and distance < 3) then
                    _, _, rename = table.unpack(DP.Shared[ShareTable[index]])
                    TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), ShareTable[index])
                    SimpleNotify(CFGDPEMOTES.Languages[lang]['sentrequestto'] .. GetPlayerName(target))
                else
                    SimpleNotify(CFGDPEMOTES.Languages[lang]['nobodyclose'])
                end
            end
        end

        shareddancemenu.OnItemSelect = function(sender, item, index)
            target, distance = GetClosestPlayer()
            if (distance ~= -1 and distance < 3) then
                _, _, rename = table.unpack(DP.Dances[DanceTable[index]])
                TriggerServerEvent("ServerEmoteRequest", GetPlayerServerId(target), DanceTable[index], 'Dances')
                SimpleNotify(CFGDPEMOTES.Languages[lang]['sentrequestto'] .. GetPlayerName(target))
            else
                SimpleNotify(CFGDPEMOTES.Languages[lang]['nobodyclose'])
            end
        end
    end

    propmenu.OnItemSelect = function(sender, item, index)
        EmoteMenuStart(PropETable[index], "props")
    end

    submenu.OnItemSelect = function(sender, item, index)
        if EmoteTable[index] ~= CFGDPEMOTES.Languages[lang]['favoriteemotes'] then
            EmoteMenuStart(EmoteTable[index], "emotes")
        end
    end
end

function AddCancelEmote(menu)
    local newitem = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['cancelemote'], CFGDPEMOTES.Languages[lang]['cancelemoteinfo'])
    menu:AddItem(newitem)
    menu.OnItemSelect = function(sender, item, checked_)
        if item == newitem then
            EmoteCancel()
            DestroyAllPropsDP()
        end
    end
end

function AddWalkMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, CFGDPEMOTES.Languages[lang]['walkingstyles'], "", "", Menuthing, Menuthing)

    walkreset = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['normalreset'], CFGDPEMOTES.Languages[lang]['resetdef'])
    submenu:AddItem(walkreset)
    table.insert(WalkTable, CFGDPEMOTES.Languages[lang]['resetdef'])

    WalkInjured = NativeUI.CreateItem("Injured", "")
    submenu:AddItem(WalkInjured)
    table.insert(WalkTable, "move_m@injured")

    for a, b in pairsByKeys(DP.Walks) do
        x = table.unpack(b)
        walkitem = NativeUI.CreateItem(a, "")
        submenu:AddItem(walkitem)
        table.insert(WalkTable, x)
    end

    submenu.OnItemSelect = function(sender, item, index)
        if item ~= walkreset then
            WalkMenuStart(WalkTable[index])
        else
            ResetPedMovementClipset(PlayerPedId())
        end
    end
end

function AddFaceMenu(menu)
    local submenu = _menuPool:AddSubMenu(menu, CFGDPEMOTES.Languages[lang]['moods'], "", "", Menuthing, Menuthing)

    facereset = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['normalreset'], CFGDPEMOTES.Languages[lang]['resetdef'])
    submenu:AddItem(facereset)
    table.insert(FaceTable, "")

    for a, b in pairsByKeys(DP.Expressions) do
        x, y, z = table.unpack(b)
        faceitem = NativeUI.CreateItem(a, "")
        submenu:AddItem(faceitem)
        table.insert(FaceTable, a)
    end

    submenu.OnItemSelect = function(sender, item, index)
        if item ~= facereset then
            EmoteMenuStart(FaceTable[index], "expression")
        else
            ClearFacialIdleAnimOverride(PlayerPedId())
        end
    end
end

function AddInfoMenu(menu)
    if not UpdateAvailable then
        infomenu = _menuPool:AddSubMenu(menu, CFGDPEMOTES.Languages[lang]['infoupdate'], "(1.7.4)", "", Menuthing, Menuthing)
    else
        infomenu = _menuPool:AddSubMenu(menu, CFGDPEMOTES.Languages[lang]['infoupdateav'], CFGDPEMOTES.Languages[lang]['infoupdateavtext'], "", Menuthing, Menuthing)
    end
    contact = NativeUI.CreateItem(CFGDPEMOTES.Languages[lang]['suggestions'], CFGDPEMOTES.Languages[lang]['suggestionsinfo'])
    u170 = NativeUI.CreateItem("1.7.0", "Added /emotebind [key] [emote]!")
    u165 = NativeUI.CreateItem("1.6.5", "Updated camera/phone/pee/beg, added makeitrain/dance(glowstick/horse).")
    u160 = NativeUI.CreateItem("1.6.0", "Added shared emotes /nearby, or in menu, also fixed some emotes!")
    u151 = NativeUI.CreateItem("1.5.1", "Added /walk and /walks, for walking styles without menu")
    u150 = NativeUI.CreateItem("1.5.0", "Added Facial Expressions menu (if enabled by server owner)")
    infomenu:AddItem(contact)
    infomenu:AddItem(u170)
    infomenu:AddItem(u165)
    infomenu:AddItem(u160)
    infomenu:AddItem(u151)
    infomenu:AddItem(u150)
end

-- function OpenEmoteMenu()
--     mainMenu:Visible(not mainMenu:Visible())
-- end

function firstToUpper(str)
    return (str:gsub("^%l", string.upper))
end

-- AddEmoteMenu(mainMenu)
-- AddCancelEmote(mainMenu)
-- if CFGDPEMOTES.WalkingStylesEnabled then
--     AddWalkMenu(mainMenu)
-- end
-- if CFGDPEMOTES.ExpressionsEnabled then
--     AddFaceMenu(mainMenu)
-- end

-- _menuPool:RefreshIndex()

-- Citizen.CreateThread(function()
--     while true do
--         Citizen.Wait(0)
--         _menuPool:ProcessMenus()
--     end
-- end)
Keys = {}
function Keys.Register(Controls, ControlName, Description, Action)
	RegisterKeyMapping(string.format('%s', ControlName), Description, "keyboard", Controls)
	RegisterCommand(string.format('%s', ControlName), function(source, args)
		if (Action ~= nil) then
			Action();
		end
	end, false)
end

RegisterNetEvent("dp:Update")
AddEventHandler("dp:Update", function(state)
    UpdateAvailable = state
    AddInfoMenu(mainMenu)
    _menuPool:RefreshIndex()
end)

RegisterNetEvent("dp:RecieveMenu") -- For opening the emote menu from another resource.
AddEventHandler("dp:RecieveMenu", function()
    OpenEmoteMenu()
end)

RegisterNetEvent("dp:cancelEmote")
AddEventHandler("dp:cancelEmote", function()
    if exports.property:takedBox() then return end
    EmoteCancel()
end)

Citizen.CreateThread(function()
    for i=1, 5 do
        Keys.Register('', 's'..i, "Raccourcis animation #"..i, function()
            if IsPedDeadOrDying(PlayerPedId()) then return end
            if not IsPedSwimming(PlayerPedId()) and not IsPedShooting(PlayerPedId()) and not IsPedClimbing(PlayerPedId()) and not IsPedCuffed(PlayerPedId()) and not IsPedDiving(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedJumpingOutOfVehicle(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInParachuteFreeFall(PlayerPedId()) then
                local anim = GetResourceKvpString("bindedanim_"..i)

                EmoteCommandStart(0, {
                    [1] = anim
                })
            end
        end)
    end
    Keys.Register('F7', 'menuAnimation', "Menu animation", function()
        if IsPedDeadOrDying(PlayerPedId()) then return end
        if not IsPedSwimming(PlayerPedId()) and not IsPedShooting(PlayerPedId()) and not IsPedClimbing(PlayerPedId()) and not IsPedCuffed(PlayerPedId()) and not IsPedDiving(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedJumpingOutOfVehicle(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInParachuteFreeFall(PlayerPedId()) then
            OpenEmoteMenu()
        end
    end)

    Keys.Register('X', 'cancelAnimation', "Annuler l'animation en cours", function()
        if IsPedDeadOrDying(PlayerPedId()) then return end
        if not IsPedSwimming(PlayerPedId()) and not IsPedShooting(PlayerPedId()) and not IsPedClimbing(PlayerPedId()) and not IsPedCuffed(PlayerPedId()) and not IsPedDiving(PlayerPedId()) and not IsPedFalling(PlayerPedId()) and not IsPedJumpingOutOfVehicle(PlayerPedId()) and not IsPedUsingAnyScenario(PlayerPedId()) and not IsPedInParachuteFreeFall(PlayerPedId()) then
            EmoteCancel()
        end
    end)
end)


-- RegisterCommand("zeubhumide", function ()
--     if emotePed ~= nil then 
--         DeletePed(emotePed)
--     end
--     emotePed = createClone()
--     CreateThread(function()
--         while true do
--             Wait(1)
--             if emotePed and currentEmote then
--                 local coordsCam = GetGameplayCamCoord()
--                 local rotCam = GetGameplayCamRot(2)
--                 local forwardCam = RotationToDirection(rotCam)
--                 local rightCam = RotationToDirection(vector3(rotCam.x, rotCam.y, rotCam.z - 90.0))
--                 local upCam = vector3(0.0, 0.0, 1.0)
    
--                 -- Nous utilisons une très petite valeur pour forward pour s'assurer que le Ped est juste devant la caméra
--                 local forwardOffset = 0.5
--                 local rightOffset = 0.5 -- Ajustez cela si vous voulez le Ped plus à gauche ou à droite
--                 local upOffset = -0.5 -- Ajustez si vous voulez que le Ped soit plus haut ou plus bas dans la vue de la caméra
    
--                 -- Calcul de la nouvelle position pour le Ped
--                 local pedCoords = coordsCam + forwardCam * forwardOffset + rightCam * rightOffset + upCam * upOffset
    
--                 -- Appliquez la matrice pour positionner et orienter le Ped
--                 SetEntityMatrix(emotePed, forwardCam.x, forwardCam.y, forwardCam.z, upCam.x, upCam.y, upCam.z, rightCam.x, rightCam.y, rightCam.z, pedCoords.x, pedCoords.y, pedCoords.z)
    
--                 SetEntityVisible(emotePed, true, false)
--                 SetEntityHeading(emotePed, rotCam.z + 180)
--             else
--                 -- Cachez le Ped quand il n'est pas utilisé
--                 if emotePed then
--                     SetEntityVisible(emotePed, false, false)
--                 end
--             end
--         end
--     end)
    
-- end, false)

