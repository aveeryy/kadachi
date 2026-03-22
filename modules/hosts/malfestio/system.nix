{ __findFile, ... }:
{
  den.hosts.x86_64-linux.malfestio = {
    desktop = {
      displays."eDP-1" = {
        resolution = "800x1280";
        rotation = "270";
      };
      system = {
        hasBattery = true;
        hasBluetooth = true;
        hasWiFi = true;
      };
    };
    users.avery = { };
  };

  den.aspects.malfestio = {
    includes = [
      <megurine/is/steam-deck>
      <megurine/is/steam-deck/cachyos-kernel>

      <adachi/desktop>
      <adachi/desktop/hyprland>
    ];

    nixos = {
      boot.loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };

      i18n = {
        defaultLocale = "es_ES.UTF-8";
        supportedLocales = [
          "C.UTF-8/UTF-8"
          "en_US.UTF-8/UTF-8"
          "es_ES.UTF-8/UTF-8"
        ];
      };

      jovian.steam.desktopSession = "hyprland-uwsm";

      systemd.services.NetworkManager-wait-online.enable = false;

      time.timeZone = "Europe/Madrid";
    };
  };
}
