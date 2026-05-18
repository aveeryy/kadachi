{ den, lib, ... }:
let
  inherit (lib)
    attrValues
    concatStringsSep
    elemAt
    filter
    getExe
    map
    mergeAttrsList
    mkOption
    optionals
    optionalAttrs
    optionalString
    singleton
    splitString
    take
    ;
in
{
  den.schema.host =
    { host, ... }:
    with lib.types;
    {
      options.services.wireguard = {
        peerEnabled = mkOption {
          type = bool;
          default = false;
        };
        addresses = mkOption {
          type = listOf str;
        };
        port = mkOption {
          type = int;
          default = 51820;
        };
        publicKey = mkOption {
          type = str;
        };
        isServerPeer = mkOption {
          type = bool;
          default = false;
        };
        allowInternetAccess = mkOption {
          type = bool;
          default = false;
        };
        internetInterface = mkOption {
          type = nullOr str;
          default = null;
        };
        endpoint = mkOption {
          type = nullOr str;
          default =
            if host.services.wireguard.isServerPeer then
              "${host.services.baseDomain}:${toString host.services.wireguard.port}"
            else
              null;
        };
      };
    };

  kasane.services._.wireguard =
    { host }:
    {
      description = "Wireguard VPN configuration";

      nixos =
        { config, pkgs, ... }:
        let
          cfg = host.services.wireguard;
          interfaceName = "kadachi-wg";
          mainSubnetAddress = "10.10.0.0/16";

          toSingleHostAddress = address: "${elemAt (splitString "/" address) 0}/32";

          # There is not a single word in either the Spanish or English language that expresses my hate
          # for this singular function; I hope I never need to use anything other than a /16 subnet.
          # This dreadful mess will exist until this is implemented: https://github.com/NixOS/nix/issues/10387
          to16NetworkAddress =
            address: concatStringsSep "." (take 2 (splitString "." address) ++ [ "0.0/16" ]);

          mustIncludePeer =
            peer:
            peer.services.wireguard.peerEnabled
            && peer.name != host.name
            && (cfg.isServerPeer || peer.services.wireguard.isServerPeer);

          availablePeers = filter mustIncludePeer (attrValues (mergeAttrsList (attrValues den.hosts)));

          kadachiPeers = map (peer: {
            inherit (peer) name;
            inherit (peer.services.wireguard) publicKey endpoint;
            allowedIPs =
              if cfg.isServerPeer then
                map toSingleHostAddress peer.services.wireguard.addresses
              else if cfg.allowInternetAccess && peer.services.wireguard.allowInternetAccess then
                singleton "0.0.0.0/0"
              else
                map to16NetworkAddress peer.services.wireguard.addresses;
            presharedKeyFile =
              config.sops.secrets."wireguard/${interfaceName}/preshared_keys/${peer.name}".path;
          }) availablePeers;
        in
        {
          networking = {
            firewall.allowedUDPPorts =
              singleton
                config.networking.wireguard.interfaces.${interfaceName}.listenPort;
            nat = optionalAttrs (cfg.isServerPeer && cfg.allowInternetAccess) {
              enable = true;
              externalInterface = cfg.internetInterface;
              internalInterfaces = singleton interfaceName;
            };
            wireguard = {
              enable = true;
              interfaces.${interfaceName} = {
                ips = cfg.addresses;
                listenPort = cfg.port;
                privateKeyFile = config.sops.secrets."wireguard/${interfaceName}/private_key".path;
                postSetup = optionalString (cfg.isServerPeer && cfg.allowInternetAccess) ''
                  ${getExe pkgs.iptables} -t nat -A POSTROUTING -s ${mainSubnetAddress} -o ${cfg.internetInterface} -j MASQUERADE
                '';
                postShutdown = optionalString (cfg.isServerPeer && cfg.allowInternetAccess) ''
                  ${getExe pkgs.iptables} -t nat -D POSTROUTING -s ${mainSubnetAddress} -o ${cfg.internetInterface} -j MASQUERADE
                '';
                peers =
                  kadachiPeers
                  ++ (optionals (cfg.isServerPeer) [
                    {
                      allowedIPs = [ "10.10.1.1/32" ];
                      name = "Pixel9a";
                      publicKey = "Y5A5iv0ukg1TQMcIdtXd+bmDxtrqHCuoEhYRmBqwkFY=";
                      presharedKeyFile = config.sops.secrets."wireguard/${interfaceName}/preshared_keys/Pixel9a".path;
                    }
                  ]);
              };
            };
          };

          sops.secrets = {
            "wireguard/${interfaceName}/private_key".owner = "root";
          }
          // mergeAttrsList (
            map (peer: {
              "wireguard/${interfaceName}/preshared_keys/${peer.name}".owner = "root";
            }) availablePeers
          )
          // optionalAttrs (cfg.isServerPeer) {
            "wireguard/${interfaceName}/preshared_keys/Pixel9a".owner = "root";
          };
        };
    };
}
