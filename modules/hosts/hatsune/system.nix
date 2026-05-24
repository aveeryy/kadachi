{ __findFile, self, ... }:
{
  den.hosts.x86_64-linux.hatsune = {
    services = {
      baseDomain = "hatsune.rcia.dev";
      defaultDatabase = "postgres";
      email = "infra-host-hatsune@rcia.dev";
      copyparty.domain = "hatsune.rcia.dev";
      nginx.localServiceConfig = ''
        error_page 403 https://miku.hatsune.rcia.dev;
        allow 10.0.0.0/16;
        allow 10.10.0.0/16;
        deny all;
      '';
    };
    users.avery = { };
  };

  den.aspects.hatsune =
    { host }:
    {
      description = "UGREEN NAS (DXP4800 Pro) system configuration";

      includes = [
        <megurine/has/intel-cpu>
        <megurine/has/intel-cpu/kvm>
        <megurine/is/server>
        <megurine/requires/secure-boot>

        <kasane/services/acme/desec>
        <kasane/services/copyparty>
        <kasane/services/ddns/desec>
        <kasane/services/nginx>
      ];

      nixos =
        { config, ... }:

        let
          commonVolumeFlags = {
            # File system permissions
            chmod_f = "664";
            chmod_d = "775";
            gid = config.users.groups.disk-write.gid;
          };
        in
        {
          boot = {
            extraModprobeConfig = ''
              options it87 force_id=0x8613 ignore_resource_conflict=1
            '';
            extraModulePackages = with config.boot.kernelPackages; [ it87 ];
            initrd.availableKernelModules = [
              "xhci_pci"
              "nvme"
              "ahci"
              "usb_storage"
              "sd_mod"
            ];
            kernelModules = [ "it87" ];
          };

          services = {
            copyparty = {
              settings = {
              };
              volumes = {
                "/disk0" = {
                  path = "/mnt/disk0";
                  access = {
                    rwmda = [ "avery" ];
                  };
                  flags = commonVolumeFlags;
                };
                "/disk1" = {
                  path = "/mnt/disk1";
                  access = {
                    rwmda = [ "avery" ];
                  };
                  flags = commonVolumeFlags;
                };
              };
            };

            nginx.virtualHosts."miku.${host.services.baseDomain}" = {
              locations."= /" = {
                root = "${self}/modules/assets";
                tryFiles = "/migu.webp =404";
              };
              forceSSL = true;
              useACMEHost = host.services.baseDomain;
            };
          };
        };
    };
}
