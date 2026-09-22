{ ... }: {
  config.shell.base.home = {
    programs.zoxide = {
      enable = true;
      options = [ "--cmd cd" ];
      enableBashIntegration = true;
      enableFishIntegration = true;
      enableZshIntegration = true;
    };
  };
}
