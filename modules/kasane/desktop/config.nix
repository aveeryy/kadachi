{ lib, ... }:
let
  displayType = lib.types.submodule (
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          default = name;
        };
        resolution = lib.mkOption { type = lib.types.str; };
        refreshRate = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 60;
        };
        position = lib.mkOption {
          type = lib.types.str;
          default = "0x0";
        };
        scaling = lib.mkOption {
          type = lib.types.strMatching "^[[:digit:]]+(.[[:digit:]]+)?$";
          default = "1";
        };
        rotation = lib.mkOption {
          type = lib.types.enum [
            "0"
            "90"
            "180"
            "270"
            "0-flipped"
            "90-flipped"
            "180-flipped"
            "270-flipped"
          ];
          default = "0";
        };
      };
    }
  );
in
{
  den.base.host =
    { host, ... }:
    {
      options = {
        desktop = {
          displays = lib.mkOption { type = lib.types.attrsOf displayType; };
          lockSessionAtStart = lib.mkOption {
            type = lib.types.bool;
            default = false;
          };
          system = {
            hasBattery = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            hasBluetooth = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
            hasWiFi = lib.mkOption {
              type = lib.types.bool;
              default = false;
            };
          };
        };
      };
    };
}
