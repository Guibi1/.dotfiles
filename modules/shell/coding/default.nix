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
      yubikey-manager
      mosh
      hyperfine
      tokei

      # TypeScript
      bun
      nodejs_22

      # Rust
      rustup
      binaryen

      # Go
      go

      # Nix
      nixd
      nil

      # Python
      python3
      ruff
      uv

      # Java
      graalvmPackages.graalvm-ce
      jdt-language-server

      # Embedded
      espup
      espflash
      probe-rs-tools
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
