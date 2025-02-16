{ ... }:
let
  jellyfinPath = "/mnt/Datos/jellyfin";
  nginxLocalServiceConfig = import ./nginx-local-config.nix;
  portDefinitions = import ./_port-definitions.nix;
in {
  services = {
    jellyfin = {
      enable = true;
      dataDir = "${jellyfinPath}/data/";
    };
    nginx.virtualHosts."jellyfin.rcia.dev" = {
      locations."/" = {
        proxyPass =
          "http://127.0.0.1:${toString portDefinitions.jellyfin-http}";
      };
      extraConfig = nginxLocalServiceConfig;
      useACMEHost = "rcia.dev";
    };
  };
}
