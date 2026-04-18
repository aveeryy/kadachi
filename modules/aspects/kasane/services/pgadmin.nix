{ den, ... }:
{
  kasane.services._.pgadmin = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { config, lib, ... }:
        {
          services = {
            pgadmin = {
              enable = true;
              initialEmail = "admin@${host.services.baseDomain}";
              initialPasswordFile = config.sops.secrets."pgadmin/initial_password".path;
              port = 5050;
            };
            nginx.virtualHosts."pgadmin.${host.services.baseDomain}" = {
              locations."/".proxyPass = "http://localhost:${toString config.services.pgadmin.port}";
              forceSSL = true;
              useACMEHost = host.services.baseDomain;
              extraConfig = host.services.nginx.localServiceConfig;
            };
          };
          sops.secrets."pgadmin/initial_password".owner = "pgadmin";
        };
    }
  );
}
