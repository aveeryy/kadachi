{ self, lib, ... }:
let
  inherit (lib) map filter;
  inherit (lib.attrsets) hasAttr;

  createBackupConfiguration = backupName: host: borgmaticConfiguration: {
    services.borgmatic.configurations.${backupName} = {
      archive_name_format = "{hostname}-${backupName}-{now:%Y-%m-%dT%H:%M:%S.%f}";
      repositories = host.services.backups.repositories backupName;
      encryption_passcommand = "cat /run/secrets/backups/password/${backupName}";
      ssh_command = "ssh -p 23 -i ${
        self.nixosConfigurations.${host.hostName}.config.sops.templates."backups_ssh_private_key".path
      }";

      ntfy = {
        server = "https://ntfy.rcia.dev";
        topic = "backups";
        access_token = "{credential file /run/secrets/backups/ntfy_token}";

        finish = {
          title = "Backup job finished";
          message = "Backup job ${host.hostName}/${backupName} finished";
          priority = "low";
          tags =
            if host.services.backups.identifyingIcon != "" then
              "${host.services.backups.identifyingIcon},white_check_mark"
            else
              "white_check_mark";
        };

        fail = {
          title = "Backup job failed";
          message = "Backup job ${host.hostName}/${backupName} failed";
          priority = "max";
          tags =
            if host.services.backups.identifyingIcon != "" then
              "${host.services.backups.identifyingIcon},skull"
            else
              "skull";
        };

        states = [
          "finish"
          "fail"
        ];
      };
    }
    // borgmaticConfiguration;

    sops.secrets."backups/password/${backupName}".owner = "root";
  };

  getFastestRefreshRate =
    host:
    builtins.elemAt (lib.lists.sort (a: b: a > b) (
      lib.mapAttrsToList (_: display: display.refreshRate) host.desktop.displays
    )) 0;

  includeToUsersFromChildren =
    includedAspects:
    (map (aspect: aspect.provides.to-users) (
      filter (aspect: (hasAttr "provides" aspect) && (hasAttr "to-users" aspect.provides)) includedAspects
    ));
in
{
  flake.lib = {
    inherit
      createBackupConfiguration
      getFastestRefreshRate
      includeToUsersFromChildren
      ;
  };
}
