{ __findFile, ... }:
{
  den.hosts.x86_64-linux.hatsune = {
    services = {
      baseDomain = "hatsune.rcia.dev";
      defaultDatabase = "postgres";
      email = "infra-host-hatsune@rcia.dev";
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
    ];

    nixos = {
      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "nvme"
        "ahci"
        "usb_storage"
        "sd_mod"
      ];
    };
  };
}
