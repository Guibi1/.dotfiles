{
    description = "Guibi's dotfiles";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        darwin.url = "github:nix-darwin/nix-darwin/master";
        darwin.inputs.nixpkgs.follows = "nixpkgs";
        home-manager.url = "github:nix-community/home-manager";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";
    };

    outputs = { nixpkgs, darwin, home-manager , ... }:
    {
        # Build nixos flake using:
        # $ nixos-rebuild build --flake .#Apollon
        nixosConfigurations."Apollon" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { home-manager = home-manager; };
            modules = [
                ./nixos/base-config.nix
                ./nixos/apollon/config.nix
            ];
        };

        # Build nixos flake using:
        # $ nixos-rebuild build --flake .#Artemis
        nixosConfigurations."Artemis" = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = { home-manager = home-manager; };
            modules = [
                ./nixos/base-config.nix
                ./nixos/artemis/config.nix
            ];
        };

        # Build darwin flake using:
        # $ darwin-rebuild build --flake .#Hermes
        darwinConfigurations."Hermes" = darwin.lib.darwinSystem {
            modules = [
                ./darwin-config.nix
                home-manager.darwinModules.home-manager {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.guibi = { lib, ... }: {
                        imports = [./home-manager/base-config.nix];
                        home.homeDirectory = lib.mkForce "/Users/guibi";
                        programs.git.signing.key = "5E5CABB6D17CFB3E";
                    };
                }
            ];
        };

        # Build home-manager configuration for WSL using:
        # $ home-manager switch --flake .#guibi
        homeConfigurations."guibi" = home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.x86_64-linux;

            modules = [
                ./home-manager/base-config.nix
                {
                    programs.git = {
                        signing.key = "1F1C47D520393678";
                        extraConfig = {
                            core.sshCommand = "ssh.exe";
                        };
                    };
                }
            ];
        };
    };
}
