{ ... }:
{
  den.aspects.malfestio.nixos = {
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
    };
  };
}
