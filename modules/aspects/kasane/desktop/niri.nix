{ lib, ... }: {
  kasane.desktop._.niri =
    { host, user }:
    let
      inherit (builtins)
        attrValues
        elemAt
        fromJSON
        ;

      inherit (lib)
        optionalAttrs
        range
        singleton
        splitString
        toIntBase10
        ;

      getPositionConfig =
        position:
        let
          split = splitString "x" position;
        in
        {
          x = toIntBase10 (elemAt split 0);
          y = toIntBase10 (elemAt split 1);
        };

      getVrrConfig =
        vrr:
        optionalAttrs (vrr != "disabled") {

          networking.useDHCP = lib.mkDefault false;
          focus-at-startup._props = optionalAttrs (vrr == "on-demand") {
            on-demand = true;
          };
        };

      displayToNiriConfig =
        display: with display; {
          output = {
            _args = singleton name;
            mode = "${resolution}@${toString refreshRate}";
            position._props = getPositionConfig position;
            scale = fromJSON scaling;
            transform = if rotation == "0" then "normal" else rotation;
          }
          // (optionalAttrs primary { focus-at-startup = { }; })
          // (getVrrConfig vrr);
        };

    in
    {
      nixos = {
        environment.pathsToLink = [
          "/share/applications"
          "/share/xdg-desktop-portal"
        ];
      };

      homeManager = {
        wayland.windowManager.niri = {
          enable = true;
          settings = {
            input = {
              keyboard.xkb = {
                layout = "es";
                variant = "dvorak";
                options = "lv5:caps_switch";
              };
              mouse = {
                accel-speed = -0.4;
                accel-profile = "flat";
              };
              focus-follows-mouse = {
                _props.max-scroll-amount = "0%";
              };
            };

            binds = {
              # Window management and navigation
              "Mod+W" = {
                _props.repeat = false;
                close-window = { };
              };
              "Mod+K".focus-workspace-up = { };
              "Mod+J".focus-workspace-down = { };
              "Mod+H".focus-column-left = { };
              "Mod+L".focus-column-right = { };
              # Workspace management and navigation
              "Mod+1".focus-workspace = 1;
              "Mod+2".focus-workspace = 2;
              "Mod+3".focus-workspace = 3;
              "Mod+4".focus-workspace = 4;
              "Mod+5".focus-workspace = 5;
              "Mod+6".focus-workspace = 6;
              "Mod+7".focus-workspace = 7;
              "Mod+8".focus-workspace = 8;
              "Mod+9".focus-workspace = 9;
              "Mod+0".focus-workspace = 10;
              # Audio output volume
              "XF86AudioRaiseVolume" = {
                _props.allow-when-locked = true;
                spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
              };
              "XF86AudioLowerVolume" = {
                _props.allow-when-locked = true;
                spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              };
              "XF86AudioMute" = {
                _props = {
                  allow-when-locked = true;
                  repeat = false;
                };
                spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              };
              # Audio input volume
              "Shift+XF86AudioRaiseVolume" = {
                _props.allow-when-locked = true;
                spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0; wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 5%+";
              };
              "Shift+XF86AudioLowerVolume" = {
                _props.allow-when-locked = true;
                spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0; wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
              };
              "Shift+XF86AudioMute" = {
                _props = {
                  allow-when-locked = true;
                  repeat = false;
                };
                spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              };
            };

            layout.focus-ring.off = { };

            hotkey-overlay.skip-at-startup = { };

            prefer-no-csd = { };

            _children =
              (map (x: { workspace = toString x; }) (range 1 10))
              ++ (map displayToNiriConfig (attrValues host.desktop.displays));
          };
        };
      };
    };
}
