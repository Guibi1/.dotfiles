{ ... }: {
  config.hardware.base.nixos = {
    boot = {
      kernelParams = [ "quiet" ];
      consoleLogLevel = 2;

      loader = {
        efi.canTouchEfiVariables = true;
        timeout = 0;

        limine = {
          enable = true;
          maxGenerations = 10;
          secureBoot = {
            enable = true;
            autoGenerateKeys = true;
            autoEnrollKeys.enable = true;
          };
        };
      };

      plymouth = {
        enable = true;
        theme = "breeze";
      };

      kernel.sysctl = {
        "fs.inotify.max_user_watches" = 524288;
        "fs.inotify.max_user_instances" = 8192;
      };
    };
  };
}
