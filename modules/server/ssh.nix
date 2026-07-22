{ lib, ... }:
{
  options.server.ssh.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "SSH NixOS module";
  };

  config.server.ssh.nixos = {
    services.openssh = {
      enable = true;
      ports = [ 22 ];
      settings = {
        AllowUsers = [ "guibi" ];
        PermitRootLogin = "no";
        UseDns = true;
        X11Forwarding = false;
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

    services.fail2ban.enable = true;
  };
}
