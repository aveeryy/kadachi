{ ... }: {
  megurine.has.bluetooth = {
    nixos = {
      hardware.bluetooth.enable = true;
    };

    home-manager = {
      services.mpris-proxy.enable = true;
    };
  };
}
