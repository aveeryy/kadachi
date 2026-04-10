{ __findFile, ... }:
{
  den.hosts.x86_64-linux.nightcord = {
    services = {
      baseHost = "nightcord.rcia.dev";
      email = "infra-host-nightcord@rcia.dev";
    };
    users.avery = { };
  };

  den.aspects.nightcord = {
    description = "VPS that hosts a mirror of Vaultwarden and Forgejo along some monitoring tools";

    includes = [
      <megurine/is/server>
      <megurine/requires/legacy-boot>

      # <kasane/services/acme/desec>
      # <kasane/services/database>
      # <kasane/services/forgejo>
      # <kasane/services/nginx>
      # <kasane/services/vaultwarden>
    ];

    nixos = {
      boot = {
        loader.grub.device = "/dev/sda";
        initrd.availableKernelModules = [
          "ahci"
          "xhci_pci"
          "virtio_pci"
          "virtio_scsi"
          "sd_mod"
          "sr_mod"
          "ext4"
        ];
      };
    };
  };
}
