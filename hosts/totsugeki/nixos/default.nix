{ lib, pkgs, ... }: {

  imports = [ ./filesystems.nix ./steam.nix ];

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
    supportedFilesystems = [ "ntfs" ];
  };

  environment.systemPackages = with pkgs; [ ffmpeg-full gparted ];

  hardware.i2c.enable = true;

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 8000 42595 1420 ];
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

  i18n = {
    defaultLocale = "es_ES.UTF-8";
    supportedLocales = [
      "C.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
      "es_ES.UTF-8/UTF-8"
      "ja_JP.UTF-8/UTF-8" # Monster Hunter Frontier Z Zenith
    ];
  };

  nixpkgs.config.allowUnfree = true;

  fonts = {
    packages = with pkgs; [
      inter
      ubuntu-sans
      twitter-color-emoji
      (nerdfonts.override { fonts = [ "Iosevka" "UbuntuMono" ]; })
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
    dconf.enable = true;
    nix-ld.enable = true;
  };

  security.polkit = { enable = true; };

  xdg.portal = {
    config.common = {
      default = "gtk";
      "org.freedesktop.impl.portal.ScreenCast" = "wlr";
    };
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    wlr = {
      enable = true;
      settings = {
        screencast = {
          output_name = "DP-1";
          max_fps = 165;
          chooser_type = "simple";
          chooser_cmd = "${pkgs.slurp}/bin/slurp -f %o -or";
        };
      };
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    gvfs.enable = true;
    jellyfin = {
      enable = false;
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
    printing = {
      enable = true;
      drivers = with pkgs; [ brlaser ];
    };
    udisks2.enable = true;
    udev.extraRules = ''
      SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="3000", MODE="0666"
    '';
  };
  systemd = { services = { NetworkManager-wait-online.enable = false; }; };

  sops = {
    defaultSopsFile = "/etc/nixos/secrets/greatyamada.yaml";
    age.keyFile = "/home/avery/.config/sops/age/keys.txt";
  };

  virtualisation.virtualbox.host.enable = true;

  system.stateVersion = "24.05";

  users.users.avery.extraGroups = [ "corectrl" ];
}
