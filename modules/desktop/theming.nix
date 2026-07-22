{ ... }: {
  config.desktop.home = { pkgs, ... }: {
    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    xdg = {
      enable = true;
      userDirs.createDirectories = true;
    };

    gtk = rec {
      enable = true;
      gtk4.theme = theme;
      theme = {
        name = "Catppuccin-Mocha-Standard-Mauve-Dark";
        package = (
          pkgs.catppuccin-gtk.override {
            size = "standard";
            variant = "mocha";
            accents = [ "mauve" ];
          }
        );
      };
    };

    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kde";
      kvantum = {
        enable = true;
        settings.General.theme = "catppuccin-mocha-mauve";
        themes = [
          (pkgs.catppuccin-kvantum.override {
            variant = "mocha";
            accent = "mauve";
          })
        ];
      };
    };

    home.pointerCursor = {
      enable = true;
      size = 20;
      gtk.enable = true;
      hyprcursor.enable = true;
      name = "macOS";
      package = pkgs.apple-cursor;
    };
  };

  config.desktop.nixos = { pkgs, ... }: {
    fonts.packages = with pkgs; [
      cascadia-code
      nerd-fonts.fira-code
      noto-fonts
      noto-fonts-color-emoji
      liberation_ttf
    ];
  };
}
