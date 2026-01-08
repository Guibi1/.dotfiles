{ pkgs, ... }:
{
    imports = [
        ./hw-config.nix
        ./sftp.nix
        ./backup.nix
    ];

    # Global packages
    environment = {
        systemPackages = with pkgs; [ fluxcd minio-client ];
        sessionVariables = {
            KUBECONFIG = "/home/guibi/kubeconfig.yaml";
        };
    };


    # Programs options
    programs = {
    };


    # Services options
    services = {
        fail2ban.enable = true;

        openssh = {
            enable = true;
            ports = [ 22 ];
            settings = {
                AllowUsers = [ "guibi" ];
                PermitRootLogin = "no";
                UseDns = true;
                X11Forwarding = false;
                PasswordAuthentication = false;
                KbdInteractiveAuthentication = false;
            };
        };

        k3s = {
            enable = true;
            role = "server";
            clusterInit = true;
            extraFlags = "--service-node-port-range=27000-30000";
        };
    };


    # Networking options
    networking = {
        hostName = "Apollon";

        interfaces.eno1.ipv4.addresses = [ {
            address = "192.168.18.222";
            prefixLength = 24;
        } ];

        defaultGateway = "192.168.18.1";
        nameservers = [ "1.1.1.1" "8.8.8.8" ];

        firewall = {
            allowedTCPPorts = [
                6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
            ];
            allowedUDPPorts = [
                27020
            ];
        };
    };


    # ZFS
    boot = {
        supportedFilesystems = [ "zfs" ];
        zfs = {
            forceImportRoot = false;
            extraPools = [ "SSD" "Data" ];
        };
    };


    # Found on github.com/openebs/openebs/issues/3727#issuecomment-2366776183
    systemd.tmpfiles.rules = [
        "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    ];


    # Home manager options
    home-manager.users.guibi = input: {
        imports = [../../home-manager/base-config.nix];
        programs.git.signing.key = "1F1C47D520393678";
    };


    # No touchy
    networking.hostId = "6d57a4c5";
    system.stateVersion = "23.11";
}
