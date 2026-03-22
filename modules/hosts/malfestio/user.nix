{ __findFile, ... }:
{
  den.aspects."avery@malfestio" = {
    includes = [
      <kasane/base-user>

      <kasane/desktop/awww>
      <kasane/desktop/hyprland>
      <kasane/gaming/discord>
      <kasane/theme>
      <kasane/tools/compressed-file-tools>
      <kasane/tools/kitty>
      <kasane/tools/pcmanfm-qt>
      <kasane/web-browsers/firefox>
    ];

    homeManager =
      { lib, ... }:
      {
        wayland.windowManager.hyprland.settings = {
          exec-once = lib.mkOrder 10 [
            "[workspace 10 silent] steam"
          ];
          windowrule = [ "match:class steam, workspace 10 silent" ];
        };
      };
  };
}
