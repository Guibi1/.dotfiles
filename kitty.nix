{ config, pkgs, ... }:
let
    vars = import ./vars.nix;
in
{
    programs.kitty = {
        enable = true;

        font = {
            size = 14;
            name = "Cascadia Code PL";
            package = pkgs.cascadia-code;
        };

        settings = {
            foreground="#bfc9db";
            background="#13141c";
            selection_foreground="#ffffff";
            selection_background="#44475a";

            background_opacity="0.6";
            background_blur="0";

            url_color="#8be9fd";

            # black
            color0="#100e23";
            color8="#100e23";

            # red
            color1="#ff8080";
            color9="#ff5458";

            # green
            color2="#95ffa4";
            color10="#62d196";

            # yellow
            color3="#ffe9aa";
            color11="#ffb378";

            # blue
            color4="#91ddff";
            color12="#65b2ff";

            # magenta
            color5="#c991e1";
            color13="#906cff";

            # cyan
            color6="#aaffe4";
            color14="#63f2f1";

            # white
            color7="#cbe3e7";
            color15="#a6b3cc";

            # Cursor colors
            cursor="#f8f8f2";
            cursor_text_color="background";

            # Tab bar colors
            active_tab_foreground="#282a36";
            active_tab_background="#f8f8f2";
            inactive_tab_foreground="#282a36";
            inactive_tab_background="#6272a4";

            # Marks
            mark1_foreground="#282a36";
            mark1_background="#ff5555";

            # Splits/Windows
            active_border_color="#f8f8f2";
            inactive_border_color="#6272a4";
        };
    };
}
