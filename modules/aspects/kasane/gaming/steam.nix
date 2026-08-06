{ ... }:
{
  kasane.gaming._.steam = {
    nixos = { pkgs, ... }: {
      programs.steam = {
        enable = true;
        package = pkgs.steam.override {
          extraEnv = {
            MANGOHUD = "1";
            MANGOHUD_CONFIG = "read_cfg,no_display";
          };
        };
        localNetworkGameTransfers.openFirewall = true;
        remotePlay.openFirewall = true;
        protontricks.enable = true;
      };
    };

    homeManager = {
      programs.mangohud.enable = true;
      services.ludusavi.settings.roots = [
        {
          path = "~/.local/share/Steam";
          store = "steam";
        }
      ];
    };
  };
}
