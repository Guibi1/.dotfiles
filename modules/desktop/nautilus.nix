{ ... }: {

  config.desktop.nixos = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      nautilus
    ];

    services.gvfs.enable = true;

    programs.nautilus-open-any-terminal = {
      enable = true;
      terminal = "ghostty";
    };
  };

  config.desktop.home = { lib, ... }: {
    wayland.windowManager.hyprland.settings = {
      bind = [
        {
          _args = [
            "SUPER + E"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('runapp nautilus -w')")
          ];
        }
      ];
    };
  };
}
