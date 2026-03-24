{ lib, ... }:
{
  megurine.is._.desktop = {
    nixos = {
      security.polkit.enable = lib.mkDefault true;
      services = {
        devmon.enable = lib.mkDefault true;
        gvfs.enable = lib.mkDefault true;
        pipewire = {
          enable = lib.mkDefault true;
          alsa = {
            enable = lib.mkDefault true;
            support32Bit = lib.mkDefault true;
          };
          pulse.enable = lib.mkDefault true;
          extraConfig.pipewire = {
            "10-quantum" = lib.mkDefault {
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
        udisks2.enable = lib.mkDefault true;
      };
    };

    provides.to-users = {
      description = "User configuration for desktop systems";

      homeManager = {
        xdg = {
          enable = lib.mkDefault true;
          userDirs = {
            enable = lib.mkDefault true;
            createDirectories = lib.mkDefault true;
          };
        };
      };
    };
  };
}
