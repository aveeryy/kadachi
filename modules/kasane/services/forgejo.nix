{

  lib,
  inputs,
  ...
}:
let
  arrayToSecrets =
    secretNames:
    builtins.listToAttrs (
      map (key: {
        name = "forgejo/${key}";
        value.owner = "forgejo";
      }) secretNames
    );
in
{
  flake-file.inputs.catppuccin = {
    url = "github:catppuccin/nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  kasane.services._.forgejo =
    { host, ... }:
    {
      nixos =
        { pkgs, config, ... }:
        {
          imports = [ inputs.catppuccin.nixosModules.catppuccin ];
          services = {
            forgejo = {
              enable = true;
              package = pkgs.forgejo;
              secrets = {
                server.LFS_JWT_SECRET = lib.mkForce config.sops.secrets."forgejo/lfs_jwt_secret".path;
                security = {
                  INTERNAL_TOKEN = lib.mkForce config.sops.secrets."forgejo/internal_token".path;
                  SECRET_KEY = lib.mkForce config.sops.secrets."forgejo/secret_key".path;
                };
                oauth2.JWT_SECRET = lib.mkForce config.sops.secrets."forgejo/oauth2_jwt_secret".path;
              };
              settings = {
                server = {
                  DOMAIN = "git.${host.services.baseHost}";
                  ROOT_URL = "https://git.${host.services.baseHost}";
                  HTTP_PORT = 3000;
                  DISABLE_SSH = false;
                  START_SSH_SERVER = false;
                  LFS_START_SERVER = true;
                };
                service = {
                  DISABLE_REGISTRATION = true;
                  REGISTER_MANUAL_CONFIRM = true;
                };
                security = {
                  INSTALL_LOCK = true;
                };
              };
            };
            nginx.virtualHosts."git.${host.services.baseHost}" = {
              locations."/" = {
                proxyPass = "http://127.0.0.1:${toString config.services.forgejo.settings.server.HTTP_PORT}";
              };
              forceSSL = true;
              useACMEHost = host.services.baseHost;
            };
            openssh.settings.AllowUsers =
              lib.lists.optionals (!config.services.forgejo.settings.server.DISABLE_SSH)
                [
                  "forgejo"
                ];
          };
          sops.secrets = arrayToSecrets [
            "database_password"
            "internal_token"
            "lfs_jwt_secret"
            "oauth2_jwt_secret"
            "secret_key"
          ];
          catppuccin.forgejo = {
            enable = true;
            flavor = "mocha";
            accent = "mauve";
          };
        };
    };
}
