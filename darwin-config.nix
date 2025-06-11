{ self, config, lib, pkgs, ... }:
let
    vars = import ./vars.nix;
in
{
    # Global packages
    environment.systemPackages = with pkgs; [
        git aerospace
    ];


    # Programs options
    programs = {
        zsh.enable = true;
        fish.enable = true;
    };


    # Security options
    security = {
        pam.services.sudo_local.touchIdAuth = true;
    };


    # Fonts
    fonts.packages = with pkgs; [
        cascadia-code
        nerd-fonts.fira-code
        noto-fonts
        liberation_ttf
    ];

    environment.shells = [ pkgs.fish ];

    # Let Determinate manage nix
    nix.enable = false;


    # No touchy
    # system.configurationRevision = self.rev or self.dirtyRev or null;
    system.stateVersion = 6;
    nixpkgs.hostPlatform = "aarch64-darwin";
}
