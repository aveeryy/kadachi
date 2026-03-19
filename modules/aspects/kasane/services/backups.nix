{
  lib,
  den,
  inputs,
  ...
}:
let
  repositoryType =
    with lib.types;
    submodule {
      options = {
        path = lib.mkOption {
          type = str;
          description = "Path to the repository";
        };
        label = lib.mkOption {
          type = str;
          description = "Repository label";
        };
      };
    };
in
{
  den.schema.host =
    { host, ... }:
    {
      options.services.backups = with lib.types; {
        identifyingIcon = lib.mkOption {
          type = str;
          default = "";
          example = "cat";
        };
        repositories = lib.mkOption {
          type = functionTo (listOf repositoryType);
          default = name: [ ];
          example = name: [
            {
              path = "ssh://user@example.com/backups/${name}";
              label = "backupserver";
            }
            {
              path = "/mnt/backups/${name}";
              label = "local";
            }
          ];
        };
      };
    };
  kasane.services._.backups = den.lib.take.exactly (
    { host }:
    {
      nixos =
        { config, ... }:
        {
          services.borgmatic.enable = true;
          sops = {
            secrets = {
              "backups/ssh_private_key".owner = "root";
              "backups/ntfy_token" = {
                owner = "root";
                sopsFile = "${inputs.secrets}/common.yaml";
              };
            };
            templates."backups_ssh_private_key" = {
              content = ''
                ${config.sops.placeholder."backups/ssh_private_key"}
              '';
              owner = "root";
            };
          };
          systemd.timers.borgmatic.timerConfig.RandomizedDelaySec = "0";
        };
    }
  );
}
