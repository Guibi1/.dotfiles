{ ... }: {
  config.desktop.nixos = {
    virtualisation.docker = {
      enable = true;
      autoPrune.enable = true;

      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
  };
}
