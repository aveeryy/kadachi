{ den, ... }:
{
  kasane.services._.vaultwarden = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { config, ... }:
        {
          services = {
            vaultwarden = {
              enable = true;
              config = {
                domain = "https://vaultwarden.${host.services.baseHost}";
                rocketAddress = "127.0.0.1";
                rocketPort = 8222;
                showPasswordHint = false;
                signupsAllowed = false;
              };
              environmentFile = config.sops.templates."vaultwarden.env".path;
            };
            nginx.virtualHosts."vaultwarden.${host.services.baseHost}" = {
              locations."/".proxyPass =
                "http://localhost:${toString config.services.vaultwarden.config.rocketPort}";
              forceSSL = true;
              useACMEHost = host.services.baseHost;
              extraConfig = host.services.nginx.localServiceConfig;
            };
          };
          sops = {
            secrets."vaultwarden/database_url" = { };
            templates."vaultwarden.env" = {
              content = ''
                DATABASE_URL=${config.sops.placeholder."vaultwarden/database_url"}
              '';
              owner = "vaultwarden";
            };
          };

        };
    }
  );
}
