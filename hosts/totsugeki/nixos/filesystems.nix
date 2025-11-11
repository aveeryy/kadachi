{ ... }:
{
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
      options = [
        "user"
        "x-systemd.automount"
        "exec"
        "x-gvfs-show"
      ];
    };
    "/mnt/Juegos" = {
      device = "/dev/disk/by-uuid/2a474d7c-0a0f-423a-b892-98be45903073";
      fsType = "btrfs";
      options = [
        "nofail"
        "x-gvfs-show"
      ];
    };
  };
}
