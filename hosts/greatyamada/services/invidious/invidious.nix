{ ... }:
let
  nginxLocalServiceConfig = import ./nginx-local-config.nix;
  ports = import ../_port-definitions.nix;
in {
  services = {
    invidious = {
      enable = true;
      port = ports.invidious-http;
      extraSettingsFile = "/var/lib/invidious/extra_configuration";
      settings = {
        check_tables = true;
        db.user = "invidious";
        default_user_preferences = {
          locale = "es";
          dark_mode = "dark";
          autoplay = true;
          video_loop = true;
          quality = "dash";
          volume = 20;
        };
        signature_server = "localhost:${toString ports.inv-sig-helper}";
      };
      database = {
        createLocally = false;
        passwordFile = "/var/lib/invidious/db_password";
      };
      hmacKeyFile = "/var/lib/invidious/hmac_key";
    };
    nginx.virtualHosts."iv.rcia.dev" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString ports.invidious-http}";
      };
      extraConfig = nginxLocalServiceConfig;
    };
  };
  sops.secrets = {
    "invidious/db_password" = {
      path = "/var/lib/invidious/db_password";
      owner = "invidious";
    };
    "invidious/hmac" = {
      path = "/var/lib/invidious/hmac_key";
      owner = "invidious";
    };
    "invidious/extra_secrets" = {
      path = "/var/lib/invidious/extra_configuration";
      owner = "invidious";
    };
  };
}
