{ den, ... }: {
  den = {
    quirks = {
      ddnsDomains.description = "Additional DDNS domains";
      monitoredServices.description = "HTTP services that should be monitored";
      shellAliases.description = "Command aliases for shells";
      syncthingFolders.description = "Additional folders to sync with Syncthing";
    };

    policies = {
      collect-monitored-services =
        { host, ... }:
        let
          inherit (den.lib.policy) pipe;
        in
        [
          (pipe.from "monitoredServices" [
            (pipe.collectAll ({ host, ... }: true))
            pipe.withProvenance
          ])
        ];
    };
  };
}
