{ __findFile, ... }:
{
  den.hosts.x86_64-linux.totsugeki = {
    desktop = {
      displays."DP-1".resolution = "2560x1440@165";
      lockSessionAtStart = true;
    };
    users.avery.aspect = "avery_totsugeki";
  };

  den.aspects = {
    totsugeki = {
      description = "Main computer";

      includes = [
        <adachi/desktop>
        <adachi/desktop/hyprland>
        <adachi/hardware/amd-cpu>
        <adachi/hardware/amd-cpu/kvm>
        <adachi/system/auto-hostname>
        <adachi/system/cachyos-kernel>
        <adachi/system/secure-boot>
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
    avery_totsugeki = {
      includes = [
        <kasane/base-user>

        <adachi/hardware/i2c>
        <adachi/nixvim/extras/format-on-save>
        <adachi/nixvim/languages/markdown>
        <adachi/nixvim/languages/python>
        <adachi/nixvim/languages/rust>
        <adachi/nixvim/languages/vue>
        (<adachi/services/gpg-agent> true)
        (<adachi/system/greetd-autologin> "uwsm start default")
        (<adachi/tools/autofirma> "Avery")
        <adachi/tools/virtualisation>

        <kasane/desktop/awww>
        <kasane/desktop/caelestia-shell>
        <kasane/desktop/hyprland>
        <kasane/desktop/hyprlock>
        <kasane/desktop/screenshot>
        <kasane/gaming/bottles>
        <kasane/gaming/discord>
        <kasane/gaming/heroic>
        <kasane/gaming/ludusavi>
        <kasane/gaming/mangohud>
        <kasane/gaming/minecraft>
        <kasane/gaming/steam>
        <kasane/services/mullvad-vpn>
        <kasane/services/printing>
        <kasane/theme>
        <kasane/tools/android>
        <kasane/tools/compressed-file-tools>
        <kasane/tools/disk-management>
        <kasane/tools/fastfetch>
        <kasane/tools/filen-desktop>
        <kasane/tools/kitty>
        <kasane/tools/libreoffice>
        <kasane/tools/multimedia>
        <kasane/tools/pcmanfm-qt>
        <kasane/tools/qbittorrent>
        <kasane/web-browsers/firefox>
      ];

      homeManager = {
        services.ludusavi.settings.roots = [
          {
            path = "/mnt/Datos/SteamLibrary";
            store = "steam";
          }
          {
            path = "/mnt/Juegos/steamapps";
            store = "steam";
          }
        ];
      };
    };
  };
}
