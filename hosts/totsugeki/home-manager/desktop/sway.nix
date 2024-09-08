{ config, pkgs, ... }:
let cfg = config.wayland.windowManager.sway.config;
in {
  home.packages = with pkgs; [ autotiling ];
  wayland.windowManager.sway = {
    enable = true;
    package = pkgs.swayfx;
    checkConfig = false; # checkConfig crashes with swayfx on activation
    config = {
      bars = [ ];
      input = {
        "type:keyboard" = {
          xkb_layout = "es";
          xkb_variant = "dvorak";
          xkb_options = "lv5:caps_switch";
        };
        "type:pointer" = {
          "accel_profile" = "flat";
          "pointer_accel" = "-0.4";
        };
      };
      focus.followMouse = "always";
      floating.titlebar = false;
      gaps = {
        inner = 4;
        smartBorders = "off";
        smartGaps = false;
      };
      keybindings = let
        Super = "Mod4";
        Hyper = "Mod3";
      in {
        "Ctrl+Alt+T" = "exec ${cfg.terminal}";
        "${Super}+Space" = "exec ags -t launcher";
        "${Super}+C" = "exec ags -t bar_extended";
        "${Hyper}+C" = "exec ags -t popup_clock";
        # Workspace management
        "${Super}+1" = "workspace number 1";
        "${Super}+2" = "workspace number 2";
        "${Super}+3" = "workspace number 3";
        "${Super}+4" = "workspace number 4";
        "${Super}+5" = "workspace number 5";
        "${Super}+6" = "workspace number 6";
        "${Super}+7" = "workspace number 7";
        "${Super}+8" = "workspace number 8";
        "${Super}+9" = "workspace number 9";
        "${Super}+0" = "workspace number 10";
        "${Super}+Shift+1" = "move container to workspace number 1";
        "${Super}+Shift+2" = "move container to workspace number 2";
        "${Super}+Shift+3" = "move container to workspace number 3";
        "${Super}+Shift+4" = "move container to workspace number 4";
        "${Super}+Shift+5" = "move container to workspace number 5";
        "${Super}+Shift+6" = "move container to workspace number 6";
        "${Super}+Shift+7" = "move container to workspace number 7";
        "${Super}+Shift+8" = "move container to workspace number 8";
        "${Super}+Shift+9" = "move container to workspace number 9";
        "${Super}+Shift+0" = "move container to workspace number 10";
        # Window management
        "${Super}+W" = "kill";
        "${Super}+${cfg.left}" = "focus left";
        "${Super}+${cfg.right}" = "focus right";
        "${Super}+${cfg.up}" = "focus up";
        "${Super}+${cfg.down}" = "focus down";
        "${Super}+Shift+${cfg.left}" = "move left";
        "${Super}+Shift+${cfg.right}" = "move right";
        "${Super}+Shift+${cfg.up}" = "move up";
        "${Super}+Shift+${cfg.down}" = "move down";
        "${Super}+F11" = "fullscreen toggle";
        # Modes
        "${Hyper}+W" = "mode wallpaper";
        "${Hyper}+M" = "mode music";
        "${Hyper}+R" = "mode resize";
        # Speaker volume
        "XF86AudioRaiseVolume" = "exec volumectl output +5";
        "XF86AudioLowerVolume" = "exec volumectl output -5";
        # Microphone volume
        "Shift+XF86AudioRaiseVolume" = "exec volumectl input +5";
        "Shift+XF86AudioLowerVolume" = "exec volumectl input -5";
        # Brightness
        "Alt+XF86AudioRaiseVolume" = "exec ddc-brightness +5";
        "Alt+XF86AudioLowerVolume" = "exec ddc-brightness -5";
        # Screenshots
        "${Super}+S" = "exec screenshot full";
        "${Super}+Shift+S" = "exec screenshot section";
      };
      modes = {
        music = {
          p = "exec playerctl play-pause";
          h = "exec playerctl previous";
          l = "exec playerctl next";
          Escape = "mode default";
        };
        resize = {
          "${cfg.left}" = "resize shrink width 10px";
          "${cfg.right}" = "resize grow width 10px";
          "${cfg.up}" = "resize shrink height 10px";
          "${cfg.down}" = "resize grow height 10px";
          Escape = "mode default";
        };
        wallpaper = {
          l = "exec change-wallpaper next";
          h = "exec change-wallpaper previous";
          Escape = "mode default";
        };
      };
      output.DP-1.resolution = "2560x1440@165Hz";
      seat."*".xcursor_theme = "phinger-cursors-dark 32";
      startup = [
        { command = "swww-daemon"; }
        { command = "autotiling"; }
        { command = "ags"; }
      ];
      terminal = "kitty";
    };
    extraConfig = ''
      # SwayFX configuration
      blur enable
      blur_radius 4
      blur_passes 3
      corner_radius 8
      default_dim_inactive 0.4
      default_border none
      layer_effects bar blur enable; blur_ignore_transparent enable
      layer_effects bar_extended blur enable; blur_ignore_transparent enable
      layer_effects bar_extended blur enable; blur_ignore_transparent enable
      layer_effects launcher blur enable; blur_ignore_transparent enable
    '';
  };
}
