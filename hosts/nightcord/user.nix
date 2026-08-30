{ __findFile, ... }:
{
  hosts.nightcord.users.avery = {
    includes = [
      <kasane/base-user>
    ];
  };
}
