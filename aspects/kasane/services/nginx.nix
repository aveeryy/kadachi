{ ... }:
{
  kasane.services._.nginx =
    { host }:
    {
      nixos =
        { config, ... }:
        {
          networking.firewall.allowedTCPPorts = [ config.services.nginx.defaultSSLListenPort ];
          services.nginx = {
            enable = true;
            recommendedGzipSettings = true;
            recommendedProxySettings = true;
            recommendedOptimisation = true;
            recommendedTlsSettings = true;
            virtualHosts = {
              ${host.services.internetDomain} = {
                forceSSL = true;
                useACMEHost = host.services.internetDomain;
                serverAliases = [ "*.${host.services.internetDomain}" ];
              };
            };
          };
        };
    };
}
