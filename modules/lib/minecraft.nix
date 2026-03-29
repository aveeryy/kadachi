{ kadachi-lib, lib, ... }:
let
  inherit (lib) optionals;
  inherit (lib.attrsets) filterAttrs mapAttrs;
  inherit (kadachi-lib) isAttrSetEmpty;

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
      worldName = serverCfg.serverProperties.level-name or "world";
      baseWorldPath = "${serverName}/${worldName}";

      nonDeclarativeBannedPlayers = isAttrSetEmpty serverCfg.bannedPlayers;
      nonDeclarativeOperators = isAttrSetEmpty serverCfg.operators;
      nonDeclarativeWhitelist = isAttrSetEmpty serverCfg.whitelist;
    in
    [
      baseWorldPath
      "${baseWorldPath}_nether"
      "${baseWorldPath}_the_end"
      "${serverName}/banned-ips.json"
    ]
    ++ optionals (nonDeclarativeBannedPlayers) [
      "${serverName}/banned-players.json"
    ]
    ++ optionals (nonDeclarativeOperators) [
      "${serverName}/ops.json"
    ]
    ++ optionals (nonDeclarativeWhitelist) [
      "${serverName}/whitelist.json"
    ];

  getBackupPaths =
    minecraftCfg:
    mapAttrs (
      serverName: serverCfg:
      map (path: "${minecraftCfg.dataDir}/${path}") (getBackupPathsForServer serverName serverCfg)
    ) (getActiveServers minecraftCfg.servers);

in
{
  flake.lib.minecraft = {
    inherit
      getActiveServers
      getBackupPaths
      getBackupPathsForServer
      players
      ;
  };
}
