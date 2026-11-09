{ lib, ... }:
let
  inherit (lib)
    mkOption
    ;

  inherit (lib.types)
    attrsOf
    bool
    enum
    listOf
    str
    submodule
    ;

  routeType = submodule {
    options = {
      gateway = mkOption {
        type = str;
      };
    };
  };

  interfaceType = submodule (
    { name, ... }: {
      options = {
        name = mkOption {
          type = str;
          default = name;
        };

        type = mkOption {
          type = enum [
            "wireless"
            "wired"
          ];
        };

        addresses = mkOption {
          type = listOf str;
          default = [ ];
        };

        routes = mkOption {
          type = listOf routeType;
          default = [ ];
        };

        dhcp = mkOption {
          type = enum [
            "yes"
            "no"
            "ipv4"
            "ipv6"
          ];
          default = "no";
        };

        requiredForOnline = mkOption {
          type = bool;
          default = false;
        };
      };
    }
  );
in
{
  den.schema.host = { host, ... }: {
    options.networking.interfaces = mkOption {
      type = attrsOf interfaceType;
      default = { };
    };
  };
}
