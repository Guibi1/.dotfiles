{ ... }: {
  config.desktop.nixos = { pkgs, ... }: {
    programs.yubikey-touch-detector = {
      enable = true;
      libnotify = true;
    };

    environment.systemPackages = with pkgs; [
      yubikey-manager
    ];
  };
}
