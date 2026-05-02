{ den, lib, ... }:
let
  inherit (lib)
    mkDefault
    mkOption
    ;
in
{
  den.schema.host =
    { host, ... }:
    {
      options.services.navidrome = with lib.types; {
        domain = mkOption {
          type = str;
          default = "music.${host.services.baseDomain}";
        };
      };
    };

  kasane.services._.navidrome = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { config, ... }:
        let
          cfg = config.services.navidrome;
        in
        {
          services = {
            navidrome = {
              enable = true;
              settings = {
                BaseUrl = "https://${host.services.navidrome.domain}";
                DefaultLanguage = "es";
                EnableInsightsCollector = false;
                "ListenBrainz.BaseURL" = "https://koito.rcia.dev/apis/listenbrainz/1";
                MusicFolder = mkDefault "/mnt/ssd-01/music";
                PlaylistFolder = mkDefault "/mnt/ssd-01/music/+Playlists";
                RecentlyAddedByModTime = true;
                "Scanner.Schedule" = "@every 1h";
              };
            };

            nginx.virtualHosts.${host.services.navidrome.domain} = {
              locations."/" = {
                proxyPass = "http://127.0.0.1:${toString cfg.settings.Port}";

              };
              forceSSL = true;
              useACMEHost = host.services.baseDomain;
            };
          };
        };
    }
  );
}
