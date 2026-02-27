{ inputs, ... }:
{
  flake-file.inputs.nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

  adachi.system._.cachyos-kernel.nixos =
    { pkgs, lib, ... }:
    {
      boot.kernelPackages = lib.mkDefault pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto;
      nix.settings = {
        extra-substituters = [ "https://attic.xuyh0120.win/lantian" ];
        extra-trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
      };
      nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
    };

}
