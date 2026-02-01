{ ... }:
let
  externalInterface = "enp5s0";
in
{
  den.aspects.greatyamada.nixos =
    { pkgs, config, ... }:
    {
      networking = {
        nat = {
          enable = true;
          externalInterface = externalInterface;
          internalInterfaces = [ "wg0" ];
        };
        firewall.allowedUDPPorts = [ 51820 ];
        wireguard = {
          enable = true;
          interfaces.wg0 = {
            ips = [ "10.10.0.1/24" ];
            listenPort = 51820;
            peers = [
              {
                allowedIPs = [ "10.10.0.2/32" ];
                name = "Pixel9a";
                publicKey = "Y5A5iv0ukg1TQMcIdtXd+bmDxtrqHCuoEhYRmBqwkFY=";
                presharedKeyFile = config.sops.secrets."wireguard/wg0/preshared_keys/pixel9a".path;
              }
            ];
            postSetup = ''
              ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.10.0.0/24 -o ${externalInterface} -j MASQUERADE
            '';
            postShutdown = ''
              ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.10.0.0/24 -o ${externalInterface} -j MASQUERADE
            '';
            privateKeyFile = config.sops.secrets."wireguard/wg0/private_key".path;
          };
        };
      };
      sops.secrets = {
        "wireguard/wg0/private_key" = {
          owner = "root";
        };
        "wireguard/wg0/preshared_keys/pixel9a" = {
          owner = "root";
        };
      };

    };
}
