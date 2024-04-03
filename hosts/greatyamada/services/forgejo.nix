{ lib, pkgs, ... }:
let
  forgejoConfigPath = "/var/lib/forgejo/custom/conf";
  arrayToSecrets = elements:
    builtins.listToAttrs (map (x: {
      name = "forgejo/" + x;
      value = {
        path = "${forgejoConfigPath}/" + x;
        owner = "forgejo";
      };
    }) elements);
in {
  services = {
    forgejo = {
      enable = true;
      settings = {
        server = {
          DOMAIN = "git.rcia.dev";
          ROOT_URL = "https://git.rcia.dev";
          HTTP_PORT = 3000;
          DISABLE_SSH = true;
          LFS_START_SERVER = true;
          LFS_JWT_SECRET = "";
          LFS_JWT_SECRET_URI = "file://${forgejoConfigPath}/lfs_jwt_secret";
        };
        database = {
          type = "postgres";
          passwordFile = "${forgejoConfigPath}/database_password";
        };
        security = {
          INSTALL_LOCK = true;
          INTERNAL_TOKEN = lib.mkForce "";
          INTERNAL_TOKEN_URI = "file://${forgejoConfigPath}/internal_token";
          SECRET_KEY = lib.mkForce "";
          SECRET_KEY_URI = "file://${forgejoConfigPath}/secret_key";
        };
        oauth2 = {
          JWT_SECRET = lib.mkForce "";
          JWT_SECRET_URI = "file://${forgejoConfigPath}/oauth2_jwt_secret";
        };
      };
    };
    nginx = {
      virtualHosts."git.rcia.dev" = {
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          clientMaxBodySize = "200M";
        };
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
