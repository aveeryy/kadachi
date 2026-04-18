{ self, lib, ... }:
let
  inherit (lib) map filter recursiveUpdate;
  inherit (lib.attrsets) hasAttr isAttrs optionalAttrs;

  createBackupConfiguration = backupName: host: borgmaticConfiguration: {
    services.borgmatic.configurations.${backupName} = (
      createBackupConfiguration' backupName host borgmaticConfiguration
    );

    sops.secrets = optionalAttrs ((getHostConfig host.hostName).services.borgmatic.enable) {
      "backups/password/${backupName}".owner = "root";
    };
  };

  createBackupConfiguration' =
    backupName: host: borgmaticConfiguration:
    recursiveUpdate {
      archive_name_format = "{hostname}-${backupName}-{now:%Y-%m-%dT%H:%M:%S.%f}";
      repositories = host.services.backups.repositories backupName;
      encryption_passphrase = "{credential file /run/secrets/backups/password/${backupName}}";
      ssh_command = "ssh -p 23 -i ${
        (getHostConfig host.hostName).sops.templates."backups_ssh_private_key".path
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
    } borgmaticConfiguration;

  getHostConfig = hostName: self.nixosConfigurations.${hostName}.config;

  isAttrSetEmpty = attrset: (lib.length (lib.attrsets.attrsToList attrset)) == 0;

  getAsset = assetName: "${self}/modules/assets/${assetName}";

  getFastestRefreshRate =
    host:
    builtins.elemAt (lib.lists.sort (a: b: a > b) (
      lib.mapAttrsToList (_: display: display.refreshRate) host.desktop.displays
    )) 0;

  includeToUsersFromChildren =
    includedAspects:
    (map (aspect: aspect.provides.to-users) (
      filter (
        aspect: (isAttrs aspect) && (hasAttr "provides" aspect) && (hasAttr "to-users" aspect.provides)
      ) includedAspects
    ));
in
{
  flake.lib = {
    inherit
      createBackupConfiguration
      createBackupConfiguration'
      getAsset
      getFastestRefreshRate
      getHostConfig
      includeToUsersFromChildren
      isAttrSetEmpty
      ;
  };
}
