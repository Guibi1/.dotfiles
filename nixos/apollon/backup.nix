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
        host = 10.200.0.1
        port = 2022
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


    # Restic options
    services.restic = {
        backups = {
            niftic = {
                repository = "sftp://guibi@niftic.hopto.org:16810//uploads/restic";
                initialize = true;
                paths = [
                    "/mnt/Data/Backups/Minecraft"
                    "/mnt/Data/NextCloud"
                ];
                exclude = [
                    "*.tmp"
                ];
                checkOpts = [
                    "--with-cache"
                ];
                passwordFile = "/home/guibi/keys/niftic_restic";
                timerConfig = {
                    OnCalendar = "daily";
                    Persistent = true;
                };
                pruneOpts = [
                    "--keep-weekly 4"
                    "--keep-monthly 12"
                    "--keep-yearly 3"
                ];
                extraOptions = [
                    "sftp.args='-i /home/guibi/keys/niftic_ed25519'"
                ];
            };

            azom = {
                repository = "sftp://guibi@10.200.0.1:2022//restic";
                initialize = true;
                paths = [
                    "/mnt/Data/Backups/Minecraft"
                    "/mnt/Data/NextCloud"
                ];
                exclude = [
                    "*.tmp"
                ];
                checkOpts = [
                    "--with-cache"
                ];
                passwordFile = "/home/guibi/keys/azom_restic";
                timerConfig = {
                    OnCalendar = "daily";
                    Persistent = true;
                };
                pruneOpts = [
                    "--keep-weekly 4"
                    "--keep-monthly 12"
                    "--keep-yearly 3"
                ];
                extraOptions = [
                    "sftp.args='-i /home/guibi/keys/azom_ed25519'"
                ];
            };
        };
    };

    networking.wg-quick.interfaces = {
        wg0azom = {
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
    };
}
