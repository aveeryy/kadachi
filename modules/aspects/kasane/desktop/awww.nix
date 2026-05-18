{ kadachi-lib, ... }:
{
  kasane.desktop._.awww =
    { host, user }:
    {
      homeManager =
        { pkgs, lib, ... }:
        {
          home.packages = with pkgs; [
            awww
            (wallpaperctl.override {
              refreshRate = kadachi-lib.getFastestRefreshRate host;
            })
          ];
          wayland.windowManager.hyprland = {
            settings = {
              exec-once = lib.mkOrder 20 [ "awww-daemon" ];
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
