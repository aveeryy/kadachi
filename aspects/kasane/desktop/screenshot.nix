{ ... }:
{
  kasane.desktop._.screenshot = {
    homeManager =
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
      };

    umbriel.settings.keybinds = {
      "Print" = {
        action = "spawn screenshot full";
        repeat = false;
      };
      "Shift+Print" = {
        action = "spawn screenshot section";
        repeat = false;
      };
      "Mod+S" = {
        action = "spawn screenshot full";
        repeat = false;
      };
      "Mod+Shift+S" = {
        action = "spawn screenshot section";
        repeat = false;
      };
    };
  };
}
