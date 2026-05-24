{ __findFile, ... }:
{
  den.aspects."avery@hatsune" =
    { host, user }:
    {

      includes = [
        <kasane/base-user>

        <adachi/neovim/extras/format-on-save>
      ];

      nixos = {
        users.users.${user.userName}.extraGroups = [ "disk-write" ];
      };
    };
}
