{ config, lib, pkgs, ... }:
let
    vars = import ./vars.nix;
in
{
    imports = [
        /etc/nixos/hardware-configuration.nix
        <home-manager/nixos>
    ] ++ (lib.optional vars.server ./server);


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

        kernel.sysctl = {
            "fs.inotify.max_user_watches" = 524288;
            "fs.inotify.max_user_instances" = 8192;
        };
    };

    powerManagement.enable = true;

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


    # Networking options
    networking = {
        hostName = vars.hostname;
        networkmanager.enable = true;
    };


    # Global packages
    environment.systemPackages = with pkgs; [
        uutils-coreutils-noprefix sudo-rs git
        htop grc fzf fastfetch
        jq socat xdg-utils
        polkit_gnome
        brightnessctl
        gcc
    ];


    # Programs options
    programs = {
        ssh.startAgent = true;
        dconf.enable = true;
        hyprland.enable = vars.enable-hyprland or false;
        fish.enable = true;
    };


    # Users options
    users = {
        defaultUserShell = pkgs.fish;

        users.guibi = {
            isNormalUser = true;
            description = "Laurent";
            extraGroups = [ "networkmanager" "wheel" ];
            packages = with pkgs; [];
        };
    };
    home-manager.users.guibi = import ./home.nix;


    # Services options
    services = {
        # Start the gnome keyring (secrets)
        gnome.gnome-keyring.enable = true;

        # Mount, trash... for the file explorer
        gvfs.enable = true;

        # Bluetooth control
        blueman.enable = true;

        # CPU power management
        auto-cpufreq.enable = true;

        # Fingerprint
        fprintd.enable = vars.enable-fprint or false;

        # Start Pipewire (audio)
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };

        # Auto start Hyprland on TTY1
        greetd = {
            enable = vars.enable-hyprland or false;
            settings.default_session = {
                command = "${pkgs.hyprland}/bin/Hyprland &> /dev/null";
                user = "guibi";
            };
        };
    };


    # Security options
    security = {
        polkit.enable = true;
        rtkit.enable = true;

        pam.services = {
            login.enableGnomeKeyring = true;
            hyprlock.enableGnomeKeyring = true;
        };
    };


    # Systemd options
    systemd = {
        # Start Polkit-Gnome
        user.services.polkit-gnome-authentication-agent-1 = {
            enable = vars.enable-hyprland or false;
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

    # Nix settings
    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
    };

    # No touchy
    system.stateVersion = "23.11";
}
