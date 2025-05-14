{ config, pkgs, ... }:
let
    vars = import ../vars.nix;
in
{
    # Services options
    services = {
        borgbackup.jobs = {
            niftic_main = {
                description = "Main niftic daily backup";
                repo = "niftic-ssh:/path/to/your/remote/repo";
                archiveFormat = "{hostname}-{now}";
                compression = "zlib";
                paths = [
                    "/mnt/Data/Backups/Minecraft"
                    "/mnt/Data/Nextcloud"
                ];
                exclude = [
                    "*.tmp"
                ];
                prune = {
                    keepDaily = 7;
                    keepWeekly = 4;
                    keepMonthly = 6;
                };
                timer = {
                    OnCalendar = "daily";
                    Persistent = true;
                };
            };

            azom_main = {
                description = "Main azom daily backup";
                repo = "azom-ssh:/data";
                archiveFormat = "{hostname}-{now}";
                compression = "zlib";
                paths = [
                    "/mnt/Data/Backups/Minecraft"
                    "/mnt/Data/Nextcloud"
                ];
                exclude = [
                    "*.tmp"
                ];
                prune = {
                    keepDaily = 7;
                    keepWeekly = 4;
                    keepMonthly = 6;
                };
                timer = {
                    OnCalendar = "daily";
                    Persistent = true;
                };
            };
        };
    };
}
