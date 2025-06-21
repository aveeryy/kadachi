{ ... }: {
  networking.firewall.allowedTCPPorts = [ 443 ];
  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "rcia.dev" = {
        forceSSL = true;
        # enableACME = true;
        useACMEHost = "rcia.dev";
        serverAliases = [ "*.rcia.dev" ];
        # locations."/" = { root = /var/www/public; };
      };
    };
  };
}
