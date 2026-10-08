{
  __findFile,
  kadachi-lib,
  lib,
  ...
}:
let
  inherit (lib)
    singleton
    ;

  inherit (kadachi-lib)
    constants
    ;
in
{
  den.hosts.x86_64-linux.greatyamada = {
    services = {
      internetDomain = "rcia.dev";
      email = "infra-host-greatyamada@rcia.dev";

      database.default = "postgres";

      backups = {
        identifyingIcon = "whale";
        repositories = jobName: [
          {
            path = "ssh://u541128@u541128.your-storagebox.de:23//home/borgmatic/${jobName}/";
            label = "${jobName}@hetzner-de";
          }
        ];
      };

      adguardhome.allowedInternetAddresses = with constants.networks; [
        local
        kadachi-wg
      ];

      pgadmin.allowedInternetAddresses = with constants.networks; [
        local
        kadachi-wg
      ];

      radicale.allowedInternetAddresses = with constants.networks; [
        local
        kadachi-wg
      ];

      vaultwarden.allowedInternetAddresses = with constants.networks; [
        local
        kadachi-wg
      ];

      wireguard = {
        addresses = [ "10.10.0.1/16" ];
        publicKey = "xhPfEY8deFqQCESimFRzKFqxJ3LJM5uwUgVK4MFkjiM=";
        isServerPeer = true;
        allowInternetAccess = true;
        internetInterface = "enp5s0";
      };
    };

    users.avery = { };
  };

  hosts.greatyamada = {
    description = "Home server";

    includes = [
      <megurine/has/amd-cpu>
      <megurine/has/amd-cpu/kvm>
      <megurine/is/server>
      <megurine/requires/secure-boot>

      <adachi/services/acme/host/desec>
      <adachi/services/adguardhome>
      <adachi/services/backups>
      <adachi/services/ddns/host/desec>
      <adachi/services/fail2ban>
      <adachi/services/forgejo>
      <adachi/services/koito>
      <adachi/services/karakeep>
      <adachi/services/minecraft-server>
      <adachi/services/minecraft-server/bccg-2026>
      <adachi/services/minecraft-server/vc-test>
      <adachi/services/nginx>
      <adachi/services/ntfy-sh>
      <adachi/services/pgadmin>
      <adachi/services/podman>
      <adachi/services/postgresql>
      <adachi/services/radicale>
      <adachi/services/samba>
      <adachi/services/vaultwarden>
      <adachi/services/wireguard>
    ];

    nixos =
      {
        config,
        pkgs,
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

        security.acme.certs."rcia.dev".extraDomainNames = [
          # This one is needed, since the ACME aspect sets `extraDomainNames` as mkDefault
          "*.rcia.dev"
          "*.hatsune.rcia.dev"
        ];

        services = {
          dnsmasq.settings.server = [
            "9.9.9.9"
            "1.1.1.1"
          ];
          forgejo.settings.server.SSH_PORT = 2222;
          minecraft-servers.dataDir = "/mnt/ssd-01/minecraft";
          nginx.virtualHosts = {
            "rcia.dev".locations."/".return = "307 https://git.rcia.dev/Avery";

            "hatsune.rcia.dev" = {
              # TODO: maybe use Wireguard?
              locations."/".proxyPass = "https://10.0.0.2$request_uri";
              forceSSL = true;
              useACMEHost = "rcia.dev";
              serverAliases = [ "*.hatsune.rcia.dev" ];
              extraConfig = ''
                client_max_body_size 1G;
              '';
            };
          };
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

        systemd = {
          network.networks."10-wan" = {
            matchConfig.Name = "enp5s0";
            address = singleton "10.0.0.1/16";
            routes = singleton { Gateway = "10.0.255.254"; };
            linkConfig.RequiredForOnline = "routable";
          };

          # Run backups hourly
          timers.borgmatic.timerConfig.OnCalendar = "*-*-* *:00:00";
        };
      };
  };
}
