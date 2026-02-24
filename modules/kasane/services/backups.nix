{ lib, den, ... }:
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
  den.base.host =
    { host, ... }:
    {
      options.services.backups = with lib.types; {
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
            secrets."backups/ssh_private_key".owner = "root";
            templates."backups_ssh_private_key" = {
              content = ''
                ${config.sops.placeholder."backups/ssh_private_key"}
              '';
              owner = "root";
            };
          };
        };
    }
  );
}
