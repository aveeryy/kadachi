{ den, lib, ... }:
let
  inherit (lib)
    attrValues
    elemAt
    filter
    getExe
    map
    mergeAttrsList
    mkOption
    optionalAttrs
    optionalString
    splitString
    ;
in
{
  den.schema.host =
    { host, ... }:
    with lib.types;
    {
      options.services.wireguard = {
        nodeEnabled = mkOption {
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
        isMainNode = mkOption {
          type = bool;
          default = false;
        };
        allowInternetAccess = mkOption {
          type = bool;
          default = false;
        };
        internetInterface = mkOption {
          type = nullOr str;
          default = false;
        };
        endpoint = mkOption {
          type = nullOr str;
          default =
            if host.services.wireguard.isMainNode then
              "${host.services.baseDomain}:${toString host.services.wireguard.port}"
            else
              null;
        };
      };
    };

  kasane.services._.wireguard = den.lib.take.exactly (
    { host }:
    {
      description = "Wireguard VPN configuration";

      nixos =
        { config, pkgs, ... }:
        let
          cfg = host.services.wireguard;

          toHostAddress = address: "${elemAt (splitString "/" address) 0}/32";

          availablePeers = filter (other: other.name != host.name && other.services.wireguard.nodeEnabled) (
            attrValues (mergeAttrsList (attrValues den.hosts))
          );

          kadachiPeers = map (peer: {
            name = peer.name;
            allowedIPs = map toHostAddress peer.services.wireguard.addresses;
            publicKey = peer.services.wireguard.publicKey;
            presharedKeyFile = optionalString (
              cfg.isMainNode || peer.services.wireguard.isMainNode
            ) config.sops.secrets."wireguard/wg0/preshared_keys/${peer.name}".path;
            endpoint = peer.services.wireguard.endpoint;
          }) availablePeers;
        in
        {
          networking = {
            firewall.allowedUDPPorts = [ config.networking.wireguard.interfaces.wg0.listenPort ];
            nat = optionalAttrs (cfg.isMainNode && cfg.allowInternetAccess) {
              enable = true;
              externalInterface = cfg.internetInterface;
              internalInterfaces = [ "wg0" ];
            };
            wireguard = {
              enable = true;
              interfaces.wg0 = {
                ips = cfg.addresses;
                listenPort = cfg.port;
                privateKeyFile = config.sops.secrets."wireguard/wg0/private_key".path;
                postSetup = optionalString (cfg.allowInternetAccess) ''
                  ${getExe pkgs.iptables} -t nat -A POSTROUTING -s 10.10.0.0/16 -o ${cfg.internetInterface} -j MASQUERADE
                '';
                postShutdown = optionalString (cfg.allowInternetAccess) ''
                  ${getExe pkgs.iptables} -t nat -D POSTROUTING -s 10.10.0.0/16 -o ${cfg.internetInterface} -j MASQUERADE
                '';
                peers = kadachiPeers ++ [
                  {
                    allowedIPs = [ "10.10.1.1/32" ];
                    name = "Pixel9a";
                    publicKey = "Y5A5iv0ukg1TQMcIdtXd+bmDxtrqHCuoEhYRmBqwkFY=";
                    presharedKeyFile = optionalString (cfg.isMainNode
                    ) config.sops.secrets."wireguard/wg0/preshared_keys/Pixel9a".path;
                  }
                ];
              };
            };
          };

          sops.secrets = {
            "wireguard/wg0/private_key".owner = "root";
          }
          // mergeAttrsList (
            map (peer: {
              "wireguard/wg0/preshared_keys/${peer.name}".owner = "root";
            }) (filter (peer: cfg.isMainNode || peer.services.wireguard.isMainNode) availablePeers)
          )
          // optionalAttrs (cfg.isMainNode) {
            "wireguard/wg0/preshared_keys/Pixel9a".owner = "root";
          };
        };
    }
  );
}
