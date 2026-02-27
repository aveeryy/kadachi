{ ... }:
{
  kasane.desktop._.screenshot.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ screenshot ];
      wayland.windowManager.hyprland.settings.bind = [
        ", Print, exec, screenshot full"
        "SHIFT, Print, exec, screenshot section"
        "SUPER, S, exec, screenshot full"
        "SUPER + SHIFT, S, exec, screenshot section"
      ];
    };
}
