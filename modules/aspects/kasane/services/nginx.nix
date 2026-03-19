{ lib, den, ... }:
{
  den.schema.host =
    { host, ... }:
    {
      options.services.nginx = {
        localServiceConfig = lib.mkOption {
          type = lib.types.str;
          default = ''
            error_page 403 https://${host.services.baseHost};
            allow 10.0.0.0/24;
            allow 10.10.0.0/24;
            deny all;
          '';
        };
      };
    };

  kasane.services._.nginx = den.lib.take.exactly (
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
            ${host.services.baseHost} = {
              forceSSL = true;
              useACMEHost = host.services.baseHost;
              serverAliases = [ "*.${host.services.baseHost}" ];
            };
          };
        };
      };
    }
  );
}
