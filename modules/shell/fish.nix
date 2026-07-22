{ ... }: {
  config.shell.home = { pkgs, ... }: {
    programs.fish = {
      enable = true;
      interactiveShellInit = "${pkgs.any-nix-shell}/bin/any-nix-shell fish | source";

      shellAliases = {
        cat = "bat";
      };

      plugins = [
        {
          name = "grc";
          src = pkgs.fishPlugins.grc.src;
        }
        {
          name = "pisces";
          src = pkgs.fishPlugins.pisces.src;
        }
        {
          name = "fzf";
          src = pkgs.fishPlugins.fzf-fish.src;
        }
      ];
    };

    home.packages = with pkgs; [
      bat
      grc
      fzf
    ];
  };

  config.shell.nixos = { pkgs, ... }: {
    programs.fish.enable = true;
    users.defaultUserShell = pkgs.fish;
  };
}
