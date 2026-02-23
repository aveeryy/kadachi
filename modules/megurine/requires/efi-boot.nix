{ lib, ... }:
{
  megurine.requires._.efi-boot.nixos = {
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = lib.mkDefault 5;
    };
  };
}
