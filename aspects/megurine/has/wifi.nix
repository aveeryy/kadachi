{ ... }: {
  megurine.has._.wifi = {
    nixos = {
      networking.networkmanager.enable = true;
    };
  };
}
