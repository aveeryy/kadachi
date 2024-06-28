{ pkgs, ... }: {
  services.nginx = {
    enable = true;
    virtualHosts = {
      "rcia.dev" = {
        forceSSL = true;
        locations = {
          "/" = { root = /var/www/public; };
          "/profile_picture" = { };
        };
      };
      "ichi-prod.rcia.dev" = {
        locations."/" = {
            proxyPass = "http://127.0.0.1:3000";
        }
      };
    };
  };
}
