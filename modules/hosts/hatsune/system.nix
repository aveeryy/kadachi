{ __findFile, ... }:
{
  den.hosts.x86_64-linux.hatsune = {
    services = {
      baseDomain = "hatsune.rcia.dev";
      defaultDatabase = "postgres";
      email = "infra-host-hatsune@rcia.dev";
      copyparty.domain = "hatsune.rcia.dev";
    };
    users.avery = { };
  };

  den.aspects.hatsune = {
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

        services.copyparty = {
          settings = {
            e2dsa = true;
          };
          volumes = {
            "/disk0" = {
              path = "/mnt/disk0";
              access = {
                rwmda = [ "avery" ];
              };
            };
            "/disk1" = {
              path = "/mnt/disk1";
              access = {
                rwmda = [ "avery" ];
              };
            };
          };
        };
      };
  };
}
