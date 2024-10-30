{ config, pkgs, ... }:
let
    vars = import ./vars.nix;
in
{
    # Global packages
    environment = {
        systemPackages = with pkgs; [ fluxcd ];
        sessionVariables = {
            KUBECONFIG = "/home/guibi/kubeconfig.yaml";
        };
    };


    # Networking options
    networking = {
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


    # Services options
    services = {
        fail2ban.enable = true;

        openssh = {
            enable = true;
            ports = [ 22 ];
            settings = {
                PasswordAuthentication = false;
                AllowUsers = [ "guibi" ];
                UseDns = true;
                X11Forwarding = false;
                PermitRootLogin = "no";
            };
        };

        k3s = {
            enable = true;
            role = "server";
            clusterInit = true;
            extraFlags = "--service-node-port-range=27000-30000";
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

    networking.hostId = "6d57a4c5";
}
