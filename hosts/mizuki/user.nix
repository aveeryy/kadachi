{ __findFile, ... }:
{
  hosts.mizuki.users.avery = {
    includes = [
      <kasane/base-user>

      <adachi/hardware/i2c>
      (<adachi/system/greetd-autologin> "uwsm start default")

      <kasane/desktop/awww>
      <kasane/desktop/hyprland>
      <kasane/desktop/hyprlock>
      <kasane/desktop/noctalia-shell>
      <kasane/desktop/screenshot>
      <kasane/services/syncthing>
      <kasane/theme>
      <kasane/tools/compressed-file-tools>
      <kasane/tools/disk-management>
      <kasane/tools/kitty>
      <kasane/tools/libreoffice>
      <kasane/tools/multimedia>
      <kasane/tools/pcmanfm-qt>
      <kasane/tools/obsidian>
      <kasane/tools/xh>
      <kasane/web-browsers/firefox>
    ];
  };
}
