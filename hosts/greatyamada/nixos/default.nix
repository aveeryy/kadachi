{ lib, pkgs, ... }: {
  imports = [ ./filesystems.nix ];

  boot.loader.systemd-boot.enable = true;

  environment.systemPackages = with pkgs; [ iptables ];

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
