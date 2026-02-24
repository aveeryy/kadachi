{ den, ... }:
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
            services = {
              radicale = {
                enable = true;
                settings = {
                  server.hosts = [ "127.0.0.1:${toString radicalePort}" ];
                  auth = {
                    type = "htpasswd";
                    htpasswd_filename = "/var/lib/radicale/users";
                    htpasswd_encryption = "bcrypt";
                  };
                };
              };
              nginx.virtualHosts."radicale.${host.services.baseHost}" = {
                locations."/".proxyPass = "http://127.0.0.1:${toString radicalePort}";
                forceSSL = true;
                useACMEHost = host.services.baseHost;
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
