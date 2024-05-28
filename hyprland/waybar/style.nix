{ ... }:
let
    custom = {
        font = "Cascadia Code PL";
        font_size = "14px";
        font_weight = "bold";
        text_color = "#cdd6f4";
        secondary_accent = "89b4fa";
        tertiary_accent = "f5f5f5";
        background = "11111B";
        opacity = "0.98";
    };
in
{
    programs.waybar.style = ''
        * {
            border: none;
            border-radius: 0px;
            padding: 0;
            margin: 0;
            min-height: 0px;
            font-family: ${custom.font};
            font-weight: ${custom.font_weight};
            opacity: ${custom.opacity};
        }

        window#waybar {
            background: none;
        }

        /* MODULES LEFT */
        #custom-launcher {
            font-size: 24px;
            color: #${custom.secondary_accent};
            color: #b4befe;
            font-weight: ${custom.font_weight};
            
            background: #${custom.background};

            padding: 4px 16px;
            padding-right: 32px;
            border-radius: 0px 0px 40px 0px;
        }

        #workspaces {
            font-size: 18px;
            padding-left: 15px;
        }
        #workspaces button {
            color: ${custom.text_color};
            padding-left:  6px;
            padding-right: 6px;
        }
        #workspaces button.empty {
            color: #6c7086;
        }
        #workspaces button.active {
            color: #b4befe;
        }

        /* MODULES CENTER */
        #clock {
            padding-left: 9px;
            padding-right: 15px;
        }

        /* MODULES RIGHT */
        #tray, #pulseaudio, #network, #cpu, #memory, #disk, #clock, #battery {
            font-size: ${custom.font_size};
            color: ${custom.text_color};
        }

        #cpu {
            padding-left: 15px;
            padding-right: 9px;
            margin-left: 7px;
        }
        #memory {
            padding-left: 9px;
            padding-right: 9px;
        }
        #disk {
            padding-left: 9px;
            padding-right: 15px;
        }

        #tray {
            padding: 0 20px;
            margin-left: 7px;
        }

        #pulseaudio {
            padding-left: 15px;
            padding-right: 9px;
            margin-left: 7px;
        }
        #battery {
            padding-left: 9px;
            padding-right: 9px;
        }
        #network {
            padding-left: 9px;
            padding-right: 15px;
        }        
    '';
}
