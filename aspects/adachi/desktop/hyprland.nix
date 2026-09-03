{ ... }:
{
  adachi.desktop._.hyprland = {
    nixos =
      { inputs', pkgs, ... }:
      {
        programs = {
          uwsm.enable = true;
          hyprland = {
            enable = true;
            package = inputs'.nixpkgs-master.legacyPackages.hyprland;
            withUWSM = true;
          };
        };
        xdg.portal = {
          enable = true;
          config.common.default = "gtk";
          extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        };
      };

    homeManager = {
      wayland.windowManager.hyprland = {
        enable = true;
        settings = {
          env = [
            "XDG_CURRENT_DESKTOP,Hyprland"
            "XDG_SESSION_TYPE,wayland"
            "XDG_SESSION_DESKTOP,Hyprland"
          ];
        };
        systemd.enable = false;
      };
    };
  };
}
