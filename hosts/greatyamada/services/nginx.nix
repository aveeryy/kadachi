{ ... }: {
  services.nginx = {
    enable = true;
    virtualHosts = {
      "rcia.dev" = {
        forceSSL = true;
        enableACME = true;
        serverAliases = [ "*.rcia.dev" ];
        # locations."/" = { root = /var/www/public; };
      };
    };
  };
}
