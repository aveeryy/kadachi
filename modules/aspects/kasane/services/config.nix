{ lib, ... }:
{
  den.schema.host =
    { host, ... }:
    {
      options.services = {
        baseHost = lib.mkOption {
          type = lib.types.str;
          default = "${host.hostName}.local";
        };
        email = lib.mkOption { type = lib.types.str; };
      };
    };
}
