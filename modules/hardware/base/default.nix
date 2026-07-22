{ inputs, lib, ... }: {
  options.hardware.base.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Base NixOS module";
  };

  config.hardware.base.nixos = { ... }: {
    imports = [ inputs.home-manager.nixosModules.default ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
    };

    nixpkgs.config.allowUnfree = true;
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
    };
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
