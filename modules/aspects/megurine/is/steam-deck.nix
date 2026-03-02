{ __findFile, inputs, ... }:
{
  flake-file.inputs.jovian-nixos = {
    url = "github:Jovian-Experiments/Jovian-NixOS";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  megurine.is._.steam-deck = {
    description = ''
      Aspect for the Steam Deck that uses Jovian-NixOS to provide a SteamOS-like experience.

      Already includes all of the required <megurine/has/...> aspects
    '';

    includes = [
      <megurine/has/amd-cpu>
      <megurine/requires/efi-boot>
    ];

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

        services.displayManager.sddm.wayland.enable = true;
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
