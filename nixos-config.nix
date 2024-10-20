{ config, pkgs, ... }:
let
    vars = import ./vars.nix;
in
{
    imports = [
        /etc/nixos/hardware-configuration.nix
        <home-manager/nixos>
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

        # pulseaudio = {
        #     enable = true;
        #     package = pkgs.pulseaudioFull;
        # };
    };


    # Networking options
    networking = {
        hostName = "Hermes"; # Define your hostname.

        networkmanager = {
            enable = true;
            ensureProfiles.profiles = {
                eduroam = {
                    connection = {
                        id = "eduroam";
                        uuid = "0b3b1367-b305-4885-932a-48100e1e37b5";
                        type = "wifi";
                    };
                    wifi = {
                        cloned-mac-address = "stable";
                        mode = "infrastructure";
                        ssid = "eduroam";
                    };
                    wifi-security = {
                        key-mgmt = "wpa-eap";
                    };
                    "802-1x" = {
                        anonymous-identity = "anonymous657357@usherbrooke.ca";
                        ca-cert = "/home/guibi/.config/cat_installer/ca.pem";
                        domain-suffix-match = "radius.usherbrooke.ca";
                        eap = "peap";
                        identity = vars.eduroam.identity or "";
                        password = vars.eduroam.password or "";
                        phase2-auth = "mschapv2";
                    };
                };

                UdsS = {
                    connection = {
                        id = "UdsS";
                        uuid = "eb0e0e9c-8aa0-4541-ae59-51aca3dea1b5";
                        type = "vpn";
                        autoconnect = "false";
                    };
                    vpn = {
                        authtype = "password";
                        autoconnect-flags = "0";
                        certsigs-flags = "0";
                        cookie-flags = "2";
                        disable_udp = "no";
                        enable_csd_trojan = "no";
                        gateway = "rpv.usherbrooke.ca";
                        gateway-flags = "2";
                        gwcert-flags = "2";
                        lasthost-flags = "0";
                        pem_passphrase_fsid = "no";
                        prevent_invalid_cert = "no";
                        protocol = "anyconnect";
                        resolve-flags = "2";
                        stoken_source = "disabled";
                        useragent = "AnyConnect Linux_64 4.10.07061";
                        xmlconfig-flags = "0";
                        service-type = "org.freedesktop.NetworkManager.openconnect";
                    };
                    vpn-secrets = {
                        lasthost = "rpv.usherbrooke.ca";
                        save_passwords = "yes";
                        xmlconfig = "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjxBbnlDb25uZWN0UHJvZmlsZSB4bWxucz0iaHR0cDovL3NjaGVtYXMueG1sc29hcC5vcmcvZW5jb2RpbmcvIiB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL2VuY29kaW5nLyBBbnlDb25uZWN0UHJvZmlsZS54c2QiPg0KCTxDbGllbnRJbml0aWFsaXphdGlvbj4NCgkJPFVzZVN0YXJ0QmVmb3JlTG9nb24gVXNlckNvbnRyb2xsYWJsZT0idHJ1ZSI+ZmFsc2U8L1VzZVN0YXJ0QmVmb3JlTG9nb24+DQoJCTxBdXRvbWF0aWNDZXJ0U2VsZWN0aW9uIFVzZXJDb250cm9sbGFibGU9InRydWUiPmZhbHNlPC9BdXRvbWF0aWNDZXJ0U2VsZWN0aW9uPg0KCQk8U2hvd1ByZUNvbm5lY3RNZXNzYWdlPmZhbHNlPC9TaG93UHJlQ29ubmVjdE1lc3NhZ2U+DQoJCTxDZXJ0aWZpY2F0ZVN0b3JlPkFsbDwvQ2VydGlmaWNhdGVTdG9yZT4NCgkJPENlcnRpZmljYXRlU3RvcmVNYWM+QWxsPC9DZXJ0aWZpY2F0ZVN0b3JlTWFjPg0KCQk8Q2VydGlmaWNhdGVTdG9yZUxpbnV4PkFsbDwvQ2VydGlmaWNhdGVTdG9yZUxpbnV4Pg0KCQk8Q2VydGlmaWNhdGVTdG9yZU92ZXJyaWRlPmZhbHNlPC9DZXJ0aWZpY2F0ZVN0b3JlT3ZlcnJpZGU+DQoJCTxQcm94eVNldHRpbmdzPk5hdGl2ZTwvUHJveHlTZXR0aW5ncz4NCgkJPEFsbG93TG9jYWxQcm94eUNvbm5lY3Rpb25zPnRydWU8L0FsbG93TG9jYWxQcm94eUNvbm5lY3Rpb25zPg0KCQk8QXV0aGVudGljYXRpb25UaW1lb3V0PjEyPC9BdXRoZW50aWNhdGlvblRpbWVvdXQ+DQoJCTxBdXRvQ29ubmVjdE9uU3RhcnQgVXNlckNvbnRyb2xsYWJsZT0idHJ1ZSI+ZmFsc2U8L0F1dG9Db25uZWN0T25TdGFydD4NCgkJPE1pbmltaXplT25Db25uZWN0IFVzZXJDb250cm9sbGFibGU9InRydWUiPnRydWU8L01pbmltaXplT25Db25uZWN0Pg0KCQk8TG9jYWxMYW5BY2Nlc3MgVXNlckNvbnRyb2xsYWJsZT0idHJ1ZSI+dHJ1ZTwvTG9jYWxMYW5BY2Nlc3M+DQoJCTxEaXNhYmxlQ2FwdGl2ZVBvcnRhbERldGVjdGlvbiBVc2VyQ29udHJvbGxhYmxlPSJ0cnVlIj5mYWxzZTwvRGlzYWJsZUNhcHRpdmVQb3J0YWxEZXRlY3Rpb24+DQoJCTxDbGVhclNtYXJ0Y2FyZFBpbiBVc2VyQ29udHJvbGxhYmxlPSJ0cnVlIj50cnVlPC9DbGVhclNtYXJ0Y2FyZFBpbj4NCgkJPElQUHJvdG9jb2xTdXBwb3J0PklQdjQ8L0lQUHJvdG9jb2xTdXBwb3J0Pg0KCQk8QXV0b1JlY29ubmVjdCBVc2VyQ29udHJvbGxhYmxlPSJmYWxzZSI+dHJ1ZQ0KCQkJPEF1dG9SZWNvbm5lY3RCZWhhdmlvciBVc2VyQ29udHJvbGxhYmxlPSJmYWxzZSI+UmVjb25uZWN0QWZ0ZXJSZXN1bWU8L0F1dG9SZWNvbm5lY3RCZWhhdmlvcj4NCgkJPC9BdXRvUmVjb25uZWN0Pg0KCQk8U3VzcGVuZE9uQ29ubmVjdGVkU3RhbmRieT5mYWxzZTwvU3VzcGVuZE9uQ29ubmVjdGVkU3RhbmRieT4NCgkJPEF1dG9VcGRhdGUgVXNlckNvbnRyb2xsYWJsZT0iZmFsc2UiPnRydWU8L0F1dG9VcGRhdGU+DQoJCTxSU0FTZWN1cklESW50ZWdyYXRpb24gVXNlckNvbnRyb2xsYWJsZT0iZmFsc2UiPkF1dG9tYXRpYzwvUlNBU2VjdXJJREludGVncmF0aW9uPg0KCQk8V2luZG93c0xvZ29uRW5mb3JjZW1lbnQ+U2luZ2xlTG9jYWxMb2dvbjwvV2luZG93c0xvZ29uRW5mb3JjZW1lbnQ+DQoJCTxMaW51eExvZ29uRW5mb3JjZW1lbnQ+U2luZ2xlTG9jYWxMb2dvbjwvTGludXhMb2dvbkVuZm9yY2VtZW50Pg0KCQk8V2luZG93c1ZQTkVzdGFibGlzaG1lbnQ+TG9jYWxVc2Vyc09ubHk8L1dpbmRvd3NWUE5Fc3RhYmxpc2htZW50Pg0KCQk8TGludXhWUE5Fc3RhYmxpc2htZW50PkxvY2FsVXNlcnNPbmx5PC9MaW51eFZQTkVzdGFibGlzaG1lbnQ+DQoJCTxBdXRvbWF0aWNWUE5Qb2xpY3k+ZmFsc2U8L0F1dG9tYXRpY1ZQTlBvbGljeT4NCgkJPFBQUEV4Y2x1c2lvbiBVc2VyQ29udHJvbGxhYmxlPSJmYWxzZSI+RGlzYWJsZQ0KCQkJPFBQUEV4Y2x1c2lvblNlcnZlcklQIFVzZXJDb250cm9sbGFibGU9ImZhbHNlIj48L1BQUEV4Y2x1c2lvblNlcnZlcklQPg0KCQk8L1BQUEV4Y2x1c2lvbj4NCgkJPEVuYWJsZVNjcmlwdGluZyBVc2VyQ29udHJvbGxhYmxlPSJmYWxzZSI+dHJ1ZQ0KCQkJPFRlcm1pbmF0ZVNjcmlwdE9uTmV4dEV2ZW50PmZhbHNlPC9UZXJtaW5hdGVTY3JpcHRPbk5leHRFdmVudD4NCgkJCTxFbmFibGVQb3N0U0JMT25Db25uZWN0U2NyaXB0PnRydWU8L0VuYWJsZVBvc3RTQkxPbkNvbm5lY3RTY3JpcHQ+DQoJCTwvRW5hYmxlU2NyaXB0aW5nPg0KCQk8RW5hYmxlQXV0b21hdGljU2VydmVyU2VsZWN0aW9uIFVzZXJDb250cm9sbGFibGU9ImZhbHNlIj5mYWxzZQ0KCQkJPEF1dG9TZXJ2ZXJTZWxlY3Rpb25JbXByb3ZlbWVudD4yMDwvQXV0b1NlcnZlclNlbGVjdGlvbkltcHJvdmVtZW50Pg0KCQkJPEF1dG9TZXJ2ZXJTZWxlY3Rpb25TdXNwZW5kVGltZT40PC9BdXRvU2VydmVyU2VsZWN0aW9uU3VzcGVuZFRpbWU+DQoJCTwvRW5hYmxlQXV0b21hdGljU2VydmVyU2VsZWN0aW9uPg0KCQk8UmV0YWluVnBuT25Mb2dvZmY+ZmFsc2UNCgkJPC9SZXRhaW5WcG5PbkxvZ29mZj4NCgkJPENhcHRpdmVQb3J0YWxSZW1lZGlhdGlvbkJyb3dzZXJGYWlsb3Zlcj5mYWxzZTwvQ2FwdGl2ZVBvcnRhbFJlbWVkaWF0aW9uQnJvd3NlckZhaWxvdmVyPg0KCQk8QWxsb3dNYW51YWxIb3N0SW5wdXQ+dHJ1ZTwvQWxsb3dNYW51YWxIb3N0SW5wdXQ+DQoJPC9DbGllbnRJbml0aWFsaXphdGlvbj4NCgk8U2VydmVyTGlzdD4NCgkJPEhvc3RFbnRyeT4NCgkJCTxIb3N0TmFtZT5ycHYudXNoZXJicm9va2UuY2E8L0hvc3ROYW1lPg0KCQk8L0hvc3RFbnRyeT4NCgk8L1NlcnZlckxpc3Q+DQo8L0FueUNvbm5lY3RQcm9maWxlPg0K";
                    };
                };
            };
        };
    };


    # Global packages
    environment.systemPackages = with pkgs; [
        git
        polkit_gnome
        jq socat xdg-utils
        brightnessctl
        networkmanager-openconnect
    ];


    # Programs options
    programs = {
        dconf.enable = true;
        hyprland.enable = vars.enable-hyprland or false;
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

        openssh = {
            enable = vars.server or false;
            ports = [ 22 ];
            settings = {
                PasswordAuthentication = true;
                AllowUsers = [ "guibi" ]; # Allows all users by default. Can be [ "user1" "user2" ]
                UseDns = true;
                X11Forwarding = false;
                PermitRootLogin = "prohibit-password"; # "yes", "without-password", "prohibit-password", "forced-commands-only", "no"
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


    # Session variables
    environment.sessionVariables = {
        SSH_AUTH_SOCK = "/run/user/$(id -u)/keyring/ssh";
    };


    # Fonts
    fonts.packages = with pkgs; [
        cascadia-code
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
        noto-fonts
        noto-fonts-cjk
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


    # No touchy
    system.stateVersion = "23.11";
}
