{ __findFile, lib, ... }:
let
  inherit (lib)
    singleton
    ;
in
{
  den.hosts.x86_64-linux.nightcord = {
    networking = {
      interfaces.enp1s0 = {
        type = "wired";
        dhcp = "yes";
        requiredForOnline = true;
      };

      kadachi-wg = {
        addresses = singleton "10.10.0.3/16";
        publicKey = "N25ds+kKBhgwMAS6HuS1AFKYNWZZ6Sj7CsV05+3o/Tw=";
        # TODO
        # isServerPeer = true;
      };
    };

    services = {
      internetDomain = "nightcord.rcia.dev";
      email = "infra-host-nightcord@rcia.dev";

      acme.aspect = <adachi/services/acme/desec>;

      database.default = "postgres";
    };
    users.avery = { };
  };

  hosts.nightcord = {
    description = "VPS that hosts a mirror of Vaultwarden and Forgejo along some monitoring tools";

    includes = [
      <megurine/is/server>
      <megurine/requires/legacy-boot>

      <adachi/networking/kadachi-wg>
      <adachi/services/forgejo>
      <adachi/services/gatus>
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
