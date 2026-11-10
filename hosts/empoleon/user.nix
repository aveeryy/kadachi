{ __findFile, ... }: {
  hosts.empoleon.users.avery = {
    includes = [
      <kasane/base-user>

      (<adachi/system/greetd-autologin> "uwsm start default")

      (<kasane/desktop/default-applications/file-manager> "pcmanfm-qt.desktop")
      <kasane/desktop/awww>
      <kasane/desktop/hyprland>
      <kasane/desktop/hyprlock>
      <kasane/desktop/noctalia>
      <kasane/desktop/screenshot>
      <kasane/programs/compressed-file-tools>
      <kasane/programs/disk-management>
      <kasane/programs/kitty>
      <kasane/programs/libreoffice>
      <kasane/programs/multimedia>
      <kasane/programs/pcmanfm-qt>
      <kasane/programs/obsidian>
      <kasane/programs/xh>
      <kasane/theme>
      <kasane/web-browsers/firefox>
    ];
  };
}
