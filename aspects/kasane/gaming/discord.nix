{ lib, ... }:
{
  kasane.gaming._.discord = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [ (discord.override { withVencord = true; }) ];
      };

    umbriel.settings = {
      general.autostart = lib.singleton "discord";
      window_rule = [
        {
          match.app_id = "^discord$";
          default_workspace = 3;
        }
      ];
    };
  };
}
