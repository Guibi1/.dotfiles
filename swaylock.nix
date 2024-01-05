{ config, pkgs, ... }:
let
    vars = import ./vars.nix;
in
{
    # Add swaylock
    programs.swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings = {
            daemonize=true;
            screenshots=true;
            # fade-in=0.1;
            effect-blur="8x3";
            color="1e1e2e";
            inside-color="00000000";
            inside-clear-color="00000000";
            inside-ver-color="00000000";
            inside-wrong-color="00000000";
            line-color="00000000";
            line-clear-color="00000000";
            line-ver-color="00000000";
            line-wrong-color="00000000";
            separator-color="89b4f4";
            ring-color="89b4f4";
            ring-clear-color="f5c2e7";
            ring-ver-color="cba6f7";
            ring-wrong-color="f38ba8";
            key-hl-color="94e2d5";
            bs-hl-color="f5c2e7";
            indicator-thickness=8;
            indicator-radius=100;
            timestr="%H:%M:%S";
            datestr="%y-%m-%d";
            font="monospace";
            font-size=32;
            text-color="cdd6f4";
            text-clear-color="00000000";
            text-ver-color="00000000";
            text-wrong-color="00000000";
            layout-bg-color="00000000";
            ignore-empty-password=true;
            indicator=true;
            clock=true;
        };
    };

    # Add swayidle
    home.packages = with pkgs; [ swayidle ];
    xdg.configFile.swayidle.source = ./dotfiles/swayidle;            
}
