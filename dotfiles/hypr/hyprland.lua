require("autostart")
require("keybinds")


hl.monitor({
    output   = "",
    mode     = "highrr",
    position = "auto",
    scale    = 1.25,
})
-- hl.monitor({ output = "DP-1", mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1" })


hl.config({
    input = {
        kb_layout    = "ca",
        kb_options   = "caps:hyper",
        follow_mouse = 1,
        sensitivity = -0.35,

        touchpad = {
            natural_scroll = true,
        },
    },

    general = {
        gaps_in     = 4,
        gaps_out    = 8,
        border_size = 1,

        col = {
            active_border   = "rgba(cba6f7aa)",
            inactive_border = "rgb(45475a)",
        },

        layout = "dwindle",
    },

    decoration = {
        rounding = 8,

        blur = {
            enabled = true,
            size    = 4,
            passes  = 2,
            special = true,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    misc = {
        disable_hyprland_logo = true,
        vrr                   = 3,
    },

    xwayland = {
        force_zero_scaling = true,
    },
})


hl.layer_rule({ match = { namespace = "waystart" }, blur = true })


hl.animation({ leaf = "windows",     enabled = true, speed = 3,  bezier = "default" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 3,  bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border",      enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 1,  bezier = "default" })
hl.animation({ leaf = "fade",        enabled = true, speed = 7,  bezier = "default" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 3,  bezier = "default" })
