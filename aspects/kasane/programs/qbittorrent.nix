{ lib, ... }:
{
  kasane.programs._.qbittorrent.homeManager =
    { config, pkgs, ... }:
    {
      home.packages = lib.singleton pkgs.qbittorrent;

      programs.umbriel.settings = {
        autostart = lib.singleton "qbittorrent";
        window_rule = [
          {
            match.app_id = "^qbittorrent$";
            default_workspace = 10;
          }
        ];
      };
    };
}
