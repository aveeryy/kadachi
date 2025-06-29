{ ... }:
let
  _portDefinitions = import ./_port-definitions.nix;
  nginxLocalConfig = import ./nginx-local-config.nix;
in {
  services = {
    pgadmin = {
      enable = true;
      initialEmail = "avery@localhost";
      initialPasswordFile = "/dev/null";
      minimumPasswordLength = 0;
      port = _portDefinitions.pgadmin;
    };
    nginx.virtualHosts."pgadmin.rcia.dev" = {
      locations."/".proxyPass =
        "http://localhost:${toString _portDefinitions.pgadmin}";
      forceSSL = true;
      useACMEHost = "rcia.dev";
      extraConfig = nginxLocalConfig;
    };
  };
}
