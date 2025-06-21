{ ... }:
let portDefinitions = import ./_port-definitions.nix;
in {
  services = {
    jellyfin.enable = true;
    nginx.virtualHosts."jellyfin.rcia.dev" = {
      locations."/".proxyPass =
        "http://127.0.0.1:${toString portDefinitions.jellyfin-http}";
      forceSSL = true;
      useACMEHost = "rcia.dev";
    };
  };
  users.users.jellyfin.extraGroups = [ "media" ];
}
