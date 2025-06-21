{ ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
    "/mnt/ssd-01" = {
      device = "/dev/disk/by-label/ssd-01";
      fsType = "ext4";
    };
    "/mnt/hdd-01" = {
      device = "/dev/disk/by-label/hdd-01";
      fsType = "ext4";
    };
    "/mnt/hdd-02" = {
      device = "/dev/disk/by-label/hdd-02";
      fsType = "ext4";
    };
  };
  swapDevices = [{
    device = "/.swapfile";
    size = 4 * 1024;
  }];
}
