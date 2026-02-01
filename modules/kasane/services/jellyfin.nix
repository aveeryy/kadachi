{ ... }:
{
  kasane.services._.jellyfin =
    { host, ... }:
    {
      nixos = {
        services = {
          jellyfin.enable = true;
          nginx.virtualHosts."jellyfin.${host.services.baseHost}" = {
            locations."/".proxyPass = "http://127.0.0.1:8096";
            forceSSL = true;
            useACMEHost = host.services.baseHost;
          };
        };
        users.users.jellyfin.extraGroups = [ "media" ];
      };
    };
}
