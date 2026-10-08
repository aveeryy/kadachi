{ kadachi-lib, ... }:
let
  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  flake-file.inputs.nixpkgs-pgadmin-fix.url = "github:gador/nixpkgs/pgadmin-9.18";

  den.schema.host = mkHttpServiceOptions {
    name = "pgadmin";
  };

  adachi.services._.pgadmin = { host }: {
    nixos = { config, inputs', ... }: {
      services = {
        pgadmin = {
          enable = true;
          package = inputs'.nixpkgs-pgadmin-fix.legacyPackages.pgadmin4;
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
