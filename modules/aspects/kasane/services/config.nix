{ lib, ... }:
{
  den.schema.host =
    { host, ... }:
    {
      options.services = with lib.types; {
        baseDomain = lib.mkOption {
          type = str;
          default = "${host.hostName}.local";
        };
        defaultDatabase = lib.mkOption { type = enum [ "postgres" ]; };
        email = lib.mkOption { type = str; };
      };
    };
}
