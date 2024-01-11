{ config, pkgs, ... }:
let
    vars = import ../vars.nix;
in
{
    imports = [ ./kitty.nix ./swaylock.nix ];

    home.packages = with pkgs; [
        gnome.nautilus
        firefox
        vscode
        discord
        betterbird
        swww
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

    xdg = {
        enable = true;

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
        cursorTheme = {
            name = "mochaLight";
            package = pkgs.catppuccin-cursors;
            size = 24;
        };
    };
}
