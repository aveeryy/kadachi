{ config, lib, pkgs, ... }: {
  boot = {
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "video=DP-1:2560x1440@165" ];
    initrd.availableKernelModules =
      [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    loader = {
      systemd-boot = { enable = true; };
      efi.canTouchEfiVariables = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/144857c7-877b-46c7-94d9-30a6d6d27cf0";
      fsType = "btrfs";
      options = [ "compress=zstd:9" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/8084-F762";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/4bbd6139-7caa-4617-a94f-b185c5f6ca45";
      fsType = "btrfs";
      options = [ "compress=zstd:9" ];
    };

    "/mnt/Datos" = {
      device = "/dev/disk/by-uuid/994ef2bd-a9fb-4414-9a0a-19b150ffa452";
      fsType = "btrfs";
      options = [ "compress=zstd:9" "user" "x-systemd.automount" "exec" ];
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

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "Europe/Madrid";

  i18n.defaultLocale = "es_ES.UTF-8";
  console = {
    keyMap = lib.mkForce "dvorak-es";
    useXkbConfig = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    cpu.amd.updateMicrocode =
      lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "x86_64-linux";
  };

  users = {
    defaultUserShell = pkgs.zsh;
    extraGroups.vboxusers.members = [ "avery" ];
    users.avery = {
      extraGroups = [ "wheel" ];
      isNormalUser = true;
    };
  };

  environment = {
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [ htop libjxl neovim ];
  };

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
    zsh.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  security = {
    doas = {
      enable = true;
      extraRules = [{
        users = [ "avery" ];
        keepEnv = true;
        persist = true;
      }];
    };
    rtkit.enable = true;
    sudo.enable = false;
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
    openssh.enable = true;
    udisks2.enable = true;
  };

  systemd = { services = { NetworkManager-wait-online.enable = false; }; };

  system.stateVersion = "24.05";
}
