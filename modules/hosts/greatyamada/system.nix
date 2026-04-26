{ __findFile, ... }:
{
  den.hosts.x86_64-linux.greatyamada = {
    services = {
      baseDomain = "rcia.dev";
      defaultDatabase = "postgres";
      email = "infra-host-greatyamada@rcia.dev";
      backups = {
        identifyingIcon = "whale";
        repositories = jobName: [
          {
            path = "ssh://u541128@u541128.your-storagebox.de:23//home/borgmatic/${jobName}/";
            label = "${jobName}@hetzner-de";
          }
        ];
      };
      wireguard = {
        peerEnabled = true;
        addresses = [ "10.10.0.1/16" ];
        publicKey = "xhPfEY8deFqQCESimFRzKFqxJ3LJM5uwUgVK4MFkjiM=";
        isServerPeer = true;
        allowInternetAccess = true;
        internetInterface = "enp5s0";
      };
    };
    users.avery = { };
  };

  den.aspects.greatyamada = {
    description = "Home server";

    includes = [
      <megurine/has/amd-cpu>
      <megurine/has/amd-cpu/kvm>
      <megurine/is/server>
      <megurine/requires/secure-boot>

      <adachi/services/podman>
      <kasane/gaming/minecraft/server>
      <kasane/services/acme/desec>
      <kasane/services/adguardhome>
      <kasane/services/backups>
      <kasane/services/ddns/desec>
      <kasane/services/fail2ban>
      <kasane/services/forgejo>
      <kasane/services/koito>
      <kasane/services/jellyfin>
      <kasane/services/karakeep>
      <kasane/services/nginx>
      <kasane/services/ntfy-sh>
      <kasane/services/pgadmin>
      <kasane/services/postgresql>
      <kasane/services/radicale>
      <kasane/services/samba>
      <kasane/services/vaultwarden>
      <kasane/services/wireguard>
    ];

    nixos =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        boot.initrd.availableKernelModules = [
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "sd_mod"
        ];

        networking = {
          useDHCP = lib.mkForce false;
          interfaces.enp5s0 = {
            ipv4.addresses = [
              {
                address = "10.0.0.1";
                prefixLength = 16;
              }
            ];
          };
          defaultGateway = {
            address = "10.0.255.254";
            interface = "enp5s0";
          };
          nameservers = [
            "9.9.9.9"
            "1.1.1.1"
          ];
        };

        services = {
          forgejo.settings.server.SSH_PORT = 2222;
          minecraft-servers.dataDir = "/mnt/ssd-01/minecraft";
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
