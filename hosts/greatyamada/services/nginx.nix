{ pkgs, ... }: {
  services.nginx = {
    enable = true;
    virtualHosts = {
      "rcia.dev" = {
        forceSSL = true;
        locations."/" = { root = /var/www/public; };
      };
    };
  };
}
