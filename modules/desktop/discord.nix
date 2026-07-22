{ ... }: {
  config.desktop.home =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      krispPatcher =
        pkgs.writers.writePython3 "discord-krisp-patcher"
          {
            libraries = with pkgs.python3Packages; [
              capstone
              pyelftools
            ];
            flakeIgnore = [
              "E501"
              "F403"
              "F405"
            ];
          }
          (
            builtins.readFile (
              pkgs.fetchurl {
                url = "https://pastebin.com/raw/8tQDsMVd";
                sha256 = "sha256-IdXv0MfRG1/1pAAwHLS2+1NESFEz2uXrbSdvU9OvdJ8=";
              }
            )
          );

      krispDiscord = pkgs.discord.overrideAttrs (attrs: {
        postFixup =
          (attrs.postFixup or "")
          + ''${lib.getExe pkgs.fd} -g "discord_krisp.node" "$out/opt/Discord/modules" -x ${krispPatcher} {}'';

        stageModules = pkgs.writeShellScript "discord-stage-mine" ''
          store_modules="$1"
          modules_dir="${config.xdg.configHome}/discord/${attrs.version}/modules"

          mkdir -p "$modules_dir"
          for m in "$store_modules"/*; do
            dest="$modules_dir/$(basename "$m")"

            if [ -L "$dest" ]; then
              rm "$dest"
            fi

            ${lib.getExe pkgs.rsync} -a --checksum --delete "$m/" "$dest"
          done

          chmod -R u+w "$modules_dir"

          echo '${
            builtins.toJSON (lib.mapAttrs (_: mod: { installedVersion = mod; }) attrs.passthru.moduleVersions)
          }' \
            > "$modules_dir/installed.json"
        '';
      });
    in
    {
      home.packages = [
        (krispDiscord.override {
          withOpenASAR = true;
        })
      ];

      wayland.windowManager.hyprland.settings = {
        window_rule = [
          {
            name = "discord-dedicated-workspace";
            match.class = "discord";
            workspace = "name:D";
          }
        ];

        bind = [
          {
            _args = [
              "MOD3 + D"
              (lib.generators.mkLuaInline "hl.dsp.focus({ workspace = 'name:D' })")
            ];
          }
        ];
      };
    };
}
