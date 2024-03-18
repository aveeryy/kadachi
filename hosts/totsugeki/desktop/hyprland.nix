{ config, pkgs, ... }: {
  home.packages = with pkgs; [ hyprpicker hyprlock ];
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = "DP-1, 2560x1440@165, 0x0, 1";

      env = [ "XCURSOR_SIZE, 32" "QT_QPA_PLATFORMTHEME, qt5ct" ];

      exec-once = [
        "hyprlock"
        "waybar"
        "swww init; swww img ~/.local/share/wallpapers/.current_image"
        "[workspace 1 silent] firefox"
        "[workspace 10 silent] qbittorrent"
      ];

      general = {
        border_size = 0;
        gaps_in = 2;
        gaps_out = 2;
      };

      decoration = {
        rounding = 0;
        dim_inactive = true;
        dim_strength = 0.3;
        drop_shadow = false;
        blur = {
          enabled = true;
          size = 3;
          passes = 3;
          noise = 5.0e-2;
          vibrancy = 0.25;
          vibrancy_darkness = 0.3;
        };
      };

      dwindle = {
        pseudotile = true;
        force_split = 2;
        use_active_for_splits = true;
        preserve_split = true;
      };

      bind = [
        "SUPER SHIFT CTRL ALT, Q, exit,"

        "SUPER, W, killactive"
        "SUPER, F, togglefloating, "
        "SUPER, C, centerwindow"
        "SUPER, F11, fullscreen, 0"

        "CTRL ALT, T, exec, kitty"
        "SUPER, Space, exec, rofi -show drun"
        "SUPER, E, exec, zsh -c dolphin"

        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"

        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        "SUPER, S, exec, screenshot.sh full"
        "SUPER + SHIFT, S, exec, screenshot.sh section"

        "MOD3, C, exec, colorpicker"

        "MOD3, S, exec, hyprlock"
        "MOD3, 1, exec, play_to_soundboard.sh $HOME/soundboard/fireball.webm"
        "MOD3, 2, exec, play_to_soundboard.sh $HOME/soundboard/turret.webm"
        "MOD3, 3, exec, play_to_soundboard.sh $HOME/soundboard/elhormiguero.webm --volume=70"
        "MOD3, 4, exec, play_to_soundboard.sh $HOME/soundboard/america.webm --volume=70"
        "MOD3 SHIFT, P, exec, pkill mpv"
      ];

      bindl = [
        "MOD3, m, submap, Música"
        "MOD3, w, submap, Fondo de pantalla"
        ", XF86AudioMute, exec, volumectl.sh output toggle-mute"
        "SHIFT, XF86AudioMute, exec, volumectl.sh input toggle-mute"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, volumectl.sh output +5"
        ", XF86AudioLowerVolume, exec, volumectl.sh output -5"
        "SHIFT, XF86AudioRaiseVolume, exec, volumectl.sh input +5"
        "SHIFT, XF86AudioLowerVolume, exec, volumectl.sh input -5"
      ];

      bindm =
        [ "SUPER, mouse:272, movewindow" "SUPER, mouse:273, resizewindow" ];

      animations = {
        enabled = true;
        animation = [
          "windows, 1, 6, wind, slide"
          "windowsIn, 1, 6, winIn, slide"
          "windowsOut, 1, 5, winOut, slide"
          "windowsMove, 1, 5, wind, slide"
          "border, 1, 1, liner"
          "borderangle, 1, 50, liner, loop"
          "fade, 1, 8, default"
          "workspaces, 1, 5, wind"
        ];
        bezier = [
          "wind, 0.05, 0.92, 0.1, 1"
          "winIn, 0.1, 1.1, 0.1, 1"
          "winOut, 0.3, -0.3, 0, 1"
          "liner, 1, 1, 1, 1"
        ];
      };

      windowrulev2 = [
        "tile, class:^(ichi Client)$"
        "opacity 0.999 0.999, class: ^(org.kde.dolphin)$"
        "nofocus, title:^()$,class:^(steam)$"
        "minsize 1 1, title:^()$,class:^(steam)$"
      ];

      layerrule = [ "blur, waybar" "blur, rofi" "ignorezero, rofi" ];

      input = {
        kb_layout = "es";
        kb_variant = "dvorak";
        kb_options = "lv5:caps_switch";
        follow_mouse = 1;
        sensitivity = -1;
      };

      misc = {
        animate_manual_resizes = true;
        animate_mouse_windowdragging = true;
        key_press_enables_dpms = true;
      };
    };
    extraConfig = ''
      submap = Fondo de pantalla

      bind = , H, exec, change_wallpaper.sh previous
      bind = , L, exec, change_wallpaper.sh next
      bind = , M, exec, change_wallpaper.sh open-menu
      bindl = , escape, submap, reset
      bindl = MOD3, w, submap, reset

      submap = reset

      submap = Música

      bindl = , h, exec, playerctl previous
      bindl = , l, exec, playerctl next
      bindl = , p, exec, playerctl play-pause
      bindl = , escape, submap, reset
      bindl = MOD3, m, submap, reset

      submap = reset
    '';
  };
}
