{ ... }: {
  config.desktop.home = {
    programs.quickshell = {
      enable = true;
      systemd.enable = true;
    };
  };
}
