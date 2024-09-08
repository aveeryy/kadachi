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
  };

  environment.systemPackages = with pkgs; [ amf-headers ffmpeg-full ];

  hardware.i2c.enable = true;

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
      ubuntu-sans
      (nerdfonts.override { fonts = [ "Iosevka" "UbuntuMono" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Ubuntu Sans" ];
        sansSerif = [ "Ubuntu Sans" ];
        monospace = [ "Ubuntu Mono Nerd Font" ];
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
    gvfs.enable = true;
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
  };
  systemd = { services = { NetworkManager-wait-online.enable = false; }; };

  sops = {
    defaultSopsFile = "/etc/nixos/secrets/totsugeki.yaml";
    age.keyFile = "/home/avery/.config/sops/age/keys.txt";
  };

  system.stateVersion = "24.05";

  users.users.avery.extraGroups = [ "corectrl" ];
}
