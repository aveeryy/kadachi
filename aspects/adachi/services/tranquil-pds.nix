{ kadachi-lib, lib, ... }:
let
  inherit (lib)
    mkDefault
    singleton
    ;

  inherit (kadachi-lib.http)
    mkHttpServiceOptions
    mkNginxConfiguration
    ;
in
{
  den.schema.host = mkHttpServiceOptions {
    name = "tranquil-pds";
    subdomain = "pds";
  };

  adachi.services._.tranquil-pds = { host }: {
    nixos = { config, ... }: {
      services = {
        tranquil-pds = {
          enable = true;
          database.createLocally = true;
          environmentFiles = singleton config.sops.templates."tranquil-pds.env".path;
          settings = {
            server = {
              hostname = host.services.tranquil-pds.domains.internet;
              port = mkDefault 3003;
              age_assurance_override = mkDefault true;
              disable_account_verification_gate = mkDefault true;
              invite_code_required = mkDefault true;
            };
          };
        };

        nginx = mkNginxConfiguration host host.services.tranquil-pds {
          locations."/" = {
            proxyPass = "http://127.0.0.1:${toString config.services.tranquil-pds.settings.server.port}";
            extraConfig = ''
              proxy_read_timeout 300;
              proxy_send_timeout 300;
            '';
          };
          locations."/xrpc" = {
            proxyPass = "http://127.0.0.1:${toString config.services.tranquil-pds.settings.server.port}";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_read_timeout 86400;
              proxy_send_timeout 86400;
              proxy_buffering off;
              proxy_request_buffering off;
            '';
          };
        };
      };

      sops = {
        secrets = {
          "tranquil-pds/master_key" = { };
          "tranquil-pds/jwt_secret" = { };
          "tranquil-pds/dpop_secret" = { };
          "tranquil-pds/discord_bot_token" = { };
        };
        templates."tranquil-pds.env".content = ''
          MASTER_KEY=${config.sops.placeholder."tranquil-pds/master_key"}
          JWT_SECRET=${config.sops.placeholder."tranquil-pds/jwt_secret"}
          DPOP_SECRET=${config.sops.placeholder."tranquil-pds/dpop_secret"}
          DISCORD_BOT_TOKEN=${config.sops.placeholder."tranquil-pds/discord_bot_token"}
        '';
      };
    };
  };
}
