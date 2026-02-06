{ __findFile, ... }:
{
  den.hosts.x86_64-linux.greatyamada = {
    services = {
      baseHost = "rcia.dev";
      email = "aveeryy@protonmail.com";
    };
    users.avery.aspect = "avery_greatyamada";
  };

  den.aspects.greatyamada = {
    description = "Home server";

    includes = [
      <adachi/hardware/amd-cpu>
      <adachi/hardware/amd-cpu/kvm>
      <adachi/services/podman>
      <adachi/system/auto-hostname>
      <adachi/system/secure-boot>

      <kasane/services/acme/cloudflare>
      <kasane/services/adguardhome>
      <kasane/services/database>
      <kasane/services/ddns/cloudflare>
      <kasane/services/fail2ban>
      <kasane/services/forgejo>
      <kasane/services/koito>
      <kasane/services/jellyfin>
      <kasane/services/karakeep>
      <kasane/services/nginx>
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
          postgresql.dataDir = "/mnt/ssd-01/postgresql/${config.services.postgresql.package.psqlSchema}";
          samba.settings = {
            "PS2" = {
              path = "/mnt/hdd-01/PS2";
              browseable = "yes";
              "read only" = "yes";
              "guest ok" = "yes";
              comment = "PS2 game share";
            };
          };
        };

        time.timeZone = "UTC";
      };
  };
}
