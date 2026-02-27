{
  lib,
  inputs,
  den,
  kadachi-lib,
  ...
}:
{
  flake-file.inputs.catppuccin = {
    url = "github:catppuccin/nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  kasane.services._.forgejo = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { pkgs, config, ... }:
        {
          imports = [
            inputs.catppuccin.nixosModules.catppuccin

            (kadachi-lib.createBackupConfiguration "forgejo" host {
              source_directories = [ config.services.forgejo.stateDir ];
              keep_daily = 7;
              keep_weekly = 4;
            })
          ];
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

            openssh.settings.AllowUsers = lib.lists.optional (
              !config.services.forgejo.settings.server.DISABLE_SSH
            ) "forgejo";
          };

          sops.secrets = {
            "forgejo/database_password".owner = "forgejo";
            "forgejo/internal_token".owner = "forgejo";
            "forgejo/lfs_jwt_secret".owner = "forgejo";
            "forgejo/oauth2_jwt_secret".owner = "forgejo";
            "forgejo/secret_key".owner = "forgejo";
          };

          catppuccin.forgejo = {
            enable = true;
            flavor = "mocha";
            accent = "mauve";
          };
        };
    }
  );
}
