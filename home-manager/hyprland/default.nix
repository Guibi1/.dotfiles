{ pkgs, ... }:
{
    imports = [ ./kitty.nix ./waybar ];

    home.packages = with pkgs; [
        # Desktop utilities
        networkmanagerapplet
        gnome.nautilus
        gnome.file-roller
        gnome.seahorse

        # Programs
        firefox
        vscode
        zed-editor
        discord
        nextcloud-client

        # Hyprland specific
        hyprlock hypridle
        grimblast
        rofi-wayland
        dex wl-clip-persist swww
    ];

    programs = {
        # Eww config
        eww = {
            enable = true;
            configDir = ../dotfiles/eww;
        };

        ghostty = {
            enable = true;
            enableFishIntegration = true;

            settings = {
                font-size = 16;
                font-family = "Cascadia Code PL";
                theme = "catppuccin-mocha";
                term = "xterm-256color";
            };
        };
    };

    services = {
        # Mako config
        mako = {
            enable = true;

            settings = {
                # Placement
                width = 400;
                height = 160;
                margin = "8";
                padding = "8";
                anchor = "bottom-right";

                # General
                font = "Cascadia Code PL 14";
                backgroundColor = "#13141c66";
                textColor = "#bfc9db";
                progressColor = "#f1ca914D";
                defaultTimeout = 3000;

                # Border
                borderSize = 1;
                borderColor = "#646a7366";
                borderRadius = 8;

                extraConfig = ''
                    outer-margin=8

                    [urgency=high]
                    default-timeout=0
                '';
            };
        };
    };

    home.file = {
    };

    # Configuration (mostly gnome)
    dconf = {
        enable = true;
        settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };

    xdg = {
        enable = true;
        userDirs.createDirectories = true;

        # .config symlinks
        configFile = {
            hypr.source = ../dotfiles/hypr;
        };
    };

    gtk = {
        enable = true;
        theme = {
            name = "Catppuccin-Mocha-Standard-Red-Dark";
            package = (pkgs.catppuccin-gtk.override {
                accents = [ "red" ];
                size = "standard";
                variant = "mocha";
            });
        };
        iconTheme = {
            name = "Tela-circle-black";
            package = (pkgs.tela-circle-icon-theme.override {
                colorVariants = [ "black" "pink" ];
            });
        };
    };

    # Cursor pointer
    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 20;
    };

    # Env variables
    home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        EDITOR = "zed --wait";
    };
}
