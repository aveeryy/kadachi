{ ... }:
let portDefinitions = import ./_port-definitions.nix;
in {
  networking = {
    firewall.allowedUDPPorts = [ portDefinitions.wireguard ];
    wireguard = {
      enable = true;
      interfaces.wg0 = {
        ips = [ "10.10.0.1/24" ];
        peers = [{
          allowedIPs = [ "10.10.0.2/32" ];
          name = "Note9";
          publicKey = "Y5A5iv0ukg1TQMcIdtXd+bmDxtrqHCuoEhYRmBqwkFY=";
          presharedKeyFile = "/run/secrets/preshared_keys_note9";
        }];
        postSetup =
          "iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o enp5s0 -j MASQUERADE";
        postShutdown =
          "iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o enp5s0 -j MASQUERADE";
        privateKeyFile = "/run/secrets/wg_private_key";
      };
    };
  };
  sops.secrets = {
    "wireguard/private_key" = {
      path = "/run/secrets/wg_private_key";
      owner = "root";
    };
    "wireguard/preshared_keys/note9" = {
      path = "/run/secrets/preshared_keys_note9";
      owner = "root";
    };
  };
}
