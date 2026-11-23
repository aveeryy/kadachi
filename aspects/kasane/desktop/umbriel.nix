{
  inputs,
  lib,
  den,
  ...
}:
let
  inherit (lib)
    last
    mapAttrs'
    nameValuePair
    singleton
    ;

  displaysToOutputs =
    displays:
    mapAttrs' (
      id: display:
      nameValuePair (display.name) ({
        mode = "${display.resolution}@${toString display.refreshRate}";
        scale = builtins.fromJSON display.scaling;
        focus_at_startup = display.primary;
        workspaces = 10;
      })
    ) displays;

  umbrielClass =
    { class, aspect-chain }:
    den._.forward {
      each = singleton class;
      fromClass = _: "umbriel";
      intoClass = _: "homeManager";
      intoPath = _: [
        "programs"
        "umbriel"
      ];
      fromAspect = _: last aspect-chain;
      guard = { options, ... }: options ? programs.umbriel;
    };
in
{
  flake-file.inputs.umbriel.url = "github:noctalia-dev/umbriel";

  den.default.includes = singleton umbrielClass;

  kasane.desktop._.umbriel = { host, ... }: {
    nixos = {
      imports = singleton inputs.umbriel.nixosModules.default;

      programs.umbriel.enable = true;
    };

    homeManager = {
      imports = singleton inputs.umbriel.homeModules.default;

      programs.umbriel = {
        enable = true;
        settings = {
          input = {
            focus.follows_mouse = "always";
            keyboard = {
              layout = "es";
              variant = "dvorak";
              options = "lv5:caps_switch";
            };

            mouse.sensitivity = -0.8;
          };

          general.show_cheatsheet = false;

          keybinds = {
            # Window management
            "Mod+W" = "window-close";
            "Mod+K" = "window-focus-up";
            "Mod+J" = "window-focus-down";
            "Mod+H" = "window-focus-left";
            "Mod+L" = "window-focus-right";
            # Switch workspaces
            "Mod+1" = "workspace-switch 1";
            "Mod+2" = "workspace-switch 2";
            "Mod+3" = "workspace-switch 3";
            "Mod+4" = "workspace-switch 4";
            "Mod+5" = "workspace-switch 5";
            "Mod+6" = "workspace-switch 6";
            "Mod+7" = "workspace-switch 7";
            "Mod+8" = "workspace-switch 8";
            "Mod+9" = "workspace-switch 9";
            "Mod+0" = "workspace-switch 10";
            # Move window to workspace
            "Mod+Shift+1" = "window-move-to-workspace 1";
            "Mod+Shift+2" = "window-move-to-workspace 2";
            "Mod+Shift+3" = "window-move-to-workspace 3";
            "Mod+Shift+4" = "window-move-to-workspace 4";
            "Mod+Shift+5" = "window-move-to-workspace 5";
            "Mod+Shift+6" = "window-move-to-workspace 6";
            "Mod+Shift+7" = "window-move-to-workspace 7";
            "Mod+Shift+8" = "window-move-to-workspace 8";
            "Mod+Shift+9" = "window-move-to-workspace 9";
            "Mod+Shift+0" = "window-move-to-workspace 10";
            # Audio
            "XF86AudioLowerVolume" = {
              action = "spawn wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
              allow_when_locked = true;
            };
            "Shift+XF86AudioLowerVolume" = {
              action = "spawn wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0; wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
              allow_when_locked = true;
            };
            "XF86AudioRaiseVolume" = {
              action = "spawn wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+";
              allow_when_locked = true;
            };
            "Shift+XF86AudioRaiseVolume" = {
              action = "spawn wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0; wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SOURCE@ 5%+";
              allow_when_locked = true;
            };
            "XF86AudioMute" = {
              action = "spawn wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              allow_when_locked = true;
              repeat = false;
            };
            "Shift+XF86AudioMute" = {
              action = "spawn wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              allow_when_locked = true;
              repeat = false;
            };
          };

          layout = {

            mode = "dwindle";
          };

          output = displaysToOutputs host.desktop.displays;
        };
      };
    };
  };
}
