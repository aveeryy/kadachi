{ inputs, ... }:
{
  flake-file.inputs.caelestia-shell = {
    # Temporary fix for steam deck
    url = "github:caelestia-dots/shell/1b4b90a3ad9532f7002ef2593d8efb68443f21f3";
    # url = "github:caelestia-dots/shell";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  kasane.desktop._.caelestia-shell =
    { host, user }:
    {
      homeManager =
        { config, lib, ... }:
        {
          imports = [ inputs.caelestia-shell.homeManagerModules.default ];
          programs.caelestia = {
            enable = true;
            systemd = {
              enable = true;
              target = "graphical-session.target";
            };
            cli = {
              enable = true;
              settings = {
                theme = {
                  enableTerm = false;
                  enableHypr = false;
                  enableDiscord = false;
                  enableSpicetify = false;
                  enableFuzzel = false;
                  enableBtop = false;
                  enableGtk = false;
                  enableQt = false;
                };
              };
            };
            settings = {
              background.enabled = false;
              bar = {
                clock.showIcon = false;
                entries = [
                  {
                    id = "logo";
                    enabled = true;
                  }
                  {
                    id = "workspaces";
                    enabled = true;
                  }
                  {
                    id = "spacer";
                    enabled = true;
                  }
                  {
                    id = "tray";
                    enabled = true;
                  }
                  {
                    id = "statusIcons";
                    enabled = true;
                  }
                  {
                    id = "clock";
                    enabled = true;
                  }
                  {
                    id = "power";
                    enabled = true;
                  }
                ];
                scrollActions = {
                  brightness = false;
                  volume = false;
                  workspaces = false;
                };
                status = {
                  showAudio = true;
                  showMicrophone = true;
                  showNetwork = host.desktop.system.hasWiFi;
                  showBluetooth = host.desktop.system.hasBluetooth;
                  showBattery = host.desktop.system.hasBattery;
                };
                tray = {
                  background = true;
                  compact = true;
                };
                workspaces = {
                  activeLabel = "  ";
                  occupiedLabel = "  ";
                  showWindows = false;
                  shown = 10;
                };
              };
              border = {
                rounding = 12;
                thickness = 8;
              };
              general = {
                idle = {
                  timeouts =
                    lib.optionals (config.programs.hyprlock.enable) [
                      {
                        timeout = 300;
                        idleAction = [
                          "hyprlock"
                          "--grace"
                          "10"
                        ];
                      }
                    ]
                    ++ [
                      {
                        timeout = 360;
                        idleAction = "dpms off";
                        returnAction = "dpms on";
                      }
                    ];
                };
              };
              osd.enableMicrophone = true;
              services = {
                audioIncrement = 0.05;
                brightnessIncrement = 0.05;
                maxVolume = 1.5;
                smartScheme = false;
                useFahrenheit = false;
                useTwelveHourClock = false;
                weatherLocation = "Salamanca";
              };
              sidebar.dragThreshold = 50;
            };
          };
          wayland.windowManager.hyprland.settings = {
            bind = [
              "SUPER, Space, global, caelestia:launcher"
              "MOD3, D, global, caelestia:dashboard"
              "MOD3, S, exec, caelestia shell drawers toggle sidebar"
              "CTRL ALT, Delete, global, caelestia:session"
            ];

            bindle = [
              ", XF86MonBrightnessUp, exec, caelestia shell brightness set +5%"
              ", XF86MonBrightnessDown, exec, caelestia shell brightness set 5%-"
            ];
          };
        };
    };
}
