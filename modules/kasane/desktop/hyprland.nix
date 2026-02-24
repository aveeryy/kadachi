{ __findFile, lib, ... }:
let
  rotations = [
    "0"
    "90"
    "180"
    "270"
    "0-flipped"
    "90-flipped"
    "180-flipped"
    "270-flipped"
  ];

  getDisplayRotation = rotation: toString (lib.lists.findFirstIndex (x: x == rotation) 0 rotations);

  displayToHyprlandConfig =
    display:
    "${display.name}, ${display.resolution}@${toString display.refreshRate}, ${display.position}, ${display.scaling}, transform, ${getDisplayRotation display.rotation}";

  displaysToHyprlandConfig =
    displays: map (display: displayToHyprlandConfig display) (lib.attrsets.attrValues displays);
in
{
  kasane.desktop._.hyprland =
    { host, user }:
    {
      homeManager =
        { pkgs, ... }:
        {
          wayland.windowManager.hyprland = {
            enable = true;
            settings = {
              monitor = displaysToHyprlandConfig host.desktop.displays;
              input = {
                # Keyboard
                kb_layout = "es";
                kb_variant = "dvorak";
                kb_options = "lv5:caps_switch";
                # Mouse
                sensitivity = -0.4;
                accel_profile = "flat";
              };

              general = {
                border_size = 0;
                gaps_in = 4;
                gaps_out = 8;
              };

              decoration = {
                rounding = 12;
                dim_inactive = true;
                dim_strength = 0.4;
                blur = {
                  enabled = true;
                  size = 8;
                  passes = 2;
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
              ];

              bindm = [
                "SUPER, mouse:272, movewindow"
                "SUPER, mouse:273, resizewindow"
              ];

              bindl = [
                ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
                "SHIFT, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
              ];

              bindle = [
                ", XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"
                ", XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
                "SHIFT, XF86AudioRaiseVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0; wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 5%+"
                "SHIFT, XF86AudioLowerVolume, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0; wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-"
              ];

              misc = {
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
                vrr = 2;
              };
              ecosystem = {
                no_update_news = true;
                no_donation_nag = true;
              };
            };
          };
        };
    };
}
