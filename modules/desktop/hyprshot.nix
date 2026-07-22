{ ... }: {
  config.desktop.home = { config, lib, ... }: {
    programs.hyprshot = {
      enable = true;
      saveLocation = "${config.xdg.userDirs.pictures}/Screenshots";
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        {
          _args = [
            "SUPER + SHIFT + S"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('pidof hyprshot || runapp hyprshot -m region --clipboard-only')")
          ];
        }
        {
          _args = [
            "PRINT"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('runapp hyprshot -m output -m active --clipboard-only')")
          ];
        }
      ];
    };
  };
}
