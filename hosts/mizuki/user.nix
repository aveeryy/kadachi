{ __findFile, ... }:
{
  hosts.mizuki.users.avery = {
    includes = [
      <kasane/base-user>

      (<adachi/system/greetd-autologin> "uwsm start default")

      (<kasane/desktop/default-applications/file-manager> "pcmanfm-qt.desktop")
      <kasane/programs/autofirma>
      <kasane/desktop/awww>
      <kasane/desktop/hyprland>
      <kasane/desktop/hyprlock>
      <kasane/desktop/noctalia>
      <kasane/desktop/screenshot>
      <kasane/services/syncthing>
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

    homeManager = {
      wayland.windowManager.hyprland.settings.input.sensitivity = -0.3;
    };
  };
}
