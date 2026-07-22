{
  description = "Guibi's dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    darwin.url = "github:nix-darwin/nix-darwin/master";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";
    cme.url = "github:Guibi1/cme";
    cme.inputs.nixpkgs.follows = "nixpkgs";
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      {
        lib,
        config,
        selectModules,
        ...
      }@top:
      {
        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        imports =
          let
            importModules =
              dir:
              builtins.concatLists (
                builtins.attrValues (
                  builtins.mapAttrs (
                    name: type:
                    let
                      path = dir + "/${name}";
                    in
                    if type == "regular" && builtins.match ".*\\.nix" name != null then
                      [ path ]
                    else if type == "directory" then
                      let
                        defaultNix = path + "/default.nix";
                      in
                      if builtins.pathExists defaultNix then [ defaultNix ] else importModules path
                    else
                      [ ]
                  ) (builtins.readDir dir)
                )
              );
          in
          importModules ./modules;

        _module.args.selectModules = modules: {
          nixos = map (module: module.nixos or { }) modules;
          home = map (module: module.home or { }) modules;
        };

        perSystem =
          { system, ... }:
          let
            pkgs = inputs.nixpkgs.legacyPackages.${system};
            shellHome = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = (selectModules [ top.config.shell ]).home;
            };
          in
          lib.mkIf (system == "x86_64-linux") {
            packages.shell = shellHome.activationPackage;
            apps.shell = {
              type = "app";
              program = "${shellHome.activationPackage}/activate";
            };
          };
      }
    );
}
