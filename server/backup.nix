{ config, pkgs, ... }:
let
    vars = import ../vars.nix;
in
{
    # SFTP mounts
    environment.systemPackages = [ pkgs.rclone ];
    environment.etc."rclone-mnt.conf".text = "
        [niftic]
        type = sftp
        host = niftic.ca
        user = guibi
        key_file = /mnt/Data/Backups/keys/niftic_ed25519

        [azom]
        type = sftp
        host = azom.dev
        port = 6073
        user = guibi
        key_file = /mnt/Data/Backups/keys/azom_ed25519
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
                "config=/etc/rclone-mnt.conf"
            ];
        };
    };


    # Borgbackup options
    services.borgbackup = {
        jobs = {
            niftic = {
                repo = "/mnt/niftic/borg";
                doInit = true;
                compression = "zlib";
                paths = [
                    "/mnt/Data/Backups/Minecraft"
                    "/mnt/Data/NextCloud"
                ];
                exclude = [
                    "*.tmp"
                ];
                startAt = "daily";
                prune.keep = {
                    weekly = 4;
                    monthly = -1;
                };
                encryption = {
                    mode = "repokey-blake2";
                    passCommand = "cat /mnt/Data/Backups/keys/niftic_borg";
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
                startAt = "daily";
                prune.keep = {
                    weekly = 4;
                    monthly = -1;
                };
                encryption = {
                    mode = "repokey-blake2";
                    passCommand = "cat /mnt/Data/Backups/keys/azom_borg";
                };
            };
        };
    };
}
