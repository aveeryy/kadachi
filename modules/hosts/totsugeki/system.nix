{ __findFile, ... }:
{
  den.hosts.x86_64-linux.totsugeki = {
    desktop = {
      displays."DP-1" = {
        resolution = "2560x1440";
        refreshRate = 165;
      };
      lockSessionAtStart = true;
    };

    services = {
      backups = {
        identifyingIcon = "dolphin";
        repositories = jobName: [
          {
            path = "ssh://u541128@u541128.your-storagebox.de:23//home/borgmatic/${jobName}/";
            label = "${jobName}@hetzner-de";
          }
        ];
      };

      wireguard = {
        addresses = [ "10.10.1.1/16" ];
        publicKey = "7tijdqEKHVTDcbpSwEYzHidUzXUcH7sTJfleozNnaUU=";
      };
    };

    users.avery = {
      services.syncthing.deviceId = "BCKPJKO-XN7F5XW-B6NYXHH-RBAYJQ2-RMG24JK-DFTGQ2R-T7TLOQZ-PKUOUAV";
    };
  };

  den.aspects.totsugeki = {
    description = "Main computer";

    includes = [
      <megurine/is/desktop>
      <megurine/has/amd-cpu>
      <megurine/has/amd-cpu/kvm>
      <megurine/requires/secure-boot>

      <adachi/desktop/hyprland>
      <adachi/services/podman>
      <adachi/system/cachyos-kernel>

      <kasane/services/backups>
      <kasane/services/wireguard>
    ];

    nixos =
      {
        pkgs,
        lib,
        config,
        inputs',
        ...
      }:
      {
        boot = {
          initrd.availableKernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          kernelPackages = inputs'.nix-cachyos-kernel.legacyPackages.linuxPackages-cachyos-bore-lto;
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

        networking = {
          firewall = {
            allowedTCPPorts = [
              42595
              25210 # qBitTorrent WebUI
            ];
            allowedUDPPorts = [ 34197 ];
          };
        };

        services.pipewire.wireplumber.extraConfig."no-node-suspension"."monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "~alsa_output.*"; }
            ];
            actions.update-props."session.suspend-timeout-seconds" = 0;
          }
        ];

        systemd.network.networks."10-wan" = {
          matchConfig.name = "enp5s0";
          networkConfig.DHCP = "ipv4";
          linkConfig.RequiredForOnline = "routable";
          # DNS is managed by dnsmasq
          dhcpV4Config.UseDNS = false;
          dhcpV6Config.UseDNS = false;
        };

        time.timeZone = "Europe/Madrid";
      };
  };
}
