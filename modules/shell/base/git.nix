{ inputs, ... }: {
  config.shell.base.home = { lib, pkgs, ... }: {
    programs.git = {
      enable = true;
      signing.signByDefault = true;
      settings = {
        user.name = "Laurent Stéphenne";
        user.email = "laurent@guibi.dev";
        pull.rebase = true;
        core.editor = "${
          lib.getExe inputs.cme.packages.${pkgs.stdenv.hostPlatform.system}.default
        } --title 'Enter commit description'";
      };
    };

    programs.gpg.enable = true;
  };
}
