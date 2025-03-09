{ ... }: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/144857c7-877b-46c7-94d9-30a6d6d27cf0";
      fsType = "btrfs";
      options = [ "compress=zstd:15" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/590B-73B7";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/4bbd6139-7caa-4617-a94f-b185c5f6ca45";
      fsType = "btrfs";
    };
    "/mnt/Datos" = {
      device = "/dev/disk/by-uuid/4d0a4a15-a962-420a-b641-37afbac65c3a";
      fsType = "btrfs";
      options = [ "user" "x-systemd.automount" "exec" ];
    };
    "/mnt/Windows" = {
      device = "/dev/disk/by-uuid/491E4ED690A84DBB";
      fsType = "ntfs";
      options = [ "nofail" ];
    };
    "/mnt/MHWildsTemp" = {
      device = "/dev/disk/by-uuid/674312a5-9d19-4e06-99ce-1481f3b45acd";
      fsType = "ext4";
    };
  };
}
