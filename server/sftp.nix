{ config, pkgs, ... }:
let
    vars = import ../vars.nix;
in
{
    # SFTP users
    users.users = {
        azom = {
            isNormalUser = true;
            createHome = false;
            shell = "/bin/false";
            openssh.authorizedKeys.keys = [
                "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDt+DENKmUysV2ADG7h3WTVExRdgCzr6YH3ZzHeKt8Ke azom@fedora"
            ];
        };

        niftic = {
            isNormalUser = true;
            createHome = false;
            shell = "/bin/false";
            openssh.authorizedKeys.keys = [
            ];
        };
    };


    # Services options
    services = {
        openssh = {
            settings.AllowUsers = [ "azom" "niftic" ];

            extraConfig = "
                Match User azom
                    ForceCommand internal-sftp
                    ChrootDirectory /mnt/Data/Backups/Azom
                    AllowTcpForwarding no

                Match User niftic
                    ForceCommand internal-sftp
                    ChrootDirectory /mnt/Data/Backups/Niftic
                    AllowTcpForwarding no
            ";
        };
    };
}
