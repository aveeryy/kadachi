{ ... }:
{
  kasane.tools._.pcmanfm-qt.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ pcmanfm-qt ];
      wayland.windowManager.hyprland.settings.bind = [ "SUPER, E, exec, pcmanfm-qt" ];
    };
}
