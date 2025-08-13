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
    programs.waybar = {
        enable = true;

        settings.mainBar = {
            position = "bottom";
            layer = "top";

            # MODULES ORDER
            modules-left = [
                "custom/launcher"
                "hyprland/workspaces"
            ];
            modules-center = [
                "clock"
            ];
            modules-right = [
                "tray"
                "cpu"
                "memory"
                "disk"
                "pulseaudio"
                "battery"
                "network"
            ];

            # MODULES LEFT
            "custom/launcher" = {
                format = "";
                on-click = "pkill rofi || rofi -show drun";
                tooltip = "false";
            };

            "hyprland/workspaces" = {
                active-only = false;
                disable-scroll = true;
                format = "{icon}";
                on-click = "activate";
                format-icons = {
                    # "1" = "󰈹";
                    # "2" = "";
                    # "3" = "󰘙";
                    # "4" = "󰙯";
                    # "5" = "";
                    # "6" = "";
                    urgent = "";
                    default = "";
                    sort-by-number = true;
                };
                persistent-workspaces = {
                    "1" = [ ];
                    "2" = [ ];
                    "3" = [ ];
                    "4" = [ ];
                    "5" = [ ];
                };
            };

            # MODULES CENTER
            clock = {
                calendar = {
                    format = { today = "<span color='#b4befe'><b>{}</b></span>"; };
                };
                format = " {:%H:%M}";
                tooltip = "true";
                tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
                format-alt = " {:%d/%m}";
            };

            # MODULES RIGHT
            memory = {
                format = "󰟜 {}%";
                format-alt = "󰟜 {used} GiB"; # 
                interval = 2;
            };
            cpu = {
                format = "  {usage}%";
                format-alt = "  {avg_frequency} GHz";
                interval = 2;
            };
            disk = {
                # path = "/";
                format = "󰋊 {percentage_used}%";
                interval = 60;
            };
            network = {
                format-wifi = "  {signalStrength}%";
                format-ethernet = "󰀂 ";
                tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
                format-linked = "{ifname} (No IP)";
                format-disconnected = "󰖪 ";
            };
            tray = {
                icon-size = 20;
                spacing = 8;
            };
            pulseaudio = {
                format = "{icon} {volume}%";
                format-muted = "󰖁  {volume}%";
                format-icons = {
                    default = [ " " ];
                };
                scroll-step = 5;
                on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            };
            battery = {
                format = "{icon} {capacity}%";
                format-icons = [ " " " " " " " " " " ];
                format-charging = " {capacity}%";
                format-full = " {capacity}%";
                format-warning = " {capacity}%";
                interval = 5;
                states = {
                    warning = 20;
                };
                format-time = "{H}h{M}m";
                tooltip = true;
                tooltip-format = "{time}";
            };
        };

        style = ''
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
    };
}
