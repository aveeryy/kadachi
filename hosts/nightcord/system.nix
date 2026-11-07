{ __findFile, ... }:
{
  den.hosts.x86_64-linux.nightcord = {
    networking = {
      interfaces.enp1s0 = {
        type = "wired";
        dhcp = "yes";
        requiredForOnline = true;
      };
    };

    services = {
      internetDomain = "nightcord.rcia.dev";
      email = "infra-host-nightcord@rcia.dev";

      database.default = "postgres";
    };
    users.avery = { };
  };

  hosts.nightcord = {
    description = "VPS that hosts a mirror of Vaultwarden and Forgejo along some monitoring tools";

    includes = [
      <megurine/is/server>
      <megurine/requires/legacy-boot>

      <adachi/services/acme/host/desec>
      <adachi/services/forgejo>
      <adachi/services/nginx>
      <adachi/services/ntfy-sh>
      <adachi/services/postgresql>
      <adachi/services/vaultwarden>
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
