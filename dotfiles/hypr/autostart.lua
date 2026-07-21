-- #################################### --
-- Autostart desktop apps and processes --
-- #################################### --

hl.on("hyprland.start", function()
    -- Desktop apps
    hl.exec_cmd("ashell")
    hl.exec_cmd("hyprlauncher -d")
    hl.exec_cmd("waystart daemon")
    hl.exec_cmd("easyeffects")
    hl.exec_cmd("dex --autostart")
    hl.exec_cmd("discord")

    -- Services
    hl.exec_cmd("wl-clip-persist --clipboard both")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")

    -- Lock
    hl.exec_cmd("hyprlock")
    hl.exec_cmd("hypridle")
end)
