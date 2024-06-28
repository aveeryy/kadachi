{ ... }:
let nginxLocalServiceConfig = import ./nginx-local-config.nix;
in {
  services = {
    invidious = {
      enable = true;
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
      };
      database = {
        createLocally = false;
        passwordFile = "/var/lib/invidious/db_password";
      };
      hmacKeyFile = "/var/lib/invidious/hmac_key";
    };
    nginx.virtualHosts."iv.rcia.dev" = {
      locations."/" = { proxyPass = "http://127.0.0.1:3000"; };
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
  };
}
