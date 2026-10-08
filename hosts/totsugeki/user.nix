{ __findFile, ... }:
{
  hosts.totsugeki.users.avery = {
    includes = [
      <kasane/base-user>

      <adachi/programs/virtualisation>
      <adachi/services/printing>
      (<adachi/system/greetd-autologin> "uwsm start default")

      <kasane/desktop/awww>
      (<kasane/desktop/default-applications/file-manager> "pcmanfm-qt.desktop")
      <kasane/desktop/hyprland>
      <kasane/desktop/hyprlock>
      <kasane/desktop/noctalia>
      <kasane/desktop/screenshot>
      <kasane/gaming/bottles>
      <kasane/gaming/discord>
      <kasane/gaming/heroic>
      <kasane/gaming/ludusavi>
      <kasane/gaming/minecraft>
      <kasane/gaming/steam>
      <kasane/services/syncthing>
      <kasane/programs/android>
      <kasane/programs/autofirma>
      (<kasane/programs/autofirma/firefox-integration> "Avery")
      <kasane/programs/compressed-file-tools>
      <kasane/programs/disk-management>
      <kasane/programs/fastfetch>
      <kasane/programs/kitty>
      <kasane/programs/libreoffice>
      <kasane/programs/multimedia>
      <kasane/programs/obsidian>
      <kasane/programs/pcmanfm-qt>
      <kasane/programs/qbittorrent>
      <kasane/theme>
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
