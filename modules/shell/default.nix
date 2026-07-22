{ lib, ... }: {
  options.shell.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Shell NixOS module";
  };
  options.shell.home = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Shell home-manager module";
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
