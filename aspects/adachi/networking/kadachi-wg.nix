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
    mapAttrs'
    mergeAttrsList
    mkDefault
    mkForce
    mkOption
    nameValuePair
    optionalAttrs
    optionalString
    removeSuffix
    singleton
    splitString
    take
    toLower
    ;

  inherit (lib.types)
    bool
    int
    listOf
    nullOr
    str
    ;

  inherit (kadachi-lib)
    constants
    getAllHosts
    ;

  address = constants.networks.kadachi-wg;
  domain = constants.wireguardBaseDomain;
in
{
  den.schema.host = { host, ... }: {
    options.networking.kadachi-wg = {
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
          if host.networking.kadachi-wg.isServerPeer then
            "${host.services.internetDomain}:${toString host.networking.kadachi-wg.port}"
          else
            null;
      };
    };
  };

  adachi.networking._.kadachi-wg = { host }: {
    description = "Wireguard VPN configuration for cross-host communication and private services";

    nixos =
      { config, pkgs, ... }:
      let
        cfg = host.networking.kadachi-wg;

        iptables = getExe pkgs.iptables;

        toSingleHostAddress = address: "${elemAt (splitString "/" address) 0}/32";

        # There is not a single word in either the Spanish or English language that expresses my hate
        # for this singular function; I hope I never need to use anything other than a /16 subnet.
        # This dreadful mess will exist until this is implemented: https://github.com/NixOS/nix/issues/10387
        to16NetworkAddress =
          address: concatStringsSep "." (take 2 (splitString "." address) ++ singleton "0.0/16");

        hasWireguardConfigured =
          host: host.networking.kadachi-wg.addresses != [ ] && host.networking.kadachi-wg.publicKey != null;

        mustIncludePeer =
          peer: peer.name != host.name && (cfg.isServerPeer || peer ? endpoint && peer.endpoint != null);

        getPeerInternalDomains =
          peer:
          let
            address = removeSuffix "/32" (elemAt peer.allowedIPs 0);
          in
          [
            (toLower "/${peer.name}.${domain}/${address}")
            (toLower "/.${peer.name}.${domain}/${address}")
          ];

        hostsWithConfiguredWireguard = filter hasWireguardConfigured (getAllHosts den.hosts);

        kadachiPeers = map (
          host:
          let
            peer = host.networking.kadachi-wg;
            hostAddresses = map toSingleHostAddress peer.addresses;
          in
          {
            inherit (host) name;
            inherit (peer) publicKey endpoint;
            allowedIPs =
              if cfg.isServerPeer || !cfg.isServerPeer && !peer.isServerPeer then
                hostAddresses
              else if cfg.allowInternetAccess && peer.allowInternetAccess then
                hostAddresses ++ singleton "0.0.0.0/0"
              else
                hostAddresses ++ map to16NetworkAddress peer.addresses;
            presharedKeyFile = config.sops.secrets."wireguard/kadachi-wg/preshared_keys/${host.name}".path;
          }
        ) hostsWithConfiguredWireguard;

        nonKadachiPeers = [
          {
            name = "Pixel9a";
            allowedIPs = singleton "10.10.2.1/32";
            publicKey = "Y5A5iv0ukg1TQMcIdtXd+bmDxtrqHCuoEhYRmBqwkFY=";
            presharedKeyFile = config.sops.secrets."wireguard/kadachi-wg/preshared_keys/Pixel9a".path;
          }
        ];

        # All peers in network
        allPeers = kadachiPeers ++ nonKadachiPeers;
        # Peers that will be included in the configuration file
        peers = filter mustIncludePeer (kadachiPeers ++ nonKadachiPeers);
      in
      {
        networking = {
          firewall.allowedUDPPorts = singleton cfg.port;

          nat = optionalAttrs (cfg.isServerPeer && cfg.allowInternetAccess) {
            enable = true;
            externalInterface = cfg.internetInterface;
            internalInterfaces = singleton "kadachi-wg";
          };

          networkmanager = {
            dns = mkForce "none";
            unmanaged = singleton "kadachi-wg";
          };

          wireguard = {
            enable = true;
            useNetworkd = false;
            interfaces.kadachi-wg = {
              inherit peers;
              ips = cfg.addresses;
              listenPort = cfg.port;
              privateKeyFile = config.sops.secrets."wireguard/kadachi-wg/private_key".path;
              postSetup = optionalString (cfg.isServerPeer && cfg.allowInternetAccess) ''
                ${iptables} -t nat -A POSTROUTING -s ${address} -o ${cfg.internetInterface} -j MASQUERADE
              '';
              postShutdown = optionalString (cfg.isServerPeer && cfg.allowInternetAccess) ''
                ${iptables} -t nat -D POSTROUTING -s ${address} -o ${cfg.internetInterface} -j MASQUERADE
              '';
            };
          };
        };

        security.acme.certs = optionalAttrs (host.services.internetDomain != null) {
          ${host.services.internetDomain}.extraDomainNames = [
            "${host.name}.${domain}"
            "*.${host.name}.${domain}"
          ];
        };

        services = {
          dnsmasq = {
            enable = true;
            settings = {
              address = flatten (map getPeerInternalDomains allPeers);
              bind-interfaces = true;
              listen-address = "127.0.0.1";
              server = mkDefault [
                "10.10.0.1"
                "85.208.114.51"
              ];
            };
          };

          resolved.settings.Resolve = {
            CacheFromLocalhost = true;
            DNSStubListener = false;
          };
        };

        sops.secrets = {
          "wireguard/kadachi-wg/private_key".owner = "root";
        }
        // mergeAttrsList (
          map (peer: {
            "wireguard/kadachi-wg/preshared_keys/${peer.name}".owner = "root";
          }) peers
        )
        // optionalAttrs (cfg.isServerPeer) {
          "wireguard/kadachi-wg/preshared_keys/Pixel9a".owner = "root";
        };

        systemd.network = {
          networks = mapAttrs' (
            name: config:
            nameValuePair ("0-interface-${name}") ({
              dhcpV4Config.UseDNS = false;
              dhcpV6Config.UseDNS = false;
            })
          ) host.networking.interfaces;

          wait-online.ignoredInterfaces = singleton "kadachi-wg";
        };
      };
  };
}
