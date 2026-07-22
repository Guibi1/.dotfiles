{ ... }: {
  config.desktop.home = { pkgs, ... }: {
    home.packages = with pkgs; [
      ((modrinth-app.override { jdks = [ graalvmPackages.graalvm-oracle ]; }).overrideAttrs (attrs: {
        buildCommand = attrs.buildCommand + ''
          wrapProgram "$out/bin/ModrinthApp" \
            --set __NV_DISABLE_EXPLICIT_SYNC 1
        '';
      }))
    ];
  };

  config.desktop.nixos = {
    programs.steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
