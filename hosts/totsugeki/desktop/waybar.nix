{ pkgs, ... }: {
  programs.waybar = {
    enable = true;
    settings = {
      primary = {
        layer = "top";
        spacing = 0;
        position = "bottom";
        mode = "dock";
        modules-left = [
          "clock"
          "pulseaudio"
          "cpu"
          "temperature"
          "custom/gpu"
          "temperature#gpu"
          "memory"
        ];
        modules-center = [ "hyprland/workspaces" "hyprland/submap" ];
        modules-right = [ "mpris" ];
        "hyprland/workspaces" = {
          format = "{icon}";
          format-icons = {
            "1" = "󰈹 ";
            "2" = " ";
            "3" = " ";
            "8" = " ";
            "9" = " ";
            "10" = " ";
            default = " ";
          };
          persistent-workspaces = { "*" = 10; };
          sort-by-number = true;
        };
        "hyprland/submap" = { format = "  {}"; };
        temperature = {
          hwmon-path-abs = "/sys/devices/pci0000:00/0000:00:18.3/hwmon";
          input-filename = "temp1_input";
        };
        "temperature#gpu" = {
          hwmon-path-abs =
            "/sys/devices/pci0000:00/0000:00:03.1/0000:05:00.0/0000:06:00.0/0000:07:00.0/hwmon";
          input-filename = "temp1_input";
        };
        "custom/gpu" = {
          exec = "cat /sys/class/drm/card*/device/gpu_busy_percent";
          format = "GPU {}%";
          restart-interval = 2;
        };
        mpris = {
          format = "{player_icon}{status_icon} {artist} // {title}";
          interval = 0.2;
          player-icons = {
            default = "";
            firefox = "󰈹 ";
          };
          status-icons = {
            paused = "";
            playing = "";
          };
        };
        clock = {
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          format = " {:%Y-%m-%d %H:%M:%S}";
          interval = 1;
          calendar = {
            mode = "year";
            mode-mon-col = 2;
            weeks-pos = "right";
            on-scroll = 1;
            on-click-right = "mode";
            format = {
              days = "<span color='#e0def4'>{}</span>";
              today = "<span color='#eb6f92'><b><u>{}</u></b></span>";
              weeks = "";
              weekdays = "<span color='#9ccfd8'><b>{}</b></span>";
              months = "<span color='#31748f'><b>{}</b></span>";
            };
          };
        };
        cpu = {
          format = "CPU {usage}%";
          tooltip = false;
          interval = 2;
          on-click = "kitty htop";
        };
        memory = {
          format = "MEM {used}GB";
          interval = 1;
          tooltip-format = "{percentage}%";
        };
        pulseaudio = {
          scroll-step = 5;
          format = "{icon} {volume}% {format_source}";
          format-muted = "󰖁  {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = { default = [ "" "" ]; };
          ignored-sinks = [ "Easy Effects Sink" ];
        };
      };
    };
    style = ''
      * {
        border: none;
        background-color: transparent;
        font-family: Iosevka Nerd Font;
        font-weight: bold;
        font-size: 14px;
      }

      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #cdd6f4;
        margin: 4px;
      }

      tooltip {
        background: #1e1e2e;
        border: 2px solid #313244;
      }

      #mpris {
        color: #f5c2e7;
        padding-right: 20px;
      }

      #workspaces button {
        padding: 1px;
        color: #cdd6f4;
        margin-right: 6px;
      }

      #workspaces button.persistent {
        color: #cdd6f4;
      }

      #workspaces button.focused {
        border: 0;
      }

      #workspaces button.urgent {
        color: #f38ba8;
      }

      #workspaces button.empty {
        color: #313244;
      }

      #workspaces button.active {
        color: #cba6f7;
      }

      #submap {
        color: #cba6f7;
        margin-left: 4px;
        padding: 0 8px;
      }

      #cpu {
        color: #f9e2af;
        padding-right: 6px;
      }

      #temperature {
        color: #f9e2af;
        padding-right: 12px;
      }

      #custom-gpu {
        color: #94e2d5;
        padding-right: 6px;
      }

      #temperature.gpu {
        color: #94e2d5;
        padding-right: 12px;
      }

      #memory {
        color: #a6e3a1;
        padding-right: 12px;
      }

      #pulseaudio {
        color: #fab387;
        padding-right: 12px;
      }

      #clock {
        color: #f38ba8;
        padding-left: 20px;
        padding-right: 12px;
      }
    '';
  };
}
