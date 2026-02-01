{ ... }:
{
  kasane.services._.karakeep =
    { host, ... }:
    {
      nixos =
        { config, ... }:
        {
          services = {
            karakeep = {
              enable = true;
              browser.enable = false;
              extraEnvironment = {
                PORT = "3002";
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
    };
}
