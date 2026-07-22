{ ... }: {
  config.hardware.base.nixos = {
    powerManagement.enable = true;
    services.auto-cpufreq.enable = true;
  };
}
