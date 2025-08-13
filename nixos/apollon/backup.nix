{ pkgs, ... }:
{
    # SFTP mounts
    environment.systemPackages = [ pkgs.rclone ];
    environment.etc."rclone-mnt.conf".text = "
        [niftic]
        type = sftp
        host = niftic.hopto.org
        port = 16810
        user = guibi
        key_file = /home/guibi/keys/niftic_ed25519
        shell_type = unix
        md5sum_command = md5sum
        sha1sum_command = sha1sum

        [azom]
        type = sftp
        host = ssh.azom.dev
        port = 6073
        user = guibi
        key_file = /home/guibi/keys/azom_ed25519
        shell_type = unix
        md5sum_command = md5sum
        sha1sum_command = sha1sum
    ";

    fileSystems = {
        "/mnt/niftic" = {
            device = "niftic:/";
            fsType = "rclone";
            options = [
                "nodev"
                "nofail"
                "allow_other"
                "args2env"
                "vfs-cache-mode=writes"
                "config=/etc/rclone-mnt.conf"
            ];
        };

        "/mnt/azom" = {
            device = "azom:/";
            fsType = "rclone";
            options = [
                "nodev"
                "nofail"
                "allow_other"
                "args2env"
                "vfs-cache-mode=writes"
                "config=/etc/rclone-mnt.conf"
            ];
        };
    };


    # Borgbackup options
    services.borgbackup = {
        jobs = {
            niftic = {
                repo = "/mnt/niftic/uploads/borg";
                doInit = true;
                compression = "zlib";
                paths = [
                    "/mnt/Data/Backups/Minecraft"
                    "/mnt/Data/NextCloud"
                ];
                exclude = [
                    "*.tmp"
                ];
                startAt = [ ];
                prune.keep = {
                    weekly = 4;
                    monthly = -1;
                };
                encryption = {
                    mode = "repokey-blake2";
                    passCommand = "cat /home/guibi/keys/niftic_borg";
                };
            };

            azom = {
                repo = "/mnt/azom/borg";
                doInit = true;
                compression = "zlib";
                paths = [
                    "/mnt/Data/Backups/Minecraft"
                    "/mnt/Data/NextCloud"
                ];
                exclude = [
                    "*.tmp"
                ];
                startAt = [ ];
                prune.keep = {
                    weekly = 4;
                    monthly = -1;
                };
                encryption = {
                    mode = "repokey-blake2";
                    passCommand = "cat /home/guibi/keys/azom_borg";
                };
            };
        };
    };

    systemd.timers = {
        "borgbackup-job-niftic" = {
            description = "Daily timer for niftic BorgBackup";
            requires = [ "mnt-niftic.mount" ];
            after = [ "mnt-niftic.mount" ];
            timerConfig = {
                OnCalendar = "daily";
                Unit = "borgbackup-job-niftic.service";
            };
            wantedBy = [ "timers.target" ];
        };

        "borgbackup-job-azom" = {
            description = "Daily timer for azom BorgBackup";
            requires = [ "mnt-azom.mount" ];
            after = [ "mnt-azom.mount" ];
            timerConfig = {
                OnCalendar = "daily";
                Unit = "borgbackup-job-azom.service";
            };
            wantedBy = [ "timers.target" ];
        };
    };
}
