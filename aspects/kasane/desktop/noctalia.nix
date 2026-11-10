{ lib, ... }:
let
  inherit (lib)
    filterAttrs
    optional
    singleton
    ;
in
{
  kasane.desktop.noctalia =
    { host, user }:
    let
      hasWirelessInterface =
        (filterAttrs (_: network: network.type == "wireless") host.networking.interfaces) != { };
    in
    {
      nixos = {
        programs.noctalia.enable = true;
      };

      homeManager = { config, osConfig, ... }: {
        programs.noctalia = {
          enable = true;
          settings = {
            audio = {
              enable_overdrive = true;
              enable_sounds = false;
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
              end =
                singleton "tray"
                ++ (optional hasWirelessInterface "network")
                ++ (optional osConfig.hardware.bluetooth.enable "bluetooth")
                ++ [
                  "volume"
                  "clock"
                ];
            };

            brightness.enable_ddcutil = true;

            control_center = {
              hidden_tabs =
                singleton "weather"
                ++ (optional (!hasWirelessInterface) "network")
                ++ (optional (!osConfig.hardware.bluetooth.enable) "bluetooth");

              shortcuts = [ ];

              calendar.show_events_card = false;
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
              card_borders = false;
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
                transparency_mode = "glass";
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
              bluetooth.scale = 1.15;
              clock = {
                font_family = osConfig.stylix.fonts.monospace.name;
                font_scale = 1.05;
                font_weight = 700;
                format = "{:%H:%M:%S}";
              };
              launcher = {
                icon_color = "primary";
                scale = 1.55;
              };
              network = {
                scale = 1.1;
                show_label = false;
              };
              tray.drawer = true;
              volume.show_label = false;
              workspaces = {
                empty_color = "tertiary";
                occupied_color = "tertiary";
                scroll_repeat = "steps";
                show_labels = false;
              };
              tray.scale = 1.05;
              volume.scale = 1.05;
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
              "SUPER, period, exec, ${ipc} panel-toggle launcher /emo "
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
