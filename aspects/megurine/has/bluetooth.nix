{ ... }: {
  megurine.has.bluetooth = {
    nixos = {
      hardware.bluetooth.enable = true;
    };
  };
}
