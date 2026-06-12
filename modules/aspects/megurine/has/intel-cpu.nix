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
              vpl-gpu-rt
            ];
          };
        };
      };
    provides = {
      kvm.nixos.boot.kernelModules = [ "kvm-intel" ];
    };
  };
}
