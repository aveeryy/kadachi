{
  inputs,
  kadachi-lib,
  lib,
  ...
}:
let
  inherit (lib)
    mkDefault
    singleton
    ;

  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  flake-file.inputs.celler = {
    url = "github:celler-cache/celler";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.schema.host = mkHttpServiceOptions {
    name = "celler";
    subdomain = "cache";
  };

  adachi.services._.celler = { host }: {
    nixos = { ... }: {
      imports = singleton inputs.celler.nixosModules.cellerd;
      services = {
        celler = {
          enable = true;

          settings = {
            listen = "127.0.0.1:9090";
            api-endpoint = "https://${host.services.celler.domains.internet}/";

            database.url = mkDefault "postgresql:///cellerd?host=/run/postgresql";

          };
        };

        nginx = mkNginxConfiguration host host.services.celler { };
      };
    };
  };
}
