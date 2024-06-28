{ ... }:
let
  radicalePath = "/mnt/Datos/radicale";
  nginxLocalServiceConfig = import ./nginx-local-config.nix;
in {
  services = {
    radicale = {
      enable = true;
      settings = {
        server.hosts = [ "127.0.0.1:5232" ];
        auth = {
          type = "htpasswd";
          htpasswd_filename = "/etc/radicale/users";
          htpasswd_encryption = "bcrypt";
        };
        storage.filesystem_folder = radicalePath;
      };
    };
    nginx.virtualHosts."radicale.rcia.dev" = {
      locations."/" = { proxyPass = "http://127.0.0.1:5232"; };
      extraConfig = nginxLocalServiceConfig;
    };
  };
  sops.secrets."radicale/users" = {
    path = "/etc/radicale/users";
    owner = "radicale";
  };
}
