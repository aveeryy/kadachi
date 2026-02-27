{ den, ... }:
{
  kasane.services._.ntfy-sh = den.lib.take.exactly (
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
                base-url = "https://ntfy.${host.services.baseHost}";
                listen-http = ":2586";
                behind-proxy = true;

                auth-file = "/var/lib/ntfy-sh/user.db";
                auth-default-access = "deny-all";
              };
            };
            nginx.virtualHosts."ntfy.${host.services.baseHost}" = {
              locations."/" = {
                proxyPass = "http://127.0.0.1${config.services.ntfy-sh.settings.listen-http}";
                proxyWebsockets = true;
              };
              forceSSL = true;
              useACMEHost = "rcia.dev";
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
    }
  );
}
