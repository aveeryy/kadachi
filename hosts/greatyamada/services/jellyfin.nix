{ pkgs, ... }:
let
  jellyfinPath = "/mnt/Datos/jellyfin/";
  nginxLocalServiceConfig = import ./nginx-local-config.nix;
in {
  services = {
    jellyfin = {
      enable = true;
      configDir = jellyfinPath + "config/";
      dataDir = jellyfinPath + "data/";
    };
    nginx.virtualHosts."jellyfin.rcia.dev" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096";
        clientMaxBodySize = "10M";
      };
      extraConfig = nginxLocalServiceConfig;
    };
  };
}
