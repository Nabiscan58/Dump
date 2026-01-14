local interiors = {

    ["mxc_realestate-paleto-old"] = {
        coords = vec3(-141.3190, 6292.4355, 31.4911),
        sets = {
            ["mxc_realestate_modernstyle"] = false,
            ["mxc_realestate_vintagestyle"] = true,
            ["mxc_realestate_messypaper"] = true,

        }
    },
    ["mxc_realestate-lossantos-modern"] = {
        coords = vec3(75.4036, -253.0999, 48.1971),
        sets = {
            ["mxc_realestate_modernstyle"] = true,
            ["mxc_realestate_vintagestyle"] = false,
            ["mxc_realestate_messypaper"] = false,
        }
    },
}


for name, v in pairs(interiors) do
    RequestIpl(name)
    local interior = GetInteriorAtCoords(v.coords)
 print(name, interior)
    if IsValidInterior(interior) then
        print(name, "valid")
        for name2, enable in pairs(v.sets) do
            print(name, name2, enable)
            if enable then
                ActivateInteriorEntitySet(interior, name2)
            else
                DeactivateInteriorEntitySet(interior, name2)
            end
        end

        RefreshInterior(interior)
    end
end