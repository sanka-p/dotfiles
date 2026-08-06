-- Catppuccin Mocha palette for the Hyprland Lua config.
-- The hyprlang twin of this file (mocha.conf) is still sourced by hyprlock,
-- so keep the two in sync.

local M = {
    rosewater = "f5e0dc",
    flamingo  = "f2cdcd",
    pink      = "f5c2e7",
    mauve     = "cba6f7",
    red       = "f38ba8",
    maroon    = "eba0ac",
    peach     = "fab387",
    yellow    = "f9e2af",
    green     = "a6e3a1",
    teal      = "94e2d5",
    sky       = "89dceb",
    sapphire  = "74c7ec",
    blue      = "89b4fa",
    lavender  = "b4befe",
    text      = "cdd6f4",
    subtext1  = "bac2de",
    subtext0  = "a6adc8",
    overlay2  = "9399b2",
    overlay1  = "7f849c",
    overlay0  = "6c7086",
    surface2  = "585b70",
    surface1  = "45475a",
    surface0  = "313244",
    base      = "1e1e2e",
    mantle    = "181825",
    crust     = "11111b",
}

---@param hex string bare 6-digit hex, e.g. M.mauve
function M.rgb(hex)
    return "rgb(" .. hex .. ")"
end

---@param hex string bare 6-digit hex, e.g. M.mauve
---@param alpha string 2-digit hex alpha, e.g. "ee"
function M.rgba(hex, alpha)
    return "rgba(" .. hex .. alpha .. ")"
end

return M
