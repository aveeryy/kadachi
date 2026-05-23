{ ... }:
{
  den.aspects.hatsune.nixos = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "btrfs";
        options = [
          "compress=zstd"
          "noatime"
        ];
      };
      "/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
      };
      "/mnt/disk0" = {
        device = "/dev/disk/by-label/disk0";
        fsType = "btrfs";
        options = [
          "compress=zstd"
          "noatime"
        ];
      };
      "/mnt/disk1" = {
        device = "/dev/disk/by-label/disk1";
        fsType = "btrfs";
        options = [
          "compress=zstd"
          "noatime"
        ];
      };
    };
  };
}
