{ ... }:
{
    # SFTP users
    users.users = let base = {
        isNormalUser = true;
        createHome = false;
        shell = "/bin/false";
        useDefaultShell = false;
    }; in {
        azom = {
            openssh.authorizedKeys.keys = [
            ];
        } // base;

        niftic = {
            openssh.authorizedKeys.keys = [
            ];
        } // base;
    };


    # Services options
    services = {
        openssh = {
            settings.AllowUsers = [ "azom" "niftic" ];

            extraConfig = "
                Match User azom,niftic
                    ForceCommand internal-sftp
                    AllowTcpForwarding no
                    AllowAgentForwarding no
                    AllowStreamLocalForwarding no
                    PermitTTY no
                    PermitUserRC no
                    X11Forwarding no

                Match User azom
                    ChrootDirectory /mnt/Data/Backups/Azom

                Match User niftic
                    ChrootDirectory /mnt/Data/Backups/Niftic
            ";
        };
    };
}
