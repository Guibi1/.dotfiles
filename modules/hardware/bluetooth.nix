{ lib, ... }: {
  options.hardware.bluetooth.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Bluetooth NixOS module";
  };

  options.hardware.bluetooth.home = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Bluetooth home-manager module";
  };

  config.hardware.bluetooth.nixos = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General = {
        DeviceID = "bluetooth:004C:0000:0000";
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };

    programs.librepods.enable = true;

    systemd.services = {
      bluetooth.serviceConfig = {
        ProtectKernelTunables = lib.mkDefault true;
        ProtectKernelModules = lib.mkDefault true;
        ProtectKernelLogs = lib.mkDefault true;
        ProtectHostname = true;
        ProtectControlGroups = true;
        ProtectProc = "invisible";
        SystemCallFilter = [
          "~@obsolete"
          "~@cpu-emulation"
          "~@swap"
          "~@reboot"
          "~@mount"
        ];
        SystemCallArchitectures = "native";
      };
    };
  };

  config.hardware.bluetooth.home = {
    services.mpris-proxy.enable = true;
  };
}
