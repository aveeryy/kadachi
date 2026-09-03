{ inputs, ... }: {
  hosts.mizuki = {
    nixos = { config, ... }: {
      services.openvpn.servers.bisite = {
        autoStart = false;
        config = "config ${config.sops.secrets."bisite.ovpn".path}";
      };

      sops.secrets."bisite.ovpn" = {
        sopsFile = "${inputs.secrets}/mizuki/vpn.ovpn";
        format = "binary";
      };
    };
  };
}
