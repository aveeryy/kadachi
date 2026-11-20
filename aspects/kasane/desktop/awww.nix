{ kadachi-lib, lib, ... }:
let
  inherit (kadachi-lib)
    getAsset
    getFastestRefreshRate
    ;

  inherit (lib)
    mkOrder
    singleton
    ;
in
{
  kasane.desktop._.awww =
    { host, user }:
    {
      homeManager =
        {
          config,
          lib,
          pkgs,
          self',
          ...
        }:
        let
          awww_jxl = (
            pkgs.awww.overrideAttrs {
              patches = singleton (getAsset "patches/awww-disable-decode-limits.patch");

              cargoBuildFlags = [ "--features=jxl" ];
            }
          );
        in
        {
          home = {
            activation.ensureWallpaper = lib.hm.dag.entryAfter [ "writeBoundary" ] /* bash */ ''
              run mkdir -p "${config.xdg.userDirs.pictures}/Fondos"
              run ln -sf ${getAsset "blossoms.jxl"} "${config.xdg.userDirs.pictures}/Fondos/blossoms.jxl"
            '';
            packages = [
              awww_jxl
              (self'.packages.wallpaperctl.override {
                awww = awww_jxl;
                refreshRate = getFastestRefreshRate host;
              })
            ];
          };

          programs.umbriel.settings = {
            general.autostart = [
              "awww-daemon"
              "wallpaperctl ensure"
            ];
          };
        };
    };
}
