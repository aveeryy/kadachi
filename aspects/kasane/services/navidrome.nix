{ kadachi-lib, ... }:
let
  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  den.schema.host = mkHttpServiceOptions {
    name = "navidrome";
    subdomain = "music";
  };

  kasane.services._.navidrome =
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
                BaseUrl = "https://${host.services.navidrome.domains.internet}";
                DefaultLanguage = "es";
                EnableInsightsCollector = false;
                "ListenBrainz.BaseURL" = "https://koito.rcia.dev/apis/listenbrainz/1";
                RecentlyAddedByModTime = true;
                "Scanner.Schedule" = "@every 1h";
              };
            };

            nginx = mkNginxConfiguration host host.services.navidrome {
              locations."/".proxyPass = "http://127.0.0.1:${toString cfg.settings.Port}";
            };
          };
        };
    };
}
