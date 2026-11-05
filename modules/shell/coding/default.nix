{ lib, ... }: {
  options.shell.coding.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Coding shell NixOS module";
  };

  options.shell.coding.home = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Coding shell home-manager module";
  };

  config.shell.coding.home = { pkgs, ... }: {
    home.packages = with pkgs; [
      mosh
      hyperfine
      tokei

      # TypeScript
      bun
      nodejs_26

      # Rust
      rustup

      # Go
      go

      # Nix
      nixd
      nil

      # Python
      python3
      ruff
      uv
    ];
  };

  config.shell.coding.nixos = { pkgs, ... }: {
    programs.nix-ld.enable = true;

    environment.systemPackages = with pkgs; [
      gcc
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
