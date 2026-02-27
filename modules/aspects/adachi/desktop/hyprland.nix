{ ... }:
{
  adachi.desktop._.hyprland = {
    nixos =
      { pkgs, ... }:
      {
        programs = {
          uwsm.enable = true;
          hyprland = {
            enable = true;
            withUWSM = true;
          };
        };
        xdg.portal = {
          enable = true;
          config.common.default = "gtk";
          extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
        };
      };

    homeManager =
      { home, pkgs, ... }:
      {
        home.packages = with pkgs; [ lxqt.lxqt-policykit ];
        wayland.windowManager.hyprland = {
          enable = true;
          settings = {
            env = [
              "XDG_CURRENT_DESKTOP,Hyprland"
              "XDG_SESSION_TYPE,wayland"
              "XDG_SESSION_DESKTOP,Hyprland"
            ];
            exec-once = [ "lxqt-policykit-agent" ];
          };
          systemd.enable = false;
        };
      };
  };
}
