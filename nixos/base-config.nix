{ pkgs, home-manager, ... }:
{
    imports = [
        home-manager.nixosModules.default
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

        kernel.sysctl = {
            "fs.inotify.max_user_watches" = 524288;
            "fs.inotify.max_user_instances" = 8192;
        };
    };


    # Power management
    powerManagement.enable = true;


    # Networking options
    networking = {
        networkmanager.enable = true;
    };


    # Global packages
    environment.systemPackages = with pkgs; [
        ripgrep git
        uutils-coreutils-noprefix sudo-rs
        htop grc fzf fastfetch
        jq socat xdg-utils
    ];


    # Programs options
    programs = {
        fish.enable = true;
        ssh.startAgent = true;
    };


    # Users options
    users = {
        defaultUserShell = pkgs.fish;

        users.guibi = {
            isNormalUser = true;
            description = "Laurent";
            extraGroups = [ "networkmanager" "wheel" ];
        };
    };


    # Home manager options
    home-manager  = {
        useGlobalPkgs = true;
        useUserPackages = true;
    };


    # Services options
    services = {
        # CPU power management
        auto-cpufreq.enable = true;

        # Start Pipewire (audio)
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
    };


    # Security options
    security = {
        polkit.enable = true;
        rtkit.enable = true;
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

    # Nix settings
    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
        auto-optimise-store = true;
    };
}
