{ ... }:
{
  adachi.desktop = {
    nixos =
      { pkgs, ... }:
      {
        security.polkit.enable = true;
        services = {
          devmon.enable = true;
          gvfs.enable = true;
          pipewire = {
            enable = true;
            alsa = {
              enable = true;
              support32Bit = true;
            };
            pulse.enable = true;
            extraConfig.pipewire = {
              "10-quantum" = {
                "default.clock.allowed-rates" = [
                  44100
                  48000
                  96000
                ];
                "default.clock.quantum" = 32;
                "default.clock.min-quantum" = 32;
                "default.clock.max-quantum" = 1024;
              };
            };
          };
          udisks2.enable = true;
        };
      };
    homeManager.xdg.enable = true;
  };
}
