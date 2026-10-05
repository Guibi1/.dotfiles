{ inputs, ... }: {
  config.hardware.base.nixos = { pkgs, ... }: {
    imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

    boot = {
      kernelParams = [ "quiet" ];
      consoleLogLevel = 2;
      initrd.systemd.enable = true;

      loader = {
        timeout = 0;
        efi.canTouchEfiVariables = true;
      };

      lanzaboote = {
        enable = true;
        configurationLimit = 8;
        pkiBundle = "/var/lib/sbctl";

        autoGenerateKeys.enable = true;
        autoEnrollKeys.enable = true;

        measuredBoot = {
          enable = true;
          pcrs = [
            0
            1
            2
            4
            7
          ];
        };
      };

      kernel.sysctl = {
        "fs.inotify.max_user_watches" = 524288;
        "fs.inotify.max_user_instances" = 8192;
      };
    };

    environment.systemPackages = [ pkgs.sbctl ];
  };
}
