{ __findFile, lib, ... }:
let
  inherit (lib)
    singleton
    ;
in
{
  den.hosts.x86_64-linux.empoleon = {
    desktop = {
      displays."eDP-1" = {
        resolution = "2880x1920";
        refreshRate = 120;
        scaling = "2";
        primary = true;
      };
    };

    networking = {
      interfaces.wlp0s20f3 = {
        type = "wireless";
        dhcp = "yes";
      };
      kadachi-wg = {
        addresses = singleton "10.10.1.4/16";
        publicKey = "piplUp4pl8ug1uZ1NMw0uRRQ++bIezjxmXZWv5713nc=";
      };
    };

    users.avery = { };
  };

  hosts.empoleon = {
    description = "Personal laptop";

    includes = [
      <megurine/is/desktop>
      <megurine/has/bluetooth>
      <megurine/has/intel-cpu>
      <megurine/has/intel-cpu/kvm>
      <megurine/has/wifi>
      <megurine/requires/secure-boot>

      <adachi/networking/kadachi-wg>
      # <adachi/system/cachyos-kernel>
    ];

    nixos = { pkgs, ... }: {
      boot = {
        initrd.availableKernelModules = [
          "xhci_pci"
          "thunderbolt"
          "nvme"
          "usb_storage"
          "sd_mod"
        ];
        kernelModules = [ "kvm-intel" ];
        kernelParams = [ "nvme.noacpi=1" ];
        blacklistedKernelModules = [ "cros-usbpd-charger" ];
        kernelPackages = pkgs.linuxPackages_latest;
      };
      i18n = {
        defaultLocale = "es_ES.UTF-8";
        supportedLocales = [
          "C.UTF-8/UTF-8"
          "en_US.UTF-8/UTF-8"
          "es_ES.UTF-8/UTF-8"
        ];
      };

      # For fingerprint support
      services.fprintd.enable = true;

      # Custom udev rules
      services.udev.extraRules = ''
        # Ethernet expansion card support
        ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8156", ATTR{power/autosuspend}="20"
      '';

      services.tuned.enable = true;
      services.upower.enable = true;

      time.timeZone = "Europe/Madrid";
    };
  };
}
