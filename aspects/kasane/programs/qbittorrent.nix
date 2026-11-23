{ lib, ... }:
{
  kasane.programs._.qbittorrent = {
    homeManager = { config, pkgs, ... }: {
      home.packages = lib.singleton pkgs.qbittorrent;
    };

    umbriel.settings = {
      general.autostart = lib.singleton "qbittorrent";
      window_rule = [
        {
          match.app_id = "^org.qbittorrent.qBittorrent$";
          default_workspace = 10;
        }
      ];
    };
  };
}
