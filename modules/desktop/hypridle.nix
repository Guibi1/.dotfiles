{ ... }: {
  config.desktop.home = {
    services.hypridle = {
      enable = true;

      settings = {
        general = {
          lock_cmd = "pidof hyprlock || runapp hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch \"hl.dsp.dpms({ action = 'enable' })\"";
        };

        listener = [
          {
            timeout = 120;
            on-timeout = "hyprctl dispatch \"hl.dsp.dpms({ action = 'disable' })\"";
            on-resume = "hyprctl dispatch \"hl.dsp.dpms({ action = 'enable' })\"";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 1200;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
