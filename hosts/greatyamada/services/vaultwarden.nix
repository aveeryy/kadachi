{ config, ... }:
let
  ports = import ./_port-definitions.nix;
  nginxLocalServiceConfig = import ./nginx-local-config.nix;
in {
  services = {
    vaultwarden = {
      enable = true;
      dbBackend = "postgresql";
      config = {
        domain = "https://vaultwarden.rcia.dev";
        rocketAddress = "127.0.0.1";
        rocketPort = ports.tcp.vaultwarden;
        showPasswordHint = false;
        signupsAllowed = false;
      };
      environmentFile = config.sops.templates."vaultwarden.env".path;
    };
    nginx.virtualHosts."vaultwarden.rcia.dev" = {
      locations."/".proxyPass =
        "http://localhost:${toString ports.tcp.vaultwarden}";
      forceSSL = true;
      useACMEHost = "rcia.dev";
      extraConfig = nginxLocalServiceConfig;
    };
  };
  sops = {
    secrets."vaultwarden_database_url" = { };
    templates."vaultwarden.env" = {
      content = ''
        DATABASE_URL=${config.sops.placeholder."vaultwarden_database_url"}
      '';
      owner = "vaultwarden";
    };
  };
}
