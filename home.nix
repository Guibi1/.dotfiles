args@{ config, pkgs, lib, ... }:
let
    vars = import ./vars.nix;
    tryImport = file: lib.optional (builtins.pathExists file) file;
in
{
    home.username = "guibi";
    home.homeDirectory = "/home/guibi";
    home.stateVersion = "23.11";

    imports = [] ++ (tryImport ./hyprland.nix);


    # Packages to install
    home.packages = with pkgs; [
        nano
        neofetch
        bun
        graphite-cli
        cargo
        grc
        meslo-lgs-nf # Font for Tide
    ];


    # Dotfiles
    home.file = {

    };


    # Programs config
    programs = {
        # Fish shell config
        fish = {
            enable = true;
            interactiveShellInit = ''
                set fish_greeting # Disable greeting
            '';
            plugins = [
                { name = "grc"; src = pkgs.fishPlugins.grc.src; }
                { name = "tide"; src = pkgs.fishPlugins.tide.src; }
                { name = "pisces"; src = pkgs.fishPlugins.pisces.src; }
            ];
        };

        # Git config
        git = {
            enable = true;
            userName = "Laurent Stéphenne";
            userEmail = "laurent@guibi.ca";

            # Enable gpg signing if possible
            signing = {
                signByDefault = vars ? git.gpgKey;
                key = vars.git.gpgKey or null;
            };
        };
    
        # Let Home Manager install and manage itself
        home-manager.enable = true;
    };


    # VARIABLES
    home.sessionVariables = {
        NIXPKGS_ALLOW_UNFREE = "1";
        EDITOR = "code";
    };
}
