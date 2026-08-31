{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types)
    enum
    str
    nullOr
    ;
in
{
  den.schema.host =
    { host, ... }:
    {
      options.services = {
        internetDomain = mkOption {
          type = nullOr str;
          default = null;
          description = "Base internet-accessible domain for services";
        };

        email = mkOption {
          type = str;
          description = "Email used for ACME";
        };

        fallbackUrl = mkOption {
          type = str;
          default = host.services.internetDomain;
          description = "Fallback URL for private services";
        };

        # Generic options for databases
        database = {
          default = mkOption {
            type = enum [ "postgres" ];
            description = "Default database to use for services";
          };
        };
      };
    };
}
