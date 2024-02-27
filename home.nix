{ config, pkgs, lib, ... }:
let
    vars = import ./vars.nix;
    importIf = file: enable: lib.optional enable file;
in
{
    home.username = "guibi";
    home.homeDirectory = "/home/guibi";
    home.stateVersion = "23.11";

    imports = [./node-global-packages] ++ (importIf ./hyprland vars.enableHyprland);


    # Packages to install
    home.packages = with pkgs; [
        grc # Fish plugin
        neofetch

        # Dev env
        bun nodejs_20
        cargo
        gnumake gcc
    ];


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
            enable = vars.git.enable or false;
            userName = "Laurent Stéphenne";
            userEmail = "laurent@guibi.dev";

            # Enable gpg signing if possible
            signing = {
                signByDefault = vars ? git.gpgKey;
                key = vars.git.gpgKey or null;
            };

            # Allows for git difftool to work with vscode
            extraConfig = {
                diff.tool = "vscode";
                "difftool \"vscode\"".cmd = "code --diff $LOCAL $REMOTE";
            };
        };

        gpg = {
            enable = true;
        };
    
        # Let Home Manager install and manage itself
        home-manager.enable = true;
    };


    # Env variables
    home.sessionVariables = {
        NIXPKGS_ALLOW_UNFREE = "1";
        EDITOR = "code --wait";
    };
}
