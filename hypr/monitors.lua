-- Monitor presets.
--
-- The active preset name lives in ~/.local/state/hypr/monitor-preset and is
-- switched by scripts/toggle-monitor-config.sh (menu: scripts/display-menu.sh,
-- bound to SUPER + F7). Keep `order` in sync with the cycle list in that script.

local external = "HDMI-A-1"

local presets = {
    HOME = {
        { output = "eDP-1", mode = "preferred", position = "0x0", scale = 1 },
        { output = external, disabled = true }, -- unspecified monitors auto-enable otherwise
    },
    EXT_RIGHT = {
        { output = "eDP-1",  mode = "preferred", position = "0x0",        scale = 1 },
        { output = external, mode = "preferred", position = "auto-right", scale = 1 },
    },
    EXT_LEFT = {
        { output = "eDP-1",  mode = "preferred", position = "0x0",       scale = 1 },
        { output = external, mode = "preferred", position = "auto-left", scale = 1 },
    },
    MIRROR = {
        { output = "eDP-1",  mode = "preferred", position = "0x0", scale = 1 },
        { output = external, mode = "preferred", mirror = "eDP-1" },
    },
}

local order = { "HOME", "EXT_RIGHT", "EXT_LEFT", "MIRROR" }
local default = order[1]

local f = io.open(os.getenv("HOME") .. "/.local/state/hypr/monitor-preset")
local name = f and f:read("l") or default
if f then
    f:close()
end

for _, monitor in ipairs(presets[name] or presets[default]) do
    hl.monitor(monitor)
end
