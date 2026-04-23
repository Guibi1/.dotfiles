{ pkgs, ... }:
{
    # Restic options
    services.restic.backups = let base = {
        paths = [
            "/mnt/Data/OpenCloud"
            "/mnt/Data/Backups/Minecraft"
            "/mnt/Data/Backups/OpenEBS"
        ];
        timerConfig = {
            OnCalendar = "daily";
            Persistent = true;
        };
        exclude = [
            "*.tmp"
        ];
        checkOpts = [ "--with-cache" ];
        pruneOpts = [
            "--keep-weekly 4"
            "--keep-monthly 12"
            "--keep-yearly 3"
        ];
    }; in {
        niftic = {
            repository = "sftp://guibi@192.168.0.206:22//uploads/restic";
            passwordFile = "/home/guibi/keys/niftic_restic";
            extraOptions = [ "sftp.args='-i /home/guibi/keys/niftic_ed25519'" ];
        } // base;

        azom = {
            repository = "sftp://guibi@10.200.0.1:2022//restic";
            passwordFile = "/home/guibi/keys/azom_restic";
            extraOptions = [ "sftp.args='-i /home/guibi/keys/azom_ed25519'" ];
        } // base;
    };


    # SFTP mounts
    fileSystems = let base = {
        fsType = "rclone";
        options = [
            "nodev"
            "nofail"
            "allow_other"
            "args2env"
            "vfs-cache-mode=writes"
            "config=/etc/rclone-mnt.conf"
        ];
    }; in {
        "/mnt/niftic" = {
            device = "niftic:/";
        } // base;

        "/mnt/azom" = {
            device = "azom:/";
        } // base;
    };

    environment.systemPackages = [ pkgs.rclone ];
    environment.etc."rclone-mnt.conf".text = "
        [niftic]
        type = sftp
        host = 192.168.0.206
        port = 22
        user = guibi
        key_file = /home/guibi/keys/niftic_ed25519
        shell_type = unix
        md5sum_command = md5sum
        sha1sum_command = sha1sum

        [azom]
        type = sftp
        host = 10.200.0.1
        port = 2022
        user = guibi
        key_file = /home/guibi/keys/azom_ed25519
        shell_type = unix
        md5sum_command = md5sum
        sha1sum_command = sha1sum
    ";


    # Wireguard client options
    networking.wg-quick.interfaces = {
        azom = {
            address = [ "10.200.0.2/32" ];
            privateKeyFile = "/home/guibi/keys/azom_wireguard";

            peers = [
                {
                    publicKey = "n0FZu8oaSSzRyuBX/4QCpOR4vWh/AYKS13xLLme8QFQ=";
                    allowedIPs = [ "10.200.0.1/32" ];
                    endpoint = "azom.dev:48318";
                    persistentKeepalive = 25;
                }
            ];
        };

        niftic = {
            address = [ "10.10.0.2/32" ];
            privateKeyFile = "/home/guibi/keys/niftic_wireguard";

            peers = [
                {
                    publicKey = "qCeDw5Cdyax6YQ5KpztIkanXv63z8l1rVddvW6b5oXA=";
                    allowedIPs = [ "10.10.0.1/32" "192.168.0.206/32" ];
                    endpoint = "niftic.hopto.org:51820";
                    persistentKeepalive = 25;
                }
            ];
        };
    };


    # ZFS snapshot backup options
    systemd = {
        services.zfs-archive-latest = {
            description = "Archive latest ZFS CSI snapshots for backup";
            serviceConfig = {
                Type = "oneshot";
                ExecStart = ["/mnt/Data/Backups/OpenEBS/archive-latest-snapshots.sh"];
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
}
