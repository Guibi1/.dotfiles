{ lib, ... }: {
  options.shell.base.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Base shell NixOS module";
  };

  options.shell.base.home = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Base shell home-manager module";
  };

  config.shell.base.nixos = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git
      htop
      jq
      socat
      xdg-utils
      ripgrep
      fd
    ];
  };

  imports =
    let
      dir = ./.;
      entries = builtins.readDir dir;
      isNixModule =
        name: type: type == "regular" && builtins.match ".*\\.nix" name != null && name != "default.nix";
      names = builtins.filter (name: isNixModule name entries.${name}) (builtins.attrNames entries);
    in
    map (name: dir + "/${name}") names;
}
