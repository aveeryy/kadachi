{ pkgs, ... }:
let portDefinitions = import ./_port-definitions.nix;
in {
  networking = {
    nat = {
      enable = true;
      externalInterface = "enp5s0";
      internalInterfaces = [ "wg0" ];
    };
    firewall.allowedUDPPorts = [ portDefinitions.wireguard ];
    wireguard = {
      enable = true;
      interfaces.wg0 = {
        ips = [ "10.10.0.1/24" ];
        listenPort = portDefinitions.wireguard;
        peers = [{
          allowedIPs = [ "10.10.0.2/32" ];
          name = "Pixel9a";
          publicKey = "Y5A5iv0ukg1TQMcIdtXd+bmDxtrqHCuoEhYRmBqwkFY=";
          presharedKeyFile = "/run/secrets/wireguard/preshared_keys/note9";
        }];
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.10.0.0/24 -o enp5s0 -j MASQUERADE
        '';
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.10.0.0/24 -o enp5s0 -j MASQUERADE
        '';
        privateKeyFile = "/run/secrets/wireguard/private_key";
      };
    };
  };
  sops.secrets = {
    "wireguard/private_key" = { owner = "root"; };
    "wireguard/preshared_keys/note9" = { owner = "root"; };
  };
}
