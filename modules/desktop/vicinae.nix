{ ... }:
{
  config.desktop.home = { lib, ... }: {
    programs.vicinae = {
      enable = true;
      systemd.enable = true;

      settings = {
        close_on_focus_loss = true;
        pop_to_root_on_close = true;
        wrap_navigation = true;
        encrypt_sensitive_data = true;
        tray.enabled = false;

        font = {
          rendering = "native";
          normal = {
            family = "Cascadia Code PL SemiLight";
            size = 10;
          };
        };
        theme = {
          light = {
            name = "catppuccin-mocha";
            icon_theme = "macOS";
          };
        };
        launcher_window = {
          opacity = 0.7;
          compact_mode.enabled = true;
        };

        providers = {
          applications = {
            preferences = {
              defaultAction = "focus";
              launchPrefix = "runapp --";
              paths = [ ];
            };

            entrypoints = {
              auto-cpufreq-gtk.enabled = false;
              cups.enabled = false;
              htop.enabled = false;
              uuctl.enabled = false;
              opencloudcmd.enabled = false;
            };
          };

          clipboard = {
            preferences = {
              monitoring = true;
              eraseOnStartup = false;
              evictionThreshold = "604800";
              ignorePasswords = true;
              preserveTagged = true;
            };
            entrypoints = {
              clear.enabled = false;
              clear-history.enabled = false;
            };
          };

          core = {
            entrypoints = {
              forget-telemetry.enabled = false;
              list-extensions.enabled = false;
              manage-fallback.enabled = false;
              open-config-file.enabled = false;
              open-default-config.enabled = false;
              reload-scripts.enabled = false;
              report-bug.enabled = false;
              search-tray.enabled = false;
              settings.enabled = false;
              show-logs.enabled = false;
              sponsor.enabled = false;
              store.enabled = false;
            };
          };
          files = {
            preferences = {
              autoIndexing = true;
              excludedIndexingPaths = [ ];
              indexingPaths = [
                "/home/guibi/Downloads"
                "/home/guibi/Documents"
                "/home/guibi/Images"
                "/home/guibi/OpenCloud"
              ];
            };
          };

          power = {
            entrypoints = {
              logout.enabled = false;
            };
          };
          developer.enabled = false;
          font.enabled = false;
          scripts.enabled = false;
          system.enabled = false;
          theme.enabled = false;
        };
      };
    };

    wayland.windowManager.hyprland.settings = {
      bind = [
        {
          _args = [
            "ALT_L + SPACE"
            (lib.generators.mkLuaInline "hl.dsp.exec_cmd('runapp vicinae toggle')")
          ];
        }
      ];
    };
  };
}
