{ den, kadachi-lib, ... }:
{
  kasane.services._.radicale =
    let
      radicalePort = 5232;
    in
    den.lib.take.exactly (
      { host }:
      {
        nixos =
          { config, lib, ... }:
          {
            imports = [
              (kadachi-lib.createBackupConfiguration "radicale" host {
                source_directories = [ config.services.radicale.settings.storage.filesystem_folder ];
                keep_daily = 14;
                keep_monthly = 3;
              })
            ];
            services = {
              radicale = {
                enable = true;
                settings = {
                  server.hosts = [ "127.0.0.1:${toString radicalePort}" ];
                  auth = {
                    type = "htpasswd";
                    htpasswd_filename = config.sops.secrets."radicale/users".path;
                    htpasswd_encryption = "bcrypt";
                  };
                  storage.filesystem_folder = "/var/lib/radicale/collections";
                };
              };
              nginx.virtualHosts."radicale.${host.services.baseDomain}" = {
                locations."/".proxyPass = "http://127.0.0.1:${toString radicalePort}";
                forceSSL = true;
                useACMEHost = host.services.baseDomain;
                extraConfig = host.services.nginx.localServiceConfig;
              };
            };
            sops.secrets."radicale/users" = {
              path = "/var/lib/radicale/users";
              owner = "radicale";
            };
          };
      }
    );
}
