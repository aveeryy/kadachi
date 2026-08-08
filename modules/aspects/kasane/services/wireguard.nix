{
  den,
  kadachi-lib,
  lib,
  ...
}:
let
  inherit (lib)
    concatStringsSep
    elemAt
    filter
    flatten
    getExe
    map
    mergeAttrsList
    mkOption
    optionalAttrs
    optionalString
    removeSuffix
    singleton
    splitString
    take
    toLower
    ;

  inherit (kadachi-lib)
    getAllHosts
    ;
in
{
  den.schema.host =
    { host, ... }:
    with lib.types;
    {
      options.services.wireguard = {
        addresses = mkOption {
          type = listOf str;
          default = [ ];
        };
        port = mkOption {
          type = int;
          default = 51820;
        };
        publicKey = mkOption {
          type = nullOr str;
          default = null;
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

          hasWireguardConfigured =
            host: host.services.wireguard.addresses != [ ] && host.services.wireguard.publicKey != null;

          mustIncludePeer =
            peer: peer.name != host.name && (cfg.isServerPeer || peer ? endpoint && peer.endpoint != null);

          getPeerInternalDomains =
            peer:
            let
              address = removeSuffix "/32" (elemAt peer.allowedIPs 0);
            in
            [
              (toLower "/${peer.name}.wg.rcia.dev/${address}")
              (toLower "/.${peer.name}.wg.rcia.dev/${address}")
            ];

          hostsWithConfiguredWireguard = filter hasWireguardConfigured (getAllHosts den.hosts);

          kadachiPeers = map (
            host:
            let
              peerCfg = host.services.wireguard;
              hostAddresses = map toSingleHostAddress host.services.wireguard.addresses;
            in
            {
              inherit (host) name;
              inherit (peerCfg) publicKey endpoint;
              allowedIPs =
                if cfg.isServerPeer || !cfg.isServerPeer && !peerCfg.isServerPeer then
                  hostAddresses
                else if cfg.allowInternetAccess && peerCfg.allowInternetAccess then
                  hostAddresses ++ [ "0.0.0.0/0" ]
                else
                  hostAddresses ++ (map to16NetworkAddress peerCfg.addresses);
              presharedKeyFile =
                config.sops.secrets."wireguard/${interfaceName}/preshared_keys/${host.name}".path;
            }
          ) hostsWithConfiguredWireguard;

          nonKadachiPeers = [
            {
              allowedIPs = [ "10.10.2.1/32" ];
              name = "Pixel9a";
              publicKey = "Y5A5iv0ukg1TQMcIdtXd+bmDxtrqHCuoEhYRmBqwkFY=";
              presharedKeyFile = config.sops.secrets."wireguard/${interfaceName}/preshared_keys/Pixel9a".path;
            }
          ];

          # All peers in network
          absolutelyAllPeers = kadachiPeers ++ nonKadachiPeers;
          # Peers that will be included in the configuration file
          peers = filter mustIncludePeer (kadachiPeers ++ nonKadachiPeers);
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
              useNetworkd = false;
              interfaces.${interfaceName} = {
                inherit peers;
                ips = cfg.addresses;
                listenPort = cfg.port;
                privateKeyFile = config.sops.secrets."wireguard/${interfaceName}/private_key".path;
                postSetup = optionalString (cfg.isServerPeer && cfg.allowInternetAccess) ''
                  ${getExe pkgs.iptables} -t nat -A POSTROUTING -s ${mainSubnetAddress} -o ${cfg.internetInterface} -j MASQUERADE
                '';
                postShutdown = optionalString (cfg.isServerPeer && cfg.allowInternetAccess) ''
                  ${getExe pkgs.iptables} -t nat -D POSTROUTING -s ${mainSubnetAddress} -o ${cfg.internetInterface} -j MASQUERADE
                '';
              };
            };
          };

          services = {
            dnsmasq = {
              enable = true;
              settings = {
                address = flatten (map getPeerInternalDomains absolutelyAllPeers);
                bind-interfaces = true;
                listen-address = "127.0.0.1";
                server =
                  if host.name != "greatyamada" then
                    (singleton "10.10.0.1")
                  else
                    [
                      "9.9.9.9"
                      "1.1.1.1"
                    ];
              };
            };
            resolved.settings.Resolve.CacheFromLocalhost = true;
          };

          sops.secrets = {
            "wireguard/${interfaceName}/private_key".owner = "root";
          }
          // mergeAttrsList (
            map (peer: {
              "wireguard/${interfaceName}/preshared_keys/${peer.name}".owner = "root";
            }) peers
          )
          // optionalAttrs (cfg.isServerPeer) {
            "wireguard/${interfaceName}/preshared_keys/Pixel9a".owner = "root";
          };

          systemd.network.wait-online.ignoredInterfaces = singleton "kadachi-wg";
        };
    };
}
