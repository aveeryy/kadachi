{ lib, ... }:
{
  kasane.services._.searxng =
    { host, ... }:
    {
      nixos =
        { pkgs, config, ... }:
        {
          services = {
            searx = {
              enable = true;
              package = pkgs.searxng;
              environmentFile = config.sops.templates."searxng_secret_key.env".path;
              redisCreateLocally = true;
              settings = {
                base_url = "https://searxng.${host.services.baseHost}";
                bind_address = "127.0.0.1";
                port = 8888;
                public_instance = false;
                limiter = false;
              };

            };
            nginx.virtualHosts."searxng.${host.services.baseHost}" = {
              locations."/".proxyPass = "http://127.0.0.1:${toString config.services.searx.settings.port}";
              extraConfig = lib.optionals (
                !config.services.searx.settings.public_instance
              ) host.services.nginx.localServiceConfig;
              forceSSL = true;
              useACMEHost = host.services.baseHost;
            };
          };
          sops = {
            secrets."searxng/secret_key".owner = "searx";
            templates."searxng_secret_key.env" = {
              content = ''
                SEARXNG_SECRET=${config.sops.placeholder."searxng/secret_key"}
              '';
              owner = "searx";
            };
          };
          systemd.services.nginx.serviceConfig.ProtectHome = false;
          users.groups.searx.members = lib.optionals (config.services.nginx.enable) [ "nginx" ];
        };
    };
}
