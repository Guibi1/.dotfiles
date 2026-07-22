{ inputs, ... }: {
  config.shell.home = { lib, pkgs, ... }: {
    programs.jujutsu = {
      enable = true;
      settings = {
        user.name = "Laurent Stéphenne";
        user.email = "laurent@guibi.dev";
        signing.behavior = "own";
        signing.backend = "gpg";
        git.sign-on-push = true;
        git.colocate = true;
        ui.editor = "${
          lib.getExe inputs.cme.packages.${pkgs.stdenv.hostPlatform.system}.default
        } --title 'Enter commit description'";
        ui.default-command = [
          "log"
          "-r"
          "@|ancestors(remote_bookmarks().., 2)|trunk()"
        ];
        remotes.origin.fetch-tags = "v*";
      };
    };

    programs.gpg.enable = true;
  };
}
