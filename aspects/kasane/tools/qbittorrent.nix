{ lib, ... }:
{
  kasane.tools._.qbittorrent.homeManager =
    { config, pkgs, ... }:
    {
      home.packages = with pkgs; [ qbittorrent ];
      wayland.windowManager.hyprland.settings.exec-once = lib.mkAfter [
        (
          if config.programs.mullvad-vpn.enable then
            "[workspace 10 silent] sleep 20s && mullvad-exclude qbittorrent"
          else
            "[workspace 10 silent] qbittorrent"
        )
      ];

    };
}
