{
  inputs,
  den,
  lib,
  kadachi-lib,
  ...
}:
let
  inherit (lib) nameValuePair;
  inherit (lib.attrsets) mapAttrs';
  inherit (kadachi-lib) createBackupConfiguration';
  inherit (kadachi-lib.minecraft) getBackupPaths;
in
{
  flake-file.inputs.nix-minecraft = {
    url = "github:Infinidoge/nix-minecraft";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  kasane.gaming._.minecraft._.server = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { config, ... }:
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
                  encryption_passcommand = "cat /run/secrets/backups/password/minecraft_common";
                  keep_daily = 3;
                  keep_weekly = 1;
                  keep_monthly = 1;
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
    }
  );
}
