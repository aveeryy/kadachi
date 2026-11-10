{ ... }: {
  hosts.empoleon.nixos = {

    fileSystems = {
      "/" = {
        device = "/dev/mapper/enc";
        fsType = "btrfs";
        options = [
          "compress=zstd"
          "noatime"
        ];
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/B34B-464D";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };
    };

    boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/8a1df880-0c0e-4c68-8c51-73ae4e2d7183";

    swapDevices = [
      { device = "/dev/disk/by-uuid/e4ea6f8b-9880-4e03-b106-c5f740fa3a04"; }
    ];
  };
}
