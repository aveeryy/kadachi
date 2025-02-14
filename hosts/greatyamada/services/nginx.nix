{ ... }: {
  services.nginx = {
    enable = true;
    virtualHosts = {
      "rcia.dev" = { locations."/" = { root = /var/www/public; }; };
    };
  };
}
