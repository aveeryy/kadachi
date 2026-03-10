{ __findFile, ... }:
{
  den.hosts.x86_64-linux.greatyamada = {
    services = {
      baseHost = "rcia.dev";
      email = "aveeryy@protonmail.com";
      backups = {
        identifyingIcon = "whale";
        repositories = jobName: [
          {
            path = "ssh://u541128@u541128.your-storagebox.de:23//home/borgmatic/${jobName}/";
            label = "${jobName}@hetzner-de";
          }
        ];
      };
    };
    users.avery.aspect = "avery_greatyamada";
  };

  den.aspects.greatyamada = {
    description = "Home server";

    includes = [
      <megurine/has/amd-cpu>
      <megurine/has/amd-cpu/kvm>
      <megurine/is/server>
      <megurine/requires/secure-boot>

      <adachi/services/podman>

      <kasane/services/acme/desec>
      <kasane/services/adguardhome>
      <kasane/services/backups>
      <kasane/services/database>
      <kasane/services/ddns/desec>
      <kasane/services/fail2ban>
      <kasane/services/forgejo>
      <kasane/services/koito>
      <kasane/services/jellyfin>
      <kasane/services/karakeep>
      <kasane/services/nginx>
      <kasane/services/ntfy-sh>
      <kasane/services/pgadmin>
      <kasane/services/radicale>
      <kasane/services/samba>
      <kasane/services/searxng>
      <kasane/services/vaultwarden>
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
            "xhci_pci"
            "ahci"
            "usbhid"
            "usb_storage"
            "sd_mod"
          ];
          kernelPackages = pkgs.linuxKernel.packages.linux_zen;
        };

        networking = {
          useDHCP = lib.mkForce false;
          interfaces.enp5s0 = {
            ipv4.addresses = [
              {
                address = "10.0.0.1";
                prefixLength = 24;
              }
            ];
          };
          defaultGateway = {
            address = "10.0.0.254";
            interface = "enp5s0";
          };
          nameservers = [
            "9.9.9.9"
            "1.1.1.1"
          ];
        };

        services = {
          forgejo.settings.server.SSH_PORT = 2222;
          nginx.virtualHosts."rcia.dev".locations."/".return = "301 https://git.rcia.dev/Avery";
          postgresql.dataDir = "/mnt/ssd-01/postgresql/${config.services.postgresql.package.psqlSchema}";
          samba.settings = {
            global = {
              "map to guest" = "Bad User";
              "ntlm auth" = "yes"; # Required for PS2
              "server min protocol" = "NT1"; # Required for PS2
              "lanman auth" = "yes"; # Required for POPSLoader
            };
            "PS2" = {
              path = "/mnt/hdd-01/PS2";
              browseable = "yes";
              "guest ok" = "yes";
              comment = "PS2 game share";
            };
          };
        };

        # Run backups hourly
        systemd.timers.borgmatic.timerConfig.OnCalendar = "*-*-* *:00:00";

        time.timeZone = "UTC";
      };
  };
}
