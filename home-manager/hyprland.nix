{ lib, pkgs, ... }:
{
    home.packages = with pkgs; [
        # Desktop utilities
        networkmanagerapplet
        nautilus

        # Programs
        firefox
        vscode
        zed-editor
        discord
        nextcloud-client
        prismlauncher

        # Hyprland specific
        hyprlauncher hyprpicker
        hypridle
        dex wl-clip-persist
    ];


    programs = {
        hyprshot.enable = true;

        ashell = {
            enable = true;
        };

        hyprlock = {
            enable = true;
        };

        zen-browser = {
            enable = true;
            policies = {
                DisableAppUpdate = true;
                DisableTelemetry = true;
            };
        };

        ghostty = {
            enable = true;
            enableFishIntegration = true;

            settings = {
                font-size = 16;
                font-family = "Cascadia Code PL";
                theme = "Catppuccin Mocha";
                term = "xterm-256color";
            };
        };
    };


    services = {
        hyprpaper.enable = true;
        hyprsunset.enable = true;
        hyprpolkitagent.enable = true;

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
        # configFile = {
        #     hypr.source = ../dotfiles/hypr;
        # };
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
        EDITOR = lib.mkForce "zed --wait";
    };
}
