{ ... }: {
  config.shell.base.home = {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
      enableTransience = true;

      settings = {
        add_newline = true;

        character = {
          success_symbol = "[[󰄛](green) ❯](peach)";
          error_symbol = "[[󰄛](red) ❯](peach)";
        };

        directory = {
          truncation_length = 4;
          style = "bold lavender";
        };

        palette = "catppuccin_mocha";
        palettes.catppuccin_mocha = {
          rosewater = "#f5e0dc";
          flamingo = "#f2cdcd";
          pink = "#f5c2e7";
          mauve = "#cba6f7";
          red = "#f38ba8";
          maroon = "#eba0ac";
          peach = "#fab387";
          yellow = "#f9e2af";
          green = "#a6e3a1";
          teal = "#94e2d5";
          sky = "#89dceb";
          sapphire = "#74c7ec";
          blue = "#89b4fa";
          lavender = "#b4befe";
          text = "#cdd6f4";
          subtext1 = "#bac2de";
          subtext0 = "#a6adc8";
          overlay2 = "#9399b2";
          overlay1 = "#7f849c";
          overlay0 = "#6c7086";
          surface2 = "#585b70";
          surface1 = "#45475a";
          surface0 = "#313244";
          base = "#1e1e2e";
          mantle = "#181825";
          crust = "#11111b";
        };

        git_status.disabled = true;
        git_commit.disabled = true;
        git_metrics.disabled = true;
        git_branch.disabled = true;

        custom = {
          jj = {
            symbol = "🥋 ";
            command = ''
              jj log --revisions @ --no-graph --ignore-working-copy --color always --limit 1 --template '
              separate(" ",
                  change_id.shortest(7),
                  bookmarks,
                  concat(
                      if(conflict, "💥"),
                      if(divergent, "🚧"),
                      if(hidden, "👻"),
                      if(immutable, "🔒"),
                  ),
                  raw_escape_sequence("\x1b[1;32m") ++ if(empty, "(empty)"),
                  raw_escape_sequence("\x1b[1;32m") ++ truncate_end(16, description.first_line(), "…") ++ raw_escape_sequence("\x1b[0m"),
              )'
            '';
            require_repo = true;
            shell = [
              "bash"
              "--norc"
              "--noprofile"
            ];
            when = "while ! test -d .jj; do test $PWD = / && exit 1; cd -P ..; done; exit 0";
          };

          git_status = {
            command = "starship module git_status";
            require_repo = true;
            shell = [
              "bash"
              "--norc"
              "--noprofile"
            ];
            when = "while ! test -d .jj; do test $PWD = / && exit 0; cd -P ..; done; exit 1";
          };

          git_commit = {
            command = "starship module git_commit";
            require_repo = true;
            shell = [
              "bash"
              "--norc"
              "--noprofile"
            ];
            when = "while ! test -d .jj; do test $PWD = / && exit 0; cd -P ..; done; exit 1";
          };

          git_metrics = {
            command = "starship module git_metrics";
            require_repo = true;
            shell = [
              "bash"
              "--norc"
              "--noprofile"
            ];
            when = "while ! test -d .jj; do test $PWD = / && exit 0; cd -P ..; done; exit 1";
          };

          git_branch = {
            command = "starship module git_branch";
            style = "bold mauve";
            require_repo = true;
            shell = [
              "bash"
              "--norc"
              "--noprofile"
            ];
            when = "while ! test -d .jj; do test $PWD = / && exit 0; cd -P ..; done; exit 1";
          };
        };
      };
    };
  };
}
