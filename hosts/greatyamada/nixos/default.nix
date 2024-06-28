{ config, lib, pkgs }: {
  imports = [ ./filesystems.nix ];
  networking = {
    firewall.enable = true;
    hostName = "greatyamada";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault false;
  };

  sops = {
    defaultSopsFile = "/etc/nixos/secrets/greatyamada.yaml";
    age.keyFile = "/etc/nixos/keys.txt";
  };

  time.timeZone = "UTC";
}
