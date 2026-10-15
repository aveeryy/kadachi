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
        # Temporarily use alternative substituters due to https://github.com/xddxdd/nix-cachyos-kernel/issues/110
        substituters = [ "https://cache.xinux.uz" ];
        trusted-public-keys = [
          "cache.xinux.uz:BXCrtqejFjWzWEB9YuGB7X2MV4ttBur1N8BkwQRdH+0="
        ];
        # extra-substituters = [ "https://attic.xuyh0120.win/lantian" ];
        # extra-trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
      };
    };

}
