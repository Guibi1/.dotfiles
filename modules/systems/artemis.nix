{
  inputs,
  config,
  selectModules,
  ...
}:
let
  selectedModules = selectModules [
    config.hardware.base
    config.hardware.audio
    config.hardware.nvidia
    config.hardware.bluetooth
    config.shell
    config.desktop
  ];
in
{
  config.flake.nixosConfigurations.Artemis = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = selectedModules.nixos ++ [
      ../../hosts/artemis/hardware-configuration.nix
      {
        networking.hostName = "Artemis";
        system.stateVersion = "25.11";
        home-manager.users.guibi = {
          imports = selectedModules.home;
          programs.git.signing.key = "1F1C47D520393678";
        };
      }
    ];
  };
}
