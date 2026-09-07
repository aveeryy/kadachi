{ ... }:
{
  kasane.desktop._.screenshot.homeManager =
    {
      config,
      lib,
      pkgs,
      self',
      ...
    }:
    {
      home = {
        activation.ensureScreenshotDirectory = lib.hm.dag.entryAfter [ "writeBoundary" ] /* bash */ ''
          run mkdir -p "${config.xdg.userDirs.pictures}/Capturas"
        '';
        packages = lib.singleton self'.packages.screenshot;
      };
      wayland.windowManager.hyprland.settings.bind = [
        ", Print, exec, screenshot full"
        "SHIFT, Print, exec, screenshot section"
        "SUPER, S, exec, screenshot full"
        "SUPER + SHIFT, S, exec, screenshot section"
      ];
    };
}
