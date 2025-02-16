{ pkgs, ... }:
let
  forgejoSecretsPath = "/run/secrets/forgejo_";
  portDefinitions = import ./_port-definitions.nix;
  arrayToSecrets = elements:
    builtins.listToAttrs (map (key: {
      name = "forgejo/${key}";
      value = {
        path = "${forgejoSecretsPath}${key}";
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
        passwordFile = "${forgejoSecretsPath}database_password";
      };
      secrets = {
        server.LFS_JWT_SECRET = "${forgejoSecretsPath}lfs_jwt_secret";
        security = {
          INTERNAL_TOKEN = "${forgejoSecretsPath}internal_token";
          SECRET_KEY = "${forgejoSecretsPath}secret_key";
        };
        oauth2.JWT_SECRET = "${forgejoSecretsPath}oauth2_jwt_secret";
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
      };
      useACMEHost = "rcia.dev";
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
