{ lib, pkgs, ... }: {
  imports = [ ./filesystems.nix ];

  boot = {
    loader.systemd-boot.enable = true;
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    initrd.availableKernelModules =
      [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  environment.systemPackages = with pkgs; [ arion docker-client ];

  networking = {
    firewall.enable = true;
    hostName = "greatyamada";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault false;
    interfaces.enp5s0 = {
      ipv4.addresses = [{
        address = "10.0.0.1";
        prefixLength = 24;
      }];
    };
    defaultGateway = {
      address = "10.0.0.254";
      interface = "enp5s0";
    };
    nameservers = [ "9.9.9.9" ];
  };

  sops = {
    defaultSopsFile = "/etc/nixos/secrets/greatyamada.yaml";
    age.keyFile = "/etc/nixos/keys.txt";
  };

  system.stateVersion = "24.05";

  users = {
    groups.media = { };
    users.avery.extraGroups = [ "media" ];
  };

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  time.timeZone = "UTC";
}
