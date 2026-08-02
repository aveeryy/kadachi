{
  den,
  inputs,
  lib,
  kadachi-lib,
  ...
}:
let
  inherit (builtins)
    attrNames
    attrValues
    elem
    listToAttrs
    filter
    hasAttr
    mapAttrs
    ;

  inherit (lib)
    concatLines
    filterAttrs
    hasPrefix
    mkOption
    replaceString
    singleton
    ;

  inherit (lib.types)
    attrsOf
    nullOr
    str
    ;

  inherit (kadachi-lib)
    getAllHosts
    recursiveMerge
    ;

  extraDevices = {
    avery.pixel9a.id = "FADOVR6-65UKNE3-CNTQ5UY-ZY6GXW7-G3SRCAD-UO2VLEO-D6O5EWE-XIEYUAC";
  };

  userFolderOverrides = {
    avery = allDevices: {
      "Obsidian [Personal]".devices = [ "pixel9a" ];
      "Obsidian [Trabajo]".devices = [ "pixel9a" ];
      "Kadachi Documentation".devices = [ "pixel9a" ];
      Pixel9aBackup = {
        devices = filter (device: device != "mizuki") (attrNames allDevices);
        path = "~/Backups/Pixel9a";
        type = "receiveonly";
      };
    };
  };
in
{
  den.policies.syncthing-expose =
    { host, user, ... }:
    let
      inherit (den.lib.policy) pipe;
      targetUser = user;
    in
    [
      (pipe.from "syncthingFolders" [
        (pipe.collectAll (
          { host, user, ... }:
          user.userName == targetUser.userName && user.services.syncthing.deviceId != null
        ))
      ])
    ];

  den.schema.user = { user, ... }: {
    options.services.syncthing = {
      deviceId = mkOption {
        type = nullOr str;
        default = null;
      };
      folderOverrides = mkOption {
        type = attrsOf str;
        default = { };
      };
    };
  };

  kasane.services._.syncthing =
    { host, user }:
    let
      intoSyncthingDevice = otherHost: ({
        name = otherHost.hostName;
        value.id = otherHost.users.${user.userName}.services.syncthing.deviceId;
      });

      hasSyncthingConfigured =
        otherHost:
        otherHost.users ? "${user.userName}"
        && otherHost.users.${user.userName}.services.syncthing.deviceId != null;

      kadachiDevices = listToAttrs (
        map intoSyncthingDevice (filter hasSyncthingConfigured (getAllHosts den.hosts))
      );

      devices = kadachiDevices // (extraDevices.${user.userName} or { });
    in
    {
      includes = [
        den.policies.syncthing-expose
      ];

      nixos = {
        sops.secrets = {
          "syncthing/${user.userName}/cert" = {
            sopsFile = "${inputs.secrets}/${host.hostName}/syncthing/${user.userName}/cert.pem";
            format = "binary";
            owner = user.userName;
          };
          "syncthing/${user.userName}/key" = {
            sopsFile = "${inputs.secrets}/${host.hostName}/syncthing/${user.userName}/key.pem";
            format = "binary";
            owner = user.userName;
          };
        };
      };

      homeManager =
        {
          config,
          lib,
          osConfig,
          syncthingFolders,
          ...
        }:
        let
          folderPathsInHome = map (folder: replaceString "~" config.home.homeDirectory folder.path) (
            filter (folder: hasPrefix config.home.homeDirectory folder.path || hasPrefix "~" folder.path) (
              attrValues config.services.syncthing.settings.folders
            )
          );

          isFolderValid = _: folder: hasAttr "path" folder && elem host.hostName folder.devices;

          filterOutInvalidFolders = folders: filterAttrs isFolderValid folders;

          setHostPath = _: folder: folder // { path = folder.path.${host.hostName}; };

          processModuleFolders = array: singleton (mapAttrs setHostPath (recursiveMerge array));
        in
        {
          home.activation.ensureSyncthingDirectories = lib.hm.dag.entryAfter [ "writeBoundary" ] (
            concatLines (map (path: ''run mkdir -p "${path}"'') folderPathsInHome)
          );

          services.syncthing = {
            enable = true;
            cert = osConfig.sops.secrets."syncthing/${user.userName}/cert".path;
            key = osConfig.sops.secrets."syncthing/${user.userName}/key".path;
            settings = {
              inherit devices;
              folders = filterOutInvalidFolders (
                recursiveMerge (
                  # Default sync folder
                  singleton {
                    "Sync" = {
                      devices = attrNames devices;
                      path = "${config.home.homeDirectory}/Sync";
                    };
                  }
                  # Folders from other modules
                  ++ (processModuleFolders syncthingFolders)
                  # Per-user overrides
                  ++ singleton (userFolderOverrides.${user.userName} or (_: { }) devices)
                  # Per-user-and-host overrides
                  ++ singleton user.services.syncthing.folderOverrides
                )
              );
              options.urAccepted = -1;
            };
          };
        };
    };
}
