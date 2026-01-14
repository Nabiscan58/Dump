INVENTORY.Permis = {}
INVENTORY.Permis.Open = false
INVENTORY.Permis.OpenPermis = false
INVENTORY.Permis.OpenWeapon = false
INVENTORY.Permis.OpenChasse = false
INVENTORY.Permis.OpenPeche = false
INVENTORY.Permis.LspdOpen = false
INVENTORY.Permis.BcsoOpen = false
INVENTORY.Permis.EmsOpen = false
INVENTORY.Permis.DataId = {
    firstname = "John",
    lastname = "Doe",
    dataofbirth = "02/02/2000",
    sex = "H",
    height = 180
}

INVENTORY.Permis.DataPermis = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    auto = false,
    moto = false,
    truck = false,
    boat = false,
    plane = false,
    height = 180
}

INVENTORY.Permis.DataWeapon = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180
}

INVENTORY.Permis.DataLspd = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180,
    matricule = 1,
    mugshot = nil
}
INVENTORY.Permis.DataBcso = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180,
    matricule = 1,
    mugshot = nil
}

INVENTORY.Permis.DataEms = {
    firstname = "John",
    lastname = "Doe",
    dateofbirth = "02/02/2000",
    sex = "H",
    height = 180,
    matricule = 1,
    mugshot = nil
}
local w, h
local w2, h2
local ww2, hh2
CreateThread(function ()
    w, h = UI.ConvertToPixel(457, 272)
    w2, h2 = UI.ConvertToPixel(108, 141)
    ww2, hh2 = UI.ConvertToPixel(448, 526)
end)
local baseX, baseY = 0.69375002384186, 0.61111110448837
function INVENTORY.Permis.DrawId()
    UI.DrawSpriteNew("permis", "idcard", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
        
    end)

    if string.upper(INVENTORY.Permis.DataId.sex) == "H" or string.upper(INVENTORY.Permis.DataId.sex) == "HOMME" or string.upper(INVENTORY.Permis.DataId.sex) == "M" then
        UI.DrawSpriteNew("permis", "male", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
            
        end)
    else
        UI.DrawSpriteNew("permis", "female", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, INVENTORY.Permis.DataId.firstname.." "..INVENTORY.Permis.DataId.lastname, false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataId.dateofbirth, true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.131, baseY + 0.1, INVENTORY.Permis.DataId.sex, true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.161, baseY + 0.1, INVENTORY.Permis.DataId.height, true, 0.20, {255, 255, 255, 255}, 0, false, false)

    if INVENTORY.Permis.DataId.textureDict and INVENTORY.Permis.DataId.textureName then
        print("zizi")
        local z, x = UI.ConvertToPixel(125, 165)
        UI.DrawSpriteNew(INVENTORY.Permis.DataId.textureDict, INVENTORY.Permis.DataId.textureName, baseX + 0.0010, baseY, z, x, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
end

function INVENTORY.Permis.DrawPermis()
    UI.DrawSpriteNew("permis", "license", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
        
    end)

    if string.upper(INVENTORY.Permis.DataPermis.sex) == "H" or string.upper(INVENTORY.Permis.DataPermis.sex) == "HOMME" or string.upper(INVENTORY.Permis.DataPermis.sex) == "M" then
        UI.DrawSpriteNew("permis", "male", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
            
        end)
    else
        UI.DrawSpriteNew("permis", "female", baseX+ 0.008, baseY + 0.025, w2, h2, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, INVENTORY.Permis.DataPermis.firstname.." "..INVENTORY.Permis.DataPermis.lastname, false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataPermis.dateofbirth, true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.131, baseY + 0.1, INVENTORY.Permis.DataPermis.sex, true, 0.20, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.161, baseY + 0.1, INVENTORY.Permis.DataPermis.height, true, 0.20, {255, 255, 255, 255}, 0, false, false)
    local x, y = UI.ConvertToPixel(24, 24)
    if INVENTORY.Permis.DataPermis.auto then 
        UI.DrawSpriteNew("permis", "car_icon", baseX+ w - 0.052, baseY + 0.11, x, y, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
    if INVENTORY.Permis.DataPermis.moto then 
        UI.DrawSpriteNew("permis", "bike_icon", baseX+ w - 0.052 + 0.002 + x, baseY + 0.11, x, y, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
    if INVENTORY.Permis.DataPermis.truck then
        UI.DrawSpriteNew("permis", "truck_icon", baseX+ w - 0.052 + 0.003+ (x *2), baseY + 0.11, x, y, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
    if INVENTORY.Permis.DataPermis.plane then
        UI.DrawSpriteNew("permis", "plane_icon",  baseX+ w - 0.052, baseY + 0.11 + y + 0.003, x, y, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
    if INVENTORY.Permis.DataPermis.boat then
        UI.DrawSpriteNew("permis", "boat_icon", baseX+ w - 0.052 + 0.003+ (x *2), baseY + 0.11 + y + 0.003, x, y, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
end

function INVENTORY.Permis.DrawWeapon()
    UI.DrawSpriteNew("permis", "firearm", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, INVENTORY.Permis.DataWeapon.firstname.." "..INVENTORY.Permis.DataWeapon.lastname, false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataWeapon.dateofbirth, true, 0.20, {255, 255, 255, 255}, 0, false, false) 
end

function INVENTORY.Permis.DrawPeche()
    UI.DrawSpriteNew("permis", "fishing", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, INVENTORY.Permis.DataWeapon.firstname.." "..INVENTORY.Permis.DataWeapon.lastname, false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataWeapon.dateofbirth, true, 0.20, {255, 255, 255, 255}, 0, false, false) 
end

function INVENTORY.Permis.DrawChasse()
    UI.DrawSpriteNew("permis", "hunter", baseX, baseY, w, h, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)

    UI.DrawTexts(baseX + 0.075, baseY + 0.045, INVENTORY.Permis.DataWeapon.firstname.." "..INVENTORY.Permis.DataWeapon.lastname, false, 0.35, {255, 255, 255, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.091, baseY + 0.1, INVENTORY.Permis.DataWeapon.dateofbirth, true, 0.20, {255, 255, 255, 255}, 0, false, false) 
end

function INVENTORY.Permis.DrawBadgeLSPD()
    UI.DrawSpriteNew("permis", "background_police", baseX, baseY - 0.11, ww2, hh2, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)
    UI.DrawTexts(baseX + 0.12, baseY - 0.028, INVENTORY.Permis.DataLspd.firstname.." "..INVENTORY.Permis.DataLspd.lastname, false, 0.23, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.005, INVENTORY.Permis.DataLspd.dateofbirth, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.175, baseY + 0.035, INVENTORY.Permis.DataLspd.sex, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.147, baseY + 0.035, INVENTORY.Permis.DataLspd.height, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.035, INVENTORY.Permis.DataLspd.matricule, true, 0.20, {0, 0, 0, 255}, 0, false, false)
    if INVENTORY.Permis.DataLspd.textureDict and INVENTORY.Permis.DataLspd.textureName then
        local z, x = UI.ConvertToPixel(120, 130)
        UI.DrawSpriteNew(INVENTORY.Permis.DataLspd.textureDict, INVENTORY.Permis.DataLspd.textureName, baseX + 0.027, baseY - 0.037, z, x, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
end

function INVENTORY.Permis.DrawMariage()
    UI.DrawSpriteNew("permis", "background_mariage", baseX, baseY - 0.11, ww2, hh2, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)

    UI.DrawTexts(baseX + 0.12, baseY - 0.025, INVENTORY.Permis.DataMarriage.self_name, false, 0.23, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.005, INVENTORY.Permis.DataMarriage.spouse_name, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.15, baseY + 0.035, INVENTORY.Permis.DataMarriage.date, true, 0.20, {0, 0, 0, 255}, 0, false, false)
    if INVENTORY.Permis.DataMarriage.textureDict and INVENTORY.Permis.DataMarriage.textureName then
        local z, x = UI.ConvertToPixel(120, 130)
        UI.DrawSpriteNew(INVENTORY.Permis.DataMarriage.textureDict, INVENTORY.Permis.DataMarriage.textureName, baseX + 0.027, baseY - 0.037, z, x, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
end

function INVENTORY.Permis.DrawBadgeSheriff()
    UI.DrawSpriteNew("permis", "background_sheriff", baseX, baseY - 0.11, ww2, hh2, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)
    UI.DrawTexts(baseX + 0.12, baseY - 0.028, INVENTORY.Permis.DataBcso.firstname.." "..INVENTORY.Permis.DataBcso.lastname, false, 0.23, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.005, INVENTORY.Permis.DataBcso.dateofbirth, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.175, baseY + 0.035, INVENTORY.Permis.DataBcso.sex, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.147, baseY + 0.035, INVENTORY.Permis.DataBcso.height, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.035, INVENTORY.Permis.DataBcso.matricule, true, 0.20, {0, 0, 0, 255}, 0, false, false)
    if INVENTORY.Permis.DataBcso.textureDict and INVENTORY.Permis.DataBcso.textureName then
        local z, x = UI.ConvertToPixel(120, 130)
        UI.DrawSpriteNew(INVENTORY.Permis.DataBcso.textureDict, INVENTORY.Permis.DataBcso.textureName,  baseX + 0.027, baseY - 0.037, z, x, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
end

function INVENTORY.Permis.DrawBadgeEms()
    UI.DrawSpriteNew("permis", "background_ems", baseX, baseY - 0.11, ww2, hh2, 0, 255, 255, 255, 255, {
        NoSelect = true,
        NoHover = true,
        devmod = false,
    }, function ()
    end)
    UI.DrawTexts(baseX + 0.12, baseY - 0.028, INVENTORY.Permis.DataEms.firstname.." "..INVENTORY.Permis.DataEms.lastname, false, 0.23, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.005, INVENTORY.Permis.DataEms.dateofbirth, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.175, baseY + 0.035, INVENTORY.Permis.DataEms.sex, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.147, baseY + 0.035, INVENTORY.Permis.DataEms.height, false, 0.20, {0, 0, 0, 255}, 0, false, false)
    UI.DrawTexts(baseX + 0.12, baseY + 0.035, INVENTORY.Permis.DataEms.matricule, true, 0.20, {0, 0, 0, 255}, 0, false, false)
    if INVENTORY.Permis.DataEms.textureDict and INVENTORY.Permis.DataEms.textureName then
        local z, x = UI.ConvertToPixel(120, 130)
        UI.DrawSpriteNew(INVENTORY.Permis.DataEms.textureDict, INVENTORY.Permis.DataEms.textureName,  baseX + 0.027, baseY - 0.037, z, x, 0, 255, 255, 255, 255, {
            NoSelect = true,
            NoHover = true,
            devmod = false,
        }, function ()
        end)
    end
end


-- permisweapon

