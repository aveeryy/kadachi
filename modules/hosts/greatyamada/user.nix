{ __findFile, ... }:
{
  den.aspects."avery@greatyamada" =
    let
      media_group_member =
        { user, ... }:
        {
          nixos.users.groups.media.members = [ user.userName ];
        };
    in
    {

      includes = [
        <kasane/base-user>

        <adachi/neovim/extras/format-on-save>
        (<adachi/services/gpg-agent> false)

        media_group_member
      ];
    };
}
