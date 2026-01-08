{ config, pkgs, zen-browser, waystart, ... }:
{
    imports = [ ./hw-config.nix ];


    # Global packages
    environment.systemPackages = with pkgs; [
        waystart.packages.${pkgs.system}.default
        easyeffects
        brightnessctl gcc
    ];


    # Programs options
    programs = {
        hyprland.enable = true;
        dconf.enable = true;
        steam.enable = true;
    };


    # Services options
    services = {
        # Mount, trash... for the file explorer
        gvfs.enable = true;

        # Bluetooth control
        blueman.enable = true;

        # Auto start Hyprland on TTY1
        greetd = {
            enable = true;
            settings.default_session = {
                command = "${pkgs.hyprland}/bin/start-hyprland &> /dev/null";
                user = "guibi";
            };
        };
    };


    # Networking options
    networking = {
        hostName = "Artemis";
    };


    # Bluetooth options
    hardware = {
        bluetooth = {
            enable = true;
            powerOnBoot = false;
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

    # Nvidia options
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware = {
        graphics.enable = true;
        nvidia = {
            modesetting.enable = true;
            open = true;
            nvidiaSettings = true;
            package = config.boot.kernelPackages.nvidiaPackages.stable;
        };
    };


    # Fonts
    fonts.packages = with pkgs; [
        cascadia-code
        nerd-fonts.fira-code
        noto-fonts
        noto-fonts-color-emoji
        liberation_ttf
        dina-font
        proggyfonts
    ];


    # Home manager options
    home-manager.users.guibi = input: {
        imports = [
            ../../home-manager/base-config.nix
            ../../home-manager/hyprland.nix
            zen-browser.homeModules.default
        ];
        programs.git.signing.key = "1F1C47D520393678";
    };


    # No touchy
    system.stateVersion = "25.11";
}
