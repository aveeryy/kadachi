{
  kadachi-lib,
  lib,
  ...
}:
let
  inherit (lib)
    singleton
    ;

  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  den.schema.host = mkHttpServiceOptions {
    name = "karakeep";
  };

  kasane.services._.karakeep =
    { host }:
    {
      nixos =
        { config, pkgs, ... }:
        {
          imports = [
            (kadachi-lib.createBackupConfiguration "karakeep" host {
              source_directories = singleton config.services.karakeep.extraEnvironment.DATA_DIR;
              keep_daily = 14;
              keep_monthly = 3;
            })
          ];
          services = {
            karakeep = {
              enable = true;
              browser.enable = false;
              extraEnvironment = {
                PORT = "3002";
                DATA_DIR = "/var/lib/karakeep";
                LOG_LEVEL = "notice";
                DISABLE_SIGNUPS = "true";
              };
            };
            nginx = mkNginxConfiguration host host.services.karakeep {
              locations."/".proxyPass = "http://127.0.0.1:${config.services.karakeep.extraEnvironment.PORT}";
            };
          };
        };
    };
}
