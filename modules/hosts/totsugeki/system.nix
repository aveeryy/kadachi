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
    services.backups = {
      identifyingIcon = "dolphin";
      repositories = jobName: [
        {
          path = "ssh://u541128@u541128.your-storagebox.de:23//home/borgmatic/${jobName}/";
          label = "${jobName}@hetzner-de";
        }
      ];
    };
    users.avery = { };
  };

  den.aspects.totsugeki = {
    description = "Main computer";

    includes = [
      <megurine/has/amd-cpu>
      <megurine/has/amd-cpu/kvm>
      <megurine/requires/secure-boot>

      <adachi/desktop>
      <adachi/desktop/hyprland>
      <adachi/system/cachyos-kernel>

      <kasane/services/backups>
    ];

    nixos =
      {
        pkgs,
        lib,
        config,
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
          kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto;
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

        networking.firewall.allowedTCPPorts = [ 42595 ];

        services.pipewire.wireplumber.extraConfig."no-node-suspension"."monitor.alsa.rules" = [
          {
            matches = [
              { "node.name" = "~alsa_output.*"; }
            ];
            actions.update-props."session.suspend-timeout-seconds" = 0;
          }
        ];

        systemd.services.NetworkManager-wait-online.enable = false;

        virtualisation.docker.enable = true;

        time.timeZone = "Europe/Madrid";
      };
  };
}
