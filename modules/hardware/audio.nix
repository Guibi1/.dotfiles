{ lib, ... }: {
  options.hardware.audio.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Audio NixOS module";
  };

  options.hardware.audio.home = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Audio home-manager module";
  };

  config.hardware.audio.nixos = {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  config.hardware.audio.home = { lib, ... }: {
    services.playerctld.enable = true;
    services.easyeffects.enable = true;

    wayland.windowManager.hyprland.settings = {
      bind = [
        {
          _args = [
            "XF86AudioRaiseVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 2%+')")
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioLowerVolume"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('wpctl set-volume @DEFAULT_AUDIO_SINK@ 2%-')")
            {
              locked = true;
              repeating = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioMute"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle')")
            {
              locked = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioPlay"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('playerctl play-pause')")
            {
              locked = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioNext"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('playerctl next')")
            {
              locked = true;
            }
          ];
        }
        {
          _args = [
            "XF86AudioPrev"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('playerctl previous')")
            {
              locked = true;
            }
          ];
        }
      ];
    };
  };
}
