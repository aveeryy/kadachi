{ ... }:
{
  megurine.has._.amd-cpu = {
    nixos =
      { lib, config, ... }:
      {
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      };
    provides = {
      kvm.nixos.boot.kernelModules = [ "kvm-amd" ];
    };
  };
}
