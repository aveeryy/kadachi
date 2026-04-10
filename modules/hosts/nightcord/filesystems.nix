{ ... }:
{
  den.aspects.nightcord.nixos = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "ext4";
      };
    };
    swapDevices = [
      {
        device = "/.swapfile";
        size = 4 * 1024;
      }
    ];
  };
}
