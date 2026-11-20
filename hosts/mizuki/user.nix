{ __findFile, ... }:
{
  hosts.mizuki.users.avery = {
    includes = [
      <kasane/base-user>

      (<adachi/system/greetd-autologin> "umbriel")

      (<kasane/desktop/default-applications/file-manager> "pcmanfm-qt.desktop")
      <kasane/desktop/awww>
      <kasane/desktop/hyprlock>
      <kasane/desktop/noctalia>
      <kasane/desktop/screenshot>
      <kasane/services/syncthing>
      <kasane/desktop/umbriel>
      <kasane/programs/compressed-file-tools>
      <kasane/programs/disk-management>
      <kasane/programs/kitty>
      <kasane/programs/libreoffice>
      <kasane/programs/multimedia>
      <kasane/programs/pcmanfm-qt>
      <kasane/programs/obsidian>
      <kasane/programs/xh>
      <kasane/programs/yaak>
      <kasane/theme>
      <kasane/web-browsers/firefox>
    ];
  };
}
