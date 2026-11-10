{ ... }:
{
  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

  adachi.system._.cachyos-kernel.nixos =
    {
      pkgs,
      lib,
      inputs',
      ...
    }:
    {
      boot.kernelPackages = lib.mkDefault inputs'.nix-cachyos-kernel.legacyPackages.linuxPackages-cachyos-latest-lto;
      nix.settings = {
        extra-substituters = [ "https://cache.lantian.pub/lantian" ];
        extra-trusted-public-keys = [ "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ=" ];
      };
    };

}
