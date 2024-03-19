{ config, lib, pkgs }: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/61050e8d-41c6-4c37-98a9-d8b0cdce6903";
      fsType = "btrfs";
      options = [ "compress=zstd:15" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/3397-A4FF";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/61050e8d-41c6-4c37-98a9-d8b0cdce6903";
      fsType = "btrfs";
      options = [ "compress=zstd:15" "subvol=/home" ];
    }
    "/mnt/Datos" = {
        device = "/dev/disk/by-uuid/6a5274fc-8ee8-41ae-b7a0-867e5bbc25f4";
        fsType = "btrfs";
        options = [ "compress=zstd:15" ];
    }
    "/mnt/Datos/music" = {
        device = "/dev/disk/by-uuid/6a5274fc-8ee8-41ae-b7a0-867e5bbc25f4";
        fsType = "btrfs";
        options = [ "compress=zstd:15" "subvol=/music" ];
    }
    "/var/www" = {
        device = "/dev/disk/by-uuid/6a5274fc-8ee8-41ae-b7a0-867e5bbc25f4";
        fsType = "btrfs";
        options = [ "compress=zstd:15" "subvol=/html" ];
    }
  };

  networking = {
    firewall = {
        enable = true;
    };
    hostName = "greatyamada";
    networkmanager.enable = true;
    useDHCP = lib.mkDefault false;
  };

  time.timeZone = "UTC";
}
