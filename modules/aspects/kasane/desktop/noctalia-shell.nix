{ inputs, ... }:
{
  flake-file.inputs.noctalia-shell = {
    url = "github:noctalia-dev/noctalia-shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  kasane.desktop._.noctalia-shell.homeManager = {
    imports = [
      inputs.noctalia-shell.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = {
        appLauncher = {
          density = "compact";
          enableClipboardHistory = false;
          enableSessionSearch = false;
          enableSettingsSearch = false;
          enableWindowsSearch = false;
          iconMode = "native";
          position = "follow_bar";
          showCategories = false;
        };
        audio = {
          volumeOverdrive = true;
          volumeStep = 5;
        };
        bar = {
          density = "compact";
          position = "left";
          showCapsule = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                colorizeSystemIcon = "primary";
                enableColorization = true;
                useDistroLogo = true;
              }
              {
                id = "Workspace";
                hideUnoccupied = false;
                occupiedColor = "tertiary";
              }
            ];
            center = [ ];
            right = [
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
            ];
          };
        };
        brightness = {
          brightnessStep = 5;
          enableDcdSupport = true;
        };
        controlCenter = {
          cards = [
            {
              enabled = true;
              id = "profile-card";
            }
            {
              enabled = false;
              id = "shortcuts-card";
            }
            {
              enabled = true;
              id = "audio-card";
            }
            {
              enabled = true;
              id = "brightness-card";
            }
            {
              enabled = false;
              id = "weather-card";
            }
            {
              enabled = true;
              id = "media-sysmon-card";
            }
          ];
        };
        colorSchemes.predefinedScheme = "Catppuccin";
        dock.enabled = false;
        general = {
          enableShadows = false;
          iRadiusRatio = 0.7;
          telemetryEnabled = false;
        };
        location.weatherEnabled = false;
        wallpaper.enabled = false;
      };
    };

    wayland.windowManager.hyprland.settings =
      let
        ipc = "noctalia-shell ipc call";
      in
      {
        bind = [
          "SUPER, Space, exec, ${ipc} launcher toggle"
          "SUPER, period, exec, ${ipc} launcher emoji"
          "CTRL ALT, Delete, exec, ${ipc} sessionMenu toggle"

        ];
        bindle = [
          ", XF86MonBrightnessUp, exec, ${ipc} brightness increase"
          ", XF86MonBrightnessDown, exec, ${ipc} brightness decrease"
        ];
        exec-once = [ "noctalia-shell" ];
        layerrule = [
          {
            name = "noctalia";
            "match:namespace" = "noctalia-background-.*$";
            ignore_alpha = 0.5;
            blur = true;
            blur_popups = true;
          }
        ];
      };
  };
}
