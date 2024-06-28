{ config, lib, pkgs, ... }: {

  imports = [ ./filesystems.nix ./plasma.nix ./steam.nix ];

  boot = {
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "video=DP-1:2560x1440@165" ];
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        gfxmodeEfi = "2560x1440";
        useOSProber = true;
      };
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8000 42595 ];
      allowedUDPPorts = [ 24642 ];
    };
    hostName = "totsugeki";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;
  };

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Europe/Madrid";
  };

  i18n.defaultLocale = "es_ES.UTF-8";

  nixpkgs.config.allowUnfree = true;

  fonts = {
    packages = with pkgs; [
      inter
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Inter" ];
        sansSerif = [ "Inter" ];
        monospace = [ "Iosevka Nerd Font" ];
      };
    };
  };

  programs = {
    corectrl = {
      enable = true;
      gpuOverclock.enable = true;
    };
    nix-ld.enable = true;
  };

  xdg.portal.enable = true;

  services = {
    jellyfin = {
      enable = true;
      openFirewall = true;
    };
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
    udisks2.enable = true;
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666"
    '';
    displayManager = {
      defaultSession = "plasma";
      sddm = {
        enable = true;
        wayland.enable = true;
      };
    };
  };
  systemd = { services = { NetworkManager-wait-online.enable = false; }; };

  sops = {
    defaultSopsFile = "/etc/nixos/secrets/totsugeki.yaml";
    age.keyFile = "/home/avery/.config/sops/age/keys.txt";
  };

  system.stateVersion = "24.05";

  users.users.avery.extraGroups = [ "corectrl" ];
}
