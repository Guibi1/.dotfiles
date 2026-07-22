{ ... }: {
  config.hardware.base.nixos = { lib, ... }: {
    services.gnome.gnome-keyring.enable = true;

    security = {
      polkit.enable = true;
      rtkit.enable = true;

      pam.services.login.enableGnomeKeyring = true;

      sudo.enable = false;
      run0 = {
        enable = true;
        enableSudoAlias = true;
      };

      wrappers = {
        su.enable = lib.mkForce false;
        sudoedit.enable = lib.mkForce false;
        sg.enable = lib.mkForce false;
        pkexec.setuid = lib.mkForce false;
        newgrp.setuid = lib.mkForce false;
      };
    };
  };
}
