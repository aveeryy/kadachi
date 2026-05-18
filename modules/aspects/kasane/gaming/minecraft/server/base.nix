{
  inputs,
  lib,
  kadachi-lib,
  ...
}:
{
  flake-file.inputs.nix-minecraft = {
    url = "github:Infinidoge/nix-minecraft";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  kasane.gaming._.minecraft._.server =
    { host }:
    {
      nixos =
        { config, pkgs, ... }:
        let
          inherit (lib) getExe nameValuePair;
          inherit (lib.attrsets) mapAttrs';
          inherit (kadachi-lib) createBackupConfiguration';
          inherit (kadachi-lib.minecraft) getBackupPaths;

          backupHour = 04;

          createBeforeBackupScript =
            serverName:
            getExe (
              pkgs.writeShellApplication {
                name = "minecraft-server-before-backup-${serverName}";
                text = ''
                  SERVICE_NAME="minecraft-server-${serverName}.service"
                  if [[ ! "$(date "+%-H")" = "${toString backupHour}" ]]; then
                    exit 75
                  fi

                  if [[ "$(systemctl is-active $SERVICE_NAME)" = "active" ]]; then
                    touch "/tmp/${serverName}-$(date "+%Y-%m-%d").active"
                    systemctl stop "$SERVICE_NAME"
                  fi
                '';
              }
            );

          createAfterBackupScript =
            serverName:
            getExe (
              pkgs.writeShellApplication {
                name = "minecraft-server-after-backup-${serverName}";
                text = ''
                  FILE_NAME="/tmp/${serverName}-$(date "+%Y-%m-%d").active";
                  if [[ -f "$FILE_NAME" ]]; then
                    rm -f "$FILE_NAME"
                    systemctl start "minecraft-server-${serverName}.service"
                  fi
                '';
              }
            );
        in
        {
          imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

          nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

          services = {
            minecraft-servers = {
              enable = true;
              eula = true;
              openFirewall = false;
              environmentFile = config.sops.templates."minecraft.env".path;
              managementSystem = {
                systemd-socket.enable = true;
                tmux.enable = false;
              };
            };

            borgmatic.configurations = mapAttrs' (
              name: paths:
              nameValuePair ("minecraft-${name}") (
                createBackupConfiguration' "minecraft-${name}" host {
                  source_directories = paths;
                  encryption_passphrase = "{credential file /run/secrets/backups/password/minecraft_common}";
                  keep_daily = 3;
                  keep_weekly = 1;
                  keep_monthly = 1;
                  commands = [
                    {
                      before = "configuration";
                      when = [ "check" ];
                      run = [ (createBeforeBackupScript name) ];
                    }
                    {
                      after = "configuration";
                      when = [ "create" ];
                      run = [ (createAfterBackupScript name) ];
                    }
                  ];
                }
              )
            ) (getBackupPaths config.services.minecraft-servers);
          };

          sops = {
            secrets = {
              "backups/password/minecraft_common".owner = "root";
              "minecraft/proxy_forwarding_secret".owner = "minecraft";
            };
            templates."minecraft.env" = {
              content = ''
                MINECRAFT_PROXY_FORWARDING_SECRET=${config.sops.placeholder."minecraft/proxy_forwarding_secret"}
              '';
              owner = "minecraft";
            };
          };
        };
    };
}
