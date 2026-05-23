{ ... }:
{
  megurine.has._.intel-cpu = {
    nixos =
      { lib, config, ... }:
      {
        hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    provides = {
      kvm.nixos.boot.kernelModules = [ "kvm-intel" ];
    };
  };
}
