{ lib, ... }:
let
  inherit (lib) mkOption;
  inherit (lib.types)
    str
    enum
    ;
in
{
  den.schema.host =
    { host, ... }:
    {
      options.services = {
        baseDomain = mkOption {
          type = str;
          default = "${host.hostName}.local";
          description = "Base domain for services";
        };
        email = mkOption {
          type = str;
          description = "Email used for ACME";
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
