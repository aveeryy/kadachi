{ lib, ... }:
{
  den.schema.host =
    { host, ... }:
    {
      options.services.nginx = {
        localServiceConfig = lib.mkOption {
          type = lib.types.str;
          default = ''
            error_page 403 https://${host.services.baseDomain};
            allow 10.0.0.0/16;
            allow 10.10.0.0/16;
            deny all;
          '';
        };
      };
    };

  kasane.services._.nginx =
    { host }:
    {
      nixos = {
        networking.firewall.allowedTCPPorts = [ 443 ];
        services.nginx = {
          enable = true;
          recommendedGzipSettings = true;
          recommendedProxySettings = true;
          recommendedOptimisation = true;
          recommendedTlsSettings = true;
          virtualHosts = {
            ${host.services.baseDomain} = {
              forceSSL = true;
              useACMEHost = host.services.baseDomain;
              serverAliases = [ "*.${host.services.baseDomain}" ];
            };
          };
        };
      };
    };
}
