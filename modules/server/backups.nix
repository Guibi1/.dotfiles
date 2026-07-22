{ lib, config, ... }:
{
  options.server.backups.settings = lib.mkOption {
    type = lib.types.submodule {
      options = {
        paths = lib.mkOption { type = lib.types.listOf lib.types.str; };
        pruneOpts = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [
            "--keep-daily 2"
            "--keep-weekly 3"
            "--keep-monthly 3"
            "--keep-yearly 3"
          ];
        };
      };
    };
    description = "Shared Restic backup settings.";
  };

  options.server.backups.remotes = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          host = lib.mkOption { type = lib.types.str; };
          port = lib.mkOption { type = lib.types.port; };
          user = lib.mkOption { type = lib.types.str; };
          resticPath = lib.mkOption { type = lib.types.str; };
          passwordFile = lib.mkOption { type = lib.types.path; };
          identityFile = lib.mkOption { type = lib.types.path; };
          wg = lib.mkOption {
            type = lib.types.nullOr (
              lib.types.submodule {
                options = {
                  address = lib.mkOption { type = lib.types.str; };
                  endpoint = lib.mkOption { type = lib.types.str; };
                  privateKeyFile = lib.mkOption { type = lib.types.path; };
                  publicKey = lib.mkOption { type = lib.types.str; };
                };
              }
            );
            default = null;
          };
        };
      }
    );

    description = "Backup remotes used for Restic, rclone, and optional WireGuard tunnels.";
  };

  options.server.backups.nixos = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Backups NixOS module";
  };

  options.server.backups.home = lib.mkOption {
    type = lib.types.deferredModule;
    description = "Backups home-manager module";
  };

  config.server.backups.nixos = { lib, pkgs, ... }: {
    # Restic options
    services.restic.backups = builtins.listToAttrs map (remote: {
      name = remote.name;
      value = {
        repository = "sftp://${remote.user}@${remote.host}:${toString remote.port}/${remote.resticPath}";
        passwordFile = remote.passwordFile;
        extraOptions = [ "sftp.args='-i ${remote.identityFile}'" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = true;
        };
        exclude = [
          "*.tmp"
        ];
        checkOpts = [ "--with-cache" ];
        paths = config.server.backups.settings.paths;
        pruneOpts = config.server.backups.settings.pruneOpts;
      };
    }) config.server.backups.remotes;

    # WireGuard options
    networking.wg-quick.interfaces = builtins.listToAttrs map (remote: {
      name = remote.name;
      value = {
        address = [ remote.wg.address ];
        privateKeyFile = remote.wg.privateKeyFile;

        peers = [
          {
            persistentKeepalive = 25;
            allowedIPs = [ "${remote.host}/32" ];
            endpoint = remote.wg.endpoint;
            publicKey = remote.wg.publicKey;
          }
        ];
      };
    }) lib.lists.filter (remote: remote.wg != null) config.server.backups.remotes;

    systemd = {
      # Re-resolve dynamic-DNS peer endpoints when a tunnel goes stale,
      # so WireGuard reconnects instead of staying dead on a stale IP.
      services.wg-endpoint-refresh = {
        description = "Re-resolve stale WireGuard peer endpoints (dynamic DNS)";
        after = map (remote: "wg-quick-${remote.name}.service") lib.lists.filter (
          remote: remote.wg != null
        ) config.server.backups.remotes;
        serviceConfig = {
          Type = "oneshot";
          ExecStart =
            let
              wg = "${pkgs.wireguard-tools}/bin/wg";
              awk = "${pkgs.gawk}/bin/awk";
              date = "${pkgs.uutils-coreutils-noprefix}/bin/date";
            in
            pkgs.writeShellScript "wg-endpoint-refresh" ''
              set -uo pipefail
              STALE=120  # seconds w/o handshake before intervening

              refresh() {  # iface pubkey endpoint
                  ${wg} show "$1" >/dev/null 2>&1 || return 0
                  now=$(${date} +%s)
                  hs=$(${wg} show "$1" latest-handshakes 2>/dev/null | ${awk} '{print $2}')
                  if [ -z "$hs" ] || [ $((now - hs)) -gt "$STALE" ]; then
                      ${wg} set "$1" peer "$2" endpoint "$3" || true
                  fi
              }
            ''
            + lib.strings.join "\n" map (
              remote: "refresh ${remote.name} ${remote.wg.publicKey} ${remote.wg.endpoint}"
            ) lib.lists.filter (remote: remote.wg != null) config.server.backups.remotes;
        };
      };

      timers.wg-endpoint-refresh = {
        description = "Periodically refresh stale WireGuard peer endpoints";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "2h";
          OnUnitActiveSec = "1h";
        };
      };
    };
  };

  config.server.backups.home = {
    programs.rclone = {
      enable = true;
      remotes = builtins.listToAttrs map (remote: {
        name = remote.name;
        value = {
          config = {
            type = "sftp";
            host = remote.host;
            port = remote.port;
            user = remote.user;
            key_file = remote.identityFile;
            shell_type = "unix";
            md5sum_command = "md5sum";
            sha1sum_command = "sha1sum";
          };
          mounts."/" = {
            enable = true;
            mountPoint = "/mnt/${remote.name}";
            options = {
              args2env = true;
              vfs-cache-mode = "writes";
            };
          };
        };
      }) config.server.backups.remotes;
    };
  };
}
