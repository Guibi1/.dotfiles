{
  inputs,
  config,
  selectModules,
  ...
}:
let
  selectedModules = selectModules [
    config.shell.base
    config.shell.coding
  ];
in
{
  config.flake.darwinConfigurations.Hermes = inputs.darwin.lib.darwinSystem {
    modules = [
      ({ pkgs, ... }: {
        # Global
        environment = {
          systemPackages = with pkgs; [
            git
            aerospace
          ];
          shells = [ pkgs.fish ];
          variables = {
            SSH_SK_PROVIDER = "/usr/local/lib/libsk-libfido2.dylib";
          };
        };

        # Programs options
        programs = {
          zsh.enable = true;
          fish.enable = true;
        };

        # Security options
        security = {
          pam.services.sudo_local.touchIdAuth = true;
        };

        # Fonts
        fonts.packages = with pkgs; [
          cascadia-code
          nerd-fonts.fira-code
          noto-fonts
          liberation_ttf
        ];

        # Let Determinate manage nix
        nix.enable = false;

        # No touchy
        system.stateVersion = 6;
        nixpkgs.hostPlatform = "aarch64-darwin";
      })
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.guibi = { lib, ... }: {
          imports = selectedModules.home;
          home.homeDirectory = lib.mkForce "/Users/guibi";
          programs.git.signing.key = "5E5CABB6D17CFB3E";
        };
      }
    ];
  };
}
