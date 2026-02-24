{ __findFile, ... }:
{
  den.aspects.avery_malfestio = {

    includes = [
      <kasane/base-user>

      <kasane/desktop/awww>
      <kasane/desktop/caelestia-shell>
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
        # Avoid launching caelestia on Steam gamescope session
        programs.caelestia.systemd.target = lib.mkForce "wayland-session@hyprland.desktop.target";
        wayland.windowManager.hyprland.settings = {
          exec-once = lib.mkOrder 10 [
            "[workspace 10 silent] steam"
          ];
          windowrule = [ "match:class steam, workspace 10 silent" ];
        };
      };
  };
}
