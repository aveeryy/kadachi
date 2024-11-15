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
    };
    #"/mnt/Datos" = {
    #  device = "/dev/disk/by-uuid/eb3b01e9-556f-4c9d-aa99-5495c1bc51e1";
    #  fsType = "btrfs";
    #  options = [ "user" "x-systemd.automount" "exec" ];
    #};
    "/mnt/Windows" = {
      device = "/dev/disk/by-uuid/E290A87190A84DBB";
      fsType = "ntfs";
      options = [ "nofail" ];
    };
    #"/mnt/Windows-Datos" = {
    #  device = "/dev/disk/by-uuid/1E58C48458C45BE1";
    #  fsType = "ntfs";
    #  options = [ "nofail" ];
    #};
  };
}
