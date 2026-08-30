{ lib, ... }:
let
  inherit (lib) mkOption;
in
{
  den.schema.host =
    { host, ... }:
    {
      options.services.vaultwarden = with lib.types; {
        domain = mkOption {
          type = str;
          default = "vaultwarden.${host.services.baseDomain}";
        };
        database = mkOption {
          type = str;
          default = host.services.database.default;
        };
      };
    };

  kasane.services._.vaultwarden =
    { host }:
    {
      nixos =
        { config, ... }:
        let
          cfg = config.services.vaultwarden;

          databaseConfig = {
            postgres = "postgresql";
          };

          databaseSocketHost = {
            postgres = "/run/postgresql";
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
              locations."/".proxyPass = "http://localhost:${toString cfg.config.rocketPort}";
              forceSSL = true;
              useACMEHost = host.services.baseDomain;
              extraConfig = host.services.nginx.localServiceConfig;
            };

            postgresql = {
              ensureDatabases = lib.optional (cfg.dbBackend == "postgresql") "vaultwarden";
              ensureUsers = lib.optional (cfg.dbBackend == "postgresql") {
                name = "vaultwarden";
                ensureDBOwnership = true;
              };
            };
          };

          sops = {
            secrets."vaultwarden/database_url" = { };
            templates."vaultwarden.env" = {
              content = ''
                DATABASE_URL=${config.sops.placeholder."vaultwarden/database_url"}?host=${
                  databaseSocketHost.${host.services.vaultwarden.database}
                }
              '';
              owner = "vaultwarden";
            };

          };
        };
    };
}
