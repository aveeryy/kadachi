{ lib, ... }:
{
  kasane.gaming._.discord.homeManager =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ (discord.override { withVencord = true; }) ];
      wayland.windowManager.hyprland.settings = {
        exec-once = lib.mkAfter [ "[workspace 3 silent] discord" ];
        windowrule = [ "match:class discord, workspace 3 silent" ];
      };
    };
}
