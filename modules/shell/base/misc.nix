{ ... }: {
  config.shell.base.home = {
    home.username = "guibi";
    home.homeDirectory = "/home/guibi";
    home.stateVersion = "23.11";
    home.sessionPath = [ "$HOME/.cache/.bun/bin" ];

    programs.home-manager.enable = true;
  };
}
