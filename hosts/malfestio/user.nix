{ __findFile, ... }:
{
  hosts.malfestio.users.avery = {
    includes = [
      <kasane/base-user>

      <kasane/desktop/awww>
      <kasane/gaming/discord>
      <kasane/theme>
      <kasane/programs/compressed-file-tools>
      <kasane/programs/kitty>
      <kasane/programs/pcmanfm-qt>
      <kasane/web-browsers/firefox>
    ];
  };
}
