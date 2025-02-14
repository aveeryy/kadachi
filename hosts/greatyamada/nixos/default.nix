{ lib, ... }: {
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

  system.stateVersion = "25.05";

  time.timeZone = "UTC";
}
