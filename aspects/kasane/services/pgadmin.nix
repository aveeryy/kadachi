{ ... }:
{
  kasane.services._.pgadmin =
    { host }:
    {
      nixos =
        { config, lib, ... }:
        {
          services = {
            pgadmin = {
              enable = true;
              initialEmail = "admin@${host.services.internetDomain}";
              initialPasswordFile = config.sops.secrets."pgadmin/initial_password".path;
              port = 5050;
            };
            nginx.virtualHosts."pgadmin.${host.services.internetDomain}" = {
              locations."/".proxyPass = "http://localhost:${toString config.services.pgadmin.port}";
              forceSSL = true;
              useACMEHost = host.services.internetDomain;
              extraConfig = host.services.nginx.localServiceConfig;
            };
          };
          sops.secrets."pgadmin/initial_password".owner = "pgadmin";
        };
    };
}
