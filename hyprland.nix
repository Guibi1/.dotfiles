{ config, pkgs, ... }:
let
    vars = import ./vars.nix;
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
        eww = {
            enable = true;
            package = pkgs.eww-wayland;
            configDir = ./dotfiles/eww;
        };

        wofi = {
            enable = true;
            settings = {};
        };

        gpg = {
            enable = true;
        };
    };

    home.file = {
    };

    xdg = {
        enable = true;
        
        configFile = {
            hypr.source = ./dotfiles/hypr;
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
