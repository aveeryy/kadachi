{ self, lib, ... }:
let
  inherit (lib)
    all
    attrValues
    concatLists
    head
    isAttrs
    isList
    last
    mergeAttrsList
    optionalAttrs
    recursiveUpdate
    tail
    unique
    zipAttrsWith
    ;

  createBackupConfiguration = backupName: host: borgmaticConfiguration: {
    services.borgmatic.configurations.${backupName} = (
      createBackupConfiguration' backupName host borgmaticConfiguration
    );

    sops.secrets = optionalAttrs ((getHostConfig host.name).services.borgmatic.enable) {
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
        (getHostConfig host.name).sops.templates."backups_ssh_private_key".path
      }";

      ntfy = {
        server = "https://ntfy.rcia.dev";
        topic = "backups";
        access_token = "{credential file /run/secrets/backups/ntfy_token}";

        finish = {
          title = "Backup job finished";
          message = "Backup job ${host.name}/${backupName} finished";
          priority = "low";
          tags =
            if host.services.backups.identifyingIcon != "" then
              "${host.services.backups.identifyingIcon},white_check_mark"
            else
              "white_check_mark";
        };

        fail = {
          title = "Backup job failed";
          message = "Backup job ${host.name}/${backupName} failed";
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

  copyPathToStore = builtins.filterSource (p: t: true);

  getAsset = assetName: copyPathToStore ../assets/${assetName};

  getFastestRefreshRate =
    host:
    builtins.elemAt (lib.lists.sort (a: b: a > b) (
      lib.mapAttrsToList (_: display: display.refreshRate) host.desktop.displays
    )) 0;

  getAllHosts = hosts: attrValues (mergeAttrsList (attrValues hosts));

  # Slighly modified version of https://stackoverflow.com/a/54505212
  # Under the CC BY-SA 4.0 license: https://creativecommons.org/licenses/by-sa/4.0/
  recursiveMerge =
    attrList:
    let
      inner =
        attrPath:
        zipAttrsWith (
          key: values:
          if tail values == [ ] then
            head values
          else if all isList values then
            unique (concatLists values)
          else if all isAttrs values then
            inner (attrPath ++ [ key ]) values
          else
            last values
        );
    in
    inner [ ] attrList;
in
{
  inherit
    copyPathToStore
    createBackupConfiguration
    createBackupConfiguration'
    getAsset
    getAllHosts
    getFastestRefreshRate
    getHostConfig
    recursiveMerge
    ;

  minecraft = import ./minecraft.nix { inherit lib; };
}
