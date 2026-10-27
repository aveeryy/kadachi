{ kadachi-lib, lib, ... }:
let
  inherit (lib)
    mkForce
    ;

  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  den.schema.host = mkHttpServiceOptions {
    name = "miniflux";
    subdomain = "rss";
  };

  adachi.services._.miniflux = { host }: {
    nixos = { config, ... }: {
      services = {
        miniflux = {
          enable = true;
          adminCredentialsFile = config.sops.templates."miniflux_admin".path;
          config = {
            LISTEN_ADDR = "localhost:12500";
          };
        };

        nginx = mkNginxConfiguration host host.services.miniflux {
          locations."/".proxyPass = "http://${config.services.miniflux.config.LISTEN_ADDR}";
        };
      };

      sops = {
        secrets = {
          "miniflux/admin_username" = { };
          "miniflux/admin_password" = { };
        };
        templates."miniflux_admin".content = ''
          ADMIN_USERNAME=${config.sops.placeholder."miniflux/admin_username"}
          ADMIN_PASSWORD=${config.sops.placeholder."miniflux/admin_password"}
        '';
      };
    };
  };
}
