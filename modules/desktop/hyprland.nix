{ inputs, ... }: {
  config.desktop.home = { lib, ... }: {
    wayland.windowManager.hyprland = {
      enable = true;

      settings = {
        monitor = {
          output = "";
          mode = "highrr";
          position = "auto";
          scale = 1.25;
        };

        config = {
          input = {
            kb_layout = "ca";
            kb_options = "caps:hyper";
            follow_mouse = 2;
            sensitivity = -0.65;
            touchpad = {
              natural_scroll = true;
            };
          };

          general = {
            gaps_in = 0;
            gaps_out = 0;
            border_size = 1;
            layout = "dwindle";
            col = {
              active_border = "rgba(cba6f7aa)";
              inactive_border = "rgb(45475a)";
            };
          };

          decoration = {
            rounding = 12;
            rounding_power = 4;
            blur = {
              enabled = true;
              size = 4;
              passes = 2;
              special = true;
            };
          };

          animations = {
            enabled = true;
          };

          dwindle = {
            preserve_split = true;
          };

          misc = {
            vrr = 3;
            focus_on_activate = true;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          xwayland = {
            force_zero_scaling = true;
          };
        };

        animation = [
          {
            leaf = "windows";
            enabled = true;
            speed = 3;
            bezier = "default";
          }
          {
            leaf = "windowsOut";
            enabled = true;
            speed = 3;
            bezier = "default";
            style = "popin 80%";
          }
          {
            leaf = "border";
            enabled = true;
            speed = 10;
            bezier = "default";
          }
          {
            leaf = "borderangle";
            enabled = true;
            speed = 1;
            bezier = "default";
          }
          {
            leaf = "fade";
            enabled = true;
            speed = 7;
            bezier = "default";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 3;
            bezier = "default";
          }
        ];

        window_rule = [
          {
            match.title = "Picture-in-Picture";
            keep_aspect_ratio = true;
            content = "video";
            float = true;
            pin = true;
            size = [
              "monitor_w * 0.25"
              "monitor_h * 0.25"
            ];
            move = [
              "monitor_w * 0.75 - 16"
              "monitor_h * 0.75 - 16"
            ];
          }
        ];

        layer_rule = [
          {
            match.namespace = "vicinae";
            ignore_alpha = 0;
            no_anim = true;
            blur = true;
          }
        ];

        bind =
          let
            mkLuaBind =
              {
                keys,
                dispatcher,
                flags ? { },
              }:
              {
                _args = [
                  keys
                  (lib.generators.mkLuaInline dispatcher)
                  flags
                ];
              };
          in
          (
            [
              (mkLuaBind {
                keys = "MOD3 + W";
                dispatcher = "hl.dsp.window.close()";
              })
              (mkLuaBind {
                keys = "MOD3 + A";
                dispatcher = "hl.dsp.window.float({ action = 'toggle' })";
              })
              (mkLuaBind {
                keys = "MOD3 + P";
                dispatcher = "hl.dsp.window.pseudo()";
              })
              (mkLuaBind {
                keys = "MOD3 + Tab";
                dispatcher = "hl.dsp.focus({ workspace = 'previous_per_monitor' })";
              })
              # Device control
              (mkLuaBind {
                keys = "XF86MonBrightnessUp";
                dispatcher = "hl.dsp.exec_cmd('brightnessctl set 5%+')";
                flags = {
                  locked = true;
                  repeating = true;
                };
              })
              (mkLuaBind {
                keys = "XF86MonBrightnessDown";
                dispatcher = "hl.dsp.exec_cmd('brightnessctl set 5%- -n')";
                flags = {
                  locked = true;
                  repeating = true;
                };
              })
              # Special workspace (scratchpad)
              (mkLuaBind {
                keys = "MOD3 + S";
                dispatcher = "hl.dsp.workspace.toggle_special('magic')";
              })
              (mkLuaBind {
                keys = "MOD3 + ALT + S";
                dispatcher = "hl.dsp.window.move({ workspace = 'special:magic' })";
              })
              # Move/resize windows with MOD3 + LMB/RMB and dragging
              (mkLuaBind {
                keys = "MOD3 + mouse:272";
                dispatcher = "hl.dsp.window.drag()";
                flags = {
                  mouse = true;
                };
              })
              (mkLuaBind {
                keys = "MOD3 + mouse:273";
                dispatcher = "hl.dsp.window.resize()";
                flags = {
                  mouse = true;
                };
              })
            ]
            ++ (builtins.concatMap
              (dir: [
                (mkLuaBind {
                  keys = "SUPER + ${dir}";
                  dispatcher = "hl.dsp.window.move({ direction = '${dir}' })";
                })
                (mkLuaBind {
                  keys = "SUPER + SHIFT + ${dir}";
                  dispatcher = "hl.dsp.window.move({ workspace = '${dir}' })";
                })
              ])
              [
                "left"
                "right"
                "up"
                "down"
              ]
            )
            ++ builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = toString (i + 1);
                  key = if ws == "10" then "0" else ws;
                in
                [
                  (mkLuaBind {
                    keys = "MOD3 + ${key}";
                    dispatcher = "hl.dsp.focus({ workspace = ${ws} })";
                  })
                  (mkLuaBind {
                    keys = "MOD3 + ALT + ${key}";
                    dispatcher = "hl.dsp.window.move({ workspace = ${ws} })";
                  })
                ]
              ) 10
            )
          );
      };

      configType = "lua";
      systemd.enable = false;
      package = null;
      portalPackage = null;
    };
  };

  config.desktop.nixos = { pkgs, lib, ... }: {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };

    environment.systemPackages = with pkgs; [
      runapp
      brightnessctl
    ];
    programs.uwsm.enable = true;
    services.greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${lib.getExe pkgs.uwsm} start hyprland-uwsm.desktop";
          user = "guibi";
        };
        default_session = initial_session;
      };
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
