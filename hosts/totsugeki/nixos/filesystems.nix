{ ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/144857c7-877b-46c7-94d9-30a6d6d27cf0";
      fsType = "btrfs";
      options = [ "compress=zstd:15" ];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/8084-F762";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/4bbd6139-7caa-4617-a94f-b185c5f6ca45";
      fsType = "btrfs";
      options = [ "compress=zstd:15" ];
    };

    "/mnt/Datos" = {
      device = "/dev/disk/by-uuid/994ef2bd-a9fb-4414-9a0a-19b150ffa452";
      fsType = "btrfs";
      options = [ "compress=zstd:15" "user" "x-systemd.automount" "exec" ];
    };
  };
}
