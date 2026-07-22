{ ... }: {
  config.hardware.base.nixos = {
    users.users.guibi = {
      isNormalUser = true;
      description = "Laurent";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };
}
