{
  den,
  lib,
  kadachi-lib,
  ...
}:
let
  inherit (kadachi-lib) mkOpt;
in
{
  den.schema.host =
    { host, ... }:
    {
      options.services.vaultwarden = with lib.types; {
        domain = mkOpt str "vaultwarden.${host.services.baseHost}";
        database = mkOpt str host.services.defaultDatabase;
      };
    };

  kasane.services._.vaultwarden = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { config, ... }:
        let
          databaseConfig = {
            postgres = "postgresql";
          };
        in
        {
          services = {
            vaultwarden = {
              enable = true;
              dbBackend = databaseConfig.${host.services.vaultwarden.database};
              config = {
                domain = "https://${host.services.vaultwarden.domain}";
                rocketAddress = "127.0.0.1";
                rocketPort = 8222;
                showPasswordHint = false;
                signupsAllowed = false;
              };
              environmentFile = config.sops.templates."vaultwarden.env".path;
            };

            nginx.virtualHosts.${host.services.vaultwarden.domain} = {
              locations."/".proxyPass =
                "http://localhost:${toString config.services.vaultwarden.config.rocketPort}";
              forceSSL = true;
              useACMEHost = host.services.baseHost;
              extraConfig = host.services.nginx.localServiceConfig;
            };
          };

          sops = {
            secrets."vaultwarden/database_url" = { };
            templates."vaultwarden.env" = {
              content = ''
                DATABASE_URL=${config.sops.placeholder."vaultwarden/database_url"}
              '';
              owner = "vaultwarden";
            };
          };

        };
    }
  );
}
