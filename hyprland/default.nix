{ config, pkgs, ... }:
let
    vars = import ../vars.nix;
in
{
    imports = [ ./kitty.nix ./swaylock.nix ];

    home.packages = with pkgs; [
        # Desktop utilities
        networkmanagerapplet
        gnome.nautilus
        gnome.file-roller

        # Programs
        firefox
        vscode
        discord
        betterbird
        nextcloud-client

        # Hyprland specific
        grimblast
        dex wl-clip-persist swww
    ];

    programs = {
        # Eww config
        eww = {
            enable = true;
            package = pkgs.eww-wayland;
            configDir = ../dotfiles/eww;
        };

        # Wofi config
        wofi = {
            enable = true;
            style = (builtins.readFile ./wofi.css);
            settings = {
                width="480px";
                height="320px";
                allow_images=true;
            };
        };

        gpg = {
            enable = true;
        };
    };

    services = {
        # Mako config
        mako = {
            enable = true;

            # Placement
            width=400;
            height=160;
            margin="8";
            padding="8";
            anchor="bottom-right";

            # General
            font="Cascadia Code PL 12";
            backgroundColor="#13141c66";
            textColor="#bfc9db";
            progressColor="#f1ca914D";
            defaultTimeout=3000;

            # Border
            borderSize=1;
            borderColor="#646a7366";
            borderRadius=8;

            extraConfig = ''
                outer-margin=8

                [urgency=high]
                default-timeout=0
            '';
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
    };

    # Cursor pointer
    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Classic";
        size = 14;
    };

    # Env variables
    home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
    };
}
