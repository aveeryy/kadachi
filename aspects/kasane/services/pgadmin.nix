{ kadachi-lib, ... }:
let
  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  den.schema.host = mkHttpServiceOptions {
    name = "pgadmin";
  };

  kasane.services._.pgadmin = { host }: {
    nixos = { config, ... }: {
      services = {
        pgadmin = {
          enable = true;
          initialEmail = "admin@${host.services.internetDomain}";
          initialPasswordFile = config.sops.secrets."pgadmin/initial_password".path;
          port = 5050;
        };
        nginx = mkNginxConfiguration host host.services.pgadmin {
          locations."/".proxyPass = "http://localhost:${toString config.services.pgadmin.port}";
        };
      };
      sops.secrets."pgadmin/initial_password".owner = "pgadmin";
    };
  };
}
