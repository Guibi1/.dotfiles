{ ... }: {
  config.desktop.home = {
    programs.zed-editor = {
      enable = true;
      defaultEditor = true;
      installRemoteServer = true;
    };
  };

  config.desktop.nixos = {
    programs.nix-ld.enable = true;
  };
}
