-- Window rules. See https://wiki.hypr.land/Configuring/Basics/Window-Rules/

hl.window_rule({
    name  = "zotero-dialogs",
    match = {
        class = "^(Zotero)$",
        title = "^(Quick Format Citation|Progress)$",
    },
    float    = true,
    center   = true,
    no_anim  = true,
    max_size = { 400, 100 },
})

-- Workspace assignments
hl.window_rule({ name = "kitty-workspace",    match = { class = "^(kitty)$" },    workspace = "1" })
hl.window_rule({ name = "zen-workspace",      match = { class = "^(zen)$" },      workspace = "2" })
hl.window_rule({ name = "spotify-workspace",  match = { class = "^(spotify)$" },  workspace = "3" })
hl.window_rule({ name = "zotero-workspace",   match = { class = "^(Zotero)$" },   workspace = "4" })
hl.window_rule({ name = "obsidian-workspace", match = { class = "^(obsidian)$" }, workspace = "4" })

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
-- hl.window_rule({
--     name  = "fix-xwayland-drags",
--     match = {
--         class      = "^$",
--         title      = "^$",
--         xwayland   = true,
--         float      = true,
--         fullscreen = false,
--         pin        = false,
--     },
--     no_focus = true,
-- })
