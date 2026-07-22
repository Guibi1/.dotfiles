{ ... }: {
  config.shell.home = { pkgs, ... }: {
    programs.fastfetch = {
      enable = true;

      settings = {
        display = {
          separator = " ❯ ";
          color = "cyan";
        };

        modules = [
          {
            type = "custom";
            format = " System Information";
            outputColor = "magenta";
          }
          {
            type = "custom";
            format = "════════════════════";
            outputColor = "magenta";
          }

          {
            type = "custom";
            format = " OS";
            outputColor = "red";
          }
          {
            type = "os";
            key = "├─   Distro";
            keyColor = "red";
          }
          {
            type = "kernel";
            key = "├─   Kernel";
            keyColor = "red";
          }

          {
            type = "custom";
            format = " Desktop Environment";
            outputColor = "green";
          }
          {
            type = "wm";
            key = "├─   WM";
            keyColor = "green";
          }
          {
            type = "theme";
            key = "├─   Theme";
            keyColor = "green";
          }
          {
            type = "icons";
            key = "├─  󰉦 Icons";
            keyColor = "green";
          }

          {
            type = "custom";
            format = " Terminal";
            outputColor = "yellow";
          }
          {
            type = "shell";
            key = "├─   Shell";
            keyColor = "yellow";
          }
          {
            type = "terminal";
            key = "├─   Term";
            keyColor = "yellow";
          }
          {
            type = "terminalfont";
            key = "├─   Font";
            keyColor = "yellow";
          }

          {
            type = "custom";
            format = "󰧑 Hardware";
            outputColor = "blue";
          }
          {
            type = "cpu";
            key = "├─  󰧑";
            keyColor = "blue";
          }
          {
            type = "gpu";
            key = "├─  󰍛";
            keyColor = "blue";
          }
          {
            type = "memory";
            key = "├─  ";
            keyColor = "blue";
          }
          {
            type = "display";
            key = "├─  ";
            keyColor = "blue";
          }
          {
            type = "localip";
            key = "├─  ";
            keyColor = "blue";
          }
          {
            type = "battery";
            key = "├─  ";
            keyColor = "blue";
          }
        ];
      };
    };

    xdg.configFile = {
      "fastfetch/greeting.jsonc".source = (pkgs.formats.json { }).generate "greeting.jsonc" {
        logo = null;
        display = {
          separator = "  ->  ";
        };

        modules = [
          "break"
          {
            type = "title";
            key = "  ";
            keyColor = "cyan";
          }
          {
            type = "custom";
            format = "┌───────────────────────────────────────────────────┐";
          }
          {
            type = "os";
            key = "  ";
            keyColor = "blue";
          }
          {
            type = "shell";
            key = "  ";
            keyColor = "green";
          }
          {
            type = "memory";
            key = "  ";
            keyColor = "red";
          }
          {
            type = "localip";
            key = "  󱦂";
          }
          {
            type = "battery";
            key = "  ";
            keyColor = "green";
          }
          {
            type = "custom";
            format = "└───────────────────────────────────────────────────┘";
          }
        ];
      };
    };

    programs.fish.interactiveShellInit = ''
      function fish_greeting
          if not set -q IN_NIX_SHELL
              fastfetch -c ~/.config/fastfetch/greeting.jsonc
          end
      end
    '';
  };
}
