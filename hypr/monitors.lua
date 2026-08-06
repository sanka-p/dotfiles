-- Monitor presets.
--
-- The active preset name lives in ~/.local/state/hypr/monitor-preset and is
-- switched by scripts/toggle-monitor-config.sh (bound to SUPER + F7).
-- Keep `order` in sync with the cycle list in that script.

local presets = {
    HOME = {
        { output = "eDP-1", mode = "preferred", position = "0x0", scale = 1 },
    },
    EFAC = {
        { output = "eDP-1",    mode = "preferred", position = "0x0",     scale = 1 },
        { output = "HDMI-A-1", mode = "preferred", position = "0x-1200", scale = 1 }, -- top
    },
}

local order = { "HOME", "EFAC" }
local default = order[1]

local f = io.open(os.getenv("HOME") .. "/.local/state/hypr/monitor-preset")
local name = f and f:read("l") or default
if f then
    f:close()
end

for _, monitor in ipairs(presets[name] or presets[default]) do
    hl.monitor(monitor)
end
