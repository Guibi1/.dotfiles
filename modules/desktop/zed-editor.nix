{ ... }: {
  config.desktop.home = {
    programs.zed-editor = {
      enable = true;
      defaultEditor = true;
      installRemoteServer = true;
    };
  };
}
