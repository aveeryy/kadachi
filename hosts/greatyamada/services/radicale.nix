{ ... }:
let
  nginxLocalServiceConfig = import ./nginx-local-config.nix;
  portDefinitions = import ./_port-definitions.nix;
in {
  services = {
    radicale = {
      enable = true;
      settings = {
        server.hosts =
          [ "127.0.0.1:${toString portDefinitions.radicale-http}" ];
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/var/lib/radicale/users";
          htpasswd_encryption = "bcrypt";
        };
      };
    };
    nginx.virtualHosts."radicale.rcia.dev" = {
      locations."/" = {
        proxyPass =
          "http://127.0.0.1:${toString portDefinitions.radicale-http}";
      };
      forceSSL = true;
      useACMEHost = "rcia.dev";
      extraConfig = nginxLocalServiceConfig;
    };
  };
  sops.secrets."radicale/users" = {
    path = "/var/lib/radicale/users";
    owner = "radicale";
  };
}
