{ __findFile, ... }:
{
  den.aspects."avery@hatsune" =
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
