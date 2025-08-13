{ config, lib, pkgs, ... }:
{
    imports = [
        ./hw-config.nix
    ];


    # Global packages
    environment.systemPackages = with pkgs; [
        brightnessctl
        polkit_gnome
        gcc
    ];


    # Programs options
    programs = {
        hyprland.enable = true;
        dconf.enable = true;
    };


    # Services options
    services = {
        # Start the gnome keyring (secrets)
        gnome.gnome-keyring.enable = true;

        # Mount, trash... for the file explorer
        gvfs.enable = true;

        # Bluetooth control
        blueman.enable = true;

        # Fingerprint
        fprintd.enable = true;

        # Auto start Hyprland on TTY1
        greetd = {
            enable = true;
            settings.default_session = {
                command = "${pkgs.hyprland}/bin/Hyprland &> /dev/null";
                user = "guibi";
            };
        };
    };


    # Networking options
    networking = {
        hostName = "Hermes";
    };


    # Bluetooth options
    hardware = {
        bluetooth = {
            enable = true;
            powerOnBoot = true;
            settings.General = {
                Enable = "Source,Sink,Media,Socket";
                Experimental = true;
            };
        };
    };


    # Security options
    security = {
        pam.services = {
            login.enableGnomeKeyring = true;
            hyprlock.enableGnomeKeyring = true;
        };
    };


    # Systemd options
    systemd = {
        # Start Polkit-Gnome
        user.services.polkit-gnome-authentication-agent-1 = {
            enable = true;
            description = "polkit-gnome-authentication-agent-1";
            wantedBy = [ "default.target" ];
            serviceConfig = {
                Type = "simple";
                ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
                Restart = "on-failure";
                RestartSec = 1;
                TimeoutStopSec = 10;
            };
        };
    };


    # Fonts
    fonts.packages = with pkgs; [
        cascadia-code
        nerd-fonts.fira-code
        noto-fonts
        noto-fonts-emoji
        liberation_ttf
        dina-font
        proggyfonts
    ];


    # No touchy
    system.stateVersion = "23.11";
}
