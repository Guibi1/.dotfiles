{ ... }: {
  config.desktop.home = { lib, ... }: {
    programs.ghostty = {
      enable = true;
      enableFishIntegration = true;

      settings = {
        font-size = 14;
        font-family = "Cascadia Code PL";
        theme = "Catppuccin Mocha";
        term = "xterm-256color";
        gtk-single-instance = false;
      };
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        {
          _args = [
            "SUPER + Return"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('runapp ghostty')")
          ];
        }
      ];
    };
  };
}
