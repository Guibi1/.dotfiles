{ lib, config, ... }:
{
  options.server.sftp.users = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          keys = lib.mkOption { type = lib.types.listOf lib.types.str; };
          chroot = lib.mkOption { type = lib.types.str; };
        };
      }
    );
    description = "SFTP users and their authorized keys and chroot directories.";
  };

  options.server.sftp.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "SFTP NixOS module";
  };

  config.server.sftp.nixos = { lib, ... }: {
    users.users = builtins.listToAttrs (
      map (user: {
        name = user.name;
        value = {
          isNormalUser = true;
          createHome = false;
          shell = "/bin/false";
          useDefaultShell = false;
          openssh.authorizedKeys.keys = user.keys;
        };
      }) config.server.sftp.users
    );

    services = {
      openssh = {
        settings.AllowUsers = map (user: user.name) config.server.sftp.users;

        extraConfig =
          let
            names = lib.strings.join "," (map (user: user.name) config.server.sftp.users);
          in
          ''
            Match User ${names}
                ForceCommand internal-sftp
                AllowTcpForwarding no
                AllowAgentForwarding no
                AllowStreamLocalForwarding no
                PermitTTY no
                PermitUserRC no
                X11Forwarding no
          ''
          + lib.strings.join "\n" (
            map (user: ''
              Match User ${user.name}
                  ChrootDirectory ${user.chroot}
            '') config.server.sftp.users
          );
      };
    };
  };
}
