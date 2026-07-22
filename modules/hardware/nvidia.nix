{ lib, ... }: {
  options.hardware.nvidia.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "NVIDIA NixOS module";
  };

  config.hardware.nvidia.nixos = {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];

    hardware.nvidia = {
      open = true;
      nvidiaSettings = false;
      modesetting.enable = true;
      powerManagement = {
        enable = true;
        kernelSuspendNotifier = true;
      };
    };

    boot.kernelParams = [ "nvidia.NVreg_PreserveVideoMemoryAllocations=1" ];

    environment.variables = {
      GBM_BACKEND = "nvidia-drm";
      LIBVA_DRIVER_NAME = "nvidia";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    };

    systemd.services.disable-xh00-wakeup = {
      description = "Disable XH00 USB wakeup";
      wantedBy = [ "multi-user.target" ];
      script = "echo XH00 > /proc/acpi/wakeup";
      serviceConfig.Type = "oneshot";
    };
  };
}
