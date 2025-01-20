{ config, lib, pkgs, ... }:
let
    vars = import ./vars.nix;
in
{
    imports = [
        <home-manager/nix-darwin>
    ];


    # Global packages
    environment.systemPackages = with pkgs; [
        git
    ];


    # Programs options
    programs = {
        zsh.enable = true;
        fish.enable = true;
    };


    # Users options
    users = {
        users.guibi = {
            shell = "${pkgs.fish}/bin/fish";
            packages = with pkgs; [];
        };
    };
    home-manager.users.guibi = import ./home.nix;


    # Fonts
    fonts.packages = with pkgs; [
        cascadia-code
        nerd-fonts.fira-code
        noto-fonts
        liberation_ttf
    ];


    # Security options
    security = {
        pam.enableSudoTouchIdAuth = true;
    };


    # Custom configuration location
    environment.darwinConfig = "$HOME/nix-config/darwin-config.nix";


    # Auto upgrade nix package and the daemon service.
    services.nix-daemon.enable = true;
    nix.package = pkgs.nix;


    # No touchy
    system.stateVersion = 5;
}
