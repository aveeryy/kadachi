{ lib, ... }:
let
  inherit (builtins)
    attrValues
    ;

  inherit (lib)
    concatLines
    mapAttrs'
    mkOverride
    nameValuePair
    replaceString
    singleton
    ;
in
{
  kasane.tools._.obsidian = { host, user }: {
    homeManager =
      {
        config,
        inputs',
        lib,
        ...
      }:
      let
        removeHomeDirectory = path: replaceString "${config.home.homeDirectory}/" "" path;

        vaultPaths = map (vault: vault.target) (attrValues config.programs.obsidian.vaults);
      in
      {
        home.activation = {
          ensureObsidianVaults = lib.hm.dag.entryAfter [ "writeBoundary" ] (
            concatLines (
              map (path: /* bash */ ''
                run mkdir -p "$HOME/${path}"
                run mkdir -p "$HOME/${path}/Diarias"
              '') vaultPaths
            )
          );
          # Syncthing doesn't support resolving symlinks, so when syncing to a non-NixOS device
          # the symlink would be copied, which then the Obsidian app would discard and replace
          # with an empty configuration file
          replaceSymlinkWithFile = lib.hm.dag.entryAfter [ "linkGeneration" ] (
            concatLines (
              map (path: /* bash */ ''
                for file in $(find "$HOME/${path}" -type l); do
                  run cp -r $(readlink -e "$file") "''${file}.tmp" && rm -rf "$file" && mv "''${file}.tmp" "$file"
                done
                # Clean backup files
                for file in $(find "$HOME/${path}" -name '*.bak'); do
                  run chmod -R 777 "$file" && rm -rf "$file" 
                done
              '') vaultPaths
            )
          );

        };

        programs.obsidian = {
          enable = true;
          vaults = {
            Personal = {
              target = mkOverride 500 (removeHomeDirectory "${config.xdg.userDirs.documents}/Notas/Personal");
            };
            Trabajo = {
              target = mkOverride 500 (removeHomeDirectory "${config.xdg.userDirs.documents}/Notas/Trabajo");
            };
          };
        };
      };

    syncthingFolders =
      { config, ... }:
      mapAttrs' (
        name: vault:
        nameValuePair "Obsidian [${name}]" ({
          devices = singleton host.hostName;
          path.${host.hostName} = "${config.home.homeDirectory}/${vault.target}";
        })
      ) (config.programs.obsidian.vaults);
  };
}
