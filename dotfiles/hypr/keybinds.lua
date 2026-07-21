-- ############################ --
-- All the keybinds of Hyprland --
-- ############################ --

local MOD3 = "MOD3" -- Hyper (caps:hyper)
local SUP  = "SUPER"

-- Manage
hl.bind(MOD3 .. " + Escape", hl.dsp.exit())
hl.bind(MOD3 .. " + W",      hl.dsp.window.close())
hl.bind(MOD3 .. " + A",      hl.dsp.window.float({ action = "toggle" }))
hl.bind(MOD3 .. " + P",      hl.dsp.window.pseudo())

-- Windows
hl.bind(SUP .. " + SUPER_L",   hl.dsp.exec_cmd("waystart toggle"), { release = true })
hl.bind(SUP .. " + E",         hl.dsp.exec_cmd("nautilus"))
hl.bind(SUP .. " + L",         hl.dsp.exec_cmd("hyprlock"))
hl.bind(SUP .. " + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(SUP .. " + Return",    hl.dsp.exec_cmd("ghostty"))

-- Device control
hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),        { locked = true, repeating = true })
hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),       { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"),                            { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%- -n"),                         { locked = true, repeating = true })
hl.bind("PRINT", hl.dsp.exec_cmd("hyprshot -m output -m active --clipboard-only"))

-- Move focus with MOD3 + arrow keys
hl.bind(MOD3 .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(MOD3 .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(MOD3 .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(MOD3 .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Move workspace to screen with SUPER + SHIFT + arrow keys
hl.bind(SUP .. " + SHIFT + left",  hl.dsp.workspace.move({ monitor = "l" }))
hl.bind(SUP .. " + SHIFT + right", hl.dsp.workspace.move({ monitor = "r" }))
hl.bind(SUP .. " + SHIFT + up",    hl.dsp.workspace.move({ monitor = "u" }))
hl.bind(SUP .. " + SHIFT + down",  hl.dsp.workspace.move({ monitor = "d" }))

-- Switch workspaces with MOD3 + [0-9]
-- Move active window to a workspace with MOD3 + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(MOD3 .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(MOD3 .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(MOD3 .. " + Tab",         hl.dsp.focus({ workspace = "previous_per_monitor" }))
hl.bind(MOD3 .. " + SHIFT + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Dedicated workspaces
hl.bind(MOD3 .. " + D", hl.dsp.focus({ workspace = "name:D" }))
hl.window_rule({
    name  = "discord-dedicated-workspace",
    match = { class = "discord" },

    workspace = "name:D",
})

-- Special workspace (scratchpad)
hl.bind(MOD3 .. " + S",       hl.dsp.workspace.toggle_special("magic"))
hl.bind(MOD3 .. " + ALT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with MOD3 + LMB/RMB and dragging
hl.bind(MOD3 .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(MOD3 .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
