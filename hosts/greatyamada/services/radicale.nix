{ ... }:
let
  nginxLocalServiceConfig = import ./nginx-local-config.nix;
  portDefinitions = import ./_port-definitions.nix;
  radicalePath = "/mnt/Datos/radicale";
in {
  services = {
    radicale = {
      enable = true;
      settings = {
        server.hosts =
          [ "127.0.0.1:${toString portDefinitions.radicale-http}" ];
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/etc/radicale/users";
          htpasswd_encryption = "bcrypt";
        };
        storage.filesystem_folder = radicalePath;
      };
    };
    nginx.virtualHosts."radicale.rcia.dev" = {
      locations."/" = {
        proxyPass =
          "http://127.0.0.1:${toString portDefinitions.radicale-http}";
      };
      extraConfig = nginxLocalServiceConfig;
      useACMEHost = "rcia.dev";
    };
  };
  sops.secrets."radicale/users" = {
    path = "/etc/radicale/users";
    owner = "radicale";
  };
}
