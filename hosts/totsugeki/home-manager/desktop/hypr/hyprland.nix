{ ... }: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = "DP-1, 2560x1440@165, 0x0, 1";
      input = {
        # Keyboard
        kb_layout = "es";
        kb_variant = "dvorak";
        kb_options = "lv5:caps_switch";
        # Mouse
        sensitivity = -0.4;
        accel_profile = "flat";
      };

      exec-once = [
        "hyprlock"
        "ags"
        "swww-daemon"
        "lxqt-policykit-agent"
        "[workspace 10 silent] qbittorrent"
      ];

      env = [
        "XDG_CURRENT_DESKTOP,Hyprland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_SESSION_DESKTOP,Hyprland"
      ];

      general = {
        border_size = 0;
        gaps_in = 4;
        gaps_out = 4;
      };

      decoration = {
        rounding = 8;
        dim_inactive = true;
        dim_strength = 0.4;
        blur = {
          enabled = true;
          size = 4;
          passes = 3;
        };
        shadow.enabled = false;
      };

      animations = {
        animation = [
          "windows, 1, 4, wind, slide"
          "windowsIn, 1, 4, winIn, slide"
          "windowsOut, 1, 3, winOut, slide"
          "windowsMove, 1, 3, wind, slide"
          "workspaces, 1, 2, default, slidevert"
        ];
        bezier = [
          "wind, 0.05, 0.92, 0.1, 1"
          "winIn, 0.1, 1.1, 0.1, 1"
          "winOut, 0.3, -0.3, 0, 1"
        ];
      };

      dwindle = {
        pseudotile = true;
        force_split = 2;
        use_active_for_splits = true;
        preserve_split = true;
      };

      bind = [
        "SUPER SHIFT CTRL ALT, Q, exit,"
        # Window management
        "SUPER, W, killactive"
        "SUPER, F, togglefloating, "
        "SUPER, C, centerwindow"
        "SUPER, F11, fullscreen, 0"
        # Spawns
        "CTRL ALT, T, exec, kitty"
        "SUPER, Space, exec, ags -t launcher"
        "SUPER, C, exec, ags -t bar_extended"
        "SUPER, E, exec, pcmanfm-qt"
        # Session locking
        ", code:191, exec, hyprlock"
        "MOD3, L, exec, hyprlock"
        # Window navigation
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        # Workspace navigation
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
        # Send window to workspace
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
        # Screenshots
        ", Print, exec, screenshot full"
        "SHIFT, Print, exec, screenshot section"
        "SUPER, S, exec, screenshot full"
        "SUPER + SHIFT, S, exec, screenshot section"
      ];

      bindl = [
        # Submaps
        "MOD3, m, submap, Música"
        "MOD3, w, submap, Fondo de pantalla"
        # Volume mute
        ", XF86AudioMute, exec, volumectl output toggle-mute"
        "SHIFT, XF86AudioMute, exec, volumectl input toggle-mute"
      ];

      bindle = [
        # Volume control
        ", XF86AudioRaiseVolume, exec, volumectl output +5"
        ", XF86AudioLowerVolume, exec, volumectl output -5"
        "SHIFT, XF86AudioRaiseVolume, exec, volumectl input +5"
        "SHIFT, XF86AudioLowerVolume, exec, volumectl input -5"
      ];

      bindm =
        [ "SUPER, mouse:272, movewindow" "SUPER, mouse:273, resizewindow" ];

      layerrule = [
        "blur, bar"
        "ignorezero, bar"
        "blur, launcher"
        "ignorezero, launcher"
        "blur, extended_bar"
        "ignorezero, extended_bar"
      ];

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vrr = 2;
      };
    };
    extraConfig = ''
      submap = Fondo de pantalla

      bind = , H, exec, change-wallpaper previous
      bind = , L, exec, change-wallpaper next
      bindl = , escape, submap, reset
      bindl = MOD3, w, submap, reset

      submap = reset

      submap = Música

      bindl = , p, exec, playerctl play-pause
      bindl = , h, exec, playerctl previous
      bindl = , l, exec, playerctl next
      bindl = , escape, submap, reset
      bindl = MOD3, m, submap, reset

      submap = reset
    '';

  };
}
