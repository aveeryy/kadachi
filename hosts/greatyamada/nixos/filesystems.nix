{ ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXROOT";
      fsType = "btrfs";
      options = [ "compress=zstd:15" ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
    "/mnt/Datos" = {
      device = "/dev/disk/by-label/Datos";
      fsType = "btrfs";
      options = [ "compress=zstd:15" ];
    };
    "/mnt/Datos/minecraft" = {
      device = "/dev/disk/by-label/Datos";
      fsType = "btrfs";
      options = [ "compress=zstd:4" "subvol=/minecraft" ];
    };
    "/mnt/Datos/music" = {
      device = "/dev/disk/by-label/Datos";
      fsType = "btrfs";
      options = [ "subvol=/music" ];
    };
  };
}
