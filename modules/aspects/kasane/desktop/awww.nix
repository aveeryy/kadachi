{ kadachi-lib, ... }:
{
  # TODO: rename to awww
  kasane.desktop._.awww =
    { host, user }:
    {
      homeManager =
        { pkgs, lib, ... }:
        {
          home.packages = with pkgs; [
            swww
            (wallpaperctl.override {
              refreshRate = kadachi-lib.getFastestRefreshRate host;
            })
          ];
          wayland.windowManager.hyprland = {
            settings = {
              exec-once = lib.mkOrder 20 [ "swww-daemon" ];
              bindl = [ "MOD3, w, submap, Fondo de pantalla" ];
            };
            extraConfig = ''
              submap = Fondo de pantalla

              bind = , H, exec, wallpaperctl previous
              bind = , L, exec, wallpaperctl next
              bindl = , escape, submap, reset
              bindl = MOD3, w, submap, reset

              submap = reset
            '';
          };
        };
    };
}
