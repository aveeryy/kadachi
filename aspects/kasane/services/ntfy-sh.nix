{ kadachi-lib, ... }:
let
  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  den.schema.host = mkHttpServiceOptions {
    name = "ntfy-sh";
    subdomain = "ntfy";
  };

  kasane.services._.ntfy-sh =
    { host }:
    {
      nixos =
        { config, ... }:
        {
          services = {
            ntfy-sh = {
              enable = true;
              environmentFile = config.sops.templates."ntfy/users".path;
              settings = {
                base-url = "https://${host.services.ntfy-sh.domains.internet}";
                listen-http = ":2586";
                behind-proxy = true;

                auth-file = "/var/lib/ntfy-sh/user.db";
                auth-default-access = "deny-all";
              };
            };
            nginx = mkNginxConfiguration host host.services.ntfy-sh {
              locations."/" = {
                proxyPass = "http://127.0.0.1${config.services.ntfy-sh.settings.listen-http}";
                proxyWebsockets = true;
              };
            };
          };

          sops = {
            secrets."ntfy/users" = { };
            templates."ntfy/users" = {
              content = ''
                NTFY_AUTH_USERS="${config.sops.placeholder."ntfy/users"}"
              '';
              owner = config.services.ntfy-sh.user;
            };
          };
        };
    };
}
