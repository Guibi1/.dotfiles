{ config, pkgs, ... }:
{
    imports = [
      /etc/nixos/hardware-configuration.nix
    ];


    # Boot options.
    boot = {
        kernelParams = [ "quiet" ];
        consoleLogLevel = 2;

        loader = {
            efi.canTouchEfiVariables = true;
            timeout = 0;

            systemd-boot = {
               enable = true;
               configurationLimit = 10;
            };
        };

        plymouth = {
            enable = true;
            theme = "breeze";
        };
    };


    # Networking options
    networking = {
        hostName = "Hermes"; # Define your hostname.
        networkmanager.enable = true;
    };


    # Global packages
    environment.systemPackages = with pkgs; [
        git
        polkit_gnome
        jq socat xdg-utils
        brightnessctl
    ];


    # Programs options
    programs = {
        hyprland.enable = true;
        fish.enable = true;
    };


    # Usesr options
    users = {
        defaultUserShell = pkgs.fish;
    
        users.guibi = {
            isNormalUser = true;
            description = "Laurent";
            extraGroups = [ "networkmanager" "wheel" ];
            packages = with pkgs; [];
        };
    };


    # Services options
    services = {
        # Start the gnome keyring (secrets)
        gnome.gnome-keyring.enable = true;

        # Mount, trash... for the file explorer
        gvfs.enable = true;

        # Start Pipewire (audio)
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
        
        # Auto start Hyprland on TTY1
        greetd = {
            enable = true;
            settings = rec {
                initial_session = {
                    command = "${pkgs.hyprland}/bin/Hyprland";
                    user = "guibi";
                };
                default_session = initial_session;
            };
        };
    };


    # Security options
    security = {
        polkit.enable = true;
        rtkit.enable = true;
        pam.services.swaylock = {
            enableGnomeKeyring = true;
        };
    };


    # Systemd options
    systemd = {
        # Start Polkit-Gnome
        user.services.polkit-gnome-authentication-agent-1 = {
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


    # Locale options
    console.keyMap = "cf";
    time.timeZone = "America/Toronto";

    i18n.defaultLocale = "en_CA.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "fr_CA.UTF-8";
        LC_IDENTIFICATION = "fr_CA.UTF-8";
        LC_MEASUREMENT = "fr_CA.UTF-8";
        LC_MONETARY = "fr_CA.UTF-8";
        LC_NAME = "fr_CA.UTF-8";
        LC_NUMERIC = "fr_CA.UTF-8";
        LC_PAPER = "fr_CA.UTF-8";
        LC_TELEPHONE = "fr_CA.UTF-8";
        LC_TIME = "fr_CA.UTF-8";
    };


    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;


    # No touchy
    system.stateVersion = "23.11";
}
