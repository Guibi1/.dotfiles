{ lib, ... }:
{
  options.server.k3s.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "K3S NixOS module";
  };

  config.server.k3s.nixos = {
    services.k3s = {
      enable = true;
      role = "server";
      clusterInit = true;
      extraFlags = "--service-node-port-range=27000-30000";
    };
    systemd.tmpfiles.rules = [ "L+ /usr/local/bin - - - - /run/current-system/sw/bin/" ];

    networking.firewall.allowedTCPPorts = [ 6443 ];
    networking.firewall.allowedUDPPorts = [ 27020 ];
    networking.hostId = "6d57a4c5";

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
  };
}
