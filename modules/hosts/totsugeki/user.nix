{ __findFile, ... }:
{
  den.aspects."avery@totsugeki" = {
    includes = [
      <kasane/base-user>

      <adachi/hardware/i2c>
      (<adachi/system/greetd-autologin> "uwsm start default")
      <adachi/tools/autofirma>
      (<adachi/tools/autofirma/firefox-integration> "Avery")
      <adachi/tools/virtualisation>

      <kasane/desktop/awww>
      <kasane/desktop/hyprland>
      <kasane/desktop/hyprlock>
      <kasane/desktop/noctalia-shell>
      <kasane/desktop/screenshot>
      <kasane/gaming/bottles>
      <kasane/gaming/discord>
      <kasane/gaming/heroic>
      <kasane/gaming/ludusavi>
      <kasane/gaming/mangohud>
      <kasane/gaming/minecraft/launcher>
      <kasane/gaming/steam>
      <kasane/services/mullvad-vpn>
      <kasane/services/printing>
      <kasane/theme>
      <kasane/tools/android>
      <kasane/tools/compressed-file-tools>
      <kasane/tools/disk-management>
      <kasane/tools/fastfetch>
      <kasane/tools/filen-desktop>
      <kasane/tools/kitty>
      <kasane/tools/lazydocker>
      <kasane/tools/libreoffice>
      <kasane/tools/multimedia>
      <kasane/tools/pcmanfm-qt>
      <kasane/tools/qbittorrent>
      <kasane/web-browsers/firefox>
    ];

    homeManager = {
      services.ludusavi.settings.roots = [
        {
          path = "/mnt/Datos/SteamLibrary";
          store = "steam";
        }
        {
          path = "/mnt/Juegos/steamapps";
          store = "steam";
        }
      ];
    };
  };
}
