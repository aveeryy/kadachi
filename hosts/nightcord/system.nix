{ __findFile, ... }:
{
  den.hosts.x86_64-linux.nightcord = {
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

      <kasane/services/acme/desec>
      <kasane/services/forgejo>
      <kasane/services/nginx>
      <kasane/services/ntfy-sh>
      <kasane/services/postgresql>
      <kasane/services/vaultwarden>
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

      systemd.network.networks."10-wan" = {
        matchConfig.Name = "enp1s0";
        networkConfig = {
          DHCP = "ipv4";
          IPv6AcceptRA = true;
        };
        linkConfig.RequiredForOnline = "routable";
        # DNS is managed by dnsmasq
        dhcpV4Config.UseDNS = false;
        dhcpV6Config.UseDNS = false;
      };
    };
  };
}
