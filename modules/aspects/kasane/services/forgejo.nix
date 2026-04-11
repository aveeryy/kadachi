{
  lib,
  inputs,
  den,
  kadachi-lib,
  ...
}:
let
  inherit (kadachi-lib) mkOpt;
in
{
  flake-file.inputs.catppuccin = {
    url = "github:catppuccin/nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.schema.host =
    { host, ... }:
    {
      options.services.forgejo = with lib.types; {
        domain = mkOpt str "git.${host.services.baseHost}";
        database = mkOpt str host.services.defaultDatabase;
      };
    };

  kasane.services._.forgejo = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { pkgs, config, ... }:
        let
          cfg = config.services.forgejo;

          databaseConfig = {
            postgres = {
              type = lib.mkDefault "postgres";
              port = lib.mkDefault config.services.postgresql.settings.port;
              passwordFile = lib.mkDefault config.sops.secrets."forgejo/database_password".path;
            };
          };
        in
        {
          imports = [
            inputs.catppuccin.nixosModules.catppuccin

            (kadachi-lib.createBackupConfiguration "forgejo" host {
              source_directories = [ cfg.stateDir ];
              keep_daily = 7;
              keep_weekly = 4;
            })
          ];

          services = {
            forgejo = {
              enable = true;
              package = pkgs.forgejo;
              database = databaseConfig.${host.services.forgejo.database};
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
                  DOMAIN = host.services.forgejo.domain;
                  ROOT_URL = "https://${host.services.forgejo.domain}";
                  HTTP_PORT = lib.mkDefault 3000;
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
                  LOGIN_REMEMBER_DAYS = 90;
                };
              };
            };

            nginx.virtualHosts.${host.services.forgejo.domain} = {
              locations."/" = {
                proxyPass = "http://127.0.0.1:${toString cfg.settings.server.HTTP_PORT}";
              };
              forceSSL = true;
              useACMEHost = host.services.baseHost;
            };

            openssh.settings.AllowUsers = lib.lists.optional (!cfg.settings.server.DISABLE_SSH) "forgejo";
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
