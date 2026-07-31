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
        home.activation.ensureObsidianVaults = lib.hm.dag.entryAfter [ "writeBoundary" ] (
          concatLines (map (path: ''run mkdir -p "$HOME/${path}"'') vaultPaths)
        );
        # home.packages = [
        #   (inputs'.kadachi-nvim.packages.kadachi-nvim.override {
        #     obsidianWorkspaces = [ ];
        #   })
        # ];

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
