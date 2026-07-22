{
  inputs,
  config,
  selectModules,
  ...
}:
let
  selectedModules = selectModules [ config.shell ];
in
{
  config.flake.homeConfigurations.guibi = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

    modules = selectedModules.home ++ [
      {
        programs.git = {
          signing.key = "1F1C47D520393678";
          settings = {
            core.sshCommand = "ssh.exe";
          };
        };
      }
    ];
  };
}
