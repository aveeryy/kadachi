{ ... }:
{
  kasane.tools._.pcmanfm-qt.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ pcmanfm-qt ];
      wayland.windowManager.niri.settings.binds."Mod+E" = {
        _props.repeat = false;
        spawn = "pcmanfm-qt";
      };
      wayland.windowManager.hyprland.settings.bind = [ "SUPER, E, exec, pcmanfm-qt" ];
    };
}
