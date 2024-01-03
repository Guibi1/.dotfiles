args@{ config, pkgs, ... }:
let
    vars = import ./vars.nix;
in
{
    home.packages = with pkgs; [
        firefox

    ];

    programs = {
        kitty = {
            enable = true;

            font = {
                size = 14;
                name = "Cascadia Code PL";
                package = pkgs.cascadia-code;
            };
        };

        eww = {
            enable = true;
        };

        gpg = {
            enable = true;
        };

        vscode = {
            enable = true;
            enableUpdateCheck = false;
        };
    };

    wayland.windowManager.hyprland = {
        enable = true;

        settings = {
            "$mod" = "SUPER";
            bind =
            [
                "$mod, F, exec, firefox"
                ", Print, exec, grimblast copy area"
            ]
            ++ (
                # workspaces
                # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
                builtins.concatLists (builtins.genList (
                    x: let
                    ws = let
                        c = (x + 1) / 10;
                    in
                        builtins.toString (x + 1 - (c * 10));
                    in [
                    "$mod, ${ws}, workspace, ${toString (x + 1)}"
                    "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                    ]
                )
                10)
            );
        };
    };


    xdg.enable = true;
    fonts.fontconfig.enable = true; # Enable fontconfig
}
