{ __findFile, ... }:
{
  den.hosts.x86_64-linux.malfestio = {
    desktop = {
      displays."eDP-1" = {
        resolution = "800x1280@60";
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

  den.aspects = {
    malfestio = {
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
    avery_malfestio = {
      includes =
        let
          steam_user =
            { user, ... }:
            {
              nixos.jovian.steam.user = user.userName;
            };
        in
        [
          <kasane/base-user>

          <kasane/desktop/awww>
          <kasane/desktop/caelestia-shell>
          <kasane/desktop/hyprland>
          <kasane/gaming/discord>
          <kasane/theme>
          <kasane/tools/compressed-file-tools>
          <kasane/tools/kitty>
          <kasane/tools/pcmanfm-qt>
          <kasane/web-browsers/firefox>

          steam_user
        ];

      homeManager =
        { lib, ... }:
        {
          # Avoid launching caelestia on Steam gamescope session
          programs.caelestia.systemd.target = lib.mkForce "wayland-session@hyprland.desktop.target";
          wayland.windowManager.hyprland.settings = {
            exec-once = lib.mkOrder 10 [
              "[workspace 10 silent] steam"
            ];
            windowrule = [ "match:class steam, workspace 10 silent" ];
          };
        };
    };
  };
}
