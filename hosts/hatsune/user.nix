{ __findFile, ... }:
{
  hosts.hatsune.users.avery =
    { host, user }:
    {

      includes = [
        <kasane/base-user>
      ];

      nixos = {
        users.users.${user.userName}.extraGroups = [ "disk-write" ];
      };
    };
}
