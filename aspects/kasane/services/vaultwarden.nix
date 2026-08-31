{ kadachi-lib, lib, ... }:
let
  inherit (lib)
    mkOption
    ;

  inherit (lib.types)
    str
    ;

  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  den.schema.host = mkHttpServiceOptions {
    name = "vaultwarden";
    options = { host, ... }: {
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
                domain = "https://${host.services.vaultwarden.domains.internet}";
                rocketAddress = "127.0.0.1";
                rocketPort = 8222;
                showPasswordHint = false;
                signupsAllowed = false;
              };
              environmentFile = config.sops.templates."vaultwarden.env".path;
            };

            nginx = mkNginxConfiguration host host.services.vaultwarden {
              locations."/".proxyPass = "http://localhost:${toString cfg.config.rocketPort}";
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
