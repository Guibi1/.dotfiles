{
    description = "Guibi's Mac dotfiles";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        darwin.url = "github:nix-darwin/nix-darwin/master";
        darwin.inputs.nixpkgs.follows = "nixpkgs";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = inputs@{ nixpkgs, darwin, home-manager , ... }:
    {
        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#Hermes
        darwinConfigurations."Hermes" = darwin.lib.darwinSystem {
            modules = [
                ./darwin-config.nix
                home-manager.darwinModules.home-manager {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.guibi = ./home.nix;
                }
            ];
        };
    };
}
