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
    users.avery.aspect = "avery_malfestio";
  };

  den.aspects.malfestio = {
    includes = [
      <adachi/desktop>
      <adachi/desktop/hyprland>
      <adachi/hardware/amd-cpu>
      <adachi/system/auto-hostname>
      <adachi/system/steam-deck>
      <adachi/system/steam-deck/cachyos-kernel>
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
