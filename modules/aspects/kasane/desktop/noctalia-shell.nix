{ inputs, kadachi-lib, ... }:
{
  flake-file.inputs.noctalia-shell = {
    url = "github:noctalia-dev/noctalia-shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  kasane.desktop._.noctalia-shell =
    { host, user }:
    {

      homeManager = {
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
              spectrumFramerate = kadachi-lib.getFastestRefreshRate host;
              volumeOverdrive = true;
              volumeStep = 5;
            };
            bar = {
              barType = "floating";
              contentPadding = 8;
              density = "default";
              floating = true;
              fontScale = 1.1;
              position = "left";
              showCapsule = false;
              widgets = {
                left = [
                  {
                    id = "Launcher";
                    colorizeSystemIcon = "primary";
                    enableColorization = true;
                    useDistroLogo = true;
                  }
                  {
                    id = "Workspace";
                    hideUnoccupied = false;
                    occupiedColor = "tertiary";
                    emptyColor = "tertiary";
                  }
                ];
                center = [ ];
                right = [
                  {
                    id = "Tray";
                    drawerEnabled = true;
                  }
                  {
                    id = "Microphone";
                    displayMode = "onhover";
                  }
                  {
                    id = "Volume";
                    displayMode = "onhover";
                  }
                  {
                    id = "Clock";
                    formatHorizontal = "HH:mm:ss";
                    formatVertical = "HH mm ss";
                    useMonospacedFont = true;
                    usePrimaryColor = true;
                  }
                ];
              };
            };
            brightness = {
              brightnessStep = 5;
              enableDdcSupport = true;
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
            dock.enabled = false;
            general = {
              dimmerOpacity = 0.75;
              enableShadows = false;
              radiusRatio = 0.65;
              iRadiusRatio = 0.65;
              telemetryEnabled = false;
            };
            location.weatherEnabled = false;
            osd = {
              enabled = true;
              location = "bottom_center";
              autoHideMs = "1000";
            };
            sessionMenu = {
              largeButtonsStyle = false;
              powerOptions = [
                {
                  action = "shutdown";
                  enabled = true;
                  keybind = "1";
                }
                {
                  action = "reboot";
                  enabled = true;
                  keybind = "2";
                }
                {
                  action = "rebootToUefi";
                  enabled = true;
                  keybind = "3";
                }
                # TODO: enable based on system capability
                {
                  action = "suspend";
                  enabled = false;
                  keybind = "4";
                }
                {
                  action = "hibernate";
                  enabled = false;
                  keybind = "5";
                }
              ];
            };
            ui = {
              scrollbarAlwaysVisible = false;
              translucentWidgets = true;
            };
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
    };
}
