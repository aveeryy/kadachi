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
        extra-substituters = [ "https://attic.xuyh0120.win/lantian" ];
        extra-trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
      };
    };

}
