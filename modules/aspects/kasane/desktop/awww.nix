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
          home.packages = [
            awww_jxl
            (self'.packages.wallpaperctl.override {
              awww = awww_jxl;
              refreshRate = getFastestRefreshRate host;
            })
          ];
          wayland.windowManager.hyprland = {
            settings = {
              exec-once = mkOrder 20 [ "awww-daemon" ];
              bind = [ "MOD3, w, submap, wallpaper" ];
            };
            submaps.wallpaper.settings = {
              bind = [
                ", H, exec, wallpaperctl previous"
                ", L, exec, wallpaperctl next"
              ];
              bindl = [
                ", escape, submap, reset"
                "MOD3, w, submap, reset"
              ];
            };
          };
        };
    };
}
