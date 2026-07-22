{ ... }: {
  config.desktop.home = { lib, ... }: {
    programs.hyprlock = {
      enable = true;

      settings = {
        general.ignore_empty_input = true;

        background = [
          {
            path = "~/Images/wallpaper.png";
          }
        ];

        label = [
          {
            text = "cmd[update:1000] date +'%A %-d %B'";
            font_size = 28;
            font_family = "Cascadia Code PL Extra Bold";
            color = "rgba(255, 255, 255, .8)";

            shadow_passes = 4;
            shadow_size = 10;
            shadow_color = "rgb(0, 0, 0)";
            shadow_boost = 1.4;

            position = "0, -120";
            halign = "center";
            valign = "top";
          }
          {
            text = "$TIME";
            font_size = 120;
            font_family = "Cascadia Code PL Bold";
            color = "rgba(255, 255, 255, .7)";

            shadow_passes = 4;
            shadow_size = 8;
            shadow_color = "rgb(0, 0, 0)";
            shadow_boost = 0.8;

            position = "0, -150";
            halign = "center";
            valign = "top";
          }
          {
            text = "Bonjour, $USER";
            font_size = 20;
            font_family = "Cascadia Code PL";
            color = "rgba(255, 255, 255, .8)";

            shadow_passes = 4;
            shadow_size = 8;
            shadow_color = "rgb(0, 0, 0)";
            shadow_boost = 0.8;

            position = "0, 124";
            halign = "center";
            valign = "bottom";
          }
        ];

        input-field = [
          {
            outline_thickness = 0;
            fade_on_empty = false;
            font_family = "Cascadia Code PL";
            placeholder_text = "Mot de passe";
            fail_text = "$FAIL <b>($ATTEMPTS)</b>";

            font_color = "rgba(255, 255, 255, .7)";
            inner_color = "rgba(0, 0, 0, .3)";
            check_color = "rgba(0, 0, 0, .3)";
            fail_color = "rgba(0, 0, 0, .3)";

            dots_size = 0.3;
            dots_spacing = 0.3;
            dots_center = true;

            shadow_passes = 3;
            shadow_size = 8;
            shadow_color = "rgb(0, 0, 0)";
            shadow_boost = 0.8;

            size = "320, 40";
            position = "0, 70";
            halign = "center";
            valign = "bottom";
          }
        ];
      };
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        {
          _args = [
            "SUPER + L"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('loginctl lock-session')")
          ];
        }
      ];

      on = [
        {
          _args = [
            "hyprland.start"
            (lib.generators.mkLuaInline "function() hl.exec_cmd('runapp hyprlock') end")
          ];
        }
      ];
    };
  };
}
