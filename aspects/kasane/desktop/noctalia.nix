{
  inputs,
  lib,
  ...
}:
let
  inherit (lib)
    optional
    singleton
    ;
in
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia/v5.0.1";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  kasane.desktop.noctalia =
    { host, user }:
    {

      homeManager = { config, osConfig, ... }: {
        imports = singleton inputs.noctalia.homeModules.default;

        programs.noctalia = {
          enable = true;
          settings = {
            audio = {
              enable_overdrive = true;
            };

            bar.default = {
              enabled = true;
              background_opacity = osConfig.stylix.opacity.terminal;
              position = "left";
              start = [
                "launcher"
                "workspaces"
              ];
              center = [ ];
              end = [
                "tray"
              ]
              ++ (optional osConfig.hardware.bluetooth.enable "bluetooth")
              ++ [
                "volume"
                "clock"
              ];
            };

            notification.layer = "overlay";

            osd = {
              enabled = true;
              background_opacity = osConfig.stylix.opacity.terminal;
              position = "bottom_center";

              kinds = {
                keyboard_backlight = false;
                keyboard_layout = false;
                lock_keys = false;
                media = false;
                privacy = false;
              };
            };

            shell = {
              avatar_path = "${config.home.homeDirectory}/.face";
              polkit_agent = true;
              popup_borders = false;
              popup_shadows = false;
              settings_window_translucent = true;

              launcher = {
                categories = false;
                show_app_origin_indicator = false;
              };

              panel = {
                borders = false;
                launcher_placement = "attached";
                open_near_click_control_center = true;
                open_near_click_launcher = true;
                shadow = false;
              };

              session = {
                grid = true;
                grid_columns = 2;

                actions = [
                  {
                    action = "shutdown";
                    countdown_seconds = 10.0;
                    enabled = true;
                    shortcut = "1";
                    variant = "destructive";
                  }
                  {
                    action = "reboot";
                    countdown_seconds = 10.0;
                    enabled = true;
                    shortcut = "2";
                    variant = "default";
                  }
                  {
                    action = "lock";
                    countdown_seconds = 0.0;
                    enabled = true;
                    shortcut = "3";
                    variant = "default";
                  }
                  {
                    action = "lock_and_suspend";
                    countdown_seconds = 3.0;
                    enabled = true;
                    shortcut = "4";
                    variant = "default";
                  }
                ];
              };

              shadow.alpha = 0.0;
            };

            wallpaper.enabled = false;

            widget = {
              clock = {
                font_family = osConfig.stylix.fonts.monospace.name;
                font_weight = 700;
                format = "{:%H:%M:%S}";
              };
              launcher = {
                icon_color = "primary";
                scale = 1.55;
              };
              tray.drawer = true;
              volume.show_label = false;
              workspaces = {
                empty_color = "tertiary";
                occupied_color = "tertiary";
                scroll_repeat = "steps";
                show_labels = false;
              };
            };
          };
        };

        wayland.windowManager.hyprland.settings =
          let
            ipc = "noctalia msg";
          in
          {
            bind = [
              "SUPER, Space, exec, ${ipc} panel-toggle launcher"
              # "SUPER, period, exec, ${ipc} launcher emoji"
              # "SUPER, comma, exec, ${ipc} plugin:kaomoji toggle"
              "CTRL ALT, Delete, exec, ${ipc} panel-toggle session"
            ];
            bindle = [
              ", XF86MonBrightnessUp, exec, ${ipc} brightness-up"
              ", XF86MonBrightnessDown, exec, ${ipc} brightness-down"
            ];
            exec-once = singleton "noctalia";
            layerrule = singleton {
              name = "noctalia";
              "match:namespace" = "noctalia-background-.*$";
              ignore_alpha = 0.5;
              blur = true;
              blur_popups = true;
            };
          };
      };
    };
}
