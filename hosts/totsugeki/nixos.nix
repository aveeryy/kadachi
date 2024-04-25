{ config, lib, pkgs, ... }: {
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

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/144857c7-877b-46c7-94d9-30a6d6d27cf0";
      fsType = "btrfs";
      options = [ "compress=zstd:15" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/8084-F762";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/4bbd6139-7caa-4617-a94f-b185c5f6ca45";
      fsType = "btrfs";
      options = [ "compress=zstd:15" ];
    };

    "/mnt/Datos" = {
      device = "/dev/disk/by-uuid/994ef2bd-a9fb-4414-9a0a-19b150ffa452";
      fsType = "btrfs";
      options = [ "compress=zstd:15" "user" "x-systemd.automount" "exec" ];
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 1111 42595 ];
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
    hyprland.enable = true;
    steam.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  services = {
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "avery";
        };
        default_session = initial_session;
      };
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
  };
  systemd = { services = { NetworkManager-wait-online.enable = false; }; };

  sops = {
    defaultSopsFile = "/etc/nixos/secrets/totsugeki.yaml";
    age.keyFile = "/home/avery/.config/sops/age/keys.txt";
  };

  system.stateVersion = "24.05";
}
