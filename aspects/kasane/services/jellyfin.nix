{ kadachi-lib, ... }:
let
  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  den.schema.host = mkHttpServiceOptions {
    name = "jellyfin";
  };

  kasane.services._.jellyfin =
    { host }:
    {
      nixos = {
        services = {
          jellyfin.enable = true;
          nginx = mkNginxConfiguration host host.services.jellyfin {
            locations."/".proxyPass = "http://127.0.0.1:8096";
          };
        };
        users.users.jellyfin.extraGroups = [
          "media"
          "render"
          "video"
        ];
      };
    };
}
