{ pkgs, ... }:
let
  forgejoConfigPath = "/var/lib/forgejo/custom/conf";
  portDefinitions = import ./_port-definitions.nix;
  arrayToSecrets = elements:
    builtins.listToAttrs (map (key: {
      name = "forgejo/${key}";
      value = {
        path = "${forgejoConfigPath}/${key}";
        owner = "forgejo";
      };
    }) elements);
in {
  services = {
    forgejo = {
      enable = true;
      package = pkgs.forgejo;
      database = {
        type = "postgres";
        port = portDefinitions.postgresql;
        passwordFile = "${forgejoConfigPath}/database_password";
      };
      secrets = {
        server.LFS_JWT_SECRET = "${forgejoConfigPath}/lfs_jwt_secret";
        security = {
          INTERNAL_TOKEN = "${forgejoConfigPath}/internal_token";
          SECRET_KEY = "${forgejoConfigPath}/secret_key";
        };
        oauth2.JWT_SECRET = "${forgejoConfigPath}/oauth2_jwt_secret";
      };
      settings = {
        server = {
          DOMAIN = "git.rcia.dev";
          ROOT_URL = "https://git.rcia.dev";
          HTTP_PORT = portDefinitions.forgejo-http;
          DISABLE_SSH = true;
          LFS_START_SERVER = true;
        };
        security = { INSTALL_LOCK = true; };
      };
    };
    nginx.virtualHosts."git.rcia.dev" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString portDefinitions.forgejo-http}";
        clientMaxBodySize = "200M";
      };
    };
  };
  systemd.services.forgejo.preStart = ''
    ${pkgs.forgejo}/bin/gitea migrate
  '';
  sops.secrets = arrayToSecrets [
    "database_password"
    "internal_token"
    "lfs_jwt_secret"
    "oauth2_jwt_secret"
    "secret_key"
  ];
}
