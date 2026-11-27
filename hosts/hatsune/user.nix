{ __findFile, ... }:
{
  hosts.hatsune.users.avery =
    { host, user }:
    {

      includes = [
        <kasane/base-user>
        # For note syncing
        <kasane/programs/obsidian>
        <kasane/programs/syncthing>
      ];

      nixos = {
        users.users.${user.userName}.extraGroups = [ "disk-write" ];
      };
    };
}
