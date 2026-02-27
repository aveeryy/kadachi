{ den, kadachi-lib, ... }:
{
  kasane.services._.karakeep = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { config, ... }:
        {
          imports = [
            (kadachi-lib.createBackupConfiguration "karakeep" host {
              source_directories = [ config.services.karakeep.extraEnvironment.DATA_DIR ];
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
            nginx.virtualHosts."karakeep.${host.services.baseHost}" = {
              locations."/".proxyPass = "http://127.0.0.1:${config.services.karakeep.extraEnvironment.PORT}";
              forceSSL = true;
              useACMEHost = host.services.baseHost;
              extraConfig = host.services.nginx.localServiceConfig;
            };
          };
        };
    }
  );
}
