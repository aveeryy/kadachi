{
  lib,
  inputs,
  den,
  kadachi-lib,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkForce
    mkOption
    optional
    ;
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
        domain = mkOption {
          type = str;
          default = "git.${host.services.baseDomain}";
        };
        database = mkOption {
          type = str;
          default = host.services.defaultDatabase;
        };
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
              type = mkDefault "postgres";
              port = mkDefault config.services.postgresql.settings.port;
              socket = mkDefault "/run/postgresql";
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
                server.LFS_JWT_SECRET = mkForce config.sops.secrets."forgejo/lfs_jwt_secret".path;
                security = {
                  INTERNAL_TOKEN = mkForce config.sops.secrets."forgejo/internal_token".path;
                  SECRET_KEY = mkForce config.sops.secrets."forgejo/secret_key".path;
                };
                oauth2.JWT_SECRET = mkForce config.sops.secrets."forgejo/oauth2_jwt_secret".path;
              };
              settings = {
                server = {
                  DOMAIN = host.services.forgejo.domain;
                  ROOT_URL = "https://${host.services.forgejo.domain}";
                  HTTP_PORT = mkDefault 3000;
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
              useACMEHost = host.services.baseDomain;
            };

            openssh.settings.AllowUsers = optional (!cfg.settings.server.DISABLE_SSH) "forgejo";
          };

          sops.secrets = {
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
