{ inputs, ... }:
{
  config.desktop.home = {
    imports = [
      inputs.zen-browser.homeModules.default
    ];

    programs.zen-browser = {
      enable = true;
      setAsDefaultBrowser = true;
      policies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
      };
    };
  };
}
