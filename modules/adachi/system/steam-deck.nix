{ __findFile, inputs, ... }:
{
  flake-file.inputs.jovian-nixos = {
    url = "github:Jovian-Experiments/Jovian-NixOS";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  adachi.system._.steam-deck = {
    nixos =
      { lib, ... }:
      {
        imports = [ inputs.jovian-nixos.nixosModules.default ];

        boot = {
          initrd.availableKernelModules = lib.mkDefault [
            "nvme"
            "xhci_pci"
            "usbhid"
            "sdhci_pci"
          ];
          loader.systemd-boot.consoleMode = "5";
        };

        jovian = {
          devices.steamdeck = {
            enable = true;
            autoUpdate = true;
            enableVendorDrivers = false;
          };
          hardware.has.amd.gpu = true;
          steam = {
            enable = true;
            autoStart = true;
          };
          steamos.useSteamOSConfig = true;
        };

        networking.networkmanager.enable = true;
      };
    provides = {
      cachyos-kernel = {
        includes = [ <adachi/system/cachyos-kernel> ];
        nixos =
          { pkgs, ... }:
          {
            boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-deckify-lto;
          };
      };
    };
  };
}
