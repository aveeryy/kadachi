{ ... }:
{
  megurine.has._.intel-cpu = {
    nixos =
      {
        lib,
        config,
        pkgs,
        ...
      }:
      {
        hardware = {
          cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
          graphics = {
            enable = true;
            extraPackages = with pkgs; [
              intel-media-driver
              vpl-gpu-rt
            ];
          };
        };

        services.thermald.enable = true;
      };

    provides = {
      kvm.nixos.boot.kernelModules = [ "kvm-intel" ];
    };
  };
}
