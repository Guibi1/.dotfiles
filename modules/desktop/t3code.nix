{ ... }: {
  config.desktop.home = { pkgs, ... }: {
    programs.t3code = {
      enable = true;
      package = pkgs.callPackage ../../packages/t3code-desktop/package.nix {
        t3code-cli = pkgs.callPackage ../../packages/t3code-cli/package.nix { };
        enableJujutsu = true;
      };
    };
  };
}
