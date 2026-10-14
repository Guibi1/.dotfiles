{ lib, ... }:
{
  options.server.k3s.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "K3s NixOS module";
  };

  config.server.k3s.nixos = { pkgs, ... }: {
    services.k3s = {
      enable = true;
      role = "server";
      clusterInit = true;
      extraFlags = "--service-node-port-range=27000-30000";
    };

    networking = {
      hostId = "6d57a4c5";
      firewall.allowedTCPPorts = [ 6443 ];
    };

    environment = {
        systemPackages = with pkgs; [ fluxcd seaweedfs ];
        sessionVariables.KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    };

    systemd = {
      services.zfs-archive-latest = {
        description = "Archive latest ZFS CSI snapshots for backup";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = [ "/mnt/Data/Backups/OpenEBS/archive-latest-snapshots.sh" ];
        };
      };

      timers.zfs-archive-latest = {
        description = "Daily ZFS snapshot archive timer";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
      };
    };

    systemd.tmpfiles.rules = [ "L+ /usr/local/bin - - - - /run/current-system/sw/bin/" ];
  };
}
