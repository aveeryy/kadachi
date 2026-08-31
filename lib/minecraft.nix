{ lib, ... }:
let
  inherit (lib)
    elemAt
    filterAttrs
    mapAttrs
    optional
    optionals
    splitString
    ;

  players = {
    gbrii = "b65a1bc3-c6a0-4e8c-99b8-3538cfec0cfc";
    dankoszz = "87b47db0-4dd3-469c-8dfd-c21095dadd93";
    Santos_H = "6bbfc884-43e0-48b6-81d3-bb52654db44d";
    PableteOmg12 = "34c4db29-0112-4ae1-b3ee-48fb59b3311c";
  };

  getActiveServers =
    servers: filterAttrs (name: server: name != "main-proxy" && server.enable) servers;

  getBackupPathsForServer =
    serverName: serverCfg:
    let
      # Starting with Minecraft 26.1, the Nether and The End dimensions are now located
      # in a subdirectory in the main world's directory
      gameVersion = elemAt (splitString "-" serverCfg.package.version) 0;
      oldWorldFormat = gameVersion < "26.1";

      worldName = serverCfg.serverProperties.level-name or "world";
      baseWorldPath = "${serverName}/${worldName}";

      imperativeBannedPlayers = serverCfg.bannedPlayers == { };
      imperativeOperators = serverCfg.operators == { };
      imperativeWhitelist = serverCfg.whitelist == { };
    in
    [
      baseWorldPath
      "${serverName}/banned-ips.json"
    ]
    ++ optionals oldWorldFormat [
      "${baseWorldPath}_nether"
      "${baseWorldPath}_the_end"
    ]
    ++ optional imperativeBannedPlayers "${serverName}/banned-players.json"
    ++ optional imperativeOperators "${serverName}/ops.json"
    ++ optional imperativeWhitelist "${serverName}/whitelist.json";

  getBackupPaths =
    minecraftCfg:
    mapAttrs (
      serverName: serverCfg:
      map (path: "${minecraftCfg.dataDir}/${path}") (getBackupPathsForServer serverName serverCfg)
    ) (getActiveServers minecraftCfg.servers);

in
{
  inherit
    getActiveServers
    getBackupPaths
    getBackupPathsForServer
    players
    ;
}
