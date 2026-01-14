---
--- @author Dylan MALANDAIN
--- @version 2.0.0
--- @since 2020
---
--- RageUI Is Advanced UI Libs in LUA for make beautiful interface like RockStar GAME.
---
---
--- Commercial Info.
--- Any use for commercial purposes is strictly prohibited and will be punished.
---
--- @see RageUI
---

---@type table

local SettingsButton = {
    Text = { X = 13, Y = 10, Scale = 0.32 },
    Rectangle = { Y = 1, Width = 358.0, Height = 2.0 },
}


function RageUI.Line(R,G,B,O)
    local CurrentMenu = RageUI.CurrentMenu
    local Description = RageUI.Settings.Items.Description;
    if CurrentMenu ~= nil then
        if CurrentMenu() then
            local Option = RageUI.Options + 1
            if CurrentMenu.Pagination.Minimum <= Option and CurrentMenu.Pagination.Maximum >= Option then
                RenderSprite("ui_rageUI","line", CurrentMenu.X + SettingsButton.Rectangle.Y + 40 + CurrentMenu.SubtitleHeight ,CurrentMenu.Y + 25 +SettingsButton.Rectangle.Y + 1.9 + CurrentMenu.SubtitleHeight + RageUI.ItemOffset,SettingsButton.Rectangle.Width, SettingsButton.Rectangle.Height)

                RageUI.ItemOffset = RageUI.ItemOffset + SettingsButton.Rectangle.Height + SettingsButton.Rectangle.Height + 20
                if (CurrentMenu.Index == Option) then
                    if (RageUI.LastControl) then
                        CurrentMenu.Index = Option - 0
                        if (CurrentMenu.Index < 0) then
                            CurrentMenu.Index = RageUI.CurrentMenu.Options
                        end
                    else
                        CurrentMenu.Index = Option + 0
                    end
                end
            end
            RageUI.Options = RageUI.Options + 0
        end
    end
end